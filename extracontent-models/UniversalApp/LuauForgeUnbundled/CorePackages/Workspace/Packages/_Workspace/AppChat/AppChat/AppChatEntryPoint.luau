local RbxAnalyticsService = game:GetService("RbxAnalyticsService")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/types")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags")

local logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Loggers").Logger
local Logger = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Logger")
local getRoactChatStackNavigator = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/getRoactChatStackNavigator")

local useTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/Foundation").Hooks.useTokens

local v5 = not require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/getFFlagAppChatRemoveDynamicRequires")()
local usePageSideMargin = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/CollectionViews").usePageSideMargin
local v6, v7

if v5 then
	v6 = nil
	v7 = nil
else
	v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Navigators/Compact/rootNavigator")
	v7 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Navigators/Wide/rootNavigator")
end

local AnalyticsProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LegacyAnalytics/AnalyticsProvider")
local ChatPlacementContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Contexts/ChatPlacementContext")
local LuaAppNavigationContextProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/LuaAppNavigationContextProvider")

local setTabBarVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppTabBarRodux").Actions.SetTabBarVisible
local RoactChatAnalyticsProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/RoactChatAnalyticsProvider")
local AppTelemetryLayer = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/Layers/AppTelemetryLayer")

local FFlagAppChatPerfTracking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatPerfTracking")
local AppChatPerfTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Telemetry/AppChatPerfTracker")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")
local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactNavigation")
local UserInputService = game:GetService("UserInputService")
local memo = React.memo
local useCallback = React.useCallback
local useChatIsVisible = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useChatIsVisible")
local useCurrentSquadParentChannelId = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SquadsCore/Hooks").useCurrentSquadParentChannelId
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useIsVoiceConnected = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/CrossExperienceVoice").Hooks.useIsVoiceConnected
local usePartyChatReactiveFeatureRestriction = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/usePartyChatReactiveFeatureRestriction")
local useRef = React.useRef
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/RoactUtils").Hooks.RoactRodux.useSelector
local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Core.Style.useStyle
local useRobloxLocale = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Hooks/useRobloxLocale")

local ReplyingToMessageProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Components/ChatConversation/MessageInteraction/ReplyingContext/ReplyingToMessageProvider")
local FFlagAppChatSignalsReplyStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatSignalsReplyStore")
local fFlagAppChatReactivePaneLayoutOnRotation = SharedFlags.FFlagAppChatReactivePaneLayoutOnRotation
local layerCollectorProvider = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/UIBlox").Core.Layout.LayerCollector.LayerCollectorProvider
local AppChatNetworking = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChatNetworking")
local InteractionFeedback = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/InteractionFeedback")
local hapticFeedbackConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/HapticFeedback").HapticFeedbackConfig

local createConversation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/createConversation")
local module22 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Conversations/Thunks/fetchLatestConversationDetails")
local rootedChatDetailsNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Navigators/rootedChatDetailsNavigation")

local EnumScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/EnumScreens")

local getFFlagIsSquadEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagIsSquadEnabled
local getFFlagEnableCrossExpVoice = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SharedFlags").GetFFlagEnableCrossExpVoice
local fFlagAppChatReactiveFeatureRestrictions = SharedFlags.FFlagAppChatReactiveFeatureRestrictions

local EnteredChatFromEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/EnteredChatFromEntryPoint")
local NavigateIntoChat = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Actions/NavigateIntoChat")

local getFFlagFixChatsBottomInsetBackgroundColor = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/getFFlagFixChatsBottomInsetBackgroundColor")

local GetOverlayStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetOverlayStore")
local navigateWithOsaGate = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Utils/navigateWithOsaGate")
local fFlagAppChatShowOSAOnPageEntry = SharedFlags.FFlagAppChatShowOSAOnPageEntry
local fFlagEnableHeaderBarButtonsUpdate = SharedFlags.FFlagEnableHeaderBarButtonsUpdate
local fFlagLuaAppCompositionAppChat = SharedFlags.FFlagLuaAppCompositionAppChat

local FFlagAppChatUseSignalsForLastEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Flags/FFlagAppChatUseSignalsForLastEntryPoint")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/SignalsReact").useSignalState

local v8 = if FFlagAppChatUseSignalsForLastEntryPoint then require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Stores/GetLastEntryPointStore") else nil

local NAV_BAR_WITH_FACEPILE_SIZE = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Constants").NAV_BAR_WITH_FACEPILE_SIZE

local v9 = {
	logger = logger,
	navigateToLuaAppPages = nil,
	parameters = nil,
	rnBypassActionSignal = nil,
	setActiveConversationId = nil,
	setBackButtonEnabled = nil,
	setTabBarVisible = function() end,
	setInitialConversationId = function(p2) end,
	wideMode = false,
	notificationCount = 0,
	navigateToRootStack = nil,
	androidBackButtonSignal = nil,
	initialConversationId = "",
	requestedRoute = nil,
	chatPlacement = ChatPlacementContext.Enum.Unknown
}

local function useReactivePaneRestore(joined)
	local v11 = if joined.parameters then joined.parameters.conversationId else nil
	local v12 = useRef(v11)
	local v13 = useCallback(function(current)
		v12.current = current

		local setActiveConversationId = joined.setActiveConversationId

		if setActiveConversationId then
			setActiveConversationId(current)
		end
	end, { joined.setActiveConversationId })

	local v14 = useRef(joined.navigateToRootStack)
	v14.current = joined.navigateToRootStack
	local v15 = useCallback(function(...)
		local current = v14.current

		if current then
			current(...)
		end
	end, {})

	if not joined.navigateToRootStack then
		v15 = joined.navigateToRootStack
	end

	return v12, v13, v15
end

function LUAUFORGE_MODULE_GLOBALS_hdj_AppChatEntryPoint(p2)
	local joined = Cryo.Dictionary.join(v9, p2)
	local placementInExperience = ChatPlacementContext.isPlacementInExperience(joined.chatPlacement)

	if fFlagAppChatReactiveFeatureRestrictions then
		usePartyChatReactiveFeatureRestriction(joined.isVisible and not placementInExperience)
	end

	local v10 = useTokens()

	if v5 then
		v6 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Navigators/Compact/rootNavigator")
		v7 = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Navigators/Wide/rootNavigator")
	end

	local v11 = useSelector(useCallback(function(p3)
		return p3.LocalUserId
	end, {})) or joined.localUserId
	local v12 = useSelector(useCallback(function(p3)
		return p3.GlobalGuiInset
	end, {})) or { bottom = 0 }
	local v13 = useCallback(function(p3)
		return p3.ChatAppReducer.LastEntryPoint
	end, {})

	local v14 = if FFlagAppChatUseSignalsForLastEntryPoint then useSignalState(v8(false).getLastEntryPoint) else useSelector(v13)

	local v15 = useDispatch()

	useEffect(function()
		v15(AppChatNetworking.rodux.GetChatLandingModal.API(placementInExperience)):catch(function(p3)
			Logger:warning("Error in GetChatLandingModal request. Error: {}", (tostring(p3)))
		end)
	end, { v15, v11, placementInExperience })

	local v16 = useChatIsVisible()

	local v17 = nil
	local v18, v19

	if fFlagAppChatReactivePaneLayoutOnRotation then
		v17, v18, v19 = useReactivePaneRestore(joined)
	else
		v18 = joined.setActiveConversationId
		v19 = joined.navigateToRootStack
	end

	local v20 = React.useMemo(function()
		return {
			container = RoactNavigation.createAppContainer(getRoactChatStackNavigator(
				joined.wideMode and v7 or v6,
				v19,
				joined.androidBackButtonSignal,
				joined.androidBackButtonConnection
			)),
			restoreParameters = v17 and v17.current and { conversationId = v17.current } or nil
		}
	end, {
		joined.wideMode,
		v7,
		v6,
		v19,
		joined.androidBackButtonSignal,
		joined.androidBackButtonConnection,
		v17
	})

	local v21 = useRef(nil)

	if
		not fFlagAppChatReactivePaneLayoutOnRotation
		and not placementInExperience
		and v21.current == nil
	then
		v21.current = RoactNavigation.createAppContainer(getRoactChatStackNavigator(
			joined.wideMode and v7 or v6,
			joined.navigateToRootStack,
			joined.androidBackButtonSignal,
			joined.androidBackButtonConnection
		))
	end

	local v22

	if placementInExperience or fFlagAppChatReactivePaneLayoutOnRotation then
		v22 = v20.container
	else
		v22 = v21.current
	end

	local v23 = useRef(false)
	local v24 = useRef(nil)
	local v25 = useRef(function(...) end)

	useEffect(function()
		if joined.logger then
			Logger:setParent(joined.logger)
		end
	end, { joined.logger })

	local v26 = useCallback(function(p3)
		if not v23.current then
			return
		end

		if v25.current then
			v25.current(p3)
		end
	end, { v23, v25 })

	local navigateToLuaAppPages = joined.navigateToLuaAppPages
	useEffect(function()
		local setOverlayDefaultProps = GetOverlayStore(false).setOverlayDefaultProps

		local v28 = if navigateToLuaAppPages then navigateToLuaAppPages[EnumScreens.ViewUserProfile] else nil
		setOverlayDefaultProps({ onViewUserProfile = v28 })
	end, { navigateToLuaAppPages })

	local v27 = useCallback(function(p3)
		return RoactNavigation.Actions.navigate({
			routeName = EnumScreens.ChatConversation,
			params = { conversationId = p3 }
		})
	end, {})
	local v28 = useCallback(function(p3, p4)
		local v29 = {
			RoactNavigation.Actions.navigate({
				routeName = EnumScreens.ChatConversation,
				params = { conversationId = p3 }
			}),
			RoactNavigation.Actions.navigate({
				routeName = EnumScreens.SquadLobby,
				params = { conversationId = p3, extraParams = p4 }
			})
		}

		if joined.wideMode then
			return RoactNavigation.Actions.navigate({
				routeName = EnumScreens.ChatLanding,
				params = { conversationId = p3 },
				action = RoactNavigation.StackActions.reset({ index = 2, actions = v29 })
			})
		end

		table.insert(v29, 1, RoactNavigation.Actions.navigate({
			routeName = EnumScreens.ChatLanding
		}))

		return RoactNavigation.Actions.navigate({
			routeName = EnumScreens.ChatLandingStack,
			params = { conversationId = p3 },
			action = RoactNavigation.StackActions.reset({ index = 3, actions = v29 })
		})
	end, { joined.wideMode })

	local v29 = useCallback(function(p3)
		return v15(createConversation("one_to_one", { p3 }))
	end, { v15 })

	local v30 = useCallback(function(p3)
		return v15(module22(p3))
	end, { v15 })

	local v31 = useCallback(function(current)
		v25.current = current

		if not joined.updateExternalNavigationForScreen then
			return function()
				v25.current = nil
			end
		end

		local updateExternalNavigationForScreen = joined.updateExternalNavigationForScreen

		if getFFlagIsSquadEnabled() then
			updateExternalNavigationForScreen(function(p3)
				local conversationId = p3.conversationId
				local omit = Cryo.Dictionary.omit(p3, "conversationId")

				if fFlagAppChatShowOSAOnPageEntry then
					navigateWithOsaGate({
						conversationId = conversationId,
						dispatch = v15,
						onAccepted = function()
							current(v28(conversationId, omit))
						end,
						requireMultiUserForU13 = true
					})
				else
					current(v28(conversationId, omit))
				end
			end, EnumScreens.SquadLobby)
		end

		updateExternalNavigationForScreen(function(p3)
			if
				not (p3 and p3.conversationId)
				or rootedChatDetailsNavigation.tryNavigateToRootedChatDetails(
					{
						callback = current,
						dispatch = v15,
						fetchLatestConversationDetails = v30
					},
					p3
				)
			then
				return
			end

			current(RoactNavigation.Actions.navigate({
				routeName = EnumScreens.ChatDetails,
				params = p3
			}))
		end, EnumScreens.ChatDetails)

		updateExternalNavigationForScreen(function(p3)
			local conversationId = p3 and p3.conversationId

			if conversationId then
				if fFlagAppChatShowOSAOnPageEntry then
					navigateWithOsaGate({
						conversationId = conversationId,
						dispatch = v15,
						onAccepted = function()
							if FFlagAppChatPerfTracking then
								AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatConversationTTI, {
									conversationId = conversationId
								})
							end

							current(v27(conversationId))
						end
					})

					return
				end

				if FFlagAppChatPerfTracking then
					AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatConversationTTI, {
						conversationId = conversationId
					})
				end

				v30(conversationId):andThen(function()
					Logger:info(
						"Successfully fetched conversation details for conversationId {} for external navigation",
						conversationId
					)

					current(v27(conversationId))
				end):catch(function(p4)
					Logger:warning(
						"Error in fetchLatestConversationDetails request before navigate to conversation. error: {}",
						(tostring(p4))
					)

					if FFlagAppChatPerfTracking then
						AppChatPerfTracker.cancel(AppChatPerfTracker.Events.ChatConversationTTI, {
							conversationId = conversationId
						})
					end
				end)
			else
				local userId = p3 and p3.userId

				if not userId then
					return
				end

				spawn(function()
					v29(userId):andThen(function(p4)
						if FFlagAppChatPerfTracking then
							AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatConversationTTI, {
								conversationId = p4.id
							})
						end

						Logger:info(
							"Successfully fetched conversation details for userId {} for external navigation",
							userId
						)

						if fFlagAppChatShowOSAOnPageEntry then
							navigateWithOsaGate({
								conversationId = p4.id,
								dispatch = v15,
								onAccepted = function()
									current(v27(p4.id))
								end
							})
						else
							current(v27(p4.id))
						end
					end):catch(function(p4)
						Logger:warning(
							"Error in CreateConversation request before navigate to conversation. error: {}",
							(tostring(p4))
						)
					end)
				end)
			end
		end, EnumScreens.ChatConversation)

		updateExternalNavigationForScreen(function(p3)
			current(RoactNavigation.Actions.navigate({
				routeName = EnumScreens.ChatLanding,
				params = p3
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

			if getFFlagIsSquadEnabled() then
				updateExternalNavigationForScreen(nil, EnumScreens.SquadLobby)
			end

			v25.current = nil
		end
	end, {
		v25,
		v29,
		v15,
		v30,
		v27,
		v28,
		joined.updateExternalNavigationForScreen,
		joined.wideMode
	})

	local v32 = useCallback(function(object)
		if v24.current then
			v24.current:disconnect()
			v24.current = nil
		end

		if object then
			v24.current = object:connect(v26)
		end
	end, { v24, v26 })

	useEffect(function()
		v23.current = true
		v32(joined.rnBypassActionSignal)

		return function()
			v23.current = false
			v32(nil)

			v15(EnteredChatFromEntryPoint())
		end
	end, {})

	useEffect(function()
		if
			joined.initialConversationId
			and joined.initialConversationId ~= ""
			and placementInExperience
		then
			v15(NavigateIntoChat({
				screen = EnumScreens.ChatConversation,
				params = { userId = v11, conversationId = joined.initialConversationId }
			}))

			joined.setInitialConversationId("")
		end

		return function() end
	end, { v15, v11, joined.initialConversationId, joined.setInitialConversationId })

	useEffect(function()
		if joined.requestedRoute and placementInExperience then
			v15(NavigateIntoChat(joined.requestedRoute))

			if joined.clearRequestedRoute then
				joined.clearRequestedRoute()
			end
		end

		return function() end
	end, {
		v15,
		placementInExperience,
		joined.requestedRoute,
		joined.clearRequestedRoute
	})

	local v33 = nil
	local v34

	if getFFlagIsSquadEnabled() then
		v34 = useCurrentSquadParentChannelId()

		if getFFlagEnableCrossExpVoice() then
			v33 = useIsVoiceConnected()
		end
	else
		v34 = nil
	end

	useEffect(function()
		if
			getFFlagIsSquadEnabled()
			and placementInExperience
			and joined.initialConversationId == ""
			and joined.requestedRoute == nil
			and v34
		then
			if getFFlagEnableCrossExpVoice() and v33 then
				v15(NavigateIntoChat({
					screen = EnumScreens.SquadLobby,
					params = { userId = v11, conversationId = v34 }
				}))
			else
				v15(NavigateIntoChat({
					screen = EnumScreens.ChatConversation,
					params = { userId = v11, conversationId = v34 }
				}))
			end
		end
	end, {})

	useEffect(function()
		v32(joined.rnBypassActionSignal)
	end, { joined.rnBypassActionSignal, v32 })

	local v35 = usePageSideMargin(v22.current, fFlagLuaAppCompositionAppChat)
	local v36 = React.useMemo(function()
		return {
			outer = placementInExperience and 12 or v35,
			inner = placementInExperience and 12 or v35,
			default = 12
		}
	end, { v35, placementInExperience })
	local v37 = useStyle()

	local v38 = useCallback(function(p3)
		v15(setTabBarVisible(p3))
	end, { v15 })

	local createElement = React.createElement

	local v40 = if fFlagAppChatReactivePaneLayoutOnRotation then v20.restoreParameters else joined.parameters
	local v39 = {
		externalDispatchConnector = v31,
		parameters = v40,
		setActiveConversationId = v18,
		setBackButtonEnabled = joined.setBackButtonEnabled,
		setTabBarVisible = v38,
		chatIsVisible = v16,
		screenProps = 0
	}

	local v41 = {
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
	local v42 = if v10 then v10.Size.Size_1400 else NAV_BAR_WITH_FACEPILE_SIZE
	v41.topBarHeight = math.max(y, v42)

	v41.wideMode = joined.wideMode
	v41.isInExperience = placementInExperience
	v41.isVisible = joined.isVisible
	v41.notificationCount = joined.notificationCount
	v41.appChatOuterPadding = v36.outer
	v41.appChatInnerPadding = v36.inner
	v41.appChatDefaultPadding = v36.default
	local v43 = if fFlagEnableHeaderBarButtonsUpdate then v10.Size.Size_100 else nil
	v41.topBarUtilityIconSideMargin = v43
	v41.showSearchRow = placementInExperience
	v41.navigateToRootStack = joined.navigateToRootStack
	v41.navigateToAddFriends = joined.navigateToAddFriends
	v39.screenProps = v41
	local element = createElement(v22, v39)

	local element2 = React.createElement(
		LuaAppNavigationContextProvider,
		{ navigateToLuaAppPages = joined.navigateToLuaAppPages, dispatch = v15 },
		{ navigation = element }
	)

	local v44 = React.useMemo(function()
		return { chatPlacement = joined.chatPlacement }
	end, { joined.chatPlacement })

	local v45 = React.createElement(ChatPlacementContext.Provider, { value = v44 }, {
		navigation = element2
	})

	if not FFlagAppChatSignalsReplyStore then
		v45 = React.createElement(ReplyingToMessageProvider, {}, { navigation = v45 })
	end

	local v46 = React.createElement(
		InteractionFeedback.InteractionFeedbackContext.Provider,
		{ value = hapticFeedbackConfig },
		{ navigation = v45 }
	)

	if not placementInExperience then
		v46 = React.createElement(layerCollectorProvider, {}, { navigation = v46 })
	end

	local v47 = useRobloxLocale()

	local playSessionId = RbxAnalyticsService:GetPlaySessionId()
	local v48

	if getFFlagIsSquadEnabled() then
		v48 = useSelector(function(p3)
			local currentSquad = p3.Squad and p3.Squad.Squad and p3.Squad.Squad.currentSquad

			if currentSquad and currentSquad.squadId then
				return currentSquad.squadId
			end

			return nil
		end)
	else
		v48 = nil
	end

	local v49 = React.useMemo(function()
		return {
			context = "platformChat",
			locale = v47,
			entryPoint = v14 or "unknown",
			userId = v11,
			playSessionId = playSessionId,
			currentSquadId = v48,
			placement = joined.chatPlacement
		}
	end, { v47, v14, v11, playSessionId, v48, joined.chatPlacement })

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local provider = AppTelemetryLayer.Provider
	local v55

	if v12.bottom > 0 then
		local createElement4 = React.createElement
		local v58 = if getFFlagFixChatsBottomInsetBackgroundColor() then v37.Theme.BackgroundDefault.Color else v37.Theme.NavigationBar.Color
		local v59 = if getFFlagFixChatsBottomInsetBackgroundColor() then v37.Theme.BackgroundDefault.Transparency else v37.Theme.NavigationBar.Transparency
		v55 = createElement4("Frame", {
			BackgroundColor3 = v58,
			BackgroundTransparency = v59,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, 0, 0, v12.bottom),
			ZIndex = 3
		})
	end

	local element3 = createElement2(AnalyticsProvider, { localUserId = v11, entryPoint = v14 }, {
		telemetry = createElement3(provider, { value = v49 }, {
			navigation = v46,
			BottomInsetBackground = v55
		})
	})

	if FFlagAppChatPerfTracking then
		useEffect(function()
			AppChatPerfTracker.setSharedContext({
				placement = joined.chatPlacement,
				entryPoint = v14,
				hasActiveParty = v48 ~= nil
			})
		end, { joined.chatPlacement, v14, v48 })
	end

	return React.createElement(RoactChatAnalyticsProvider, { entryPoint = v14 }, { element3 })
end

return memo(LUAUFORGE_MODULE_GLOBALS_hdj_AppChatEntryPoint)
