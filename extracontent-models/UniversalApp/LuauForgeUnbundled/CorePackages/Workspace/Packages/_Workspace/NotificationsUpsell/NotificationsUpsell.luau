return {
	setupNotificationsUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/setupNotificationsUpsell"),
	setupPushNotificationsUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/setupPushNotificationsUpsell"),
	NotificationsUpsellConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/NotificationsUpsellConstants"),
	ModalEventConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Analytics/ModalEventConstants"),
	PushUpsellEventConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Analytics/RobloxTelemetryConfigs/PushUpsellEventName"),
	requestPushNotificationPermission = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/requestPushNotificationPermission"),
	NativePushNotificationPermissionPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/NativePushNotificationPermissionPrompt")
}
