local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local v4 = if not require(scriptParentParent.Flags.FFlagUpdateInvitesToUsePaginatedFriends) then require(scriptParent.FriendsListContextProvider) else require(scriptParent.FriendsListContextProvider2)
local InviteCallbackProvider = require(scriptParent.InviteCallbackProvider)
local SelectedUsersContextProvider = require(scriptParent.SelectedUsersContextProvider)
local Cryo = require(scriptParentParentParent.Cryo)
local React = require(scriptParentParentParent.React)

return function(t1: {[any]: any}) -- line: 29
	-- upvalues: Cryo (copy), React (copy), v4 (copy), InviteCallbackProvider (copy), SelectedUsersContextProvider (copy)
	local excludedFriendsSet = t1.excludedFriendsSet

	if t1.preselectedUsersUnremovable and t1.preselectedUsers then
		excludedFriendsSet = Cryo.Dictionary.union(excludedFriendsSet or {}, Cryo.List.toSet(t1.preselectedUsers))
	end

	return React.createElement(v4, {
		excludedFriendsSet = excludedFriendsSet,
		isLoadingCustomParams = t1.isLoadingCustomParams
	}, React.createElement(InviteCallbackProvider, {
		inviteSingleFriend = t1.inviteSingleFriend,
		inviteMultiFriends = t1.inviteMultiFriends
	}, React.createElement(SelectedUsersContextProvider, {
		selectionLimit = t1.selectionLimit,
		preselectedUsers = t1.preselectedUsers,
		preselectedUsersUnremovable = t1.preselectedUsersUnremovable,
		onRemoveCallback = t1.onRemoveCallback
	}, t1.children)))
end
