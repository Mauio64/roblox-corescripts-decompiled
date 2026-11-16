local parent = script.Parent.Parent.Parent
local React = require(parent.React)

return (React.createContext({
	selectedFriendsSize = 0,
	selectedFriends = {},
	addFriend = function() end,
	removeFriend = function() end,
	isFriendSelected = function(): boolean
		return false
	end,
	preselectedUsers = {},
	onRemoveCallback = function() end
}))
