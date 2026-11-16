local parent = script.Parent.Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default
local NotificationsCommon = require(parent.NotificationsCommon)
local SharedFlags = require(parent.SharedFlags)

local ModalEventConstants = require(script.Parent.Analytics.ModalEventConstants)
local PushUpsellEventName = require(script.Parent.Analytics.RobloxTelemetryConfigs.PushUpsellEventName)
local NotificationsUpsellConstants = require(script.Parent.NotificationsUpsellConstants)
local setupPushNotificationsUpsell = require(script.Parent.setupPushNotificationsUpsell)

local FFlagPushNotificationsUpsellHomePromptsExperiment = SharedFlags.FFlagPushNotificationsUpsellHomePromptsExperiment
local flag = false

local function isEnabled() -- 1 equivalent call inferred from this helper
	return FFlagPushNotificationsUpsellHomePromptsExperiment
		and SharedFlags.FFlagNotificationsUpsellUseRequestPushPermissionHelper
end

local function requestPermission()
	if flag then
		return
	end

	flag = true
	NotificationsCommon.ixpHelper.logUserLayerExposure(SharedFlags.FStringPushNotificationsUpsellHomePromptsExperimentLayer)

	default:logRobloxTelemetryEvent(
		PushUpsellEventName,
		{},
		{
			[ModalEventConstants.ActionType] = ModalEventConstants.ShouldRequest,
			[ModalEventConstants.EntryPoint] = "Home"
		},
		ModalEventConstants.ModalContextSysUpsell
	)
	setupPushNotificationsUpsell.OpenModal(NotificationsUpsellConstants.ModalKey.PushUpsellHome, false, "Home")
end

return {
	isEnabled = isEnabled,
	handlePromptsResponse = function(p)
		if not isEnabled() or type(p) ~= "table" then -- inferred equivalent call
			return
		end

		local custom_prompts = p.custom_prompts

		if
			type(custom_prompts) ~= "table"
			or custom_prompts[SharedFlags.FStringPushNotificationsUpsellHomeCustomPromptName] == nil
		then
			return
		end

		requestPermission()
	end
}
