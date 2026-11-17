local Players = game:GetService("Players")

return function(object, friendId, value, value2, value3, value4)
	assert(type(friendId) == "string", "Expected friendId to be a string")
	assert(type(value) == "number", "Expected position to be a number")
	assert(type(value3) == "number", "Expected number to be a string")
	assert(type(value4) == "string", "Expected fromWhere to be a string")
	assert(type(value2) == "number", "Expected absolutePosition to be a number")

	object:setRBXEventStream("contactFriendFinder", "goToGameDetailInPeopleList", {
		uid = tostring(Players.LocalPlayer.UserId),
		friendId = friendId,
		position = value,
		absolutePosition = value2,
		rootPlaceId = value3,
		fromWhere = value4
	})
end
