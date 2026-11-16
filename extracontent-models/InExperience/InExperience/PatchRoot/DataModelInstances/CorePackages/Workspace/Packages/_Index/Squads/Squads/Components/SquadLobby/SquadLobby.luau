local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent

local RoactNavigation = require(parent.RoactNavigation)
local UIBlox = require(parent.UIBlox)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useLocalUserId = RobloxAppHooks.useLocalUserId
local CrossExperienceVoice = require(parent.CrossExperienceVoice)
local useVoiceStatus = CrossExperienceVoice.Hooks.useVoiceStatus

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
local SquadLobbyJoinDialogContainer = require(script.Parent.SquadLobbyJoinDialog.SquadLobbyJoinDialogContainer)
local SquadPartySheetActionEnum = require(Squads.Enums.SquadPartySheetActionEnum)
local SquadUserPartyStatus = require(Squads.Enums.SquadUserPartyStatus)

local cryo = dependencies.Cryo
local foundation = dependencies.Foundation
local luauPolyfill = dependencies.LuauPolyfill
local networkingPresence = dependencies.NetworkingPresence
local networkingSquads = dependencies.NetworkingSquads
local react = dependencies.React
local roact = dependencies.Roact
local sharedFlags = dependencies.SharedFlags
local Enums = require(parent.SquadsCore.Enums)
local EventNames = require(parent.SquadsCore.EventNames)

local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local SquadPromptType = Enums.SquadPromptType
local SquadCoplayJoin = Enums.SquadCoplayJoin
local SquadExternalContractProvider2 = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadViewFlags = SquadExternalContractProvider2.SquadViewFlags
local SquadSessionProvider = require(parent.SquadsCore.SquadSessionProvider)
local SquadLobbySessionProvider = SquadSessionProvider.SquadLobbySessionProvider
local logInExpCoplayTelemetry = require(parent.SquadsCore.logInExpCoplayTelemetry)
local Thunks = require(parent.SquadsCore.Thunks)
local createOrJoinSquad = Thunks.createOrJoinSquad
local userBlockingNetworking = dependencies.UserBlockingNetworking
local useCurrentSquadSelector = dependencies.Hooks.useCurrentSquadSelector
local useDispatch = dependencies.Hooks.useDispatch
local useEffectOnce = dependencies.Hooks.useEffectOnce
local useNavigation = dependencies.useNavigation
local usePrevious = dependencies.Hooks.usePrevious
local useSelector = dependencies.Hooks.useSelector
local useStore = dependencies.Hooks.useStore
local Hooks = require(parent.SquadsCore.Hooks)
local useSquadState = Hooks.useSquadState
local presenceType = dependencies.RoduxPresence.Enums.PresenceType

local Flags = require(parent.SquadsCore.Flags)
local FFlagSquadsPresenceStoreMigration = Flags.FFlagSquadsPresenceStoreMigration
local FFlagSquadsEnableFoundationTestIds = require(Squads.Flags.FFlagSquadsEnableFoundationTestIds)
local DataHydration = require(parent.DataHydration)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local v

if FFlagSquadsPresenceStoreMigration then
	v = DataHydration.Presence.PresenceStore.get()
else
	v = nil
end

local presenceType2

if FFlagSquadsPresenceStoreMigration then
	presenceType2 = DataHydration.Presence.PresenceEnums.PresenceType
else
	presenceType2 = nil
end

local stateLayerAffordance = foundation.Enums.StateLayerAffordance
local useStyle = UIBlox.Core.Style.useStyle
local useTokens = foundation.Hooks.useTokens

local clearInterval = luauPolyfill.clearInterval
local setInterval = luauPolyfill.setInterval

local defineFastFlag = game:DefineFastFlag("EnableSquadLobbyBanners", false)
local fFlagEnableSquadTopBannerWideMode = sharedFlags.FFlagEnableSquadTopBannerWideMode
local fFlagMakeCreateOrJoinSquadAThunks = sharedFlags.FFlagMakeCreateOrJoinSquadAThunks
local defineFastInt = game:DefineFastInt("PartyInviteeNoResponseDurationSeconds", 3)
local defineFastInt2 = game:DefineFastInt("PartyUserInvitedDurationSeconds", 10)
local squadQuickStartExperimentation = dependencies.SocialExperiments.SquadQuickStartExperimentation

local squadCoordinationExperienceJoinExperimentation = dependencies.SocialExperiments.SquadCoordinationExperienceJoinExperimentation
local squadRegroupExperimentation = dependencies.SocialExperiments.SquadRegroupExperimentation
local luckyRecommendationExperimentation = dependencies.SocialExperiments.LuckyRecommendationExperimentation
local fFlagEnablePartyQuickStartButton = sharedFlags.FFlagEnablePartyQuickStartButton
local fFlagEnablePartyVoiceChangersInLua = sharedFlags.FFlagEnablePartyVoiceChangersInLua
local fFlagEnableSquadRegroupExperimentation = sharedFlags.FFlagEnableSquadRegroupExperimentation

local fFlagEnableSquadRegroupExperimentationSmallScreenFix = sharedFlags.FFlagEnableSquadRegroupExperimentationSmallScreenFix
local fFlagEnableSquadRegroupServerCapacityCheck = sharedFlags.FFlagEnableSquadRegroupServerCapacityCheck
local fFlagAppChatShowOSAOnPageEntry = sharedFlags.FFlagAppChatShowOSAOnPageEntry
local FFlagSquadMemberJoinDialogAndOverflowMenu = require(Squads.Flags.FFlagSquadMemberJoinDialogAndOverflowMenu)

local function SquadLobby(props)
	local v2 = useTokens()
	local v3 = useDispatch()
	local v4 = tonumber(useLocalUserId()) or 0
	local v5 = useStyle()
	local squadState = useSquadState()
	local v6 = useNavigation()
	local isWideMode = props.isWideMode
	local v7 = react.useContext(SquadExternalContractContext)
	local state, setState = react.useState(0)

	local voiceStatus = useVoiceStatus()

	if fFlagEnableSquadTopBannerWideMode then
		local ref = react.useRef(HttpService:GenerateGUID())
		react.useEffect(function()
			if isWideMode then
				return function() end
			end

			local current = ref.current
			v7.disableSquadTopBanner(current, true)

			local v8 = v6 and v6.addListener(RoactNavigation.Events.WillBlur, function(p)
				if p.state.routeName == "SquadInviteFriends" or p.state.routeName == "SquadLobby" then
					v7.disableSquadTopBanner(current, true)
				else
					v7.disableSquadTopBanner(current, false)
				end
			end)

			return function()
				if v8 then
					v8.remove()
					v8 = nil
				end

				v7.disableSquadTopBanner(current, false)
			end
		end, { v7.disableSquadTopBanner, v6, isWideMode })

		react.useEffect(function()
			v7.updateSquadViewFlags(SquadViewFlags.SquadLobby, true)
			return function()
				v7.updateSquadViewFlags(SquadViewFlags.SquadLobby, false)
			end
		end, { v7.updateSquadViewFlags })
	else
		react.useEffect(function()
			v7.updateSquadViewFlags(SquadViewFlags.SquadLobby, true)

			local v8 = v6 and v6.addListener(RoactNavigation.Events.WillBlur, function(p)
				if p.state.routeName == "SquadInviteFriends" or p.state.routeName == "SquadLobby" then
					v7.updateSquadViewFlags(SquadViewFlags.SquadLobby, true)
				else
					v7.updateSquadViewFlags(SquadViewFlags.SquadLobby, false)
				end
			end)
			return function()
				if v8 then
					v8.remove()
					v8 = nil
				end

				v7.updateSquadViewFlags(SquadViewFlags.SquadLobby, false)
			end
		end, { v7.updateSquadViewFlags, v6 })
	end

	local state2, setState2 = react.useState(false)
	local state3, setState3 = react.useState(Vector2.zero)
	local v8 = react.useCallback(function(p)
		setState3(p.AbsoluteSize)
	end, { setState3 })

	local v9 = useCurrentSquadSelector()
	local squadId2 = not v9 and "" or v9.squadId
	local members = v9 and v9.members

	local v10 = useSelector((react.useCallback(function(p)
		if p.Squad and p.Squad.Squad and p.Squad.Squad.currentSquad then
			return p.Squad.Squad.currentSquad.parentChannelId or ""
		end

		return ""
	end, {})))

	local v11 = useStore()
	local v12 = v6.getParam("conversationId") or ""
	local v13 = v7.useGetConversationFromId(v12)
	local participants = v13 and v13.participants
	local invitees = v9 and v9.invitees

	local v14 = v6.getParam("extraParams") or {}
	local squadId = v14.squadId
	local squadCreateOrJoinAttemptId

	if squadQuickStartExperimentation.getPartyQuickStartChangesEnabled() and fFlagEnablePartyQuickStartButton then
		squadCreateOrJoinAttemptId = v14.squadCreateOrJoinAttemptId
	else
		squadCreateOrJoinAttemptId = nil
	end

	local scheduledGroupUpId = v14.scheduledGroupUpId

	local v15 = react.useCallback(function()
		v7.setSquadPrompt(v11, {
			hideCancelButton = true,
			promptType = SquadPromptType.Error,
			onConfirm = function()
				props.navigateAwayFromSquad()
			end
		})
	end, { props.navigateAwayFromSquad, v11, v7.setSquadPrompt })

	local useCallback = react.useCallback
	local function fn(parentChannelId: string)
		if fFlagMakeCreateOrJoinSquadAThunks then
			v3(createOrJoinSquad(
				parentChannelId,
				v7.setSquadPrompt,
				v7.fireSquadAnalytics,
				v7.squadLocation,
				squadCreateOrJoinAttemptId,
				props.navigateAwayFromSquad,
				scheduledGroupUpId
			))
		else
			v3(networkingSquads.CreateOrJoinSquad.API({
				parentChannelId = parentChannelId,
				leaveExisting = true,
				squadLocation = v7.squadLocation,
				partyAttemptId = squadCreateOrJoinAttemptId
			})):andThen(function(p)
				local groupUpId = p.responseBody.groupUp.groupUpId
				local members2 = p.responseBody.groupUp.members

				if groupUpId and members2 then
					logInExpCoplayTelemetry(
						groupUpId,
						members2,
						v7.squadLocation,
						SquadCoplayJoin.PartyJoin,
						v7.fireSquadAnalytics
					)
				end
			end):catch(function(_)
				v15()
			end)
		end
	end

	local v16

	if fFlagMakeCreateOrJoinSquadAThunks then
		v16 = createOrJoinSquad
	end

	local navigateAwayFromSquad

	if fFlagMakeCreateOrJoinSquadAThunks then
		navigateAwayFromSquad = props.navigateAwayFromSquad
	end

	local v17

	if not fFlagMakeCreateOrJoinSquadAThunks then
		v17 = v15
	end

	local v18

	if fFlagMakeCreateOrJoinSquadAThunks then
		v18 = v7.setSquadPrompt
	end

	local v19 = useCallback(fn, {
		v3,
		v16,
		navigateAwayFromSquad,
		v17,
		v18,
		v7.squadLocation,
		v7.fireSquadAnalytics,
		squadCreateOrJoinAttemptId,
		scheduledGroupUpId
	})
	local v20 = squadId and squadId ~= squadId2
	react.useEffect(function()
		if v20 then
			v7.setSquadPrompt(v11, {
				promptType = SquadPromptType.JoinAnotherSquad,
				onConfirm = function()
					v19(v12)
				end,
				onCancel = function()
					props.navigateAwayFromSquad()
				end
			})

			v6.setParams({ squadId = nil })
		end
	end, { squadId, v7.setSquadPrompt, v19, v12, props.navigateAwayFromSquad, v20 })

	useEffectOnce(function()
		if v20 then
			return
		end

		if
			fFlagAppChatShowOSAOnPageEntry
			and v7.shouldShowOSAForConversation
			and v7.shouldShowOSAForConversation(v13)
		then
			props.navigateAwayFromSquad()
		elseif squadId2 == "" then
			if v13 and v13.source == "friends" then
				Logger:debug("Channel does not exist for: {}. Creating a friend conversation.", v12)

				v3(v7.createFriendConversation(v12)):andThen(function(p)
					if p and p.id then
						v19(p.id)
					end
				end):catch(function(p)
					Logger:debug("Error while trying to create a friend conversation: {}", p)
					v15()
				end)
			else
				v19(v12)
			end
		end
	end, { v3, v7.createFriendConversation, v12, v13, v19, v15 })

	local state4, setState4 = react.useState({})

	local v21 = react.useMemo(function()
		local userIdSet = {}

		if members then
			for _, member in ipairs(members) do
				userIdSet[tostring(member.userId)] = true
			end
		end

		return userIdSet
	end, { members })

	local v22 = react.useCallback(function(list, p, p2)
		local users = {}
		local count = 0

		if p and #cryo.Dictionary.keys(p) == 0 then
			table.insert(users, { userId = v4, partyStatus = SquadUserPartyStatus.Connecting })
		elseif list then
			local now = os.time()

			for _, item in ipairs(list) do
				local partyStatus = SquadUserPartyStatus.Inactive

				if p[item] then
					partyStatus = SquadUserPartyStatus.Active
				else
					local v22 = p2 and cryo.List.findWhere(p2, function(p3): boolean
						return item == tostring(p3.userId)
					end)

					if v22 then
						local v23 = math.floor(p2[v22].invitedAtTimestampMs / 1000) or 0

						if now < v23 then
							continue
						end

						if now - v23 < defineFastInt2 then
							partyStatus = SquadUserPartyStatus.Invited
							count += 1
						elseif now - v23 < defineFastInt + defineFastInt2 then
							partyStatus = SquadUserPartyStatus.NoResponse
							count += 1
						end
					end
				end

				table.insert(users, { userId = tonumber(item), partyStatus = partyStatus })
			end
		end

		return { users = users, numberOfUpdatesPending = count }
	end, {})

	react.useEffect(function()
		setState4(v22(participants, v21, invitees).users)

		local v23 = nil
		v23 = setInterval(function()
			local v24 = v22(participants, v21, invitees)
			setState4(v24.users)

			if v24.numberOfUpdatesPending == 0 then
				clearInterval(v23)
			end
		end, 1000)

		return function()
			clearInterval(v23)
		end
	end, { v21, invitees, participants, v22 })

	local v23 = usePrevious(squadId2) or ""
	react.useEffect(function()
		if v23 ~= "" and squadId2 == "" then
			props.navigateAwayFromSquad()
		elseif squadId2 ~= "" and v12 ~= "" and v10 ~= "" and v10 ~= v12 then
			local actions = {
				RoactNavigation.Actions.navigate({
					routeName = "ChatConversation",
					params = { conversationId = v10 }
				}),
				RoactNavigation.Actions.navigate({
					routeName = "SquadLobby",
					params = { conversationId = v10 }
				})
			}

			if isWideMode then
				v6.navigate(
					"ChatLanding",
					{ conversationId = v10 },
					RoactNavigation.StackActions.reset({ index = 2, actions = actions })
				)
			else
				table.insert(actions, 1, RoactNavigation.Actions.navigate({
					routeName = "ChatLanding"
				}))

				v6.navigate(
					"ChatLandingStack",
					{ conversationId = v10 },
					RoactNavigation.StackActions.reset({ index = 3, actions = actions })
				)
			end
		end
	end, { v6, v10, v12, squadId2, props.navigateAwayFromSquad })

	local v24 = usePrevious(members)
	react.useEffect(function()
		local userIds = {}

		if members then
			for _, member in pairs(members) do
				local v25 = false

				if v24 then
					for _, v26 in pairs(v24) do
						if v26.userId == member.userId then
							v25 = true
							break
						end
					end
				end

				if v25 then
					continue
				end

				table.insert(userIds, member.userId)

				if v4 ~= member.userId then
					v3(userBlockingNetworking.IsBlockedById.API({
						userId = member.userId,
						currentUserId = v4
					}))
				end
			end
		end

		if not FFlagSquadsPresenceStoreMigration then
			v3(networkingPresence.GetPresencesFromUserIds.API(userIds))
		end
	end, { members, v4, v24 })

	local toggleVoiceChatMenu = react.useCallback(function()
		setState2(not state2)
	end, { state2, setState2 })

	local v25 = Constants.SQUAD_LOBBY_ACTION_BAR_HEIGHT + 26 + 20

	local v26 = Constants.SQUAD_LOBBY_ACTION_BAR_HEIGHT + 20
	local state5, setState5 = react.useState(nil)
	local state6, setState6 = react.useState(false)

	local onAbsoluteSizeChanged = react.useCallback(function(vector2: Vector2)
		if vector2.Y > 0 then
			setState(vector2.Y + v2.Gap.Medium)
		else
			setState(0)
		end
	end, { setState, v2 })

	local v27 = react.useCallback(function(p)
		local byUserId = p.Squad and p.Squad.Presence and p.Squad.Presence.byUserId or {}
		local result = {}

		for _, v27 in ipairs(members or {}) do
			local userId = tostring(v27.userId)
			result[userId] = byUserId[userId]
		end

		return result
	end, { members })
	local v28

	if FFlagSquadsPresenceStoreMigration then
		v28 = react.useMemo(function()
			return Signals.createComputed(function(p)
				local result = {}

				for _, v29 in ipairs(members or {}) do
					local userId = tostring(v29.userId)
					result[userId] = v.GetPresenceByUserId(userId).data(p)
				end

				return result
			end)
		end, { members })
	end

	local v29

	if FFlagSquadsPresenceStoreMigration then
		v29 = useSignalState(v28)
	else
		v29 = useSelector(v27)
	end

	local v30 = not fFlagEnableSquadRegroupServerCapacityCheck or Players.MaxPlayers > 1

	local v31 = react.useMemo(function(): boolean
		if not (squadRegroupExperimentation.getSquadRegroupEnabled() and props.isInExperience and v30 and v9 and v9.members and #v9.members > 1 and v9.selfPermissions and v9.selfPermissions.canSeeRegroupJoinButton) then
			return false
		end

		local v31 = v29[tostring(v4)]

		if v31 == nil then
			return false
		end

		for k, v32 in pairs(v29) do
			if v32 ~= nil and k ~= tostring(v4) then
				local userPresenceType = v32.userPresenceType
				local v40

				if FFlagSquadsPresenceStoreMigration then
					v40 = presenceType2.Online
				else
					v40 = presenceType.Online
				end

				if userPresenceType == v40 then
					return true
				end

				local userPresenceType2 = v32.userPresenceType
				local v41

				if FFlagSquadsPresenceStoreMigration then
					v41 = presenceType2.InGame
				else
					v41 = presenceType.InGame
				end

				if
					userPresenceType2 ~= v41
					or v31.gameId == (FFlagSquadsPresenceStoreMigration and "" or nil)
					or v32.gameId == (FFlagSquadsPresenceStoreMigration and "" or nil)
					or v31.gameId == v32.gameId
				then
					continue
				end

				return true
			end
		end

		return false
	end, { v29, v4, props.isInExperience, v9, v30 })
	local v32

	if luckyRecommendationExperimentation.getLuckyRecommendationEnabled() then
		local v39 = members ~= nil and #members >= 2
		v32 = not props.isInExperience and v39
	else
		v32 = false
	end

	local v39 = v2.Size.Size_1000 + v2.Padding.Medium * 2
	local v40 = fFlagEnableSquadRegroupExperimentationSmallScreenFix and v31

	local v41 = (not v31 or v40) and not v32 and 0 or v2.Gap.XXLarge + v39

	local squadLobbyBanners = react.useMemo(function()
		if defineFastFlag then
			return (react.createElement(SquadLobbyBanners, {
				onAbsoluteSizeChanged = onAbsoluteSizeChanged
			}))
		end

		return nil
	end, { onAbsoluteSizeChanged })

	local navigateToSquadInviteFriends = react.useCallback(function()
		props.navigateToSquadInviteFriends(v10)
	end, { v10, props.navigateToSquadInviteFriends })

	local useMemo = react.useMemo
	local function fn2()
		local createElement = react.createElement
		local v45 = {
			Position = UDim2.fromOffset(0, state),
			Size = UDim2.new(1, 0, 1, -(state + v41)),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollBarImageColor3 = v5.Theme.UIEmphasis.Color,
			ScrollBarImageTransparency = v5.Theme.UIEmphasis.Transparency,
			ScrollBarThickness = 4,
			Selectable = false,
			ZIndex = 0,
			[react.Change.AbsoluteSize] = v8
		}
		local frameContents

		if v40 then
			frameContents = react.createElement(
				foundation.View,
				{ tag = "auto-y size-full-0 bg-surface-0 col align-x-center align-y-top" },
				{
					UserGridContainer = react.createElement(
						foundation.View,
						{ tag = "auto-y size-full-0 bg-surface-0", LayoutOrder = 1 },
						{
							SquadLobbyUserGrid = react.createElement(SquadLobbyUserGrid, {
								containerSize = state3 - Vector2.new(0, v25 + v2.Gap.Medium + v39),
								paddingBottom = UDim.new(0, 0),
								users = state4,
								isInExperience = props.isInExperience,
								onUserCardActivated = function(p: string)
									v7.fireSquadAnalytics(EventNames.PartySheetAction, {
										parentChannelId = v10,
										actionType = SquadPartySheetActionEnum.UserCardClicked,
										voiceStatus = voiceStatus
									})

									setState5(p)
									setState6(true)
								end,
								navigateToHomePage = props.navigateToHomePage,
								navigateToSquadInviteFriends = navigateToSquadInviteFriends,
								openSquadVoiceAbuseReport = props.openSquadVoiceAbuseReport
							})
						}
					),
					RegroupRowSpacer = react.createElement(foundation.View, {
						tag = "bg-surface-0",
						Size = UDim2.new(1, 0, 0, v2.Gap.Medium),
						LayoutOrder = 2
					}),
					SquadLobbyRegroupRow = react.createElement(
						foundation.View,
						{ tag = "bg-surface-0", Size = UDim2.new(1, 0, 0, v39), LayoutOrder = 3 },
						{
							Row = react.createElement(SquadLobbyRegroupRow, { localUserId = v4 })
						}
					),
					BottomPadding = react.createElement(foundation.View, {
						tag = "bg-surface-0",
						Size = UDim2.new(1, 0, 0, v25),
						LayoutOrder = 4
					})
				}
			)
		end

		local squadLobbyUserGrid

		if not v40 then
			squadLobbyUserGrid = react.createElement(SquadLobbyUserGrid, {
				containerSize = state3 - Vector2.new(0, v25),
				paddingBottom = UDim.new(0, v25),
				users = state4,
				isInExperience = props.isInExperience,
				onUserCardActivated = function(p: string)
					v7.fireSquadAnalytics(EventNames.PartySheetAction, {
						parentChannelId = v10,
						actionType = SquadPartySheetActionEnum.UserCardClicked,
						voiceStatus = voiceStatus
					})

					setState5(p)
					setState6(true)
				end,
				navigateToHomePage = props.navigateToHomePage,
				navigateToSquadInviteFriends = navigateToSquadInviteFriends,
				openSquadVoiceAbuseReport = props.openSquadVoiceAbuseReport
			})
		end

		return createElement("ScrollingFrame", v45, {
			FrameContents = frameContents,
			SquadLobbyUserGrid = squadLobbyUserGrid
		})
	end

	local navigateToHomePage = props.navigateToHomePage
	local v45

	if v31 or v32 then
		v45 = v41
	end

	local v46

	if v40 then
		v46 = v39
	end

	local v47

	if v40 then
		v47 = v4
	end

	local squadLobbyUsersScrollingFrame = useMemo(fn2, {
		setState5,
		setState6,
		state3,
		members,
		navigateToSquadInviteFriends,
		v8,
		navigateToHomePage,
		v25,
		state,
		v45,
		state4,
		v40,
		v46,
		v47,
		voiceStatus,
		props.openSquadVoiceAbuseReport
	})

	local squadLobbyActionBar = react.useMemo(function()
		local createElement = react.createElement
		local v50 = {
			squadState = squadState,
			anchorPoint = Vector2.new(0.5, 1),
			hasUnreadMessages = 0,
			navigateAwayFromSquad = 0,
			navigateToChat = 0,
			navigateToHomePage = 0,
			toggleVoiceChatMenu = 0,
			position = 0,
			squadId = 0,
			isInExperience = 0
		}
		local hasUnreadMessages

		if v13 and v13.hasUnreadMessages then
			hasUnreadMessages = v13.hasUnreadMessages
		else
			hasUnreadMessages = false
		end

		v50.hasUnreadMessages = hasUnreadMessages

		v50.navigateAwayFromSquad = props.navigateAwayFromSquad
		v50.navigateToChat = props.navigateToChat
		v50.navigateToHomePage = props.navigateToHomePage
		v50.toggleVoiceChatMenu = toggleVoiceChatMenu
		v50.position = UDim2.new(0.5, 0, 1, -20)
		v50.squadId = squadId2
		v50.isInExperience = props.isInExperience
		return createElement(SquadLobbyActionBar, v50)
	end, {
		squadId2,
		props.isInExperience,
		props.navigateToChat,
		props.navigateToHomePage,
		squadState,
		toggleVoiceChatMenu,
		v13 and v13.hasUnreadMessages
	})

	local squadLobbyRegroupRow = react.useMemo(function()
		if v40 or not v31 then
			return nil
		end

		return react.createElement(foundation.View, {
			tag = "anchor-bottom-center auto-none gui-object-defaults",
			Position = UDim2.new(0.5, 0, 1, -(20 + Constants.SQUAD_LOBBY_ACTION_BAR_HEIGHT + v2.Gap.XXLarge)),
			Size = UDim2.new(1, 0, 0, v39)
		}, {
			Row = react.createElement(SquadLobbyRegroupRow, { localUserId = v4 })
		})
	end, { v31, v4, v2, v39 })

	local squadLobbyLuckyRecommendationRow = react.useMemo(function()
		if v32 then
			return react.createElement(foundation.View, {
				tag = "anchor-bottom-center auto-none gui-object-defaults",
				Position = UDim2.new(0.5, 0, 1, -(20 + Constants.SQUAD_LOBBY_ACTION_BAR_HEIGHT + v2.Gap.XXLarge)),
				Size = UDim2.new(1, 0, 0, v39)
			}, {
				Row = react.createElement(SquadLobbyLuckyRecommendationRow)
			})
		end

		return nil
	end, { v32, v2, v39 })

	local squadLobbyVoiceChatMenu = react.useMemo(function()
		if not state2 then
			return nil
		end

		local createElement = react.createElement
		local view = foundation.View
		local v53 = {
			Size = UDim2.new(1, 0, 1, 0),
			stateLayer = { affordance = stateLayerAffordance.None },
			onActivated = function()
				setState2(false)
			end,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby--voice-chat-menu-backdrop" or nil
		}

		local createElement2 = react.createElement
		local scrollView = foundation.ScrollView
		local v55 = {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			sizeConstraint = { MaxSize = Vector2.new(350, 1e999) },
			scroll = {
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				CanvasSize = UDim2.new(1, 0, 1, 0),
				ScrollingDirection = Enum.ScrollingDirection.Y
			},
			layout = {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder
			}
		}

		local children = {
			FlexibleSpace = react.createElement(foundation.View, {
				Size = UDim2.new(1, 0, 0, v26),
				flexItem = { FlexMode = Enum.UIFlexMode.Fill },
				LayoutOrder = 1,
				stateLayer = { affordance = stateLayerAffordance.None },
				onActivated = function()
					setState2(false)
				end
			}),
			Menu = 0,
			BottomPadding = 0
		}

		local createElement3 = react.createElement
		local view2 = foundation.View
		local v56 = {
			Size = UDim2.new(1, 0, 1, 0),
			flexItem = { ItemLineAlignment = Enum.ItemLineAlignment.Center },
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 2,
			padding = Vector2.new(v2.Padding.XLarge, v2.Padding.Medium),
			stateLayer = { affordance = stateLayerAffordance.None },
			onActivated = function() end,
			ZIndex = 3
		}

		local createElement4 = react.createElement
		local openSquadVoiceChangers

		if fFlagEnablePartyVoiceChangersInLua then
			openSquadVoiceChangers = props.openSquadVoiceChangers
		end

		children.Menu = createElement3(view2, v56, {
			SquadLobbyVoiceChatMenu = createElement4(SquadLobbyVoiceChatMenu, {
				openSquadVoiceChangers = openSquadVoiceChangers
			})
		})

		children.BottomPadding = react.createElement(foundation.View, {
			Size = UDim2.new(1, 0, 0, v26),
			LayoutOrder = 3,
			stateLayer = { affordance = stateLayerAffordance.None },
			onActivated = function()
				setState2(false)
			end
		})
		return (createElement(view, v53, { createElement2(scrollView, v55, children) }))
	end, { v26, state2, setState2, v2 })

	local userDropdownMenu = react.useMemo(function()
		if FFlagSquadMemberJoinDialogAndOverflowMenu then
			if state6 and state5 then
				return (react.createElement(SquadLobbyJoinDialogContainer, {
					userId = state5,
					isInExperience = props.isInExperience,
					onClose = function()
						setState5(nil)
						setState6(false)
					end,
					openViewProfile = props.openViewProfile
				}))
			end

			return nil
		elseif state6 and state5 then
			return (react.createElement(SquadLobbyUserDropdownMenu, {
				userId = state5,
				isInExperience = props.isInExperience,
				onDismiss = function()
					setState5(nil)
					setState6(false)
				end,
				openViewProfile = function()
					props.openViewProfile(state5)
				end,
				openSquadVoiceAbuseReport = props.openSquadVoiceAbuseReport,
				parentChannelId = v10
			}))
		else
			return nil
		end
	end, { v10, props.isInExperience, state6, setState6, props.openViewProfile, state5, setState5 })

	react.useEffect(function()
		squadCoordinationExperienceJoinExperimentation.logExposure()

		if fFlagEnableSquadRegroupExperimentation then
			squadRegroupExperimentation.logExposure()
		end

		luckyRecommendationExperimentation.logExposure()
	end, {})

	local fragment = roact.createFragment({
		SquadLobbyBanners = squadLobbyBanners,
		SquadLobbyUsersScrollingFrame = squadLobbyUsersScrollingFrame,
		SquadLobbyRegroupRow = squadLobbyRegroupRow,
		SquadLobbyLuckyRecommendationRow = squadLobbyLuckyRecommendationRow,
		SquadLobbyActionBar = squadLobbyActionBar,
		SquadLobbyVoiceChatMenu = squadLobbyVoiceChatMenu,
		UserDropdownMenu = userDropdownMenu
	})

	if squadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then
		fragment = react.createElement(SquadLobbySessionProvider.Provider, nil, fragment)
	end

	return fragment
end

return SquadLobby
