return function(p1, p2, p3, p4) -- line: 1
	assert(type(p3) == "string", "expected promptType to be a string")
	assert(type(p4) == "string", "expected modalState to be a string")
	p1:setRBXEventStream(p2, "accountSecurityPromptEvent", {
		promptType = p3,
		state = p4
	})
end
