local t = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/t")
local sendRequestRefundClickEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics").Events.sendRequestRefundClickEvent

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue

local strictInterface = t.strictInterface({
	placeId = t.union(t.string, t.number),
	eventContext = t.string
})

return function(p2, p3, p4)
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p2, p3, "placeId")
	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(p2, p3, "eventContext")

	local v5, v6 = strictInterface({
		placeId = actionTelemetryFieldValue,
		eventContext = actionTelemetryFieldValue2
	})

	if not v5 then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = "SduiRequestRefundClickTelemetryHandler", message = v6 },
			p4.appPage
		)
	end

	sendRequestRefundClickEvent({
		placeId = not actionTelemetryFieldValue and "" or tostring(actionTelemetryFieldValue)
	}, not actionTelemetryFieldValue2 and "" or tostring(actionTelemetryFieldValue2))
end
