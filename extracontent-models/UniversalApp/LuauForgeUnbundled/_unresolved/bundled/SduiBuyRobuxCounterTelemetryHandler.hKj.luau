local getActionTelemetryFieldValue = require("@luauforge/bundled/hId").getActionTelemetryFieldValue

local module = require("@luauforge/bundled/hHP")

local function SduiBuyRobuxCounterTelemetryHandler(p2, p3, p4)
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p2, p3, "counterName")

	if typeof(actionTelemetryFieldValue) ~= "string" or actionTelemetryFieldValue == "" then
		return
	end

	module.trackCounter(actionTelemetryFieldValue)
end

return SduiBuyRobuxCounterTelemetryHandler
