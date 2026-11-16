local MessageBusService = game:GetService("MessageBusService")

local Players = game:GetService("Players")
local parent = script.Parent
local parent2 = parent.Parent

require(parent.ToastNotificationProtocolTypes)
local ToastNotificationProtocolConstants = require(parent.ToastNotificationProtocolConstants)
local Analytics = require(parent2.Analytics)
local getPlatformTarget = Analytics.getPlatformTarget

local ToastNotificationProtocol = {}
ToastNotificationProtocol.__index = ToastNotificationProtocol

game:DefineFastFlag("LuaAppInitializeToastNotificationEventParams2", false)

function ToastNotificationProtocol.new()
	return (setmetatable({}, ToastNotificationProtocol))
end

function ToastNotificationProtocol.setupNotifications(_, channels)
	if #channels > 0 then
		local platform, userId

		if game:GetFastFlag("LuaAppInitializeToastNotificationEventParams2") then
			platform = getPlatformTarget()

			if Players.LocalPlayer then
				userId = tostring(Players.LocalPlayer.UserId)
			else
				userId = ""
			end
		end

		MessageBusService:Publish(ToastNotificationProtocolConstants.MESSAGE_INIT_TOAST_NOTIF, {
			channels = channels,
			userId = userId,
			platform = platform
		})
	end
end

function ToastNotificationProtocol.updateNotification(_, notificationId: string, stateName: string)
	if notificationId and stateName then
		MessageBusService:Publish(ToastNotificationProtocolConstants.MESSAGE_UPDATE_TOAST_NOTIF, {
			notificationId = notificationId,
			stateName = stateName
		})
	end
end

function ToastNotificationProtocol.voltronBroadcast(_, p: string?, p2)
	if p then
		MessageBusService:Publish(p, p2)
	end
end

function ToastNotificationProtocol.dismissNotification(_, notificationId: string)
	if notificationId then
		MessageBusService:Publish(ToastNotificationProtocolConstants.MESSAGE_DISMISS_TOAST_NOTIF, {
			notificationId = notificationId
		})
	end
end

function ToastNotificationProtocol.listenToDisplayNotification(_, callback)
	return MessageBusService:Subscribe(
		ToastNotificationProtocolConstants.MESSAGE_DISPLAY_TOAST_NOTIF,
		callback,
		false,
		true
	)
end

function ToastNotificationProtocol.listenToDismissNotification(_, callback)
	return MessageBusService:Subscribe(
		ToastNotificationProtocolConstants.MESSAGE_DISMISS_TOAST_NOTIF,
		callback,
		false,
		true
	)
end

ToastNotificationProtocol.default = ToastNotificationProtocol.new()

return ToastNotificationProtocol
