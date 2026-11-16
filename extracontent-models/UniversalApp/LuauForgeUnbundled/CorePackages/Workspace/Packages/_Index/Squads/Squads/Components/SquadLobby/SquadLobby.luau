local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local RoactNavigation = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RoactNavigation")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/UIBlox")
local useLocalUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/RobloxAppHooks").useLocalUserId
local useVoiceStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/CrossExperienceVoice").Hooks.useVoiceStatus

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Common/Constants")
local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")
local Logger = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Logger")
require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Common/ModelTypes")
local module6 = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadLobby/SquadLobbyActionBar")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadLobby/SquadLobbyUserGrid")
local module8 = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadLobby/SquadLobbyRegroupRow")
local module9 = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadLobby/SquadLobbyLuckyRecommendationRow")
local module10 = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadLobby/SquadLobbyVoiceChatMenu")
local module11 = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadLobby/SquadLobbyBanners")
local SquadLobbyUserDropdownMenu = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadLobby/SquadLobbyUserDropdownMenu")
local SquadLobbyJoinDialogContainer = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadLobby/SquadLobbyJoinDialog/SquadLobbyJoinDialogContainer")
local SquadPartySheetActionEnum = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Enums/SquadPartySheetActionEnum")
local SquadUserPartyStatus = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Enums/SquadUserPartyStatus")

local cryo = dependencies.Cryo
local foundation = dependencies.Foundation
local luauPolyfill = dependencies.LuauPolyfill
local networkingPresence = dependencies.NetworkingPresence
local networkingSquads = dependencies.NetworkingSquads
local react = dependencies.React
local roact = dependencies.Roact
local sharedFlags = dependencies.SharedFlags
local Enums = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/EventNames")

local squadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider").SquadExternalContractContext
local squadPromptType = Enums.SquadPromptType
local squadCoplayJoin = Enums.SquadCoplayJoin
local squadViewFlags = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider").SquadViewFlags
local squadLobbySessionProvider = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadSessionProvider").SquadLobbySessionProvider
local logInExpCoplayTelemetry = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/logInExpCoplayTelemetry")
local createOrJoinSquad = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Thunks").createOrJoinSquad
local userBlockingNetworking = dependencies.UserBlockingNetworking
local useCurrentSquadSelector = dependencies.Hooks.useCurrentSquadSelector
local useDispatch = dependencies.Hooks.useDispatch
local useEffectOnce = dependencies.Hooks.useEffectOnce
local useNavigation = dependencies.useNavigation
local usePrevious = dependencies.Hooks.usePrevious
local useSelector = dependencies.Hooks.useSelector
local useStore = dependencies.Hooks.useStore
local useSquadState = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks").useSquadState
local presenceType = dependencies.RoduxPresence.Enums.PresenceType

local fFlagSquadsPresenceStoreMigration = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Flags").FFlagSquadsPresenceStoreMigration
local FFlagSquadsEnableFoundationTestIds = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadsEnableFoundationTestIds")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/DataHydration")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/Signals")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/SignalsReact").useSignalState

local v5 = if fFlagSquadsPresenceStoreMigration then DataHydration.Presence.PresenceStore.get() else nil
local presenceType2

if fFlagSquadsPresenceStoreMigration then
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
local FFlagSquadMemberJoinDialogAndOverflowMenu = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagSquadMemberJoinDialogAndOverflowMenu")

local function SquadLobby(props)
	local v6 = useTokens()
	local v7 = useDispatch()
	local v8 = tonumber(useLocalUserId()) or 0
	local v9 = useStyle()
	local v10 = useSquadState()
	local v11 = useNavigation()
	local isWideMode = props.isWideMode
	local v12 = react.useContext(squadExternalContractContext)
	local state, setState = react.useState(0)

	local v13 = useVoiceStatus()

	if fFlagEnableSquadTopBannerWideMode then
		local ref = react.useRef(HttpService:GenerateGUID())
		react.useEffect(function()
			if isWideMode then
				return function() end
			end

			local current = ref.current
			v12.disableSquadTopBanner(current, true)

			local v14 = v11 and v11.addListener(RoactNavigation.Events.WillBlur, function(p2)
				if p2.state.routeName == "SquadInviteFriends" or p2.state.routeName == "SquadLobby" then
					v12.disableSquadTopBanner(current, true)
				else
					v12.disableSquadTopBanner(current, false)
				end
			end)

			return function()
				if v14 then
					v14.remove()
					v14 = nil
				end

				v12.disableSquadTopBanner(current, false)
			end
		end, { v12.disableSquadTopBanner, v11, isWideMode })

		react.useEffect(function()
			v12.updateSquadViewFlags(squadViewFlags.SquadLobby, true)
			return function()
				v12.updateSquadViewFlags(squadViewFlags.SquadLobby, false)
			end
		end, { v12.updateSquadViewFlags })
	else
		react.useEffect(function()
			v12.updateSquadViewFlags(squadViewFlags.SquadLobby, true)

			local v14 = v11 and v11.addListener(RoactNavigation.Events.WillBlur, function(p2)
				if p2.state.routeName == "SquadInviteFriends" or p2.state.routeName == "SquadLobby" then
					v12.updateSquadViewFlags(squadViewFlags.SquadLobby, true)
				else
					v12.updateSquadViewFlags(squadViewFlags.SquadLobby, false)
				end
			end)
			return function()
				if v14 then
					v14.remove()
					v14 = nil
				end

				v12.updateSquadViewFlags(squadViewFlags.SquadLobby, false)
			end
		end, { v12.updateSquadViewFlags, v11 })
	end

	local state2, setState2 = react.useState(false)
	local state3, setState3 = react.useState(Vector2.zero)
	local v14 = react.useCallback(function(p2)
		setState3(p2.AbsoluteSize)
	end, { setState3 })

	local v15 = useCurrentSquadSelector()
	local v16 = not v15 and "" or v15.squadId
	local members = v15 and v15.members

	local v18 = useSelector((react.useCallback(function(p2)
		if p2.Squad and p2.Squad.Squad and p2.Squad.Squad.currentSquad then
			return p2.Squad.Squad.currentSquad.parentChannelId or ""
		end

		return ""
	end, {})))

	local v19 = useStore()
	local v20 = v11.getParam("conversationId") or ""
	local v21 = v12.useGetConversationFromId(v20)
	local participants = v21 and v21.participants
	local invitees = v15 and v15.invitees

	local v22 = v11.getParam("extraParams") or {}
	local squadId = v22.squadId
	local squadCreateOrJoinAttemptId

	if
		squadQuickStartExperimentation.getPartyQuickStartChangesEnabled()
		and fFlagEnablePartyQuickStartButton
	then
		squadCreateOrJoinAttemptId = v22.squadCreateOrJoinAttemptId
	else
		squadCreateOrJoinAttemptId = nil
	end

	local scheduledGroupUpId = v22.scheduledGroupUpId

	local v23 = react.useCallback(function()
		v12.setSquadPrompt(v19, {
			hideCancelButton = true,
			promptType = squadPromptType.Error,
			onConfirm = function()
				props.navigateAwayFromSquad()
			end
		})
	end, { props.navigateAwayFromSquad, v19, v12.setSquadPrompt })

	local useCallback = react.useCallback
	local function fn(p2)
		if fFlagMakeCreateOrJoinSquadAThunks then
			v7(createOrJoinSquad(
				p2,
				v12.setSquadPrompt,
				v12.fireSquadAnalytics,
				v12.squadLocation,
				squadCreateOrJoinAttemptId,
				props.navigateAwayFromSquad,
				scheduledGroupUpId
			))
		else
			v7(networkingSquads.CreateOrJoinSquad.API({
				parentChannelId = p2,
				leaveExisting = true,
				squadLocation = v12.squadLocation,
				partyAttemptId = squadCreateOrJoinAttemptId
			})):andThen(function(p3)
				local groupUpId = p3.responseBody.groupUp.groupUpId
				local members2 = p3.responseBody.groupUp.members

				if groupUpId and members2 then
					logInExpCoplayTelemetry(
						groupUpId,
						members2,
						v12.squadLocation,
						squadCoplayJoin.PartyJoin,
						v12.fireSquadAnalytics
					)
				end
			end):catch(function(p3)
				v23()
			end)
		end
	end

	local v25 = if fFlagMakeCreateOrJoinSquadAThunks then createOrJoinSquad else nil
	local navigateAwayFromSquad = if fFlagMakeCreateOrJoinSquadAThunks then props.navigateAwayFromSquad else nil
	local v26 = if not fFlagMakeCreateOrJoinSquadAThunks then v23 else nil
	local v27 = if fFlagMakeCreateOrJoinSquadAThunks then v12.setSquadPrompt else nil
	local v28 = useCallback(fn, {
		v7,
		v25,
		navigateAwayFromSquad,
		v26,
		v27,
		v12.squadLocation,
		v12.fireSquadAnalytics,
		squadCreateOrJoinAttemptId,
		scheduledGroupUpId
	})
	local v29 = squadId and squadId ~= v16
	react.useEffect(function()
		if v29 then
			v12.setSquadPrompt(v19, {
				promptType = squadPromptType.JoinAnotherSquad,
				onConfirm = function()
					v28(v20)
				end,
				onCancel = function()
					props.navigateAwayFromSquad()
				end
			})

			v11.setParams({ squadId = nil })
		end
	end, { squadId, v12.setSquadPrompt, v28, v20, props.navigateAwayFromSquad, v29 })

	useEffectOnce(function()
		if v29 then
			return
		end

		if
			fFlagAppChatShowOSAOnPageEntry
			and v12.shouldShowOSAForConversation
			and v12.shouldShowOSAForConversation(v21)
		then
			props.navigateAwayFromSquad()
		elseif v16 == "" then
			if v21 and v21.source == "friends" then
				Logger:debug("Channel does not exist for: {}. Creating a friend conversation.", v20)

				v7(v12.createFriendConversation(v20)):andThen(function(p2)
					if p2 and p2.id then
						v28(p2.id)
					end
				end):catch(function(p2)
					Logger:debug("Error while trying to create a friend conversation: {}", p2)
					v23()
				end)
			else
				v28(v20)
			end
		end
	end, { v7, v12.createFriendConversation, v20, v21, v28, v23 })

	local state4, setState4 = react.useState({})

	local v30 = react.useMemo(function()
		local userIdSet = {}

		if members then
			for i, member in ipairs(members) do
				userIdSet[tostring(member.userId)] = true
			end
		end

		return userIdSet
	end, { members })

	local v31 = react.useCallback(function(list, p2, p3)
		local v32 = {}
		local count = 0

		if p2 and #cryo.Dictionary.keys(p2) == 0 then
			table.insert(v32, { userId = v8, partyStatus = SquadUserPartyStatus.Connecting })
		elseif list then
			local now = os.time()

			for i, item in ipairs(list) do
				local v33 = SquadUserPartyStatus.Inactive

				if p2[item] then
					v33 = SquadUserPartyStatus.Active
				else
					local v34 = p3 and cryo.List.findWhere(p3, function(p4): boolean
						return item == tostring(p4.userId)
					end)

					if v34 then
						local v35 = math.floor(p3[v34].invitedAtTimestampMs / 1000) or 0

						if now < v35 then
							continue
						end

						if now - v35 < defineFastInt2 then
							v33 = SquadUserPartyStatus.Invited
							count += 1
						elseif now - v35 < defineFastInt + defineFastInt2 then
							v33 = SquadUserPartyStatus.NoResponse
							count += 1
						end
					end
				end

				table.insert(v32, { userId = tonumber(item), partyStatus = v33 })
			end
		end

		return { users = v32, numberOfUpdatesPending = count }
	end, {})

	react.useEffect(function()
		setState4(v31(participants, v30, invitees).users)

		local v33 = nil
		v33 = setInterval(function()
			local v34 = v31(participants, v30, invitees)
			setState4(v34.users)

			if v34.numberOfUpdatesPending == 0 then
				clearInterval(v33)
			end
		end, 1000)

		return function()
			clearInterval(v33)
		end
	end, { v30, invitees, participants, v31 })

	local v32 = usePrevious(v16) or ""
	react.useEffect(function()
		if v32 ~= "" and v16 == "" then
			props.navigateAwayFromSquad()
		elseif v16 ~= "" and v20 ~= "" and v18 ~= "" and v18 ~= v20 then
			local v33 = {
				RoactNavigation.Actions.navigate({
					routeName = "ChatConversation",
					params = { conversationId = v18 }
				}),
				RoactNavigation.Actions.navigate({
					routeName = "SquadLobby",
					params = { conversationId = v18 }
				})
			}

			if isWideMode then
				v11.navigate(
					"ChatLanding",
					{ conversationId = v18 },
					RoactNavigation.StackActions.reset({ index = 2, actions = v33 })
				)
			else
				table.insert(v33, 1, RoactNavigation.Actions.navigate({
					routeName = "ChatLanding"
				}))

				v11.navigate(
					"ChatLandingStack",
					{ conversationId = v18 },
					RoactNavigation.StackActions.reset({ index = 3, actions = v33 })
				)
			end
		end
	end, { v11, v18, v20, v16, props.navigateAwayFromSquad })

	local v33 = usePrevious(members)
	react.useEffect(function()
		local userIds = {}

		if members then
			for k, member in pairs(members) do
				local v34 = false

				if v33 then
					for k2, v36 in pairs(v33) do
						if v36.userId == member.userId then
							v34 = true
							break
						end
					end
				end

				if v34 then
					continue
				end

				table.insert(userIds, member.userId)

				if v8 ~= member.userId then
					v7(userBlockingNetworking.IsBlockedById.API({
						userId = member.userId,
						currentUserId = v8
					}))
				end
			end
		end

		if not fFlagSquadsPresenceStoreMigration then
			v7(networkingPresence.GetPresencesFromUserIds.API(userIds))
		end
	end, { members, v8, v33 })

	local v34 = react.useCallback(function()
		setState2(not state2)
	end, { state2, setState2 })

	local v35 = Constants.SQUAD_LOBBY_ACTION_BAR_HEIGHT + 26 + 20

	local v36 = Constants.SQUAD_LOBBY_ACTION_BAR_HEIGHT + 20
	local state5, setState5 = react.useState(nil)
	local state6, setState6 = react.useState(false)

	local v37 = react.useCallback(function(p2)
		if p2.Y > 0 then
			setState(p2.Y + v6.Gap.Medium)
		else
			setState(0)
		end
	end, { setState, v6 })

	local v38 = react.useCallback(function(p2)
		local byUserId = p2.Squad and p2.Squad.Presence and p2.Squad.Presence.byUserId or {}
		local result = {}

		for i, v39 in ipairs(members or {}) do
			local userId = tostring(v39.userId)
			result[userId] = byUserId[userId]
		end

		return result
	end, { members })
	local v39

	if fFlagSquadsPresenceStoreMigration then
		v39 = react.useMemo(function()
			return Signals.createComputed(function(p2)
				local result = {}

				for i, v40 in ipairs(members or {}) do
					local userId = tostring(v40.userId)
					result[userId] = v5.GetPresenceByUserId(userId).data(p2)
				end

				return result
			end)
		end, { members })
	end

	local v40 = if fFlagSquadsPresenceStoreMigration then useSignalState(v39) else useSelector(v38)

	local v41 = not fFlagEnableSquadRegroupServerCapacityCheck or Players.MaxPlayers > 1

	local v42 = react.useMemo(function(): boolean
		if not (squadRegroupExperimentation.getSquadRegroupEnabled() and props.isInExperience and v41 and v15 and v15.members and #v15.members > 1 and v15.selfPermissions and v15.selfPermissions.canSeeRegroupJoinButton) then
			return false
		end

		local v43 = v40[tostring(v8)]

		if v43 == nil then
			return false
		end

		for k, v44 in pairs(v40) do
			if v44 ~= nil and k ~= tostring(v8) then
				local userPresenceType = v44.userPresenceType

				local v45 = if fFlagSquadsPresenceStoreMigration then presenceType2.Online else presenceType.Online

				if userPresenceType == v45 then
					return true
				end

				local userPresenceType2 = v44.userPresenceType

				local v46 = if fFlagSquadsPresenceStoreMigration then presenceType2.InGame else presenceType.InGame

				if
					userPresenceType2 ~= v46
					or v43.gameId == (fFlagSquadsPresenceStoreMigration and "" or nil)
					or v44.gameId == (fFlagSquadsPresenceStoreMigration and "" or nil)
					or v43.gameId == v44.gameId
				then
					continue
				end

				return true
			end
		end

		return false
	end, { v40, v8, props.isInExperience, v15, v41 })
	local v43

	if luckyRecommendationExperimentation.getLuckyRecommendationEnabled() then
		local v44 = members ~= nil and #members >= 2
		v43 = not props.isInExperience and v44
	else
		v43 = false
	end

	local v44 = v6.Size.Size_1000 + v6.Padding.Medium * 2
	local v45 = fFlagEnableSquadRegroupExperimentationSmallScreenFix and v42

	local v46 = (not v42 or v45) and not v43 and 0 or v6.Gap.XXLarge + v44

	local v47 = react.useMemo(function()
		if defineFastFlag then
			return (react.createElement(module11, { onAbsoluteSizeChanged = v37 }))
		end

		return nil
	end, { v37 })

	local v48 = react.useCallback(function()
		props.navigateToSquadInviteFriends(v18)
	end, { v18, props.navigateToSquadInviteFriends })

	local useMemo = react.useMemo
	local function fn2()
		local createElement = react.createElement
		local v50 = {
			Position = UDim2.fromOffset(0, state),
			Size = UDim2.new(1, 0, 1, -(state + v46)),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			CanvasSize = UDim2.new(),
			ScrollingDirection = Enum.ScrollingDirection.Y,
			ScrollBarImageColor3 = v9.Theme.UIEmphasis.Color,
			ScrollBarImageTransparency = v9.Theme.UIEmphasis.Transparency,
			ScrollBarThickness = 4,
			Selectable = false,
			ZIndex = 0,
			[react.Change.AbsoluteSize] = v14
		}
		local v52

		if v45 then
			v52 = react.createElement(
				foundation.View,
				{
					tag = "auto-y size-full-0 bg-surface-0 col align-x-center align-y-top"
				},
				{
					UserGridContainer = react.createElement(
						foundation.View,
						{ tag = "auto-y size-full-0 bg-surface-0", LayoutOrder = 1 },
						{
							SquadLobbyUserGrid = react.createElement(module7, {
								containerSize = state3 - Vector2.new(0, v35 + v6.Gap.Medium + v44),
								paddingBottom = UDim.new(0, 0),
								users = state4,
								isInExperience = props.isInExperience,
								onUserCardActivated = function(p2)
									v12.fireSquadAnalytics(EventNames.PartySheetAction, {
										parentChannelId = v18,
										actionType = SquadPartySheetActionEnum.UserCardClicked,
										voiceStatus = v13
									})

									setState5(p2)
									setState6(true)
								end,
								navigateToHomePage = props.navigateToHomePage,
								navigateToSquadInviteFriends = v48,
								openSquadVoiceAbuseReport = props.openSquadVoiceAbuseReport
							})
						}
					),
					RegroupRowSpacer = react.createElement(foundation.View, {
						tag = "bg-surface-0",
						Size = UDim2.new(1, 0, 0, v6.Gap.Medium),
						LayoutOrder = 2
					}),
					SquadLobbyRegroupRow = react.createElement(
						foundation.View,
						{
							tag = "bg-surface-0",
							Size = UDim2.new(1, 0, 0, v44),
							LayoutOrder = 3
						},
						{
							Row = react.createElement(module8, { localUserId = v8 })
						}
					),
					BottomPadding = react.createElement(foundation.View, {
						tag = "bg-surface-0",
						Size = UDim2.new(1, 0, 0, v35),
						LayoutOrder = 4
					})
				}
			)
		end

		local v53

		if not v45 then
			v53 = react.createElement(module7, {
				containerSize = state3 - Vector2.new(0, v35),
				paddingBottom = UDim.new(0, v35),
				users = state4,
				isInExperience = props.isInExperience,
				onUserCardActivated = function(p2)
					v12.fireSquadAnalytics(EventNames.PartySheetAction, {
						parentChannelId = v18,
						actionType = SquadPartySheetActionEnum.UserCardClicked,
						voiceStatus = v13
					})

					setState5(p2)
					setState6(true)
				end,
				navigateToHomePage = props.navigateToHomePage,
				navigateToSquadInviteFriends = v48,
				openSquadVoiceAbuseReport = props.openSquadVoiceAbuseReport
			})
		end

		return createElement("ScrollingFrame", v50, {
			FrameContents = v52,
			SquadLobbyUserGrid = v53
		})
	end

	local navigateToHomePage = props.navigateToHomePage
	local v50 = if v42 or v43 then v46 else nil
	local v51 = if v45 then v44 else nil
	local v53 = useMemo(fn2, {
		setState5,
		setState6,
		state3,
		members,
		v48,
		v14,
		navigateToHomePage,
		v35,
		state,
		v50,
		state4,
		v45,
		v51,
		if v45 then v8 else nil,
		v13,
		props.openSquadVoiceAbuseReport
	})

	local v54 = react.useMemo(function()
		local createElement = react.createElement
		local v56 = {
			squadState = v10,
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
		local v57 = if v21 and v21.hasUnreadMessages then v21.hasUnreadMessages else false
		v56.hasUnreadMessages = v57

		v56.navigateAwayFromSquad = props.navigateAwayFromSquad
		v56.navigateToChat = props.navigateToChat
		v56.navigateToHomePage = props.navigateToHomePage
		v56.toggleVoiceChatMenu = v34
		v56.position = UDim2.new(0.5, 0, 1, -20)
		v56.squadId = v16
		v56.isInExperience = props.isInExperience
		return createElement(module6, v56)
	end, {
		v16,
		props.isInExperience,
		props.navigateToChat,
		props.navigateToHomePage,
		v10,
		v34,
		v21 and v21.hasUnreadMessages
	})

	local v55 = react.useMemo(function()
		if v45 or not v42 then
			return nil
		end

		return react.createElement(foundation.View, {
			tag = "anchor-bottom-center auto-none gui-object-defaults",
			Position = UDim2.new(0.5, 0, 1, -(20 + Constants.SQUAD_LOBBY_ACTION_BAR_HEIGHT + v6.Gap.XXLarge)),
			Size = UDim2.new(1, 0, 0, v44)
		}, {
			Row = react.createElement(module8, { localUserId = v8 })
		})
	end, { v42, v8, v6, v44 })

	local v56 = react.useMemo(function()
		if v43 then
			return react.createElement(foundation.View, {
				tag = "anchor-bottom-center auto-none gui-object-defaults",
				Position = UDim2.new(
					0.5,
					0,
					1,
					-(20 + Constants.SQUAD_LOBBY_ACTION_BAR_HEIGHT + v6.Gap.XXLarge)
				),
				Size = UDim2.new(1, 0, 0, v44)
			}, { Row = react.createElement(module9) })
		end

		return nil
	end, { v43, v6, v44 })

	local v57 = react.useMemo(function()
		if not state2 then
			return nil
		end

		local createElement = react.createElement
		local view = foundation.View
		local v58 = {
			Size = UDim2.new(1, 0, 1, 0),
			stateLayer = { affordance = stateLayerAffordance.None },
			onActivated = function()
				setState2(false)
			end,
			testId = FFlagSquadsEnableFoundationTestIds and "--social-squad-lobby--voice-chat-menu-backdrop" or nil
		}

		local createElement2 = react.createElement
		local scrollView = foundation.ScrollView
		local v60 = {
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
				Size = UDim2.new(1, 0, 0, v36),
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
		local v61 = {
			Size = UDim2.new(1, 0, 1, 0),
			flexItem = { ItemLineAlignment = Enum.ItemLineAlignment.Center },
			AutomaticSize = Enum.AutomaticSize.Y,
			LayoutOrder = 2,
			padding = Vector2.new(v6.Padding.XLarge, v6.Padding.Medium),
			stateLayer = { affordance = stateLayerAffordance.None },
			onActivated = function() end,
			ZIndex = 3
		}

		local createElement4 = react.createElement

		local v65 = if fFlagEnablePartyVoiceChangersInLua then props.openSquadVoiceChangers else nil
		children.Menu = createElement3(view2, v61, {
			SquadLobbyVoiceChatMenu = createElement4(module10, {
				openSquadVoiceChangers = v65
			})
		})

		children.BottomPadding = react.createElement(foundation.View, {
			Size = UDim2.new(1, 0, 0, v36),
			LayoutOrder = 3,
			stateLayer = { affordance = stateLayerAffordance.None },
			onActivated = function()
				setState2(false)
			end
		})
		return (createElement(view, v58, { createElement2(scrollView, v60, children) }))
	end, { v36, state2, setState2, v6 })

	local v58 = react.useMemo(function()
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
				parentChannelId = v18
			}))
		else
			return nil
		end
	end, {
		v18,
		props.isInExperience,
		state6,
		setState6,
		props.openViewProfile,
		state5,
		setState5
	})

	react.useEffect(function()
		squadCoordinationExperienceJoinExperimentation.logExposure()

		if fFlagEnableSquadRegroupExperimentation then
			squadRegroupExperimentation.logExposure()
		end

		luckyRecommendationExperimentation.logExposure()
	end, {})

	local fragment = roact.createFragment({
		SquadLobbyBanners = v47,
		SquadLobbyUsersScrollingFrame = v53,
		SquadLobbyRegroupRow = v55,
		SquadLobbyLuckyRecommendationRow = v56,
		SquadLobbyActionBar = v54,
		SquadLobbyVoiceChatMenu = v57,
		UserDropdownMenu = v58
	})

	if squadCoordinationExperienceJoinExperimentation.getIsSquadLobbySessionEnabled() then
		fragment = react.createElement(squadLobbySessionProvider.Provider, nil, fragment)
	end

	return fragment
end

return SquadLobby
