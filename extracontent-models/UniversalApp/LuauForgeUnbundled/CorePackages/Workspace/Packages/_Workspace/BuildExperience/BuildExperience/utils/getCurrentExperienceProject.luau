local function getCurrentExperienceProject()
	local gameId = game.GameId
	local placeId = game.PlaceId

	if gameId == 0 then
		gameId = nil
	end

	if placeId == 0 then
		placeId = nil
	end

	return { universeId = gameId, placeId = placeId }
end

return getCurrentExperienceProject
