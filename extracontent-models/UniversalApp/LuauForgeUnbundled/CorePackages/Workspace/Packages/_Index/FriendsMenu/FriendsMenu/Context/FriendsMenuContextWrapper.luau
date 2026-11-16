local v5 = if require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Flags/FFlagUpdateInvitesToUsePaginatedFriends") then require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/FriendsListContextProvider2") else require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/FriendsListContextProvider")
local InviteCallbackProvider = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/InviteCallbackProvider")
local SelectedUsersContextProvider = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/SelectedUsersContextProvider")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/React")

return function(props)
	local v6 = props.excludedFriendsSet

	if props.preselectedUsersUnremovable and props.preselectedUsers then
		v6 = Cryo.Dictionary.union(v6 or {}, Cryo.List.toSet(props.preselectedUsers))
	end

	return React.createElement(
		v5,
		{ excludedFriendsSet = v6, isLoadingCustomParams = props.isLoadingCustomParams },
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
