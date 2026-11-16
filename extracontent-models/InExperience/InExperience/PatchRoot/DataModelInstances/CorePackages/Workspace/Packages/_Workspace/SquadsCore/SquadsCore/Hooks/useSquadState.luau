local SquadsCore = script:FindFirstAncestor("SquadsCore")
local parent = SquadsCore.Parent

local React = require(parent.React)
local NetworkingSquads = require(SquadsCore.Http.NetworkingSquads)
local RoduxNetworking = require(SquadsCore.Http.RoduxNetworking)
local NetworkStatus = RoduxNetworking.Enum.NetworkStatus
local SquadState = require(SquadsCore.Enums.SquadState)
local useCurrentSquadId = require(SquadsCore.Hooks.useCurrentSquadId)
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

return function()
	local v = useCurrentSquadId() or ""

	local v2 = useSelector((React.useCallback(function(p)
		return NetworkingSquads.JoinSquad.getStatus(p, {})
	end, {})))

	local v3 = useSelector((React.useCallback(function(p)
		return NetworkingSquads.CreateOrJoinSquad.getStatus(p, {})
	end, {})))

	local idle = SquadState.Idle

	if v ~= "" then
		return SquadState.Active
	end

	if v2 == NetworkStatus.Fetching or v3 == NetworkStatus.Fetching then
		return SquadState.Initializing
	end

	return idle
end
