local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Squads/React")

local SquadLobbyUserOverflowMenuView = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadLobby/SquadLobbyUserOverflowMenu/SquadLobbyUserOverflowMenuView")
local useSquadLobbyUserOverflowMenuViewModel = require("@game/CorePackages/Workspace/Packages/_Index/Squads/Squads/Components/SquadLobby/SquadLobbyUserOverflowMenu/useSquadLobbyUserOverflowMenuViewModel")

local function SquadLobbyUserOverflowMenuContainer(p2)
	local v5 = useSquadLobbyUserOverflowMenuViewModel(p2)
	return React.createElement(SquadLobbyUserOverflowMenuView, v5)
end

return SquadLobbyUserOverflowMenuContainer
