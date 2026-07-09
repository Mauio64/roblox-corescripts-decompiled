local function getUniverseId() -- line: 1
	if game.GameId > 0 then
		return (tostring(game.GameId))
	end

	return nil
end

return getUniverseId
