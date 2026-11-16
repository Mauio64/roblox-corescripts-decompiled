local module = require("@game/CorePackages/Workspace/Packages/_Index/AppStartup/AppStartup/AppStartupSequence")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/AppStartup/AppStartup/Components/PlatformAccountRouter")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/AppStartup/AppStartup/Components/StartupMessage/StartupMessageContainer")
local module4 = require("@game/CorePackages/Workspace/Packages/_Index/AppStartup/AppStartup/navigateWithPlatformAccount")
local module5 = require("@game/CorePackages/Workspace/Packages/_Index/AppStartup/AppStartup/Reducers")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/AppStartup/AppStartup/Actions")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/AppStartup/AppStartup/Enums")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/AppStartup/AppStartup/Hooks")

return {
	AppStartupSequence = module,
	PlatformAccountRouter = module2,
	StartupMessageContainer = module3,
	PostAppInteractiveContainer = require("@game/CorePackages/Workspace/Packages/_Index/AppStartup/AppStartup/Components/PostAppInteractiveContainer"),
	navigateWithPlatformAccount = module4,
	Reducers = module5,
	Actions = module6,
	Hooks = module8,
	Enums = module7
}
