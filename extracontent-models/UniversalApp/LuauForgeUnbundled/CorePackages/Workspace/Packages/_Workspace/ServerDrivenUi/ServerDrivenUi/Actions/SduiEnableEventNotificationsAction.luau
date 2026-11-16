local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiCoreSystem")
local VirtualEvents = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/VirtualEvents")
local closeCentralOverlay = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/CentralOverlay").Thunks.CloseCentralOverlay

local sduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local sduiParseHelpers = SduiCoreSystem.SduiParseHelpers

local function SduiEnableEventNotificationsAction(p2, p3, p4)
	local actionParams = p2 and p2.actionParams or nil

	if actionParams == nil then
		p4.dependencies.logger.reportError(
			sduiErrorType.InvalidActionParams,
			{ name = "EnableEventNotifications", message = "Missing actionParams" },
			p4.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	local eventId = actionParams.eventId
	local universeId = actionParams.universeId
	local channel = actionParams.channel

	local networking = p4.dependencies.networking

	VirtualEvents.enablePushNotifications(networking):catch(function(p5)
		p4.dependencies.logger.reportError(sduiErrorType.ActionNetworkRequestFailed, {
			name = "EnableEventNotifications",
			message = "enablePushNotifications failed: " .. sduiParseHelpers.stringifyValue(p5)
		}, p4.appPage)
	end)

	VirtualEvents.neverShowNotificationsModalAgain(networking):catch(function(p5)
		p4.dependencies.logger.reportError(sduiErrorType.ActionNetworkRequestFailed, {
			name = "EnableEventNotifications",
			message = "neverShowNotificationsModalAgain failed: " .. sduiParseHelpers.stringifyValue(p5)
		}, p4.appPage)
	end)

	local fireEventNotificationEnabled = VirtualEvents.fireEventNotificationEnabled
	local v6 = if eventId then tostring(eventId) else nil
	local v7 = if universeId then tostring(universeId) else nil
	local v8 = if channel then tostring(channel) else nil
	fireEventNotificationEnabled({ virtualEventId = v6, universeId = v7, channel = v8 })

	p4.dependencies.dispatch(closeCentralOverlay())
end

return SduiEnableEventNotificationsAction
