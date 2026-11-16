return function(object, value, p2, value2, p3, p4, p5)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected actionType to be a string")

	object:setRBXEventStream(value, "modalAction", {
		aType = value2,
		origin = p3,
		section = p4,
		errorCode = p5,
		field = p2
	})
end
