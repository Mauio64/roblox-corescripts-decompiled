local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger

local defineFastInt = game:DefineFastInt("GameJoinFriendsInGameThrottleHundrethsPercent", 10000)

local strictInterface = t.strictInterface({
	placeId = t.string,
	uid = t.string,
	ctx = t.string
})

local v5 = {
	eventName = "joinFriendsInGame",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 26, 4, 29 },
	description = "User joined friends in game from experience details overflow"
}

local v6 = { "addSessionInfo" }

return function(p2, p3)
	local v7, v8 = strictInterface(p2)

	if not v7 then
		discoveryEventErrorLogger.reportError("GameJoinFriendsInGameInvalidInterface", v8)
	end

	TelemetryService:LogEvent(v5, {
		eventContext = p3,
		standardizedFields = v6,
		customFields = p2
	})
end
