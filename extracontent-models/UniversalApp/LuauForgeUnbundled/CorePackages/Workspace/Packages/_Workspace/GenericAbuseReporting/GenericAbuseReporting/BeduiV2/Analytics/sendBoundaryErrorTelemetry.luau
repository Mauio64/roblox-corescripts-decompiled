local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/Dash")

local analyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/GenericAbuseReporting/GenericAbuseReporting/BeduiV2/Analytics/analyticsService")

local sendAnalyticsEvent = analyticsService.sendAnalyticsEvent
local telemetryEventType = analyticsService.TelemetryEventType

local function sendBoundaryErrorTelemetry(p2, p3)
	local pretty = Dash.pretty(p2, { depth = 10, multiline = true })

	sendAnalyticsEvent({
		abuse_vector = p3.abuse_vector,
		target_id = p3.target_id,
		run_id = "err",
		total_duration = 0,
		path = {}
	}, {
		sub_event_type = telemetryEventType.Error,
		error_detail = { error_message = `Render error: {pretty}` }
	})
end

return sendBoundaryErrorTelemetry
