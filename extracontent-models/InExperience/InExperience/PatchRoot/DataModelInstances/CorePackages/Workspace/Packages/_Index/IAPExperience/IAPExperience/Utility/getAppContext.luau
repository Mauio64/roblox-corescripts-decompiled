local function getAppContext(): string
	return if game.GameId == 0 then "UA" else "IN_EXPERIENCE"
end

return getAppContext
