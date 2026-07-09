local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local FriendsChatDependencyContext = require(script.Parent.FriendsChatDependencyContext)

local function useChatWindow() -- line: 8
	-- upvalues: React (copy), FriendsChatDependencyContext (copy)
	local v5 = React.useContext(FriendsChatDependencyContext)

	if v5 == nil then
		error("useChatWindow must be used within a FriendsChatDependencyBridge")
	end

	return v5.ChatWindow
end

return useChatWindow
