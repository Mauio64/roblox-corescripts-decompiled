local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/React")

local SquadLobbyJoinDialogView = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadLobby/SquadLobbyJoinDialog/SquadLobbyJoinDialogView")
local useSquadLobbyJoinDialogViewModel = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadLobby/SquadLobbyJoinDialog/useSquadLobbyJoinDialogViewModel")

local function SquadLobbyJoinDialogContainer(p2)
	local v5 = useSquadLobbyJoinDialogViewModel(p2)
	return React.createElement(SquadLobbyJoinDialogView, v5)
end

return SquadLobbyJoinDialogContainer
