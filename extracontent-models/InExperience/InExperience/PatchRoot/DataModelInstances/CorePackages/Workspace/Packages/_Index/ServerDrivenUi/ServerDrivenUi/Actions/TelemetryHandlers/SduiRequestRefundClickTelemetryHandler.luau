local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local t = require(Parent.t)
local sendRequestRefundClickEvent = require(Parent.DiscoveryAnalytics).Events.sendRequestRefundClickEvent
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue
local v7 = t.strictInterface({
	placeId = t.union(t.string, t.number),
	eventContext = t.string
})

return function(p1, p2, p3) -- line: 20
	-- upvalues: getActionTelemetryFieldValue (copy), v7 (copy), SduiErrorType (copy), sendRequestRefundClickEvent (copy)
	local v11 = getActionTelemetryFieldValue(p1, p2, "placeId")
	local v12 = getActionTelemetryFieldValue(p1, p2, "eventContext")
	local v13, v14 = v7({
		placeId = v11,
		eventContext = v12
	})

	if not v13 then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = "SduiRequestRefundClickTelemetryHandler",
			message = v14
		}, p3.appPage)
	end

	sendRequestRefundClickEvent({
		placeId = not v11 and "" or tostring(v11)
	}, not v12 and "" or tostring(v12))
end
