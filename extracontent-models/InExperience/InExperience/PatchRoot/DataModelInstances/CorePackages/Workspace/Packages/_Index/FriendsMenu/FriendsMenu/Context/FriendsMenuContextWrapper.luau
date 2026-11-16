local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local FFlagUpdateInvitesToUsePaginatedFriends = require(parent2.Flags.FFlagUpdateInvitesToUsePaginatedFriends)
local v

if FFlagUpdateInvitesToUsePaginatedFriends then
	v = require(parent.FriendsListContextProvider2)
else
	v = require(parent.FriendsListContextProvider)
end

local InviteCallbackProvider = require(parent.InviteCallbackProvider)
local SelectedUsersContextProvider = require(parent.SelectedUsersContextProvider)

local Cryo = require(parent3.Cryo)
local React = require(parent3.React)

return function(props)
	local excludedFriendsSet = props.excludedFriendsSet

	if props.preselectedUsersUnremovable and props.preselectedUsers then
		excludedFriendsSet = Cryo.Dictionary.union(excludedFriendsSet or {}, Cryo.List.toSet(props.preselectedUsers))
	end

	return React.createElement(
		v,
		{
			excludedFriendsSet = excludedFriendsSet,
			isLoadingCustomParams = props.isLoadingCustomParams
		},
		React.createElement(
			InviteCallbackProvider,
			{
				inviteSingleFriend = props.inviteSingleFriend,
				inviteMultiFriends = props.inviteMultiFriends
			},
			React.createElement(
				SelectedUsersContextProvider,
				{
					selectionLimit = props.selectionLimit,
					preselectedUsers = props.preselectedUsers,
					preselectedUsersUnremovable = props.preselectedUsersUnremovable,
					onRemoveCallback = props.onRemoveCallback
				},
				props.children
			)
		)
	)
end
