local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

return function(p1, t1: {[any]: any}?) -- line: 3
	-- upvalues: RbxAnalyticsService (copy)
	if not t1 then
		t1 = {}
	end

	assert(t1 ~= nil, "eventTable must not be nil")
	t1.gameId = tostring(game.GameId)
	t1.placeId = tostring(game.PlaceId)
	RbxAnalyticsService:SendEventDeferred("rcc", "lua_chat_system", p1, t1)
end
