return function(object, value, value2, p2)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected actionType to be a string")

	object:setRBXEventStream(value, "modalAction", { aType = value2, origin = p2 })
end
