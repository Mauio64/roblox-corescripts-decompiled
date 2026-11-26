local module = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/NavigationActions/RegisterCustomGetStateForAction")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/Enums/CustomGetStateForAction")

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/AvatarRoute/Types")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/Types/NavigationType")

return {
	AvatarRoute = {
		Context = { AvatarRouteContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/AvatarRoute/Context/AvatarRouteContext") },
		Hooks = { useAvatarRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/AvatarRoute/Hooks/useAvatarRoute") },
		RouteInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/AvatarRoute/RouteInfo"),
		AvatarRoute = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/AvatarRoute/AvatarRoute"),
		AvatarScreenProperties = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/AvatarRoute/AvatarScreenProperties"),
		getActiveAvatarScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/AvatarRoute/getActiveAvatarScreen")
	},
	Enums = {
		AvatarScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/Enums/AvatarScreen"),
		AvatarEditorNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/Enums/AvatarEditorNavigation"),
		AvatarRootNavigationAction = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/Enums/AvatarRootNavigationAction"),
		UnifiedLoggingSurface = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/Enums/UnifiedLoggingSurface"),
		CustomGetStateForAction = module2
	},
	Actions = {
		DeregisterCustomGetStateForAction = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/NavigationActions/DeregisterCustomGetStateForAction"),
		RegisterCustomGetStateForAction = module,
		ClearScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/NavigationActions/ClearScreens"),
		AvatarExperienceActions = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/NavigationActions/AvatarExperienceActions")
	},
	BackHandlerRegistry = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/BackHandlerRegistry"),
	Debug = { logOnOverlayClosed = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/Debug/logOnOverlayClosed") },
	withMappedNavigationParams = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/withMappedNavigationParams"),
	Thunks = {
		NavigateWithLock = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/Thunks/NavigateWithLock"),
		NavigateDownToAvatarScreen = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/Thunks/NavigateDownToAvatarScreen")
	},
	Utils = { closeGiftSendFlow = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceNavigation/AvatarExperienceNavigation/Utils/closeGiftSendFlow") }
}
