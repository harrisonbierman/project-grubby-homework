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
		if dict.get(key) is Dictionary and signature.has(key) and signature.get(key) is Dictionary:
			return validate_message_signature(dict.get(key), signature.get(key))
	
	return true
	
	
