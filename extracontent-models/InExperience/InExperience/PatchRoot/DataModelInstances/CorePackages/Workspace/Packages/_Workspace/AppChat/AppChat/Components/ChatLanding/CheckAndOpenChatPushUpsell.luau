local IXPService = game:GetService("IXPService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local React = require(AppChatParent.React)
local useNavigation = require(AppChatParent.Navigation).useNavigation
local useNavigationFocus = require(AppChatParent.Navigation).useNavigationFocus
local RoactNavigation = require(AppChatParent.RoactNavigation)
local useUserExperiment = require(AppChatParent.RoactAppExperiment).useUserExperiment
local AppUserLayers = require(AppChatParent.ExperimentLayers).AppUserLayers
local AppPage = require(AppChatParent.RobloxAppEnums).AppPage
local default = require(AppChatParent.LoggingProtocol).default
local NotificationsUpsell = require(AppChatParent.NotificationsUpsell)
local useChatIsVisible = require(AppChat.Hooks.useChatIsVisible)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local PushUpsellEventConfig = NotificationsUpsell.PushUpsellEventConfig
local ModalEventConstants = NotificationsUpsell.ModalEventConstants
local setupPushNotificationsUpsell = NotificationsUpsell.setupPushNotificationsUpsell
local NotificationsUpsellConstants = NotificationsUpsell.NotificationsUpsellConstants
local GetFStringPushUpsellChatVariantName = require(AppChatParent.SharedFlags).GetFStringPushUpsellChatVariantName

local function CheckAndOpenChatPushUpsell() -- line: 27
	-- upvalues: useNavigationFocus (copy), useNavigation (copy), useChatIsVisible (copy), useIsInExperience (copy), React (copy), useUserExperiment (copy), AppUserLayers (copy), GetFStringPushUpsellChatVariantName (copy), RoactNavigation (copy), setupPushNotificationsUpsell (copy), NotificationsUpsellConstants (copy), IXPService (copy), default (copy), PushUpsellEventConfig (copy), ModalEventConstants (copy), AppPage (copy)
	local v21 = useNavigationFocus()
	local v22 = useNavigation()
	local v23 = useChatIsVisible()
	local v24 = useIsInExperience()
	local v25, v26 = React.useState(false)
	local v27 = useUserExperiment({ AppUserLayers.SocialAppChat }, function(p1) -- line: 36
		-- upvalues: AppUserLayers (copy), GetFStringPushUpsellChatVariantName (copy)
		return {
			pushUpsellChatVariant = (p1[AppUserLayers.SocialAppChat] or {})[GetFStringPushUpsellChatVariantName()] or -1
		}
	end)

	React.useEffect(function() -- line: 45
		-- upvalues: v22 (copy), RoactNavigation (copy), v26 (copy)
		local v31 = v22.addListener(RoactNavigation.Events.WillBlur, function(p2) -- line: 46
			-- upvalues: v26 (copy)
			if p2.action.routeName == "ChatConversation" then
				v26(true)
			end
		end)

		return function() -- line: 53
			-- upvalues: v31 (copy)
			v31.remove()
		end
	end, {})

	local function showUpsellOnChatLanding() -- line: 58
		-- upvalues: setupPushNotificationsUpsell (copy), NotificationsUpsellConstants (copy), IXPService (copy), AppUserLayers (copy), default (copy), PushUpsellEventConfig (copy), ModalEventConstants (copy), AppPage (copy)
		setupPushNotificationsUpsell.ShouldShowUpsell(NotificationsUpsellConstants.ModalKey.PushUpsellChat):andThen(function(p3) -- line: 59
			-- upvalues: IXPService (copy), AppUserLayers (copy), default (copy), PushUpsellEventConfig (copy), ModalEventConstants (copy), AppPage (copy), setupPushNotificationsUpsell (copy), NotificationsUpsellConstants (copy)
			if not p3 then
				return
			end

			IXPService:LogUserLayerExposure(AppUserLayers.SocialAppChat)
			default:logRobloxTelemetryEvent(PushUpsellEventConfig, {}, {
				[ModalEventConstants.ActionType] = ModalEventConstants.ShouldRequest,
				[ModalEventConstants.EntryPoint] = AppPage.Chat
			}, ModalEventConstants.ModalContextPushEduUpsell)
			setupPushNotificationsUpsell.OpenModal(NotificationsUpsellConstants.ModalKey.PushUpsellChat, true, AppPage.Chat)
		end)
	end
	local function showUpsellWhenReturnFromConversation() -- line: 73
		-- upvalues: v25 (copy), v26 (copy), setupPushNotificationsUpsell (copy), NotificationsUpsellConstants (copy), IXPService (copy), AppUserLayers (copy), default (copy), PushUpsellEventConfig (copy), ModalEventConstants (copy)
		if not v25 then
			return
		end

		v26(false)
		setupPushNotificationsUpsell.ShouldShowUpsell(NotificationsUpsellConstants.ModalKey.PushUpsellChat):andThen(function(p4) -- line: 79
			-- upvalues: IXPService (copy), AppUserLayers (copy), default (copy), PushUpsellEventConfig (copy), ModalEventConstants (copy), setupPushNotificationsUpsell (copy), NotificationsUpsellConstants (copy)
			if not p4 then
				return
			end

			IXPService:LogUserLayerExposure(AppUserLayers.SocialAppChat)
			default:logRobloxTelemetryEvent(PushUpsellEventConfig, {}, {
				[ModalEventConstants.ActionType] = ModalEventConstants.ShouldRequest,
				[ModalEventConstants.EntryPoint] = "ChatConversation"
			}, ModalEventConstants.ModalContextPushEduUpsell)
			setupPushNotificationsUpsell.OpenModal(NotificationsUpsellConstants.ModalKey.PushUpsellChat, true, "ChatConversation")
		end)
	end

	React.useEffect(function() -- line: 93
		-- upvalues: v23 (copy), v21 (copy), v24 (copy), v27 (copy), setupPushNotificationsUpsell (copy), NotificationsUpsellConstants (copy), IXPService (copy), AppUserLayers (copy), default (copy), PushUpsellEventConfig (copy), ModalEventConstants (copy), AppPage (copy), v25 (copy), v26 (copy)
		if not v23 or (not v21 or v24 or v27.pushUpsellChatVariant == nil or v27.pushUpsellChatVariant < 0) then
			return
		end

		if v27.pushUpsellChatVariant == 1 then
			setupPushNotificationsUpsell.ShouldShowUpsell(NotificationsUpsellConstants.ModalKey.PushUpsellChat):andThen(function(p5) -- line: 59
				-- upvalues: IXPService (copy), AppUserLayers (copy), default (copy), PushUpsellEventConfig (copy), ModalEventConstants (copy), AppPage (copy), setupPushNotificationsUpsell (copy), NotificationsUpsellConstants (copy)
				if not p5 then
					return
				end

				IXPService:LogUserLayerExposure(AppUserLayers.SocialAppChat)
				default:logRobloxTelemetryEvent(PushUpsellEventConfig, {}, {
					[ModalEventConstants.ActionType] = ModalEventConstants.ShouldRequest,
					[ModalEventConstants.EntryPoint] = AppPage.Chat
				}, ModalEventConstants.ModalContextPushEduUpsell)
				setupPushNotificationsUpsell.OpenModal(NotificationsUpsellConstants.ModalKey.PushUpsellChat, true, AppPage.Chat)
			end)

			return
		end

		if v27.pushUpsellChatVariant == 2 then
			if not v25 then
				return
			end

			v26(false)
			setupPushNotificationsUpsell.ShouldShowUpsell(NotificationsUpsellConstants.ModalKey.PushUpsellChat):andThen(function(p6) -- line: 79
				-- upvalues: IXPService (copy), AppUserLayers (copy), default (copy), PushUpsellEventConfig (copy), ModalEventConstants (copy), setupPushNotificationsUpsell (copy), NotificationsUpsellConstants (copy)
				if not p6 then
					return
				end

				IXPService:LogUserLayerExposure(AppUserLayers.SocialAppChat)
				default:logRobloxTelemetryEvent(PushUpsellEventConfig, {}, {
					[ModalEventConstants.ActionType] = ModalEventConstants.ShouldRequest,
					[ModalEventConstants.EntryPoint] = "ChatConversation"
				}, ModalEventConstants.ModalContextPushEduUpsell)
				setupPushNotificationsUpsell.OpenModal(NotificationsUpsellConstants.ModalKey.PushUpsellChat, true, "ChatConversation")
			end)
		end
	end, {
		v23,
		v21
	})
end

return CheckAndOpenChatPushUpsell
