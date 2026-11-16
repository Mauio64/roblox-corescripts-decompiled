return function(object, value, value2, value3)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected field to be a string")
	assert(type(value3) == "string", "Expected errorText to be a string")

	object:setRBXEventStream(value, "formFieldValidation", {
		field = value2,
		error = value3
	})
end
