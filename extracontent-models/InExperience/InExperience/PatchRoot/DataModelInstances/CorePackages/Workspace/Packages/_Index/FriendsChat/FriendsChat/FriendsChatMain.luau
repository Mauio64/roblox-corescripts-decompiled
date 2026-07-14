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
local FFlagExpChatEnableFriendsTab = require(Parent.SharedFlags).FFlagExpChatEnableFriendsTab

local function FriendsChatMainContent(t1: {[any]: any}) -- line: 52
	-- upvalues: useFriendsChatVisibilityTelemetry (copy), useChatWindowSettings (copy), React (copy), GetFriendsChatNavigationStore (copy), GetFriendsChatRealtimeStore (copy), SignalsReact (copy), Players (copy), Localization (copy), LocalizationService (copy), InExperienceAppChatModal (copy), EnumScreens (copy), FriendsChatLandingTelemetryProviders (copy), ConversationList (copy), FriendsChatConversationWindow (copy), getFFlagAppChatEnableRootedNavigation (copy), LocalizationProvider (copy), Foundation (copy)
	useFriendsChatVisibilityTelemetry()

	local v28 = useChatWindowSettings()
	local v29 = React.useMemo(function() -- line: 56
		-- upvalues: v28 (copy)
		return {
			BackgroundColor3 = v28.ChatWindowBackgroundColor3,
			BackgroundTransparency = v28.ChatWindowBackgroundTransparency
		}
	end, { v28 })
	local v30 = GetFriendsChatNavigationStore(false)
	local v31 = GetFriendsChatRealtimeStore(false)

	React.useEffect(function() -- line: 71
		-- upvalues: v31 (copy)
		v31.markFriendsTabEntered()
	end, { v31 })

	local v32 = SignalsReact.useSignalState(v30.getSelectedConversationId)
	local v33 = t1.chatWindowSettings or v29
	local v34 = t1.parentLayoutOrder or 1
	local LocalPlayer = Players.LocalPlayer
	local v36 = if not LocalPlayer then nil else tostring(LocalPlayer.UserId)
	local v37 = React.useMemo(function() -- line: 80
		-- upvalues: Localization (copy), LocalizationService (copy)
		return Localization.new(LocalizationService.RobloxLocaleId)
	end, {})

	React.useEffect(function() -- line: 84
		-- upvalues: v31 (copy), v32 (copy)
		v31.setActiveConversationId(v32)

		return function() -- line: 86
			-- upvalues: v31 (copy)
			v31.setActiveConversationId(nil)
		end
	end, {
		v31,
		v32
	})

	local v38 = React.useCallback(function(s1: string) -- line: 91
		-- upvalues: v30 (copy)
		v30.setSelectedConversationId(s1)
	end, { v30 })
	local v39 = React.useCallback(function() -- line: 95
		-- upvalues: v30 (copy)
		v30.setSelectedConversationId(nil)
	end, { v30 })
	local v40 = React.useCallback(function(s2: string) -- line: 99
		-- upvalues: InExperienceAppChatModal (copy), EnumScreens (copy)
		InExperienceAppChatModal.default:openToScreen({
			screen = EnumScreens.ChatDetails,
			params = {
				rooted = true,
				conversationId = s2
			}
		})
	end, {})
	local v41 = React.useCallback(function(s3: string) -- line: 109
		-- upvalues: v30 (copy)
		v30.setSelectedConversationId(s3)
	end, { v30 })
	local v42 = if v32 ~= nil then React.createElement(FriendsChatConversationWindow, {
		conversationId = v32,
		parentLayoutOrder = v34,
		chatWindowSettings = v33,
		transparencyValue = t1.transparencyValue,
		textTransparency = t1.textTransparency,
		isSpatialUIEnabled = t1.isSpatialUIEnabled,
		isChannelBarVisible = t1.isChannelBarVisible,
		onHovered = t1.onHovered,
		onUnhovered = t1.onUnhovered,
		onAbsoluteSizeChanged = t1.onAbsoluteSizeChanged,
		onAbsolutePositionChanged = t1.onAbsolutePositionChanged,
		onBack = v39,
		onOpenDetails = if not getFFlagAppChatEnableRootedNavigation() then nil else v40,
		onFriendPlaceholderConversationCreated = v41
	}) else React.createElement(FriendsChatLandingTelemetryProviders, nil, {
		ConversationList = React.createElement(ConversationList, {
			LayoutOrder = v34,
			chatWindowSettings = v33,
			transparencyValue = t1.transparencyValue,
			textTransparency = t1.textTransparency,
			isSpatialUIEnabled = t1.isSpatialUIEnabled,
			onHovered = t1.onHovered,
			onUnhovered = t1.onUnhovered,
			onAbsoluteSizeChanged = t1.onAbsoluteSizeChanged,
			onAbsolutePositionChanged = t1.onAbsolutePositionChanged,
			onConversationActivated = v38,
			localUserId = v36
		})
	})

	return React.createElement(LocalizationProvider, {
		localization = v37
	}, {
		Content = React.createElement(Foundation.FoundationProvider, {
			theme = Foundation.Enums.Theme.Dark
		}, {
			Content = v42
		})
	})
end
local function FriendsChatMain(t2: {[any]: any}) -- line: 161
	-- upvalues: Players (copy), LocalizationService (copy), RbxAnalyticsService (copy), React (copy), FFlagExpChatEnableFriendsTab (copy), ChatPlacementContext (copy), SocialCommon (copy), useGetAndSetRef (copy), AppTelemetryLayer (copy), FriendsChatMainContent (copy)
	local LocalPlayer = Players.LocalPlayer
	local v45 = not LocalPlayer and "unknown" or tostring(LocalPlayer.UserId)
	local RobloxLocaleId = LocalizationService.RobloxLocaleId
	local PlaySessionId = RbxAnalyticsService:GetPlaySessionId()
	local v48 = React.useMemo(function() -- line: 167
		-- upvalues: FFlagExpChatEnableFriendsTab (copy), ChatPlacementContext (copy), RobloxLocaleId (copy), SocialCommon (copy), v45 (copy), PlaySessionId (copy)
		local v54 = if not FFlagExpChatEnableFriendsTab then ChatPlacementContext.Enum.InExperienceDefault else ChatPlacementContext.Enum.InExperienceFriendsTab

		return {
			context = "platformChat",
			currentSquadId = nil,
			locale = RobloxLocaleId,
			entryPoint = SocialCommon.Enums.ChatEntryPointNames.ExperienceChatTabBar,
			userId = v45,
			placement = v54,
			playSessionId = PlaySessionId
		}
	end, {
		RobloxLocaleId,
		v45,
		PlaySessionId
	})
	local v49, v50 = useGetAndSetRef(v48)

	React.useEffect(function() -- line: 184
		-- upvalues: v50 (copy), v48 (copy)
		v50(v48)
	end, {
		v48,
		v50
	})

	return React.createElement(AppTelemetryLayer.Provider, {
		value = v49
	}, {
		Content = React.createElement(FriendsChatMainContent, t2)
	})
end

return FriendsChatMain
