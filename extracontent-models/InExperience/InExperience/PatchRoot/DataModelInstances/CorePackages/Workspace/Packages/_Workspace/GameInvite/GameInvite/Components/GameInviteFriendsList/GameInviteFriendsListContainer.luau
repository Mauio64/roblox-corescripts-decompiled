local parent = script:FindFirstAncestor("GameInvite").Parent
local React = require(parent.React)

local GameInviteFriendsListView = require(script.Parent.GameInviteFriendsListView)
local useGameInviteFriendsListViewModel = require(script.Parent.useGameInviteFriendsListViewModel)

local function GameInviteFriendsListContainer(p)
	local v = useGameInviteFriendsListViewModel(p)
	return React.createElement(GameInviteFriendsListView, v)
end

return GameInviteFriendsListContainer
