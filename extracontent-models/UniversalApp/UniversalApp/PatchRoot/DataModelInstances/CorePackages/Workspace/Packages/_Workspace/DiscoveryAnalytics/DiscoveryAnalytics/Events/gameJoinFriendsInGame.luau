local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local t = require(Parent.t)
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local v5 = game:DefineFastInt("GameJoinFriendsInGameThrottleHundrethsPercent", 10000)
local v6 = t.strictInterface({
	placeId = t.string,
	uid = t.string,
	ctx = t.string
})
local t1 = {
	eventName = "joinFriendsInGame",
	description = "User joined friends in game from experience details overflow",
	backends = { "EventIngest" },
	throttlingPercentage = v5,
	lastUpdated = {
		26,
		4,
		29
	}
}
local t2 = { "addSessionInfo" }

return function(p1, s1: string) -- line: 29
	-- upvalues: v6 (copy), DiscoveryEventErrorLogger (copy), TelemetryService (copy), t1 (copy), t2 (copy)
	local v11, v12 = v6(p1)

	if not v11 then
		DiscoveryEventErrorLogger.reportError("GameJoinFriendsInGameInvalidInterface", v12)
	end

	TelemetryService:LogEvent(t1, {
		eventContext = s1,
		standardizedFields = t2,
		customFields = p1
	})
end
