local HttpService = game:GetService("HttpService")
local AppChat = script:FindFirstAncestor("AppChat")
local AppChatParent = AppChat.Parent
local AppCommonLib = require(AppChatParent.AppCommonLib)
local AppNavBar = require(AppChatParent.AppNavBar)
local VisibilityControl = AppNavBar.VisibilityControl
local Cryo = require(AppChatParent.Cryo)
local Components = require(AppChatParent.FriendsLanding.Components)
local React = require(AppChatParent.React)
local RoactRodux = require(AppChatParent.RoactRodux)
local SharedFlags = require(AppChatParent.SharedFlags)
local UIBlox = require(AppChatParent.UIBlox)
local useDispatch = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useDispatch
local useEffectOnMount = require(AppChatParent.RoactUtils).Hooks.useEffectOnMount
local useLocalization = require(AppChatParent.Localization).Hooks.useLocalization
local useLocalUserId = require(AppChatParent.RobloxAppHooks).useLocalUserId
local useNavigation = require(AppChatParent.Navigation).useNavigation
local usePrevious = require(AppChatParent.RoactUtils).Hooks.usePrevious
local useSelector = require(AppChatParent.RoactUtils).Hooks.RoactRodux.useSelector
local AppPage = require(AppChatParent.RobloxAppEnums).AppPage
local ChatLoadingContainer = require(script.Parent.ChatLoading.ChatLoadingContainer)
local ChatLandingTelemetryEvents = require(script.Parent.ChatLandingTelemetryEvents)
local ConversationGroupsEntryContainer = require(script.Parent.ConversationGroupsEntryContainer)
local ConversationListWithTopBar = require(script.Parent.ConversationListWithTopBar)
local v25 = require(script.Parent.Logger):new(script.Name)
local NoConversationsLanding = require(script.Parent.NoConversationsLanding)
local mapDispatchToProps = require(script.Parent.mapDispatchToProps)
local ChatLandingTelemetryLayer = require(AppChat.Telemetry.Layers.ChatLandingTelemetryLayer)
local ChatLandingTelemetryState = require(AppChat.Contexts.TelemetryState.ChatLandingTelemetryState)
local compose = require(AppChat.SocialLibraries).RoduxTools.compose
local ConversationChannels = require(AppChat.Models.ConversationChannels)
local createConversation = require(AppChat.Conversations.Thunks.createConversation)
local CreateConversationError = require(AppChat.Analytics.Enums.CreateConversationError)
local EmptyStateType = require(AppChat.Analytics.Enums.EmptyStateType)
local EnumScreens = require(AppChat.EnumScreens)
local EventNames = require(AppChat.Analytics.EventNames)
local fetchConversationsByPage = require(AppChat.Conversations.Thunks.fetchConversationsByPage)
local getConversationTitle = require(AppChat.Conversations.getConversationTitle)
local getOtherParticipants = require(AppChat.Conversations.getOtherParticipants)
local parseCreateConversationErrors = require(AppChat.Conversations.Thunks.parseCreateConversationErrors)
local RoactPaginator = require(AppChat.SocialLibraries).RoactPaginator
local useAnalytics = require(AppChat.Analytics.useAnalytics)
local useChatPlacementContext = require(AppChat.Contexts.ChatPlacementContext).useChatPlacementContext
local useGetConversations = require(AppChat.Hooks.useGetConversations)
local useAreConversationsFetching = require(AppChat.Hooks.useAreConversationsFetching)
local useChatIsVisible = require(AppChat.Hooks.useChatIsVisible)
local useHasConversations = require(AppChat.Hooks.useHasConversations)
local useAppChatIsWideMode = require(AppChat.Hooks.useAppChatIsWideMode)
local useIsAppLoaded = require(AppChat.Hooks.useIsAppLoaded)
local useIsChatEnabled = require(AppChat.Hooks.useIsChatEnabled)
local useIsExternalNavigationAvailable = require(AppChat.Hooks.useIsExternalNavigationAvailable)
local useIsGroupChatEnabled = require(AppChat.Hooks.useIsGroupChatEnabled)
local useIsInExperience = require(AppChat.Hooks.useIsInExperience)
local useIsOldestConversationFetched = require(AppChat.Hooks.useIsOldestConversationFetched)
local useIsUserPending = require(AppChat.Hooks.useIsUserPending)
local useIsChatEnabledFromReason = require(AppChat.Hooks.useIsChatEnabledFromReason)
local useAnalytics2 = require(AppChat.Analytics.useAnalytics)
local useTelemetry = require(AppChat.Telemetry.useTelemetry)
local getConversationIds = require(AppChat.Utils.getConversationIds)
local FFlagAppChatPerfTracking = require(AppChat.Flags.FFlagAppChatPerfTracking)
local FFlagAppChatMessageTTIMilestones = require(AppChat.Flags.FFlagAppChatMessageTTIMilestones)
local FFlagAppChatUseNewConversationRow = require(AppChat.Flags.FFlagAppChatUseNewConversationRow)
local AppChatPerfTracker = require(AppChat.Telemetry.AppChatPerfTracker)
local useCallback = React.useCallback
local useEffect = React.useEffect
local IsVRAppBuild = AppCommonLib.IsVRAppBuild
local useStyle = UIBlox.Core.Style.useStyle
local useTextSizeOffset = UIBlox.Core.Style.useTextSizeOffset
local NoFriendsView = Components.NoFriendsView
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagEnableScrollAwayContentScrollableFix = SharedFlags.FFlagEnableScrollAwayContentScrollableFix
local FFlagAppChatConversationStore = require(AppChat.Flags.FFlagAppChatConversationStore)
local FFlagAppChatSignalsMessageStore = require(AppChat.Flags.FFlagAppChatSignalsMessageStore)
local getFFlagChatTabHideGroupsLinkOnVR = require(AppChat.Flags.getFFlagChatTabHideGroupsLinkOnVR)
local GetTopBarStore = require(AppChat.Stores.GetTopBarStore)
local FFlagAppChatTopBarSignalsStore = require(AppChat.Flags.FFlagAppChatTopBarSignalsStore)
local PartyPageCarouselExperimentation = require(AppChatParent.SocialExperiments).PartyPageCarouselExperimentation
local FFlagCreateConnectionsHub = require(AppChatParent.SharedFlags).FFlagCreateConnectionsHub
local FFlagConnectionsToFriendsRename = require(AppChatParent.SharedFlags).FFlagConnectionsToFriendsRename
local SquadQuickStartExperimentation = require(AppChatParent.SocialExperiments).SquadQuickStartExperimentation
local useCanAccessParty = require(AppChatParent.Squads.useCanAccessParty)
local useConversationList = require(AppChat.Hooks.useConversationList)
local v83 = FFlagAppChatUseNewConversationRow and (FFlagAppChatConversationStore and FFlagAppChatSignalsMessageStore)
local v84 = if not (game.PlaceId > 0) then nil else tostring(game.PlaceId)
local v85 = if not (game.GameId > 0) then nil else tostring(game.GameId)
local t1 = {
	topBarHeight = 0,
	isShowingFilterBox = false,
	navigateToSquadLobby = function() -- line: 117
	end
}

local function areConversationIdsEqual(t2: {[any]: any}, t3: {[any]: any}) -- line: 120
	if #t2 ~= #t3 then
		return false
	end

	for v91, v92 in t2 do
		if v92 ~= t3[v91] then
			return false
		end
	end

	return true
end
local function encodeConversationIds(t4: {[any]: any}) -- line: 134
	-- upvalues: HttpService (copy)
	local ok, result = pcall(function() -- line: 135
		-- upvalues: HttpService (copy), t4 (copy)
		return HttpService:JSONEncode(t4)
	end)

	if ok then
		return result
	end

	return "[]"
end

function ChatLandingContainer(t5: {[any]: any}) -- line: 141
	-- upvalues: Cryo (copy), t1 (copy), useAnalytics (copy), useChatPlacementContext (copy), useDispatch (copy), useIsChatEnabled (copy), useIsGroupChatEnabled (copy), useIsChatEnabledFromReason (copy), useIsInExperience (copy), useAppChatIsWideMode (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy), useIsAppLoaded (copy), useAreConversationsFetching (copy), useHasConversations (copy), useIsOldestConversationFetched (copy), useLocalUserId (copy), useNavigation (copy), useStyle (copy), useTextSizeOffset (copy), useAnalytics2 (copy), FFlagCreateConnectionsHub (copy), useGetConversations (copy), v83 (copy), useConversationList (copy), useEffect (copy), getConversationIds (copy), v25 (copy), HttpService (copy), usePrevious (copy), fetchConversationsByPage (copy), React (copy), getOtherParticipants (copy), useIsUserPending (copy), ConversationChannels (copy), getConversationTitle (copy), useTelemetry (copy), ChatLandingTelemetryLayer (copy), ChatLandingTelemetryState (copy), useEffectOnMount (copy), ChatLandingTelemetryEvents (copy), useLocalization (copy), useCallback (copy), PartyPageCarouselExperimentation (copy), EventNames (copy), v84 (copy), v85 (copy), EnumScreens (copy), createConversation (copy), parseCreateConversationErrors (copy), CreateConversationError (copy), useSelector (copy), useIsExternalNavigationAvailable (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), useCanAccessParty (copy), SquadQuickStartExperimentation (copy), ChatLoadingContainer (copy), NoFriendsView (copy), EmptyStateType (copy), AppPage (copy), FFlagConnectionsToFriendsRename (copy), NoConversationsLanding (copy), ConversationListWithTopBar (copy), FFlagAppChatUseNewConversationRow (copy), FFlagEnableScrollAwayContentScrollableFix (copy), VisibilityControl (copy), getFFlagChatTabHideGroupsLinkOnVR (copy), IsVRAppBuild (copy), FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), ConversationGroupsEntryContainer (copy), useChatIsVisible (copy)
	local v97 = Cryo.Dictionary.join(t1, t5)
	local v98 = useAnalytics()
	local v99 = useChatPlacementContext()
	local v100 = useDispatch()
	local v101 = useIsChatEnabled()
	local v102 = useIsGroupChatEnabled()
	local v103 = useIsChatEnabledFromReason("privacySettingsEnabled")
	local v104 = useIsChatEnabledFromReason("globalRulesEnabled")
	local v105 = useIsChatEnabledFromReason("thirdPartyPrivacySettingsEnabled")
	local v106 = useIsInExperience()
	local v107 = useAppChatIsWideMode(v106)

	if FFlagAppChatPerfTracking and (FFlagAppChatMessageTTIMilestones and AppChatPerfTracker.Hooks) then
		local v108 = AppChatPerfTracker.getEventName(AppChatPerfTracker.Events.ChatLandingTTI) or ""

		AppChatPerfTracker.Hooks.useTTIRenderAndMountedTracking(v108)
	end

	local v109 = useIsAppLoaded()
	local v110 = useAreConversationsFetching()
	local v111 = useHasConversations()
	local v112 = useIsOldestConversationFetched()
	local v113 = useLocalUserId()
	local v114 = useNavigation()
	local v115 = useStyle()
	local v116 = useTextSizeOffset()
	local v117 = useAnalytics2()
	local v118 = 64 + 2 * v116
	local v119 = if not FFlagCreateConnectionsHub then nil else v114.getScreenProps("navigateToLuaAppPages", {})
	local v120 = useGetConversations()
	local t6 = {}
	local t7 = {}

	if v83 then
		local v123 = useConversationList(true)

		t6 = v123.items
		t7 = v123.listStatus
	end

	local v124 = if not v83 then v120 else t6
	local v125 = if not v83 then v110 else t7.isFetchingConversations == true
	local v126 = if not v83 then v111 else #t6 > 0
	local v127 = if not v83 then v112 else t7.oldestConversationIsFetched == true

	if v83 then
		useEffect(function() -- line: 196
			-- upvalues: v120 (copy), t6 (ref), getConversationIds (copy), v25 (copy), HttpService (copy)
			if #v120 == 0 and #t6 == 0 then
				return
			end

			local v154 = getConversationIds(v120)
			local v155 = getConversationIds(t6)
			local v156, g159

			if #v154 ~= #v155 then
				v156 = false
			else
				g159 = nil
				v156 = nil

				for v157, v158 in v154 do
					if v158 ~= v155[v157] then
						v156 = false
						g159 = true
					end

					if g159 then
						break
					end
				end

				if not g159 then
					v156 = true
				end
			end

			g159 = false

			if not v156 then
				local v160 = v25
				local ok, result = pcall(function() -- line: 135
					-- upvalues: HttpService (copy), v154 (copy)
					return HttpService:JSONEncode(v154)
				end)
				local v163 = not ok and "[]" or result
				local ok2, result2 = pcall(function() -- line: 135
					-- upvalues: HttpService (copy), v155 (copy)
					return HttpService:JSONEncode(v155)
				end)

				v160:warning("Conversation list parity mismatch. Rodux ids: {}, Signals ids: {}", v163, not ok2 and "[]" or result2)
			end
		end, {
			v120,
			t6
		})
	end

	local v128 = usePrevious(v101)

	useEffect(function() -- line: 214
		-- upvalues: v25 (copy), v128 (copy), v101 (copy), v100 (copy), fetchConversationsByPage (copy)
		v25:debug("Comparing previousIsChatEnabled ({}) --> isChatEnabled ({})", v128, v101)

		if v128 ~= nil and (v128 ~= v101 and v101) then
			v25:info("Chat has become enabled, fetching conversations")
			v100(fetchConversationsByPage())
		end
	end, {
		v100,
		v101,
		v128
	})

	local v129, v130, v131 = React.useMemo(function() -- line: 230
		-- upvalues: v124 (copy), v83 (copy), Cryo (copy), getOtherParticipants (copy), v113 (copy), useIsUserPending (copy), ConversationChannels (copy), getConversationTitle (copy), v102 (copy)
		local n1 = 0
		local n2 = 0
		local t8 = {}

		for _, v170 in v124 do
			local v171 = if not v83 or v170.otherParticipants ~= nil then v170 else Cryo.Dictionary.join(v170, {
				otherParticipants = getOtherParticipants(v170, v113)
			})

			if useIsUserPending(v171) then
				n1 += 1
			end

			if v171.moderationType == ConversationChannels.ModerationType.TrustedComms then
				n2 += 1
			end

			local v172 = getConversationTitle(v171)

			if v102 or v171.conversationType ~= "MultiUserConversation" then
				table.insert(t8, Cryo.Dictionary.join(v171, {
					title = v172
				}))
			end
		end

		return t8, n1, n2
	end, {
		v124,
		v102,
		if not v83 then nil else v113
	})
	local v132 = useTelemetry(ChatLandingTelemetryLayer.Context)
	local emit = v132.emit

	if v83 then
		local v134 = React.useRef(v132.emit)

		v134.current = v132.emit

		function emit(...) -- line: 273
			-- upvalues: v134 (copy)
			v134.current(...)
		end
	end

	local v135 = ChatLandingTelemetryState.useSetState()

	useEffect(function() -- line: 279
		-- upvalues: v135 (copy), Cryo (copy), v129 (copy), v130 (copy), v131 (copy)
		v135(function(p1) -- line: 280
			-- upvalues: Cryo (copy), v129 (copy), v130 (copy), v131 (copy)
			return Cryo.Dictionary.join(p1, {
				chatLandingListCount = #v129,
				pendingConversationCount = v130,
				unfilteredConversationCount = v131
			})
		end)
	end, {
		#v129,
		v130,
		v131,
		v135
	})
	useEffectOnMount(function() -- line: 289
		-- upvalues: v132 (copy), ChatLandingTelemetryEvents (copy), v101 (copy)
		v132.emit(ChatLandingTelemetryEvents.ScreenRendered, {
			isChatEnabled = v101
		})
	end)

	local v136 = useLocalization({
		partyUnavailableWithUser = "Feature.Chat.Message.PartyUnavailableWithUser",
		networkErrorText = "Feature.Toast.NetworkingError.SomethingIsWrong"
	})
	local v137 = useCallback(function() -- line: 300
		-- upvalues: PartyPageCarouselExperimentation (copy), HttpService (copy), v98 (copy), EventNames (copy), v99 (copy), v84 (copy), v85 (copy), v114 (copy), EnumScreens (copy)
		if PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
			local guid = HttpService:GenerateGUID(false)

			v98.fireAnalyticsEvent(EventNames.ChatLandingPartyQuickStartButtonClicked, {
				clickLocation = v99.chatPlacement,
				partyAttemptId = guid,
				placeId = v84,
				universeId = v85
			})
			v114.navigate(EnumScreens.QuickStartSquadInviteFriends, {
				uuid = guid
			})
		end
	end, {
		v98,
		v99,
		v114,
		v84,
		v85
	})
	local v138 = useCallback(function(p2) -- line: 317
		-- upvalues: PartyPageCarouselExperimentation (copy), v100 (copy), createConversation (copy), v117 (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), v114 (copy), EnumScreens (copy), parseCreateConversationErrors (copy), v136 (copy), EventNames (copy), CreateConversationError (copy)
		if PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
			v100(createConversation("one_to_one", { p2 }, v117, "navigateToConversationFromSocialCarousel")):andThen(function(p3) -- line: 331
				-- upvalues: FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), v114 (copy), EnumScreens (copy)
				if FFlagAppChatPerfTracking then
					AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatConversationTTI, {
						conversationId = p3.id
					})
				end

				v114.navigate(EnumScreens.ChatConversation, {
					conversationId = p3.id
				})
			end):catch(function(p4) -- line: 341
				-- upvalues: parseCreateConversationErrors (copy), v136 (copy), v114 (copy), EnumScreens (copy), v117 (copy), EventNames (copy), CreateConversationError (copy)
				local v183 = if parseCreateConversationErrors(p4) ~= "participant_chat_disabled" then v136.networkErrorText else v136.partyUnavailableWithUser

				v114.navigate(EnumScreens.RoactChatToast, {
					toastProps = {
						toastContent = {
							toastTitle = v183
						}
					}
				})

				if v117 then
					v117.fireAnalyticsEvent(EventNames.NewConversationCreated, {
						createConversationResult = CreateConversationError.FetchConversationError
					})
				end
			end)
		end
	end, {
		v100,
		v136,
		parseCreateConversationErrors,
		v114,
		v117
	})
	local v139 = Cryo.isEmpty(v129)
	local v140 = useSelector(function(p5) -- line: 364
		return p5.ChatAppReducer.ChatSettings.retrievalStatus ~= "Done"
	end) or (v139 and v125 or v139 and v126)
	local v141 = false
	local u142 = false
	local u143 = false
	local v144 = useIsExternalNavigationAvailable({
		EnumScreens.AddFriends,
		EnumScreens.PrivacySettings,
		EnumScreens.Groups
	})
	local v145 = FFlagAppIaScrollAway and (not v106 and AppNavBar.getScrollAwayEnabled())
	local v146 = useCanAccessParty()
	local v147 = SquadQuickStartExperimentation.getPartyQuickStartChangesEnabled() and v146
	local v148

	if v140 then
		v148 = React.createElement(ChatLoadingContainer, {
			cellWidth = 375,
			topBarHeight = v97.topBarHeight,
			pageHeaderText = v97.pageHeaderText,
			cellHeight = v118,
			topPadding = if not FFlagAppIaScrollAway or not v145 then nil else v97.topBarHeight
		})
		v141 = true
	elseif not v101 or v139 and v109 and not v125 then
		if v101 then
			v148 = React.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = v115.Theme.BackgroundDefault.Color,
				BackgroundTransparency = v115.Tokens.Color.None.Transparency
			}, {
				NoFriendsView = React.createElement(NoFriendsView, {
					pageRenderReport = function() -- line: 410
						-- upvalues: v132 (copy), ChatLandingTelemetryEvents (copy), EmptyStateType (copy)
						v132.emit(ChatLandingTelemetryEvents.ChatEmptyStateScreenRendered, {
							emptyStateType = EmptyStateType.NoFriendsView
						})
					end,
					openAddFriendsPage = function() -- line: 415
						-- upvalues: v132 (copy), ChatLandingTelemetryEvents (copy), FFlagCreateConnectionsHub (copy), v119 (copy), AppPage (copy), v97 (copy)
						v132.emit(ChatLandingTelemetryEvents.ChatAddFriendsBtnClicked, {})

						if FFlagCreateConnectionsHub then
							v119[AppPage.CoHubAddConnections]()

							return
						end

						v97.navigateToAddFriends()
					end,
					noFriendsHeaderKey = not FFlagConnectionsToFriendsRename and "Feature.Chat.Label.AddConnections" or "Feature.Chat.Label.AddFriends",
					noFriendsTextLabelKey = not FFlagConnectionsToFriendsRename and "Feature.Chat.Text.NoConnections" or "Feature.Chat.Text.NoFriends",
					addFriendsBtnLabelKey = not FFlagConnectionsToFriendsRename and "Feature.Chat.Label.AddConnections" or "Feature.Chat.Label.AddFriends",
					addFriendsBtnEnabled = v144[EnumScreens.AddFriends]
				})
			})
			v141 = true
		else
			v148 = React.createElement(NoConversationsLanding, {
				chatEnabled = v101,
				privacySettingsEnabled = v103,
				globalRulesEnabled = v104,
				thirdPartyPrivacySettingsEnabled = v105,
				canNavigateToPrivacySettings = v144[EnumScreens.PrivacySettings],
				canNavigateToAddFriends = v144[EnumScreens.AddFriends],
				onCallToAction = function(p6) -- line: 445
					-- upvalues: v97 (copy), v132 (copy), ChatLandingTelemetryEvents (copy), FFlagCreateConnectionsHub (copy), v119 (copy), AppPage (copy)
					if p6 == "privacy" then
						v97.navigateToPrivacy()

						return
					end

					if p6 == "friends" then
						v132.emit(ChatLandingTelemetryEvents.ChatAddFriendsBtnClicked, {})

						if FFlagCreateConnectionsHub then
							v119[AppPage.CoHubAddConnections]()

							return
						end

						v97.navigateToAddFriends()
					end
				end,
				fireRenderEvent = function(p7) -- line: 457
					-- upvalues: EmptyStateType (copy), v132 (copy), ChatLandingTelemetryEvents (copy)
					local v178 = if p7 ~= "friends" then if p7 ~= "privacy" then if p7 ~= "regional" then EmptyStateType.EmptyConversationList else EmptyStateType.ChatUnavailableRegionView else EmptyStateType.ChatSettingsDisabledView else EmptyStateType.NoFriendsView

					v132.emit(ChatLandingTelemetryEvents.ChatEmptyStateScreenRendered, {
						emptyStateType = v178
					})
				end
			})
		end
	else
		local v149 = `conversationListWithTopBar{ v97.filterText }`

		v141 = true
		u142 = true
		u143 = true
		v148 = React.createElement(ConversationListWithTopBar, Cryo.Dictionary.join(v97, {
			filterText = v97.isShowingFilterBox and v97.filterText or nil,
			key = v149,
			itemList = v129,
			appLoaded = v109,
			localUserId = v113,
			conversationsIsFetching = v125,
			oldestConversationIsFetched = v127,
			entryHeight = v118,
			isInExperience = v106,
			isWideMode = if not PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() and not FFlagAppChatUseNewConversationRow then nil else v107,
			navigateToConversationFromUserId = if not PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then nil else v138,
			navigateToQuickStartSquadInviteFriends = if not PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then nil else v137,
			showGroupsLink = v144[EnumScreens.Groups],
			canvasTopPadding = if not FFlagAppIaScrollAway or not v145 then nil else v97.topBarHeight,
			canAccessParty = v146,
			isPartyQuickStartEnabled = v147
		}))
	end

	if FFlagAppIaScrollAway and FFlagEnableScrollAwayContentScrollableFix then
		useEffect(function() -- line: 512
			-- upvalues: v145 (copy), VisibilityControl (copy), u143 (ref)
			if not v145 then
				return
			end

			VisibilityControl.setContentScrollable(u143)
		end, {
			u143,
			v145
		})
	end

	if getFFlagChatTabHideGroupsLinkOnVR() and IsVRAppBuild() then
		v141 = true
	end

	if FFlagAppChatTopBarSignalsStore then
		useEffect(function() -- line: 526
			-- upvalues: v106 (copy), GetTopBarStore (copy), EnumScreens (copy), u142 (ref)
			if v106 then
				GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatLanding, {
					rightHidden = not u142
				})
			end
		end, {
			u142,
			v106
		})
	else
		local v150 = v114.getScreenProps("setScreenTopBar", function() -- line: 534
		end)

		useEffect(function() -- line: 535
			-- upvalues: v106 (copy), v150 (copy), EnumScreens (copy), u142 (ref)
			if v106 then
				v150(EnumScreens.ChatLanding, {
					rightHidden = not u142
				})
			end
		end, {
			u142,
			v150,
			v106
		})
	end

	local v151 = if not (not v141 and v144[EnumScreens.Groups]) then v148 else React.createElement(React.Fragment, nil, {
		UIPadding = if not FFlagAppIaScrollAway or not v145 then nil else React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v97.topBarHeight)
		}),
		groupsLink = React.createElement(ConversationGroupsEntryContainer, {
			entryHeight = v118
		}),
		chatFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, -v118),
			Position = UDim2.new(0, 0, 0, v118)
		}, {
			chatContainer = v148
		})
	})
	local v152 = useChatIsVisible()

	React.useEffect(function() -- line: 576
		-- upvalues: v152 (copy), emit (ref), ChatLandingTelemetryEvents (copy), v101 (copy), v140 (copy)
		if v152 then
			emit(ChatLandingTelemetryEvents.AppChatVisible, {
				isChatEnabled = v101,
				isChatLoading = v140
			})
		end
	end, {
		v152,
		v101,
		v140
	})

	if FFlagAppChatPerfTracking then
		React.useEffect(function() -- line: 586
			-- upvalues: v152 (copy), v140 (copy), v101 (copy), v25 (copy), v129 (copy), AppChatPerfTracker (copy)
			if not v152 then
				return
			end

			local v179 = not v140 and v101

			v25:debug("TTI Ready Check (ChatLanding): isLoading={}, isChatEnabled={}, itemCount={}, ready={}", v140, v101, #v129, v179)

			if v179 and AppChatPerfTracker.isActive(AppChatPerfTracker.Events.ChatLandingTTI) then
				AppChatPerfTracker.finish(AppChatPerfTracker.Events.ChatLandingTTI, {
					numElementsRendered = #v129
				})
			end
		end, {
			v152,
			v140,
			v101,
			#v129
		})
	end

	local v153 = React.useRef({
		isChatEnabled = v101,
		isChatLoading = v140
	})

	React.useEffect(function() -- line: 610
		-- upvalues: v153 (copy), v101 (copy), v140 (copy)
		v153.current = {
			isChatEnabled = v101,
			isChatLoading = v140
		}
	end, {
		v101,
		v140
	})
	useEffect(function() -- line: 619
		-- upvalues: v152 (copy), emit (ref), ChatLandingTelemetryEvents (copy), v153 (copy)
		return function() -- line: 620
			-- upvalues: v152 (copy), emit (ref), ChatLandingTelemetryEvents (copy), v153 (copy)
			if v152 then
				emit(ChatLandingTelemetryEvents.AppChatClosed, v153.current)
			end
		end
	end, { v152 })

	return v151
end

return compose(RoactRodux.connect(nil, mapDispatchToProps), RoactPaginator.connect(function() -- line: 633
	return {
		pageSize = 30
	}
end))(ChatLandingContainer)
