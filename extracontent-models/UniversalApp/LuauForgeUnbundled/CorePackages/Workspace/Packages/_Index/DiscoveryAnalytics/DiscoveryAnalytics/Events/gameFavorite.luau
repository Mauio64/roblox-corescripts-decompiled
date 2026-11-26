local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger

local fFlagLuaAppAddUniverseIdToEngagementEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagLuaAppAddUniverseIdToEngagementEvents

local defineFastInt = game:DefineFastInt("GameFavoriteThrottleHundrethsPercent", 10000)

local strictInterface = t.strictInterface
local v5 = {
	placeId = t.string,
	state = t.union(t.literal("on"), t.literal("off")),
	ctx = t.string,
	uid = t.string,
	targetId = 0
}
local v6 = if fFlagLuaAppAddUniverseIdToEngagementEvents then t.optional(t.string) else nil
v5.targetId = v6
local v7 = strictInterface(v5)

return function(p2, p3)
	local v8, v9 = v7(p2)

	if not v8 then
		discoveryEventErrorLogger.reportError("GameFavoriteInvalidInterface", v9)
	end

	TelemetryService:LogEvent({
		eventName = "favorite",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 25, 11, 11 },
		description = "User has favorited/unfavorited a game"
	}, {
		eventContext = p3,
		standardizedFields = { "addSessionInfo" },
		customFields = p2
	})
end
