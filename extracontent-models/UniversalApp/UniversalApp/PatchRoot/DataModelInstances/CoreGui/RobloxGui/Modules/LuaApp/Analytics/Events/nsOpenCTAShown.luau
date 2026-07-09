return function(p1, p2, p3) -- line: 4
	assert(type(p2) == "string", "Expected eventContext to be a string")
	assert(type(p3) == "number", "Expected countOfUnreadNotifications to be a number")
	p1:setRBXEventStream(p2, "nsOpenCTAShown", {
		count = p3
	})
end
