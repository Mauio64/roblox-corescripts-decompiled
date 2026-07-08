local function getAppContext() -- line: 5
	if game.GameId == 0 then
		return "UA"
	end

	return "IN_EXPERIENCE"
end

return getAppContext
