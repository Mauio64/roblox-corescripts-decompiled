local parent = script.Parent.Parent
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default
local React = require(parent.React)
local SharedFlags = require(parent.SharedFlags)
local Signals = require(parent.Signals)
local SignalsUtils = require(parent.SignalsUtils)
local createSessionScopedSignal = SignalsUtils.createSessionScopedSignal

local ModalEventConstants = require(script.Parent.Analytics.ModalEventConstants)
local PushUpsellEventName = require(script.Parent.Analytics.RobloxTelemetryConfigs.PushUpsellEventName)
local NotificationsUpsellConstants = require(script.Parent.NotificationsUpsellConstants)
local setupPushNotificationsUpsell = require(script.Parent.setupPushNotificationsUpsell)

local v = {
	[ModalEventConstants.EntryPoint] = ModalEventConstants.EntryPointChat,
	[ModalEventConstants.Variant] = ModalEventConstants.VariantLegacy
}

local sessionScopedSignal, v2 = createSessionScopedSignal(false)

local sessionScopedSignal2, v3 = createSessionScopedSignal(false)

local function openLegacyUpsell() -- 1 equivalent call inferred from this helper
	local pushUpsellChat = NotificationsUpsellConstants.ModalKey.PushUpsellChat
	setupPushNotificationsUpsell.ShouldShowUpsell(pushUpsellChat):andThen(function(p)
		if not p then
			return
		end

		default:logRobloxTelemetryEvent(
			PushUpsellEventName,
			{},
			{
				[ModalEventConstants.ActionType] = ModalEventConstants.ShouldRequest,
				[ModalEventConstants.EntryPoint] = ModalEventConstants.EntryPointChat,
				[ModalEventConstants.Variant] = ModalEventConstants.VariantLegacy
			},
			ModalEventConstants.ModalContextPushEduUpsell
		)
		setupPushNotificationsUpsell.OpenModal(pushUpsellChat, true, ModalEventConstants.EntryPointChat, v)
	end)
end

local ChatPushUpsellLegacyPrompt = {}

function ChatPushUpsellLegacyPrompt.handlePromptsResponse(p)
	if sessionScopedSignal(false) or type(p) ~= "table" then
		return
	end

	local custom_prompts = p.custom_prompts

	if
		type(custom_prompts) ~= "table"
		or custom_prompts[SharedFlags.FStringChatPushUpsellLegacyCustomPromptName] == nil
	then
		return
	end

	v2(true)
	v3(true)
end

function ChatPushUpsellLegacyPrompt.useOpenPendingLegacyUpsell()
	React.useEffect(function()
		return Signals.createEffect(function(p)
			if sessionScopedSignal2(p) then
				v3(false)
				openLegacyUpsell() -- inferred equivalent call
			end
		end)
	end, {})
end

return ChatPushUpsellLegacyPrompt
