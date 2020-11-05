extends Control

onready var _passages: Array = $JSONParser.passages
onready var _dialogue: Label = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/Label
onready var _continue_btn = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/Option4/ContinueBtn
onready var _option1_btn = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/Option1/Option1_Btn
onready var _option2_btn = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/Option2/Option2_Btn
onready var _option3_btn = $MarginContainer/ColorRect/MarginContainer/VBoxContainer/HBoxContainer/Option3/Option3_Btn
var _current_passages_index: int = 0

func _ready():
	_change_dialogue(_current_passages_index)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		_on_ContinueBtn_pressed()
	if event.is_action_pressed("ui_option_1"):
		_on_Option1_Btn_pressed()
	if event.is_action_pressed("ui_option_2"):
		_on_Option1_Btn_pressed()
	if event.is_action_pressed("ui_option_3"):
		_on_Option3_Btn_pressed()

func _on_ContinueBtn_pressed():
	var current_passage: Passage = _passages[_current_passages_index]
	var next_passage_pid: int = current_passage.links[0].pid
	var index: int = 0
	
	for psg in _passages:
		if psg.pid == next_passage_pid:
			_change_dialogue(index)
			pass
		index += 1
		
func _change_dialogue(index: int):
	
	if _dialogue.get_node("AnimationPlayer").is_playing():
		_skip_typewriter_animation()
		return
	else:
		_typewriter_animation()
		
	_dialogue.text = _passages[index].text
	
	match _passages[index].links.size():
		1:
			_continue_btn.text = _passages[index].links[0].text
			_option1_btn.text = ""
			_option2_btn.text = ""
			_option3_btn.text = ""
			_continue_btn.disabled = false
			_option1_btn.disabled = true
			_option2_btn.disabled = true
			_option3_btn.disabled = true
			_continue_btn.get_parent().get_node("AnimationPlayer").play("enabled")
			_option1_btn.get_parent().get_node("AnimationPlayer").stop()
			_option2_btn.get_parent().get_node("AnimationPlayer").stop()
			_option3_btn.get_parent().get_node("AnimationPlayer").stop()
		2:
			_option1_btn.text = _passages[index].links[0].text
			_option2_btn.text = _passages[index].links[1].text
			_option3_btn.text = ""
			_continue_btn.disabled = true
			_option1_btn.disabled = false
			_option2_btn.disabled = false
			_option3_btn.disabled = true
			_continue_btn.get_parent().get_node("AnimationPlayer").stop()
			_option1_btn.get_parent().get_node("AnimationPlayer").play("enabled")
			_option2_btn.get_parent().get_node("AnimationPlayer").play("enabled")
			_option3_btn.get_parent().get_node("AnimationPlayer").stop()
		3:
			_option1_btn.text = _passages[index].links[0].text
			_option2_btn.text = _passages[index].links[1].text
			_option3_btn.text = _passages[index].links[2].text
			_continue_btn.disabled = true
			_option1_btn.disabled = false
			_option2_btn.disabled = false
			_option3_btn.disabled = false
			_continue_btn.get_parent().get_node("AnimationPlayer").stop()
			_option1_btn.get_parent().get_node("AnimationPlayer").play("enabled")
			_option2_btn.get_parent().get_node("AnimationPlayer").play("enabled")
			_option3_btn.get_parent().get_node("AnimationPlayer").play("enabled")
		4:
			_option1_btn.text = _passages[index].links[0].text
			_option2_btn.text = _passages[index].links[1].text
			_option3_btn.text = _passages[index].links[2].text
			_continue_btn.text = _passages[index].links[3].text
			_continue_btn.disabled = false
			_option1_btn.disabled = false
			_option2_btn.disabled = false
			_option3_btn.disabled = false
			_continue_btn.get_parent().get_node("AnimationPlayer").play("enabled")
			_option1_btn.get_parent().get_node("AnimationPlayer").play("enabled")
			_option2_btn.get_parent().get_node("AnimationPlayer").play("enabled")
			_option3_btn.get_parent().get_node("AnimationPlayer").play("enabled")
			
	_current_passages_index = index

func _on_Option1_Btn_pressed():
	var current_passage: Passage = _passages[_current_passages_index]
	var next_passage_pid: int = current_passage.links[0].pid
	var index: int = 0
	
	for psg in _passages:
		if psg.pid == next_passage_pid:
			_change_dialogue(index)
			pass
		index += 1

func _on_Option2_Btn_pressed():
	var current_passage: Passage = _passages[_current_passages_index]
	var next_passage_pid: int = current_passage.links[1].pid
	var index: int = 0
	
	for psg in _passages:
		if psg.pid == next_passage_pid:
			_change_dialogue(index)
			pass
		index += 1

func _on_Option3_Btn_pressed():
	var current_passage: Passage = _passages[_current_passages_index]
	var next_passage_pid: int = current_passage.links[2].pid
	var index: int = 0
	
	for psg in _passages:
		if psg.pid == next_passage_pid:
			_change_dialogue(index)
			pass
		index += 1

func _typewriter_animation():
	if _dialogue.text.length() < 250:
		_dialogue.get_node("AnimationPlayer").seek(0.0)
		_dialogue.get_node("AnimationPlayer").play("typewriter",-1,4.0)
		_dialogue.get_node("AudioStreamPlayer").play()
		_pause(true, true)
		yield(_dialogue.get_node("AnimationPlayer"), "animation_finished")
		_pause()
		_dialogue.get_node("AudioStreamPlayer").stop()
	else:
		_dialogue.get_node("AnimationPlayer").seek(0.0)
		_dialogue.get_node("AnimationPlayer").play("typewriter")
		_dialogue.get_node("AudioStreamPlayer").play()
		_pause(true, true)
		yield(_dialogue.get_node("AnimationPlayer"), "animation_finished")
		_pause()
		_dialogue.get_node("AudioStreamPlayer").stop()

func _skip_typewriter_animation():
	var anim = _dialogue.get_node("AnimationPlayer")
	var anim_time = anim.get_animation("typewriter").length
	_dialogue.get_node("AnimationPlayer").seek(anim_time, true)
	_dialogue.get_node("AudioStreamPlayer").stop()
	
func _pause(process: bool = false, physics: bool = false, input: bool = false):
	set_process(process)
	set_physics_process(physics)
	set_process_input(input)
