local Players = game:GetService("Players")

return function(p1, p2, p3, p4, p5, p6, p7) -- line: 4
	-- upvalues: Players (copy)
	assert(type(p2) == "string", "Expected playerId to be a string")
	assert(type(p3) == "string", "Expected placeId to be a string")
	assert(type(p4) == "number", "Expected rootPlaceId to be a number")

	if p5 then
		assert(type(p5) == "string", "Expected gameInstanceId to be a string")
	end

	if p6 then
		assert(type(p6) == "string", "Expected joinAttemptId to be a string")
	end

	if p7 then
		assert(type(p7) == "string", "Expected source to be a string")
	end

	p1:setRBXEventStream("PlacesList", "joinGameInPlacesList", {
		uid = tostring(Players.LocalPlayer.UserId),
		playerId = p2,
		placeId = p3,
		rootPlaceId = p4,
		gameInstanceId = p5,
		joinAttemptJoinId = p6,
		source = p7
	})
end
