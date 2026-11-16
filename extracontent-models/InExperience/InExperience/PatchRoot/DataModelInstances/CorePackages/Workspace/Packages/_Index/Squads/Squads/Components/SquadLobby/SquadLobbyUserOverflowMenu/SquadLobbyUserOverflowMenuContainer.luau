local parent = script:FindFirstAncestor("Squads").Parent
local React = require(parent.React)

local SquadLobbyUserOverflowMenuView = require(script.Parent.SquadLobbyUserOverflowMenuView)
local useSquadLobbyUserOverflowMenuViewModel = require(script.Parent.useSquadLobbyUserOverflowMenuViewModel)

local function SquadLobbyUserOverflowMenuContainer(p)
	local v = useSquadLobbyUserOverflowMenuViewModel(p)
	return React.createElement(SquadLobbyUserOverflowMenuView, v)
end

return SquadLobbyUserOverflowMenuContainer
