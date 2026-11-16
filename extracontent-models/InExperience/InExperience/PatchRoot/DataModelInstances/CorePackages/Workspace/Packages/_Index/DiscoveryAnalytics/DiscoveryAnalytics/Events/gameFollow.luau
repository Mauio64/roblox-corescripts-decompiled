local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent

local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppAddUniverseIdToEngagementEvents = SharedFlags.FFlagLuaAppAddUniverseIdToEngagementEvents

local defineFastInt = game:DefineFastInt("GameFollowThrottleHundrethsPercent", 10000)

local strictInterface = t.strictInterface
local v = {
	placeId = t.string,
	state = t.union(t.literal("on"), t.literal("off")),
	ctx = t.string,
	uid = t.string,
	universeId = 0
}
local universeId

if FFlagLuaAppAddUniverseIdToEngagementEvents then
	universeId = t.optional(t.string)
end

v.universeId = universeId
local v2 = strictInterface(v)

return function(customFields, eventContext: string)
	local v3, v4 = v2(customFields)

	if not v3 then
		DiscoveryEventErrorLogger.reportError("GameFollowInvalidInterface", v4)
	end

	TelemetryService:LogEvent({
		eventName = "follow",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 25, 11, 11 },
		description = "User has followed/unfollowed a game"
	}, {
		eventContext = eventContext,
		standardizedFields = { "addSessionInfo" },
		customFields = customFields
	})
end
