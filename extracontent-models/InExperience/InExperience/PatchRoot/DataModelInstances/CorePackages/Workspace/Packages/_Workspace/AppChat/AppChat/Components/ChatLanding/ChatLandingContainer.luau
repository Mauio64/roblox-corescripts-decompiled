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
local FFlagSignalsNavP3hMisc = SharedFlags.FFlagSignalsNavP3hMisc
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
local v84 = FFlagAppChatUseNewConversationRow and (FFlagAppChatConversationStore and FFlagAppChatSignalsMessageStore)
local v85 = if not (game.PlaceId > 0) then nil else tostring(game.PlaceId)
local v86 = if not (game.GameId > 0) then nil else tostring(game.GameId)
local t1 = {
	topBarHeight = 0,
	isShowingFilterBox = false,
	navigateToSquadLobby = function() -- line: 118
	end
}

local function areConversationIdsEqual(t2: {[any]: any}, t3: {[any]: any}) -- line: 121
	if #t2 ~= #t3 then
		return false
	end

	for v92, v93 in t2 do
		if v93 ~= t3[v92] then
			return false
		end
	end

	return true
end
local function encodeConversationIds(t4: {[any]: any}) -- line: 135
	-- upvalues: HttpService (copy)
	local ok, result = pcall(function() -- line: 136
		-- upvalues: HttpService (copy), t4 (copy)
		return HttpService:JSONEncode(t4)
	end)

	if ok then
		return result
	end

	return "[]"
end

function ChatLandingContainer(t5: {[any]: any}) -- line: 142
	-- upvalues: Cryo (copy), t1 (copy), useAnalytics (copy), useChatPlacementContext (copy), useDispatch (copy), useIsChatEnabled (copy), useIsGroupChatEnabled (copy), useIsChatEnabledFromReason (copy), useIsInExperience (copy), useAppChatIsWideMode (copy), FFlagAppChatPerfTracking (copy), FFlagAppChatMessageTTIMilestones (copy), AppChatPerfTracker (copy), useIsAppLoaded (copy), useAreConversationsFetching (copy), useHasConversations (copy), useIsOldestConversationFetched (copy), useLocalUserId (copy), useNavigation (copy), useStyle (copy), useTextSizeOffset (copy), useAnalytics2 (copy), FFlagCreateConnectionsHub (copy), useGetConversations (copy), v84 (copy), useConversationList (copy), useEffect (copy), getConversationIds (copy), v25 (copy), HttpService (copy), usePrevious (copy), fetchConversationsByPage (copy), React (copy), getOtherParticipants (copy), useIsUserPending (copy), ConversationChannels (copy), getConversationTitle (copy), useTelemetry (copy), ChatLandingTelemetryLayer (copy), ChatLandingTelemetryState (copy), useEffectOnMount (copy), ChatLandingTelemetryEvents (copy), useLocalization (copy), useCallback (copy), PartyPageCarouselExperimentation (copy), EventNames (copy), v85 (copy), v86 (copy), EnumScreens (copy), createConversation (copy), parseCreateConversationErrors (copy), CreateConversationError (copy), useSelector (copy), useIsExternalNavigationAvailable (copy), FFlagAppIaScrollAway (copy), AppNavBar (copy), useCanAccessParty (copy), SquadQuickStartExperimentation (copy), ChatLoadingContainer (copy), NoFriendsView (copy), EmptyStateType (copy), AppPage (copy), FFlagConnectionsToFriendsRename (copy), NoConversationsLanding (copy), ConversationListWithTopBar (copy), FFlagAppChatUseNewConversationRow (copy), FFlagEnableScrollAwayContentScrollableFix (copy), VisibilityControl (copy), getFFlagChatTabHideGroupsLinkOnVR (copy), IsVRAppBuild (copy), FFlagAppChatTopBarSignalsStore (copy), GetTopBarStore (copy), ConversationGroupsEntryContainer (copy), useChatIsVisible (copy), FFlagSignalsNavP3hMisc (copy)
	local v98 = Cryo.Dictionary.join(t1, t5)
	local v99 = useAnalytics()
	local v100 = useChatPlacementContext()
	local v101 = useDispatch()
	local v102 = useIsChatEnabled()
	local v103 = useIsGroupChatEnabled()
	local v104 = useIsChatEnabledFromReason("privacySettingsEnabled")
	local v105 = useIsChatEnabledFromReason("globalRulesEnabled")
	local v106 = useIsChatEnabledFromReason("thirdPartyPrivacySettingsEnabled")
	local v107 = useIsInExperience()
	local v108 = useAppChatIsWideMode(v107)

	if FFlagAppChatPerfTracking and (FFlagAppChatMessageTTIMilestones and AppChatPerfTracker.Hooks) then
		local v109 = AppChatPerfTracker.getEventName(AppChatPerfTracker.Events.ChatLandingTTI) or ""

		AppChatPerfTracker.Hooks.useTTIRenderAndMountedTracking(v109)
	end

	local v110 = useIsAppLoaded()
	local v111 = useAreConversationsFetching()
	local v112 = useHasConversations()
	local v113 = useIsOldestConversationFetched()
	local v114 = useLocalUserId()
	local v115 = useNavigation()
	local v116 = useStyle()
	local v117 = useTextSizeOffset()
	local v118 = useAnalytics2()
	local v119 = 64 + 2 * v117
	local v120 = if not FFlagCreateConnectionsHub then nil else v115.getScreenProps("navigateToLuaAppPages", {})
	local v121 = useGetConversations()
	local t6 = {}
	local t7 = {}

	if v84 then
		local v124 = useConversationList(true)

		t6 = v124.items
		t7 = v124.listStatus
	end

	local v125 = if not v84 then v121 else t6
	local v126 = if not v84 then v111 else t7.isFetchingConversations == true
	local v127 = if not v84 then v112 else #t6 > 0
	local v128 = if not v84 then v113 else t7.oldestConversationIsFetched == true

	if v84 then
		useEffect(function() -- line: 197
			-- upvalues: v121 (copy), t6 (ref), getConversationIds (copy), v25 (copy), HttpService (copy)
			if #v121 == 0 and #t6 == 0 then
				return
			end

			local v156 = getConversationIds(v121)
			local v157 = getConversationIds(t6)
			local v158, g161

			if #v156 ~= #v157 then
				v158 = false
			else
				g161 = nil
				v158 = nil

				for v159, v160 in v156 do
					if v160 ~= v157[v159] then
						v158 = false
						g161 = true
					end

					if g161 then
						break
					end
				end

				if not g161 then
					v158 = true
				end
			end

			g161 = false

			if not v158 then
				local v162 = v25
				local ok, result = pcall(function() -- line: 136
					-- upvalues: HttpService (copy), v156 (copy)
					return HttpService:JSONEncode(v156)
				end)
				local v165 = not ok and "[]" or result
				local ok2, result2 = pcall(function() -- line: 136
					-- upvalues: HttpService (copy), v157 (copy)
					return HttpService:JSONEncode(v157)
				end)

				v162:warning("Conversation list parity mismatch. Rodux ids: {}, Signals ids: {}", v165, not ok2 and "[]" or result2)
			end
		end, {
			v121,
			t6
		})
	end

	local v129 = usePrevious(v102)

	useEffect(function() -- line: 215
		-- upvalues: v25 (copy), v129 (copy), v102 (copy), v101 (copy), fetchConversationsByPage (copy)
		v25:debug("Comparing previousIsChatEnabled ({}) --> isChatEnabled ({})", v129, v102)

		if v129 ~= nil and (v129 ~= v102 and v102) then
			v25:info("Chat has become enabled, fetching conversations")
			v101(fetchConversationsByPage())
		end
	end, {
		v101,
		v102,
		v129
	})

	local v130, v131, v132 = React.useMemo(function() -- line: 231
		-- upvalues: v125 (copy), v84 (copy), Cryo (copy), getOtherParticipants (copy), v114 (copy), useIsUserPending (copy), ConversationChannels (copy), getConversationTitle (copy), v103 (copy)
		local n1 = 0
		local n2 = 0
		local t8 = {}

		for _, v172 in v125 do
			local v173 = if not v84 or v172.otherParticipants ~= nil then v172 else Cryo.Dictionary.join(v172, {
				otherParticipants = getOtherParticipants(v172, v114)
			})

			if useIsUserPending(v173) then
				n1 += 1
			end

			if v173.moderationType == ConversationChannels.ModerationType.TrustedComms then
				n2 += 1
			end

			local v174 = getConversationTitle(v173)

			if v103 or v173.conversationType ~= "MultiUserConversation" then
				table.insert(t8, Cryo.Dictionary.join(v173, {
					title = v174
				}))
			end
		end

		return t8, n1, n2
	end, {
		v125,
		v103,
		if not v84 then nil else v114
	})
	local v133 = useTelemetry(ChatLandingTelemetryLayer.Context)
	local emit = v133.emit

	if v84 then
		local v135 = React.useRef(v133.emit)

		v135.current = v133.emit

		function emit(...) -- line: 274
			-- upvalues: v135 (copy)
			v135.current(...)
		end
	end

	local v136 = ChatLandingTelemetryState.useSetState()

	useEffect(function() -- line: 280
		-- upvalues: v136 (copy), Cryo (copy), v130 (copy), v131 (copy), v132 (copy)
		v136(function(p1) -- line: 281
			-- upvalues: Cryo (copy), v130 (copy), v131 (copy), v132 (copy)
			return Cryo.Dictionary.join(p1, {
				chatLandingListCount = #v130,
				pendingConversationCount = v131,
				unfilteredConversationCount = v132
			})
		end)
	end, {
		#v130,
		v131,
		v132,
		v136
	})
	useEffectOnMount(function() -- line: 290
		-- upvalues: v133 (copy), ChatLandingTelemetryEvents (copy), v102 (copy)
		v133.emit(ChatLandingTelemetryEvents.ScreenRendered, {
			isChatEnabled = v102
		})
	end)

	local v137 = useLocalization({
		partyUnavailableWithUser = "Feature.Chat.Message.PartyUnavailableWithUser",
		networkErrorText = "Feature.Toast.NetworkingError.SomethingIsWrong"
	})
	local v138 = useCallback(function() -- line: 301
		-- upvalues: PartyPageCarouselExperimentation (copy), HttpService (copy), v99 (copy), EventNames (copy), v100 (copy), v85 (copy), v86 (copy), v115 (copy), EnumScreens (copy)
		if PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
			local guid = HttpService:GenerateGUID(false)

			v99.fireAnalyticsEvent(EventNames.ChatLandingPartyQuickStartButtonClicked, {
				clickLocation = v100.chatPlacement,
				partyAttemptId = guid,
				placeId = v85,
				universeId = v86
			})
			v115.navigate(EnumScreens.QuickStartSquadInviteFriends, {
				uuid = guid
			})
		end
	end, {
		v99,
		v100,
		v115,
		v85,
		v86
	})
	local v139 = useCallback(function(p2) -- line: 318
		-- upvalues: PartyPageCarouselExperimentation (copy), v101 (copy), createConversation (copy), v118 (copy), FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), v115 (copy), EnumScreens (copy), parseCreateConversationErrors (copy), v137 (copy), EventNames (copy), CreateConversationError (copy)
		if PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then
			v101(createConversation("one_to_one", { p2 }, v118, "navigateToConversationFromSocialCarousel")):andThen(function(p3) -- line: 332
				-- upvalues: FFlagAppChatPerfTracking (copy), AppChatPerfTracker (copy), v115 (copy), EnumScreens (copy)
				if FFlagAppChatPerfTracking then
					AppChatPerfTracker.start(AppChatPerfTracker.Events.ChatConversationTTI, {
						conversationId = p3.id
					})
				end

				v115.navigate(EnumScreens.ChatConversation, {
					conversationId = p3.id
				})
			end):catch(function(p4) -- line: 342
				-- upvalues: parseCreateConversationErrors (copy), v137 (copy), v115 (copy), EnumScreens (copy), v118 (copy), EventNames (copy), CreateConversationError (copy)
				local v185 = if parseCreateConversationErrors(p4) ~= "participant_chat_disabled" then v137.networkErrorText else v137.partyUnavailableWithUser

				v115.navigate(EnumScreens.RoactChatToast, {
					toastProps = {
						toastContent = {
							toastTitle = v185
						}
					}
				})

				if v118 then
					v118.fireAnalyticsEvent(EventNames.NewConversationCreated, {
						createConversationResult = CreateConversationError.FetchConversationError
					})
				end
			end)
		end
	end, {
		v101,
		v137,
		parseCreateConversationErrors,
		v115,
		v118
	})
	local v140 = Cryo.isEmpty(v130)
	local v141 = useSelector(function(p5) -- line: 365
		return p5.ChatAppReducer.ChatSettings.retrievalStatus ~= "Done"
	end) or (v140 and v126 or v140 and v127)
	local v142 = false
	local u143 = false
	local u144 = false
	local v145 = useIsExternalNavigationAvailable({
		EnumScreens.AddFriends,
		EnumScreens.PrivacySettings,
		EnumScreens.Groups
	})
	local v146 = FFlagAppIaScrollAway and (not v107 and AppNavBar.getScrollAwayEnabled())
	local v147 = useCanAccessParty()
	local v148 = SquadQuickStartExperimentation.getPartyQuickStartChangesEnabled() and v147
	local v149

	if v141 then
		v149 = React.createElement(ChatLoadingContainer, {
			cellWidth = 375,
			topBarHeight = v98.topBarHeight,
			pageHeaderText = v98.pageHeaderText,
			cellHeight = v119,
			topPadding = if not FFlagAppIaScrollAway or not v146 then nil else v98.topBarHeight
		})
		v142 = true
	elseif not v102 or v140 and v110 and not v126 then
		if v102 then
			v149 = React.createElement("Frame", {
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundColor3 = v116.Theme.BackgroundDefault.Color,
				BackgroundTransparency = v116.Tokens.Color.None.Transparency
			}, {
				NoFriendsView = React.createElement(NoFriendsView, {
					pageRenderReport = function() -- line: 411
						-- upvalues: v133 (copy), ChatLandingTelemetryEvents (copy), EmptyStateType (copy)
						v133.emit(ChatLandingTelemetryEvents.ChatEmptyStateScreenRendered, {
							emptyStateType = EmptyStateType.NoFriendsView
						})
					end,
					openAddFriendsPage = function() -- line: 416
						-- upvalues: v133 (copy), ChatLandingTelemetryEvents (copy), FFlagCreateConnectionsHub (copy), v120 (copy), AppPage (copy), v98 (copy)
						v133.emit(ChatLandingTelemetryEvents.ChatAddFriendsBtnClicked, {})

						if FFlagCreateConnectionsHub then
							v120[AppPage.CoHubAddConnections]()

							return
						end

						v98.navigateToAddFriends()
					end,
					noFriendsHeaderKey = not FFlagConnectionsToFriendsRename and "Feature.Chat.Label.AddConnections" or "Feature.Chat.Label.AddFriends",
					noFriendsTextLabelKey = not FFlagConnectionsToFriendsRename and "Feature.Chat.Text.NoConnections" or "Feature.Chat.Text.NoFriends",
					addFriendsBtnLabelKey = not FFlagConnectionsToFriendsRename and "Feature.Chat.Label.AddConnections" or "Feature.Chat.Label.AddFriends",
					addFriendsBtnEnabled = v145[EnumScreens.AddFriends]
				})
			})
			v142 = true
		else
			v149 = React.createElement(NoConversationsLanding, {
				chatEnabled = v102,
				privacySettingsEnabled = v104,
				globalRulesEnabled = v105,
				thirdPartyPrivacySettingsEnabled = v106,
				canNavigateToPrivacySettings = v145[EnumScreens.PrivacySettings],
				canNavigateToAddFriends = v145[EnumScreens.AddFriends],
				onCallToAction = function(p6) -- line: 446
					-- upvalues: v98 (copy), v133 (copy), ChatLandingTelemetryEvents (copy), FFlagCreateConnectionsHub (copy), v120 (copy), AppPage (copy)
					if p6 == "privacy" then
						v98.navigateToPrivacy()

						return
					end

					if p6 == "friends" then
						v133.emit(ChatLandingTelemetryEvents.ChatAddFriendsBtnClicked, {})

						if FFlagCreateConnectionsHub then
							v120[AppPage.CoHubAddConnections]()

							return
						end

						v98.navigateToAddFriends()
					end
				end,
				fireRenderEvent = function(p7) -- line: 458
					-- upvalues: EmptyStateType (copy), v133 (copy), ChatLandingTelemetryEvents (copy)
					local v180 = if p7 ~= "friends" then if p7 ~= "privacy" then if p7 ~= "regional" then EmptyStateType.EmptyConversationList else EmptyStateType.ChatUnavailableRegionView else EmptyStateType.ChatSettingsDisabledView else EmptyStateType.NoFriendsView

					v133.emit(ChatLandingTelemetryEvents.ChatEmptyStateScreenRendered, {
						emptyStateType = v180
					})
				end
			})
		end
	else
		local v150 = `conversationListWithTopBar{ v98.filterText }`

		v142 = true
		u143 = true
		u144 = true
		v149 = React.createElement(ConversationListWithTopBar, Cryo.Dictionary.join(v98, {
			filterText = v98.isShowingFilterBox and v98.filterText or nil,
			key = v150,
			itemList = v130,
			appLoaded = v110,
			localUserId = v114,
			conversationsIsFetching = v126,
			oldestConversationIsFetched = v128,
			entryHeight = v119,
			isInExperience = v107,
			isWideMode = if not PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() and not FFlagAppChatUseNewConversationRow then nil else v108,
			navigateToConversationFromUserId = if not PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then nil else v139,
			navigateToQuickStartSquadInviteFriends = if not PartyPageCarouselExperimentation.getPartyPageCarouselEnabled() then nil else v138,
			showGroupsLink = v145[EnumScreens.Groups],
			canvasTopPadding = if not FFlagAppIaScrollAway or not v146 then nil else v98.topBarHeight,
			canAccessParty = v147,
			isPartyQuickStartEnabled = v148
		}))
	end

	if FFlagAppIaScrollAway and FFlagEnableScrollAwayContentScrollableFix then
		useEffect(function() -- line: 513
			-- upvalues: v146 (copy), VisibilityControl (copy), u144 (ref)
			if not v146 then
				return
			end

			VisibilityControl.setContentScrollable(u144)
		end, {
			u144,
			v146
		})
	end

	if getFFlagChatTabHideGroupsLinkOnVR() and IsVRAppBuild() then
		v142 = true
	end

	if FFlagAppChatTopBarSignalsStore then
		useEffect(function() -- line: 527
			-- upvalues: v107 (copy), GetTopBarStore (copy), EnumScreens (copy), u143 (ref)
			if v107 then
				GetTopBarStore(false).setScreenTopBar(EnumScreens.ChatLanding, {
					rightHidden = not u143
				})
			end
		end, {
			u143,
			v107
		})
	else
		local v151 = v115.getScreenProps("setScreenTopBar", function() -- line: 535
		end)

		useEffect(function() -- line: 536
			-- upvalues: v107 (copy), v151 (copy), EnumScreens (copy), u143 (ref)
			if v107 then
				v151(EnumScreens.ChatLanding, {
					rightHidden = not u143
				})
			end
		end, {
			u143,
			v151,
			v107
		})
	end

	local v152 = if not (not v142 and v145[EnumScreens.Groups]) then v149 else React.createElement(React.Fragment, nil, {
		UIPadding = if not FFlagAppIaScrollAway or not v146 then nil else React.createElement("UIPadding", {
			PaddingTop = UDim.new(0, v98.topBarHeight)
		}),
		groupsLink = React.createElement(ConversationGroupsEntryContainer, {
			entryHeight = v119
		}),
		chatFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, -v119),
			Position = UDim2.new(0, 0, 0, v119)
		}, {
			chatContainer = v149
		})
	})
	local v153 = useChatIsVisible()

	React.useEffect(function() -- line: 577
		-- upvalues: v153 (copy), emit (ref), ChatLandingTelemetryEvents (copy), v102 (copy), v141 (copy)
		if v153 then
			emit(ChatLandingTelemetryEvents.AppChatVisible, {
				isChatEnabled = v102,
				isChatLoading = v141
			})
		end
	end, {
		v153,
		v102,
		v141
	})

	if FFlagAppChatPerfTracking then
		React.useEffect(function() -- line: 587
			-- upvalues: v153 (copy), v141 (copy), v102 (copy), v25 (copy), v130 (copy), AppChatPerfTracker (copy)
			if not v153 then
				return
			end

			local v181 = not v141 and v102

			v25:debug("TTI Ready Check (ChatLanding): isLoading={}, isChatEnabled={}, itemCount={}, ready={}", v141, v102, #v130, v181)

			if v181 and AppChatPerfTracker.isActive(AppChatPerfTracker.Events.ChatLandingTTI) then
				AppChatPerfTracker.finish(AppChatPerfTracker.Events.ChatLandingTTI, {
					numElementsRendered = #v130
				})
			end
		end, {
			v153,
			v141,
			v102,
			#v130
		})
	end

	local v154 = React.useRef({
		isChatEnabled = v102,
		isChatLoading = v141
	})

	React.useEffect(function() -- line: 611
		-- upvalues: v154 (copy), v102 (copy), v141 (copy)
		v154.current = {
			isChatEnabled = v102,
			isChatLoading = v141
		}
	end, {
		v102,
		v141
	})
	useEffect(function() -- line: 620
		-- upvalues: v153 (copy), emit (ref), ChatLandingTelemetryEvents (copy), v154 (copy)
		return function() -- line: 621
			-- upvalues: v153 (copy), emit (ref), ChatLandingTelemetryEvents (copy), v154 (copy)
			if v153 then
				emit(ChatLandingTelemetryEvents.AppChatClosed, v154.current)
			end
		end
	end, { v153 })

	if FFlagSignalsNavP3hMisc then
		local v155 = React.useRef(nil)

		if v153 or v155.current == nil then
			v155.current = v152
		end

		return v155.current
	end

	return v152
end

return compose(RoactRodux.connect(nil, mapDispatchToProps), RoactPaginator.connect(function() -- line: 645
	return {
		pageSize = 30
	}
end))(ChatLandingContainer)
