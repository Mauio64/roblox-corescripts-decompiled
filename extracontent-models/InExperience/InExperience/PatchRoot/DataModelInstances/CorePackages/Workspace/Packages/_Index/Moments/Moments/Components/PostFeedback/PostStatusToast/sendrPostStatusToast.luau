local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

local ToastNotificationsProtocol = require(parent.ToastNotificationsProtocol)

local Constants = require(Moments.Constants)

local default = ToastNotificationsProtocol.ToastNotificationProtocol.default
local SendrPostStatusToast = {}

function SendrPostStatusToast.listen(callback)
	local connection = default:listenToDisplayNotification(function(p)
		if type(p) ~= "table" then
			return
		end

		if p.notificationType == Constants.PostStatusToastNotificationType then
			callback(p)
		end
	end)
	return function()
		connection:Disconnect()
	end
end

function SendrPostStatusToast.dismiss(p)
	local notificationId = p.notificationId

	if notificationId ~= nil then
		default:dismissNotification(notificationId)
	end
end

function SendrPostStatusToast.isFailure(p): boolean
	local content = p.content
	local clientEventsPayload

	if content == nil or content.clientEventsPayload == nil then
		clientEventsPayload = p.clientEventsPayload
	else
		clientEventsPayload = content.clientEventsPayload
	end

	return type(clientEventsPayload) == "table" and clientEventsPayload.status == "failure"
end

return SendrPostStatusToast
