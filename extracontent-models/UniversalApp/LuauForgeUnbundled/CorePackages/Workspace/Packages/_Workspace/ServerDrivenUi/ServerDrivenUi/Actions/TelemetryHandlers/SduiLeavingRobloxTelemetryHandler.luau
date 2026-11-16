local sendOpenLeavingRobloxModalEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryAnalytics").Events.sendOpenLeavingRobloxModalEvent

local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue

local v5 = {
	"assignmentId",
	"assignmentType",
	"socialLinkType",
	"socialLinkDisplayType"
}

return function(p2, p3, p4)
	local v6 = {}

	for k, v7 in v5 do
		if getActionTelemetryFieldValue(p2, p3, v7) == nil then
			table.insert(v6, v7)
		end
	end

	if #v6 > 0 then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = "LeavingRobloxTelemetryHandler",
				message = `Missing telemetry fields: {table.concat(v6, ", ")}`
			},
			p4.appPage
		)
	end

	sendOpenLeavingRobloxModalEvent({
		assignment_id = tonumber(getActionTelemetryFieldValue(p2, p3, "assignmentId", 0)) or 0,
		assignment_type = getActionTelemetryFieldValue(p2, p3, "assignmentType", ""),
		social_link_type = getActionTelemetryFieldValue(p2, p3, "socialLinkType", ""),
		social_link_display_type = getActionTelemetryFieldValue(p2, p3, "socialLinkDisplayType", "")
	})
end
