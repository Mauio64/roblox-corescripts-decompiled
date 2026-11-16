local module = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/PeekViewState")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/PeekView")
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/PeekViewWithTopBar")
return {
	analytics = { peekViewDismissedEvent = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/analytics/peekViewDismissedEvent") },
	PeekViewState = module,
	PeekView = module2,
	PeekViewWithTopBar = module3,
	Scrim = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/Scrim")
}
