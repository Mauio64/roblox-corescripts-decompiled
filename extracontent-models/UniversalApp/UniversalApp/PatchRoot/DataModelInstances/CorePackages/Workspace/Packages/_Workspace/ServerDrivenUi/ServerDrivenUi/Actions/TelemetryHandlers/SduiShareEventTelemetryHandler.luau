local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local VirtualEvents = require(Parent.VirtualEvents)
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue

return function(p1, p2, p3) -- line: 16
	-- upvalues: getActionTelemetryFieldValue (copy), SduiErrorType (copy), VirtualEvents (copy)
	local v9 = getActionTelemetryFieldValue(p1, p2, "eventId")

	if v9 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = "ShareEventIconClicked",
			message = "Missing eventId for ShareEventIconClicked telemetry"
		}, p3.appPage)

		return
	end

	local v10 = getActionTelemetryFieldValue(p1, p2, "universeId", "")
	local v11 = getActionTelemetryFieldValue(p1, p2, "channel", "eventDetailsPage")

	VirtualEvents.fireShareVirtualEventIconClicked({
		virtualEventId = tostring(v9),
		universeId = tostring(v10),
		channel = tostring(v11)
	})
end
