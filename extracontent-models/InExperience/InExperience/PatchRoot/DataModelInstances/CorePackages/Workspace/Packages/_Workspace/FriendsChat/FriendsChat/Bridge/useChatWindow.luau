local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)

local FriendsChatDependencyContext = require(script.Parent.FriendsChatDependencyContext)

local function useChatWindow()
	local v = React.useContext(FriendsChatDependencyContext)

	if v == nil then
		error("useChatWindow must be used within a FriendsChatDependencyBridge")
	end

	return v.ChatWindow
end

return useChatWindow
