return function(p1, s1: string, n1: number) -- line: 4
	assert(type(s1) == "string", "Expected eventContext to be a string")
	assert(type(n1) == "number", "Expected badgeCount to be a number")
	p1:setRBXEventStream(s1, "partyTabBadgeImpression", {
		badgeCount = n1
	})
end
