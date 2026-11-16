local parent = script:FindFirstAncestor("Squads").Parent
local React = require(parent.React)

local SquadLobbyJoinDialogView = require(script.Parent.SquadLobbyJoinDialogView)
local useSquadLobbyJoinDialogViewModel = require(script.Parent.useSquadLobbyJoinDialogViewModel)

local function SquadLobbyJoinDialogContainer(p)
	local v = useSquadLobbyJoinDialogViewModel(p)
	return React.createElement(SquadLobbyJoinDialogView, v)
end

return SquadLobbyJoinDialogContainer
