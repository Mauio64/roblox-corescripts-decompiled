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
local FFlagSupportViewingUserProfileOnOSA = require(AppChat.Flags.FFlagSupportViewingUserProfileOnOSA)
local GetOverlayStore = require(AppChat.Stores.GetOverlayStore)
local navigateWithOsaGate = require(AppChat.Utils.navigateWithOsaGate)
local FFlagAppChatShowOSAOnPageEntry = SharedFlags.FFlagAppChatShowOSAOnPageEntry
local FFlagEnableHeaderBarButtonsUpdate = SharedFlags.FFlagEnableHeaderBarButtonsUpdate
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
	logger = Logger,
	setTabBarVisible = function() -- line: 125
	end,
	setInitialConversationId = function(_) -- line: 126
	end,
	chatPlacement = ChatPlacementContext.Enum.Unknown
}

function AppChatEntryPoint(p2) -- line: 139
	-- upvalues: Cryo (copy), t1 (copy), ChatPlacementContext (copy), useTokens (copy), v13 (copy), rootNavigator (ref), AppChat (copy), rootNavigator2 (ref), useSelector (copy), useCallback (copy), useDispatch (copy), useEffect (copy), AppChatNetworking (copy), Logger2 (copy), useChatIsVisible (copy), useState (copy), React (copy), RoactNavigation (copy), getRoactChatStackNavigator (copy), useRef (copy), FFlagSupportViewingUserProfileOnOSA (copy), GetOverlayStore (copy), EnumScreens (copy), createConversation (copy), fetchLatestConversationDetails (copy), GetFFlagIsSquadEnabled (copy), FFlagAppChatShowOSAOnPageEntry (copy), navigateWithOsaGate (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), GetTopBarStore (copy), ArgCheck (copy), FFlagAppChatTopBarSignalsStore (copy), EnteredChatFromEntryPoint (copy), NavigateIntoChat (copy), useCurrentSquadParentChannelId (copy), GetFFlagEnableCrossExpVoice (copy), useIsVoiceConnected (copy), useAppPolicy (copy), getFFlagHideNotificationIconForVR (copy), usePageSideMargin (copy), useIsChatEnabled (copy), FFlagAppChatTopBarConfigDriven (copy), FFlagAppChatRemoveNotifications (copy), GetFFlagEnableAppChatInExperience (copy), useStyle (copy), SetTabBarVisible (copy), UserInputService (copy), NAV_BAR_WITH_FACEPILE_SIZE (copy), FFlagEnableHeaderBarButtonsUpdate (copy), LuaAppNavigationContextProvider (copy), FFlagAppChatSignalsReplyStore (copy), ReplyingToMessageProvider (copy), InteractionFeedback (copy), HapticFeedbackConfig (copy), LayerCollectorProvider (copy), useRobloxLocale (copy), RbxAnalyticsService (copy), AnalyticsProvider (copy), AppTelemetryLayer (copy), TopBarContext (copy), getFFlagFixChatsBottomInsetBackgroundColor (copy), RoactChatAnalyticsProvider (copy)
	local v70 = Cryo.Dictionary.join(t1, p2)
	local v71 = ChatPlacementContext.isPlacementInExperience(v70.chatPlacement)
	local v72 = useTokens()

	if v13 then
		rootNavigator = require(AppChat.Navigators.Compact.rootNavigator)
		rootNavigator2 = require(AppChat.Navigators.Wide.rootNavigator)
	end

	local v73 = useSelector(useCallback(function(p3) -- line: 150
		return p3.LocalUserId
	end, {})) or v70.localUserId
	local v74 = useSelector(useCallback(function(p4) -- line: 153
		return p4.GlobalGuiInset
	end, {})) or {
		bottom = 0
	}
	local v75 = useSelector(useCallback(function(p5) -- line: 156
		return p5.ChatAppReducer.LastEntryPoint
	end, {}))
	local v76 = useDispatch()

	useEffect(function() -- line: 162
		-- upvalues: v76 (copy), AppChatNetworking (copy), v71 (copy), Logger2 (copy)
		v76(AppChatNetworking.rodux.GetChatLandingModal.API(v71)):catch(function(p6) -- line: 163
			-- upvalues: Logger2 (copy)
			Logger2:warning("Error in GetChatLandingModal request. Error: {}", (tostring(p6)))
		end)
	end, {
		v76,
		v73,
		v71
	})

	local v77 = useChatIsVisible()
	local v78, v79 = useState({})
	local v80 = React.useMemo(function() -- line: 172
		-- upvalues: RoactNavigation (copy), getRoactChatStackNavigator (copy), v70 (copy), rootNavigator2 (ref), rootNavigator (ref)
		return RoactNavigation.createAppContainer(getRoactChatStackNavigator(v70.wideMode and rootNavigator2 or rootNavigator, v70.navigateToRootStack, v70.androidBackButtonSignal, v70.androidBackButtonConnection))
	end, {
		v70.wideMode,
		rootNavigator2,
		rootNavigator,
		v70.navigateToRootStack,
		v70.androidBackButtonSignal,
		v70.androidBackButtonConnection
	})
	local v81 = if not v71 then useRef(RoactNavigation.createAppContainer(getRoactChatStackNavigator(v70.wideMode and rootNavigator2 or rootNavigator, v70.navigateToRootStack, v70.androidBackButtonSignal, v70.androidBackButtonConnection))) else v80

	if not v71 then
		v81 = v81.current
	end

	local v82 = useRef(false)
	local v83 = useRef(nil)
	local v84 = useRef(function(...) -- line: 209
	end)

	useEffect(function() -- line: 211
		-- upvalues: v70 (copy), Logger2 (copy)
		if v70.logger then
			Logger2:setParent(v70.logger)
		end
	end, { v70.logger })

	local v85 = useCallback(function(p7) -- line: 217
		-- upvalues: v82 (copy), v84 (copy)
		if not v82.current then
			return
		end

		if v84.current then
			v84.current(p7)
		end
	end, {
		v82,
		v84
	})

	if FFlagSupportViewingUserProfileOnOSA then
		local navigateToLuaAppPages = v70.navigateToLuaAppPages

		useEffect(function() -- line: 229
			-- upvalues: GetOverlayStore (copy), navigateToLuaAppPages (copy), EnumScreens (copy)
			GetOverlayStore(false).setOverlayDefaultProps({
				onViewUserProfile = if not navigateToLuaAppPages then nil else navigateToLuaAppPages[EnumScreens.ViewUserProfile]
			})
		end, { navigateToLuaAppPages })
	end

	local v87 = useCallback(function(p8) -- line: 239
		-- upvalues: RoactNavigation (copy), EnumScreens (copy)
		return RoactNavigation.Actions.navigate({
			routeName = EnumScreens.ChatConversation,
			params = {
				conversationId = p8
			}
		})
	end, {})
	local v88 = useCallback(function(p9, p10) -- line: 247
		-- upvalues: RoactNavigation (copy), EnumScreens (copy), v70 (copy)
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

		if v70.wideMode then
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
	end, { v70.wideMode })
	local v89 = useCallback(function(p11) -- line: 296
		-- upvalues: v76 (copy), createConversation (copy)
		return v76(createConversation("one_to_one", { p11 }))
	end, { v76 })
	local v90 = useCallback(function(s1: string) -- line: 300
		-- upvalues: v76 (copy), fetchLatestConversationDetails (copy)
		return v76(fetchLatestConversationDetails(s1))
	end, { v76 })
	local v91 = useCallback(function(p12: ((...any) -> ...any)) -- line: 304
		-- upvalues: v84 (copy), v70 (copy), GetFFlagIsSquadEnabled (copy), Cryo (copy), FFlagAppChatShowOSAOnPageEntry (copy), navigateWithOsaGate (copy), v76 (copy), v88 (copy), EnumScreens (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), v90 (copy), Logger2 (copy), v87 (copy), v89 (copy), RoactNavigation (copy)
		v84.current = p12

		if not v70.updateExternalNavigationForScreen then
			return function() -- line: 307
				-- upvalues: v84 (copy)
				v84.current = nil
			end
		end

		local updateExternalNavigationForScreen = v70.updateExternalNavigationForScreen

		if GetFFlagIsSquadEnabled() then
			updateExternalNavigationForScreen(function(p13) -- line: 314
				-- upvalues: Cryo (copy), FFlagAppChatShowOSAOnPageEntry (copy), navigateWithOsaGate (copy), v76 (copy), p12 (copy), v88 (copy)
				local conversationId = p13.conversationId
				local v149 = Cryo.Dictionary.omit(p13, "conversationId")

				if FFlagAppChatShowOSAOnPageEntry then
					navigateWithOsaGate({
						requireMultiUserForU13 = true,
						conversationId = conversationId,
						dispatch = v76,
						onAccepted = function() -- line: 321
							-- upvalues: p12 (copy), v88 (copy), conversationId (copy), v149 (copy)
							p12(v88(conversationId, v149))
						end
					})

					return
				end

				p12(v88(conversationId, v149))
			end, EnumScreens.SquadLobby)
		end

		updateExternalNavigationForScreen(function(p14) -- line: 332
			-- upvalues: FFlagAppChatShowOSAOnPageEntry (copy), navigateWithOsaGate (copy), v76 (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), v90 (copy), Logger2 (copy), p12 (copy), v87 (copy), v89 (copy)
			local v151 = p14 and p14.conversationId

			if v151 then
				if not FFlagAppChatShowOSAOnPageEntry then
					if FFlagAppChatPerfTracking then
						AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatConversationTTI, {
							conversationId = v151
						})
					end

					v90(v151):andThen(function() -- line: 374
						-- upvalues: Logger2 (copy), v151 (copy), p12 (copy), v87 (copy)
						Logger2:info("Successfully fetched conversation details for conversationId {} for external navigation", v151)
						p12(v87(v151))
					end):catch(function(p15) -- line: 381
						-- upvalues: Logger2 (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), v151 (copy)
						Logger2:warning("Error in fetchLatestConversationDetails request before navigate to conversation. error: {}", (tostring(p15)))

						if FFlagAppChatPerfTracking then
							AppChatPerfTracker.cancel(AppChatPerfTracker.Events.ChatConversationTTI, {
								conversationId = v151
							})
						end
					end)

					return
				end

				navigateWithOsaGate({
					conversationId = v151,
					dispatch = v76,
					onAccepted = function() -- line: 340
						-- upvalues: FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), v151 (copy), v90 (copy), Logger2 (copy), p12 (copy), v87 (copy)
						if FFlagAppChatPerfTracking then
							AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatConversationTTI, {
								conversationId = v151
							})
						end

						v90(v151):andThen(function() -- line: 347
							-- upvalues: Logger2 (copy), v151 (copy), p12 (copy), v87 (copy)
							Logger2:info("Successfully fetched conversation details for conversationId {} for external navigation", v151)
							p12(v87(v151))
						end):catch(function(p16) -- line: 354
							-- upvalues: Logger2 (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), v151 (copy)
							Logger2:warning("Error in fetchLatestConversationDetails request before navigate to conversation. error: {}", (tostring(p16)))

							if FFlagAppChatPerfTracking then
								AppChatPerfTracker.cancel(AppChatPerfTracker.Events.ChatConversationTTI, {
									conversationId = v151
								})
							end
						end)
					end
				})
			end

			local v152 = p14 and p14.userId

			if not v152 then
				return
			end

			spawn(function() -- line: 402
				-- upvalues: v89 (copy), v152 (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), Logger2 (copy), FFlagAppChatShowOSAOnPageEntry (copy), navigateWithOsaGate (copy), v76 (copy), p12 (copy), v87 (copy)
				v89(v152):andThen(function(p17) -- line: 404
					-- upvalues: FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), Logger2 (copy), v152 (copy), FFlagAppChatShowOSAOnPageEntry (copy), navigateWithOsaGate (copy), v76 (copy), p12 (copy), v87 (copy)
					if FFlagAppChatPerfTracking then
						AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatConversationTTI, {
							conversationId = p17.id
						})
					end

					Logger2:info("Successfully fetched conversation details for userId {} for external navigation", v152)

					if FFlagAppChatShowOSAOnPageEntry then
						navigateWithOsaGate({
							conversationId = p17.id,
							dispatch = v76,
							onAccepted = function() -- line: 418
								-- upvalues: p12 (copy), v87 (copy), p17 (copy)
								p12(v87(p17.id))
							end
						})

						return
					end

					p12(v87(p17.id))
				end):catch(function(p18) -- line: 426
					-- upvalues: Logger2 (copy)
					Logger2:warning("Error in CreateConversation request before navigate to conversation. error: {}", (tostring(p18)))
				end)
			end)
		end, EnumScreens.ChatConversation)
		updateExternalNavigationForScreen(function(p19) -- line: 436
			-- upvalues: p12 (copy), RoactNavigation (copy), EnumScreens (copy), v70 (copy)
			p12(RoactNavigation.Actions.navigate({
				routeName = EnumScreens.ChatLanding,
				params = p19
			}))

			if v70.wideMode then
				p12(RoactNavigation.Actions.navigate({
					routeName = EnumScreens.EmptyConversation
				}))
			end
		end, EnumScreens.ChatLanding)

		return function() -- line: 448
			-- upvalues: updateExternalNavigationForScreen (copy), EnumScreens (copy), GetFFlagIsSquadEnabled (copy), v84 (copy)
			updateExternalNavigationForScreen(nil, EnumScreens.ChatLanding)
			updateExternalNavigationForScreen(nil, EnumScreens.ChatConversation)

			if GetFFlagIsSquadEnabled() then
				updateExternalNavigationForScreen(nil, EnumScreens.SquadLobby)
			end

			v84.current = nil
		end
	end, { v84 })
	local v92 = useCallback(function(p20) -- line: 459
		-- upvalues: GetTopBarStore (copy)
		return GetTopBarStore(false).getScreenTopBar(p20)(false)
	end, {})
	local v93 = useCallback(function(p21, p22) -- line: 464
		-- upvalues: GetTopBarStore (copy)
		GetTopBarStore(false).setScreenTopBar(p21, p22)
	end, {})
	local v94 = useCallback(function(p23) -- line: 468
		-- upvalues: ArgCheck (copy), v78 (copy)
		ArgCheck.isType(p23, "string", "screen")

		return v78[p23] or {}
	end, { v78 })
	local v95 = useCallback(function(p24, p25) -- line: 473
		-- upvalues: ArgCheck (copy), v79 (copy), Cryo (copy)
		ArgCheck.isType(p24, "string", "screen")
		ArgCheck.isType(p25, "table", "state")
		v79(function(p26) -- line: 476
			-- upvalues: Cryo (copy), p24 (copy), p25 (copy)
			local v155 = Cryo.Dictionary.join(p26[p24] or {}, p25)

			return Cryo.Dictionary.join(p26, {
				[p24] = v155
			})
		end)
	end, {})
	local v96 = if not FFlagAppChatTopBarSignalsStore then v94 else v92
	local v97 = if not FFlagAppChatTopBarSignalsStore then v95 else v93
	local v98 = useCallback(function(p27) -- line: 491
		-- upvalues: v83 (copy), v85 (copy)
		if v83.current then
			v83.current:disconnect()
			v83.current = nil
		end

		if p27 then
			v83.current = p27:connect(v85)
		end
	end, { v83 })

	useEffect(function() -- line: 502
		-- upvalues: v82 (copy), v98 (copy), v70 (copy), v76 (copy), EnteredChatFromEntryPoint (copy)
		v82.current = true
		v98(v70.rnBypassActionSignal)

		return function() -- line: 506
			-- upvalues: v82 (copy), v98 (copy), v76 (copy), EnteredChatFromEntryPoint (copy)
			v82.current = false
			v98(nil)
			v76(EnteredChatFromEntryPoint())
		end
	end, {})
	useEffect(function() -- line: 514
		-- upvalues: v70 (copy), v71 (copy), v76 (copy), NavigateIntoChat (copy), EnumScreens (copy), v73 (copy)
		if v70.initialConversationId and (v70.initialConversationId ~= "" and v71) then
			v76(NavigateIntoChat({
				screen = EnumScreens.ChatConversation,
				params = {
					userId = v73,
					conversationId = v70.initialConversationId
				}
			}))
			v70.setInitialConversationId("")
		end

		return function() -- line: 523
		end
	end, {
		v76,
		v73,
		v70.initialConversationId,
		v70.setInitialConversationId
	})

	local u99 = nil
	local u100 = nil

	if GetFFlagIsSquadEnabled() then
		u99 = useCurrentSquadParentChannelId()

		if GetFFlagEnableCrossExpVoice() then
			u100 = useIsVoiceConnected()
		end
	end

	useEffect(function() -- line: 535
		-- upvalues: GetFFlagIsSquadEnabled (copy), v71 (copy), v70 (copy), u99 (ref), GetFFlagEnableCrossExpVoice (copy), u100 (ref), v76 (copy), NavigateIntoChat (copy), EnumScreens (copy), v73 (copy)
		if GetFFlagIsSquadEnabled() and (v71 and v70.initialConversationId == "" and u99) then
			if GetFFlagEnableCrossExpVoice() and u100 then
				v76(NavigateIntoChat({
					screen = EnumScreens.SquadLobby,
					params = {
						userId = v73,
						conversationId = u99
					}
				}))

				return
			end

			v76(NavigateIntoChat({
				screen = EnumScreens.ChatConversation,
				params = {
					userId = v73,
					conversationId = u99
				}
			}))
		end
	end, {})
	useEffect(function() -- line: 556
		-- upvalues: v98 (copy), v70 (copy)
		v98(v70.rnBypassActionSignal)
	end, { v70.rnBypassActionSignal })
	useEffect(function() -- line: 560
		-- upvalues: FFlagAppChatTopBarSignalsStore (copy), Cryo (copy), v78 (copy), v79 (copy)
		if not FFlagAppChatTopBarSignalsStore and not Cryo.isEmpty(v78) then
			v79({})
		end
	end, {
		v70.wideMode,
		FFlagAppChatTopBarSignalsStore
	})

	local v101 = useAppPolicy(function(p28) -- line: 566
		return p28.getChatHeaderSearch()
	end)
	local v102 = useAppPolicy(function(p29) -- line: 569
		return p29.getChatHeaderCreateChatGroup()
	end)
	local v103 = useAppPolicy(function(p30) -- line: 572
		-- upvalues: getFFlagHideNotificationIconForVR (copy)
		return p30.getChatHeaderNotifications() and (not getFFlagHideNotificationIconForVR() or p30.getWebViewSupport())
	end)
	local v104 = usePageSideMargin(v81.current)
	local v105 = React.useMemo(function() -- line: 578
		-- upvalues: v71 (copy), v104 (copy)
		return {
			default = 12,
			outer = if not v71 then v104 else 12,
			inner = if not v71 then v104 else 12
		}
	end, {
		v104,
		v71
	})
	local v106 = useIsChatEnabled()
	local v107 = if not FFlagAppChatTopBarConfigDriven() then not v71 and (v103 and not FFlagAppChatRemoveNotifications) else nil
	local v108 = if not FFlagAppChatTopBarConfigDriven() then v101 and (not v71 and v106) else nil
	local v109 = if not FFlagAppChatTopBarConfigDriven() then v102 and v106 else nil
	local v110 = if not FFlagAppChatTopBarConfigDriven() then v71 and GetFFlagEnableAppChatInExperience() else nil
	local v111 = useStyle()
	local v112 = useCallback(function(p31) -- line: 604
		-- upvalues: v76 (copy), SetTabBarVisible (copy)
		v76(SetTabBarVisible(p31))
	end, { v76 })
	local v113 = React.createElement(v81, {
		externalDispatchConnector = v91,
		parameters = v70.parameters,
		setActiveConversationId = v70.setActiveConversationId,
		setBackButtonEnabled = v70.setBackButtonEnabled,
		setTabBarVisible = v112,
		chatIsVisible = v77,
		screenProps = {
			navigateToLuaAppPages = v70.navigateToLuaAppPages,
			topBarHeight = math.max(UserInputService.NavBarSize.Y, if not v72 then NAV_BAR_WITH_FACEPILE_SIZE else v72.Size.Size_1400),
			wideMode = v70.wideMode,
			isInExperience = v71,
			isVisible = v70.isVisible,
			notificationCount = v70.notificationCount,
			appChatOuterPadding = v105.outer,
			appChatInnerPadding = v105.inner,
			appChatDefaultPadding = v105.default,
			topBarShowSearch = v108,
			topBarShowCreateChatGroup = v109,
			topBarShowNotifications = v107,
			topBarShowSnoozeNotifications = v110,
			topBarUtilityIconSideMargin = if not FFlagEnableHeaderBarButtonsUpdate then nil else v72.Size.Size_100,
			showSearchRow = v71,
			navigateToRootStack = v70.navigateToRootStack,
			navigateToAddFriends = v70.navigateToAddFriends,
			getScreenTopBar = if not FFlagAppChatTopBarSignalsStore then v96 else nil,
			setScreenTopBar = if not FFlagAppChatTopBarSignalsStore then v97 else nil
		}
	})
	local v114 = React.createElement(LuaAppNavigationContextProvider, {
		navigateToLuaAppPages = v70.navigateToLuaAppPages,
		dispatch = v76
	}, {
		navigation = v113
	})
	local v115 = React.createElement(ChatPlacementContext.Provider, {
		value = {
			chatPlacement = v70.chatPlacement
		}
	}, {
		navigation = v114
	})

	if not FFlagAppChatSignalsReplyStore then
		v115 = React.createElement(ReplyingToMessageProvider, {}, {
			navigation = v115
		})
	end

	local v116 = React.createElement(InteractionFeedback.InteractionFeedbackContext.Provider, {
		value = HapticFeedbackConfig
	}, {
		navigation = v115
	})

	if not v71 then
		v116 = React.createElement(LayerCollectorProvider, {}, {
			navigation = v116
		})
	end

	local v117 = useRobloxLocale()
	local PlaySessionId = RbxAnalyticsService:GetPlaySessionId()
	local v119 = if not GetFFlagIsSquadEnabled() then nil else useSelector(function(p32) -- line: 677
		local v145 = p32.Squad and (p32.Squad.Squad and p32.Squad.Squad.currentSquad)

		if v145 and v145.squadId then
			return v145.squadId
		end

		return nil
	end)
	local v120 = React.createElement(AnalyticsProvider, {
		localUserId = v73,
		entryPoint = v75
	}, {
		telemetry = React.createElement(AppTelemetryLayer.Provider, {
			value = {
				context = "platformChat",
				locale = v117,
				entryPoint = v75 or "unknown",
				userId = v73,
				playSessionId = PlaySessionId,
				currentSquadId = v119,
				placement = v70.chatPlacement
			}
		}, { React.createElement(if not FFlagAppChatTopBarSignalsStore then TopBarContext.Provider else React.Fragment, if not FFlagAppChatTopBarSignalsStore then {
			value = Cryo.Dictionary.join(v78, {
				getScreenTopBar = v96,
				setScreenTopBar = v97
			})
		} else nil, {
			navigation = v116,
			BottomInsetBackground = if not (v74.bottom > 0) then nil else React.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 3,
				BackgroundColor3 = if not getFFlagFixChatsBottomInsetBackgroundColor() then v111.Theme.NavigationBar.Color else v111.Theme.BackgroundDefault.Color,
				BackgroundTransparency = if not getFFlagFixChatsBottomInsetBackgroundColor() then v111.Theme.NavigationBar.Transparency else v111.Theme.BackgroundDefault.Transparency,
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, v74.bottom)
			})
		}) })
	})

	if FFlagAppChatPerfTracking then
		useEffect(function() -- line: 730
			-- upvalues: AppChatPerfTracker (copy), v70 (copy), v75 (copy), v119 (copy)
			AppChatPerfTracker.setSharedContext({
				placement = v70.chatPlacement,
				entryPoint = v75,
				hasActiveParty = v119 ~= nil
			})
		end, {
			v70.chatPlacement,
			v75,
			v119
		})
	end

	return React.createElement(RoactChatAnalyticsProvider, {
		entryPoint = v75
	}, { v120 })
end

return memo(AppChatEntryPoint)
