local GenericAbuseReporting = script:FindFirstAncestor("GenericAbuseReporting")
local GenericAbuseReportingParent = GenericAbuseReporting.Parent
local Dash = require(GenericAbuseReportingParent.Dash)
local analyticsService = require(GenericAbuseReporting.BeduiV2.Analytics.analyticsService)
local sendAnalyticsEvent = analyticsService.sendAnalyticsEvent
local TelemetryEventType = analyticsService.TelemetryEventType

local function sendBoundaryErrorTelemetry(p1, t1: {[any]: any}) -- line: 20
	-- upvalues: Dash (copy), sendAnalyticsEvent (copy), TelemetryEventType (copy)
	local v10 = Dash.pretty(p1, {
		depth = 10,
		multiline = true
	})

	sendAnalyticsEvent({
		run_id = "err",
		total_duration = 0,
		abuse_vector = t1.abuse_vector,
		target_id = t1.target_id,
		path = {}
	}, {
		sub_event_type = TelemetryEventType.Error,
		error_detail = {
			error_message = `Render error: { v10 }`
		}
	})
end

return sendBoundaryErrorTelemetry
