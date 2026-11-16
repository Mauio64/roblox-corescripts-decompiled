local MessageBusService = game:GetService("MessageBusService")

local Players = game:GetService("Players")

require("@game/CorePackages/Workspace/Packages/_Index/ToastNotificationsProtocol/ToastNotificationsProtocol/ToastNotificationProtocolTypes")
local ToastNotificationProtocolConstants = require("@game/CorePackages/Workspace/Packages/_Index/ToastNotificationsProtocol/ToastNotificationsProtocol/ToastNotificationProtocolConstants")
local getPlatformTarget = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotificationsProtocol/Analytics").getPlatformTarget

local class = {}
class.__index = class

game:DefineFastFlag("LuaAppInitializeToastNotificationEventParams2", false)

function class.new()
	return (setmetatable({}, class))
end

function class:setupNotifications(list)
	if #list > 0 then
		local v5, v6

		if game:GetFastFlag("LuaAppInitializeToastNotificationEventParams2") then
			v5 = getPlatformTarget()
			v6 = if Players.LocalPlayer then tostring(Players.LocalPlayer.UserId) else ""
		end

		MessageBusService:Publish(ToastNotificationProtocolConstants.MESSAGE_INIT_TOAST_NOTIF, {
			channels = list,
			userId = v6,
			platform = v5
		})
	end
end

function class:updateNotification(p3, p4)
	if p3 and p4 then
		MessageBusService:Publish(ToastNotificationProtocolConstants.MESSAGE_UPDATE_TOAST_NOTIF, {
			notificationId = p3,
			stateName = p4
		})
	end
end

function class:voltronBroadcast(p3, p4)
	if p3 then
		MessageBusService:Publish(p3, p4)
	end
end

function class.dismissNotification(p2, p3)
	if p3 then
		MessageBusService:Publish(ToastNotificationProtocolConstants.MESSAGE_DISMISS_TOAST_NOTIF, {
			notificationId = p3
		})
	end
end

function class:listenToDisplayNotification(p3)
	return MessageBusService:Subscribe(ToastNotificationProtocolConstants.MESSAGE_DISPLAY_TOAST_NOTIF, p3, false, true)
end

function class:listenToDismissNotification(p3)
	return MessageBusService:Subscribe(ToastNotificationProtocolConstants.MESSAGE_DISMISS_TOAST_NOTIF, p3, false, true)
end

class.default = class.new()

return class
