local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent

local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppAddUniverseIdToEngagementEvents = SharedFlags.FFlagLuaAppAddUniverseIdToEngagementEvents

local defineFastInt = game:DefineFastInt("GameCopyExperienceLinkThrottleHundrethsPercent", 10000)

local strictInterface = t.strictInterface
local v = {
	placeId = t.string,
	uid = t.string,
	ctx = t.string,
	stamp = t.optional(t.string),
	targetId = 0
}
local targetId

if FFlagLuaAppAddUniverseIdToEngagementEvents then
	targetId = t.optional(t.string)
end

v.targetId = targetId
local v2 = strictInterface(v)

return function(customFields, eventContext: string)
	local v3, v4 = v2(customFields)

	if not v3 then
		DiscoveryEventErrorLogger.reportError("GameCopyExperienceLinkInvalidInterface", v4)
	end

	TelemetryService:LogEvent({
		eventName = "copyExperienceLink",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 25, 11, 11 },
		description = "User has copied an experience link"
	}, {
		eventContext = eventContext,
		standardizedFields = { "addSessionInfo" },
		customFields = customFields
	})
end
