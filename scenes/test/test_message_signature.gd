extends Node

func value_to_JSON_to_value(value: Dictionary) -> Dictionary:
	var packet: PackedByteArray = JSON.stringify(value).to_utf8_buffer()
	return JSON.parse_string(packet.get_string_from_utf8())
	
func value_to_bytes_to_value(value: Dictionary) -> Dictionary:
	var bytes: PackedByteArray = var_to_bytes(value)
	return bytes_to_var(bytes)

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
	var result: bool = Message.validate_shape(message, signature)
	return result == true

func test_key_typo() -> bool:
	var message: Dictionary = {
		"tpe": "command",
		"body": {
			"command": "MOVE_PLAN"
		}
	}
	var result: bool = Message.validate_shape(message, signature)
	return result == false
	
func test_missing_key() -> bool:
	var message: Dictionary = {
	"type": "command",
	}
	
	var result: bool = Message.validate_shape(message, signature)
	return result == false

func test_missing_nested_key() -> bool:
	var message: Dictionary = {
	"type": "command",
	"body": {
		}
	}
	var result: bool = Message.validate_shape(message, signature)
	return result == false

func test_invalid_key_type() -> bool:
	var message: Dictionary = {
	"type": "command",
	17 : {
		"command": "MOVE_PLAN"
		}
	}
	var result: bool = Message.validate_shape(message, signature)
	return result == false

func test_invalid_nested_key_type() -> bool:
	var message: Dictionary = {
	"type": "command",
	"body" : {
		34.0: "MOVE_PLAN"
		}
	}
	var result: bool = Message.validate_shape(message, signature)
	return result == false


func test_invalid_value_type() -> bool: 
	var message: Dictionary = {
	"type": 3,
	"body": {
		"command": ""
		}
	}
	var result: bool = Message.validate_shape(message, signature)
	return result == false

func test_invalid_nested_value_type() -> bool: 
	var message: Dictionary = {
	"type": "command",
	"body": {
		"command": Test
		}
	}
	var result: bool = Message.validate_shape(message, signature)
	return result == false
	

	
func test_extra_keys() -> bool:
	var message: Dictionary = {
	"type": "command",
	"body": {
		"command": "MOVE_PLAN"
		},
	"code": "THIS_SHOULD_RESTURN FALSE"
	}
	var result: bool = Message.validate_shape(message, signature)
	return result == false

func test_nested_extra_key() -> bool:
	var message: Dictionary = {
	"type": "command",
	"body": {
		"command": "MOVE_PLAN",
		"oops": "THIS SHOULD NOT BE HERE"
		}
	}
	var result: bool = Message.validate_shape(message, signature)
	return result == false

func test_deeply_nested_invalid_type() -> bool:
	var message: Dictionary = {
		"body": {
			"data": {
				"value": "invalid"
			}
		}
	}
	return not Message.validate_shape(message, signature_deep)

func test_empty_message() -> bool:
	var message: Dictionary = {}
	return not Message.validate_shape(message, signature)

func test_null_body() -> bool:
	var message: Dictionary = {
		"type": "command",
		"body": null
	}
	return not Message.validate_shape(message, signature)
	
func test_array_instead_of_body() -> bool:
	var message: Dictionary = {
		"type": "command",
		"body": []
	}
	return not Message.validate_shape(message, signature)

func test_string_instead_of_body() -> bool:
	var message: Dictionary = {
		"type": "comand",
		"body": "MOVE_COMMAND"
	}
	return not Message.validate_shape(message, signature)

func test_empty_string_in_message() -> bool:
	var small_signature: Dictionary = {
		"type": "IT SHOULD BE VALID EVEN IF I WRITE SOMETHING HERE"
	}
	var message: Dictionary = {
		"type": ""
	}
	return Message.validate_shape(message, small_signature)
	
func test_dictionary_instead_of_string() -> bool:
	var message: Dictionary = {
		"type": {},
		"body": {
			"command": ""
		}
	}
	return not Message.validate_shape(message, signature)
	
func test_invalid_value_after_nested_dictionary() -> bool:
	var message: Dictionary = {
		"body": {
		"command": "MOVE_PLAN"
	},
		"type": 123
	}

	return not Message.validate_shape(message, signature)
	
func test_array_of_different_type() -> bool:
	var array_signature: Dictionary = {
		"array": [0]
	}
	var message: Dictionary = {
		"array": [3.4, 4,6]
	}
	return not Message.validate_shape(message,array_signature)


func test_empty_signature_array() -> bool:
	var array_signature: Dictionary = {
		"array": []
	}
	var message: Dictionary = {
		"array": [3.4, 4.4]
	}
	return not Message.validate_shape(message, array_signature)

func test_array_same_type() -> bool:
	var array_signature: Dictionary = {
		"array": [3]
	}
	var message: Dictionary = {
		"array": [4, 2]
	}
	return Message.validate_shape(message, array_signature)
	
func test_baseline_serialize_JSON_and_back() -> bool:
	var message: Dictionary = {
		"type": "command",
		"body": {
			"command": "MOVE_PLAN",
			"players": [4, 1, 2]
		}
	}
	var local_signature: Dictionary = {
		"type": "",
		"body": {
			"command": "",
			"players": [0]
		}
	}
	
	var packet: PackedByteArray = JSON.stringify(message).to_utf8_buffer()
	var received_message: Dictionary = JSON.parse_string(packet.get_string_from_utf8())
	
	return Message.validate_shape(message, local_signature)
	
func test_float_to_JSON_to_float() -> bool:
	var local_signature: Dictionary = {
		"float": 0.0
	}
	var original: Dictionary = {
		"float": 3.0
	}
	
	var message := value_to_JSON_to_value(original)
	
	return Message.validate_shape(message, local_signature)
	
# THIS TEST FAILS
# and this is why we are not going to use JSON to send packets
# we can use the special var_to_bytes() and bytes_to_var()
# functions built into gdscript since both the server and
# the client are using Godot. This would not be possible with
# two different languages
func test_int_to_JSON_to_int() -> bool:
	var local_signature: Dictionary = {
		"int": 0
	}
	var original: Dictionary = {
		"int": 12993
	}
	
	var message := value_to_JSON_to_value(original)
	return Message.validate_shape(message, local_signature)
	
func test_float_to_bytes_to_float() -> bool:
	var local_signature: Dictionary = {
		"float": 0.0
	}
	var original: Dictionary = {
		"float": 3.0
	}
	
	var message := value_to_bytes_to_value(original)
	
	return Message.validate_shape(message, local_signature)
	
func test_int_to_bytes_to_int() -> bool:
	var local_signature: Dictionary = {
		"int": 0
	}
	var original: Dictionary = {
		"int": 12993
	}
	
	var message := value_to_bytes_to_value(original)
	return Message.validate_shape(message, local_signature)

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
	t.add(test_array_of_different_type)
	t.add(test_empty_signature_array)
	t.add(test_array_same_type)
	
	t.add(test_baseline_serialize_JSON_and_back)
	t.add(test_float_to_JSON_to_float)
	t.add(test_int_to_JSON_to_int).ignore()
	
	t.add(test_float_to_bytes_to_float)
	t.add(test_int_to_bytes_to_int)
	
	
	t.run()
