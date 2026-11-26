require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/type")
local module = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/DeeplinkTapListeners")

return {
	dependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/dependencies"),
	ReducerDependencies = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/utils/ReducerDependencies"),
	LocalizationHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/utils/StringLocalizationHelper"),
	DeeplinkConfirmationModal = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/components/DeeplinkConfirmationModal"),
	JoinExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/JoinExperience"),
	DeeplinkTapListeners = module,
	useDeeplinkTapListener = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/useDeeplinkTapListener"),
	Debounce = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/utils/debounce"),
	Throttle = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/utils/throttle"),
	DeviceInfo = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/utils/deviceInfo"),
	NotificationCardProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/context/NotificationCardProvider"),
	NotificationCard = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/components/NotificationCard"),
	NotificationHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/utils/NotificationHelper"),
	type = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/type"),
	constants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/constants"),
	FFlagNotificationThumbnailUseProfileFrameThumbnail = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/Flags/FFlagNotificationThumbnailUseProfileFrameThumbnail"),
	FFlagNotificationDeeplinkTapListenersEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/Flags/FFlagNotificationDeeplinkTapListenersEnabled"),
	ixpHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/utils/ixpHelper"),
	sendEventDeferred = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/analytics/sendEventDeferred"),
	GetGameInvitesStatusStore = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsCommon/NotificationsCommon/Stores/GetGameInvitesStatusStore")
}
