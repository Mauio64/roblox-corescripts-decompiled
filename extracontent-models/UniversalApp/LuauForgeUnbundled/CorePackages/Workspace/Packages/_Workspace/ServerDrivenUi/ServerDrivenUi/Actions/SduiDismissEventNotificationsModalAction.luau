local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local VirtualEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/VirtualEvents")
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CentralOverlay").Thunks.CloseCentralOverlay

local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiParseHelpers = SduiCoreSystem.SduiParseHelpers

local function SduiDismissEventNotificationsModalAction(p2, p3, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = "DismissEventNotificationsModal",
				message = "Missing actionParams"
			},
			p4.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	if actionParams.eventId == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{
				name = "DismissEventNotificationsModal",
				message = "Missing eventId",
				propName = "eventId"
			},
			p4.appPage
		)
	end

	local networking = p4.dependencies.networking

	VirtualEvents.neverShowNotificationsModalAgain(networking):catch(function(p5)
		p4.dependencies.logger.reportError(sduiErrorType.ActionNetworkRequestFailed, {
			name = "DismissEventNotificationsModal",
			message = "neverShowNotificationsModalAgain failed: " .. sduiParseHelpers.stringifyValue(p5)
		}, p4.appPage)
	end)

	p4.dependencies.dispatch(closeCentralOverlay())
end

return SduiDismissEventNotificationsModalAction
