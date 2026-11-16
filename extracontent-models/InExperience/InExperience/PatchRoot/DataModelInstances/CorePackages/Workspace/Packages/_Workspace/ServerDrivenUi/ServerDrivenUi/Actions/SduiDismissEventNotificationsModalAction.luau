local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local VirtualEvents = require(parent.VirtualEvents)
local CentralOverlay = require(parent.CentralOverlay)
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay

local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers

local function SduiDismissEventNotificationsModalAction(p, _, p2)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = "DismissEventNotificationsModal", message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	if actionParams.eventId == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{
				name = "DismissEventNotificationsModal",
				message = "Missing eventId",
				propName = "eventId"
			},
			p2.appPage
		)
	end

	local networking = p2.dependencies.networking

	VirtualEvents.neverShowNotificationsModalAgain(networking):catch(function(p3)
		p2.dependencies.logger.reportError(SduiErrorType.ActionNetworkRequestFailed, {
			name = "DismissEventNotificationsModal",
			message = "neverShowNotificationsModalAgain failed: " .. SduiParseHelpers.stringifyValue(p3)
		}, p2.appPage)
	end)

	p2.dependencies.dispatch(CloseCentralOverlay())
end

return SduiDismissEventNotificationsModalAction
