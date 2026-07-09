local ParentParent = script.Parent.Parent.Parent

return (require(ParentParent.React).createContext({
	selectedFriendsSize = 0,
	selectedFriends = {},
	addFriend = function() -- line: 21
	end,
	removeFriend = function() -- line: 22
	end,
	isFriendSelected = function() -- line: 23
		return false
	end,
	preselectedUsers = {},
	onRemoveCallback = function() -- line: 27
	end
}))
