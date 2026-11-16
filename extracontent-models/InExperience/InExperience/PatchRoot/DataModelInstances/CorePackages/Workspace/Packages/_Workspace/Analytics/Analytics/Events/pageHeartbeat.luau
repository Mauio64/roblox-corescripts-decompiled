return function(object, value, url)
	assert(type(value) == "number", "Expected beatInterval to be a number")

	object:setRBXEventStream(string.format("%s%d", "heartbeat", value), "pageHeartbeat", {
		url = url
	})
end
