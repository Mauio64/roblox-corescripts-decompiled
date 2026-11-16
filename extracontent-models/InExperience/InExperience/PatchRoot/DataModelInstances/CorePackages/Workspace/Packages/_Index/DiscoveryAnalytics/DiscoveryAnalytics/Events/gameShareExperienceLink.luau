local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent

local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppAddUniverseIdToEngagementEvents = SharedFlags.FFlagLuaAppAddUniverseIdToEngagementEvents

local defineFastInt = game:DefineFastInt("GameShareExperienceLinkThrottleHundrethsPercent", 10000)

local strictInterface = t.strictInterface
local v = {
	placeId = t.string,
	uid = t.string,
	ctx = t.string,
	shortShareLinkFailed = t.optional(t.boolean),
	shareToAppsflyer = t.optional(t.boolean),
	stamp = t.optional(t.string),
	linkId = t.optional(t.string),
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
		DiscoveryEventErrorLogger.reportError("GameShareExperienceLinkInvalidInterface", v4)
	end

	TelemetryService:LogEvent({
		eventName = "shareExperienceLink",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 25, 11, 11 },
		description = "User has shared an experience link"
	}, {
		eventContext = eventContext,
		standardizedFields = { "addSessionInfo" },
		customFields = customFields
	})
end
