local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)

local useFriendsChatBubbleMessageListViewModel = require(script.Parent.useFriendsChatBubbleMessageListViewModel)
local FriendsChatBubbleMessageListView = require(script.Parent.FriendsChatBubbleMessageListView)

local function FriendsChatBubbleMessageListContainer(p)
	local v = useFriendsChatBubbleMessageListViewModel(p)
	return React.createElement(FriendsChatBubbleMessageListView, v)
end

return FriendsChatBubbleMessageListContainer
