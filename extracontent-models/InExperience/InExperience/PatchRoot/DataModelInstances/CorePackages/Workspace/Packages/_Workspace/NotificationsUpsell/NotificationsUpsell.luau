local SharedFlags = require(script.Parent.SharedFlags)

local FFlagChatPushUpsellPromptsEnabled = SharedFlags.FFlagChatPushUpsellPromptsEnabled

local NotificationsUpsell = {
	["jest.config"] = nil,
	["jest.config"] = script["jest.config"],
	setupNotificationsUpsell = require(script.setupNotificationsUpsell),
	setupPushNotificationsUpsell = require(script.setupPushNotificationsUpsell),
	NotificationsUpsellConstants = require(script.NotificationsUpsellConstants),
	ModalEventConstants = require(script.Analytics.ModalEventConstants),
	PushUpsellEventConfig = require(script.Analytics.RobloxTelemetryConfigs.PushUpsellEventName),
	requestPushNotificationPermission = require(script.requestPushNotificationPermission),
	NativePushNotificationPermissionPrompt = require(script.NativePushNotificationPermissionPrompt)
}
local chatPushUpsellLegacyPrompt

if FFlagChatPushUpsellPromptsEnabled then
	chatPushUpsellLegacyPrompt = require(script.ChatPushUpsellLegacyPrompt)
end

NotificationsUpsell.ChatPushUpsellLegacyPrompt = chatPushUpsellLegacyPrompt

NotificationsUpsell.PushPermissionClientAttributes = require(script.PushPermissionClientAttributes.buildPushPermissionClientAttributes)
NotificationsUpsell.usePushPermissionClientAttributes = require(script.PushPermissionClientAttributes.usePushPermissionClientAttributes)
return NotificationsUpsell
