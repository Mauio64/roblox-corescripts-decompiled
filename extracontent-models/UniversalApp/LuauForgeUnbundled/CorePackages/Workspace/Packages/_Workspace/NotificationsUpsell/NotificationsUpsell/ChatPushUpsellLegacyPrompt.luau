local default = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/LoggingProtocol").default
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/React")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/SharedFlags")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/Signals")
local createSessionScopedSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/SignalsUtils").createSessionScopedSignal

local ModalEventConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Analytics/ModalEventConstants")
local PushUpsellEventName = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/Analytics/RobloxTelemetryConfigs/PushUpsellEventName")
local NotificationsUpsellConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/NotificationsUpsellConstants")
local setupPushNotificationsUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/NotificationsUpsell/NotificationsUpsell/setupPushNotificationsUpsell")

local v5 = {
	[ModalEventConstants.EntryPoint] = ModalEventConstants.EntryPointChat,
	[ModalEventConstants.Variant] = ModalEventConstants.VariantLegacy
}

local sessionScopedSignal, v6 = createSessionScopedSignal(false)

local sessionScopedSignal2, v7 = createSessionScopedSignal(false)

local function openLegacyUpsell()
	local pushUpsellChat = NotificationsUpsellConstants.ModalKey.PushUpsellChat
	setupPushNotificationsUpsell.ShouldShowUpsell(pushUpsellChat):andThen(function(p2)
		if not p2 then
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
		setupPushNotificationsUpsell.OpenModal(pushUpsellChat, true, ModalEventConstants.EntryPointChat, v5)
	end)
end

return {
	handlePromptsResponse = function(p2)
		if sessionScopedSignal(false) or type(p2) ~= "table" then
			return
		end

		local custom_prompts = p2.custom_prompts

		if
			type(custom_prompts) ~= "table"
			or custom_prompts[SharedFlags.FStringChatPushUpsellLegacyCustomPromptName] == nil
		then
			return
		end

		v6(true)
		v7(true)
	end,
	useOpenPendingLegacyUpsell = function()
		React.useEffect(function()
			return Signals.createEffect(function(p2)
				if sessionScopedSignal2(p2) then
					v7(false)
					local pushUpsellChat = NotificationsUpsellConstants.ModalKey.PushUpsellChat
					setupPushNotificationsUpsell.ShouldShowUpsell(pushUpsellChat):andThen(function(p3)
						if not p3 then
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
						setupPushNotificationsUpsell.OpenModal(pushUpsellChat, true, ModalEventConstants.EntryPointChat, v5)
					end)
				end
			end)
		end, {})
	end
}
