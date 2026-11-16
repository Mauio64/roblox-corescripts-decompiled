local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local DiscoveryAnalytics = require(parent.DiscoveryAnalytics)
local sendOpenLeavingRobloxModalEvent = DiscoveryAnalytics.Events.sendOpenLeavingRobloxModalEvent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local getActionTelemetryFieldValue = SduiCoreSystem.getActionTelemetryFieldValue

local v = { "assignmentId", "assignmentType", "socialLinkType", "socialLinkDisplayType" }

return function(p, p2, p3)
	local v2 = {}

	for _, v3 in v do
		if getActionTelemetryFieldValue(p, p2, v3) == nil then
			table.insert(v2, v3)
		end
	end

	if #v2 > 0 then
		p3.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = "LeavingRobloxTelemetryHandler",
				message = `Missing telemetry fields: {table.concat(v2, ", ")}`
			},
			p3.appPage
		)
	end

	sendOpenLeavingRobloxModalEvent({
		assignment_id = tonumber(getActionTelemetryFieldValue(p, p2, "assignmentId", 0)) or 0,
		assignment_type = getActionTelemetryFieldValue(p, p2, "assignmentType", ""),
		social_link_type = getActionTelemetryFieldValue(p, p2, "socialLinkType", ""),
		social_link_display_type = getActionTelemetryFieldValue(p, p2, "socialLinkDisplayType", "")
	})
end
