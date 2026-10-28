extends Node

var signature: Dictionary = {
	"type": "",
	"body": {
		"command": ""
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
	
	
	t.run()
