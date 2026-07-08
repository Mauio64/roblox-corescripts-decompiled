local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local sendOpenLeavingRobloxModalEvent = require(Parent.DiscoveryAnalytics).Events.sendOpenLeavingRobloxModalEvent
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue
local t1 = {
	"assignmentId",
	"assignmentType",
	"socialLinkType",
	"socialLinkDisplayType"
}

return function(p1, p2, p3) -- line: 17
	-- upvalues: t1 (copy), getActionTelemetryFieldValue (copy), SduiErrorType (copy), sendOpenLeavingRobloxModalEvent (copy)
	local t2 = {}

	for _, v12 in t1 do
		if getActionTelemetryFieldValue(p1, p2, v12) == nil then
			table.insert(t2, v12)
		end
	end

	if #t2 > 0 then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = "LeavingRobloxTelemetryHandler",
			message = `Missing telemetry fields: { table.concat(t2, ", ") }`
		}, p3.appPage)
	end

	sendOpenLeavingRobloxModalEvent({
		assignment_id = tonumber(getActionTelemetryFieldValue(p1, p2, "assignmentId", 0)) or 0,
		assignment_type = getActionTelemetryFieldValue(p1, p2, "assignmentType", ""),
		social_link_type = getActionTelemetryFieldValue(p1, p2, "socialLinkType", ""),
		social_link_display_type = getActionTelemetryFieldValue(p1, p2, "socialLinkDisplayType", "")
	})
end
