local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local RoactNavigation = require(SquadsParent.RoactNavigation)
local UIBlox = require(SquadsParent.UIBlox)
local useLocalUserId = require(SquadsParent.RobloxAppHooks).useLocalUserId
local useVoiceStatus = require(SquadsParent.CrossExperienceVoice).Hooks.useVoiceStatus
local Constants = require(Squads.Common.Constants)
local dependencies = require(Squads.dependencies)
local Logger = require(Squads.Logger)

require(Squads.Common.ModelTypes)

local SquadLobbyActionBar = require(script.Parent.SquadLobbyActionBar)
local SquadLobbyUserGrid = require(script.Parent.SquadLobbyUserGrid)
local SquadLobbyRegroupRow = require(script.Parent.SquadLobbyRegroupRow)
local SquadLobbyLuckyRecommendationRow = require(script.Parent.SquadLobbyLuckyRecommendationRow)
local SquadLobbyVoiceChatMenu = require(script.Parent.SquadLobbyVoiceChatMenu)
local SquadLobbyBanners = require(script.Parent.SquadLobbyBanners)
local SquadLobbyUserDropdownMenu = require(script.Parent.SquadLobbyUserDropdownMenu)
local SquadPartySheetActionEnum = require(Squads.Enums.SquadPartySheetActionEnum)
local SquadUserPartyStatus = require(Squads.Enums.SquadUserPartyStatus)
local Cryo = dependencies.Cryo
local Foundation = dependencies.Foundation
local LuauPolyfill = dependencies.LuauPolyfill
local NetworkingPresence = dependencies.NetworkingPresence
local NetworkingSquads = dependencies.NetworkingSquads
local React = dependencies.React
local Roact = dependencies.Roact
local SharedFlags = dependencies.SharedFlags
local Enums = require(SquadsParent.SquadsCore.Enums)
local EventNames = require(SquadsParent.SquadsCore.EventNames)
local SquadExternalContractContext = require(SquadsParent.SquadsCore.SquadExternalContractProvider).SquadExternalContractContext
local SquadPromptType = Enums.SquadPromptType
local SquadCoplayJoin = Enums.SquadCoplayJoin
local SquadViewFlags = require(SquadsParent.SquadsCore.SquadExternalContractProvider).SquadViewFlags
local SquadLobbySessionProvider = require(SquadsParent.SquadsCore.SquadSessionProvider).SquadLobbySessionProvider
local logInExpCoplayTelemetry = require(SquadsParent.SquadsCore.logInExpCoplayTelemetry)
local createOrJoinSquad = require(SquadsParent.SquadsCore.Thunks).createOrJoinSquad
local UserBlockingNetworking = dependencies.UserBlockingNetworking
local useCurrentSquadSelector = dependencies.Hooks.useCurrentSquadSelector
local useDispatch = dependencies.Hooks.useDispatch
local useEffectOnce = dependencies.Hooks.useEffectOnce
local useNavigation = dependencies.useNavigation
local usePrevious = dependencies.Hooks.usePrevious
local useSelector = dependencies.Hooks.useSelector
local useStore = dependencies.Hooks.useStore
local useSquadState = require(SquadsParent.SquadsCore.Hooks).useSquadState
local PresenceType = dependencies.RoduxPresence.Enums.PresenceType
local FFlagSquadsPresenceStoreMigration = require(SquadsParent.SquadsCore.Flags).FFlagSquadsPresenceStoreMigration
local DataHydration = require(SquadsParent.DataHydration)
local Signals = require(SquadsParent.Signals)
local useSignalState = require(SquadsParent.SignalsReact).useSignalState
local v52 = if not FFlagSquadsPresenceStoreMigration then nil else DataHydration.Presence.PresenceStore.get()
local v53 = if not FFlagSquadsPresenceStoreMigration then nil else DataHydration.Presence.PresenceEnums.PresenceType
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useStyle = UIBlox.Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local clearInterval = LuauPolyfill.clearInterval
local setInterval = LuauPolyfill.setInterval
local v59 = game:DefineFastFlag("EnableSquadLobbyBanners", false)
local FFlagEnableSquadCoplayAnalytic = SharedFlags.FFlagEnableSquadCoplayAnalytic
local FFlagEnableSquadTopBannerWideMode = SharedFlags.FFlagEnableSquadTopBannerWideMode
local FFlagMakeCreateOrJoinSquadAThunks = SharedFlags.FFlagMakeCreateOrJoinSquadAThunks
local v63 = game:DefineFastInt("PartyInviteeNoResponseDurationSeconds", 3)
local v64 = game:DefineFastInt("PartyUserInvitedDurationSeconds", 10)
local SquadQuickStartExperimentation = dependencies.SocialExperiments.SquadQuickStartExperimentation
local SquadCoordinationExperienceJoinExperimentation = dependencies.SocialExperiments.SquadCoordinationExperienceJoinExperimentation
local SquadRegroupExperimentation = dependencies.SocialExperiments.SquadRegroupExperimentation
local LuckyRecommendationExperimentation = dependencies.SocialExperiments.LuckyRecommendationExperimentation
local FFlagEnablePartyQuickStartButton = SharedFlags.FFlagEnablePartyQuickStartButton
local FFlagEnablePartyVoiceChangersInLua = SharedFlags.FFlagEnablePartyVoiceChangersInLua
local FFlagEnableSquadRegroupExperimentation = SharedFlags.FFlagEnableSquadRegroupExperimentation
local FFlagEnableSquadRegroupExperimentationSmallScreenFix = SharedFlags.FFlagEnableSquadRegroupExperimentationSmallScreenFix
local FFlagEnableSquadRegroupServerCapacityCheck = SharedFlags.FFlagEnableSquadRegroupServerCapacityCheck
local FFlagAppChatShowOSAOnPageEntry = SharedFlags.FFlagAppChatShowOSAOnPageEntry

local function SquadLobby(t1: {[any]: any}) -- line: 110
	-- upvalues: useTokens (copy), useDispatch (copy), useLocalUserId (copy), useStyle (copy), useSquadState (copy), useNavigation (copy), React (copy), SquadExternalContractContext (copy), useVoiceStatus (copy), FFlagEnableSquadTopBannerWideMode (copy), HttpService (copy), RoactNavigation (copy), SquadViewFlags (copy), useCurrentSquadSelector (copy), useSelector (copy), useStore (copy), SquadQuickStartExperimentation (copy), FFlagEnablePartyQuickStartButton (copy), SquadPromptType (copy), FFlagMakeCreateOrJoinSquadAThunks (copy), createOrJoinSquad (copy), NetworkingSquads (copy), FFlagEnableSquadCoplayAnalytic (copy), logInExpCoplayTelemetry (copy), SquadCoplayJoin (copy), useEffectOnce (copy), FFlagAppChatShowOSAOnPageEntry (copy), Logger (copy), Cryo (copy), SquadUserPartyStatus (copy), v64 (copy), v63 (copy), setInterval (copy), clearInterval (copy), usePrevious (copy), UserBlockingNetworking (copy), FFlagSquadsPresenceStoreMigration (copy), NetworkingPresence (copy), Constants (copy), Signals (copy), v52 (copy), useSignalState (copy), FFlagEnableSquadRegroupServerCapacityCheck (copy), Players (copy), SquadRegroupExperimentation (copy), v53 (copy), PresenceType (copy), LuckyRecommendationExperimentation (copy), FFlagEnableSquadRegroupExperimentationSmallScreenFix (copy), v59 (copy), SquadLobbyBanners (copy), Foundation (copy), SquadLobbyUserGrid (copy), EventNames (copy), SquadPartySheetActionEnum (copy), SquadLobbyRegroupRow (copy), SquadLobbyActionBar (copy), SquadLobbyLuckyRecommendationRow (copy), StateLayerAffordance (copy), SquadLobbyVoiceChatMenu (copy), FFlagEnablePartyVoiceChangersInLua (copy), SquadLobbyUserDropdownMenu (copy), SquadCoordinationExperienceJoinExperimentation (copy), FFlagEnableSquadRegroupExperimentation (copy), Roact (copy), SquadLobbySessionProvider (copy)
	local v77 = useTokens()
	local v78 = useDispatch()
	local v79 = tonumber(useLocalUserId()) or 0
	local v80 = useStyle()
	local v81 = useSquadState()
	local v82 = useNavigation()
	local isWideMode = t1.isWideMode
	local v84 = React.useContext(SquadExternalContractContext)
	local v85, v86 = React.useState(0)
	local v87 = useVoiceStatus()

	if FFlagEnableSquadTopBannerWideMode then
		local v88 = React.useRef(HttpService:GenerateGUID())

		React.useEffect(function() -- line: 125
			-- upvalues: isWideMode (copy), v88 (copy), v84 (copy), v82 (copy), RoactNavigation (copy)
			if not isWideMode then
				local current = v88.current

				v84.disableSquadTopBanner(current, true)

				local u145 = v82 and v82.addListener(RoactNavigation.Events.WillBlur, function(p1) -- line: 130
					-- upvalues: v84 (copy), current (copy)
					if p1.state.routeName ~= "SquadInviteFriends" and p1.state.routeName ~= "SquadLobby" then
						v84.disableSquadTopBanner(current, false)

						return
					end

					v84.disableSquadTopBanner(current, true)
				end)

				return function() -- line: 141
					-- upvalues: u145 (ref), v84 (copy), current (copy)
					if u145 then
						u145.remove()
						u145 = nil
					end

					v84.disableSquadTopBanner(current, false)
				end
			end

			return function() -- line: 151
			end
		end, {
			v84.disableSquadTopBanner,
			v82,
			isWideMode
		})
		React.useEffect(function() -- line: 154
			-- upvalues: v84 (copy), SquadViewFlags (copy)
			v84.updateSquadViewFlags(SquadViewFlags.SquadLobby, true)

			return function() -- line: 156
				-- upvalues: v84 (copy), SquadViewFlags (copy)
				v84.updateSquadViewFlags(SquadViewFlags.SquadLobby, false)
			end
		end, { v84.updateSquadViewFlags })
	else
		React.useEffect(function() -- line: 164
			-- upvalues: v84 (copy), SquadViewFlags (copy), v82 (copy), RoactNavigation (copy)
			v84.updateSquadViewFlags(SquadViewFlags.SquadLobby, true)

			local u146 = v82 and v82.addListener(RoactNavigation.Events.WillBlur, function(p2) -- line: 167
				-- upvalues: v84 (copy), SquadViewFlags (copy)
				if p2.state.routeName ~= "SquadInviteFriends" and p2.state.routeName ~= "SquadLobby" then
					v84.updateSquadViewFlags(SquadViewFlags.SquadLobby, false)

					return
				end

				v84.updateSquadViewFlags(SquadViewFlags.SquadLobby, true)
			end)

			return function() -- line: 174
				-- upvalues: u146 (ref), v84 (copy), SquadViewFlags (copy)
				if u146 then
					u146.remove()
					u146 = nil
				end

				v84.updateSquadViewFlags(SquadViewFlags.SquadLobby, false)
			end
		end, {
			v84.updateSquadViewFlags,
			v82
		})
	end

	local v89, v90 = React.useState(false)
	local v91, v92 = React.useState(Vector2.zero)
	local v93 = React.useCallback(function(p3) -- line: 186
		-- upvalues: v92 (copy)
		v92(p3.AbsoluteSize)
	end, { v92 })
	local v94 = useCurrentSquadSelector()
	local v95 = not v94 and "" or v94.squadId
	local v96 = v94 and v94.members
	local v97 = React.useCallback(function(p4) -- line: 194
		if p4.Squad and (p4.Squad.Squad and p4.Squad.Squad.currentSquad) then
			return p4.Squad.Squad.currentSquad.parentChannelId or ""
		end

		return ""
	end, {})
	local v98 = useSelector(v97)
	local v99 = useStore()
	local v100 = v82.getParam("conversationId") or ""
	local v101 = v84.useGetConversationFromId(v100)
	local v102 = v101 and v101.participants
	local v103 = v94 and v94.invitees
	local squadCreateOrJoinAttemptId = nil
	local v105 = v82.getParam("extraParams") or {}
	local squadId = v105.squadId

	if SquadQuickStartExperimentation.getPartyQuickStartChangesEnabled() and FFlagEnablePartyQuickStartButton then
		squadCreateOrJoinAttemptId = v105.squadCreateOrJoinAttemptId
	end

	local scheduledGroupUpId = v105.scheduledGroupUpId
	local v108 = React.useCallback(function() -- line: 218
		-- upvalues: v84 (copy), v99 (copy), SquadPromptType (copy), t1 (copy)
		v84.setSquadPrompt(v99, {
			hideCancelButton = true,
			promptType = SquadPromptType.Error,
			onConfirm = function() -- line: 222
				-- upvalues: t1 (copy)
				t1.navigateAwayFromSquad()
			end
		})
	end, {
		t1.navigateAwayFromSquad,
		v99,
		v84.setSquadPrompt
	})
	local v109 = React.useCallback(function(s1: string) -- line: 228
		-- upvalues: FFlagMakeCreateOrJoinSquadAThunks (copy), v78 (copy), createOrJoinSquad (copy), v84 (copy), squadCreateOrJoinAttemptId (ref), t1 (copy), scheduledGroupUpId (copy), NetworkingSquads (copy), FFlagEnableSquadCoplayAnalytic (copy), logInExpCoplayTelemetry (copy), SquadCoplayJoin (copy), v108 (copy)
		if FFlagMakeCreateOrJoinSquadAThunks then
			v78(createOrJoinSquad(s1, v84.setSquadPrompt, v84.fireSquadAnalytics, v84.squadLocation, squadCreateOrJoinAttemptId, t1.navigateAwayFromSquad, scheduledGroupUpId))

			return
		end

		local v150 = v78(NetworkingSquads.CreateOrJoinSquad.API({
			leaveExisting = true,
			parentChannelId = s1,
			squadLocation = if not FFlagEnableSquadCoplayAnalytic then nil else v84.squadLocation,
			partyAttemptId = squadCreateOrJoinAttemptId
		}))

		if FFlagEnableSquadCoplayAnalytic then
			v150 = v150:andThen(function(p5) -- line: 252
				-- upvalues: logInExpCoplayTelemetry (copy), v84 (copy), SquadCoplayJoin (copy)
				local groupUpId = p5.responseBody.groupUp.groupUpId
				local members = p5.responseBody.groupUp.members

				if groupUpId and members then
					logInExpCoplayTelemetry(groupUpId, members, v84.squadLocation, SquadCoplayJoin.PartyJoin, v84.fireSquadAnalytics)
				end
			end)
		end

		v150:catch(function(_) -- line: 268
			-- upvalues: v108 (copy)
			v108()
		end)
	end, {
		v78,
		if not FFlagMakeCreateOrJoinSquadAThunks then nil else createOrJoinSquad,
		if not FFlagMakeCreateOrJoinSquadAThunks then nil else t1.navigateAwayFromSquad,
		if FFlagMakeCreateOrJoinSquadAThunks then nil else v108,
		if not FFlagMakeCreateOrJoinSquadAThunks then nil else v84.setSquadPrompt,
		v84.squadLocation,
		v84.fireSquadAnalytics,
		squadCreateOrJoinAttemptId,
		scheduledGroupUpId
	})
	local v110 = squadId and squadId ~= v95

	React.useEffect(function() -- line: 287
		-- upvalues: v110 (copy), v84 (copy), v99 (copy), SquadPromptType (copy), v109 (copy), v100 (copy), t1 (copy), v82 (copy)
		if v110 then
			v84.setSquadPrompt(v99, {
				promptType = SquadPromptType.JoinAnotherSquad,
				onConfirm = function() -- line: 291
					-- upvalues: v109 (copy), v100 (copy)
					v109(v100)
				end,
				onCancel = function() -- line: 294
					-- upvalues: t1 (copy)
					t1.navigateAwayFromSquad()
				end
			})
			v82.setParams({
				squadId = nil
			})
		end
	end, {
		squadId,
		v84.setSquadPrompt,
		v109,
		v100,
		t1.navigateAwayFromSquad,
		v110
	})
	useEffectOnce(function() -- line: 313
		-- upvalues: v110 (copy), FFlagAppChatShowOSAOnPageEntry (copy), v84 (copy), v101 (copy), t1 (copy), v95 (copy), Logger (copy), v100 (copy), v78 (copy), v109 (copy), v108 (copy)
		if v110 then
			return
		end

		if FFlagAppChatShowOSAOnPageEntry and v84.shouldShowOSAForConversation and v84.shouldShowOSAForConversation(v101) then
			t1.navigateAwayFromSquad()

			return
		end

		if v95 == "" then
			if v101 and v101.source == "friends" then
				Logger:debug("Channel does not exist for: {}. Creating a friend conversation.", v100)
				v78(v84.createFriendConversation(v100)):andThen(function(p7) -- line: 337
					-- upvalues: v109 (copy)
					if p7 and p7.id then
						v109(p7.id)
					end
				end):catch(function(p8) -- line: 342
					-- upvalues: Logger (copy), v108 (copy)
					Logger:debug("Error while trying to create a friend conversation: {}", p8)
					v108()
				end)

				return
			end

			v109(v100)
		end
	end, {
		v78,
		v84.createFriendConversation,
		v100,
		v101,
		v109,
		v108
	})

	local v111, v112 = React.useState({})
	local v113 = React.useMemo(function() -- line: 362
		-- upvalues: v96 (copy)
		local t2 = {}

		if v96 then
			for _, v in ipairs(v96) do
				t2[tostring(v.userId)] = true
			end
		end

		return t2
	end, { v96 })
	local v114 = React.useCallback(function(p9, p10, p11) -- line: 383
		-- upvalues: Cryo (copy), v79 (copy), SquadUserPartyStatus (copy), v64 (copy), v63 (copy)
		local t3 = {}
		local n1 = 0

		if p10 and #Cryo.Dictionary.keys(p10) == 0 then
			table.insert(t3, {
				userId = v79,
				partyStatus = SquadUserPartyStatus.Connecting
			})
		elseif p9 then
			local timestamp = os.time()

			for _, v in ipairs(p9) do
				local Inactive = SquadUserPartyStatus.Inactive

				if p10[v] then
					Inactive = SquadUserPartyStatus.Active
				else
					local v163 = p11 and Cryo.List.findWhere(p11, function(p12) -- line: 408
						-- upvalues: v (copy)
						return v == tostring(p12.userId)
					end)

					if v163 then
						local v164 = math.floor(p11[v163].invitedAtTimestampMs / 1000) or 0

						if timestamp < v164 then
							continue
						end

						if timestamp - v164 < v64 then
							Inactive = SquadUserPartyStatus.Invited
							n1 += 1
						elseif timestamp - v164 < v63 + v64 then
							Inactive = SquadUserPartyStatus.NoResponse
							n1 += 1
						end
					end
				end

				table.insert(t3, {
					userId = tonumber(v),
					partyStatus = Inactive
				})
			end
		end

		return {
			users = t3,
			numberOfUpdatesPending = n1
		}
	end, {})

	React.useEffect(function() -- line: 452
		-- upvalues: v114 (copy), v102 (copy), v113 (copy), v103 (copy), v112 (copy), setInterval (copy), clearInterval (copy)
		local v165 = v114(v102, v113, v103)

		v112(v165.users)

		local u166 = nil

		u166 = setInterval(function() -- line: 458
			-- upvalues: v114 (copy), v102 (copy), v113 (copy), v103 (copy), v112 (copy), clearInterval (copy), u166 (ref)
			local v193 = v114(v102, v113, v103)

			v112(v193.users)

			if v193.numberOfUpdatesPending == 0 then
				clearInterval(u166)
			end
		end, 1000)

		return function() -- line: 467
			-- upvalues: clearInterval (copy), u166 (ref)
			clearInterval(u166)
		end
	end, {
		v113,
		v103,
		v102,
		v114
	})

	local v115 = usePrevious(v95) or ""

	React.useEffect(function() -- line: 474
		-- upvalues: v115 (copy), v95 (copy), t1 (copy), v100 (copy), v98 (copy), RoactNavigation (copy), isWideMode (copy), v82 (copy)
		if v115 ~= "" and v95 == "" then
			t1.navigateAwayFromSquad()

			return
		end

		if v95 ~= "" and v100 ~= "" and v98 ~= "" and v98 ~= v100 then
			local t4 = {
				RoactNavigation.Actions.navigate({
					routeName = "ChatConversation",
					params = {
						conversationId = v98
					}
				}),
				RoactNavigation.Actions.navigate({
					routeName = "SquadLobby",
					params = {
						conversationId = v98
					}
				})
			}

			if isWideMode then
				v82.navigate("ChatLanding", {
					conversationId = v98
				}, RoactNavigation.StackActions.reset({
					index = 2,
					actions = t4
				}))

				return
			end

			table.insert(t4, 1, RoactNavigation.Actions.navigate({
				routeName = "ChatLanding"
			}))
			v82.navigate("ChatLandingStack", {
				conversationId = v98
			}, RoactNavigation.StackActions.reset({
				index = 3,
				actions = t4
			}))
		end
	end, {
		v82,
		v98,
		v100,
		v95,
		t1.navigateAwayFromSquad
	})

	local v116 = usePrevious(v96)

	React.useEffect(function() -- line: 538
		-- upvalues: v96 (copy), v116 (copy), v79 (copy), v78 (copy), UserBlockingNetworking (copy), FFlagSquadsPresenceStoreMigration (copy), NetworkingPresence (copy)
		local t5 = {}

		if v96 then
			for _, v in pairs(v96) do
				local v171 = false

				if v116 then
					for _, v2 in pairs(v116) do
						if v2.userId == v.userId then
							v171 = true

							break
						end
					end
				end

				if not v171 then
					table.insert(t5, v.userId)

					if v79 ~= v.userId then
						v78(UserBlockingNetworking.IsBlockedById.API({
							userId = v.userId,
							currentUserId = v79
						}))
					end
				end
			end
		end

		if not FFlagSquadsPresenceStoreMigration then
			v78(NetworkingPresence.GetPresencesFromUserIds.API(t5))
		end
	end, {
		v96,
		v79,
		v116
	})

	local v117 = React.useCallback(function() -- line: 572
		-- upvalues: v90 (copy), v89 (copy)
		v90(not v89)
	end, {
		v89,
		v90
	})
	local v118 = Constants.SQUAD_LOBBY_ACTION_BAR_HEIGHT + 26 + 20
	local v119 = Constants.SQUAD_LOBBY_ACTION_BAR_HEIGHT + 20
	local v120, v121 = React.useState(nil)
	local v122, v123 = React.useState(false)
	local v124 = React.useCallback(function(vector2: Vector2) -- line: 584
		-- upvalues: v86 (copy), v77 (copy)
		if vector2.Y > 0 then
			v86(vector2.Y + v77.Gap.Medium)

			return
		end

		v86(0)
	end, {
		v86,
		v77
	})
	local v125 = React.useCallback(function(p13) -- line: 592
		-- upvalues: v96 (copy)
		local v176 = p13.Squad and (not not p13.Squad.Presence and p13.Squad.Presence.byUserId) or {}
		local t6 = {}

		for _, v in ipairs(v96 or {}) do
			local str = tostring(v.userId)

			t6[str] = v176[str]
		end

		return t6
	end, { v96 })
	local v126 = if not FFlagSquadsPresenceStoreMigration then nil else React.useMemo(function() -- line: 605
		-- upvalues: Signals (copy), v96 (copy), v52 (copy)
		return Signals.createComputed(function(p14) -- line: 606
			-- upvalues: v96 (copy), v52 (copy)
			local t7 = {}

			for _, v in ipairs(v96 or {}) do
				local str = tostring(v.userId)

				t7[str] = v52.GetPresenceByUserId(str).data(p14)
			end

			return t7
		end)
	end, { v96 })
	local v127 = if not FFlagSquadsPresenceStoreMigration then useSelector(v125) else useSignalState(v126)
	local v128 = not FFlagEnableSquadRegroupServerCapacityCheck or Players.MaxPlayers > 1
	local v129 = React.useMemo(function() -- line: 624
		-- upvalues: SquadRegroupExperimentation (copy), t1 (copy), v128 (copy), v94 (copy), v127 (copy), v79 (copy), FFlagSquadsPresenceStoreMigration (copy), v53 (copy), PresenceType (copy)
		if not SquadRegroupExperimentation.getSquadRegroupEnabled() or (not t1.isInExperience or not v128 or not v94 or not v94.members or not (#v94.members > 1) or not v94.selfPermissions or not v94.selfPermissions.canSeeRegroupJoinButton) then
			return false
		end

		local v181 = v127[tostring(v79)]

		if v181 == nil then
			return false
		end

		for k, v in pairs(v127) do
			if v ~= nil and k ~= tostring(v79) and (v.userPresenceType == (if not FFlagSquadsPresenceStoreMigration then PresenceType.Online else v53.Online) or v.userPresenceType == (if not FFlagSquadsPresenceStoreMigration then PresenceType.InGame else v53.InGame) and v181.gameId ~= (if not FFlagSquadsPresenceStoreMigration then nil else "") and v.gameId ~= (if not FFlagSquadsPresenceStoreMigration then nil else "") and v181.gameId ~= v.gameId) then
				return true
			end
		end

		return false
	end, {
		v127,
		v79,
		t1.isInExperience,
		v94,
		v128
	})
	local u130 = false

	if LuckyRecommendationExperimentation.getLuckyRecommendationEnabled() then
		local v131 = v96 ~= nil and #v96 >= 2

		u130 = not t1.isInExperience and v131
	end

	local v132 = v77.Size.Size_1000 + v77.Padding.Medium * 2
	local v133 = FFlagEnableSquadRegroupExperimentationSmallScreenFix and v129
	local v134 = not (not not v129 and not v133) and not u130 and 0 or v77.Gap.XXLarge + v132
	local v135 = React.useMemo(function() -- line: 695
		-- upvalues: v59 (copy), React (copy), SquadLobbyBanners (copy), v124 (copy)
		if v59 then
			return (React.createElement(SquadLobbyBanners, {
				onAbsoluteSizeChanged = v124
			}))
		end

		return nil
	end, { v124 })
	local v136 = React.useCallback(function() -- line: 703
		-- upvalues: t1 (copy), v98 (copy)
		t1.navigateToSquadInviteFriends(v98)
	end, {
		v98,
		t1.navigateToSquadInviteFriends
	})
	local v137 = React.useMemo(function() -- line: 708
		-- upvalues: React (copy), v85 (copy), v134 (copy), v80 (copy), v93 (copy), v133 (copy), Foundation (copy), SquadLobbyUserGrid (copy), v91 (copy), v118 (copy), v77 (copy), v132 (copy), v111 (copy), t1 (copy), v84 (copy), EventNames (copy), v98 (copy), SquadPartySheetActionEnum (copy), v87 (copy), v121 (copy), v123 (copy), v136 (copy), SquadLobbyRegroupRow (copy), v79 (copy)
		return React.createElement("ScrollingFrame", {
			Position = UDim2.fromOffset(0, v85),
			Size = UDim2.new(1, 0, 1, -(v85 + v134)),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollBarImageColor3 = v80.Theme.UIEmphasis.Color,
			ScrollBarImageTransparency = v80.Theme.UIEmphasis.Transparency,
			ScrollBarThickness = 4,
			Selectable = false,
			ZIndex = 0,
			[React.Change.AbsoluteSize] = v93
		}, {
			FrameContents = if not v133 then nil else React.createElement(Foundation.View, {
				tag = "auto-y size-full-0 bg-surface-0 col align-x-center align-y-top"
			}, {
				UserGridContainer = React.createElement(Foundation.View, {
					tag = "auto-y size-full-0 bg-surface-0",
					LayoutOrder = 1
				}, {
					SquadLobbyUserGrid = React.createElement(SquadLobbyUserGrid, {
						containerSize = v91 - Vector2.new(0, v118 + v77.Gap.Medium + v132),
						paddingBottom = UDim.new(0, 0),
						users = v111,
						isInExperience = t1.isInExperience,
						onUserCardActivated = function(s2: string) -- line: 738
							-- upvalues: v84 (copy), EventNames (copy), v98 (copy), SquadPartySheetActionEnum (copy), v87 (copy), v121 (copy), v123 (copy)
							v84.fireSquadAnalytics(EventNames.PartySheetAction, {
								parentChannelId = v98,
								actionType = SquadPartySheetActionEnum.UserCardClicked,
								voiceStatus = v87
							})
							v121(s2)
							v123(true)
						end,
						navigateToHomePage = t1.navigateToHomePage,
						navigateToSquadInviteFriends = v136
					})
				}),
				RegroupRowSpacer = React.createElement(Foundation.View, {
					tag = "bg-surface-0",
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, v77.Gap.Medium)
				}),
				SquadLobbyRegroupRow = React.createElement(Foundation.View, {
					tag = "bg-surface-0",
					LayoutOrder = 3,
					Size = UDim2.new(1, 0, 0, v132)
				}, {
					Row = React.createElement(SquadLobbyRegroupRow, {
						localUserId = v79
					})
				}),
				BottomPadding = React.createElement(Foundation.View, {
					tag = "bg-surface-0",
					LayoutOrder = 4,
					Size = UDim2.new(1, 0, 0, v118)
				})
			}),
			SquadLobbyUserGrid = if not v133 then React.createElement(SquadLobbyUserGrid, {
				containerSize = v91 - Vector2.new(0, v118),
				paddingBottom = UDim.new(0, v118),
				users = v111,
				isInExperience = t1.isInExperience,
				onUserCardActivated = function(s3: string) -- line: 780
					-- upvalues: v84 (copy), EventNames (copy), v98 (copy), SquadPartySheetActionEnum (copy), v87 (copy), v121 (copy), v123 (copy)
					v84.fireSquadAnalytics(EventNames.PartySheetAction, {
						parentChannelId = v98,
						actionType = SquadPartySheetActionEnum.UserCardClicked,
						voiceStatus = v87
					})
					v121(s3)
					v123(true)
				end,
				navigateToHomePage = t1.navigateToHomePage,
				navigateToSquadInviteFriends = v136
			}) else nil
		})
	end, {
		v121,
		v123,
		v91,
		v96,
		v136,
		v93,
		t1.navigateToHomePage,
		v118,
		v85,
		if not v129 and not u130 then nil else v134,
		v111,
		v133,
		if not v133 then nil else v132,
		if not v133 then nil else v79,
		v87
	})
	local v138 = React.useMemo(function() -- line: 811
		-- upvalues: React (copy), SquadLobbyActionBar (copy), v81 (copy), v101 (copy), t1 (copy), v117 (copy), v95 (copy)
		return React.createElement(SquadLobbyActionBar, {
			squadState = v81,
			anchorPoint = Vector2.new(0.5, 1),
			hasUnreadMessages = not not v101 and (not not v101.hasUnreadMessages and v101.hasUnreadMessages),
			navigateAwayFromSquad = t1.navigateAwayFromSquad,
			navigateToHomePage = t1.navigateToHomePage,
			toggleVoiceChatMenu = v117,
			position = UDim2.new(0.5, 0, 1, -20),
			squadId = v95,
			isInExperience = t1.isInExperience
		})
	end, {
		v95,
		t1.isInExperience,
		t1.navigateToHomePage,
		v81,
		v117,
		v101 and v101.hasUnreadMessages
	})
	local v139 = React.useMemo(function() -- line: 834
		-- upvalues: v133 (copy), v129 (copy), React (copy), Foundation (copy), Constants (copy), v77 (copy), v132 (copy), SquadLobbyRegroupRow (copy), v79 (copy)
		if v133 or not v129 then
			return nil
		end

		return React.createElement(Foundation.View, {
			tag = "anchor-bottom-center auto-none gui-object-defaults",
			Position = UDim2.new(0.5, 0, 1, -(20 + Constants.SQUAD_LOBBY_ACTION_BAR_HEIGHT + v77.Gap.XXLarge)),
			Size = UDim2.new(1, 0, 0, v132)
		}, {
			Row = React.createElement(SquadLobbyRegroupRow, {
				localUserId = v79
			})
		})
	end, {
		v129,
		v79,
		v77,
		v132
	})
	local v140 = React.useMemo(function() -- line: 855
		-- upvalues: u130 (ref), React (copy), Foundation (copy), Constants (copy), v77 (copy), v132 (copy), SquadLobbyLuckyRecommendationRow (copy)
		if not u130 then
			return nil
		end

		return React.createElement(Foundation.View, {
			tag = "anchor-bottom-center auto-none gui-object-defaults",
			Position = UDim2.new(0.5, 0, 1, -(20 + Constants.SQUAD_LOBBY_ACTION_BAR_HEIGHT + v77.Gap.XXLarge)),
			Size = UDim2.new(1, 0, 0, v132)
		}, {
			Row = React.createElement(SquadLobbyLuckyRecommendationRow)
		})
	end, {
		u130,
		v77,
		v132
	})
	local v141 = React.useMemo(function() -- line: 874
		-- upvalues: v89 (copy), React (copy), Foundation (copy), StateLayerAffordance (copy), v90 (copy), v119 (copy), v77 (copy), SquadLobbyVoiceChatMenu (copy), FFlagEnablePartyVoiceChangersInLua (copy), t1 (copy)
		if v89 then
			return (React.createElement(Foundation.View, {
				Size = UDim2.new(1, 0, 1, 0),
				stateLayer = {
					affordance = StateLayerAffordance.None
				},
				onActivated = function() -- line: 880
					-- upvalues: v90 (copy)
					v90(false)
				end
			}, { React.createElement(Foundation.ScrollView, {
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0.5, 0, 0, 0),
				AnchorPoint = Vector2.new(0.5, 0),
				sizeConstraint = {
					MaxSize = Vector2.new(350, 1e999)
				},
				scroll = {
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					CanvasSize = UDim2.new(1, 0, 1, 0),
					ScrollingDirection = Enum.ScrollingDirection.Y
				},
				layout = {
					FillDirection = Enum.FillDirection.Vertical,
					SortOrder = Enum.SortOrder.LayoutOrder
				}
			}, {
				FlexibleSpace = React.createElement(Foundation.View, {
					LayoutOrder = 1,
					Size = UDim2.new(1, 0, 0, v119),
					flexItem = {
						FlexMode = Enum.UIFlexMode.Fill
					},
					stateLayer = {
						affordance = StateLayerAffordance.None
					},
					onActivated = function() -- line: 904
						-- upvalues: v90 (copy)
						v90(false)
					end
				}),
				Menu = React.createElement(Foundation.View, {
					LayoutOrder = 2,
					ZIndex = 3,
					Size = UDim2.new(1, 0, 1, 0),
					flexItem = {
						ItemLineAlignment = Enum.ItemLineAlignment.Center
					},
					AutomaticSize = Enum.AutomaticSize.Y,
					padding = Vector2.new(v77.Padding.XLarge, v77.Padding.Medium),
					stateLayer = {
						affordance = StateLayerAffordance.None
					},
					onActivated = function() -- line: 917
					end
				}, {
					SquadLobbyVoiceChatMenu = React.createElement(SquadLobbyVoiceChatMenu, {
						openSquadVoiceChangers = if not FFlagEnablePartyVoiceChangersInLua then nil else t1.openSquadVoiceChangers
					})
				}),
				BottomPadding = React.createElement(Foundation.View, {
					LayoutOrder = 3,
					Size = UDim2.new(1, 0, 0, v119),
					stateLayer = {
						affordance = StateLayerAffordance.None
					},
					onActivated = function() -- line: 930
						-- upvalues: v90 (copy)
						v90(false)
					end
				})
			}) }))
		end

		return nil
	end, {
		v119,
		v89,
		v90,
		v77
	})
	local v142 = React.useMemo(function() -- line: 939
		-- upvalues: v122 (copy), v120 (copy), React (copy), SquadLobbyUserDropdownMenu (copy), t1 (copy), v121 (copy), v123 (copy), v98 (copy)
		if v122 and v120 then
			return (React.createElement(SquadLobbyUserDropdownMenu, {
				userId = v120,
				isInExperience = t1.isInExperience,
				onDismiss = function() -- line: 944
					-- upvalues: v121 (copy), v123 (copy)
					v121(nil)
					v123(false)
				end,
				openViewProfile = function() -- line: 948
					-- upvalues: t1 (copy), v120 (copy)
					t1.openViewProfile(v120)
				end,
				openSquadVoiceAbuseReport = t1.openSquadVoiceAbuseReport,
				parentChannelId = v98
			}))
		end

		return nil
	end, {
		v98,
		t1.isInExperience,
		v122,
		v123,
		t1.openViewProfile,
		v120,
		v121
	})

	React.useEffect(function() -- line: 965
		-- upvalues: SquadCoordinationExperienceJoinExperimentation (copy), FFlagEnableSquadRegroupExperimentation (copy), SquadRegroupExperimentation (copy), LuckyRecommendationExperimentation (copy)
		SquadCoordinationExperienceJoinExperimentation.logExposure()

		if FFlagEnableSquadRegroupExperimentation then
			SquadRegroupExperimentation.logExposure()
		end

		LuckyRecommendationExperimentation.logExposure()
	end, {})

	local v143 = Roact.createFragment({
		SquadLobbyBanners = v135,
		SquadLobbyUsersScrollingFrame = v137,
		SquadLobbyRegroupRow = v139,
		SquadLobbyLuckyRecommendationRow = v140,
		SquadLobbyActionBar = v138,
		SquadLobbyVoiceChatMenu = v141,
		UserDropdownMenu = v142
	})

	if SquadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then
		v143 = React.createElement(SquadLobbySessionProvider.Provider, nil, v143)
	end

	return v143
end

return SquadLobby
