local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent

local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local defineFastInt = game:DefineFastInt("GameJoinFriendsInGameThrottleHundrethsPercent", 10000)

local strictInterface = t.strictInterface({ placeId = t.string, uid = t.string, ctx = t.string })

local v = {
	eventName = "joinFriendsInGame",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 26, 4, 29 },
	description = "User joined friends in game from experience details overflow"
}

local standardizedFields = { "addSessionInfo" }

return function(customFields, eventContext: string)
	local v2, v3 = strictInterface(customFields)

	if not v2 then
		DiscoveryEventErrorLogger.reportError("GameJoinFriendsInGameInvalidInterface", v3)
	end

	TelemetryService:LogEvent(v, {
		eventContext = eventContext,
		standardizedFields = standardizedFields,
		customFields = customFields
	})
end
