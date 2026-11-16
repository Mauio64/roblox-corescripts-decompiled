local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)

local ChatWindow = require(ExpChat.ChatWindow.UI.ChatWindow)
local FriendsChatDependencyContext = require(parent.FriendsChat.FriendsChatDependencyContext)

local v = { ChatWindow = ChatWindow }

local function FriendsChatDependencyBridge(p)
	return React.createElement(FriendsChatDependencyContext.Provider, { value = v }, p.children)
end

return FriendsChatDependencyBridge
