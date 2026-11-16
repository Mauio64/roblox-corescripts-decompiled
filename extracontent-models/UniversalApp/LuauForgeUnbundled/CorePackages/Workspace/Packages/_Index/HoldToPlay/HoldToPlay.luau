local module = require("@game/CorePackages/Workspace/Packages/_Index/HoldToPlay/HoldToPlay/HoldToPlayLauncher")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/HoldToPlay/HoldToPlay/useHoldToPlayStateAndCallbacks")
return {
	Constants = require("@game/CorePackages/Workspace/Packages/_Index/HoldToPlay/HoldToPlay/Constants"),
	HoldToPlayLauncher = module,
	HoldDetector = require("@game/CorePackages/Workspace/Packages/_Index/HoldToPlay/HoldToPlay/HoldDetector"),
	useHoldToPlayStateAndCallbacks = module2
}
