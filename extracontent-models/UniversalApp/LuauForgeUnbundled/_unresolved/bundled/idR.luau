local Players = game:GetService("Players")

return function(object, value, value2, value3, value4, value5)
	assert(type(value) == "string", "Expected friendId to be a string")
	assert(type(value2) == "number", "Expected position to be a number")
	assert(type(value4) == "number", "Expected number to be a string")
	assert(type(value5) == "string", "Expected fromWhere to be a string")
	assert(type(value3) == "number", "Expected absolutePosition to be a number")

	object:setRBXEventStream("contactFriendFinder", "goToGameDetailInPeopleList", {
		uid = tostring(Players.LocalPlayer.UserId),
		friendId = value,
		position = value2,
		absolutePosition = value3,
		rootPlaceId = value4,
		fromWhere = value5
	})
end
