local module = require("@game/CorePackages/Workspace/Packages/_Index/AppSplitView/AppSplitView/Components/SplitView")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/AppSplitView/AppSplitView/Common/Enums")

return {
	SplitView = module,
	PaneResizer = require("@game/CorePackages/Workspace/Packages/_Index/AppSplitView/AppSplitView/Components/PaneResizer"),
	useSplitViewResize = require("@game/CorePackages/Workspace/Packages/_Index/AppSplitView/AppSplitView/Hooks/useSplitViewResize"),
	Enums = module2
}
