local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local ChatWindow = require(ExpChat.ChatWindow.UI.ChatWindow)
local FriendsChatDependencyContext = require(ExpChatParent.FriendsChat.FriendsChatDependencyContext)
local t1 = {
	ChatWindow = ChatWindow
}

local function FriendsChatDependencyBridge(t2: {[any]: any}) -- line: 31
	-- upvalues: React (copy), FriendsChatDependencyContext (copy), t1 (copy)
	return React.createElement(FriendsChatDependencyContext.Provider, {
		value = t1
	}, t2.children)
end

return FriendsChatDependencyBridge
