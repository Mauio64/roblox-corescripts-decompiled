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
local ChatSessionRefCount = require(Parent.AppChat.ChatSessionRefCount)
local useAppChatUpdateSession = require(Parent.AppChat.useAppChatUpdateSession)
local useGetAndSetRef = require(Parent.AppChat.useGetAndSetRef)
local SocialCommon = require(Parent.SocialCommon)
local ConversationList = require(script.Parent.ConversationList)
local FriendsChatConversationWindow = require(script.Parent.ConversationWindow.FriendsChatConversationWindow)
local GetFriendsChatNavigationStore = require(script.Parent.Stores.GetFriendsChatNavigationStore)
local GetFriendsChatRealtimeStore = require(script.Parent.Stores.GetFriendsChatRealtimeStore)
local useFriendsChatVisibilityTelemetry = require(script.Parent.Telemetry.App.useFriendsChatVisibilityTelemetry)
local FriendsChatLandingTelemetryProviders = require(script.Parent.Telemetry.ChatLanding.FriendsChatLandingTelemetryProviders)
local FriendsChatConversationTelemetryProviders = require(script.Parent.Telemetry.ChatConversation.FriendsChatConversationTelemetryProviders)
local ExpChatPerfTracker = require(Parent.ChatUIPrimitives).Telemetry.ExpChatPerfTracker
local FFlagExpChatEnableFriendsTab = require(Parent.SharedFlags).FFlagExpChatEnableFriendsTab

local function FriendsChatMainContent(t1: {[any]: any}) -- line: 59
	-- upvalues: useFriendsChatVisibilityTelemetry (copy), useChatWindowSettings (copy), React (copy), GetChatModerationStatusDataHydration (copy), GetFriendsChatNavigationStore (copy), GetFriendsChatRealtimeStore (copy), FFlagExpChatEnableFriendsTab (copy), ExpChatPerfTracker (copy), SignalsReact (copy), Players (copy), Localization (copy), LocalizationService (copy), ChatSessionRefCount (copy), InExperienceAppChatModal (copy), EnumScreens (copy), SocialCommon (copy), FriendsChatLandingTelemetryProviders (copy), ConversationList (copy), FriendsChatConversationTelemetryProviders (copy), FriendsChatConversationWindow (copy), getFFlagAppChatEnableRootedNavigation (copy), LocalizationProvider (copy), Foundation (copy)
	useFriendsChatVisibilityTelemetry()

	local v33 = useChatWindowSettings()
	local v34 = React.useMemo(function() -- line: 63
		-- upvalues: v33 (copy)
		return {
			BackgroundColor3 = v33.ChatWindowBackgroundColor3,
			BackgroundTransparency = v33.ChatWindowBackgroundTransparency
		}
	end, { v33 })
	local v35 = GetChatModerationStatusDataHydration(false)
	local v36 = GetFriendsChatNavigationStore(false)
	local v37 = GetFriendsChatRealtimeStore(false)

	React.useEffect(function() -- line: 79
		-- upvalues: v37 (copy)
		v37.markFriendsTabEntered()
	end, { v37 })
	React.useEffect(function() -- line: 82
		-- upvalues: FFlagExpChatEnableFriendsTab (copy), v35 (copy)
		if FFlagExpChatEnableFriendsTab then
			v35.getUserStatus()
		end
	end, { v35 })
	React.useEffect(function() -- line: 89
		-- upvalues: ExpChatPerfTracker (copy)
		ExpChatPerfTracker.finish(ExpChatPerfTracker.Events.ChatWindowMountTTI, {}, {
			tabName = "FriendsChat"
		})

		return function() -- line: 91
			-- upvalues: ExpChatPerfTracker (copy)
			ExpChatPerfTracker.cancelAll()
		end
	end, {})
	React.useEffect(function() -- line: 95
		-- upvalues: ExpChatPerfTracker (copy)
		ExpChatPerfTracker.finish(ExpChatPerfTracker.Events.ChatWindowTabSwitchTTI, {
			tabId = "FriendsChat"
		}, {
			tabName = "FriendsChat"
		})
	end, {})

	local v38 = SignalsReact.useSignalState(v36.getSelectedConversationId)
	local v39 = t1.chatWindowSettings or v34
	local v40 = t1.parentLayoutOrder or 1
	local LocalPlayer = Players.LocalPlayer
	local v42 = if not LocalPlayer then nil else tostring(LocalPlayer.UserId)
	local v43 = React.useMemo(function() -- line: 106
		-- upvalues: Localization (copy), LocalizationService (copy)
		return Localization.new(LocalizationService.RobloxLocaleId)
	end, {})

	React.useEffect(function() -- line: 110
		-- upvalues: v37 (copy), v38 (copy)
		v37.setActiveConversationId(v38)

		return function() -- line: 112
			-- upvalues: v37 (copy)
			v37.setActiveConversationId(nil)
		end
	end, {
		v37,
		v38
	})

	local v44 = React.useCallback(function(s1: string) -- line: 117
		-- upvalues: v36 (copy)
		v36.setSelectedConversationId(s1)
	end, { v36 })
	local v45 = React.useCallback(function() -- line: 121
		-- upvalues: v36 (copy)
		v36.setSelectedConversationId(nil)
	end, { v36 })
	local v46 = React.useCallback(function(s2: string) -- line: 125
		-- upvalues: ChatSessionRefCount (copy), InExperienceAppChatModal (copy), EnumScreens (copy), SocialCommon (copy)
		ChatSessionRefCount.reserve()
		InExperienceAppChatModal.default:openToScreen({
			screen = EnumScreens.ChatDetails,
			params = {
				rooted = true,
				conversationId = s2,
				entryPoint = SocialCommon.Enums.ChatEntryPointNames.ExperienceChatTabBar
			}
		})
	end, {})
	local v47 = React.useCallback(function(s3: string) -- line: 137
		-- upvalues: v36 (copy)
		v36.setSelectedConversationId(s3)
	end, { v36 })
	local v48 = if v38 ~= nil then React.createElement(FriendsChatConversationTelemetryProviders, {
		conversationId = v38
	}, {
		ConversationWindow = React.createElement(FriendsChatConversationWindow, {
			conversationId = v38,
			parentLayoutOrder = v40,
			chatWindowSettings = v39,
			transparencyValue = t1.transparencyValue,
			textTransparency = t1.textTransparency,
			isSpatialUIEnabled = t1.isSpatialUIEnabled,
			isChannelBarVisible = t1.isChannelBarVisible,
			onHovered = t1.onHovered,
			onUnhovered = t1.onUnhovered,
			onAbsoluteSizeChanged = t1.onAbsoluteSizeChanged,
			onAbsolutePositionChanged = t1.onAbsolutePositionChanged,
			onBack = v45,
			onOpenDetails = if not getFFlagAppChatEnableRootedNavigation() then nil else v46,
			onFriendPlaceholderConversationCreated = v47
		})
	}) else React.createElement(FriendsChatLandingTelemetryProviders, nil, {
		ConversationList = React.createElement(ConversationList, {
			LayoutOrder = v40,
			chatWindowSettings = v39,
			transparencyValue = t1.transparencyValue,
			textTransparency = t1.textTransparency,
			isSpatialUIEnabled = t1.isSpatialUIEnabled,
			onHovered = t1.onHovered,
			onUnhovered = t1.onUnhovered,
			onAbsoluteSizeChanged = t1.onAbsoluteSizeChanged,
			onAbsolutePositionChanged = t1.onAbsolutePositionChanged,
			onConversationActivated = v44,
			localUserId = v42
		})
	})

	return React.createElement(LocalizationProvider, {
		localization = v43
	}, {
		Content = React.createElement(Foundation.FoundationProvider, {
			theme = Foundation.Enums.Theme.Dark
		}, {
			Content = v48
		})
	})
end
local function FriendsChatMain(t2: {[any]: any}) -- line: 192
	-- upvalues: Players (copy), LocalizationService (copy), RbxAnalyticsService (copy), useAppChatUpdateSession (copy), React (copy), FFlagExpChatEnableFriendsTab (copy), ChatPlacementContext (copy), SocialCommon (copy), useGetAndSetRef (copy), AppTelemetryLayer (copy), FriendsChatMainContent (copy)
	local LocalPlayer = Players.LocalPlayer
	local v51 = not LocalPlayer and "unknown" or tostring(LocalPlayer.UserId)
	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local PlaySessionId = RbxAnalyticsService:GetPlaySessionId()

	useAppChatUpdateSession()

	local v54 = React.useMemo(function() -- line: 200
		-- upvalues: FFlagExpChatEnableFriendsTab (copy), ChatPlacementContext (copy), RobloxLocaleId (copy), SocialCommon (copy), v51 (copy), PlaySessionId (copy)
		local v60 = if not FFlagExpChatEnableFriendsTab then ChatPlacementContext.Enum.InExperienceDefault else ChatPlacementContext.Enum.InExperienceFriendsTab

		return {
			context = "platformChat",
			currentSquadId = nil,
			locale = RobloxLocaleId,
			entryPoint = SocialCommon.Enums.ChatEntryPointNames.ExperienceChatTabBar,
			userId = v51,
			placement = v60,
			playSessionId = PlaySessionId
		}
	end, {
		RobloxLocaleId,
		v51,
		PlaySessionId
	})
	local v55, v56 = useGetAndSetRef(v54)

	React.useEffect(function() -- line: 217
		-- upvalues: v56 (copy), v54 (copy)
		v56(v54)
	end, {
		v54,
		v56
	})

	return React.createElement(AppTelemetryLayer.Provider, {
		value = v55
	}, {
		Content = React.createElement(FriendsChatMainContent, t2)
	})
end

return FriendsChatMain
