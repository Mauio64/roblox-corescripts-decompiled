return function(object, value)
	assert(type(value) == "string", "Expected eventContext to be a string")

	object:setRBXEventStream(value, "screenLoaded", nil)
end
