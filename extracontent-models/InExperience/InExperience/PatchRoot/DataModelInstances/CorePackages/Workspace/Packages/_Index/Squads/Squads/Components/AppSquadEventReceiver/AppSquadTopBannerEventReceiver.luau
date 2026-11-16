local Squads = script:FindFirstAncestor("Squads")

local parent = Squads.Parent
local AppTopBanner = require(parent.AppTopBanner)

local AppTopBannerType = AppTopBanner.Enums.AppTopBannerType
local SetAppTopBanner = AppTopBanner.Actions.SetAppTopBanner
local GetAppTopBannerStore = AppTopBanner.GetAppTopBannerStore

local dependencies = require(Squads.dependencies)

local cryo = dependencies.Cryo
local react = dependencies.React
local sharedFlags = dependencies.SharedFlags
local Hooks = require(parent.SquadsCore.Hooks)
local EventNames = require(parent.SquadsCore.EventNames)

local SquadExternalContractProvider = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadExternalContractContext = SquadExternalContractProvider.SquadExternalContractContext
local SquadExternalContractProvider2 = require(parent.SquadsCore.SquadExternalContractProvider)
local SquadViewFlags = SquadExternalContractProvider2.SquadViewFlags
local Enums = require(parent.SquadsCore.Enums)
local SquadRootViewType = Enums.SquadRootViewType
local encodeSquadMembers = require(parent.SquadsCore.encodeSquadMembers)
local useCurrentSquadId = Hooks.useCurrentSquadId
local useCurrentSquadMembers = Hooks.useCurrentSquadMembers
local useCurrentSquadParentChannelId = Hooks.useCurrentSquadParentChannelId
local useDispatch = dependencies.Hooks.useDispatch
local useCanAccessParty = require(Squads.Hooks.useCanAccessParty)

local fFlagEnableSquadTopBannerWideMode = sharedFlags.FFlagEnableSquadTopBannerWideMode
local fFlagUseSignalsForAppTopBanner = sharedFlags.FFlagUseSignalsForAppTopBanner

local FFlagIntroduceTopBannerPartyStates = require(Squads.Flags.FFlagIntroduceTopBannerPartyStates)

local defineFastFlag = game:DefineFastFlag("FixSquadTopBannerMemo", false)

return function(): nil
	local v = useDispatch()

	local v2 = react.useContext(SquadExternalContractContext)
	local squadId = useCurrentSquadId()
	local v3 = useCurrentSquadParentChannelId()
	local v4

	if FFlagIntroduceTopBannerPartyStates then
		v4 = useCurrentSquadMembers()
	else
		v4 = nil
	end

	local squadMemberList

	if defineFastFlag then
		local useMemo = react.useMemo
		local function fn()
			if FFlagIntroduceTopBannerPartyStates and v4 then
				return (cryo.List.map(v4, function(p)
					return p.userId
				end))
			end

			return {}
		end

		local v5

		if FFlagIntroduceTopBannerPartyStates then
			v5 = v4
		end

		squadMemberList = useMemo(fn, { v5 })
	else
		squadMemberList = not (FFlagIntroduceTopBannerPartyStates and v4) and {} or cryo.List.map(v4, function(p)
			return p.userId
		end)
	end

	local ref

	if FFlagIntroduceTopBannerPartyStates then
		ref = react.useRef(os.clock())
	else
		ref = nil
	end

	local useCallback = react.useCallback
	local function fn()
		if v2.navigateIntoSquadLobby and v3 then
			v(v2.navigateIntoSquadLobby({ conversationId = v3 }, true))
		end

		if FFlagIntroduceTopBannerPartyStates then
			local squadMembers = encodeSquadMembers(v4)
			v2.fireSquadAnalytics(EventNames.SquadTopBannerClicked, {
				squadId = squadId,
				parentChannelId = v3,
				squadMembers = squadMembers,
				timePassedSinceLastStateUpdatedInSec = os.clock() - ref.current
			})
		end
	end

	local v5

	if FFlagIntroduceTopBannerPartyStates then
		v5 = squadId
	end

	local navigateIntoSquadLobby = v2.navigateIntoSquadLobby
	local fireSquadAnalytics

	if FFlagIntroduceTopBannerPartyStates then
		fireSquadAnalytics = v2.fireSquadAnalytics
	end

	local v6

	if FFlagIntroduceTopBannerPartyStates then
		v6 = v4
	end

	local v7 = useCallback(fn, { v5, v3, v, navigateIntoSquadLobby, fireSquadAnalytics, v6 })

	local v8 = v2.useGetConversationFromId(v3)
	local kind = v8 and v8.type
	local participants = v8 and v8.participants

	local v9 = useCanAccessParty()

	local v10 = v2.useSquadRootView()

	if fFlagEnableSquadTopBannerWideMode then
		local v11 = v2.useSquadTopBannerDisabled()
		local useEffect = react.useEffect
		local function fn2()
			local v12 = squadId and (not v11 or v10 == SquadRootViewType.None)

			if v9 and v12 then
				if FFlagIntroduceTopBannerPartyStates then
					ref.current = os.clock()
				end

				if fFlagUseSignalsForAppTopBanner then
					GetAppTopBannerStore(false).setAppTopBanner(
						true,
						AppTopBannerType.ActiveSquad,
						FFlagIntroduceTopBannerPartyStates and {
							squadMemberList = squadMemberList,
							parentChannelType = kind,
							parentChannelParticipants = participants
						} or nil,
						v7
					)
				else
					v(SetAppTopBanner(
						true,
						AppTopBannerType.ActiveSquad,
						FFlagIntroduceTopBannerPartyStates and {
							squadMemberList = squadMemberList,
							parentChannelType = kind,
							parentChannelParticipants = participants
						} or nil,
						v7
					))
				end
			elseif fFlagUseSignalsForAppTopBanner then
				GetAppTopBannerStore(false).setAppTopBanner(false, AppTopBannerType.None, nil)
			else
				v(SetAppTopBanner(false, AppTopBannerType.None, nil))
			end
		end

		local v12

		if FFlagIntroduceTopBannerPartyStates then
			v12 = squadMemberList
		end

		useEffect(fn2, { squadId, v12, v, v7, kind, participants, v11, v10 })
	else
		local v11 = v2.useSquadViewFlags()
		local useEffect = react.useEffect
		local function fn2()
			local v12 = squadId and (bit32.band(v11, SquadViewFlags.SquadLobby) == 0 or v10 == SquadRootViewType.None)

			if v9 and v12 then
				if FFlagIntroduceTopBannerPartyStates then
					ref.current = os.clock()
				end

				if fFlagUseSignalsForAppTopBanner then
					GetAppTopBannerStore(false).setAppTopBanner(
						true,
						AppTopBannerType.ActiveSquad,
						FFlagIntroduceTopBannerPartyStates and {
							squadMemberList = squadMemberList,
							parentChannelType = kind,
							parentChannelParticipants = participants
						} or nil,
						v7
					)
				else
					v(SetAppTopBanner(
						true,
						AppTopBannerType.ActiveSquad,
						FFlagIntroduceTopBannerPartyStates and {
							squadMemberList = squadMemberList,
							parentChannelType = kind,
							parentChannelParticipants = participants
						} or nil,
						v7
					))
				end
			elseif fFlagUseSignalsForAppTopBanner then
				GetAppTopBannerStore(false).setAppTopBanner(false, AppTopBannerType.None, nil)
			else
				v(SetAppTopBanner(false, AppTopBannerType.None, nil))
			end
		end

		local v12

		if FFlagIntroduceTopBannerPartyStates then
			v12 = squadMemberList
		end

		useEffect(fn2, { squadId, v12, v, v7, v11, kind, participants, v10 })
	end

	return nil
end
