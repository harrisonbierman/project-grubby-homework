class_name Message
extends Object

static func validate_message_signature(
	dict: Dictionary,
	signature: Dictionary
	) -> bool:
		
	var signature_keys: Array[Variant] = signature.keys()
	var dict_keys: Array[Variant] = dict.keys()
	
	if not dict.has_all(signature_keys) or not signature.has_all(dict_keys):
		return false
	
		
	for key: Variant in dict:
		
		var dict_value: Variant = dict.get(key)
		var signature_value: Variant = signature.get(key)
		
		if typeof(dict_value) != typeof(signature_value):
			return false
			
		if dict_value is Dictionary:
			if not validate_message_signature(dict.get(key), signature.get(key)):
				return false
	
	return true
	
static func validate_message_signature_ai(
	message: Dictionary,
	signature: Dictionary
) -> bool:
	# Reject missing or extra keys
	if message.size() != signature.size():
		return false

	for key: Variant in signature:

		# Verify the key exists
		if not message.has(key):
			return false

		var actual: Variant = message[key]
		var expected: Variant = signature[key]

		# Verify the value has the correct type
		if typeof(actual) != typeof(expected):
			return false

		# Recursively validate nested dictionaries
		if expected is Dictionary:
			if not validate_message_signature(
				actual as Dictionary,
				expected as Dictionary
			):
				return false

	return true
	
