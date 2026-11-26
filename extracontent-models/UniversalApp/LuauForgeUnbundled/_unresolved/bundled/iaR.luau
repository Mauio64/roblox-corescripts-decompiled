return function(object, value, value2)
	assert(type(value) == "string", "Expected eventContext to be a string")
	assert(type(value2) == "number", "Expected badgeCount to be a number")

	object:setRBXEventStream(value, "partyTabBadgeClick", { badgeCount = value2 })
end
