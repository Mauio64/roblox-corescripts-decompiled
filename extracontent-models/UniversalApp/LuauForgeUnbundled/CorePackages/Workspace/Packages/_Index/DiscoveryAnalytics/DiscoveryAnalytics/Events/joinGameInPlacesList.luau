local Players = game:GetService("Players")

return function(object, value, value2, value3, value4, value5, value6)
	assert(type(value) == "string", "Expected playerId to be a string")
	assert(type(value2) == "string", "Expected placeId to be a string")
	assert(type(value3) == "number", "Expected rootPlaceId to be a number")

	if value4 then
		assert(type(value4) == "string", "Expected gameInstanceId to be a string")
	end

	if value5 then
		assert(type(value5) == "string", "Expected joinAttemptId to be a string")
	end

	if value6 then
		assert(type(value6) == "string", "Expected source to be a string")
	end

	object:setRBXEventStream("PlacesList", "joinGameInPlacesList", {
		uid = tostring(Players.LocalPlayer.UserId),
		playerId = value,
		placeId = value2,
		rootPlaceId = value3,
		gameInstanceId = value4,
		joinAttemptJoinId = value5,
		source = value6
	})
end
