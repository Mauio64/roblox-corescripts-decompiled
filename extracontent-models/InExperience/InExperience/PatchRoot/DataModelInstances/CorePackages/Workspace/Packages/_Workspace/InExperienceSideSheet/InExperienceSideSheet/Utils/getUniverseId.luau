local function getUniverseId()
	if game.GameId > 0 then
		return (tostring(game.GameId))
	end

	return nil
end

return getUniverseId
