local module = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppUpdate/RobloxAppUpdate/Types")

return {
	AppUpdateServiceWrapper = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppUpdate/RobloxAppUpdate/AppUpdateServiceWrapper"),
	Thunks = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppUpdate/RobloxAppUpdate/Thunks"),
	Types = module,
	UpdateMessageType = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppUpdate/RobloxAppUpdate/UpdateMessageType"),
	HandleUpdate = require("@game/CorePackages/Workspace/Packages/_Index/RobloxAppUpdate/RobloxAppUpdate/HandleUpdate")
}
