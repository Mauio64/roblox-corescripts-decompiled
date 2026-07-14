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
	setTabBarVisible = function() -- line: 129
	end,
	setInitialConversationId = function(_) -- line: 130
	end,
	chatPlacement = ChatPlacementContext.Enum.Unknown
}

function AppChatEntryPoint(p2) -- line: 144
	-- upvalues: Cryo (copy), t1 (copy), ChatPlacementContext (copy), useTokens (copy), v13 (copy), rootNavigator (ref), AppChat (copy), rootNavigator2 (ref), useSelector (copy), useCallback (copy), useDispatch (copy), useEffect (copy), AppChatNetworking (copy), Logger2 (copy), useChatIsVisible (copy), useState (copy), React (copy), RoactNavigation (copy), getRoactChatStackNavigator (copy), useRef (copy), FFlagSupportViewingUserProfileOnOSA (copy), GetOverlayStore (copy), EnumScreens (copy), createConversation (copy), fetchLatestConversationDetails (copy), GetFFlagIsSquadEnabled (copy), FFlagAppChatShowOSAOnPageEntry (copy), navigateWithOsaGate (copy), getFFlagAppChatRequestedRoute (copy), rootedChatDetailsNavigation (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), GetTopBarStore (copy), ArgCheck (copy), FFlagAppChatTopBarSignalsStore (copy), EnteredChatFromEntryPoint (copy), NavigateIntoChat (copy), useCurrentSquadParentChannelId (copy), GetFFlagEnableCrossExpVoice (copy), useIsVoiceConnected (copy), useAppPolicy (copy), getFFlagHideNotificationIconForVR (copy), usePageSideMargin (copy), useIsChatEnabled (copy), FFlagAppChatTopBarConfigDriven (copy), FFlagAppChatRemoveNotifications (copy), GetFFlagEnableAppChatInExperience (copy), useStyle (copy), SetTabBarVisible (copy), UserInputService (copy), NAV_BAR_WITH_FACEPILE_SIZE (copy), FFlagEnableHeaderBarButtonsUpdate (copy), LuaAppNavigationContextProvider (copy), FFlagAppChatSignalsReplyStore (copy), ReplyingToMessageProvider (copy), InteractionFeedback (copy), HapticFeedbackConfig (copy), LayerCollectorProvider (copy), useRobloxLocale (copy), RbxAnalyticsService (copy), AnalyticsProvider (copy), AppTelemetryLayer (copy), TopBarContext (copy), getFFlagFixChatsBottomInsetBackgroundColor (copy), RoactChatAnalyticsProvider (copy)
	local v72 = Cryo.Dictionary.join(t1, p2)
	local v73 = ChatPlacementContext.isPlacementInExperience(v72.chatPlacement)
	local v74 = useTokens()

	if v13 then
		rootNavigator = require(AppChat.Navigators.Compact.rootNavigator)
		rootNavigator2 = require(AppChat.Navigators.Wide.rootNavigator)
	end

	local v75 = useSelector(useCallback(function(p3) -- line: 155
		return p3.LocalUserId
	end, {})) or v72.localUserId
	local v76 = useSelector(useCallback(function(p4) -- line: 158
		return p4.GlobalGuiInset
	end, {})) or {
		bottom = 0
	}
	local v77 = useCallback(function(p5) -- line: 161
		return p5.ChatAppReducer.LastEntryPoint
	end, {})
	local v78 = useSelector(v77)
	local v79 = useDispatch()

	useEffect(function() -- line: 168
		-- upvalues: v79 (copy), AppChatNetworking (copy), v73 (copy), Logger2 (copy)
		v79(AppChatNetworking.rodux.GetChatLandingModal.API(v73)):catch(function(p6) -- line: 169
			-- upvalues: Logger2 (copy)
			Logger2:warning("Error in GetChatLandingModal request. Error: {}", (tostring(p6)))
		end)
	end, {
		v79,
		v75,
		v73
	})

	local v80 = useChatIsVisible()
	local v81, v82 = useState({})
	local v83 = React.useMemo(function() -- line: 178
		-- upvalues: RoactNavigation (copy), getRoactChatStackNavigator (copy), v72 (copy), rootNavigator2 (ref), rootNavigator (ref)
		return RoactNavigation.createAppContainer(getRoactChatStackNavigator(v72.wideMode and rootNavigator2 or rootNavigator, v72.navigateToRootStack, v72.androidBackButtonSignal, v72.androidBackButtonConnection))
	end, {
		v72.wideMode,
		rootNavigator2,
		rootNavigator,
		v72.navigateToRootStack,
		v72.androidBackButtonSignal,
		v72.androidBackButtonConnection
	})
	local v84 = useRef(nil)

	if not v73 and v84.current == nil then
		v84.current = RoactNavigation.createAppContainer(getRoactChatStackNavigator(v72.wideMode and rootNavigator2 or rootNavigator, v72.navigateToRootStack, v72.androidBackButtonSignal, v72.androidBackButtonConnection))
	end

	local v85 = if not v73 then v84.current else v83
	local v86 = useRef(false)
	local v87 = useRef(nil)
	local v88 = useRef(function(...) -- line: 211
	end)

	useEffect(function() -- line: 213
		-- upvalues: v72 (copy), Logger2 (copy)
		if v72.logger then
			Logger2:setParent(v72.logger)
		end
	end, { v72.logger })

	local v89 = useCallback(function(p7) -- line: 219
		-- upvalues: v86 (copy), v88 (copy)
		if not v86.current then
			return
		end

		if v88.current then
			v88.current(p7)
		end
	end, {
		v86,
		v88
	})

	if FFlagSupportViewingUserProfileOnOSA then
		local navigateToLuaAppPages = v72.navigateToLuaAppPages

		useEffect(function() -- line: 231
			-- upvalues: GetOverlayStore (copy), navigateToLuaAppPages (copy), EnumScreens (copy)
			GetOverlayStore(false).setOverlayDefaultProps({
				onViewUserProfile = if not navigateToLuaAppPages then nil else navigateToLuaAppPages[EnumScreens.ViewUserProfile]
			})
		end, { navigateToLuaAppPages })
	end

	local v91 = useCallback(function(p8) -- line: 241
		-- upvalues: RoactNavigation (copy), EnumScreens (copy)
		return RoactNavigation.Actions.navigate({
			routeName = EnumScreens.ChatConversation,
			params = {
				conversationId = p8
			}
		})
	end, {})
	local v92 = useCallback(function(p9, p10) -- line: 249
		-- upvalues: RoactNavigation (copy), EnumScreens (copy), v72 (copy)
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

		if v72.wideMode then
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
	end, { v72.wideMode })
	local v93 = useCallback(function(p11) -- line: 298
		-- upvalues: v79 (copy), createConversation (copy)
		return v79(createConversation("one_to_one", { p11 }))
	end, { v79 })
	local v94 = useCallback(function(s1: string) -- line: 302
		-- upvalues: v79 (copy), fetchLatestConversationDetails (copy)
		return v79(fetchLatestConversationDetails(s1))
	end, { v79 })
	local v95 = useCallback(function(p12: ((...any) -> ...any)) -- line: 307
		-- upvalues: v88 (copy), v72 (copy), GetFFlagIsSquadEnabled (copy), Cryo (copy), FFlagAppChatShowOSAOnPageEntry (copy), navigateWithOsaGate (copy), v79 (copy), v92 (copy), EnumScreens (copy), getFFlagAppChatRequestedRoute (copy), rootedChatDetailsNavigation (copy), v94 (copy), RoactNavigation (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), Logger2 (copy), v91 (copy), v93 (copy)
		v88.current = p12

		if not v72.updateExternalNavigationForScreen then
			return function() -- line: 310
				-- upvalues: v88 (copy)
				v88.current = nil
			end
		end

		local updateExternalNavigationForScreen = v72.updateExternalNavigationForScreen

		if GetFFlagIsSquadEnabled() then
			updateExternalNavigationForScreen(function(p13) -- line: 317
				-- upvalues: Cryo (copy), FFlagAppChatShowOSAOnPageEntry (copy), navigateWithOsaGate (copy), v79 (copy), p12 (copy), v92 (copy)
				local conversationId = p13.conversationId
				local v153 = Cryo.Dictionary.omit(p13, "conversationId")

				if FFlagAppChatShowOSAOnPageEntry then
					navigateWithOsaGate({
						requireMultiUserForU13 = true,
						conversationId = conversationId,
						dispatch = v79,
						onAccepted = function() -- line: 324
							-- upvalues: p12 (copy), v92 (copy), conversationId (copy), v153 (copy)
							p12(v92(conversationId, v153))
						end
					})

					return
				end

				p12(v92(conversationId, v153))
			end, EnumScreens.SquadLobby)
		end

		if getFFlagAppChatRequestedRoute() then
			updateExternalNavigationForScreen(function(p14) -- line: 336
				-- upvalues: rootedChatDetailsNavigation (copy), p12 (copy), v79 (copy), v94 (copy), RoactNavigation (copy), EnumScreens (copy)
				if not p14 or not p14.conversationId then
					return
				end

				if rootedChatDetailsNavigation.tryNavigateToRootedChatDetails({
					callback = p12,
					dispatch = v79,
					fetchLatestConversationDetails = v94
				}, p14) then
					return
				end

				p12(RoactNavigation.Actions.navigate({
					routeName = EnumScreens.ChatDetails,
					params = p14
				}))
			end, EnumScreens.ChatDetails)
		end

		updateExternalNavigationForScreen(function(p15) -- line: 359
			-- upvalues: FFlagAppChatShowOSAOnPageEntry (copy), navigateWithOsaGate (copy), v79 (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), v94 (copy), Logger2 (copy), p12 (copy), v91 (copy), v93 (copy)
			local v156 = p15 and p15.conversationId

			if v156 then
				if not FFlagAppChatShowOSAOnPageEntry then
					if FFlagAppChatPerfTracking then
						AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatConversationTTI, {
							conversationId = v156
						})
					end

					v94(v156):andThen(function() -- line: 401
						-- upvalues: Logger2 (copy), v156 (copy), p12 (copy), v91 (copy)
						Logger2:info("Successfully fetched conversation details for conversationId {} for external navigation", v156)
						p12(v91(v156))
					end):catch(function(p16) -- line: 408
						-- upvalues: Logger2 (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), v156 (copy)
						Logger2:warning("Error in fetchLatestConversationDetails request before navigate to conversation. error: {}", (tostring(p16)))

						if FFlagAppChatPerfTracking then
							AppChatPerfTracker.cancel(AppChatPerfTracker.Events.ChatConversationTTI, {
								conversationId = v156
							})
						end
					end)

					return
				end

				navigateWithOsaGate({
					conversationId = v156,
					dispatch = v79,
					onAccepted = function() -- line: 367
						-- upvalues: FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), v156 (copy), v94 (copy), Logger2 (copy), p12 (copy), v91 (copy)
						if FFlagAppChatPerfTracking then
							AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatConversationTTI, {
								conversationId = v156
							})
						end

						v94(v156):andThen(function() -- line: 374
							-- upvalues: Logger2 (copy), v156 (copy), p12 (copy), v91 (copy)
							Logger2:info("Successfully fetched conversation details for conversationId {} for external navigation", v156)
							p12(v91(v156))
						end):catch(function(p17) -- line: 381
							-- upvalues: Logger2 (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), v156 (copy)
							Logger2:warning("Error in fetchLatestConversationDetails request before navigate to conversation. error: {}", (tostring(p17)))

							if FFlagAppChatPerfTracking then
								AppChatPerfTracker.cancel(AppChatPerfTracker.Events.ChatConversationTTI, {
									conversationId = v156
								})
							end
						end)
					end
				})
			end

			local v157 = p15 and p15.userId

			if not v157 then
				return
			end

			spawn(function() -- line: 429
				-- upvalues: v93 (copy), v157 (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), Logger2 (copy), FFlagAppChatShowOSAOnPageEntry (copy), navigateWithOsaGate (copy), v79 (copy), p12 (copy), v91 (copy)
				v93(v157):andThen(function(p18) -- line: 431
					-- upvalues: FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), Logger2 (copy), v157 (copy), FFlagAppChatShowOSAOnPageEntry (copy), navigateWithOsaGate (copy), v79 (copy), p12 (copy), v91 (copy)
					if FFlagAppChatPerfTracking then
						AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatConversationTTI, {
							conversationId = p18.id
						})
					end

					Logger2:info("Successfully fetched conversation details for userId {} for external navigation", v157)

					if FFlagAppChatShowOSAOnPageEntry then
						navigateWithOsaGate({
							conversationId = p18.id,
							dispatch = v79,
							onAccepted = function() -- line: 445
								-- upvalues: p12 (copy), v91 (copy), p18 (copy)
								p12(v91(p18.id))
							end
						})

						return
					end

					p12(v91(p18.id))
				end):catch(function(p19) -- line: 453
					-- upvalues: Logger2 (copy)
					Logger2:warning("Error in CreateConversation request before navigate to conversation. error: {}", (tostring(p19)))
				end)
			end)
		end, EnumScreens.ChatConversation)
		updateExternalNavigationForScreen(function(p20) -- line: 463
			-- upvalues: p12 (copy), RoactNavigation (copy), EnumScreens (copy), v72 (copy)
			p12(RoactNavigation.Actions.navigate({
				routeName = EnumScreens.ChatLanding,
				params = p20
			}))

			if v72.wideMode then
				p12(RoactNavigation.Actions.navigate({
					routeName = EnumScreens.EmptyConversation
				}))
			end
		end, EnumScreens.ChatLanding)

		return function() -- line: 475
			-- upvalues: updateExternalNavigationForScreen (copy), EnumScreens (copy), getFFlagAppChatRequestedRoute (copy), GetFFlagIsSquadEnabled (copy), v88 (copy)
			updateExternalNavigationForScreen(nil, EnumScreens.ChatLanding)

			if getFFlagAppChatRequestedRoute() then
				updateExternalNavigationForScreen(nil, EnumScreens.ChatDetails)
			end

			updateExternalNavigationForScreen(nil, EnumScreens.ChatConversation)

			if GetFFlagIsSquadEnabled() then
				updateExternalNavigationForScreen(nil, EnumScreens.SquadLobby)
			end

			v88.current = nil
		end
	end, {
		v88,
		v93,
		v79,
		v94,
		v91,
		v92,
		v72.updateExternalNavigationForScreen,
		v72.wideMode
	})
	local v96 = useCallback(function(p21) -- line: 500
		-- upvalues: GetTopBarStore (copy)
		return GetTopBarStore(false).getScreenTopBar(p21)(false)
	end, {})
	local v97 = useCallback(function(p22, p23) -- line: 505
		-- upvalues: GetTopBarStore (copy)
		GetTopBarStore(false).setScreenTopBar(p22, p23)
	end, {})
	local v98 = useCallback(function(p24) -- line: 509
		-- upvalues: ArgCheck (copy), v81 (copy)
		ArgCheck.isType(p24, "string", "screen")

		return v81[p24] or {}
	end, { v81 })
	local v99 = useCallback(function(p25, p26) -- line: 514
		-- upvalues: ArgCheck (copy), v82 (copy), Cryo (copy)
		ArgCheck.isType(p25, "string", "screen")
		ArgCheck.isType(p26, "table", "state")
		v82(function(p27) -- line: 517
			-- upvalues: Cryo (copy), p25 (copy), p26 (copy)
			local v160 = Cryo.Dictionary.join(p27[p25] or {}, p26)

			return Cryo.Dictionary.join(p27, {
				[p25] = v160
			})
		end)
	end, {})
	local v100 = if not FFlagAppChatTopBarSignalsStore then v98 else v96
	local v101 = if not FFlagAppChatTopBarSignalsStore then v99 else v97
	local v102 = useCallback(function(p28) -- line: 532
		-- upvalues: v87 (copy), v89 (copy)
		if v87.current then
			v87.current:disconnect()
			v87.current = nil
		end

		if p28 then
			v87.current = p28:connect(v89)
		end
	end, {
		v87,
		v89
	})

	useEffect(function() -- line: 544
		-- upvalues: v86 (copy), v102 (copy), v72 (copy), v79 (copy), EnteredChatFromEntryPoint (copy)
		v86.current = true
		v102(v72.rnBypassActionSignal)

		return function() -- line: 548
			-- upvalues: v86 (copy), v102 (copy), v79 (copy), EnteredChatFromEntryPoint (copy)
			v86.current = false
			v102(nil)
			v79(EnteredChatFromEntryPoint())
		end
	end, {})
	useEffect(function() -- line: 557
		-- upvalues: v72 (copy), v73 (copy), v79 (copy), NavigateIntoChat (copy), EnumScreens (copy), v75 (copy)
		if v72.initialConversationId and (v72.initialConversationId ~= "" and v73) then
			v79(NavigateIntoChat({
				screen = EnumScreens.ChatConversation,
				params = {
					userId = v75,
					conversationId = v72.initialConversationId
				}
			}))
			v72.setInitialConversationId("")
		end

		return function() -- line: 566
		end
	end, {
		v79,
		v75,
		v72.initialConversationId,
		v72.setInitialConversationId
	})

	if getFFlagAppChatRequestedRoute() then
		useEffect(function() -- line: 571
			-- upvalues: v72 (copy), v73 (copy), v79 (copy), NavigateIntoChat (copy)
			if v72.requestedRoute and v73 then
				v79(NavigateIntoChat(v72.requestedRoute))

				if v72.clearRequestedRoute then
					v72.clearRequestedRoute()
				end
			end

			return function() -- line: 579
			end
		end, {
			v79,
			v73,
			v72.requestedRoute,
			v72.clearRequestedRoute
		})
	end

	local u103 = nil
	local u104 = nil

	if GetFFlagIsSquadEnabled() then
		u103 = useCurrentSquadParentChannelId()

		if GetFFlagEnableCrossExpVoice() then
			u104 = useIsVoiceConnected()
		end
	end

	useEffect(function() -- line: 598
		-- upvalues: GetFFlagIsSquadEnabled (copy), v73 (copy), v72 (copy), u103 (ref), GetFFlagEnableCrossExpVoice (copy), u104 (ref), v79 (copy), NavigateIntoChat (copy), EnumScreens (copy), v75 (copy)
		if GetFFlagIsSquadEnabled() and (v73 and v72.initialConversationId == "" and u103) then
			if GetFFlagEnableCrossExpVoice() and u104 then
				v79(NavigateIntoChat({
					screen = EnumScreens.SquadLobby,
					params = {
						userId = v75,
						conversationId = u103
					}
				}))

				return
			end

			v79(NavigateIntoChat({
				screen = EnumScreens.ChatConversation,
				params = {
					userId = v75,
					conversationId = u103
				}
			}))
		end
	end, {})
	useEffect(function() -- line: 619
		-- upvalues: v102 (copy), v72 (copy)
		v102(v72.rnBypassActionSignal)
	end, {
		v72.rnBypassActionSignal,
		v102
	})
	useEffect(function() -- line: 623
		-- upvalues: FFlagAppChatTopBarSignalsStore (copy), Cryo (copy), v81 (copy), v82 (copy)
		if not FFlagAppChatTopBarSignalsStore and not Cryo.isEmpty(v81) then
			v82({})
		end
	end, {
		v72.wideMode,
		FFlagAppChatTopBarSignalsStore,
		v81
	})

	local v105 = useAppPolicy(function(p29) -- line: 629
		return p29.getChatHeaderSearch()
	end)
	local v106 = useAppPolicy(function(p30) -- line: 632
		return p30.getChatHeaderCreateChatGroup()
	end)
	local v107 = useAppPolicy(function(p31) -- line: 635
		-- upvalues: getFFlagHideNotificationIconForVR (copy)
		return p31.getChatHeaderNotifications() and (not getFFlagHideNotificationIconForVR() or p31.getWebViewSupport())
	end)
	local v108 = usePageSideMargin(v85.current)
	local v109 = React.useMemo(function() -- line: 641
		-- upvalues: v73 (copy), v108 (copy)
		return {
			default = 12,
			outer = if not v73 then v108 else 12,
			inner = if not v73 then v108 else 12
		}
	end, {
		v108,
		v73
	})
	local v110 = useIsChatEnabled()
	local v111 = if not FFlagAppChatTopBarConfigDriven() then not v73 and (v107 and not FFlagAppChatRemoveNotifications) else nil
	local v112 = if not FFlagAppChatTopBarConfigDriven() then v105 and (not v73 and v110) else nil
	local v113 = if not FFlagAppChatTopBarConfigDriven() then v106 and v110 else nil
	local v114 = if not FFlagAppChatTopBarConfigDriven() then v73 and GetFFlagEnableAppChatInExperience() else nil
	local v115 = useStyle()
	local v116 = useCallback(function(p32) -- line: 667
		-- upvalues: v79 (copy), SetTabBarVisible (copy)
		v79(SetTabBarVisible(p32))
	end, { v79 })
	local v117 = React.createElement(v85, {
		externalDispatchConnector = v95,
		parameters = v72.parameters,
		setActiveConversationId = v72.setActiveConversationId,
		setBackButtonEnabled = v72.setBackButtonEnabled,
		setTabBarVisible = v116,
		chatIsVisible = v80,
		screenProps = {
			navigateToLuaAppPages = v72.navigateToLuaAppPages,
			topBarHeight = math.max(UserInputService.NavBarSize.Y, if not v74 then NAV_BAR_WITH_FACEPILE_SIZE else v74.Size.Size_1400),
			wideMode = v72.wideMode,
			isInExperience = v73,
			isVisible = v72.isVisible,
			notificationCount = v72.notificationCount,
			appChatOuterPadding = v109.outer,
			appChatInnerPadding = v109.inner,
			appChatDefaultPadding = v109.default,
			topBarShowSearch = v112,
			topBarShowCreateChatGroup = v113,
			topBarShowNotifications = v111,
			topBarShowSnoozeNotifications = v114,
			topBarUtilityIconSideMargin = if not FFlagEnableHeaderBarButtonsUpdate then nil else v74.Size.Size_100,
			showSearchRow = v73,
			navigateToRootStack = v72.navigateToRootStack,
			navigateToAddFriends = v72.navigateToAddFriends,
			getScreenTopBar = if not FFlagAppChatTopBarSignalsStore then v100 else nil,
			setScreenTopBar = if not FFlagAppChatTopBarSignalsStore then v101 else nil
		}
	})
	local v118 = React.createElement(LuaAppNavigationContextProvider, {
		navigateToLuaAppPages = v72.navigateToLuaAppPages,
		dispatch = v79
	}, {
		navigation = v117
	})
	local v119 = React.createElement(ChatPlacementContext.Provider, {
		value = {
			chatPlacement = v72.chatPlacement
		}
	}, {
		navigation = v118
	})

	if not FFlagAppChatSignalsReplyStore then
		v119 = React.createElement(ReplyingToMessageProvider, {}, {
			navigation = v119
		})
	end

	local v120 = React.createElement(InteractionFeedback.InteractionFeedbackContext.Provider, {
		value = HapticFeedbackConfig
	}, {
		navigation = v119
	})

	if not v73 then
		v120 = React.createElement(LayerCollectorProvider, {}, {
			navigation = v120
		})
	end

	local v121 = useRobloxLocale()
	local PlaySessionId = RbxAnalyticsService:GetPlaySessionId()
	local v123 = if not GetFFlagIsSquadEnabled() then nil else useSelector(function(p33) -- line: 740
		local v149 = p33.Squad and (p33.Squad.Squad and p33.Squad.Squad.currentSquad)

		if v149 and v149.squadId then
			return v149.squadId
		end

		return nil
	end)
	local v124 = React.createElement(AnalyticsProvider, {
		localUserId = v75,
		entryPoint = v78
	}, {
		telemetry = React.createElement(AppTelemetryLayer.Provider, {
			value = {
				context = "platformChat",
				locale = v121,
				entryPoint = v78 or "unknown",
				userId = v75,
				playSessionId = PlaySessionId,
				currentSquadId = v123,
				placement = v72.chatPlacement
			}
		}, { React.createElement(if not FFlagAppChatTopBarSignalsStore then TopBarContext.Provider else React.Fragment, if not FFlagAppChatTopBarSignalsStore then {
			value = Cryo.Dictionary.join(v81, {
				getScreenTopBar = v100,
				setScreenTopBar = v101
			})
		} else nil, {
			navigation = v120,
			BottomInsetBackground = if not (v76.bottom > 0) then nil else React.createElement("Frame", {
				BorderSizePixel = 0,
				ZIndex = 3,
				BackgroundColor3 = if not getFFlagFixChatsBottomInsetBackgroundColor() then v115.Theme.NavigationBar.Color else v115.Theme.BackgroundDefault.Color,
				BackgroundTransparency = if not getFFlagFixChatsBottomInsetBackgroundColor() then v115.Theme.NavigationBar.Transparency else v115.Theme.BackgroundDefault.Transparency,
				Position = UDim2.new(0, 0, 1, 0),
				Size = UDim2.new(1, 0, 0, v76.bottom)
			})
		}) })
	})

	if FFlagAppChatPerfTracking then
		useEffect(function() -- line: 793
			-- upvalues: AppChatPerfTracker (copy), v72 (copy), v78 (copy), v123 (copy)
			AppChatPerfTracker.setSharedContext({
				placement = v72.chatPlacement,
				entryPoint = v78,
				hasActiveParty = v123 ~= nil
			})
		end, {
			v72.chatPlacement,
			v78,
			v123
		})
	end

	return React.createElement(RoactChatAnalyticsProvider, {
		entryPoint = v78
	}, { v124 })
end

return memo(AppChatEntryPoint)
