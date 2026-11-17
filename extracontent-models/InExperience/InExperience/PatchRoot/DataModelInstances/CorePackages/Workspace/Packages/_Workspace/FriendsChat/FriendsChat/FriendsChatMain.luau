local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local ReactFocusNavigation = require(parent.ReactFocusNavigation)
local Foundation = require(parent.Foundation)
local EnumScreens = require(parent.AppChat.EnumScreens)
local GetChatModerationStatusDataHydration = require(parent.AppChat.GetChatModerationStatusDataHydration)
local InExperienceAppChatModal = require(parent.AppChat.InExperienceAppChatModal)
local IXPNavigationUtils = require(parent.AppChat.IXPNavigationUtils)

local Localization = require(parent.Localization)
local LocalizationProvider = Localization.LocalizationProvider
local RobloxAppLocales = require(parent.RobloxAppLocales)
local localization = RobloxAppLocales.Localization

local useChatWindowSettings = require(parent.ExpChatIntegration.useChatWindowSettings)

local AppTelemetryLayer = require(parent.AppChat.AppTelemetryLayer)
local ChatPlacementContext = require(parent.AppChat.ChatPlacementContext)
local ChatSessionRefCount = require(parent.AppChat.ChatSessionRefCount)
local useAppChatUpdateSession = require(parent.AppChat.useAppChatUpdateSession)
local useGetAndSetRef = require(parent.AppChat.useGetAndSetRef)
local usePartyChatReactiveFeatureRestriction = require(parent.AppChat.usePartyChatReactiveFeatureRestriction)
local SocialCommon = require(parent.SocialCommon)

local FriendsChatTabName = require(script.Parent.FriendsChatTabName)
local ConversationList = require(script.Parent.ConversationList)
local FriendsChatConversationWindow = require(script.Parent.ConversationWindow.FriendsChatConversationWindow)
local GetFriendsChatNavigationStore = require(script.Parent.Stores.GetFriendsChatNavigationStore)
local GetFriendsChatRealtimeStore = require(script.Parent.Stores.GetFriendsChatRealtimeStore)
local useFriendsChatVisibilityTelemetry = require(script.Parent.Telemetry.App.useFriendsChatVisibilityTelemetry)

local FriendsChatLandingTelemetryProviders = require(script.Parent.Telemetry.ChatLanding.FriendsChatLandingTelemetryProviders)

local FriendsChatConversationTelemetryProviders = require(script.Parent.Telemetry.ChatConversation.FriendsChatConversationTelemetryProviders)

local ChatUIPrimitives = require(parent.ChatUIPrimitives)
local ExpChatPerfTracker = ChatUIPrimitives.Telemetry.ExpChatPerfTracker

local SharedFlags = require(parent.SharedFlags)
local FFlagAppChatReactiveFeatureRestrictions = SharedFlags.FFlagAppChatReactiveFeatureRestrictions
local FFlagFriendsChatConversationListFocusNav = SharedFlags.FFlagFriendsChatConversationListFocusNav

local FFlagFriendsChatFocusInputOnConversationActivated = require(script.Parent.Flags.FFlagFriendsChatFocusInputOnConversationActivated)
local FFlagFriendsChatIxpScreenExposure = require(script.Parent.Flags.FFlagFriendsChatIxpScreenExposure)
local FStringFriendsChatLandingPageIxpLayer = require(script.Parent.Flags.FStringFriendsChatLandingPageIxpLayer)

local FStringFriendsChatConversationPageIxpLayer = require(script.Parent.Flags.FStringFriendsChatConversationPageIxpLayer)
local FFlagFriendsChatIxpParallelScreenLayers = require(script.Parent.Flags.FFlagFriendsChatIxpParallelScreenLayers)

local FStringFriendsChatLandingConversationRowsIxpLayer = require(script.Parent.Flags.FStringFriendsChatLandingConversationRowsIxpLayer)

local FStringFriendsChatLandingConversationListIxpLayer = require(script.Parent.Flags.FStringFriendsChatLandingConversationListIxpLayer)

local FStringFriendsChatLandingPerformanceIxpLayer = require(script.Parent.Flags.FStringFriendsChatLandingPerformanceIxpLayer)

local FStringFriendsChatConversationComposerIxpLayer = require(script.Parent.Flags.FStringFriendsChatConversationComposerIxpLayer)

local FStringFriendsChatConversationMessagesIxpLayer = require(script.Parent.Flags.FStringFriendsChatConversationMessagesIxpLayer)

local FStringFriendsChatConversationPerformanceIxpLayer = require(script.Parent.Flags.FStringFriendsChatConversationPerformanceIxpLayer)

local exposureHandler = IXPNavigationUtils.createExposureHandler(FStringFriendsChatLandingPageIxpLayer)
local exposureHandler2 = IXPNavigationUtils.createExposureHandler(FStringFriendsChatConversationPageIxpLayer)

local v = FFlagFriendsChatIxpParallelScreenLayers
	and {
		IXPNavigationUtils.createExposureHandler(FStringFriendsChatLandingConversationRowsIxpLayer),
		IXPNavigationUtils.createExposureHandler(FStringFriendsChatLandingConversationListIxpLayer),
		IXPNavigationUtils.createExposureHandler(FStringFriendsChatLandingPerformanceIxpLayer)
	}
	or {}

local v2 = FFlagFriendsChatIxpParallelScreenLayers
	and {
		IXPNavigationUtils.createExposureHandler(FStringFriendsChatConversationComposerIxpLayer),
		IXPNavigationUtils.createExposureHandler(FStringFriendsChatConversationMessagesIxpLayer),
		IXPNavigationUtils.createExposureHandler(FStringFriendsChatConversationPerformanceIxpLayer)
	}
	or {}

local function FriendsChatMainContent(props)
	useFriendsChatVisibilityTelemetry()

	local v3 = useChatWindowSettings()
	local v4 = React.useMemo(function()
		return {
			BackgroundColor3 = v3.ChatWindowBackgroundColor3,
			BackgroundTransparency = v3.ChatWindowBackgroundTransparency
		}
	end, { v3 })

	local chatModerationStatusDataHydration = GetChatModerationStatusDataHydration(false)
	local friendsChatNavigationStore = GetFriendsChatNavigationStore(false)
	local friendsChatRealtimeStore = GetFriendsChatRealtimeStore(false)
	local v5

	if FFlagFriendsChatConversationListFocusNav then
		v5 = React.useContext(ReactFocusNavigation.FocusNavigationContext)
	else
		v5 = nil
	end

	if FFlagAppChatReactiveFeatureRestrictions then
		usePartyChatReactiveFeatureRestriction(true)
	end

	React.useEffect(function()
		friendsChatRealtimeStore.markFriendsTabEntered()
	end, { friendsChatRealtimeStore })
	React.useEffect(function()
		if not FFlagAppChatReactiveFeatureRestrictions then
			chatModerationStatusDataHydration.getUserStatus()
		end
	end, { chatModerationStatusDataHydration })

	React.useEffect(function()
		ExpChatPerfTracker.finish(ExpChatPerfTracker.Events.ChatWindowMountTTI, {}, {
			tabName = FriendsChatTabName
		})
		return function()
			ExpChatPerfTracker.cancelAll()
		end
	end, {})
	React.useEffect(function()
		ExpChatPerfTracker.finish(ExpChatPerfTracker.Events.ChatWindowTabSwitchTTI, {
			tabId = FriendsChatTabName
		}, {
			tabName = FriendsChatTabName
		})
	end, {})

	local conversationId = SignalsReact.useSignalState(friendsChatNavigationStore.getEffectiveConversationId)

	if FFlagFriendsChatIxpScreenExposure then
		local current = conversationId ~= nil
		local ref = React.useRef(nil)

		if ref.current ~= current then
			ref.current = current
			local v6

			if current then
				v6 = exposureHandler2
			else
				v6 = exposureHandler
			end

			pcall(v6)

			if FFlagFriendsChatIxpParallelScreenLayers then
				local v7 = if current then v2 else v

				for _, callback in v7 do
					pcall(callback)
				end
			end
		end
	end

	local chatWindowSettings = props.chatWindowSettings or v4
	local parentLayoutOrder = props.parentLayoutOrder or 1
	local localPlayer = Players.LocalPlayer
	local userId

	if localPlayer then
		userId = tostring(localPlayer.UserId)
	end

	local localization2 = React.useMemo(function()
		return localization.new(LocalizationService.RobloxLocaleId)
	end, {})

	React.useEffect(function()
		friendsChatRealtimeStore.setActiveConversationId(conversationId)
		return function()
			friendsChatRealtimeStore.setActiveConversationId(nil)
		end
	end, { friendsChatRealtimeStore, conversationId })
	local v6

	if FFlagFriendsChatConversationListFocusNav then
		v6 = React.useCallback(function(): boolean
			return v5 ~= nil and v5.focusedGuiObject:getValue() ~= nil
		end, { v5 })
	else
		v6 = nil
	end

	local onConversationActivated = React.useCallback(function(p: string)
		if FFlagFriendsChatConversationListFocusNav and v6() or FFlagFriendsChatFocusInputOnConversationActivated then
			friendsChatNavigationStore.requestFocusInputBar()
		end

		friendsChatNavigationStore.setSelectedConversationId(p)
	end, { friendsChatNavigationStore, v6 })

	local onBack = React.useCallback(function()
		if FFlagFriendsChatConversationListFocusNav and v6() then
			friendsChatNavigationStore.requestFocusConversationList()
		end

		friendsChatNavigationStore.setSelectedConversationId(nil)
	end, { friendsChatNavigationStore, v6 })

	local onOpenDetails = React.useCallback(function(conversationId2: string)
		ChatSessionRefCount.reserve()
		InExperienceAppChatModal.default:openToScreen({
			screen = EnumScreens.ChatDetails,
			params = {
				conversationId = conversationId2,
				rooted = true,
				entryPoint = SocialCommon.Enums.ChatEntryPointNames.ExperienceChatTabBar
			}
		})
	end, {})

	local onFriendPlaceholderConversationCreated = React.useCallback(function(p: string)
		friendsChatNavigationStore.setSelectedConversationId(p)
	end, { friendsChatNavigationStore })
	local content

	if conversationId == nil then
		content = React.createElement(FriendsChatLandingTelemetryProviders, nil, {
			ConversationList = React.createElement(ConversationList, {
				LayoutOrder = parentLayoutOrder,
				chatWindowSettings = chatWindowSettings,
				transparencyValue = props.transparencyValue,
				textTransparency = props.textTransparency,
				isSpatialUIEnabled = props.isSpatialUIEnabled,
				onHovered = props.onHovered,
				onUnhovered = props.onUnhovered,
				onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
				onAbsolutePositionChanged = props.onAbsolutePositionChanged,
				onConversationActivated = onConversationActivated,
				localUserId = userId
			})
		})
	else
		content = React.createElement(FriendsChatConversationTelemetryProviders, {
			conversationId = conversationId
		}, {
			ConversationWindow = React.createElement(FriendsChatConversationWindow, {
				conversationId = conversationId,
				parentLayoutOrder = parentLayoutOrder,
				chatWindowSettings = chatWindowSettings,
				transparencyValue = props.transparencyValue,
				textTransparency = props.textTransparency,
				isSpatialUIEnabled = props.isSpatialUIEnabled,
				isChannelBarVisible = props.isChannelBarVisible,
				onHovered = props.onHovered,
				onUnhovered = props.onUnhovered,
				onAbsoluteSizeChanged = props.onAbsoluteSizeChanged,
				onAbsolutePositionChanged = props.onAbsolutePositionChanged,
				onBack = onBack,
				onOpenDetails = onOpenDetails,
				onFriendPlaceholderConversationCreated = onFriendPlaceholderConversationCreated
			})
		})
	end

	return React.createElement(LocalizationProvider, { localization = localization2 }, {
		Content = React.createElement(Foundation.FoundationProvider, {
			colorMode = Foundation.Enums.ColorMode.Dark
		}, {
			Content = content
		})
	})
end

local function FriendsChatMain(p)
	local localPlayer = Players.LocalPlayer
	local userId = not localPlayer and "unknown" or tostring(localPlayer.UserId)
	local robloxLocaleId = LocalizationService.RobloxLocaleId
	local playSessionId = RbxAnalyticsService:GetPlaySessionId()

	useAppChatUpdateSession()

	local v3 = React.useMemo(function()
		return {
			context = "platformChat",
			locale = robloxLocaleId,
			entryPoint = SocialCommon.Enums.ChatEntryPointNames.ExperienceChatTabBar,
			userId = userId,
			placement = ChatPlacementContext.Enum.InExperienceFriendsTab,
			playSessionId = playSessionId,
			currentSquadId = nil
		}
	end, { robloxLocaleId, userId, playSessionId })

	local v4, v5 = useGetAndSetRef(v3)
	React.useEffect(function()
		v5(v3)
	end, { v3, v5 })

	return React.createElement(AppTelemetryLayer.Provider, { value = v4 }, {
		Content = React.createElement(FriendsChatMainContent, p)
	})
end

return FriendsChatMain
