local IXPService = game:GetService("IXPService")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local useNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation").useNavigation
local useNavigationFocus = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Navigation").useNavigationFocus
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")

local useUserExperiment = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactAppExperiment").useUserExperiment
local appUserLayers = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/ExperimentLayers").AppUserLayers
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RobloxAppEnums").AppPage
local default = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/LoggingProtocol").default

local NotificationsUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/NotificationsUpsell")
local useChatIsVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useChatIsVisible")
local useIsInExperience = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useIsInExperience")
local pushUpsellEventConfig = NotificationsUpsell.PushUpsellEventConfig
local modalEventConstants = NotificationsUpsell.ModalEventConstants
local setupPushNotificationsUpsell = NotificationsUpsell.setupPushNotificationsUpsell
local notificationsUpsellConstants = NotificationsUpsell.NotificationsUpsellConstants

local getFStringPushUpsellChatVariantName = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFStringPushUpsellChatVariantName

local function CheckAndOpenChatPushUpsell()
	local v5 = useNavigationFocus()
	local v6 = useNavigation()
	local v7 = useChatIsVisible()
	local v8 = useIsInExperience()
	local state, setState = React.useState(false)

	local v9 = useUserExperiment({ appUserLayers.SocialAppChat }, function(p2)
		return {
			pushUpsellChatVariant = (p2[appUserLayers.SocialAppChat] or {})[getFStringPushUpsellChatVariantName()] or -1
		}
	end)

	React.useEffect(function()
		local v10 = v6.addListener(RoactNavigation.Events.WillBlur, function(p2)
			if p2.action.routeName == "ChatConversation" then
				setState(true)
			end
		end)

		return function()
			v10.remove()
		end
	end, {})

	local function showUpsellOnChatLanding()
		setupPushNotificationsUpsell.ShouldShowUpsell(notificationsUpsellConstants.ModalKey.PushUpsellChat):andThen(function(p2)
			if not p2 then
				return
			end

			IXPService:LogUserLayerExposure(appUserLayers.SocialAppChat)
			default:logRobloxTelemetryEvent(
				pushUpsellEventConfig,
				{},
				{
					[modalEventConstants.ActionType] = modalEventConstants.ShouldRequest,
					[modalEventConstants.EntryPoint] = appPage.Chat
				},
				modalEventConstants.ModalContextPushEduUpsell
			)

			setupPushNotificationsUpsell.OpenModal(
				notificationsUpsellConstants.ModalKey.PushUpsellChat,
				true,
				appPage.Chat
			)
		end)
	end

	local function showUpsellWhenReturnFromConversation()
		if not state then
			return
		end

		setState(false)
		setupPushNotificationsUpsell.ShouldShowUpsell(notificationsUpsellConstants.ModalKey.PushUpsellChat):andThen(function(p2)
			if not p2 then
				return
			end

			IXPService:LogUserLayerExposure(appUserLayers.SocialAppChat)
			default:logRobloxTelemetryEvent(
				pushUpsellEventConfig,
				{},
				{
					[modalEventConstants.ActionType] = modalEventConstants.ShouldRequest,
					[modalEventConstants.EntryPoint] = "ChatConversation"
				},
				modalEventConstants.ModalContextPushEduUpsell
			)

			setupPushNotificationsUpsell.OpenModal(
				notificationsUpsellConstants.ModalKey.PushUpsellChat,
				true,
				"ChatConversation"
			)
		end)
	end

	React.useEffect(function()
		if not v7 or not v5 or v8 or v9.pushUpsellChatVariant == nil or v9.pushUpsellChatVariant < 0 then
			return
		end

		if v9.pushUpsellChatVariant == 1 then
			setupPushNotificationsUpsell.ShouldShowUpsell(notificationsUpsellConstants.ModalKey.PushUpsellChat):andThen(function(p2)
				if not p2 then
					return
				end

				IXPService:LogUserLayerExposure(appUserLayers.SocialAppChat)
				default:logRobloxTelemetryEvent(
					pushUpsellEventConfig,
					{},
					{
						[modalEventConstants.ActionType] = modalEventConstants.ShouldRequest,
						[modalEventConstants.EntryPoint] = appPage.Chat
					},
					modalEventConstants.ModalContextPushEduUpsell
				)

				setupPushNotificationsUpsell.OpenModal(
					notificationsUpsellConstants.ModalKey.PushUpsellChat,
					true,
					appPage.Chat
				)
			end)
		elseif v9.pushUpsellChatVariant == 2 then
			if not state then
				return
			end

			setState(false)
			setupPushNotificationsUpsell.ShouldShowUpsell(notificationsUpsellConstants.ModalKey.PushUpsellChat):andThen(function(p2)
				if not p2 then
					return
				end

				IXPService:LogUserLayerExposure(appUserLayers.SocialAppChat)
				default:logRobloxTelemetryEvent(
					pushUpsellEventConfig,
					{},
					{
						[modalEventConstants.ActionType] = modalEventConstants.ShouldRequest,
						[modalEventConstants.EntryPoint] = "ChatConversation"
					},
					modalEventConstants.ModalContextPushEduUpsell
				)

				setupPushNotificationsUpsell.OpenModal(
					notificationsUpsellConstants.ModalKey.PushUpsellChat,
					true,
					"ChatConversation"
				)
			end)
		end
	end, { v7, v5 })
end

return CheckAndOpenChatPushUpsell
