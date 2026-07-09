local AnalyticsService = require(script.Parent.AnalyticsService)
local UnifiedEventLogConstants = require(script.Parent.UnifiedEventLogConstants)

return function(p1) -- line: 4
	-- upvalues: AnalyticsService (copy), UnifiedEventLogConstants (copy)
	AnalyticsService.EventStream:sendTelemetryEvent(UnifiedEventLogConstants.EVENT_NAME, UnifiedEventLogConstants.EVENT_NAME, p1)
end
