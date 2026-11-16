local default = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/LoggingProtocol").default
local NotificationsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsCommon")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/SharedFlags")

local ModalEventConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Analytics/ModalEventConstants")
local PushUpsellEventName = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Analytics/RobloxTelemetryConfigs/PushUpsellEventName")
local NotificationsUpsellConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/NotificationsUpsellConstants")
local setupPushNotificationsUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/setupPushNotificationsUpsell")

local fFlagPushNotificationsUpsellHomePromptsExperiment = SharedFlags.FFlagPushNotificationsUpsellHomePromptsExperiment
local flag = false

local function requestPermission()
	if flag then
		return
	end

	flag = true
	NotificationsCommon.ixpHelper.logUserLayerExposure(SharedFlags.FStringPushNotificationsUpsellHomePromptsExperimentLayer)

	default:logRobloxTelemetryEvent(
		PushUpsellEventName,
		{},
		{ [ModalEventConstants.ActionType] = ModalEventConstants.ShouldRequest, [ModalEventConstants.EntryPoint] = "Home" },
		ModalEventConstants.ModalContextSysUpsell
	)
	setupPushNotificationsUpsell.OpenModal(NotificationsUpsellConstants.ModalKey.PushUpsellHome, false, "Home")
end

return {
	isEnabled = function()
		return fFlagPushNotificationsUpsellHomePromptsExperiment
			and SharedFlags.FFlagNotificationsUpsellUseRequestPushPermissionHelper
	end,
	handlePromptsResponse = function(p2)
		if
			not (fFlagPushNotificationsUpsellHomePromptsExperiment and SharedFlags.FFlagNotificationsUpsellUseRequestPushPermissionHelper)
			or type(p2) ~= "table"
		then
			return
		end

		local custom_prompts = p2.custom_prompts

		if
			type(custom_prompts) ~= "table"
			or custom_prompts[SharedFlags.FStringPushNotificationsUpsellHomeCustomPromptName] == nil
		then
			return
		end

		requestPermission()
	end
}
