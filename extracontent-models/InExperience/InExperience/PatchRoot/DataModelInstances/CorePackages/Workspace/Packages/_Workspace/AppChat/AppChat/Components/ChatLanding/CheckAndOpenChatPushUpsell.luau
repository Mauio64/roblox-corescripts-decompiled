local IXPService = game:GetService("IXPService")
local AppChat = script:FindFirstAncestor("AppChat")
local parent = AppChat.Parent
local React = require(parent.React)
local Navigation = require(parent.Navigation)
local useNavigation = Navigation.useNavigation
local Navigation2 = require(parent.Navigation)
local useNavigationFocus = Navigation2.useNavigationFocus
local RoactNavigation = require(parent.RoactNavigation)

local RoactAppExperiment = require(parent.RoactAppExperiment)
local useUserExperiment = RoactAppExperiment.useUserExperiment
local ExperimentLayers = require(parent.ExperimentLayers)
local AppUserLayers = ExperimentLayers.AppUserLayers
local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local LoggingProtocol = require(parent.LoggingProtocol)
local default = LoggingProtocol.default

local NotificationsUpsell = require(parent.NotificationsUpsell)
local useChatIsVisible = require(AppChat.Hooks.useChatIsVisible)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local PushUpsellEventConfig = NotificationsUpsell.PushUpsellEventConfig
local ModalEventConstants = NotificationsUpsell.ModalEventConstants
local setupPushNotificationsUpsell = NotificationsUpsell.setupPushNotificationsUpsell
local NotificationsUpsellConstants = NotificationsUpsell.NotificationsUpsellConstants

local SharedFlags = require(parent.SharedFlags)
local GetFStringPushUpsellChatVariantName = SharedFlags.GetFStringPushUpsellChatVariantName

local function CheckAndOpenChatPushUpsell()
	local v = useNavigationFocus()
	local v2 = useNavigation()
	local v3 = useChatIsVisible()
	local v4 = useIsInExperience()
	local state, setState = React.useState(false)

	local v5 = useUserExperiment({ AppUserLayers.SocialAppChat }, function(p)
		return {
			pushUpsellChatVariant = (p[AppUserLayers.SocialAppChat] or {})[GetFStringPushUpsellChatVariantName()] or -1
		}
	end)

	React.useEffect(function()
		local v6 = v2.addListener(RoactNavigation.Events.WillBlur, function(p)
			if p.action.routeName == "ChatConversation" then
				setState(true)
			end
		end)

		return function()
			v6.remove()
		end
	end, {})

	local function showUpsellOnChatLanding()
		setupPushNotificationsUpsell.ShouldShowUpsell(NotificationsUpsellConstants.ModalKey.PushUpsellChat):andThen(function(p)
			if not p then
				return
			end

			IXPService:LogUserLayerExposure(AppUserLayers.SocialAppChat)
			default:logRobloxTelemetryEvent(
				PushUpsellEventConfig,
				{},
				{
					[ModalEventConstants.ActionType] = ModalEventConstants.ShouldRequest,
					[ModalEventConstants.EntryPoint] = AppPage.Chat
				},
				ModalEventConstants.ModalContextPushEduUpsell
			)

			setupPushNotificationsUpsell.OpenModal(
				NotificationsUpsellConstants.ModalKey.PushUpsellChat,
				true,
				AppPage.Chat
			)
		end)
	end

	local function showUpsellWhenReturnFromConversation()
		if not state then
			return
		end

		setState(false)
		setupPushNotificationsUpsell.ShouldShowUpsell(NotificationsUpsellConstants.ModalKey.PushUpsellChat):andThen(function(p)
			if not p then
				return
			end

			IXPService:LogUserLayerExposure(AppUserLayers.SocialAppChat)
			default:logRobloxTelemetryEvent(
				PushUpsellEventConfig,
				{},
				{
					[ModalEventConstants.ActionType] = ModalEventConstants.ShouldRequest,
					[ModalEventConstants.EntryPoint] = "ChatConversation"
				},
				ModalEventConstants.ModalContextPushEduUpsell
			)

			setupPushNotificationsUpsell.OpenModal(
				NotificationsUpsellConstants.ModalKey.PushUpsellChat,
				true,
				"ChatConversation"
			)
		end)
	end

	React.useEffect(function()
		if not v3 or not v or v4 or v5.pushUpsellChatVariant == nil or v5.pushUpsellChatVariant < 0 then
			return
		end

		if v5.pushUpsellChatVariant == 1 then
			setupPushNotificationsUpsell.ShouldShowUpsell(NotificationsUpsellConstants.ModalKey.PushUpsellChat):andThen(function(p)
				if not p then
					return
				end

				IXPService:LogUserLayerExposure(AppUserLayers.SocialAppChat)
				default:logRobloxTelemetryEvent(
					PushUpsellEventConfig,
					{},
					{
						[ModalEventConstants.ActionType] = ModalEventConstants.ShouldRequest,
						[ModalEventConstants.EntryPoint] = AppPage.Chat
					},
					ModalEventConstants.ModalContextPushEduUpsell
				)

				setupPushNotificationsUpsell.OpenModal(
					NotificationsUpsellConstants.ModalKey.PushUpsellChat,
					true,
					AppPage.Chat
				)
			end)
		elseif v5.pushUpsellChatVariant == 2 then
			if not state then
				return
			end

			setState(false)
			setupPushNotificationsUpsell.ShouldShowUpsell(NotificationsUpsellConstants.ModalKey.PushUpsellChat):andThen(function(p)
				if not p then
					return
				end

				IXPService:LogUserLayerExposure(AppUserLayers.SocialAppChat)
				default:logRobloxTelemetryEvent(
					PushUpsellEventConfig,
					{},
					{
						[ModalEventConstants.ActionType] = ModalEventConstants.ShouldRequest,
						[ModalEventConstants.EntryPoint] = "ChatConversation"
					},
					ModalEventConstants.ModalContextPushEduUpsell
				)

				setupPushNotificationsUpsell.OpenModal(
					NotificationsUpsellConstants.ModalKey.PushUpsellChat,
					true,
					"ChatConversation"
				)
			end)
		end
	end, { v3, v })
end

return CheckAndOpenChatPushUpsell
