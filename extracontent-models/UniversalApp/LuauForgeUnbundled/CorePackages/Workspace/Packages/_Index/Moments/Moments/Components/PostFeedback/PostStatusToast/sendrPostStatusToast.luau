local ToastNotificationsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/ToastNotificationsProtocol")

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Constants")

local default = ToastNotificationsProtocol.ToastNotificationProtocol.default

return {
	listen = function(callback)
		local connection = default:listenToDisplayNotification(function(p2)
			if type(p2) ~= "table" then
				return
			end

			if p2.notificationType == Constants.PostStatusToastNotificationType then
				callback(p2)
			end
		end)
		return function()
			connection:Disconnect()
		end
	end,
	dismiss = function(p2)
		local notificationId = p2.notificationId

		if notificationId ~= nil then
			default:dismissNotification(notificationId)
		end
	end,
	isFailure = function(p2): boolean
		local content = p2.content
		local clientEventsPayload

		if content == nil or content.clientEventsPayload == nil then
			clientEventsPayload = p2.clientEventsPayload
		else
			clientEventsPayload = content.clientEventsPayload
		end

		return type(clientEventsPayload) == "table" and clientEventsPayload.status == "failure"
	end
}
