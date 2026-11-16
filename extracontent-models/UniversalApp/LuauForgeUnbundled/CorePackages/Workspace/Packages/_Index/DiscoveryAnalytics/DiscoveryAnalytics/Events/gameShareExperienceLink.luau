local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger

local fFlagLuaAppAddUniverseIdToEngagementEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/SharedFlags").FFlagLuaAppAddUniverseIdToEngagementEvents

local defineFastInt = game:DefineFastInt("GameShareExperienceLinkThrottleHundrethsPercent", 10000)

local strictInterface = t.strictInterface
local v5 = {
	placeId = t.string,
	uid = t.string,
	ctx = t.string,
	shortShareLinkFailed = t.optional(t.boolean),
	shareToAppsflyer = t.optional(t.boolean),
	stamp = t.optional(t.string),
	linkId = t.optional(t.string),
	targetId = 0
}
local v6 = if fFlagLuaAppAddUniverseIdToEngagementEvents then t.optional(t.string) else nil
v5.targetId = v6
local v7 = strictInterface(v5)

return function(p2, p3)
	local v8, v9 = v7(p2)

	if not v8 then
		discoveryEventErrorLogger.reportError("GameShareExperienceLinkInvalidInterface", v9)
	end

	TelemetryService:LogEvent({
		eventName = "shareExperienceLink",
		backends = { "EventIngest" },
		throttlingPercentage = defineFastInt,
		lastUpdated = { 25, 11, 11 },
		description = "User has shared an experience link"
	}, {
		eventContext = p3,
		standardizedFields = { "addSessionInfo" },
		customFields = p2
	})
end
