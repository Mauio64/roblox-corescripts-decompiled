local TelemetryService = game:GetService("TelemetryService")
local parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local t = require(parent.t)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local defineFastInt = game:DefineFastInt("OpenLeavingRobloxModalThrottleHundrethsPercent", 0)

local strictInterface = t.strictInterface({
	assignment_id = t.number,
	assignment_type = t.string,
	social_link_type = t.string,
	social_link_display_type = t.string
})

local v = {
	eventName = "openLeavingRobloxModal",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 25, 12, 9 },
	description = "Event fired when a prompt is opened to confirm that the user wants to leave roblox"
}

return function(customFields)
	local v2, v3 = strictInterface(customFields)

	if not v2 then
		DiscoveryEventErrorLogger.reportError("OpenLeavingRobloxModalInterface", v3)
	end

	TelemetryService:LogEvent(v, {
		standardizedFields = { "addSessionInfo" },
		customFields = customFields
	})
end
