local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)
local Foundation = require(Parent.Foundation)
local EnumScreens = require(Parent.AppChat.EnumScreens)
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

local function FriendsChatMainContent(t1: {[any]: any}) -- line: 54
	-- upvalues: useFriendsChatVisibilityTelemetry (copy), useChatWindowSettings (copy), React (copy), GetFriendsChatNavigationStore (copy), GetFriendsChatRealtimeStore (copy), SignalsReact (copy), Players (copy), Localization (copy), LocalizationService (copy), InExperienceAppChatModal (copy), EnumScreens (copy), FriendsChatLandingTelemetryProviders (copy), ConversationList (copy), FriendsChatConversationTelemetryProviders (copy), FriendsChatConversationWindow (copy), getFFlagAppChatEnableRootedNavigation (copy), LocalizationProvider (copy), Foundation (copy)
	useFriendsChatVisibilityTelemetry()

	local v29 = useChatWindowSettings()
	local v30 = React.useMemo(function() -- line: 58
		-- upvalues: v29 (copy)
		return {
			BackgroundColor3 = v29.ChatWindowBackgroundColor3,
			BackgroundTransparency = v29.ChatWindowBackgroundTransparency
		}
	end, { v29 })
	local v31 = GetFriendsChatNavigationStore(false)
	local v32 = GetFriendsChatRealtimeStore(false)

	React.useEffect(function() -- line: 73
		-- upvalues: v32 (copy)
		v32.markFriendsTabEntered()
	end, { v32 })

	local v33 = SignalsReact.useSignalState(v31.getSelectedConversationId)
	local v34 = t1.chatWindowSettings or v30
	local v35 = t1.parentLayoutOrder or 1
	local LocalPlayer = Players.LocalPlayer
	local v37 = if not LocalPlayer then nil else tostring(LocalPlayer.UserId)
	local v38 = React.useMemo(function() -- line: 82
		-- upvalues: Localization (copy), LocalizationService (copy)
		return Localization.new(LocalizationService.RobloxLocaleId)
	end, {})

	React.useEffect(function() -- line: 86
		-- upvalues: v32 (copy), v33 (copy)
		v32.setActiveConversationId(v33)

		return function() -- line: 88
			-- upvalues: v32 (copy)
			v32.setActiveConversationId(nil)
		end
	end, {
		v32,
		v33
	})

	local v39 = React.useCallback(function(s1: string) -- line: 93
		-- upvalues: v31 (copy)
		v31.setSelectedConversationId(s1)
	end, { v31 })
	local v40 = React.useCallback(function() -- line: 97
		-- upvalues: v31 (copy)
		v31.setSelectedConversationId(nil)
	end, { v31 })
	local v41 = React.useCallback(function(s2: string) -- line: 101
		-- upvalues: InExperienceAppChatModal (copy), EnumScreens (copy)
		InExperienceAppChatModal.default:openToScreen({
			screen = EnumScreens.ChatDetails,
			params = {
				rooted = true,
				conversationId = s2
			}
		})
	end, {})
	local v42 = React.useCallback(function(s3: string) -- line: 111
		-- upvalues: v31 (copy)
		v31.setSelectedConversationId(s3)
	end, { v31 })
	local v43 = if v33 ~= nil then React.createElement(FriendsChatConversationTelemetryProviders, {
		conversationId = v33
	}, {
		ConversationWindow = React.createElement(FriendsChatConversationWindow, {
			conversationId = v33,
			parentLayoutOrder = v35,
			chatWindowSettings = v34,
			transparencyValue = t1.transparencyValue,
			textTransparency = t1.textTransparency,
			isSpatialUIEnabled = t1.isSpatialUIEnabled,
			isChannelBarVisible = t1.isChannelBarVisible,
			onHovered = t1.onHovered,
			onUnhovered = t1.onUnhovered,
			onAbsoluteSizeChanged = t1.onAbsoluteSizeChanged,
			onAbsolutePositionChanged = t1.onAbsolutePositionChanged,
			onBack = v40,
			onOpenDetails = if not getFFlagAppChatEnableRootedNavigation() then nil else v41,
			onFriendPlaceholderConversationCreated = v42
		})
	}) else React.createElement(FriendsChatLandingTelemetryProviders, nil, {
		ConversationList = React.createElement(ConversationList, {
			LayoutOrder = v35,
			chatWindowSettings = v34,
			transparencyValue = t1.transparencyValue,
			textTransparency = t1.textTransparency,
			isSpatialUIEnabled = t1.isSpatialUIEnabled,
			onHovered = t1.onHovered,
			onUnhovered = t1.onUnhovered,
			onAbsoluteSizeChanged = t1.onAbsoluteSizeChanged,
			onAbsolutePositionChanged = t1.onAbsolutePositionChanged,
			onConversationActivated = v39,
			localUserId = v37
		})
	})

	return React.createElement(LocalizationProvider, {
		localization = v38
	}, {
		Content = React.createElement(Foundation.FoundationProvider, {
			theme = Foundation.Enums.Theme.Dark
		}, {
			Content = v43
		})
	})
end
local function FriendsChatMain(t2: {[any]: any}) -- line: 167
	-- upvalues: Players (copy), LocalizationService (copy), RbxAnalyticsService (copy), React (copy), FFlagExpChatEnableFriendsTab (copy), ChatPlacementContext (copy), SocialCommon (copy), useGetAndSetRef (copy), AppTelemetryLayer (copy), FriendsChatMainContent (copy)
	local LocalPlayer = Players.LocalPlayer
	local v46 = not LocalPlayer and "unknown" or tostring(LocalPlayer.UserId)
	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local PlaySessionId = RbxAnalyticsService:GetPlaySessionId()
	local v49 = React.useMemo(function() -- line: 173
		-- upvalues: FFlagExpChatEnableFriendsTab (copy), ChatPlacementContext (copy), RobloxLocaleId (copy), SocialCommon (copy), v46 (copy), PlaySessionId (copy)
		local v55 = if not FFlagExpChatEnableFriendsTab then ChatPlacementContext.Enum.InExperienceDefault else ChatPlacementContext.Enum.InExperienceFriendsTab

		return {
			context = "platformChat",
			currentSquadId = nil,
			locale = RobloxLocaleId,
			entryPoint = SocialCommon.Enums.ChatEntryPointNames.ExperienceChatTabBar,
			userId = v46,
			placement = v55,
			playSessionId = PlaySessionId
		}
	end, {
		RobloxLocaleId,
		v46,
		PlaySessionId
	})
	local v50, v51 = useGetAndSetRef(v49)

	React.useEffect(function() -- line: 190
		-- upvalues: v51 (copy), v49 (copy)
		v51(v49)
	end, {
		v49,
		v51
	})

	return React.createElement(AppTelemetryLayer.Provider, {
		value = v50
	}, {
		Content = React.createElement(FriendsChatMainContent, t2)
	})
end

return FriendsChatMain
