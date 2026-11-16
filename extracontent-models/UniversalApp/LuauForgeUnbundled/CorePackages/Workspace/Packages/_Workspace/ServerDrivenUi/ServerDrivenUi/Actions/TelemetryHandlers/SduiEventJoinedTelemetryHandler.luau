local VirtualEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/VirtualEvents")

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue

return function(p2, p3, p4)
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p2, p3, "eventId")

	if actionTelemetryFieldValue == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = "EventJoined",
				message = "Missing eventId for EventJoined telemetry"
			},
			p4.appPage
		)
		return
	end

	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(p2, p3, "universeId", "")
	local actionTelemetryFieldValue3 = getActionTelemetryFieldValue(p2, p3, "channel", "")

	VirtualEvents.fireVirtualEventJoined({
		virtualEventId = actionTelemetryFieldValue,
		universeId = tostring(actionTelemetryFieldValue2),
		channel = tostring(actionTelemetryFieldValue3)
	})
end
