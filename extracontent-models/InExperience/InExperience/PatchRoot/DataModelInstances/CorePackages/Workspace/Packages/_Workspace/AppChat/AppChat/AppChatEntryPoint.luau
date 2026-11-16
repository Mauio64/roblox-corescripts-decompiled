local AppChat = script:FindFirstAncestor("AppChat")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local parent = AppChat.Parent

local Cryo = require(parent.Cryo)
require(AppChat.types)
local SharedFlags = require(parent.SharedFlags)

local Loggers = require(parent.Loggers)
local Logger = Loggers.Logger
local Logger2 = require(AppChat.Logger)
local getRoactChatStackNavigator = require(AppChat.getRoactChatStackNavigator)

local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

local getFFlagAppChatRemoveDynamicRequires = require(AppChat.Flags.getFFlagAppChatRemoveDynamicRequires)
local v = not getFFlagAppChatRemoveDynamicRequires()
local CollectionViews = require(parent.CollectionViews)
local usePageSideMargin = CollectionViews.usePageSideMargin
local v2, v3

if v then
	v2 = nil
	v3 = nil
else
	v2 = require(AppChat.Navigators.Compact.rootNavigator)
	v3 = require(AppChat.Navigators.Wide.rootNavigator)
end

local AnalyticsProvider = require(AppChat.LegacyAnalytics.AnalyticsProvider)
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local LuaAppNavigationContextProvider = require(AppChat.LuaAppNavigationContextProvider)

local AppTabBarRodux = require(parent.AppTabBarRodux)
local SetTabBarVisible = AppTabBarRodux.Actions.SetTabBarVisible
local RoactChatAnalyticsProvider = require(AppChat.Analytics.RoactChatAnalyticsProvider)
local AppTelemetryLayer = require(AppChat.Telemetry.Layers.AppTelemetryLayer)

local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)

local React = require(parent.React)
local RoactNavigation = require(parent.RoactNavigation)
local UserInputService = game:GetService("UserInputService")
local memo = React.memo
local useCallback = React.useCallback
local useChatIsVisible = require(AppChat.Hooks.useChatIsVisible)
local Hooks = require(parent.SquadsCore.Hooks)
local useCurrentSquadParentChannelId = Hooks.useCurrentSquadParentChannelId
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local CrossExperienceVoice = require(parent.CrossExperienceVoice)
local useIsVoiceConnected = CrossExperienceVoice.Hooks.useIsVoiceConnected
local usePartyChatReactiveFeatureRestriction = require(AppChat.Hooks.usePartyChatReactiveFeatureRestriction)
local useRef = React.useRef
local RoactUtils2 = require(parent.RoactUtils)
local useSelector = RoactUtils2.Hooks.RoactRodux.useSelector
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local useRobloxLocale = require(AppChat.Hooks.useRobloxLocale)

local ReplyingToMessageProvider = require(AppChat.Components.ChatConversation.MessageInteraction.ReplyingContext.ReplyingToMessageProvider)
local FFlagAppChatSignalsReplyStore = require(AppChat.Flags.FFlagAppChatSignalsReplyStore)
local FFlagAppChatReactivePaneLayoutOnRotation = SharedFlags.FFlagAppChatReactivePaneLayoutOnRotation
local UIBlox2 = require(parent.UIBlox)
local LayerCollectorProvider = UIBlox2.Core.Layout.LayerCollector.LayerCollectorProvider
local AppChatNetworking = require(parent.AppChatNetworking)
local InteractionFeedback = require(parent.InteractionFeedback)
local HapticFeedback = require(AppChat.Utils.HapticFeedback)
local HapticFeedbackConfig = HapticFeedback.HapticFeedbackConfig

local createConversation = require(AppChat.Conversations.Thunks.createConversation)
local fetchLatestConversationDetails = require(AppChat.Conversations.Thunks.fetchLatestConversationDetails)
local rootedChatDetailsNavigation = require(AppChat.Navigators.rootedChatDetailsNavigation)

local EnumScreens = require(script.Parent.EnumScreens)

local SharedFlags2 = require(parent.SharedFlags)
local GetFFlagIsSquadEnabled = SharedFlags2.GetFFlagIsSquadEnabled
local SharedFlags3 = require(parent.SharedFlags)
local GetFFlagEnableCrossExpVoice = SharedFlags3.GetFFlagEnableCrossExpVoice
local FFlagAppChatReactiveFeatureRestrictions = SharedFlags.FFlagAppChatReactiveFeatureRestrictions

local EnteredChatFromEntryPoint = require(AppChat.Actions.EnteredChatFromEntryPoint)
local NavigateIntoChat = require(AppChat.Actions.NavigateIntoChat)

local getFFlagFixChatsBottomInsetBackgroundColor = require(AppChat.Flags.getFFlagFixChatsBottomInsetBackgroundColor)

local GetOverlayStore = require(AppChat.Stores.GetOverlayStore)
local navigateWithOsaGate = require(AppChat.Utils.navigateWithOsaGate)
local FFlagAppChatShowOSAOnPageEntry = SharedFlags.FFlagAppChatShowOSAOnPageEntry
local FFlagEnableHeaderBarButtonsUpdate = SharedFlags.FFlagEnableHeaderBarButtonsUpdate
local FFlagLuaAppCompositionAppChat = SharedFlags.FFlagLuaAppCompositionAppChat

local FFlagAppChatUseSignalsForLastEntryPoint = require(AppChat.Flags.FFlagAppChatUseSignalsForLastEntryPoint)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local GetLastEntryPointStore

if FFlagAppChatUseSignalsForLastEntryPoint then
	GetLastEntryPointStore = require(AppChat.Stores.GetLastEntryPointStore)
else
	GetLastEntryPointStore = nil
end

local Constants = require(AppChat.Constants)

local NAV_BAR_WITH_FACEPILE_SIZE = Constants.NAV_BAR_WITH_FACEPILE_SIZE

local v4 = {
	logger = Logger,
	navigateToLuaAppPages = nil,
	parameters = nil,
	rnBypassActionSignal = nil,
	setActiveConversationId = nil,
	setBackButtonEnabled = nil,
	setTabBarVisible = function() end,
	setInitialConversationId = function(_) end,
	wideMode = false,
	notificationCount = 0,
	navigateToRootStack = nil,
	androidBackButtonSignal = nil,
	initialConversationId = "",
	requestedRoute = nil,
	chatPlacement = ChatPlacementContext.Enum.Unknown
}

local function useReactivePaneRestore(joined)
	local v5

	if joined.parameters then
		v5 = joined.parameters.conversationId
	end

	local v6 = useRef(v5)
	local v7 = useCallback(function(current)
		v6.current = current

		local setActiveConversationId = joined.setActiveConversationId

		if setActiveConversationId then
			setActiveConversationId(current)
		end
	end, { joined.setActiveConversationId })

	local v8 = useRef(joined.navigateToRootStack)
	v8.current = joined.navigateToRootStack
	local v9 = useCallback(function(...)
		local current = v8.current

		if current then
			current(...)
		end
	end, {})

	if not joined.navigateToRootStack then
		v9 = joined.navigateToRootStack
	end

	return v6, v7, v9
end

function AppChatEntryPoint(p)
	local joined = Cryo.Dictionary.join(v4, p)
	local placementInExperience = ChatPlacementContext.isPlacementInExperience(joined.chatPlacement)

	if FFlagAppChatReactiveFeatureRestrictions then
		usePartyChatReactiveFeatureRestriction(joined.isVisible and not placementInExperience)
	end

	local v5 = useTokens()

	if v then
		local rootNavigator = require(AppChat.Navigators.Compact.rootNavigator)
		v2 = rootNavigator
		local rootNavigator2 = require(AppChat.Navigators.Wide.rootNavigator)
		v3 = rootNavigator2
	end

	local v6 = useSelector(useCallback(function(p2)
		return p2.LocalUserId
	end, {})) or joined.localUserId
	local v7 = useSelector(useCallback(function(p2)
		return p2.GlobalGuiInset
	end, {})) or { bottom = 0 }
	local v8 = useCallback(function(p2)
		return p2.ChatAppReducer.LastEntryPoint
	end, {})
	local entryPoint

	if FFlagAppChatUseSignalsForLastEntryPoint then
		entryPoint = useSignalState(GetLastEntryPointStore(false).getLastEntryPoint)
	else
		entryPoint = useSelector(v8)
	end

	local dispatch = useDispatch()

	useEffect(function()
		dispatch(AppChatNetworking.rodux.GetChatLandingModal.API(placementInExperience)):catch(function(p2)
			Logger2:warning("Error in GetChatLandingModal request. Error: {}", (tostring(p2)))
		end)
	end, { dispatch, v6, placementInExperience })

	local chatIsVisible = useChatIsVisible()

	local v9 = nil
	local setActiveConversationId, v10

	if FFlagAppChatReactivePaneLayoutOnRotation then
		v9, setActiveConversationId, v10 = useReactivePaneRestore(joined)
	else
		setActiveConversationId = joined.setActiveConversationId
		v10 = joined.navigateToRootStack
	end

	local v11 = React.useMemo(function()
		return {
			container = RoactNavigation.createAppContainer(getRoactChatStackNavigator(
				joined.wideMode and v3 or v2,
				v10,
				joined.androidBackButtonSignal,
				joined.androidBackButtonConnection
			)),
			restoreParameters = v9 and v9.current and { conversationId = v9.current } or nil
		}
	end, {
		joined.wideMode,
		v3,
		v2,
		v10,
		joined.androidBackButtonSignal,
		joined.androidBackButtonConnection,
		v9
	})

	local v12 = useRef(nil)

	if not FFlagAppChatReactivePaneLayoutOnRotation and not placementInExperience and v12.current == nil then
		v12.current = RoactNavigation.createAppContainer(getRoactChatStackNavigator(
			joined.wideMode and v3 or v2,
			joined.navigateToRootStack,
			joined.androidBackButtonSignal,
			joined.androidBackButtonConnection
		))
	end

	local v13

	if placementInExperience or FFlagAppChatReactivePaneLayoutOnRotation then
		v13 = v11.container
	else
		v13 = v12.current
	end

	local v14 = useRef(false)
	local v15 = useRef(nil)
	local v16 = useRef(function(...) end)

	useEffect(function()
		if joined.logger then
			Logger2:setParent(joined.logger)
		end
	end, { joined.logger })

	local v17 = useCallback(function(p2)
		if not v14.current then
			return
		end

		if v16.current then
			v16.current(p2)
		end
	end, { v14, v16 })

	local navigateToLuaAppPages = joined.navigateToLuaAppPages
	useEffect(function()
		local setOverlayDefaultProps = GetOverlayStore(false).setOverlayDefaultProps
		local onViewUserProfile

		if navigateToLuaAppPages then
			onViewUserProfile = navigateToLuaAppPages[EnumScreens.ViewUserProfile]
		end

		setOverlayDefaultProps({ onViewUserProfile = onViewUserProfile })
	end, { navigateToLuaAppPages })

	local v18 = useCallback(function(conversationId)
		return RoactNavigation.Actions.navigate({
			routeName = EnumScreens.ChatConversation,
			params = { conversationId = conversationId }
		})
	end, {})
	local v19 = useCallback(function(conversationId, extraParams)
		local actions = {
			RoactNavigation.Actions.navigate({
				routeName = EnumScreens.ChatConversation,
				params = { conversationId = conversationId }
			}),
			RoactNavigation.Actions.navigate({
				routeName = EnumScreens.SquadLobby,
				params = { conversationId = conversationId, extraParams = extraParams }
			})
		}

		if joined.wideMode then
			return RoactNavigation.Actions.navigate({
				routeName = EnumScreens.ChatLanding,
				params = { conversationId = conversationId },
				action = RoactNavigation.StackActions.reset({ index = 2, actions = actions })
			})
		end

		table.insert(actions, 1, RoactNavigation.Actions.navigate({
			routeName = EnumScreens.ChatLanding
		}))

		return RoactNavigation.Actions.navigate({
			routeName = EnumScreens.ChatLandingStack,
			params = { conversationId = conversationId },
			action = RoactNavigation.StackActions.reset({ index = 3, actions = actions })
		})
	end, { joined.wideMode })

	local v20 = useCallback(function(p2)
		return dispatch(createConversation("one_to_one", { p2 }))
	end, { dispatch })

	local fetchLatestConversationDetails2 = useCallback(function(p2: string)
		return dispatch(fetchLatestConversationDetails(p2))
	end, { dispatch })

	local externalDispatchConnector = useCallback(function(current)
		v16.current = current

		if not joined.updateExternalNavigationForScreen then
			return function()
				v16.current = nil
			end
		end

		local updateExternalNavigationForScreen = joined.updateExternalNavigationForScreen

		if GetFFlagIsSquadEnabled() then
			updateExternalNavigationForScreen(function(p2)
				local conversationId = p2.conversationId
				local omit = Cryo.Dictionary.omit(p2, "conversationId")

				if FFlagAppChatShowOSAOnPageEntry then
					navigateWithOsaGate({
						conversationId = conversationId,
						dispatch = dispatch,
						onAccepted = function()
							current(v19(conversationId, omit))
						end,
						requireMultiUserForU13 = true
					})
				else
					current(v19(conversationId, omit))
				end
			end, EnumScreens.SquadLobby)
		end

		updateExternalNavigationForScreen(function(params)
			if
				not (params and params.conversationId)
				or rootedChatDetailsNavigation.tryNavigateToRootedChatDetails(
					{
						callback = current,
						dispatch = dispatch,
						fetchLatestConversationDetails = fetchLatestConversationDetails2
					},
					params
				)
			then
				return
			end

			current(RoactNavigation.Actions.navigate({
				routeName = EnumScreens.ChatDetails,
				params = params
			}))
		end, EnumScreens.ChatDetails)

		updateExternalNavigationForScreen(function(p2)
			local conversationId = p2 and p2.conversationId

			if conversationId then
				if FFlagAppChatShowOSAOnPageEntry then
					navigateWithOsaGate({
						conversationId = conversationId,
						dispatch = dispatch,
						onAccepted = function()
							if FFlagAppChatPerfTracking then
								AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatConversationTTI, {
									conversationId = conversationId
								})
							end

							current(v18(conversationId))
						end
					})

					return
				end

				if FFlagAppChatPerfTracking then
					AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatConversationTTI, {
						conversationId = conversationId
					})
				end

				fetchLatestConversationDetails2(conversationId):andThen(function()
					Logger2:info(
						"Successfully fetched conversation details for conversationId {} for external navigation",
						conversationId
					)

					current(v18(conversationId))
				end):catch(function(p3)
					Logger2:warning(
						"Error in fetchLatestConversationDetails request before navigate to conversation. error: {}",
						(tostring(p3))
					)

					if FFlagAppChatPerfTracking then
						AppChatPerfTracker.cancel(AppChatPerfTracker.Events.ChatConversationTTI, {
							conversationId = conversationId
						})
					end
				end)
			else
				local userId = p2 and p2.userId

				if not userId then
					return
				end

				spawn(function()
					v20(userId):andThen(function(p3)
						if FFlagAppChatPerfTracking then
							AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatConversationTTI, {
								conversationId = p3.id
							})
						end

						Logger2:info(
							"Successfully fetched conversation details for userId {} for external navigation",
							userId
						)

						if FFlagAppChatShowOSAOnPageEntry then
							navigateWithOsaGate({
								conversationId = p3.id,
								dispatch = dispatch,
								onAccepted = function()
									current(v18(p3.id))
								end
							})
						else
							current(v18(p3.id))
						end
					end):catch(function(p3)
						Logger2:warning(
							"Error in CreateConversation request before navigate to conversation. error: {}",
							(tostring(p3))
						)
					end)
				end)
			end
		end, EnumScreens.ChatConversation)

		updateExternalNavigationForScreen(function(params)
			current(RoactNavigation.Actions.navigate({
				routeName = EnumScreens.ChatLanding,
				params = params
			}))

			if joined.wideMode then
				current(RoactNavigation.Actions.navigate({
					routeName = EnumScreens.EmptyConversation
				}))
			end
		end, EnumScreens.ChatLanding)

		return function()
			updateExternalNavigationForScreen(nil, EnumScreens.ChatLanding)
			updateExternalNavigationForScreen(nil, EnumScreens.ChatDetails)
			updateExternalNavigationForScreen(nil, EnumScreens.ChatConversation)

			if GetFFlagIsSquadEnabled() then
				updateExternalNavigationForScreen(nil, EnumScreens.SquadLobby)
			end

			v16.current = nil
		end
	end, {
		v16,
		v20,
		dispatch,
		fetchLatestConversationDetails2,
		v18,
		v19,
		joined.updateExternalNavigationForScreen,
		joined.wideMode
	})

	local v21 = useCallback(function(object)
		if v15.current then
			v15.current:disconnect()
			v15.current = nil
		end

		if object then
			v15.current = object:connect(v17)
		end
	end, { v15, v17 })

	useEffect(function()
		v14.current = true
		v21(joined.rnBypassActionSignal)

		return function()
			v14.current = false
			v21(nil)

			dispatch(EnteredChatFromEntryPoint())
		end
	end, {})

	useEffect(function()
		if joined.initialConversationId and joined.initialConversationId ~= "" and placementInExperience then
			dispatch(NavigateIntoChat({
				screen = EnumScreens.ChatConversation,
				params = { userId = v6, conversationId = joined.initialConversationId }
			}))

			joined.setInitialConversationId("")
		end

		return function() end
	end, { dispatch, v6, joined.initialConversationId, joined.setInitialConversationId })

	useEffect(function()
		if joined.requestedRoute and placementInExperience then
			dispatch(NavigateIntoChat(joined.requestedRoute))

			if joined.clearRequestedRoute then
				joined.clearRequestedRoute()
			end
		end

		return function() end
	end, { dispatch, placementInExperience, joined.requestedRoute, joined.clearRequestedRoute })

	local v22 = nil
	local conversationId

	if GetFFlagIsSquadEnabled() then
		conversationId = useCurrentSquadParentChannelId()

		if GetFFlagEnableCrossExpVoice() then
			v22 = useIsVoiceConnected()
		end
	else
		conversationId = nil
	end

	useEffect(function()
		if
			GetFFlagIsSquadEnabled()
			and placementInExperience
			and joined.initialConversationId == ""
			and joined.requestedRoute == nil
			and conversationId
		then
			if GetFFlagEnableCrossExpVoice() and v22 then
				dispatch(NavigateIntoChat({
					screen = EnumScreens.SquadLobby,
					params = { userId = v6, conversationId = conversationId }
				}))
			else
				dispatch(NavigateIntoChat({
					screen = EnumScreens.ChatConversation,
					params = { userId = v6, conversationId = conversationId }
				}))
			end
		end
	end, {})

	useEffect(function()
		v21(joined.rnBypassActionSignal)
	end, { joined.rnBypassActionSignal, v21 })

	local v23 = usePageSideMargin(v13.current, FFlagLuaAppCompositionAppChat)
	local v24 = React.useMemo(function()
		return {
			outer = placementInExperience and 12 or v23,
			inner = placementInExperience and 12 or v23,
			default = 12
		}
	end, { v23, placementInExperience })
	local v25 = useStyle()

	local setTabBarVisible = useCallback(function(p2)
		dispatch(SetTabBarVisible(p2))
	end, { dispatch })

	local createElement = React.createElement
	local parameters

	if FFlagAppChatReactivePaneLayoutOnRotation then
		parameters = v11.restoreParameters
	else
		parameters = joined.parameters
	end

	local v26 = {
		externalDispatchConnector = externalDispatchConnector,
		parameters = parameters,
		setActiveConversationId = setActiveConversationId,
		setBackButtonEnabled = joined.setBackButtonEnabled,
		setTabBarVisible = setTabBarVisible,
		chatIsVisible = chatIsVisible,
		screenProps = 0
	}

	local screenProps = {
		navigateToLuaAppPages = joined.navigateToLuaAppPages,
		topBarHeight = 0,
		wideMode = 0,
		isInExperience = 0,
		isVisible = 0,
		notificationCount = 0,
		appChatOuterPadding = 0,
		appChatInnerPadding = 0,
		appChatDefaultPadding = 0,
		topBarUtilityIconSideMargin = 0,
		showSearchRow = 0,
		navigateToRootStack = 0,
		navigateToAddFriends = 0
	}

	local y = UserInputService.NavBarSize.Y
	local v27

	if v5 then
		v27 = v5.Size.Size_1400
	else
		v27 = NAV_BAR_WITH_FACEPILE_SIZE
	end

	screenProps.topBarHeight = math.max(y, v27)

	screenProps.wideMode = joined.wideMode
	screenProps.isInExperience = placementInExperience
	screenProps.isVisible = joined.isVisible
	screenProps.notificationCount = joined.notificationCount
	screenProps.appChatOuterPadding = v24.outer
	screenProps.appChatInnerPadding = v24.inner
	screenProps.appChatDefaultPadding = v24.default
	local topBarUtilityIconSideMargin

	if FFlagEnableHeaderBarButtonsUpdate then
		topBarUtilityIconSideMargin = v5.Size.Size_100
	end

	screenProps.topBarUtilityIconSideMargin = topBarUtilityIconSideMargin
	screenProps.showSearchRow = placementInExperience
	screenProps.navigateToRootStack = joined.navigateToRootStack
	screenProps.navigateToAddFriends = joined.navigateToAddFriends
	v26.screenProps = screenProps
	local element = createElement(v13, v26)

	local element2 = React.createElement(
		LuaAppNavigationContextProvider,
		{ navigateToLuaAppPages = joined.navigateToLuaAppPages, dispatch = dispatch },
		{ navigation = element }
	)

	local v28 = React.useMemo(function()
		return { chatPlacement = joined.chatPlacement }
	end, { joined.chatPlacement })

	local navigation = React.createElement(ChatPlacementContext.Provider, { value = v28 }, {
		navigation = element2
	})

	if not FFlagAppChatSignalsReplyStore then
		navigation = React.createElement(ReplyingToMessageProvider, {}, { navigation = navigation })
	end

	local navigation2 = React.createElement(
		InteractionFeedback.InteractionFeedbackContext.Provider,
		{ value = HapticFeedbackConfig },
		{ navigation = navigation }
	)

	if not placementInExperience then
		navigation2 = React.createElement(LayerCollectorProvider, {}, { navigation = navigation2 })
	end

	local locale = useRobloxLocale()

	local playSessionId = RbxAnalyticsService:GetPlaySessionId()
	local currentSquadId

	if GetFFlagIsSquadEnabled() then
		currentSquadId = useSelector(function(p2)
			local currentSquad = p2.Squad and p2.Squad.Squad and p2.Squad.Squad.currentSquad

			if currentSquad and currentSquad.squadId then
				return currentSquad.squadId
			end

			return nil
		end)
	else
		currentSquadId = nil
	end

	local v29 = React.useMemo(function()
		return {
			context = "platformChat",
			locale = locale,
			entryPoint = entryPoint or "unknown",
			userId = v6,
			playSessionId = playSessionId,
			currentSquadId = currentSquadId,
			placement = joined.chatPlacement
		}
	end, { locale, entryPoint, v6, playSessionId, currentSquadId, joined.chatPlacement })

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local provider = AppTelemetryLayer.Provider
	local bottomInsetBackground

	if v7.bottom > 0 then
		local createElement4 = React.createElement
		local backgroundColor

		if getFFlagFixChatsBottomInsetBackgroundColor() then
			backgroundColor = v25.Theme.BackgroundDefault.Color
		else
			backgroundColor = v25.Theme.NavigationBar.Color
		end

		local backgroundTransparency

		if getFFlagFixChatsBottomInsetBackgroundColor() then
			backgroundTransparency = v25.Theme.BackgroundDefault.Transparency
		else
			backgroundTransparency = v25.Theme.NavigationBar.Transparency
		end

		bottomInsetBackground = createElement4("Frame", {
			BackgroundColor3 = backgroundColor,
			BackgroundTransparency = backgroundTransparency,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, 0, 0, v7.bottom),
			ZIndex = 3
		})
	end

	local element3 = createElement2(AnalyticsProvider, { localUserId = v6, entryPoint = entryPoint }, {
		telemetry = createElement3(provider, { value = v29 }, {
			navigation = navigation2,
			BottomInsetBackground = bottomInsetBackground
		})
	})

	if FFlagAppChatPerfTracking then
		useEffect(function()
			AppChatPerfTracker.setSharedContext({
				placement = joined.chatPlacement,
				entryPoint = entryPoint,
				hasActiveParty = currentSquadId ~= nil
			})
		end, { joined.chatPlacement, entryPoint, currentSquadId })
	end

	return React.createElement(RoactChatAnalyticsProvider, { entryPoint = entryPoint }, { element3 })
end

return memo(AppChatEntryPoint)
