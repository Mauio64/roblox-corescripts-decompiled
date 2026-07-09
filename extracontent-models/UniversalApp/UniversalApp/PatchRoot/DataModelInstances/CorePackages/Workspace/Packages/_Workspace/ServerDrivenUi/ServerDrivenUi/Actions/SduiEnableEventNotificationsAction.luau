local Parent = script:FindFirstAncestor("ServerDrivenUi").Parent
local SduiCoreSystem = require(Parent.SduiCoreSystem)
local VirtualEvents = require(Parent.VirtualEvents)
local CloseCentralOverlay = require(Parent.CentralOverlay).Thunks.CloseCentralOverlay
local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers

local function SduiEnableEventNotificationsAction(p1, _, p3) -- line: 17
	-- upvalues: SduiErrorType (copy), VirtualEvents (copy), SduiParseHelpers (copy), CloseCentralOverlay (copy)
	local v11 = p1 and p1.actionParams or nil

	if v11 == nil then
		p3.dependencies.logger.reportError(SduiErrorType.InvalidActionParams, {
			name = "EnableEventNotifications",
			message = "Missing actionParams"
		}, p3.appPage)

		return
	end

	assert(v11, "actionParams must exist")

	local eventId = v11.eventId
	local universeId = v11.universeId
	local channel = v11.channel
	local networking = p3.dependencies.networking

	VirtualEvents.enablePushNotifications(networking):catch(function(p4) -- line: 39
		-- upvalues: p3 (copy), SduiErrorType (copy), SduiParseHelpers (copy)
		p3.dependencies.logger.reportError(SduiErrorType.ActionNetworkRequestFailed, {
			name = "EnableEventNotifications",
			message = "enablePushNotifications failed: " .. SduiParseHelpers.stringifyValue(p4)
		}, p3.appPage)
	end)
	VirtualEvents.neverShowNotificationsModalAgain(networking):catch(function(p5) -- line: 46
		-- upvalues: p3 (copy), SduiErrorType (copy), SduiParseHelpers (copy)
		p3.dependencies.logger.reportError(SduiErrorType.ActionNetworkRequestFailed, {
			name = "EnableEventNotifications",
			message = "neverShowNotificationsModalAgain failed: " .. SduiParseHelpers.stringifyValue(p5)
		}, p3.appPage)
	end)
	VirtualEvents.fireEventNotificationEnabled({
		virtualEventId = if not eventId then nil else tostring(eventId),
		universeId = if not universeId then nil else tostring(universeId),
		channel = if not channel then nil else tostring(channel)
	})
	p3.dependencies.dispatch(CloseCentralOverlay())
end

return SduiEnableEventNotificationsAction
