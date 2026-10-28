extends Node

var signature: Dictionary = {
	"type": "",
	"body": {
		"command": ""
	}
}

var signature_deep: Dictionary = {
	"body": {
		"data": {
			"value": 0
		}
	}
}

func test_baseline() -> bool:
	var message: Dictionary = {
		"type": "command",
		"body": {
			"command": "MOVE_PLAN"
			}
		}
	var result: bool = Message.validate_message_signature(message, signature)
	return result == true

func test_key_typo() -> bool:
	var message: Dictionary = {
		"tpe": "command",
		"body": {
			"command": "MOVE_PLAN"
		}
	}
	var result: bool = Message.validate_message_signature(message, signature)
	return result == false
	
func test_missing_key() -> bool:
	var message: Dictionary = {
	"type": "command",
	}
	
	var result: bool = Message.validate_message_signature(message, signature)
	return result == false

func test_missing_nested_key() -> bool:
	var message: Dictionary = {
	"type": "command",
	"body": {
		}
	}
	var result: bool = Message.validate_message_signature(message, signature)
	return result == false

func test_invalid_key_type() -> bool:
	var message: Dictionary = {
	"type": "command",
	17 : {
		"command": "MOVE_PLAN"
		}
	}
	var result: bool = Message.validate_message_signature(message, signature)
	return result == false

func test_invalid_nested_key_type() -> bool:
	var message: Dictionary = {
	"type": "command",
	"body" : {
		34.0: "MOVE_PLAN"
		}
	}
	var result: bool = Message.validate_message_signature(message, signature)
	return result == false


func test_invalid_value_type() -> bool: 
	var message: Dictionary = {
	"type": 3,
	"body": {
		"command": ""
		}
	}
	var result: bool = Message.validate_message_signature(message, signature)
	return result == false

func test_invalid_nested_value_type() -> bool: 
	var message: Dictionary = {
	"type": "command",
	"body": {
		"command": Test
		}
	}
	var result: bool = Message.validate_message_signature(message, signature)
	return result == false
	

	
func test_extra_keys() -> bool:
	var message: Dictionary = {
	"type": "command",
	"body": {
		"command": "MOVE_PLAN"
		},
	"code": "THIS_SHOULD_RESTURN FALSE"
	}
	var result: bool = Message.validate_message_signature(message, signature)
	return result == false

func test_nested_extra_key() -> bool:
	var message: Dictionary = {
	"type": "command",
	"body": {
		"command": "MOVE_PLAN",
		"oops": "THIS SHOULD NOT BE HERE"
		}
	}
	var result: bool = Message.validate_message_signature(message, signature)
	return result == false

func test_deeply_nested_invalid_type() -> bool:
	var message: Dictionary = {
		"body": {
			"data": {
				"value": "invalid"
			}
		}
	}
	return not Message.validate_message_signature(message, signature_deep)

func test_empty_message() -> bool:
	var message: Dictionary = {}
	return not Message.validate_message_signature(message, signature)

func test_null_body() -> bool:
	var message: Dictionary = {
		"type": "command",
		"body": null
	}
	return not Message.validate_message_signature(message, signature)
	
func test_array_instead_of_body() -> bool:
	var message: Dictionary = {
		"type": "command",
		"body": []
	}
	return not Message.validate_message_signature(message, signature)

func test_string_instead_of_body() -> bool:
	var message: Dictionary = {
		"type": "comand",
		"body": "MOVE_COMMAND"
	}
	return not Message.validate_message_signature(message, signature)

func test_empty_string_in_message() -> bool:
	var signature2: Dictionary = {
		"type": "IT SHOULD BE VALID EVEN IF I WRITE SOMETHING HERE"
	}
	var message: Dictionary = {
		"type": ""
	}
	return Message.validate_message_signature(message, signature2)
	
func test_dictionary_instead_of_string() -> bool:
	var message: Dictionary = {
		"type": {},
		"body": {
			"command": ""
		}
	}
	return not Message.validate_message_signature(message, signature)
	
func test_invalid_value_after_nested_dictionary() -> bool:
	var message: Dictionary = {
		"body": {
		"command": "MOVE_PLAN"
	},
		"type": 123
	}

	return not Message.validate_message_signature(message, signature)

func _ready() -> void:
	var t := Test.new("Message Signature Validation")
	
	t.add(test_baseline)
	
	t.add(test_extra_keys)
	t.add(test_nested_extra_key)
	
	t.add(test_invalid_key_type)
	t.add(test_invalid_nested_key_type)
	
	t.add(test_invalid_value_type)
	t.add(test_invalid_nested_value_type)
	t.add(test_key_typo)
	
	t.add(test_missing_key)
	t.add(test_missing_nested_key)
	
	t.add(test_deeply_nested_invalid_type)
	t.add(test_empty_message)
	t.add(test_null_body)
	t.add(test_array_instead_of_body)
	t.add(test_string_instead_of_body)
	t.add(test_empty_string_in_message)
	t.add(test_dictionary_instead_of_string)
	t.add(test_invalid_value_after_nested_dictionary)
	
	
	t.run()
