local function getCurrentExperienceProject() -- line: 10
	local GameId = game.GameId
	local PlaceId = game.PlaceId

	return {
		universeId = if GameId ~= 0 then GameId else nil,
		placeId = if PlaceId ~= 0 then PlaceId else nil
	}
end

return getCurrentExperienceProject
