local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local VirtualEvents = require(Parent.VirtualEvents)
local CloseCentralOverlay = require(Parent.CentralOverlay).Thunks.CloseCentralOverlay
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers

local function SduiDismissEventNotificationsModalAction(p1, _, p3) -- line: 17
	-- upvalues: SduiErrorType (copy), VirtualEvents (copy), SduiParseHelpers (copy), CloseCentralOverlay (copy)
	local v11 = p1 and p1.actionParams or nil

	if v11 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = "DismissEventNotificationsModal",
			message = "Missing actionParams"
		}, p3.appPage)

		return
	end

	assert(v11, "actionParams must exist")

	if v11.eventId == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = "DismissEventNotificationsModal",
			message = "Missing eventId",
			propName = "eventId"
		}, p3.appPage)
	end

	local networking = p3.dependencies.networking

	VirtualEvents.neverShowNotificationsModalAgain(networking):catch(function(p4) -- line: 44
		-- upvalues: p3 (copy), SduiErrorType (copy), SduiParseHelpers (copy)
		p3.dependencies.logger.reportError(SduiErrorType.ActionNetworkRequestFailed, {
			name = "DismissEventNotificationsModal",
			message = "neverShowNotificationsModalAgain failed: " .. SduiParseHelpers.stringifyValue(p4)
		}, p3.appPage)
	end)
	p3.dependencies.dispatch(CloseCentralOverlay())
end

return SduiDismissEventNotificationsModalAction
