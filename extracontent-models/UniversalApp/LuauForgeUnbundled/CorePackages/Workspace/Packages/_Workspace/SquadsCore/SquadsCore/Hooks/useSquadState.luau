local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/React")
local NetworkingSquads = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Http/NetworkingSquads")
local networkStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Http/RoduxNetworking").Enum.NetworkStatus
local SquadState = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Enums/SquadState")
local useCurrentSquadId = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/SquadsCore/Hooks/useCurrentSquadId")
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/SquadsCore/RoactUtils").Hooks.RoactRodux.useSelector

return function()
	local v5 = useCurrentSquadId() or ""

	local v7 = useSelector((React.useCallback(function(p2)
		return NetworkingSquads.JoinSquad.getStatus(p2, {})
	end, {})))

	local v9 = useSelector((React.useCallback(function(p2)
		return NetworkingSquads.CreateOrJoinSquad.getStatus(p2, {})
	end, {})))

	local v10 = SquadState.Idle

	if v5 ~= "" then
		return SquadState.Active
	end

	if v7 == networkStatus.Fetching or v9 == networkStatus.Fetching then
		v10 = SquadState.Initializing
	end

	return v10
end
