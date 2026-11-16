local parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local t = require(parent.t)
local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local sendRequestRefundClickEvent = DiscoveryAnalytics.Events.sendRequestRefundClickEvent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue

local strictInterface = t.strictInterface({
	placeId = t.union(t.string, t.number),
	eventContext = t.string
})

return function(p, p2, p3)
	local actionTelemetryFieldValue = getActionTelemetryFieldValue(p, p2, "placeId")
	local actionTelemetryFieldValue2 = getActionTelemetryFieldValue(p, p2, "eventContext")

	local v, message = strictInterface({
		placeId = actionTelemetryFieldValue,
		eventContext = actionTelemetryFieldValue2
	})

	if not v then
		p3.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = "SduiRequestRefundClickTelemetryHandler", message = message },
			p3.appPage
		)
	end

	sendRequestRefundClickEvent({
		placeId = not actionTelemetryFieldValue and "" or tostring(actionTelemetryFieldValue)
	}, not actionTelemetryFieldValue2 and "" or tostring(actionTelemetryFieldValue2))
end
