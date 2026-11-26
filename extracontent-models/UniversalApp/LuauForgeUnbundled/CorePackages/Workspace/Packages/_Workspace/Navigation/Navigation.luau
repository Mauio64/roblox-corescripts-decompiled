require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/types")

local module = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/ViewState")

local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/createSignalsNavigationObject")

local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/createProjectedNavigationObject")

return {
	canGoBack = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/canGoBack"),
	getActiveChildNavigationOptionsRecursively = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/getActiveChildNavigationOptionsRecursively"),
	getActiveRoutes = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/getActiveRoutes"),
	getCurrentNavigationState = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/getCurrentNavigationState"),
	getCurrentRouteKey = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/getCurrentRouteKey"),
	getCurrentRouteState = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/getCurrentRouteState"),
	getFocusedRoutes = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/getFocusedRoutes"),
	getRootNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/getRootNavigation"),
	getRouteKeyIsInNavigationState = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/getRouteKeyIsInNavigationState"),
	getRouteIsActive = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/getRouteIsActive"),
	getRouteIsFocused = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/getRouteIsFocused"),
	useEarlyIsFocused = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/useEarlyIsFocused"),
	useNavigation = require("@game/CorePackages/Packages/_Index/RoactNavigation/RoactNavigation/views/useNavigation"),
	useNavigationFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/useNavigationFocus"),
	useRouteName = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/useRouteName"),
	useStackScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/useStackScreens"),
	TestUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/TestUtils"),
	inspectRouteEntry = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/inspectRouteEntry"),
	ViewState = module,
	createSignalsNavigationObject = module2,
	createProjectedNavigationObject = module3,
	SignalsNavigationContainer = require("@game/CorePackages/Workspace/Packages/_Workspace/Navigation/Navigation/SignalsNavigationContainer")
}
