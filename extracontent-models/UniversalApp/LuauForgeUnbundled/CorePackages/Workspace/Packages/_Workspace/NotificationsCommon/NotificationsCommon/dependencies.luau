local module = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/UserLib")

return {
	ToastNotificationsProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/ToastNotificationsProtocol").ToastNotificationProtocol,
	React = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/React"),
	UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/UIBlox"),
	UserLib = module,
	getRbxthumbWithTypeSizeAndOptions = module.Utils.getRbxthumbWithTypeSizeAndOptions,
	UserLibConstants = module.Utils.Constants
}
