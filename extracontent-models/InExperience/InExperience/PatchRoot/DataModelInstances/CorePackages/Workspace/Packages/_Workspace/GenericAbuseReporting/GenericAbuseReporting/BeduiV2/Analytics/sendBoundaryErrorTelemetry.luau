local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local parent = GenericAbuseReporting.Parent

local Dash = require(parent.Dash)

local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)

local sendAnalyticsEvent = analyticsService.sendAnalyticsEvent
local telemetryEventType = analyticsService.TelemetryEventType

local function sendBoundaryErrorTelemetry(p, p2)
	local pretty = Dash.pretty(p, { depth = 10, multiline = true })

	sendAnalyticsEvent({
		abuse_vector = p2.abuse_vector,
		target_id = p2.target_id,
		run_id = "err",
		total_duration = 0,
		path = {}
	}, {
		sub_event_type = telemetryEventType.Error,
		error_detail = { error_message = `Render error: {pretty}` }
	})
end

return sendBoundaryErrorTelemetry
