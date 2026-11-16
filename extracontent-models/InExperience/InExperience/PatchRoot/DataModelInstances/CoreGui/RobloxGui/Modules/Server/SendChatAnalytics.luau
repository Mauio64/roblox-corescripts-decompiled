local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

return function(p, options)
	options = options or {}

	assert(options ~= nil, "eventTable must not be nil")

	options.gameId = tostring(game.GameId)
	options.placeId = tostring(game.PlaceId)

	RbxAnalyticsService:SendEventDeferred("rcc", "lua_chat_system", p, options)
end
