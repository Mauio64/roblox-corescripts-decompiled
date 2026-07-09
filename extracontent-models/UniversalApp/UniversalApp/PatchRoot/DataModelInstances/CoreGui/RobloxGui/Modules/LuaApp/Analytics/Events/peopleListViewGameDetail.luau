local Players = game:GetService("Players")

return function(p1, p2, p3, p4, p5, p6) -- line: 4
	-- upvalues: Players (copy)
	assert(type(p2) == "string", "Expected friendId to be a string")
	assert(type(p3) == "number", "Expected position to be a number")
	assert(type(p5) == "number", "Expected number to be a string")
	assert(type(p6) == "string", "Expected fromWhere to be a string")
	assert(type(p4) == "number", "Expected absolutePosition to be a number")
	p1:setRBXEventStream("contactFriendFinder", "goToGameDetailInPeopleList", {
		uid = tostring(Players.LocalPlayer.UserId),
		friendId = p2,
		position = p3,
		absolutePosition = p4,
		rootPlaceId = p5,
		fromWhere = p6
	})
end
