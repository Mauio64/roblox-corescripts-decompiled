return function(object, value, value2, value3, value4, value5)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "string", "Expected field to be a string")
	assert(type(value3) == "string", "Expected actionType to be a string")

	if value4 ~= nil then
		assert(type(value4) == "string", "Expected origin to be a string")
	end

	if value5 ~= nil then
		assert(type(value5) == "string", "Expected btn to be a string")
	end

	object:setRBXEventStream(value, "formInteraction", {
		field = value2,
		aType = value3,
		origin = value4,
		btn = value5
	})
end
