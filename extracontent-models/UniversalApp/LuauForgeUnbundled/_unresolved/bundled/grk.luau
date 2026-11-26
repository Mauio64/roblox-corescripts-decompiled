return function(object, value, value2, value3, value4)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected buttonName to be a string")
	assert(type(value3) == "string", "Expected userField to be a string")
	assert(type(value4) == "string", "Expected suggestion to be a string")

	object:setRBXEventStream(value, "buttonClick", {
		btn = value2,
		userField = value3,
		suggestion = value4
	})
end
