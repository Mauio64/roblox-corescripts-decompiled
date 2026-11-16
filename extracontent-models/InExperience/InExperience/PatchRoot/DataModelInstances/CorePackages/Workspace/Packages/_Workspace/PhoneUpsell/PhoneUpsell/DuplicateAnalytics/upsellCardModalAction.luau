return function(object, value, field, value2, origin, section, errorCode)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected actionType to be a string")

	object:setRBXEventStream(value, "modalAction", {
		aType = value2,
		origin = origin,
		section = section,
		errorCode = errorCode,
		field = field
	})
end
