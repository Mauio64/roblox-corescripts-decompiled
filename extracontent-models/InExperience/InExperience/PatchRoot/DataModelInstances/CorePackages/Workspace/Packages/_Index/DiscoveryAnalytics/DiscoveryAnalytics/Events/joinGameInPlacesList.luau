local Players = game:GetService("Players")

return function(object, playerId, value, value2, value3, value4, value5)
	assert(type(playerId) == "string", "Expected playerId to be a string")
	assert(type(value) == "string", "Expected placeId to be a string")
	assert(type(value2) == "number", "Expected rootPlaceId to be a number")

	if value3 then
		assert(type(value3) == "string", "Expected gameInstanceId to be a string")
	end

	if value4 then
		assert(type(value4) == "string", "Expected joinAttemptId to be a string")
	end

	if value5 then
		assert(type(value5) == "string", "Expected source to be a string")
	end

	object:setRBXEventStream("PlacesList", "joinGameInPlacesList", {
		uid = tostring(Players.LocalPlayer.UserId),
		playerId = playerId,
		placeId = value,
		rootPlaceId = value2,
		gameInstanceId = value3,
		joinAttemptJoinId = value4,
		source = value5
	})
end
