local getActionTelemetryFieldValue = require("@luauforge/bundled/hwV").getActionTelemetryFieldValue

local module = require("@luauforge/bundled/hwH")

local function SduiBuyRobuxCounterTelemetryHandler(p2, p3, p4)
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p2, p3, "counterName")

	if typeof(actionTelemetryFieldValue) ~= "string" or actionTelemetryFieldValue == "" then
		return
	end

	module.trackCounter(actionTelemetryFieldValue)
end

return SduiBuyRobuxCounterTelemetryHandler
