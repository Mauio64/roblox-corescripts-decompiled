local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/dependencies")

local networkingSquads = dependencies.NetworkingSquads
local networkStatus = dependencies.RoduxNetworking.Enum.NetworkStatus
local useSelector = dependencies.Hooks.useSelector
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/SignalsReact").useSignalState

local Hooks = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Hooks")
local useCurrentSquadId = Hooks.useCurrentSquadId
local useIsExperienceInviteRetryBlocked = Hooks.useIsExperienceInviteRetryBlocked

local getSquadExperienceInviteStore = require("@game/CorePackages/Workspace/Packages/_Index/Squads/SquadsCore/Stores").GetSquadExperienceInviteStore

local fFlagUseSignalsForSquadExperienceInviteStatus = dependencies.SharedFlags.FFlagUseSignalsForSquadExperienceInviteStatus
local fFlagUseSignalsForSquadExperienceInvite = dependencies.SharedFlags.FFlagUseSignalsForSquadExperienceInvite

local function getCurrentSquadId(p2)
	local squad = p2.Squad and p2.Squad.Squad
	return squad and squad.currentSquad and squad.currentSquad.squadId
end

local function selectHasCurrentSquadId(p2): boolean
	local squad = p2.Squad and p2.Squad.Squad
	return (squad and squad.currentSquad and squad.currentSquad.squadId) ~= nil
end

local function selectIsCreateExperienceInviteFetching(p2)
	local squad = p2.Squad and p2.Squad.Squad
	local squadId = squad and squad.currentSquad and squad.currentSquad.squadId
	local isCreateExperienceInviteFetching

	if squadId == nil then
		isCreateExperienceInviteFetching = false
	else
		isCreateExperienceInviteFetching = networkingSquads.CreateExperienceInvite.getStatus(p2, squadId) == networkStatus.Fetching
	end

	return isCreateExperienceInviteFetching
end

local function selectHasInFlightOrExistingInvite(p2): boolean
	local squad = p2.Squad and p2.Squad.Squad
	local squadId = squad and squad.currentSquad and squad.currentSquad.squadId

	if squadId then
		return networkingSquads.CreateExperienceInvite.getStatus(p2, squadId) == networkStatus.Fetching
			or p2.Squad.Squad.currentExperienceInvite ~= nil
	end

	return false
end

local function useIsExperienceInvitePending()
	local v6 = useIsExperienceInviteRetryBlocked((useCurrentSquadId()))

	if not fFlagUseSignalsForSquadExperienceInviteStatus then
		return useSelector(function(p2): boolean
			local squad = p2.Squad and p2.Squad.Squad
			local squadId = squad and squad.currentSquad and squad.currentSquad.squadId

			if not squadId then
				return false
			end

			if squad and squad.currentExperienceInviteStatus then
				return true
			end

			local status = networkingSquads.CreateExperienceInvite.getStatus(p2, squadId)
			local currentExperienceInvite = squad and squad.currentExperienceInvite

			if status == networkStatus.Fetching or currentExperienceInvite then
				return true
			end

			return false
		end) or v6
	end

	local v7 = useSelector(selectHasCurrentSquadId)
	local v8

	if fFlagUseSignalsForSquadExperienceInvite then
		local v9 = useSelector(selectIsCreateExperienceInviteFetching)

		local v10 = useSignalState(getSquadExperienceInviteStore(false).getHasCurrentExperienceInvite)
		v8 = v9 or v10
	else
		v8 = useSelector(selectHasInFlightOrExistingInvite)
	end

	local v9 = useSignalState(getSquadExperienceInviteStore(false).getIsExperienceInvitePending)

	if v7 then
		v6 = v9 or v8 or v6
	end

	return v6
end

return useIsExperienceInvitePending
