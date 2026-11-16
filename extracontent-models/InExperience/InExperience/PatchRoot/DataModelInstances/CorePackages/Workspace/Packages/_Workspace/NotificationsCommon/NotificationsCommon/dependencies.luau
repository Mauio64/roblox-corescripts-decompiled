local parent = script.Parent.Parent
local UserLib = require(parent.UserLib)

local ToastNotificationsProtocol = require(parent.ToastNotificationsProtocol)
return {
	ToastNotificationsProtocol = ToastNotificationsProtocol.ToastNotificationProtocol,
	React = require(parent.React),
	UIBlox = require(parent.UIBlox),
	UserLib = UserLib,
	getRbxthumbWithTypeSizeAndOptions = UserLib.Utils.getRbxthumbWithTypeSizeAndOptions,
	UserLibConstants = UserLib.Utils.Constants
}
