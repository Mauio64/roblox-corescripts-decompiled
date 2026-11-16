local AppSplitView = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/AppSplitView")

return {
	SplitPaneStore = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Stores/SplitPaneStore"),
	SplitPaneTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Telemetry/SplitPaneTelemetry"),
	useSplitLayoutStatus = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Hooks/useSplitLayoutStatus"),
	useSplitPaneRender = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Hooks/useSplitPaneRender"),
	SplitPaneContext = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Context/SplitPaneContext"),
	PaneHostContext = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Context/PaneHostContext"),
	SplitPaneNavigationLayout = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/SplitPaneNavigationLayout"),
	isSupportPaneScreen = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/isSupportPaneScreen"),
	isSupportPaneTopRoute = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/isSupportPaneTopRoute"),
	expandSupportPaneIfCollapsed = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/supportPaneInputRules").expandSupportPaneIfCollapsed,
	routeIdentityMatches = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/routeIdentityMatches"),
	SplitPaneVariant = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/SplitPaneVariant"),
	getOnScreenContextValue = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/getOnScreenContextValue"),
	OnScreenCardProvider = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/OnScreenCardProvider"),
	OnScreenStore = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Stores/OnScreenStore"),
	createNavigationHandle = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/createNavigationHandle"),
	routeIdentity = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/routeIdentity"),
	NavigateDownWithHandle = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Thunks/NavigateDownWithHandle"),
	SplitPaneSlot = AppSplitView.Enums.SplitPaneSlot,
	SplitL3SessionHelper = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/SplitL3SessionHelper"),
	SplitL3SessionManager = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/SplitL3SessionManager"),
	SupportPaneMode = AppSplitView.Enums.SupportPaneMode,
	getSplitPaneEducationalTourStore = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Stores/getSplitPaneEducationalTourStore"),
	SplitPaneEducationalTourCollapsedControl = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/SplitPaneEducationalTourCollapsedControl"),
	isSplitPaneTourSupported = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Utils/isSplitPaneTourSupported")
}
