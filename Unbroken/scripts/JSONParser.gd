extends Node

#Files need to be placed in the 'res://assets/data/' to be read correctly
export(String) var file_name = ""

var passages: Array = []

var _parsed_json_object: Dictionary = {}

func _ready():
	#Load JSON into Dictionary
	_parsed_json_object = _load_json(file_name)
	
	#Check if JSON was empty
	if _parsed_json_object.empty():
		printerr("Failed to convert (JSON -> Passage) due to JSON being empty.")
		pass
	
	#Verify Twine JSON and convert to Passages
	if _verify_twine(_parsed_json_object):
		_to_passages(_parsed_json_object)

func _load_json(name: String) -> Dictionary:
	#Read file
	var file: File = File.new()
	var err = file.open("res://assets/data/" + name, File.READ)
	if not err == OK:
		printerr("Failed to read JSON file <" + name + ">.")
		printerr("Error Code: "+ String(file.get_error()))
		return {}
	
	#Parse file to JSON
	var content: JSONParseResult = JSON.parse(file.get_as_text())
	if not content.error == OK:
		printerr("Failed to parse JSON file <" + name + ">.")
		printerr(content.error_string)
		printerr("Error found @ line number: " + String(content.error_line))
		return {}
	
	#Close file
	file.close()
	return content.result

func _verify_twine(json: Dictionary) -> bool:
	var key: String = "creator"
	if json.has(key):
		if json.get(key) == "Twine":
			return true
	printerr("JSON file not created by Twinery.")
	printerr("Make sure to follow instructions from: ")
	printerr("<https://github.com/lazerwalker/twison#twison> to create file.")
	return false

func _to_passages(json: Dictionary):
	var psgs: Array = json.get("passages")
	
	#For each passage create an entry into the passages
	for psg in psgs:
		var entry: Passage = Passage.new()
		entry.text = _strip_links_from_text(psg.get("text"))
		entry.pid = psg.get("pid")
		#Last passage does not have a link to another passage
		if psg.has("links"):
			for lnk in psg.get("links"):
				var link_entry = PassageLink.new()
				link_entry.text = lnk.name
				link_entry.pid = lnk.pid
				entry.links.append(link_entry)
		
		passages.append(entry)

func _strip_links_from_text(text: String) -> String:
	var start_index = text.find("[[")
	var clip = text.substr(start_index)
	return text.rstrip(clip)
