local module = require("@game/CorePackages/Workspace/Packages/_Workspace/Chrome/Chrome/Enabled")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/Chrome/Chrome/Common/Enums")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/Chrome/Chrome/Flags")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/Chrome/Chrome/FocusUtils")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/Chrome/Chrome/Hooks")
require("@game/CorePackages/Workspace/Packages/_Workspace/Chrome/Chrome/Common/Types")
return {
	Enabled = module,
	Enums = module2,
	Flags = module3,
	FocusUtils = module4,
	Hooks = module5,
	UnibarStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/Chrome/Chrome/UnibarStyle")
}
