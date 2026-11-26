local React = require("@game/CorePackages/Workspace/Packages/_Workspace/FriendsMenu/React")
local InviteCallbackContext = require("@game/CorePackages/Workspace/Packages/_Index/FriendsMenu/FriendsMenu/Context/InviteCallbackContext")

return function(props)
	return React.createElement(InviteCallbackContext.Provider, {
		value = {
			inviteSingleFriend = props.inviteSingleFriend,
			inviteMultiFriends = props.inviteMultiFriends
		}
	}, props.children)
end
