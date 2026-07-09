return function(p1, p2, p3, p4) -- line: 5
	assert(type(p2) == "string", "Expected eventContext to be a string")
	assert(type(p3) == "string", "Expected actionType to be a string")
	p1:setRBXEventStream(p2, "modalAction", {
		aType = p3,
		origin = p4
	})
end
