require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Components/AppNavItem")

return {
	Placement = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Enum/Placement"),
	AppNavBar = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Components/AppNavBar"),
	BottomBarInsetBackground = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Components/BottomBarInsetBackground"),
	StudioCTAIcon = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Components/StudioCTAIcon"),
	useNavBarPlacement = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Hooks/useNavBarPlacement"),
	useNavBarSize = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Hooks/useNavBarSize"),
	VisibilityControl = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/VisibilityControl"),
	Constants = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Constants"),
	Mocks = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Mocks"),
	getScrollAwayEnabled = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/getScrollAwayEnabled"),
	getAppNavRootName = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Utils/getAppNavRootName"),
	getAppNavCurrentPage = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Utils/getAppNavCurrentPage"),
	AppNavTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/AppNavBar/AppNavBar/Telemetry/AppNavTelemetry")
}
