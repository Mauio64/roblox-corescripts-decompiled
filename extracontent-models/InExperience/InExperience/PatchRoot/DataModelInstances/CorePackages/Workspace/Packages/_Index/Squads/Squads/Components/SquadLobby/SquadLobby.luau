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

local function SquadLobby(t1: {[any]: any}) -- line: 97
	-- upvalues: useTokens (copy), useDispatch (copy), useLocalUserId (copy), useStyle (copy), useSquadState (copy), useNavigation (copy), React (copy), SquadExternalContractContext (copy), useVoiceStatus (copy), FFlagEnableSquadTopBannerWideMode (copy), HttpService (copy), RoactNavigation (copy), SquadViewFlags (copy), useCurrentSquadSelector (copy), useSelector (copy), useStore (copy), SquadQuickStartExperimentation (copy), FFlagEnablePartyQuickStartButton (copy), SquadPromptType (copy), FFlagMakeCreateOrJoinSquadAThunks (copy), createOrJoinSquad (copy), NetworkingSquads (copy), FFlagEnableSquadCoplayAnalytic (copy), logInExpCoplayTelemetry (copy), SquadCoplayJoin (copy), useEffectOnce (copy), FFlagAppChatShowOSAOnPageEntry (copy), Logger (copy), Cryo (copy), SquadUserPartyStatus (copy), v57 (copy), v56 (copy), setInterval (copy), clearInterval (copy), usePrevious (copy), UserBlockingNetworking (copy), NetworkingPresence (copy), Constants (copy), FFlagEnableSquadRegroupServerCapacityCheck (copy), Players (copy), SquadRegroupExperimentation (copy), PresenceType (copy), FFlagEnableSquadRegroupExperimentationSmallScreenFix (copy), v52 (copy), SquadLobbyBanners (copy), Foundation (copy), SquadLobbyUserGrid (copy), EventNames (copy), SquadPartySheetActionEnum (copy), SquadLobbyRegroupRow (copy), SquadLobbyActionBar (copy), StateLayerAffordance (copy), SquadLobbyVoiceChatMenu (copy), FFlagEnablePartyVoiceChangersInLua (copy), SquadLobbyUserDropdownMenu (copy), SquadCoordinationExperienceJoinExperimentation (copy), FFlagEnableSquadRegroupExperimentation (copy), Roact (copy), SquadLobbySessionProvider (copy)
	local v69 = useTokens()
	local v70 = useDispatch()
	local v71 = tonumber(useLocalUserId()) or 0
	local v72 = useStyle()
	local v73 = useSquadState()
	local v74 = useNavigation()
	local isWideMode = t1.isWideMode
	local v76 = React.useContext(SquadExternalContractContext)
	local v77, v78 = React.useState(0)
	local v79 = useVoiceStatus()

	if FFlagEnableSquadTopBannerWideMode then
		local v80 = React.useRef(HttpService:GenerateGUID())

		React.useEffect(function() -- line: 112
			-- upvalues: isWideMode (copy), v80 (copy), v76 (copy), v74 (copy), RoactNavigation (copy)
			if not isWideMode then
				local current = v80.current

				v76.disableSquadTopBanner(current, true)

				local u133 = v74 and v74.addListener(RoactNavigation.Events.WillBlur, function(p1) -- line: 117
					-- upvalues: v76 (copy), current (copy)
					if p1.state.routeName ~= "SquadInviteFriends" and p1.state.routeName ~= "SquadLobby" then
						v76.disableSquadTopBanner(current, false)

						return
					end

					v76.disableSquadTopBanner(current, true)
				end)

				return function() -- line: 128
					-- upvalues: u133 (ref), v76 (copy), current (copy)
					if u133 then
						u133.remove()
						u133 = nil
					end

					v76.disableSquadTopBanner(current, false)
				end
			end

			return function() -- line: 138
			end
		end, {
			v76.disableSquadTopBanner,
			v74,
			isWideMode
		})
		React.useEffect(function() -- line: 141
			-- upvalues: v76 (copy), SquadViewFlags (copy)
			v76.updateSquadViewFlags(SquadViewFlags.SquadLobby, true)

			return function() -- line: 143
				-- upvalues: v76 (copy), SquadViewFlags (copy)
				v76.updateSquadViewFlags(SquadViewFlags.SquadLobby, false)
			end
		end, { v76.updateSquadViewFlags })
	else
		React.useEffect(function() -- line: 151
			-- upvalues: v76 (copy), SquadViewFlags (copy), v74 (copy), RoactNavigation (copy)
			v76.updateSquadViewFlags(SquadViewFlags.SquadLobby, true)

			local u134 = v74 and v74.addListener(RoactNavigation.Events.WillBlur, function(p2) -- line: 154
				-- upvalues: v76 (copy), SquadViewFlags (copy)
				if p2.state.routeName ~= "SquadInviteFriends" and p2.state.routeName ~= "SquadLobby" then
					v76.updateSquadViewFlags(SquadViewFlags.SquadLobby, false)

					return
				end

				v76.updateSquadViewFlags(SquadViewFlags.SquadLobby, true)
			end)

			return function() -- line: 161
				-- upvalues: u134 (ref), v76 (copy), SquadViewFlags (copy)
				if u134 then
					u134.remove()
					u134 = nil
				end

				v76.updateSquadViewFlags(SquadViewFlags.SquadLobby, false)
			end
		end, {
			v76.updateSquadViewFlags,
			v74
		})
	end

	local v81, v82 = React.useState(false)
	local v83, v84 = React.useState(Vector2.zero)
	local v85 = React.useCallback(function(p3) -- line: 173
		-- upvalues: v84 (copy)
		v84(p3.AbsoluteSize)
	end, { v84 })
	local v86 = useCurrentSquadSelector()
	local v87 = not v86 and "" or v86.squadId
	local v88 = v86 and v86.members
	local v89 = React.useCallback(function(p4) -- line: 181
		if p4.Squad and (p4.Squad.Squad and p4.Squad.Squad.currentSquad) then
			return p4.Squad.Squad.currentSquad.parentChannelId or ""
		end

		return ""
	end, {})
	local v90 = useSelector(v89)
	local v91 = useStore()
	local v92 = v74.getParam("conversationId") or ""
	local v93 = v76.useGetConversationFromId(v92)
	local v94 = v93 and v93.participants
	local v95 = v86 and v86.invitees
	local squadCreateOrJoinAttemptId = nil
	local v97 = v74.getParam("extraParams") or {}
	local squadId = v97.squadId

	if SquadQuickStartExperimentation.getPartyQuickStartChangesEnabled() and FFlagEnablePartyQuickStartButton then
		squadCreateOrJoinAttemptId = v97.squadCreateOrJoinAttemptId
	end

	local scheduledGroupUpId = v97.scheduledGroupUpId
	local v100 = React.useCallback(function() -- line: 205
		-- upvalues: v76 (copy), v91 (copy), SquadPromptType (copy), t1 (copy)
		v76.setSquadPrompt(v91, {
			hideCancelButton = true,
			promptType = SquadPromptType.Error,
			onConfirm = function() -- line: 209
				-- upvalues: t1 (copy)
				t1.navigateAwayFromSquad()
			end
		})
	end, {
		t1.navigateAwayFromSquad,
		v91,
		v76.setSquadPrompt
	})
	local v101 = React.useCallback(function(s1: string) -- line: 215
		-- upvalues: FFlagMakeCreateOrJoinSquadAThunks (copy), v70 (copy), createOrJoinSquad (copy), v76 (copy), squadCreateOrJoinAttemptId (ref), t1 (copy), scheduledGroupUpId (copy), NetworkingSquads (copy), FFlagEnableSquadCoplayAnalytic (copy), logInExpCoplayTelemetry (copy), SquadCoplayJoin (copy), v100 (copy)
		if FFlagMakeCreateOrJoinSquadAThunks then
			v70(createOrJoinSquad(s1, v76.setSquadPrompt, v76.fireSquadAnalytics, v76.squadLocation, squadCreateOrJoinAttemptId, t1.navigateAwayFromSquad, scheduledGroupUpId))

			return
		end

		local v138 = v70(NetworkingSquads.CreateOrJoinSquad.API({
			leaveExisting = true,
			parentChannelId = s1,
			squadLocation = if not FFlagEnableSquadCoplayAnalytic then nil else v76.squadLocation,
			partyAttemptId = squadCreateOrJoinAttemptId
		}))

		if FFlagEnableSquadCoplayAnalytic then
			v138 = v138:andThen(function(p5) -- line: 239
				-- upvalues: logInExpCoplayTelemetry (copy), v76 (copy), SquadCoplayJoin (copy)
				local groupUpId = p5.responseBody.groupUp.groupUpId
				local members = p5.responseBody.groupUp.members

				if groupUpId and members then
					logInExpCoplayTelemetry(groupUpId, members, v76.squadLocation, SquadCoplayJoin.PartyJoin, v76.fireSquadAnalytics)
				end
			end)
		end

		v138:catch(function(_) -- line: 255
			-- upvalues: v100 (copy)
			v100()
		end)
	end, {
		v70,
		if not FFlagMakeCreateOrJoinSquadAThunks then nil else createOrJoinSquad,
		if not FFlagMakeCreateOrJoinSquadAThunks then nil else t1.navigateAwayFromSquad,
		if FFlagMakeCreateOrJoinSquadAThunks then nil else v100,
		if not FFlagMakeCreateOrJoinSquadAThunks then nil else v76.setSquadPrompt,
		v76.squadLocation,
		v76.fireSquadAnalytics,
		squadCreateOrJoinAttemptId,
		scheduledGroupUpId
	})
	local v102 = squadId and squadId ~= v87

	React.useEffect(function() -- line: 274
		-- upvalues: v102 (copy), v76 (copy), v91 (copy), SquadPromptType (copy), v101 (copy), v92 (copy), t1 (copy), v74 (copy)
		if v102 then
			v76.setSquadPrompt(v91, {
				promptType = SquadPromptType.JoinAnotherSquad,
				onConfirm = function() -- line: 278
					-- upvalues: v101 (copy), v92 (copy)
					v101(v92)
				end,
				onCancel = function() -- line: 281
					-- upvalues: t1 (copy)
					t1.navigateAwayFromSquad()
				end
			})
			v74.setParams({
				squadId = nil
			})
		end
	end, {
		squadId,
		v76.setSquadPrompt,
		v101,
		v92,
		t1.navigateAwayFromSquad,
		v102
	})
	useEffectOnce(function() -- line: 300
		-- upvalues: v102 (copy), FFlagAppChatShowOSAOnPageEntry (copy), v76 (copy), v93 (copy), t1 (copy), v87 (copy), Logger (copy), v92 (copy), v70 (copy), v101 (copy), v100 (copy)
		if v102 then
			return
		end

		if FFlagAppChatShowOSAOnPageEntry and v76.shouldShowOSAForConversation and v76.shouldShowOSAForConversation(v93) then
			t1.navigateAwayFromSquad()

			return
		end

		if v87 == "" then
			if v93 and v93.source == "friends" then
				Logger:debug("Channel does not exist for: {}. Creating a friend conversation.", v92)
				v70(v76.createFriendConversation(v92)):andThen(function(p7) -- line: 324
					-- upvalues: v101 (copy)
					if p7 and p7.id then
						v101(p7.id)
					end
				end):catch(function(p8) -- line: 329
					-- upvalues: Logger (copy), v100 (copy)
					Logger:debug("Error while trying to create a friend conversation: {}", p8)
					v100()
				end)

				return
			end

			v101(v92)
		end
	end, {
		v70,
		v76.createFriendConversation,
		v92,
		v93,
		v101,
		v100
	})

	local v103, v104 = React.useState({})
	local v105 = React.useMemo(function() -- line: 349
		-- upvalues: v88 (copy)
		local t2 = {}

		if v88 then
			for _, v in ipairs(v88) do
				t2[tostring(v.userId)] = true
			end
		end

		return t2
	end, { v88 })
	local v106 = React.useCallback(function(p9, p10, p11) -- line: 370
		-- upvalues: Cryo (copy), v71 (copy), SquadUserPartyStatus (copy), v57 (copy), v56 (copy)
		local t3 = {}
		local n1 = 0

		if p10 and #Cryo.Dictionary.keys(p10) == 0 then
			table.insert(t3, {
				userId = v71,
				partyStatus = SquadUserPartyStatus.Connecting
			})
		elseif p9 then
			local timestamp = os.time()

			for _, v in ipairs(p9) do
				local Inactive = SquadUserPartyStatus.Inactive

				if p10[v] then
					Inactive = SquadUserPartyStatus.Active
				else
					local v151 = p11 and Cryo.List.findWhere(p11, function(p12) -- line: 395
						-- upvalues: v (copy)
						return v == tostring(p12.userId)
					end)

					if v151 then
						local v152 = math.floor(p11[v151].invitedAtTimestampMs / 1000) or 0

						if timestamp < v152 then
							continue
						end

						if timestamp - v152 < v57 then
							Inactive = SquadUserPartyStatus.Invited
							n1 += 1
						elseif timestamp - v152 < v56 + v57 then
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

	React.useEffect(function() -- line: 439
		-- upvalues: v106 (copy), v94 (copy), v105 (copy), v95 (copy), v104 (copy), setInterval (copy), clearInterval (copy)
		local v153 = v106(v94, v105, v95)

		v104(v153.users)

		local u154 = nil

		u154 = setInterval(function() -- line: 445
			-- upvalues: v106 (copy), v94 (copy), v105 (copy), v95 (copy), v104 (copy), clearInterval (copy), u154 (ref)
			local v181 = v106(v94, v105, v95)

			v104(v181.users)

			if v181.numberOfUpdatesPending == 0 then
				clearInterval(u154)
			end
		end, 1000)

		return function() -- line: 454
			-- upvalues: clearInterval (copy), u154 (ref)
			clearInterval(u154)
		end
	end, {
		v105,
		v95,
		v94,
		v106
	})

	local v107 = usePrevious(v87) or ""

	React.useEffect(function() -- line: 461
		-- upvalues: v107 (copy), v87 (copy), t1 (copy), v92 (copy), v90 (copy), RoactNavigation (copy), isWideMode (copy), v74 (copy)
		if v107 ~= "" and v87 == "" then
			t1.navigateAwayFromSquad()

			return
		end

		if v87 ~= "" and v92 ~= "" and v90 ~= "" and v90 ~= v92 then
			local t4 = {
				RoactNavigation.Actions.navigate({
					routeName = "ChatConversation",
					params = {
						conversationId = v90
					}
				}),
				RoactNavigation.Actions.navigate({
					routeName = "SquadLobby",
					params = {
						conversationId = v90
					}
				})
			}

			if isWideMode then
				v74.navigate("ChatLanding", {
					conversationId = v90
				}, RoactNavigation.StackActions.reset({
					index = 2,
					actions = t4
				}))

				return
			end

			table.insert(t4, 1, RoactNavigation.Actions.navigate({
				routeName = "ChatLanding"
			}))
			v74.navigate("ChatLandingStack", {
				conversationId = v90
			}, RoactNavigation.StackActions.reset({
				index = 3,
				actions = t4
			}))
		end
	end, {
		v74,
		v90,
		v92,
		v87,
		t1.navigateAwayFromSquad
	})

	local v108 = usePrevious(v88)

	React.useEffect(function() -- line: 525
		-- upvalues: v88 (copy), v108 (copy), v71 (copy), v70 (copy), UserBlockingNetworking (copy), NetworkingPresence (copy)
		local t5 = {}

		if v88 then
			for _, v in pairs(v88) do
				local v159 = false

				if v108 then
					for _, v2 in pairs(v108) do
						if v2.userId == v.userId then
							v159 = true

							break
						end
					end
				end

				if not v159 then
					table.insert(t5, v.userId)

					if v71 ~= v.userId then
						v70(UserBlockingNetworking.IsBlockedById.API({
							userId = v.userId,
							currentUserId = v71
						}))
					end
				end
			end
		end

		v70(NetworkingPresence.GetPresencesFromUserIds.API(t5))
	end, {
		v88,
		v71,
		v108
	})

	local v109 = React.useCallback(function() -- line: 555
		-- upvalues: v82 (copy), v81 (copy)
		v82(not v81)
	end, {
		v81,
		v82
	})
	local v110 = Constants.SQUAD_LOBBY_ACTION_BAR_HEIGHT + 26 + 20
	local v111 = Constants.SQUAD_LOBBY_ACTION_BAR_HEIGHT + 20
	local v112, v113 = React.useState(nil)
	local v114, v115 = React.useState(false)
	local v116 = React.useCallback(function(vector2: Vector2) -- line: 567
		-- upvalues: v78 (copy), v69 (copy)
		if vector2.Y > 0 then
			v78(vector2.Y + v69.Gap.Medium)

			return
		end

		v78(0)
	end, {
		v78,
		v69
	})
	local v117 = React.useCallback(function(p13) -- line: 575
		-- upvalues: v88 (copy)
		local v164 = p13.Squad and (not not p13.Squad.Presence and p13.Squad.Presence.byUserId) or {}
		local t6 = {}

		for _, v in ipairs(v88 or {}) do
			local str = tostring(v.userId)

			t6[str] = v164[str]
		end

		return t6
	end, { v88 })
	local v118 = useSelector(v117)
	local v119 = not FFlagEnableSquadRegroupServerCapacityCheck or Players.MaxPlayers > 1
	local v120 = React.useMemo(function() -- line: 591
		-- upvalues: SquadRegroupExperimentation (copy), t1 (copy), v119 (copy), v86 (copy), v118 (copy), v71 (copy), PresenceType (copy)
		if not SquadRegroupExperimentation.getSquadRegroupEnabled() or (not t1.isInExperience or not v119 or not v86 or not v86.members or not (#v86.members > 1) or not v86.selfPermissions or not v86.selfPermissions.canSeeRegroupJoinButton) then
			return false
		end

		local v169 = v118[tostring(v71)]

		if v169 == nil then
			return false
		end

		for k, v in pairs(v118) do
			if v ~= nil and k ~= tostring(v71) and (v.userPresenceType == PresenceType.Online or v.userPresenceType == PresenceType.InGame and v169.gameId ~= nil and v.gameId ~= nil and v169.gameId ~= v.gameId) then
				return true
			end
		end

		return false
	end, {
		v118,
		v71,
		t1.isInExperience,
		v86,
		v119
	})
	local v121 = v69.Size.Size_1000 + v69.Padding.Medium * 2
	local v122 = FFlagEnableSquadRegroupExperimentationSmallScreenFix and v120
	local v123 = (v122 or not v120) and 0 or v69.Gap.XXLarge + v121
	local v124 = React.useMemo(function() -- line: 645
		-- upvalues: v52 (copy), React (copy), SquadLobbyBanners (copy), v116 (copy)
		if v52 then
			return (React.createElement(SquadLobbyBanners, {
				onAbsoluteSizeChanged = v116
			}))
		end

		return nil
	end, { v116 })
	local v125 = React.useCallback(function() -- line: 653
		-- upvalues: t1 (copy), v90 (copy)
		t1.navigateToSquadInviteFriends(v90)
	end, {
		v90,
		t1.navigateToSquadInviteFriends
	})
	local v126 = React.useMemo(function() -- line: 658
		-- upvalues: React (copy), v77 (copy), v123 (copy), v72 (copy), v85 (copy), v122 (copy), Foundation (copy), SquadLobbyUserGrid (copy), v83 (copy), v110 (copy), v69 (copy), v121 (copy), v103 (copy), t1 (copy), v76 (copy), EventNames (copy), v90 (copy), SquadPartySheetActionEnum (copy), v79 (copy), v113 (copy), v115 (copy), v125 (copy), SquadLobbyRegroupRow (copy), v71 (copy)
		return React.createElement("ScrollingFrame", {
			Position = UDim2.fromOffset(0, v77),
			Size = UDim2.new(1, 0, 1, -(v77 + v123)),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollBarImageColor3 = v72.Theme.UIEmphasis.Color,
			ScrollBarImageTransparency = v72.Theme.UIEmphasis.Transparency,
			ScrollBarThickness = 4,
			Selectable = false,
			ZIndex = 0,
			[React.Change.AbsoluteSize] = v85
		}, {
			FrameContents = if not v122 then nil else React.createElement(Foundation.View, {
				tag = "auto-y size-full-0 bg-surface-0 col align-x-center align-y-top"
			}, {
				UserGridContainer = React.createElement(Foundation.View, {
					tag = "auto-y size-full-0 bg-surface-0",
					LayoutOrder = 1
				}, {
					SquadLobbyUserGrid = React.createElement(SquadLobbyUserGrid, {
						containerSize = v83 - Vector2.new(0, v110 + v69.Gap.Medium + v121),
						paddingBottom = UDim.new(0, 0),
						users = v103,
						isInExperience = t1.isInExperience,
						onUserCardActivated = function(s2: string) -- line: 688
							-- upvalues: v76 (copy), EventNames (copy), v90 (copy), SquadPartySheetActionEnum (copy), v79 (copy), v113 (copy), v115 (copy)
							v76.fireSquadAnalytics(EventNames.PartySheetAction, {
								parentChannelId = v90,
								actionType = SquadPartySheetActionEnum.UserCardClicked,
								voiceStatus = v79
							})
							v113(s2)
							v115(true)
						end,
						navigateToHomePage = t1.navigateToHomePage,
						navigateToSquadInviteFriends = v125
					})
				}),
				RegroupRowSpacer = React.createElement(Foundation.View, {
					tag = "bg-surface-0",
					LayoutOrder = 2,
					Size = UDim2.new(1, 0, 0, v69.Gap.Medium)
				}),
				SquadLobbyRegroupRow = React.createElement(Foundation.View, {
					tag = "bg-surface-0",
					LayoutOrder = 3,
					Size = UDim2.new(1, 0, 0, v121)
				}, {
					Row = React.createElement(SquadLobbyRegroupRow, {
						localUserId = v71
					})
				}),
				BottomPadding = React.createElement(Foundation.View, {
					tag = "bg-surface-0",
					LayoutOrder = 4,
					Size = UDim2.new(1, 0, 0, v110)
				})
			}),
			SquadLobbyUserGrid = if not v122 then React.createElement(SquadLobbyUserGrid, {
				containerSize = v83 - Vector2.new(0, v110),
				paddingBottom = UDim.new(0, v110),
				users = v103,
				isInExperience = t1.isInExperience,
				onUserCardActivated = function(s3: string) -- line: 730
					-- upvalues: v76 (copy), EventNames (copy), v90 (copy), SquadPartySheetActionEnum (copy), v79 (copy), v113 (copy), v115 (copy)
					v76.fireSquadAnalytics(EventNames.PartySheetAction, {
						parentChannelId = v90,
						actionType = SquadPartySheetActionEnum.UserCardClicked,
						voiceStatus = v79
					})
					v113(s3)
					v115(true)
				end,
				navigateToHomePage = t1.navigateToHomePage,
				navigateToSquadInviteFriends = v125
			}) else nil
		})
	end, {
		v113,
		v115,
		v83,
		v88,
		v125,
		v85,
		t1.navigateToHomePage,
		v110,
		v77,
		if not v120 then nil else v123,
		v103,
		v122,
		if not v122 then nil else v121,
		if not v122 then nil else v71,
		v79
	})
	local v127 = React.useMemo(function() -- line: 761
		-- upvalues: React (copy), SquadLobbyActionBar (copy), v73 (copy), v93 (copy), t1 (copy), v109 (copy), v87 (copy)
		return React.createElement(SquadLobbyActionBar, {
			squadState = v73,
			anchorPoint = Vector2.new(0.5, 1),
			hasUnreadMessages = not not v93 and (not not v93.hasUnreadMessages and v93.hasUnreadMessages),
			navigateAwayFromSquad = t1.navigateAwayFromSquad,
			navigateToHomePage = t1.navigateToHomePage,
			toggleVoiceChatMenu = v109,
			position = UDim2.new(0.5, 0, 1, -20),
			squadId = v87,
			isInExperience = t1.isInExperience
		})
	end, {
		v87,
		t1.isInExperience,
		t1.navigateToHomePage,
		v73,
		v109,
		v93 and v93.hasUnreadMessages
	})
	local v128 = React.useMemo(function() -- line: 784
		-- upvalues: v122 (copy), v120 (copy), React (copy), Foundation (copy), Constants (copy), v69 (copy), v121 (copy), SquadLobbyRegroupRow (copy), v71 (copy)
		if v122 or not v120 then
			return nil
		end

		return React.createElement(Foundation.View, {
			tag = "anchor-bottom-center auto-none gui-object-defaults",
			Position = UDim2.new(0.5, 0, 1, -(20 + Constants.SQUAD_LOBBY_ACTION_BAR_HEIGHT + v69.Gap.XXLarge)),
			Size = UDim2.new(1, 0, 0, v121)
		}, {
			Row = React.createElement(SquadLobbyRegroupRow, {
				localUserId = v71
			})
		})
	end, {
		v120,
		v71,
		v69,
		v121
	})
	local v129 = React.useMemo(function() -- line: 805
		-- upvalues: v81 (copy), React (copy), Foundation (copy), StateLayerAffordance (copy), v82 (copy), v111 (copy), v69 (copy), SquadLobbyVoiceChatMenu (copy), FFlagEnablePartyVoiceChangersInLua (copy), t1 (copy)
		if v81 then
			return (React.createElement(Foundation.View, {
				Size = UDim2.new(1, 0, 1, 0),
				stateLayer = {
					affordance = StateLayerAffordance.None
				},
				onActivated = function() -- line: 811
					-- upvalues: v82 (copy)
					v82(false)
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
					Size = UDim2.new(1, 0, 0, v111),
					flexItem = {
						FlexMode = Enum.UIFlexMode.Fill
					},
					stateLayer = {
						affordance = StateLayerAffordance.None
					},
					onActivated = function() -- line: 835
						-- upvalues: v82 (copy)
						v82(false)
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
					padding = Vector2.new(v69.Padding.XLarge, v69.Padding.Medium),
					stateLayer = {
						affordance = StateLayerAffordance.None
					},
					onActivated = function() -- line: 848
					end
				}, {
					SquadLobbyVoiceChatMenu = React.createElement(SquadLobbyVoiceChatMenu, {
						openSquadVoiceChangers = if not FFlagEnablePartyVoiceChangersInLua then nil else t1.openSquadVoiceChangers
					})
				}),
				BottomPadding = React.createElement(Foundation.View, {
					LayoutOrder = 3,
					Size = UDim2.new(1, 0, 0, v111),
					stateLayer = {
						affordance = StateLayerAffordance.None
					},
					onActivated = function() -- line: 861
						-- upvalues: v82 (copy)
						v82(false)
					end
				})
			}) }))
		end

		return nil
	end, {
		v111,
		v81,
		v82,
		v69
	})
	local v130 = React.useMemo(function() -- line: 870
		-- upvalues: v114 (copy), v112 (copy), React (copy), SquadLobbyUserDropdownMenu (copy), t1 (copy), v113 (copy), v115 (copy), v90 (copy)
		if v114 and v112 then
			return (React.createElement(SquadLobbyUserDropdownMenu, {
				userId = v112,
				isInExperience = t1.isInExperience,
				onDismiss = function() -- line: 875
					-- upvalues: v113 (copy), v115 (copy)
					v113(nil)
					v115(false)
				end,
				openViewProfile = function() -- line: 879
					-- upvalues: t1 (copy), v112 (copy)
					t1.openViewProfile(v112)
				end,
				openSquadVoiceAbuseReport = t1.openSquadVoiceAbuseReport,
				parentChannelId = v90
			}))
		end

		return nil
	end, {
		v90,
		t1.isInExperience,
		v114,
		v115,
		t1.openViewProfile,
		v112,
		v113
	})

	React.useEffect(function() -- line: 896
		-- upvalues: SquadCoordinationExperienceJoinExperimentation (copy), FFlagEnableSquadRegroupExperimentation (copy), SquadRegroupExperimentation (copy)
		SquadCoordinationExperienceJoinExperimentation.logExposure()

		if FFlagEnableSquadRegroupExperimentation then
			SquadRegroupExperimentation.logExposure()
		end
	end, {})

	local v131 = Roact.createFragment({
		SquadLobbyBanners = v124,
		SquadLobbyUsersScrollingFrame = v126,
		SquadLobbyRegroupRow = v128,
		SquadLobbyActionBar = v127,
		SquadLobbyVoiceChatMenu = v129,
		UserDropdownMenu = v130
	})

	if SquadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then
		v131 = React.createElement(SquadLobbySessionProvider.Provider, nil, v131)
	end

	return v131
end

return SquadLobby
