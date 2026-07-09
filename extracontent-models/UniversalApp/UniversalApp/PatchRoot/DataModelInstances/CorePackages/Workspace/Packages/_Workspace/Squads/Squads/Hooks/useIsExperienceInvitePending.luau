local Squads = script:FindFirstAncestor("Squads")
local dependencies = require(Squads.dependencies)
local NetworkingSquads = dependencies.NetworkingSquads
local NetworkStatus = dependencies.RoduxNetworking.Enum.NetworkStatus
local useSelector = dependencies.Hooks.useSelector

local function useIsExperienceInvitePending() -- line: 8
	-- upvalues: useSelector (copy), NetworkingSquads (copy), NetworkStatus (copy)
	return (useSelector(function(p1) -- line: 9
		-- upvalues: NetworkingSquads (copy), NetworkStatus (copy)
		local v8 = p1.Squad and p1.Squad.Squad
		local v9 = v8 and (v8.currentSquad and v8.currentSquad.squadId)

		if not v9 then
			return false
		end

		if v8 and v8.currentExperienceInviteStatus then
			return true
		end

		local v10 = NetworkingSquads.CreateExperienceInvite.getStatus(p1, v9)
		local v11 = v8 and v8.currentExperienceInvite

		if v10 == NetworkStatus.Fetching or v11 then
			return true
		end

		return false
	end))
end

return useIsExperienceInvitePending
