local fFlagChatPushUpsellPromptsEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/SharedFlags").FFlagChatPushUpsellPromptsEnabled

local v5 = {
	setupNotificationsUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/setupNotificationsUpsell"),
	setupPushNotificationsUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/setupPushNotificationsUpsell"),
	NotificationsUpsellConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/NotificationsUpsellConstants"),
	ModalEventConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Analytics/ModalEventConstants"),
	PushUpsellEventConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Analytics/RobloxTelemetryConfigs/PushUpsellEventName"),
	requestPushNotificationPermission = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/requestPushNotificationPermission"),
	NativePushNotificationPermissionPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/NativePushNotificationPermissionPrompt"),
	ChatPushUpsellLegacyPrompt = 0,
	PushPermissionClientAttributes = 0,
	usePushPermissionClientAttributes = 0
}

local v6 = if fFlagChatPushUpsellPromptsEnabled then require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/ChatPushUpsellLegacyPrompt") else nil
v5.ChatPushUpsellLegacyPrompt = v6

v5.PushPermissionClientAttributes = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/PushPermissionClientAttributes/buildPushPermissionClientAttributes")
v5.usePushPermissionClientAttributes = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/PushPermissionClientAttributes/usePushPermissionClientAttributes")
return v5
