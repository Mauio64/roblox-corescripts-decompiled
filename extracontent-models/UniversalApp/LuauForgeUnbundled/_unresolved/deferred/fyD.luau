return function(object, value, value2, value3, value4)
	assert(type(value) == "string", "Expected context to be a string")
	assert(type(value2) == "string", "Expected name to be a string")
	assert(type(value3) == "string", "Expected oldValue to be a string")
	assert(type(value4) == "string", "Expected newValue to be a string")

	object:setRBXEventStream(value, "changeAccessibilitySetting", {
		name = value2,
		oldValue = value3,
		newValue = value4
	})
end
