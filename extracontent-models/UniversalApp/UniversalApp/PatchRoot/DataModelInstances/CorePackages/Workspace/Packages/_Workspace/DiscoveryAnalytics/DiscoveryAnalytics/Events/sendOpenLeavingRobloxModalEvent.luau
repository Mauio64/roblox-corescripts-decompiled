local TelemetryService = game:GetService("TelemetryService")
local Parent = script:FindFirstAncestor("DiscoveryAnalytics").Parent
local t = require(Parent.t)
local DiscoveryEventErrorLogger = require(Parent.DiscoveryUtils).DiscoveryEventErrorLogger
local v5 = game:DefineFastInt("OpenLeavingRobloxModalThrottleHundrethsPercent", 0)
local v6 = t.strictInterface({
	assignment_id = t.number,
	assignment_type = t.string,
	social_link_type = t.string,
	social_link_display_type = t.string
})
local t1 = {
	eventName = "openLeavingRobloxModal",
	description = "Event fired when a prompt is opened to confirm that the user wants to leave roblox",
	backends = { "EventIngest" },
	throttlingPercentage = v5,
	lastUpdated = {
		25,
		12,
		9
	}
}

return function(p1) -- line: 27
	-- upvalues: v6 (copy), DiscoveryEventErrorLogger (copy), TelemetryService (copy), t1 (copy)
	local v9, v10 = v6(p1)

	if not v9 then
		DiscoveryEventErrorLogger.reportError("OpenLeavingRobloxModalInterface", v10)
	end

	TelemetryService:LogEvent(t1, {
		standardizedFields = { "addSessionInfo" },
		customFields = p1
	})
end
