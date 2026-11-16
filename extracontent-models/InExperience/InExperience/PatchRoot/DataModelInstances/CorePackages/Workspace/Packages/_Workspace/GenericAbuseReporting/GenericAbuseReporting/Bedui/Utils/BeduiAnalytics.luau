local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TelemetryService = game:GetService("TelemetryService")

local ArgCheck = require(parent.ArgCheck)
local Dash = require(parent.Dash)

local AbuseEntrypoint = require(GenericAbuseReporting.Enums.AbuseEntrypoint)
require(GenericAbuseReporting.Enums.AbuseVector)

local v = {
	eventName = "DynamicAbuseReportEvent",
	description = "Event to track dynamic abuse report",
	lastUpdated = { 2024, 6, 18 },
	backends = { "EventIngest", "Points" },
	throttlingPercentage = game:DefineFastInt("DynamicAbuseReportThrottleHundredthsPercent", 0),
	links = "https://github.rbx.com/Roblox/proto-schemas/pull/6068"
}

local function buildCustomFields(data)
	local meta

	if data.meta then
		meta = Dash.pretty(data.meta, { depth = 10, multiline = false })
	end

	return {
		abuse_vector = data.context.abuseVector,
		user_id = not LocalPlayer and 0 or LocalPlayer.UserId,
		event_type = data.eventType,
		entry_point = AbuseEntrypoint.APP,
		meta = meta
	}
end

return {
	sendAnalyticsEvent = function(p)
		ArgCheck.assert(p.context, "customFields must be provided")
		ArgCheck.assert(p.context.abuseVector, "customFields.abuse_vector must be provided")

		TelemetryService:LogEvent(v, { customFields = buildCustomFields(p) })
	end,
	TelemetryEventType = {
		Abandoned = "EVENT_ABANDONED",
		Error = "EVENT_ERROR",
		Rendered = "EVENT_RENDERED",
		Submitted = "EVENT_SUBMITTED"
	}
}
