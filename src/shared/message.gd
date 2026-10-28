class_name Message
extends Object

static func validate_shape(
	value: Variant,
	signature: Variant
	) -> bool:
	
	if typeof(value) != typeof(signature):
		return false
	
	if signature is Dictionary:
		if value.size() != signature.size():
			return false
		
		for key: Variant in signature:
			if not value.has(key):
				return false
		
			if not validate_shape(value[key], signature[key]):
				return false
				
	elif signature is Array:
		if signature.size() != 1:
			return false
		
		for element: Variant in value:
			if not validate_shape(element, signature[0]):
				return false
		
	return true
	
