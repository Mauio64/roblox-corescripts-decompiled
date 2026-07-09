local scriptParent = script.Parent
local ParentParent = scriptParent.Parent.Parent
local React = require(ParentParent.React)
local InviteCallbackContext = require(scriptParent.InviteCallbackContext)

return function(t1: {[any]: any}) -- line: 14
	-- upvalues: React (copy), InviteCallbackContext (copy)
	return React.createElement(InviteCallbackContext.Provider, {
		value = {
			inviteSingleFriend = t1.inviteSingleFriend,
			inviteMultiFriends = t1.inviteMultiFriends
		}
	}, t1.children)
end
