return function(object, p2, value, value2)
	assert(type(value) == "string", "expected promptType to be a string")
	assert(type(value2) == "string", "expected modalState to be a string")

	object:setRBXEventStream(p2, "accountSecurityPromptEvent", {
		promptType = value,
		state = value2
	})
end
