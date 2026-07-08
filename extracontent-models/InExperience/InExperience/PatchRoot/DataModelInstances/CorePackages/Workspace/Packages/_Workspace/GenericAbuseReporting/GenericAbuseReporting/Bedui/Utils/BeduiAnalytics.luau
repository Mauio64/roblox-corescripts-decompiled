local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local LocalPlayer = game:GetService("Players").LocalPlayer
local TelemetryService = game:GetService("TelemetryService")
local ArgCheck = require(GenericAbuseReportingParent.ArgCheck)
local Dash = require(GenericAbuseReportingParent.Dash)
local AbuseEntrypoint = require(GenericAbuseReporting.Enums.AbuseEntrypoint)

require(GenericAbuseReporting.Enums.AbuseVector)

local t1 = {
	Abandoned = "EVENT_ABANDONED",
	Error = "EVENT_ERROR",
	Rendered = "EVENT_RENDERED",
	Submitted = "EVENT_SUBMITTED"
}
local t2 = {
	eventName = "DynamicAbuseReportEvent",
	description = "Event to track dynamic abuse report",
	links = "https://github.rbx.com/Roblox/proto-schemas/pull/6068",
	lastUpdated = {
		2024,
		6,
		18
	},
	backends = {
		"EventIngest",
		"Points"
	},
	throttlingPercentage = game:DefineFastInt("DynamicAbuseReportThrottleHundredthsPercent", 0)
}

local function buildCustomFields(t3: {[any]: any}) -- line: 60
	-- upvalues: Dash (copy), LocalPlayer (copy), AbuseEntrypoint (copy)
	local v12 = nil

	if t3.meta then
		v12 = Dash.pretty(t3.meta, {
			depth = 10,
			multiline = false
		})
	end

	return {
		abuse_vector = t3.context.abuseVector,
		user_id = not LocalPlayer and 0 or LocalPlayer.UserId,
		event_type = t3.eventType,
		entry_point = AbuseEntrypoint.APP,
		meta = v12
	}
end

return {
	sendAnalyticsEvent = function(t4: {[any]: any}) -- line: 76
		-- upvalues: ArgCheck (copy), TelemetryService (copy), t2 (copy), buildCustomFields (copy)
		ArgCheck.assert(t4.context, "customFields must be provided")
		ArgCheck.assert(t4.context.abuseVector, "customFields.abuse_vector must be provided")
		TelemetryService:LogEvent(t2, {
			customFields = buildCustomFields(t4)
		})
	end,
	TelemetryEventType = t1
}
