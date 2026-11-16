local Squads = script:FindFirstAncestor("Squads")
local parent = Squads.Parent
local dependencies = require(Squads.dependencies)

local networkingSquads = dependencies.NetworkingSquads
local networkStatus = dependencies.RoduxNetworking.Enum.NetworkStatus
local useSelector = dependencies.Hooks.useSelector
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local Hooks = require(parent.SquadsCore.Hooks)
local useCurrentSquadId = Hooks.useCurrentSquadId
local useIsExperienceInviteRetryBlocked = Hooks.useIsExperienceInviteRetryBlocked

local Stores = require(parent.SquadsCore.Stores)
local GetSquadExperienceInviteStore = Stores.GetSquadExperienceInviteStore

local fFlagUseSignalsForSquadExperienceInviteStatus = dependencies.SharedFlags.FFlagUseSignalsForSquadExperienceInviteStatus
local fFlagUseSignalsForSquadExperienceInvite = dependencies.SharedFlags.FFlagUseSignalsForSquadExperienceInvite

local function getCurrentSquadId(p) -- 3 equivalent calls inferred from this helper
	local squad = p.Squad and p.Squad.Squad
	return squad and squad.currentSquad and squad.currentSquad.squadId
end

local function selectHasCurrentSquadId(p): boolean
	return getCurrentSquadId(p) ~= nil -- inferred equivalent call
end

local function selectIsCreateExperienceInviteFetching(p)
	local currentSquadId = getCurrentSquadId(p) -- inferred equivalent call
	local isCreateExperienceInviteFetching

	if currentSquadId == nil then
		isCreateExperienceInviteFetching = false
	else
		isCreateExperienceInviteFetching = networkingSquads.CreateExperienceInvite.getStatus(p, currentSquadId) == networkStatus.Fetching
	end

	return isCreateExperienceInviteFetching
end

local function selectHasInFlightOrExistingInvite(p): boolean
	local currentSquadId = getCurrentSquadId(p) -- inferred equivalent call

	if currentSquadId then
		return networkingSquads.CreateExperienceInvite.getStatus(p, currentSquadId) == networkStatus.Fetching
			or p.Squad.Squad.currentExperienceInvite ~= nil
	end

	return false
end

local function useIsExperienceInvitePending()
	local v = useIsExperienceInviteRetryBlocked((useCurrentSquadId()))

	if not fFlagUseSignalsForSquadExperienceInviteStatus then
		return useSelector(function(p): boolean
			local squad = p.Squad and p.Squad.Squad
			local squadId = squad and squad.currentSquad and squad.currentSquad.squadId

			if not squadId then
				return false
			end

			if squad and squad.currentExperienceInviteStatus then
				return true
			end

			local status = networkingSquads.CreateExperienceInvite.getStatus(p, squadId)
			local currentExperienceInvite = squad and squad.currentExperienceInvite

			if status == networkStatus.Fetching or currentExperienceInvite then
				return true
			end

			return false
		end) or v
	end

	local v2 = useSelector(selectHasCurrentSquadId)
	local v3

	if fFlagUseSignalsForSquadExperienceInvite then
		local v4 = useSelector(selectIsCreateExperienceInviteFetching)

		local v5 = useSignalState(GetSquadExperienceInviteStore(false).getHasCurrentExperienceInvite)
		v3 = v4 or v5
	else
		v3 = useSelector(selectHasInFlightOrExistingInvite)
	end

	local v4 = useSignalState(GetSquadExperienceInviteStore(false).getIsExperienceInvitePending)

	if v2 then
		return v4 or v3 or v
	end

	return v
end

return useIsExperienceInvitePending
