local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)
local Foundation = require(Parent.Foundation)
local EnumScreens = require(Parent.AppChat.EnumScreens)
local GetChatModerationStatusDataHydration = require(Parent.AppChat.GetChatModerationStatusDataHydration)
local InExperienceAppChatModal = require(Parent.AppChat.InExperienceAppChatModal)
local getFFlagAppChatEnableRootedNavigation = require(Parent.AppChat.getFFlagAppChatEnableRootedNavigation)
local LocalizationProvider = require(Parent.Localization).LocalizationProvider
local Localization = require(Parent.RobloxAppLocales).Localization
local useChatWindowSettings = require(Parent.ExpChatIntegration.useChatWindowSettings)
local AppTelemetryLayer = require(Parent.AppChat.AppTelemetryLayer)
local ChatPlacementContext = require(Parent.AppChat.ChatPlacementContext)
local useGetAndSetRef = require(Parent.AppChat.useGetAndSetRef)
local SocialCommon = require(Parent.SocialCommon)
local ConversationList = require(script.Parent.ConversationList)
local FriendsChatConversationWindow = require(script.Parent.ConversationWindow.FriendsChatConversationWindow)
local GetFriendsChatNavigationStore = require(script.Parent.Stores.GetFriendsChatNavigationStore)
local GetFriendsChatRealtimeStore = require(script.Parent.Stores.GetFriendsChatRealtimeStore)
local useFriendsChatVisibilityTelemetry = require(script.Parent.Telemetry.App.useFriendsChatVisibilityTelemetry)
local FriendsChatLandingTelemetryProviders = require(script.Parent.Telemetry.ChatLanding.FriendsChatLandingTelemetryProviders)
local FriendsChatConversationTelemetryProviders = require(script.Parent.Telemetry.ChatConversation.FriendsChatConversationTelemetryProviders)
local FFlagExpChatEnableFriendsTab = require(Parent.SharedFlags).FFlagExpChatEnableFriendsTab

local function FriendsChatMainContent(t1: {[any]: any}) -- line: 55
	-- upvalues: useFriendsChatVisibilityTelemetry (copy), useChatWindowSettings (copy), React (copy), GetChatModerationStatusDataHydration (copy), GetFriendsChatNavigationStore (copy), GetFriendsChatRealtimeStore (copy), FFlagExpChatEnableFriendsTab (copy), SignalsReact (copy), Players (copy), Localization (copy), LocalizationService (copy), InExperienceAppChatModal (copy), EnumScreens (copy), FriendsChatLandingTelemetryProviders (copy), ConversationList (copy), FriendsChatConversationTelemetryProviders (copy), FriendsChatConversationWindow (copy), getFFlagAppChatEnableRootedNavigation (copy), LocalizationProvider (copy), Foundation (copy)
	useFriendsChatVisibilityTelemetry()

	local v30 = useChatWindowSettings()
	local v31 = React.useMemo(function() -- line: 59
		-- upvalues: v30 (copy)
		return {
			BackgroundColor3 = v30.ChatWindowBackgroundColor3,
			BackgroundTransparency = v30.ChatWindowBackgroundTransparency
		}
	end, { v30 })
	local v32 = GetChatModerationStatusDataHydration(false)
	local v33 = GetFriendsChatNavigationStore(false)
	local v34 = GetFriendsChatRealtimeStore(false)

	React.useEffect(function() -- line: 75
		-- upvalues: v34 (copy)
		v34.markFriendsTabEntered()
	end, { v34 })
	React.useEffect(function() -- line: 78
		-- upvalues: FFlagExpChatEnableFriendsTab (copy), v32 (copy)
		if FFlagExpChatEnableFriendsTab then
			v32.getUserStatus()
		end
	end, { v32 })

	local v35 = SignalsReact.useSignalState(v33.getSelectedConversationId)
	local v36 = t1.chatWindowSettings or v31
	local v37 = t1.parentLayoutOrder or 1
	local LocalPlayer = Players.LocalPlayer
	local v39 = if not LocalPlayer then nil else tostring(LocalPlayer.UserId)
	local v40 = React.useMemo(function() -- line: 89
		-- upvalues: Localization (copy), LocalizationService (copy)
		return Localization.new(LocalizationService.RobloxLocaleId)
	end, {})

	React.useEffect(function() -- line: 93
		-- upvalues: v34 (copy), v35 (copy)
		v34.setActiveConversationId(v35)

		return function() -- line: 95
			-- upvalues: v34 (copy)
			v34.setActiveConversationId(nil)
		end
	end, {
		v34,
		v35
	})

	local v41 = React.useCallback(function(s1: string) -- line: 100
		-- upvalues: v33 (copy)
		v33.setSelectedConversationId(s1)
	end, { v33 })
	local v42 = React.useCallback(function() -- line: 104
		-- upvalues: v33 (copy)
		v33.setSelectedConversationId(nil)
	end, { v33 })
	local v43 = React.useCallback(function(s2: string) -- line: 108
		-- upvalues: InExperienceAppChatModal (copy), EnumScreens (copy)
		InExperienceAppChatModal.default:openToScreen({
			screen = EnumScreens.ChatDetails,
			params = {
				rooted = true,
				conversationId = s2
			}
		})
	end, {})
	local v44 = React.useCallback(function(s3: string) -- line: 118
		-- upvalues: v33 (copy)
		v33.setSelectedConversationId(s3)
	end, { v33 })
	local v45 = if v35 ~= nil then React.createElement(FriendsChatConversationTelemetryProviders, {
		conversationId = v35
	}, {
		ConversationWindow = React.createElement(FriendsChatConversationWindow, {
			conversationId = v35,
			parentLayoutOrder = v37,
			chatWindowSettings = v36,
			transparencyValue = t1.transparencyValue,
			textTransparency = t1.textTransparency,
			isSpatialUIEnabled = t1.isSpatialUIEnabled,
			isChannelBarVisible = t1.isChannelBarVisible,
			onHovered = t1.onHovered,
			onUnhovered = t1.onUnhovered,
			onAbsoluteSizeChanged = t1.onAbsoluteSizeChanged,
			onAbsolutePositionChanged = t1.onAbsolutePositionChanged,
			onBack = v42,
			onOpenDetails = if not getFFlagAppChatEnableRootedNavigation() then nil else v43,
			onFriendPlaceholderConversationCreated = v44
		})
	}) else React.createElement(FriendsChatLandingTelemetryProviders, nil, {
		ConversationList = React.createElement(ConversationList, {
			LayoutOrder = v37,
			chatWindowSettings = v36,
			transparencyValue = t1.transparencyValue,
			textTransparency = t1.textTransparency,
			isSpatialUIEnabled = t1.isSpatialUIEnabled,
			onHovered = t1.onHovered,
			onUnhovered = t1.onUnhovered,
			onAbsoluteSizeChanged = t1.onAbsoluteSizeChanged,
			onAbsolutePositionChanged = t1.onAbsolutePositionChanged,
			onConversationActivated = v41,
			localUserId = v39
		})
	})

	return React.createElement(LocalizationProvider, {
		localization = v40
	}, {
		Content = React.createElement(Foundation.FoundationProvider, {
			theme = Foundation.Enums.Theme.Dark
		}, {
			Content = v45
		})
	})
end
local function FriendsChatMain(t2: {[any]: any}) -- line: 174
	-- upvalues: Players (copy), LocalizationService (copy), RbxAnalyticsService (copy), React (copy), FFlagExpChatEnableFriendsTab (copy), ChatPlacementContext (copy), SocialCommon (copy), useGetAndSetRef (copy), AppTelemetryLayer (copy), FriendsChatMainContent (copy)
	local LocalPlayer = Players.LocalPlayer
	local v48 = not LocalPlayer and "unknown" or tostring(LocalPlayer.UserId)
	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local PlaySessionId = RbxAnalyticsService:GetPlaySessionId()
	local v51 = React.useMemo(function() -- line: 180
		-- upvalues: FFlagExpChatEnableFriendsTab (copy), ChatPlacementContext (copy), RobloxLocaleId (copy), SocialCommon (copy), v48 (copy), PlaySessionId (copy)
		local v57 = if not FFlagExpChatEnableFriendsTab then ChatPlacementContext.Enum.InExperienceDefault else ChatPlacementContext.Enum.InExperienceFriendsTab

		return {
			context = "platformChat",
			currentSquadId = nil,
			locale = RobloxLocaleId,
			entryPoint = SocialCommon.Enums.ChatEntryPointNames.ExperienceChatTabBar,
			userId = v48,
			placement = v57,
			playSessionId = PlaySessionId
		}
	end, {
		RobloxLocaleId,
		v48,
		PlaySessionId
	})
	local v52, v53 = useGetAndSetRef(v51)

	React.useEffect(function() -- line: 197
		-- upvalues: v53 (copy), v51 (copy)
		v53(v51)
	end, {
		v51,
		v53
	})

	return React.createElement(AppTelemetryLayer.Provider, {
		value = v52
	}, {
		Content = React.createElement(FriendsChatMainContent, t2)
	})
end

return FriendsChatMain
