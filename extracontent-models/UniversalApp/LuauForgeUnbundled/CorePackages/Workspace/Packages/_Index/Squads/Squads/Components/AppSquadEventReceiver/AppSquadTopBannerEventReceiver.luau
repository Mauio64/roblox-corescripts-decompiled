local AppTopBanner = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/AppTopBanner")

local appTopBannerType = AppTopBanner.Enums.AppTopBannerType
local setAppTopBanner = AppTopBanner.Actions.SetAppTopBanner
local getAppTopBannerStore = AppTopBanner.GetAppTopBannerStore

local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")

local cryo = dependencies.Cryo
local react = dependencies.React
local sharedFlags = dependencies.SharedFlags
local Hooks = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks")
local EventNames = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/EventNames")

local squadExternalContractContext = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider").SquadExternalContractContext
local squadViewFlags = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/SquadExternalContractProvider").SquadViewFlags
local squadRootViewType = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Enums").SquadRootViewType
local encodeSquadMembers = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/encodeSquadMembers")
local useCurrentSquadId = Hooks.useCurrentSquadId
local useCurrentSquadMembers = Hooks.useCurrentSquadMembers
local useCurrentSquadParentChannelId = Hooks.useCurrentSquadParentChannelId
local useDispatch = dependencies.Hooks.useDispatch
local useCanAccessParty = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Hooks/useCanAccessParty")

local fFlagEnableSquadTopBannerWideMode = sharedFlags.FFlagEnableSquadTopBannerWideMode
local fFlagUseSignalsForAppTopBanner = sharedFlags.FFlagUseSignalsForAppTopBanner

local FFlagIntroduceTopBannerPartyStates = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Flags/FFlagIntroduceTopBannerPartyStates")

local defineFastFlag = game:DefineFastFlag("FixSquadTopBannerMemo", false)

return function(): nil
	local v5 = useDispatch()

	local v6 = react.useContext(squadExternalContractContext)
	local v7 = useCurrentSquadId()
	local v8 = useCurrentSquadParentChannelId()
	local v9 = if FFlagIntroduceTopBannerPartyStates then useCurrentSquadMembers() else nil
	local v10

	if defineFastFlag then
		local function fn()
			if FFlagIntroduceTopBannerPartyStates and v9 then
				return (cryo.List.map(v9, function(p2)
					return p2.userId
				end))
			end

			return {}
		end

		v10 = react.useMemo(fn, { if FFlagIntroduceTopBannerPartyStates then v9 else nil })
	else
		v10 = not (FFlagIntroduceTopBannerPartyStates and v9) and {} or cryo.List.map(v9, function(p2)
			return p2.userId
		end)
	end

	local ref = if FFlagIntroduceTopBannerPartyStates then react.useRef(os.clock()) else nil

	local useCallback = react.useCallback
	local function fn()
		if v6.navigateIntoSquadLobby and v8 then
			v5(v6.navigateIntoSquadLobby({ conversationId = v8 }, true))
		end

		if FFlagIntroduceTopBannerPartyStates then
			local v11 = encodeSquadMembers(v9)
			v6.fireSquadAnalytics(EventNames.SquadTopBannerClicked, {
				squadId = v7,
				parentChannelId = v8,
				squadMembers = v11,
				timePassedSinceLastStateUpdatedInSec = os.clock() - ref.current
			})
		end
	end

	local v12 = if FFlagIntroduceTopBannerPartyStates then v7 else nil
	local navigateIntoSquadLobby = v6.navigateIntoSquadLobby
	local fireSquadAnalytics = if FFlagIntroduceTopBannerPartyStates then v6.fireSquadAnalytics else nil
	local v14 = useCallback(fn, {
		v12,
		v8,
		v5,
		navigateIntoSquadLobby,
		fireSquadAnalytics,
		if FFlagIntroduceTopBannerPartyStates then v9 else nil
	})

	local v15 = v6.useGetConversationFromId(v8)
	local kind = v15 and v15.type
	local participants = v15 and v15.participants

	local v16 = useCanAccessParty()

	local v17 = v6.useSquadRootView()

	if fFlagEnableSquadTopBannerWideMode then
		local v18 = v6.useSquadTopBannerDisabled()
		local function fn2()
			local v19 = v7 and (not v18 or v17 == squadRootViewType.None)

			if v16 and v19 then
				if FFlagIntroduceTopBannerPartyStates then
					ref.current = os.clock()
				end

				if fFlagUseSignalsForAppTopBanner then
					getAppTopBannerStore(false).setAppTopBanner(
						true,
						appTopBannerType.ActiveSquad,
						FFlagIntroduceTopBannerPartyStates and {
							squadMemberList = v10,
							parentChannelType = kind,
							parentChannelParticipants = participants
						} or nil,
						v14
					)
				else
					v5(setAppTopBanner(
						true,
						appTopBannerType.ActiveSquad,
						FFlagIntroduceTopBannerPartyStates and {
							squadMemberList = v10,
							parentChannelType = kind,
							parentChannelParticipants = participants
						} or nil,
						v14
					))
				end
			elseif fFlagUseSignalsForAppTopBanner then
				getAppTopBannerStore(false).setAppTopBanner(false, appTopBannerType.None, nil)
			else
				v5(setAppTopBanner(false, appTopBannerType.None, nil))
			end
		end

		react.useEffect(fn2, {
			v7,
			if FFlagIntroduceTopBannerPartyStates then v10 else nil,
			v5,
			v14,
			kind,
			participants,
			v18,
			v17
		})
	else
		local v18 = v6.useSquadViewFlags()
		local function fn2()
			local v19 = v7
				and (bit32.band(v18, squadViewFlags.SquadLobby) == 0 or v17 == squadRootViewType.None)

			if v16 and v19 then
				if FFlagIntroduceTopBannerPartyStates then
					ref.current = os.clock()
				end

				if fFlagUseSignalsForAppTopBanner then
					getAppTopBannerStore(false).setAppTopBanner(
						true,
						appTopBannerType.ActiveSquad,
						FFlagIntroduceTopBannerPartyStates and {
							squadMemberList = v10,
							parentChannelType = kind,
							parentChannelParticipants = participants
						} or nil,
						v14
					)
				else
					v5(setAppTopBanner(
						true,
						appTopBannerType.ActiveSquad,
						FFlagIntroduceTopBannerPartyStates and {
							squadMemberList = v10,
							parentChannelType = kind,
							parentChannelParticipants = participants
						} or nil,
						v14
					))
				end
			elseif fFlagUseSignalsForAppTopBanner then
				getAppTopBannerStore(false).setAppTopBanner(false, appTopBannerType.None, nil)
			else
				v5(setAppTopBanner(false, appTopBannerType.None, nil))
			end
		end

		react.useEffect(fn2, {
			v7,
			if FFlagIntroduceTopBannerPartyStates then v10 else nil,
			v5,
			v14,
			v18,
			kind,
			participants,
			v17
		})
	end

	return nil
end
