local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/React")

local GameInviteFriendsListView = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteFriendsList/GameInviteFriendsListView")
local useGameInviteFriendsListViewModel = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInvite/GameInvite/Components/GameInviteFriendsList/useGameInviteFriendsListViewModel")

local function GameInviteFriendsListContainer(p2)
	local v5 = useGameInviteFriendsListViewModel(p2)
	return React.createElement(GameInviteFriendsListView, v5)
end

return GameInviteFriendsListContainer
