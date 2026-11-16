local parent = script.Parent
local parent2 = parent.Parent.Parent

local React = require(parent2.React)
local InviteCallbackContext = require(parent.InviteCallbackContext)

return function(props)
	return React.createElement(InviteCallbackContext.Provider, {
		value = {
			inviteSingleFriend = props.inviteSingleFriend,
			inviteMultiFriends = props.inviteMultiFriends
		}
	}, props.children)
end
