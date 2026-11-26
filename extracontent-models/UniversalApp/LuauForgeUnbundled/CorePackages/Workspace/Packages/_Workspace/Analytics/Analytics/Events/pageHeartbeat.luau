return function(object, value, p2)
	assert(type(value) == "number", "Expected beatInterval to be a number")

	object:setRBXEventStream(string.format("%s%d", "heartbeat", value), "pageHeartbeat", {
		url = p2
	})
end
