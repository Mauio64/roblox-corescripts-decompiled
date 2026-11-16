local parent = script.Parent.Parent.Parent
local React = require(parent.React)

return (React.createContext({
	inviteSingleFriend = function() end,
	getMaxRecipientRowNum = function() end
}))
