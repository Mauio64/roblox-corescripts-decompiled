local parent = script:FindFirstAncestor("ServerDrivenUi").Parent

local SduiCoreSystem = require(parent.SduiCoreSystem)
local VirtualEvents = require(parent.VirtualEvents)
local CentralOverlay = require(parent.CentralOverlay)
local CloseCentralOverlay = CentralOverlay.Thunks.CloseCentralOverlay

local SduiErrorType = SduiCoreSystem.SduiErrors.SduiErrorType
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers

local function SduiEnableEventNotificationsAction(p, _, p2)
	local actionParams = p and p.actionParams or nil

	if actionParams == nil then
		p2.dependencies.logger.reportError(
			SduiErrorType.InvalidActionParams,
			{ name = "EnableEventNotifications", message = "Missing actionParams" },
			p2.appPage
		)
		return
	end

	assert(actionParams, "actionParams must exist")

	local eventId = actionParams.eventId
	local universeId = actionParams.universeId
	local channel = actionParams.channel

	local networking = p2.dependencies.networking

	VirtualEvents.enablePushNotifications(networking):catch(function(p3)
		p2.dependencies.logger.reportError(SduiErrorType.ActionNetworkRequestFailed, {
			name = "EnableEventNotifications",
			message = "enablePushNotifications failed: " .. SduiParseHelpers.stringifyValue(p3)
		}, p2.appPage)
	end)

	VirtualEvents.neverShowNotificationsModalAgain(networking):catch(function(p3)
		p2.dependencies.logger.reportError(SduiErrorType.ActionNetworkRequestFailed, {
			name = "EnableEventNotifications",
			message = "neverShowNotificationsModalAgain failed: " .. SduiParseHelpers.stringifyValue(p3)
		}, p2.appPage)
	end)

	local fireEventNotificationEnabled = VirtualEvents.fireEventNotificationEnabled
	local virtualEventId

	if eventId then
		virtualEventId = tostring(eventId)
	end

	local universeId2

	if universeId then
		universeId2 = tostring(universeId)
	end

	local channel2

	if channel then
		channel2 = tostring(channel)
	end

	fireEventNotificationEnabled({
		virtualEventId = virtualEventId,
		universeId = universeId2,
		channel = channel2
	})

	p2.dependencies.dispatch(CloseCentralOverlay())
end

return SduiEnableEventNotificationsAction
