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
local StateLayerAffordance = Foundation.Enums.StateLayerAffordance
local useStyle = UIBlox.Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local clearInterval = LuauPolyfill.clearInterval
local setInterval = LuauPolyfill.setInterval
local v52 = game:DefineFastFlag("EnableSquadLobbyBanners", false)
local FFlagEnableSquadCoplayAnalytic = SharedFlags.FFlagEnableSquadCoplayAnalytic
local FFlagEnableSquadTopBannerWideMode = SharedFlags.FFlagEnableSquadTopBannerWideMode
local FFlagMakeCreateOrJoinSquadAThunks = SharedFlags.FFlagMakeCreateOrJoinSquadAThunks
local v56 = game:DefineFastInt("PartyInviteeNoResponseDurationSeconds", 3)
local v57 = game:DefineFastInt("PartyUserInvitedDurationSeconds", 10)
local SquadQuickStartExperimentation = dependencies.SocialExperiments.SquadQuickStartExperimentation
local SquadCoordinationExperienceJoinExperimentation = dependencies.SocialExperiments.SquadCoordinationExperienceJoinExperimentation
local SquadRegroupExperimentation = dependencies.SocialExperiments.SquadRegroupExperimentation
local FFlagEnablePartyQuickStartButton = SharedFlags.FFlagEnablePartyQuickStartButton
local FFlagEnablePartyVoiceChangersInLua = SharedFlags.FFlagEnablePartyVoiceChangersInLua
local FFlagEnableSquadRegroupExperimentation = SharedFlags.FFlagEnableSquadRegroupExperimentation
local FFlagEnableSquadRegroupExperimentationSmallScreenFix = SharedFlags.FFlagEnableSquadRegroupExperimentationSmallScreenFix
local FFlagEnableSquadRegroupServerCapacityCheck = SharedFlags.FFlagEnableSquadRegroupServerCapacityCheck
local FFlagAppChatShowOSAOnPageEntry = SharedFlags.FFlagAppChatShowOSAOnPageEntry
local FFlagEnableScheduledSquads = SharedFlags.FFlagEnableScheduledSquads

local function SquadLobby(t1: {[any]: any}) -- line: 98
	-- upvalues: useTokens (copy), useDispatch (copy), useLocalUserId (copy), useStyle (copy), useSquadState (copy), useNavigation (copy), React (copy), SquadExternalContractContext (copy), useVoiceStatus (copy), FFlagEnableSquadTopBannerWideMode (copy), HttpService (copy), RoactNavigation (copy), SquadViewFlags (copy), useCurrentSquadSelector (copy), useSelector (copy), useStore (copy), SquadQuickStartExperimentation (copy), FFlagEnablePartyQuickStartButton (copy), FFlagEnableScheduledSquads (copy), SquadPromptType (copy), FFlagMakeCreateOrJoinSquadAThunks (copy), createOrJoinSquad (copy), NetworkingSquads (copy), FFlagEnableSquadCoplayAnalytic (copy), logInExpCoplayTelemetry (copy), SquadCoplayJoin (copy), useEffectOnce (copy), FFlagAppChatShowOSAOnPageEntry (copy), Logger (copy), Cryo (copy), SquadUserPartyStatus (copy), v57 (copy), v56 (copy), setInterval (copy), clearInterval (copy), usePrevious (copy), UserBlockingNetworking (copy), NetworkingPresence (copy), Constants (copy), FFlagEnableSquadRegroupServerCapacityCheck (copy), Players (copy), SquadRegroupExperimentation (copy), PresenceType (copy), FFlagEnableSquadRegroupExperimentationSmallScreenFix (copy), v52 (copy), SquadLobbyBanners (copy), Foundation (copy), SquadLobbyUserGrid (copy), EventNames (copy), SquadPartySheetActionEnum (copy), SquadLobbyRegroupRow (copy), SquadLobbyActionBar (copy), StateLayerAffordance (copy), SquadLobbyVoiceChatMenu (copy), FFlagEnablePartyVoiceChangersInLua (copy), SquadLobbyUserDropdownMenu (copy), SquadCoordinationExperienceJoinExperimentation (copy), FFlagEnableSquadRegroupExperimentation (copy), Roact (copy), SquadLobbySessionProvider (copy)
	local v70 = useTokens()
	local v71 = useDispatch()
	local v72 = tonumber(useLocalUserId()) or 0
	local v73 = useStyle()
	local v74 = useSquadState()
	local v75 = useNavigation()
	local isWideMode = t1.isWideMode
	local v77 = React.useContext(SquadExternalContractContext)
	local v78, v79 = React.useState(0)
	local v80 = useVoiceStatus()

	if FFlagEnableSquadTopBannerWideMode then
		local v81 = React.useRef(HttpService:GenerateGUID())

		React.useEffect(function() -- line: 113
			-- upvalues: isWideMode (copy), v81 (copy), v77 (copy), v75 (copy), RoactNavigation (copy)
			if not isWideMode then
				local current = v81.current

				v77.disableSquadTopBanner(current, true)

				local u134 = v75 and v75.addListener(RoactNavigation.Events.WillBlur, function(p1) -- line: 118
					-- upvalues: v77 (copy), current (copy)
					if p1.state.routeName ~= "SquadInviteFriends" and p1.state.routeName ~= "SquadLobby" then
						v77.disableSquadTopBanner(current, false)

						return
					end

					v77.disableSquadTopBanner(current, true)
				end)

				return function() -- line: 129
					-- upvalues: u134 (ref), v77 (copy), current (copy)
					if u134 then
						u134.remove()
						u134 = nil
					end

					v77.disableSquadTopBanner(current, false)
				end
			end

			return function() -- line: 139
			end
		end, {
			v77.disableSquadTopBanner,
			v75,
			isWideMode
		})
		React.useEffect(function() -- line: 142
			-- upvalues: v77 (copy), SquadViewFlags (copy)
			v77.updateSquadViewFlags(SquadViewFlags.SquadLobby, true)

			return function() -- line: 144
				-- upvalues: v77 (copy), SquadViewFlags (copy)
				v77.updateSquadViewFlags(SquadViewFlags.SquadLobby, false)
			end
		end, { v77.updateSquadViewFlags })
	else
		React.useEffect(function() -- line: 152
			-- upvalues: v77 (copy), SquadViewFlags (copy), v75 (copy), RoactNavigation (copy)
			v77.updateSquadViewFlags(SquadViewFlags.SquadLobby, true)

			local u135 = v75 and v75.addListener(RoactNavigation.Events.WillBlur, function(p2) -- line: 155
				-- upvalues: v77 (copy), SquadViewFlags (copy)
				if p2.state.routeName ~= "SquadInviteFriends" and p2.state.routeName ~= "SquadLobby" then
					v77.updateSquadViewFlags(SquadViewFlags.SquadLobby, false)

					return
				end

				v77.updateSquadViewFlags(SquadViewFlags.SquadLobby, true)
			end)

			return function() -- line: 162
				-- upvalues: u135 (ref), v77 (copy), SquadViewFlags (copy)
				if u135 then
					u135.remove()
					u135 = nil
				end

				v77.updateSquadViewFlags(SquadViewFlags.SquadLobby, false)
			end
		end, {
			v77.updateSquadViewFlags,
			v75
		})
	end

	local v82, v83 = React.useState(false)
	local v84, v85 = React.useState(Vector2.zero)
	local v86 = React.useCallback(function(p3) -- line: 174
		-- upvalues: v85 (copy)
		v85(p3.AbsoluteSize)
	end, { v85 })
	local v87 = useCurrentSquadSelector()
	local v88 = not v87 and "" or v87.squadId
	local v89 = v87 and v87.members
	local v90 = React.useCallback(function(p4) -- line: 182
		if p4.Squad and (p4.Squad.Squad and p4.Squad.Squad.currentSquad) then
			return p4.Squad.Squad.currentSquad.parentChannelId or ""
		end

		return ""
	end, {})
	local v91 = useSelector(v90)
	local v92 = useStore()
	local v93 = v75.getParam("conversationId") or ""
	local v94 = v77.useGetConversationFromId(v93)
	local v95 = v94 and v94.participants
	local v96 = v87 and v87.invitees
	local squadCreateOrJoinAttemptId = nil
	local v98 = v75.getParam("extraParams") or {}
	local squadId = v98.squadId

	if SquadQuickStartExperimentation.getPartyQuickStartChangesEnabled() and FFlagEnablePartyQuickStartButton then
		squadCreateOrJoinAttemptId = v98.squadCreateOrJoinAttemptId
	end

	local v100 = if not FFlagEnableScheduledSquads then nil else v98.scheduledGroupUpId
	local v101 = React.useCallback(function() -- line: 208
		-- upvalues: v77 (copy), v92 (copy), SquadPromptType (copy), t1 (copy)
		v77.setSquadPrompt(v92, {
			hideCancelButton = true,
			promptType = SquadPromptType.Error,
			onConfirm = function() -- line: 212
				-- upvalues: t1 (copy)
				t1.navigateAwayFromSquad()
			end
		})
	end, {
		t1.navigateAwayFromSquad,
		v92,
		v77.setSquadPrompt
	})
	local v102 = React.useCallback(function(s1: string) -- line: 218
		-- upvalues: FFlagMakeCreateOrJoinSquadAThunks (copy), v71 (copy), createOrJoinSquad (copy), v77 (copy), squadCreateOrJoinAttemptId (ref), t1 (copy), FFlagEnableScheduledSquads (copy), v100 (copy), NetworkingSquads (copy), FFlagEnableSquadCoplayAnalytic (copy), logInExpCoplayTelemetry (copy), SquadCoplayJoin (copy), v101 (copy)
		if FFlagMakeCreateOrJoinSquadAThunks then
			v71(createOrJoinSquad(s1, v77.setSquadPrompt, v77.fireSquadAnalytics, v77.squadLocation, squadCreateOrJoinAttemptId, t1.navigateAwayFromSquad, if not FFlagEnableScheduledSquads then nil else v100))

			return
		end

		local v139 = v71(NetworkingSquads.CreateOrJoinSquad.API({
			leaveExisting = true,
			parentChannelId = s1,
			squadLocation = if not FFlagEnableSquadCoplayAnalytic then nil else v77.squadLocation,
			partyAttemptId = squadCreateOrJoinAttemptId
		}))

		if FFlagEnableSquadCoplayAnalytic then
			v139 = v139:andThen(function(p5) -- line: 242
				-- upvalues: logInExpCoplayTelemetry (copy), v77 (copy), SquadCoplayJoin (copy)
				local groupUpId = p5.responseBody.groupUp.groupUpId
				local members = p5.responseBody.groupUp.members

				if groupUpId and members then
					logInExpCoplayTelemetry(groupUpId, members, v77.squadLocation, SquadCoplayJoin.PartyJoin, v77.fireSquadAnalytics)
				end
			end)
		end

		v139:catch(function(_) -- line: 258
			-- upvalues: v101 (copy)
			v101()
		end)
	end, {
		v71,
		if not FFlagMakeCreateOrJoinSquadAThunks then nil else createOrJoinSquad,
		if not FFlagMakeCreateOrJoinSquadAThunks then nil else t1.navigateAwayFromSquad,
		if FFlagMakeCreateOrJoinSquadAThunks then nil else v101,
		if not FFlagMakeCreateOrJoinSquadAThunks then nil else v77.setSquadPrompt,
		v77.squadLocation,
		v77.fireSquadAnalytics,
		squadCreateOrJoinAttemptId,
		if not FFlagEnableScheduledSquads then nil else v100
	})
	local v103 = squadId and squadId ~= v88

	React.useEffect(function() -- line: 277
		-- upvalues: v103 (copy), v77 (copy), v92 (copy), SquadPromptType (copy), v102 (copy), v93 (copy), t1 (copy), v75 (copy)
		if v103 then
			v77.setSquadPrompt(v92, {
				promptType = SquadPromptType.JoinAnotherSquad,
				onConfirm = function() -- line: 281
					-- upvalues: v102 (copy), v93 (copy)
					v102(v93)
				end,
				onCancel = function() -- line: 284
					-- upvalues: t1 (copy)
					t1.navigateAwayFromSquad()
				end
			})
			v75.setParams({
				squadId = nil
			})
		end
	end, {
		squadId,
		v77.setSquadPrompt,
		v102,
		v93,
		t1.navigateAwayFromSquad,
		v103
	})
	useEffectOnce(function() -- line: 303
		-- upvalues: v103 (copy), FFlagAppChatShowOSAOnPageEntry (copy), v77 (copy), v94 (copy), t1 (copy), v88 (copy), Logger (copy), v93 (copy), v71 (copy), v102 (copy), v101 (copy)
		if v103 then
			return
		end

		if FFlagAppChatShowOSAOnPageEntry and v77.shouldShowOSAForConversation and v77.shouldShowOSAForConversation(v94) then
			t1.navigateAwayFromSquad()

			return
		end

		if v88 == "" then
			if v94 and v94.source == "friends" then
				Logger:debug("Channel does not exist for: {}. Creating a friend conversation.", v93)
				v71(v77.createFriendConversation(v93)):andThen(function(p7) -- line: 327
					-- upvalues: v102 (copy)
					if p7 and p7.id then
						v102(p7.id)
					end
				end):catch(function(p8) -- line: 332
					-- upvalues: Logger (copy), v101 (copy)
					Logger:debug("Error while trying to create a friend conversation: {}", p8)
					v101()
				end)

				return
			end

			v102(v93)
		end
	end, {
		v71,
		v77.createFriendConversation,
		v93,
		v94,
		v102,
		v101
	})

	local v104, v105 = React.useState({})
	local v106 = React.useMemo(function() -- line: 352
		-- upvalues: v89 (copy)
		local t2 = {}

		if v89 then
			for _, v in ipairs(v89) do
				t2[tostring(v.userId)] = true
			end
		end

		return t2
	end, { v89 })
	local v107 = React.useCallback(function(p9, p10, p11) -- line: 373
		-- upvalues: Cryo (copy), v72 (copy), SquadUserPartyStatus (copy), v57 (copy), v56 (copy)
		local t3 = {}
		local n1 = 0

		if p10 and #Cryo.Dictionary.keys(p10) == 0 then
			table.insert(t3, {
				userId = v72,
				partyStatus = SquadUserPartyStatus.Connecting
			})
		elseif p9 then
			local timestamp = os.time()

			for _, v in ipairs(p9) do
				local Inactive = SquadUserPartyStatus.Inactive

				if p10[v] then
					Inactive = SquadUserPartyStatus.Active
				else
					local v152 = p11 and Cryo.List.findWhere(p11, function(p12) -- line: 398
						-- upvalues: v (copy)
						return v == tostring(p12.userId)
					end)

					if v152 then
						local v153 = math.floor(p11[v152].invitedAtTimestampMs / 1000) or 0

						if timestamp < v153 then
							continue
						end

						if timestamp - v153 < v57 then
							Inactive = SquadUserPartyStatus.Invited
							n1 += 1
						elseif timestamp - v153 < v56 + v57 then
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

	React.useEffect(function() -- line: 442
		-- upvalues: v107 (copy), v95 (copy), v106 (copy), v96 (copy), v105 (copy), setInterval (copy), clearInterval (copy)
		local v154 = v107(v95, v106, v96)

		v105(v154.users)

		local u155 = nil

		u155 = setInterval(function() -- line: 448
			-- upvalues: v107 (copy), v95 (copy), v106 (copy), v96 (copy), v105 (copy), clearInterval (copy), u155 (ref)
			local v182 = v107(v95, v106, v96)

			v105(v182.users)

			if v182.numberOfUpdatesPending == 0 then
				clearInterval(u155)
			end
		end, 1000)

		return function() -- line: 457
			-- upvalues: clearInterval (copy), u155 (ref)
			clearInterval(u155)
		end
	end, {
		v106,
		v96,
		v95,
		v107
	})

	local v108 = usePrevious(v88) or ""

	React.useEffect(function() -- line: 464
		-- upvalues: v108 (copy), v88 (copy), t1 (copy), v93 (copy), v91 (copy), RoactNavigation (copy), isWideMode (copy), v75 (copy)
		if v108 ~= "" and v88 == "" then
			t1.navigateAwayFromSquad()

			return
		end

		if v88 ~= "" and v93 ~= "" and v91 ~= "" and v91 ~= v93 then
			local t4 = {
				RoactNavigation.Actions.navigate({
					routeName = "ChatConversation",
					params = {
						conversationId = v91
					}
				}),
				RoactNavigation.Actions.navigate({
					routeName = "SquadLobby",
					params = {
						conversationId = v91
					}
				})
			}

			if isWideMode then
				v75.navigate("ChatLanding", {
					conversationId = v91
				}, RoactNavigation.StackActions.reset({
					index = 2,
					actions = t4
				}))

				return
			end

			table.insert(t4, 1, RoactNavigation.Actions.navigate({
				routeName = "ChatLanding"
			}))
			v75.navigate("ChatLandingStack", {
				conversationId = v91
			}, RoactNavigation.StackActions.reset({
				index = 3,
				actions = t4
			}))
		end
	end, {
		v75,
		v91,
		v93,
		v88,
		t1.navigateAwayFromSquad
	})

	local v109 = usePrevious(v89)

	React.useEffect(function() -- line: 528
		-- upvalues: v89 (copy), v109 (copy), v72 (copy), v71 (copy), UserBlockingNetworking (copy), NetworkingPresence (copy)
		local t5 = {}

		if v89 then
			for _, v in pairs(v89) do
				local v160 = false

				if v109 then
					for _, v2 in pairs(v109) do
						if v2.userId == v.userId then
							v160 = true

							break
						end
					end
				end

				if not v160 then
					table.insert(t5, v.userId)

					if v72 ~= v.userId then
						v71(UserBlockingNetworking.IsBlockedById.API({
							userId = v.userId,
							currentUserId = v72
						}))
					end
				end
			end
		end

		v71(NetworkingPresence.GetPresencesFromUserIds.API(t5))
	end, {
		v89,
		v72,
		v109
	})

	local v110 = React.useCallback(function() -- line: 558
		-- upvalues: v83 (copy), v82 (copy)
		v83(not v82)
	end, {
		v82,
		v83
	})
	local v111 = Constants.SQUAD_LOBBY_ACTION_BAR_HEIGHT + 26 + 20
	local v112 = Constants.SQUAD_LOBBY_ACTION_BAR_HEIGHT + 20
	local v113, v114 = React.useState(nil)
	local v115, v116 = React.useState(false)
	local v117 = React.useCallback(function(vector2: Vector2) -- line: 570
		-- upvalues: v79 (copy), v70 (copy)
		if vector2.Y > 0 then
			v79(vector2.Y + v70.Gap.Medium)

			return
		end

		v79(0)
	end, {
		v79,
		v70
	})
	local v118 = React.useCallback(function(p13) -- line: 578
		-- upvalues: v89 (copy)
		local v165 = p13.Squad and (not not p13.Squad.Presence and p13.Squad.Presence.byUserId) or {}
		local t6 = {}

		for _, v in ipairs(v89 or {}) do
			local str = tostring(v.userId)

			t6[str] = v165[str]
		end

		return t6
	end, { v89 })
	local v119 = useSelector(v118)
	local v120 = not FFlagEnableSquadRegroupServerCapacityCheck or Players.MaxPlayers > 1
	local v121 = React.useMemo(function() -- line: 594
		-- upvalues: SquadRegroupExperimentation (copy), t1 (copy), v120 (copy), v87 (copy), v119 (copy), v72 (copy), PresenceType (copy)
		if not SquadRegroupExperimentation.getSquadRegroupEnabled() or (not t1.isInExperience or not v120 or not v87 or not v87.members or not (#v87.members > 1) or not v87.selfPermissions or not v87.selfPermissions.canSeeRegroupJoinButton) then
			return false
		end

		local v170 = v119[tostring(v72)]

		if v170 == nil then
			return false
		end

		for k, v in pairs(v119) do
			if v ~= nil and k ~= tostring(v72) and (v.userPresenceType == PresenceType.Online or v.userPresenceType == PresenceType.InGame and v170.gameId ~= nil and v.gameId ~= nil and v170.gameId ~= v.gameId) then
				return true
			end
		end

		return false
	end, {
		v119,
		v72,
		t1.isInExperience,
		v87,
		v120
	})
	local v122 = v70.Size.Size_1000 + v70.Padding.Medium * 2
	local v123 = FFlagEnableSquadRegroupExperimentationSmallScreenFix and v121
	local v124 = (v123 or not v121) and 0 or v70.Gap.XXLarge + v122
	local v125 = React.useMemo(function() -- line: 648
		-- upvalues: v52 (copy), React (copy), SquadLobbyBanners (copy), v117 (copy)
		if v52 then
			return (React.createElement(SquadLobbyBanners, {
				onAbsoluteSizeChanged = v117
			}))
		end

		return nil
	end, { v117 })
	local v126 = React.useCallback(function() -- line: 656
		-- upvalues: t1 (copy), v91 (copy)
		t1.navigateToSquadInviteFriends(v91)
	end, {
		v91,
		t1.navigateToSquadInviteFriends
	})
	local v127 = React.useMemo(function() -- line: 661
		-- upvalues: React (copy), v78 (copy), v124 (copy), v73 (copy), v86 (copy), v123 (copy), Foundation (copy), SquadLobbyUserGrid (copy), v84 (copy), v111 (copy), v70 (copy), v122 (copy), v104 (copy), t1 (copy), v77 (copy), EventNames (copy), v91 (copy), SquadPartySheetActionEnum (copy), v80 (copy), v114 (copy), v116 (copy), v126 (copy), SquadLobbyRegroupRow (copy), v72 (copy)
		return React.createElement("ScrollingFrame", {
			Position = UDim2.fromOffset(0, v78),
			Size = UDim2.new(1, 0, 1, -(v78 + v124)),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollBarImageColor3 = v73.Theme.UIEmphasis.Color,
			ScrollBarImageTransparency = v73.Theme.UIEmphasis.Transparency,
			ScrollBarThickness = 4,
			Selectable = false,
			ZIndex = 0,
			[React.Change.AbsoluteSize] = v86
		}, {
			FrameContents = if not v123 then nil else React.createElement(Foundation.View, {
				tag = "auto-y size-full-0 bg-surface-0 col align-x-center align-y-top"
			}, {
				UserGridContainer = React.createElement(Foundation.View, {
					tag = "auto-y size-full-0 bg-surface-0",
					LayoutOrder = 1
				}, {
					SquadLobbyUserGrid = React.createElement(SquadLobbyUserGrid, {
						containerSize = v84 - Vector2.new(0, v111 + v70.Gap.Medium + v122),
						paddingBottom = UDim.new(0, 0),
						users = v104,
						isInExperience = t1.isInExperience,
						onUserCardActivated = function(s2: string) -- line: 691
							-- upvalues: v77 (copy), EventNames (copy), v91 (copy), SquadPartySheetActionEnum (copy), v80 (copy), v114 (copy), v116 (copy)
							v77.fireSquadAnalytics(EventNames.PartySheetAction, {
								parentChannelId = v91,
								actionType = SquadPartySheetActionEnum.UserCardClicked,
								voiceStatus = v80
							})
							v114(s2)
							v116(true)
						end,
						navigateToHomePage = t1.navigateToHomePage,
						navigateToSquadInviteFriends = v126
					})
				}),
				RegroupRowSpacer = React.createElement(Foundation.View, {
					tag = "bg-surface-0",
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, v70.Gap.Medium)
				}),
				SquadLobbyRegroupRow = React.createElement(Foundation.View, {
					tag = "bg-surface-0",
					LayoutOrder = 3,
					Size = UDim2.new(1, 0, 0, v122)
				}, {
					Row = React.createElement(SquadLobbyRegroupRow, {
						localUserId = v72
					})
				}),
				BottomPadding = React.createElement(Foundation.View, {
					tag = "bg-surface-0",
					LayoutOrder = 4,
					Size = UDim2.new(1, 0, 0, v111)
				})
			}),
			SquadLobbyUserGrid = if not v123 then React.createElement(SquadLobbyUserGrid, {
				containerSize = v84 - Vector2.new(0, v111),
				paddingBottom = UDim.new(0, v111),
				users = v104,
				isInExperience = t1.isInExperience,
				onUserCardActivated = function(s3: string) -- line: 733
					-- upvalues: v77 (copy), EventNames (copy), v91 (copy), SquadPartySheetActionEnum (copy), v80 (copy), v114 (copy), v116 (copy)
					v77.fireSquadAnalytics(EventNames.PartySheetAction, {
						parentChannelId = v91,
						actionType = SquadPartySheetActionEnum.UserCardClicked,
						voiceStatus = v80
					})
					v114(s3)
					v116(true)
				end,
				navigateToHomePage = t1.navigateToHomePage,
				navigateToSquadInviteFriends = v126
			}) else nil
		})
	end, {
		v114,
		v116,
		v84,
		v89,
		v126,
		v86,
		t1.navigateToHomePage,
		v111,
		v78,
		if not v121 then nil else v124,
		v104,
		v123,
		if not v123 then nil else v122,
		if not v123 then nil else v72,
		v80
	})
	local v128 = React.useMemo(function() -- line: 764
		-- upvalues: React (copy), SquadLobbyActionBar (copy), v74 (copy), v94 (copy), t1 (copy), v110 (copy), v88 (copy)
		return React.createElement(SquadLobbyActionBar, {
			squadState = v74,
			anchorPoint = Vector2.new(0.5, 1),
			hasUnreadMessages = not not v94 and (not not v94.hasUnreadMessages and v94.hasUnreadMessages),
			navigateAwayFromSquad = t1.navigateAwayFromSquad,
			navigateToHomePage = t1.navigateToHomePage,
			toggleVoiceChatMenu = v110,
			position = UDim2.new(0.5, 0, 1, -20),
			squadId = v88,
			isInExperience = t1.isInExperience
		})
	end, {
		v88,
		t1.isInExperience,
		t1.navigateToHomePage,
		v74,
		v110,
		v94 and v94.hasUnreadMessages
	})
	local v129 = React.useMemo(function() -- line: 787
		-- upvalues: v123 (copy), v121 (copy), React (copy), Foundation (copy), Constants (copy), v70 (copy), v122 (copy), SquadLobbyRegroupRow (copy), v72 (copy)
		if v123 or not v121 then
			return nil
		end

		return React.createElement(Foundation.View, {
			tag = "anchor-bottom-center auto-none gui-object-defaults",
			Position = UDim2.new(0.5, 0, 1, -(20 + Constants.SQUAD_LOBBY_ACTION_BAR_HEIGHT + v70.Gap.XXLarge)),
			Size = UDim2.new(1, 0, 0, v122)
		}, {
			Row = React.createElement(SquadLobbyRegroupRow, {
				localUserId = v72
			})
		})
	end, {
		v121,
		v72,
		v70,
		v122
	})
	local v130 = React.useMemo(function() -- line: 808
		-- upvalues: v82 (copy), React (copy), Foundation (copy), StateLayerAffordance (copy), v83 (copy), v112 (copy), v70 (copy), SquadLobbyVoiceChatMenu (copy), FFlagEnablePartyVoiceChangersInLua (copy), t1 (copy)
		if v82 then
			return (React.createElement(Foundation.View, {
				Size = UDim2.new(1, 0, 1, 0),
				stateLayer = {
					affordance = StateLayerAffordance.None
				},
				onActivated = function() -- line: 814
					-- upvalues: v83 (copy)
					v83(false)
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
					Size = UDim2.new(1, 0, 0, v112),
					flexItem = {
						FlexMode = Enum.UIFlexMode.Fill
					},
					stateLayer = {
						affordance = StateLayerAffordance.None
					},
					onActivated = function() -- line: 838
						-- upvalues: v83 (copy)
						v83(false)
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
					padding = Vector2.new(v70.Padding.XLarge, v70.Padding.Medium),
					stateLayer = {
						affordance = StateLayerAffordance.None
					},
					onActivated = function() -- line: 851
					end
				}, {
					SquadLobbyVoiceChatMenu = React.createElement(SquadLobbyVoiceChatMenu, {
						openSquadVoiceChangers = if not FFlagEnablePartyVoiceChangersInLua then nil else t1.openSquadVoiceChangers
					})
				}),
				BottomPadding = React.createElement(Foundation.View, {
					LayoutOrder = 3,
					Size = UDim2.new(1, 0, 0, v112),
					stateLayer = {
						affordance = StateLayerAffordance.None
					},
					onActivated = function() -- line: 864
						-- upvalues: v83 (copy)
						v83(false)
					end
				})
			}) }))
		end

		return nil
	end, {
		v112,
		v82,
		v83,
		v70
	})
	local v131 = React.useMemo(function() -- line: 873
		-- upvalues: v115 (copy), v113 (copy), React (copy), SquadLobbyUserDropdownMenu (copy), t1 (copy), v114 (copy), v116 (copy), v91 (copy)
		if v115 and v113 then
			return (React.createElement(SquadLobbyUserDropdownMenu, {
				userId = v113,
				isInExperience = t1.isInExperience,
				onDismiss = function() -- line: 878
					-- upvalues: v114 (copy), v116 (copy)
					v114(nil)
					v116(false)
				end,
				openViewProfile = function() -- line: 882
					-- upvalues: t1 (copy), v113 (copy)
					t1.openViewProfile(v113)
				end,
				openSquadVoiceAbuseReport = t1.openSquadVoiceAbuseReport,
				parentChannelId = v91
			}))
		end

		return nil
	end, {
		v91,
		t1.isInExperience,
		v115,
		v116,
		t1.openViewProfile,
		v113,
		v114
	})

	React.useEffect(function() -- line: 899
		-- upvalues: SquadCoordinationExperienceJoinExperimentation (copy), FFlagEnableSquadRegroupExperimentation (copy), SquadRegroupExperimentation (copy)
		SquadCoordinationExperienceJoinExperimentation.logExposure()

		if FFlagEnableSquadRegroupExperimentation then
			SquadRegroupExperimentation.logExposure()
		end
	end, {})

	local v132 = Roact.createFragment({
		SquadLobbyBanners = v125,
		SquadLobbyUsersScrollingFrame = v127,
		SquadLobbyRegroupRow = v129,
		SquadLobbyActionBar = v128,
		SquadLobbyVoiceChatMenu = v130,
		UserDropdownMenu = v131
	})

	if SquadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then
		v132 = React.createElement(SquadLobbySessionProvider.Provider, nil, v132)
	end

	return v132
end

return SquadLobby
