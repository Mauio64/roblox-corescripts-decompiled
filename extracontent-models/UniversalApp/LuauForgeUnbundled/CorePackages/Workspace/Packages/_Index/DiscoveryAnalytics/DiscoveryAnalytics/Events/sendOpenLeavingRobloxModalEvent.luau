local TelemetryService = game:GetService("TelemetryService")

local t = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/t")
local discoveryEventErrorLogger = require("@game/CorePackages/Workspace/Packages/_Workspace/DiscoveryAnalytics/DiscoveryUtils").DiscoveryEventErrorLogger

local defineFastInt = game:DefineFastInt("OpenLeavingRobloxModalThrottleHundrethsPercent", 0)

local strictInterface = t.strictInterface({
	assignment_id = t.number,
	assignment_type = t.string,
	social_link_type = t.string,
	social_link_display_type = t.string
})

local v5 = {
	eventName = "openLeavingRobloxModal",
	backends = { "EventIngest" },
	throttlingPercentage = defineFastInt,
	lastUpdated = { 25, 12, 9 },
	description = "Event fired when a prompt is opened to confirm that the user wants to leave roblox"
}

return function(p2)
	local v6, v7 = strictInterface(p2)

	if not v6 then
		discoveryEventErrorLogger.reportError("OpenLeavingRobloxModalInterface", v7)
	end

	TelemetryService:LogEvent(v5, {
		standardizedFields = { "addSessionInfo" },
		customFields = p2
	})
end
