local SquadsCore = script:FindFirstAncestor("SquadsCore")
local SquadsCoreParent = SquadsCore.Parent
local React = require(SquadsCoreParent.React)
local NetworkingSquads = require(SquadsCore.Http.NetworkingSquads)
local NetworkStatus = require(SquadsCore.Http.RoduxNetworking).Enum.NetworkStatus
local SquadState = require(SquadsCore.Enums.SquadState)
local useCurrentSquadId = require(SquadsCore.Hooks.useCurrentSquadId)
local useSelector = require(SquadsCoreParent.RoactUtils).Hooks.RoactRodux.useSelector

return function() -- line: 13
	-- upvalues: useCurrentSquadId (copy), React (copy), NetworkingSquads (copy), useSelector (copy), SquadState (copy), NetworkStatus (copy)
	local v9 = useCurrentSquadId() or ""
	local v10 = React.useCallback(function(p1) -- line: 16
		-- upvalues: NetworkingSquads (copy)
		return NetworkingSquads.JoinSquad.getStatus(p1, {})
	end, {})
	local v11 = useSelector(v10)
	local v12 = React.useCallback(function(p2) -- line: 21
		-- upvalues: NetworkingSquads (copy)
		return NetworkingSquads.CreateOrJoinSquad.getStatus(p2, {})
	end, {})
	local v13 = useSelector(v12)
	local Idle = SquadState.Idle

	if v9 ~= "" then
		return SquadState.Active
	end

	if v11 == NetworkStatus.Fetching or v13 == NetworkStatus.Fetching then
		Idle = SquadState.Initializing
	end

	return Idle
end
