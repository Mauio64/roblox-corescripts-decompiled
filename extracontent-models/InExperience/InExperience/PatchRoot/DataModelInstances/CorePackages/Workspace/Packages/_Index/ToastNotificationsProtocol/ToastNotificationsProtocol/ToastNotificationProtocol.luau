local MessageBusService = game:GetService("MessageBusService")
local Players = game:GetService("Players")
local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent

require(scriptParent.ToastNotificationProtocolTypes)

local ToastNotificationProtocolConstants = require(scriptParent.ToastNotificationProtocolConstants)
local getPlatformTarget = require(scriptParentParent.Analytics).getPlatformTarget
local t1 = {}

t1.__index = t1
game:DefineFastFlag("LuaAppInitializeToastNotificationEventParams2", false)

function t1.new() -- line: 18
	-- upvalues: t1 (copy)
	return (setmetatable({}, t1))
end
function t1.setupNotifications(_, p2) -- line: 23
	-- upvalues: getPlatformTarget (copy), Players (copy), MessageBusService (copy), ToastNotificationProtocolConstants (copy)
	if #p2 > 0 then
		local v10 = nil
		local v11 = nil

		if game:GetFastFlag("LuaAppInitializeToastNotificationEventParams2") then
			v11 = getPlatformTarget()
			v10 = not Players.LocalPlayer and "" or tostring(Players.LocalPlayer.UserId)
		end

		MessageBusService:Publish(ToastNotificationProtocolConstants.MESSAGE_INIT_TOAST_NOTIF, {
			channels = p2,
			userId = v10,
			platform = v11
		})
	end
end
function t1.updateNotification(_: {[any]: any}, s1: string, s2: string) -- line: 39
	-- upvalues: MessageBusService (copy), ToastNotificationProtocolConstants (copy)
	if s1 and s2 then
		MessageBusService:Publish(ToastNotificationProtocolConstants.MESSAGE_UPDATE_TOAST_NOTIF, {
			notificationId = s1,
			stateName = s2
		})
	end
end
function t1.voltronBroadcast(_: {[any]: any}, s3: string?, p3) -- line: 48
	-- upvalues: MessageBusService (copy)
	if s3 then
		MessageBusService:Publish(s3, p3)
	end
end
function t1.dismissNotification(_: {[any]: any}, s4: string) -- line: 54
	-- upvalues: MessageBusService (copy), ToastNotificationProtocolConstants (copy)
	if s4 then
		MessageBusService:Publish(ToastNotificationProtocolConstants.MESSAGE_DISMISS_TOAST_NOTIF, {
			notificationId = s4
		})
	end
end
function t1.listenToDisplayNotification(_: {[any]: any}, p4: ((...any) -> ...any)) -- line: 62
	-- upvalues: MessageBusService (copy), ToastNotificationProtocolConstants (copy)
	return MessageBusService:Subscribe(ToastNotificationProtocolConstants.MESSAGE_DISPLAY_TOAST_NOTIF, p4, false, true)
end
function t1.listenToDismissNotification(_: {[any]: any}, p5: ((...any) -> ...any)) -- line: 66
	-- upvalues: MessageBusService (copy), ToastNotificationProtocolConstants (copy)
	return MessageBusService:Subscribe(ToastNotificationProtocolConstants.MESSAGE_DISMISS_TOAST_NOTIF, p5, false, true)
end

t1.default = t1.new()

return t1
