local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local TelemetryService = game:GetService("TelemetryService")

local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/ArgCheck")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Dash")

local AbuseEntrypoint = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseEntrypoint")
require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/Enums/AbuseVector")

local v5 = {
	eventName = "DynamicAbuseReportEvent",
	description = "Event to track dynamic abuse report",
	lastUpdated = { 2024, 6, 18 },
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("DynamicAbuseReportThrottleHundredthsPercent", 0),
	links = "https://github.rbx.com/Roblox/proto-schemas/pull/6068"
}

local function buildCustomFields(data)
	local v6 = if data.meta then Dash.pretty(data.meta, {
		depth = 10,
		multiline = false
	}) else nil

	return {
		abuse_vector = data.context.abuseVector,
		user_id = not localPlayer and 0 or localPlayer.UserId,
		event_type = data.eventType,
		entry_point = AbuseEntrypoint.APP,
		meta = v6
	}
end

return {
	sendAnalyticsEvent = function(p2)
		ArgCheck.assert(p2.context, "customFields must be provided")
		ArgCheck.assert(p2.context.abuseVector, "customFields.abuse_vector must be provided")

		TelemetryService:LogEvent(v5, { customFields = buildCustomFields(p2) })
	end,
	TelemetryEventType = {
		Abandoned = "EVENT_ABANDONED",
		Error = "EVENT_ERROR",
		Rendered = "EVENT_RENDERED",
		Submitted = "EVENT_SUBMITTED"
	}
}
