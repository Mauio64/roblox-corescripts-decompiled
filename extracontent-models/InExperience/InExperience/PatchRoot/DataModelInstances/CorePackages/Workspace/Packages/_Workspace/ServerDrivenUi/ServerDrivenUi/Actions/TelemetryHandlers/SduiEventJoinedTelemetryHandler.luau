local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local VirtualEvents = require(parent.VirtualEvents)

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue

return function(p, p2, p3)
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p, p2, "eventId")

	if actionTelemetryFieldValue == nil then
		p3.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = "EventJoined", message = "Missing eventId for EventJoined telemetry" },
			p3.appPage
		)
		return
	end

	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(p, p2, "universeId", "")
	local actionTelemetryFieldValue3 = getActionTelemetryFieldValue(p, p2, "channel", "")

	VirtualEvents.fireVirtualEventJoined({
		virtualEventId = actionTelemetryFieldValue,
		universeId = tostring(actionTelemetryFieldValue2),
		channel = tostring(actionTelemetryFieldValue3)
	})
end
