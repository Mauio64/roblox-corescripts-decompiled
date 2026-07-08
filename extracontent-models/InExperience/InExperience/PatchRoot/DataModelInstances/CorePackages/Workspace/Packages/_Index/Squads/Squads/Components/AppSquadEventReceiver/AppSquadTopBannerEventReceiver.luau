local Squads = script:FindFirstAncestor("Squads")
local SquadsParent = Squads.Parent
local AppTopBanner = require(SquadsParent.AppTopBanner)
local AppTopBannerType = AppTopBanner.Enums.AppTopBannerType
local SetAppTopBanner = AppTopBanner.Actions.SetAppTopBanner
local dependencies = require(Squads.dependencies)
local Cryo = dependencies.Cryo
local React = dependencies.React
local SharedFlags = dependencies.SharedFlags
local Hooks = require(SquadsParent.SquadsCore.Hooks)
local EventNames = require(SquadsParent.SquadsCore.EventNames)
local SquadExternalContractContext = require(SquadsParent.SquadsCore.SquadExternalContractProvider).SquadExternalContractContext
local SquadViewFlags = require(SquadsParent.SquadsCore.SquadExternalContractProvider).SquadViewFlags
local SquadRootViewType = require(SquadsParent.SquadsCore.Enums).SquadRootViewType
local encodeSquadMembers = require(SquadsParent.SquadsCore.encodeSquadMembers)
local useCurrentSquadId = Hooks.useCurrentSquadId
local useCurrentSquadMembers = Hooks.useCurrentSquadMembers
local useCurrentSquadParentChannelId = Hooks.useCurrentSquadParentChannelId
local useDispatch = dependencies.Hooks.useDispatch
local useCanAccessParty = require(Squads.Hooks.useCanAccessParty)
local FFlagEnableSquadTopBannerWideMode = SharedFlags.FFlagEnableSquadTopBannerWideMode
local FFlagIntroduceTopBannerPartyStates = require(Squads.Flags.FFlagIntroduceTopBannerPartyStates)
local v23 = game:DefineFastFlag("FixSquadTopBannerMemo", false)

return function() -- line: 33
	-- upvalues: useDispatch (copy), React (copy), SquadExternalContractContext (copy), useCurrentSquadId (copy), useCurrentSquadParentChannelId (copy), FFlagIntroduceTopBannerPartyStates (copy), useCurrentSquadMembers (copy), v23 (copy), Cryo (copy), encodeSquadMembers (copy), EventNames (copy), useCanAccessParty (copy), FFlagEnableSquadTopBannerWideMode (copy), SquadRootViewType (copy), SetAppTopBanner (copy), AppTopBannerType (copy), SquadViewFlags (copy)
	local v24 = useDispatch()
	local v25 = React.useContext(SquadExternalContractContext)
	local v26 = useCurrentSquadId()
	local v27 = useCurrentSquadParentChannelId()
	local v28 = if not FFlagIntroduceTopBannerPartyStates then nil else useCurrentSquadMembers()
	local u29 = if not v23 then if not FFlagIntroduceTopBannerPartyStates or not v28 then {} else Cryo.List.map(v28, function(p1) -- line: 52
		return p1.userId
	end) else React.useMemo(function() -- line: 43
		-- upvalues: FFlagIntroduceTopBannerPartyStates (copy), v28 (copy), Cryo (copy)
		if FFlagIntroduceTopBannerPartyStates and v28 then
			return (Cryo.List.map(v28, function(p2) -- line: 45
				return p2.userId
			end))
		end

		return {}
	end, { if not FFlagIntroduceTopBannerPartyStates then nil else v28 })
	local v30 = if not FFlagIntroduceTopBannerPartyStates then nil else React.useRef(os.clock())
	local v31 = React.useCallback(function() -- line: 63
		-- upvalues: v25 (copy), v27 (copy), v24 (copy), FFlagIntroduceTopBannerPartyStates (copy), encodeSquadMembers (copy), v28 (copy), EventNames (copy), v26 (copy), v30 (copy)
		if v25.navigateIntoSquadLobby and v27 then
			v24(v25.navigateIntoSquadLobby({
				conversationId = v27
			}, true))
		end

		if FFlagIntroduceTopBannerPartyStates then
			local v40 = encodeSquadMembers(v28)

			v25.fireSquadAnalytics(EventNames.SquadTopBannerClicked, {
				squadId = v26,
				parentChannelId = v27,
				squadMembers = v40,
				timePassedSinceLastStateUpdatedInSec = os.clock() - v30.current
			})
		end
	end, {
		if not FFlagIntroduceTopBannerPartyStates then nil else v26,
		v27,
		v24,
		v25.navigateIntoSquadLobby,
		if not FFlagIntroduceTopBannerPartyStates then nil else v25.fireSquadAnalytics,
		if not FFlagIntroduceTopBannerPartyStates then nil else v28
	})
	local v32 = v25.useGetConversationFromId(v27)
	local v33 = v32 and v32.type
	local v34 = v32 and v32.participants
	local v35 = useCanAccessParty()
	local v36 = v25.useSquadRootView()

	if FFlagEnableSquadTopBannerWideMode then
		local v37 = v25.useSquadTopBannerDisabled()

		React.useEffect(function() -- line: 97
			-- upvalues: v26 (copy), v37 (copy), v36 (copy), SquadRootViewType (copy), v35 (copy), FFlagIntroduceTopBannerPartyStates (copy), v30 (copy), v24 (copy), SetAppTopBanner (copy), AppTopBannerType (copy), u29 (ref), v33 (copy), v34 (copy), v31 (copy)
			local v41 = v26 and (not v37 or v36 == SquadRootViewType.None)

			if v35 and v41 then
				if FFlagIntroduceTopBannerPartyStates then
					v30.current = os.clock()
				end

				v24(SetAppTopBanner(true, AppTopBannerType.ActiveSquad, if not FFlagIntroduceTopBannerPartyStates then nil else {
					squadMemberList = u29,
					parentChannelType = v33,
					parentChannelParticipants = v34
				}, v31))

				return
			end

			v24(SetAppTopBanner(false, AppTopBannerType.None, nil))
		end, {
			v26,
			if not FFlagIntroduceTopBannerPartyStates then nil else u29,
			v24,
			v31,
			v33,
			v34,
			v37,
			v36
		})
	else
		local v38 = v25.useSquadViewFlags()

		React.useEffect(function() -- line: 138
			-- upvalues: v26 (copy), v38 (copy), SquadViewFlags (copy), v36 (copy), SquadRootViewType (copy), v35 (copy), FFlagIntroduceTopBannerPartyStates (copy), v30 (copy), v24 (copy), SetAppTopBanner (copy), AppTopBannerType (copy), u29 (ref), v33 (copy), v34 (copy), v31 (copy)
			local v42 = v26 and (bit32.band(v38, SquadViewFlags.SquadLobby) == 0 or v36 == SquadRootViewType.None)

			if v35 and v42 then
				if FFlagIntroduceTopBannerPartyStates then
					v30.current = os.clock()
				end

				v24(SetAppTopBanner(true, AppTopBannerType.ActiveSquad, if not FFlagIntroduceTopBannerPartyStates then nil else {
					squadMemberList = u29,
					parentChannelType = v33,
					parentChannelParticipants = v34
				}, v31))

				return
			end

			v24(SetAppTopBanner(false, AppTopBannerType.None, nil))
		end, {
			v26,
			if not FFlagIntroduceTopBannerPartyStates then nil else u29,
			v24,
			v31,
			v38,
			v33,
			v34,
			v36
		})
	end

	return nil
end
