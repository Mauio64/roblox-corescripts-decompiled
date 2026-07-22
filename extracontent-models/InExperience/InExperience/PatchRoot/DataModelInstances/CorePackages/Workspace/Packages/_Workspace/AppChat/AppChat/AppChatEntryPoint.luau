local AppChat = script:FindFirstAncestor("AppChat")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local AppChatParent = AppChat.Parent
local ArgCheck = require(AppChatParent.ArgCheck)
local Cryo = require(AppChatParent.Cryo)

require(AppChat.types)

local SharedFlags = require(AppChatParent.SharedFlags)
local Logger = require(AppChatParent.Loggers).Logger
local Logger2 = require(AppChat.Logger)
local getRoactChatStackNavigator = require(AppChat.getRoactChatStackNavigator)
local useTokens = require(AppChatParent.Foundation).Hooks.useTokens
local rootNavigator = nil
local rootNavigator2 = nil
local v13 = not require(AppChat.Flags.getFFlagAppChatRemoveDynamicRequires)()
local usePageSideMargin = require(AppChatParent.CollectionViews).usePageSideMargin

if not v13 then
	rootNavigator = require(AppChat.Navigators.Compact.rootNavigator)
	rootNavigator2 = require(AppChat.Navigators.Wide.rootNavigator)
end

local AnalyticsProvider = require(AppChat.LegacyAnalytics.AnalyticsProvider)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local TopBarContext = require(AppChat.TopBarContext)
local ChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext)
local FFlagAppChatTopBarSignalsStore = require(AppChat.Flags.FFlagAppChatTopBarSignalsStore)
local LuaAppNavigationContextProvider = require(AppChat.LuaAppNavigationContextProvider)
local SetTabBarVisible = require(AppChatParent.AppTabBarRodux).Actions.SetTabBarVisible
local RoactChatAnalyticsProvider = require(AppChat.Analytics.RoactChatAnalyticsProvider)
local AppTelemetryLayer = require(AppChat.Telemetry.Layers.AppTelemetryLayer)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local React = require(AppChatParent.React)
local RoactNavigation = require(AppChatParent.RoactNavigation)
local UserInputService = game:GetService("UserInputService")
local memo = React.memo
local useAppPolicy = require(AppChat.Hooks.useAppPolicy)
local useCallback = React.useCallback
local useChatIsVisible = require(AppChat.Hooks.useChatIsVisible)
local useCurrentSquadParentChannelId = require(AppChatParent.SquadsCore.Hooks).useCurrentSquadParentChannelId
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useEffect = React.useEffect
local useIsVoiceConnected = require(AppChatParent.CrossExperienceVoice).Hooks.useIsVoiceConnected
local useRef = React.useRef
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local useState = React.useState
local useStyle = require(AppChatParent.UIBlox).Core.Style.useStyle
local useRobloxLocale = require(AppChat.Hooks.useRobloxLocale)
local ReplyingToMessageProvider = require(AppChat.Components.ChatConversation.MessageInteraction.ReplyingContext.ReplyingToMessageProvider)
local FFlagAppChatSignalsReplyStore = require(AppChat.Flags.FFlagAppChatSignalsReplyStore)
local LayerCollectorProvider = require(AppChatParent.UIBlox).Core.Layout.LayerCollector.LayerCollectorProvider
local useIsChatEnabled = require(AppChat.Hooks.useIsChatEnabled)
local AppChatNetworking = require(AppChatParent.AppChatNetworking)
local InteractionFeedback = require(AppChatParent.InteractionFeedback)
local HapticFeedbackConfig = require(AppChat.Utils.HapticFeedback).HapticFeedbackConfig
local createConversation = require(AppChat.Conversations.Thunks.createConversation)
local fetchLatestConversationDetails = require(AppChat.Conversations.Thunks.fetchLatestConversationDetails)
local rootedChatDetailsNavigation = require(AppChat.Navigators.rootedChatDetailsNavigation)
local EnumScreens = require(script.Parent.EnumScreens)
local GetFFlagIsSquadEnabled = require(AppChatParent.SharedFlags).GetFFlagIsSquadEnabled
local GetFFlagEnableCrossExpVoice = require(AppChatParent.SharedFlags).GetFFlagEnableCrossExpVoice
local FFlagAppChatRemoveNotifications = require(AppChatParent.SharedFlags).FFlagAppChatRemoveNotifications
local EnteredChatFromEntryPoint = require(AppChat.Actions.EnteredChatFromEntryPoint)
local NavigateIntoChat = require(AppChat.Actions.NavigateIntoChat)
local getFFlagHideNotificationIconForVR = require(AppChat.Flags.getFFlagHideNotificationIconForVR)
local getFFlagFixChatsBottomInsetBackgroundColor = require(AppChat.Flags.getFFlagFixChatsBottomInsetBackgroundColor)
local GetFFlagEnableAppChatInExperience = SharedFlags.GetFFlagEnableAppChatInExperience
local FFlagAppChatTopBarConfigDriven = require(AppChat.Flags.FFlagAppChatTopBarConfigDriven)
local getFFlagAppChatRequestedRoute = require(AppChat.Flags.getFFlagAppChatRequestedRoute)
local FFlagSupportViewingUserProfileOnOSA = require(AppChat.Flags.FFlagSupportViewingUserProfileOnOSA)
local GetOverlayStore = require(AppChat.Stores.GetOverlayStore)
local navigateWithOsaGate = require(AppChat.Utils.navigateWithOsaGate)
local FFlagAppChatShowOSAOnPageEntry = SharedFlags.FFlagAppChatShowOSAOnPageEntry
local FFlagEnableHeaderBarButtonsUpdate = SharedFlags.FFlagEnableHeaderBarButtonsUpdate
local FFlagLuaAppCompositionAppChat = SharedFlags.FFlagLuaAppCompositionAppChat
local NAV_BAR_WITH_FACEPILE_SIZE = require(AppChat.Constants).NAV_BAR_WITH_FACEPILE_SIZE
local t1 = {
	navigateToLuaAppPages = nil,
	parameters = nil,
	rnBypassActionSignal = nil,
	setActiveConversationId = nil,
	setBackButtonEnabled = nil,
	wideMode = false,
	notificationCount = 0,
	navigateToRootStack = nil,
	androidBackButtonSignal = nil,
	initialConversationId = "",
	requestedRoute = nil,
	logger = Logger,
	setTabBarVisible = function() -- line: 130
	end,
	setInitialConversationId = function(_) -- line: 131
	end,
	chatPlacement = ChatPlacementContext.Enum.Unknown
}

function AppChatEntryPoint(p2) -- line: 145
	-- upvalues: Cryo (copy), t1 (copy), ChatPlacementContext (copy), useTokens (copy), v13 (copy), rootNavigator (ref), AppChat (copy), rootNavigator2 (ref), useSelector (copy), useCallback (copy), useDispatch (copy), useEffect (copy), AppChatNetworking (copy), Logger2 (copy), useChatIsVisible (copy), useState (copy), React (copy), RoactNavigation (copy), getRoactChatStackNavigator (copy), useRef (copy), FFlagSupportViewingUserProfileOnOSA (copy), GetOverlayStore (copy), EnumScreens (copy), createConversation (copy), fetchLatestConversationDetails (copy), GetFFlagIsSquadEnabled (copy), FFlagAppChatShowOSAOnPageEntry (copy), navigateWithOsaGate (copy), getFFlagAppChatRequestedRoute (copy), rootedChatDetailsNavigation (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), GetTopBarStore (copy), ArgCheck (copy), FFlagAppChatTopBarSignalsStore (copy), EnteredChatFromEntryPoint (copy), NavigateIntoChat (copy), useCurrentSquadParentChannelId (copy), GetFFlagEnableCrossExpVoice (copy), useIsVoiceConnected (copy), useAppPolicy (copy), getFFlagHideNotificationIconForVR (copy), usePageSideMargin (copy), FFlagLuaAppCompositionAppChat (copy), useIsChatEnabled (copy), FFlagAppChatTopBarConfigDriven (copy), FFlagAppChatRemoveNotifications (copy), GetFFlagEnableAppChatInExperience (copy), useStyle (copy), SetTabBarVisible (copy), UserInputService (copy), NAV_BAR_WITH_FACEPILE_SIZE (copy), FFlagEnableHeaderBarButtonsUpdate (copy), LuaAppNavigationContextProvider (copy), FFlagAppChatSignalsReplyStore (copy), ReplyingToMessageProvider (copy), InteractionFeedback (copy), HapticFeedbackConfig (copy), LayerCollectorProvider (copy), useRobloxLocale (copy), RbxAnalyticsService (copy), AnalyticsProvider (copy), AppTelemetryLayer (copy), TopBarContext (copy), getFFlagFixChatsBottomInsetBackgroundColor (copy), RoactChatAnalyticsProvider (copy)
	local v73 = Cryo.Dictionary.join(t1, p2)
	local v74 = ChatPlacementContext.isPlacementInExperience(v73.chatPlacement)
	local v75 = useTokens()

	if v13 then
		rootNavigator = require(AppChat.Navigators.Compact.rootNavigator)
		rootNavigator2 = require(AppChat.Navigators.Wide.rootNavigator)
	end

	local v76 = useSelector(useCallback(function(p3) -- line: 156
		return p3.LocalUserId
	end, {})) or v73.localUserId
	local v77 = useSelector(useCallback(function(p4) -- line: 159
		return p4.GlobalGuiInset
	end, {})) or {
		bottom = 0
	}
	local v78 = useCallback(function(p5) -- line: 162
		return p5.ChatAppReducer.LastEntryPoint
	end, {})
	local v79 = useSelector(v78)
	local v80 = useDispatch()

	useEffect(function() -- line: 169
		-- upvalues: v80 (copy), AppChatNetworking (copy), v74 (copy), Logger2 (copy)
		v80(AppChatNetworking.rodux.GetChatLandingModal.API(v74)):catch(function(p6) -- line: 170
			-- upvalues: Logger2 (copy)
			Logger2:warning("Error in GetChatLandingModal request. Error: {}", (tostring(p6)))
		end)
	end, {
		v80,
		v76,
		v74
	})

	local v81 = useChatIsVisible()
	local v82, v83 = useState({})
	local v84 = React.useMemo(function() -- line: 179
		-- upvalues: RoactNavigation (copy), getRoactChatStackNavigator (copy), v73 (copy), rootNavigator2 (ref), rootNavigator (ref)
		return RoactNavigation.createAppContainer(getRoactChatStackNavigator(v73.wideMode and rootNavigator2 or rootNavigator, v73.navigateToRootStack, v73.androidBackButtonSignal, v73.androidBackButtonConnection))
	end, {
		v73.wideMode,
		rootNavigator2,
		rootNavigator,
		v73.navigateToRootStack,
		v73.androidBackButtonSignal,
		v73.androidBackButtonConnection
	})
	local v85 = useRef(nil)

	if not v74 and v85.current == nil then
		v85.current = RoactNavigation.createAppContainer(getRoactChatStackNavigator(v73.wideMode and rootNavigator2 or rootNavigator, v73.navigateToRootStack, v73.androidBackButtonSignal, v73.androidBackButtonConnection))
	end

	local v86 = if not v74 then v85.current else v84
	local v87 = useRef(false)
	local v88 = useRef(nil)
	local v89 = useRef(function(...) -- line: 212
	end)

	useEffect(function() -- line: 214
		-- upvalues: v73 (copy), Logger2 (copy)
		if v73.logger then
			Logger2:setParent(v73.logger)
		end
	end, { v73.logger })

	local v90 = useCallback(function(p7) -- line: 220
		-- upvalues: v87 (copy), v89 (copy)
		if not v87.current then
			return
		end

		if v89.current then
			v89.current(p7)
		end
	end, {
		v87,
		v89
	})

	if FFlagSupportViewingUserProfileOnOSA then
		local navigateToLuaAppPages = v73.navigateToLuaAppPages

		useEffect(function() -- line: 232
			-- upvalues: GetOverlayStore (copy), navigateToLuaAppPages (copy), EnumScreens (copy)
			GetOverlayStore(false).setOverlayDefaultProps({
				onViewUserProfile = if not navigateToLuaAppPages then nil else navigateToLuaAppPages[EnumScreens.ViewUserProfile]
			})
		end, { navigateToLuaAppPages })
	end

	local v92 = useCallback(function(p8) -- line: 242
		-- upvalues: RoactNavigation (copy), EnumScreens (copy)
		return RoactNavigation.Actions.navigate({
			routeName = EnumScreens.ChatConversation,
			params = {
				conversationId = p8
			}
		})
	end, {})
	local v93 = useCallback(function(p9, p10) -- line: 250
		-- upvalues: RoactNavigation (copy), EnumScreens (copy), v73 (copy)
		local t2 = {
			RoactNavigation.Actions.navigate({
				routeName = EnumScreens.ChatConversation,
				params = {
					conversationId = p9
				}
			}),
			RoactNavigation.Actions.navigate({
				routeName = EnumScreens.SquadLobby,
				params = {
					conversationId = p9,
					extraParams = p10
				}
			})
		}

		if v73.wideMode then
			return RoactNavigation.Actions.navigate({
				routeName = EnumScreens.ChatLanding,
				params = {
					conversationId = p9
				},
				action = RoactNavigation.StackActions.reset({
					index = 2,
					actions = t2
				})
			})
		end

		table.insert(t2, 1, RoactNavigation.Actions.navigate({
			routeName = EnumScreens.ChatLanding
		}))

		return RoactNavigation.Actions.navigate({
			routeName = EnumScreens.ChatLandingStack,
			params = {
				conversationId = p9
			},
			action = RoactNavigation.StackActions.reset({
				index = 3,
				actions = t2
			})
		})
	end, { v73.wideMode })
	local v94 = useCallback(function(p11) -- line: 299
		-- upvalues: v80 (copy), createConversation (copy)
		return v80(createConversation("one_to_one", { p11 }))
	end, { v80 })
	local v95 = useCallback(function(s1: string) -- line: 303
		-- upvalues: v80 (copy), fetchLatestConversationDetails (copy)
		return v80(fetchLatestConversationDetails(s1))
	end, { v80 })
	local v96 = useCallback(function(p12: ((...any) -> ...any)) -- line: 308
		-- upvalues: v89 (copy), v73 (copy), GetFFlagIsSquadEnabled (copy), Cryo (copy), FFlagAppChatShowOSAOnPageEntry (copy), navigateWithOsaGate (copy), v80 (copy), v93 (copy), EnumScreens (copy), getFFlagAppChatRequestedRoute (copy), rootedChatDetailsNavigation (copy), v95 (copy), RoactNavigation (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), Logger2 (copy), v92 (copy), v94 (copy)
		v89.current = p12

		if not v73.updateExternalNavigationForScreen then
			return function() -- line: 311
				-- upvalues: v89 (copy)
				v89.current = nil
			end
		end

		local updateExternalNavigationForScreen = v73.updateExternalNavigationForScreen

		if GetFFlagIsSquadEnabled() then
			updateExternalNavigationForScreen(function(p13) -- line: 318
				-- upvalues: Cryo (copy), FFlagAppChatShowOSAOnPageEntry (copy), navigateWithOsaGate (copy), v80 (copy), p12 (copy), v93 (copy)
				local conversationId = p13.conversationId
				local v154 = Cryo.Dictionary.omit(p13, "conversationId")

				if FFlagAppChatShowOSAOnPageEntry then
					navigateWithOsaGate({
						requireMultiUserForU13 = true,
						conversationId = conversationId,
						dispatch = v80,
						onAccepted = function() -- line: 325
							-- upvalues: p12 (copy), v93 (copy), conversationId (copy), v154 (copy)
							p12(v93(conversationId, v154))
						end
					})

					return
				end

				p12(v93(conversationId, v154))
			end, EnumScreens.SquadLobby)
		end

		if getFFlagAppChatRequestedRoute() then
			updateExternalNavigationForScreen(function(p14) -- line: 337
				-- upvalues: rootedChatDetailsNavigation (copy), p12 (copy), v80 (copy), v95 (copy), RoactNavigation (copy), EnumScreens (copy)
				if not p14 or not p14.conversationId then
					return
				end

				if rootedChatDetailsNavigation.tryNavigateToRootedChatDetails({
					callback = p12,
					dispatch = v80,
					fetchLatestConversationDetails = v95
				}, p14) then
					return
				end

				p12(RoactNavigation.Actions.navigate({
					routeName = EnumScreens.ChatDetails,
					params = p14
				}))
			end, EnumScreens.ChatDetails)
		end

		updateExternalNavigationForScreen(function(p15) -- line: 360
			-- upvalues: FFlagAppChatShowOSAOnPageEntry (copy), navigateWithOsaGate (copy), v80 (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), v95 (copy), Logger2 (copy), p12 (copy), v92 (copy), v94 (copy)
			local v157 = p15 and p15.conversationId

			if v157 then
				if not FFlagAppChatShowOSAOnPageEntry then
					if FFlagAppChatPerfTracking then
						AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatConversationTTI, {
							conversationId = v157
						})
					end

					v95(v157):andThen(function() -- line: 402
						-- upvalues: Logger2 (copy), v157 (copy), p12 (copy), v92 (copy)
						Logger2:info("Successfully fetched conversation details for conversationId {} for external navigation", v157)
						p12(v92(v157))
					end):catch(function(p16) -- line: 409
						-- upvalues: Logger2 (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), v157 (copy)
						Logger2:warning("Error in fetchLatestConversationDetails request before navigate to conversation. error: {}", (tostring(p16)))

						if FFlagAppChatPerfTracking then
							AppChatPerfTracker.cancel(AppChatPerfTracker.Events.ChatConversationTTI, {
								conversationId = v157
							})
						end
					end)

					return
				end

				navigateWithOsaGate({
					conversationId = v157,
					dispatch = v80,
					onAccepted = function() -- line: 368
						-- upvalues: FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), v157 (copy), v95 (copy), Logger2 (copy), p12 (copy), v92 (copy)
						if FFlagAppChatPerfTracking then
							AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatConversationTTI, {
								conversationId = v157
							})
						end

						v95(v157):andThen(function() -- line: 375
							-- upvalues: Logger2 (copy), v157 (copy), p12 (copy), v92 (copy)
							Logger2:info("Successfully fetched conversation details for conversationId {} for external navigation", v157)
							p12(v92(v157))
						end):catch(function(p17) -- line: 382
							-- upvalues: Logger2 (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), v157 (copy)
							Logger2:warning("Error in fetchLatestConversationDetails request before navigate to conversation. error: {}", (tostring(p17)))

							if FFlagAppChatPerfTracking then
								AppChatPerfTracker.cancel(AppChatPerfTracker.Events.ChatConversationTTI, {
									conversationId = v157
								})
							end
						end)
					end
				})
			end

			local v158 = p15 and p15.userId

			if not v158 then
				return
			end

			spawn(function() -- line: 430
				-- upvalues: v94 (copy), v158 (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), Logger2 (copy), FFlagAppChatShowOSAOnPageEntry (copy), navigateWithOsaGate (copy), v80 (copy), p12 (copy), v92 (copy)
				v94(v158):andThen(function(p18) -- line: 432
					-- upvalues: FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), Logger2 (copy), v158 (copy), FFlagAppChatShowOSAOnPageEntry (copy), navigateWithOsaGate (copy), v80 (copy), p12 (copy), v92 (copy)
					if FFlagAppChatPerfTracking then
						AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatConversationTTI, {
							conversationId = p18.id
						})
					end

					Logger2:info("Successfully fetched conversation details for userId {} for external navigation", v158)

					if FFlagAppChatShowOSAOnPageEntry then
						navigateWithOsaGate({
							conversationId = p18.id,
							dispatch = v80,
							onAccepted = function() -- line: 446
								-- upvalues: p12 (copy), v92 (copy), p18 (copy)
								p12(v92(p18.id))
							end
						})

						return
					end

					p12(v92(p18.id))
				end):catch(function(p19) -- line: 454
					-- upvalues: Logger2 (copy)
					Logger2:warning("Error in CreateConversation request before navigate to conversation. error: {}", (tostring(p19)))
				end)
			end)
		end, EnumScreens.ChatConversation)
		updateExternalNavigationForScreen(function(p20) -- line: 464
			-- upvalues: p12 (copy), RoactNavigation (copy), EnumScreens (copy), v73 (copy)
			p12(RoactNavigation.Actions.navigate({
				routeName = EnumScreens.ChatLanding,
				params = p20
			}))

			if v73.wideMode then
				p12(RoactNavigation.Actions.navigate({
					routeName = EnumScreens.EmptyConversation
				}))
			end
		end, EnumScreens.ChatLanding)

		return function() -- line: 476
			-- upvalues: updateExternalNavigationForScreen (copy), EnumScreens (copy), getFFlagAppChatRequestedRoute (copy), GetFFlagIsSquadEnabled (copy), v89 (copy)
			updateExternalNavigationForScreen(nil, EnumScreens.ChatLanding)

			if getFFlagAppChatRequestedRoute() then
				updateExternalNavigationForScreen(nil, EnumScreens.ChatDetails)
			end

			updateExternalNavigationForScreen(nil, EnumScreens.ChatConversation)

			if GetFFlagIsSquadEnabled() then
				updateExternalNavigationForScreen(nil, EnumScreens.SquadLobby)
			end

			v89.current = nil
		end
	end, {
		v89,
		v94,
		v80,
		v95,
		v92,
		v93,
		v73.updateExternalNavigationForScreen,
		v73.wideMode
	})
	local v97 = useCallback(function(p21) -- line: 501
		-- upvalues: GetTopBarStore (copy)
		return GetTopBarStore(false).getScreenTopBar(p21)(false)
	end, {})
	local v98 = useCallback(function(p22, p23) -- line: 506
		-- upvalues: GetTopBarStore (copy)
		GetTopBarStore(false).setScreenTopBar(p22, p23)
	end, {})
	local v99 = useCallback(function(p24) -- line: 510
		-- upvalues: ArgCheck (copy), v82 (copy)
		ArgCheck.isType(p24, "string", "screen")

		return v82[p24] or {}
	end, { v82 })
	local v100 = useCallback(function(p25, p26) -- line: 515
		-- upvalues: ArgCheck (copy), v83 (copy), Cryo (copy)
		ArgCheck.isType(p25, "string", "screen")
		ArgCheck.isType(p26, "table", "state")
		v83(function(p27) -- line: 518
			-- upvalues: Cryo (copy), p25 (copy), p26 (copy)
			local v161 = Cryo.Dictionary.join(p27[p25] or {}, p26)

			return Cryo.Dictionary.join(p27, {
				[p25] = v161
			})
		end)
	end, {})
	local v101 = if not FFlagAppChatTopBarSignalsStore then v99 else v97
	local v102 = if not FFlagAppChatTopBarSignalsStore then v100 else v98
	local v103 = useCallback(function(p28) -- line: 533
		-- upvalues: v88 (copy), v90 (copy)
		if v88.current then
			v88.current:disconnect()
			v88.current = nil
		end

		if p28 then
			v88.current = p28:connect(v90)
		end
	end, {
		v88,
		v90
	})

	useEffect(function() -- line: 545
		-- upvalues: v87 (copy), v103 (copy), v73 (copy), v80 (copy), EnteredChatFromEntryPoint (copy)
		v87.current = true
		v103(v73.rnBypassActionSignal)

		return function() -- line: 549
			-- upvalues: v87 (copy), v103 (copy), v80 (copy), EnteredChatFromEntryPoint (copy)
			v87.current = false
			v103(nil)
			v80(EnteredChatFromEntryPoint())
		end
	end, {})
	useEffect(function() -- line: 558
		-- upvalues: v73 (copy), v74 (copy), v80 (copy), NavigateIntoChat (copy), EnumScreens (copy), v76 (copy)
		if v73.initialConversationId and (v73.initialConversationId ~= "" and v74) then
			v80(NavigateIntoChat({
				screen = EnumScreens.ChatConversation,
				params = {
					userId = v76,
					conversationId = v73.initialConversationId
				}
			}))
			v73.setInitialConversationId("")
		end

		return function() -- line: 567
		end
	end, {
		v80,
		v76,
		v73.initialConversationId,
		v73.setInitialConversationId
	})

	if getFFlagAppChatRequestedRoute() then
		useEffect(function() -- line: 572
			-- upvalues: v73 (copy), v74 (copy), v80 (copy), NavigateIntoChat (copy)
			if v73.requestedRoute and v74 then
				v80(NavigateIntoChat(v73.requestedRoute))

				if v73.clearRequestedRoute then
					v73.clearRequestedRoute()
				end
			end

			return function() -- line: 580
			end
		end, {
			v80,
			v74,
			v73.requestedRoute,
			v73.clearRequestedRoute
		})
	end

	local u104 = nil
	local u105 = nil

	if GetFFlagIsSquadEnabled() then
		u104 = useCurrentSquadParentChannelId()

		if GetFFlagEnableCrossExpVoice() then
			u105 = useIsVoiceConnected()
		end
	end

	useEffect(function() -- line: 599
		-- upvalues: GetFFlagIsSquadEnabled (copy), v74 (copy), v73 (copy), u104 (ref), GetFFlagEnableCrossExpVoice (copy), u105 (ref), v80 (copy), NavigateIntoChat (copy), EnumScreens (copy), v76 (copy)
		if GetFFlagIsSquadEnabled() and (v74 and v73.initialConversationId == "" and u104) then
			if GetFFlagEnableCrossExpVoice() and u105 then
				v80(NavigateIntoChat({
					screen = EnumScreens.SquadLobby,
					params = {
						userId = v76,
						conversationId = u104
					}
				}))

				return
			end

			v80(NavigateIntoChat({
				screen = EnumScreens.ChatConversation,
				params = {
					userId = v76,
					conversationId = u104
				}
			}))
		end
	end, {})
	useEffect(function() -- line: 620
		-- upvalues: v103 (copy), v73 (copy)
		v103(v73.rnBypassActionSignal)
	end, {
		v73.rnBypassActionSignal,
		v103
	})
	useEffect(function() -- line: 624
		-- upvalues: FFlagAppChatTopBarSignalsStore (copy), Cryo (copy), v82 (copy), v83 (copy)
		if not FFlagAppChatTopBarSignalsStore and not Cryo.isEmpty(v82) then
			v83({})
		end
	end, {
		v73.wideMode,
		FFlagAppChatTopBarSignalsStore,
		v82
	})

	local v106 = useAppPolicy(function(p29) -- line: 630
		return p29.getChatHeaderSearch()
	end)
	local v107 = useAppPolicy(function(p30) -- line: 633
		return p30.getChatHeaderCreateChatGroup()
	end)
	local v108 = useAppPolicy(function(p31) -- line: 636
		-- upvalues: getFFlagHideNotificationIconForVR (copy)
		return p31.getChatHeaderNotifications() and (not getFFlagHideNotificationIconForVR() or p31.getWebViewSupport())
	end)
	local v109 = usePageSideMargin(v86.current, FFlagLuaAppCompositionAppChat)
	local v110 = React.useMemo(function() -- line: 642
		-- upvalues: v74 (copy), v109 (copy)
		return {
			default = 12,
			outer = if not v74 then v109 else 12,
			inner = if not v74 then v109 else 12
		}
	end, {
		v109,
		v74
	})
	local v111 = useIsChatEnabled()
	local v112 = if not FFlagAppChatTopBarConfigDriven() then not v74 and (v108 and not FFlagAppChatRemoveNotifications) else nil
	local v113 = if not FFlagAppChatTopBarConfigDriven() then v106 and (not v74 and v111) else nil
	local v114 = if not FFlagAppChatTopBarConfigDriven() then v107 and v111 else nil
	local v115 = if not FFlagAppChatTopBarConfigDriven() then v74 and GetFFlagEnableAppChatInExperience() else nil
	local v116 = useStyle()
	local v117 = useCallback(function(p32) -- line: 668
		-- upvalues: v80 (copy), SetTabBarVisible (copy)
		v80(SetTabBarVisible(p32))
	end, { v80 })
	local v118 = React.createElement(v86, {
		externalDispatchConnector = v96,
		parameters = v73.parameters,
		setActiveConversationId = v73.setActiveConversationId,
		setBackButtonEnabled = v73.setBackButtonEnabled,
		setTabBarVisible = v117,
		chatIsVisible = v81,
		screenProps = {
			navigateToLuaAppPages = v73.navigateToLuaAppPages,
			topBarHeight = math.max(UserInputService.NavBarSize.Y, if not v75 then NAV_BAR_WITH_FACEPILE_SIZE else v75.Size.Size_1400),
			wideMode = v73.wideMode,
			isInExperience = v74,
			isVisible = v73.isVisible,
			notificationCount = v73.notificationCount,
			appChatOuterPadding = v110.outer,
			appChatInnerPadding = v110.inner,
			appChatDefaultPadding = v110.default,
			topBarShowSearch = v113,
			topBarShowCreateChatGroup = v114,
			topBarShowNotifications = v112,
			topBarShowSnoozeNotifications = v115,
			topBarUtilityIconSideMargin = if not FFlagEnableHeaderBarButtonsUpdate then nil else v75.Size.Size_100,
			showSearchRow = v74,
			navigateToRootStack = v73.navigateToRootStack,
			navigateToAddFriends = v73.navigateToAddFriends,
			getScreenTopBar = if not FFlagAppChatTopBarSignalsStore then v101 else nil,
			setScreenTopBar = if not FFlagAppChatTopBarSignalsStore then v102 else nil
		}
	})
	local v119 = React.createElement(LuaAppNavigationContextProvider, {
		navigateToLuaAppPages = v73.navigateToLuaAppPages,
		dispatch = v80
	}, {
		navigation = v118
	})
	local v120 = React.createElement(ChatPlacementContext.Provider, {
		value = {
			chatPlacement = v73.chatPlacement
		}
	}, {
		navigation = v119
	})

	if not FFlagAppChatSignalsReplyStore then
		v120 = React.createElement(ReplyingToMessageProvider, {}, {
			navigation = v120
		})
	end

	local v121 = React.createElement(InteractionFeedback.InteractionFeedbackContext.Provider, {
		value = HapticFeedbackConfig
	}, {
		navigation = v120
	})

	if not v74 then
		v121 = React.createElement(LayerCollectorProvider, {}, {
			navigation = v121
		})
	end

	local v122 = useRobloxLocale()
	local PlaySessionId = RbxAnalyticsService:GetPlaySessionId()
	local v124 = if not GetFFlagIsSquadEnabled() then nil else useSelector(function(p33) -- line: 741
		local v150 = p33.Squad and (p33.Squad.Squad and p33.Squad.Squad.currentSquad)

		if v150 and v150.squadId then
			return v150.squadId
		end

		return nil
	end)
	local v125 = React.createElement(AnalyticsProvider, {
		localUserId = v76,
		entryPoint = v79
	}, {
		telemetry = React.createElement(AppTelemetryLayer.Provider, {
			value = {
				context = "platformChat",
				locale = v122,
				entryPoint = v79 or "unknown",
				userId = v76,
				playSessionId = PlaySessionId,
				currentSquadId = v124,
				placement = v73.chatPlacement
			}
		}, { React.createElement(if not FFlagAppChatTopBarSignalsStore then TopBarContext.Provider else React.Fragment, if not FFlagAppChatTopBarSignalsStore then {
			value = Cryo.Dictionary.join(v82, {
				getScreenTopBar = v101,
				setScreenTopBar = v102
			})
		} else nil, {
			navigation = v121,
			BottomInsetBackground = if not (v77.bottom > 0) then nil else React.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 3,
				BackgroundColor3 = if not getFFlagFixChatsBottomInsetBackgroundColor() then v116.Theme.NavigationBar.Color else v116.Theme.BackgroundDefault.Color,
				BackgroundTransparency = if not getFFlagFixChatsBottomInsetBackgroundColor() then v116.Theme.NavigationBar.Transparency else v116.Theme.BackgroundDefault.Transparency,
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, v77.bottom)
			})
		}) })
	})

	if FFlagAppChatPerfTracking then
		useEffect(function() -- line: 794
			-- upvalues: AppChatPerfTracker (copy), v73 (copy), v79 (copy), v124 (copy)
			AppChatPerfTracker.setSharedContext({
				placement = v73.chatPlacement,
				entryPoint = v79,
				hasActiveParty = v124 ~= nil
			})
		end, {
			v73.chatPlacement,
			v79,
			v124
		})
	end

	return React.createElement(RoactChatAnalyticsProvider, {
		entryPoint = v79
	}, { v125 })
end

return memo(AppChatEntryPoint)
