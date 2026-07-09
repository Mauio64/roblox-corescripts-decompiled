return function(p1, p2, p3, p4, p5) -- line: 1
	assert(type(p2) == "string", "Expected context to be a string")
	assert(type(p3) == "string", "Expected name to be a string")
	assert(type(p4) == "string", "Expected oldValue to be a string")
	assert(type(p5) == "string", "Expected newValue to be a string")
	p1:setRBXEventStream(p2, "changeAccessibilitySetting", {
		name = p3,
		oldValue = p4,
		newValue = p5
	})
end
