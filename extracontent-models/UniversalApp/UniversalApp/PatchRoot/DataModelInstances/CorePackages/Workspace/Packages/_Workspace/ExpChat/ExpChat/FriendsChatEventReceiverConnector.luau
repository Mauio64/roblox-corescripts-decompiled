local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local RoactUtils = require(ExpChatParent.RoactUtils)
local FriendsChatEventReceiver = require(ExpChatParent.FriendsChat.FriendsChatEventReceiver)
local selectSelectedTabName = require(ExpChat.selectSelectedTabName)
local useChannelTabUnreadWriter = require(ExpChat.useChannelTabUnreadWriter)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function FriendsChatEventReceiverConnector(t1: {[any]: any}) -- line: 35
	-- upvalues: useSelector (copy), selectSelectedTabName (copy), useChannelTabUnreadWriter (copy), React (copy), FriendsChatEventReceiver (copy)
	local v11 = useSelector(selectSelectedTabName)
	local v12 = useChannelTabUnreadWriter("FriendsChat")

	return React.createElement(FriendsChatEventReceiver, {
		setTabUnread = v12,
		selectedTabName = v11,
		isChatWindowVisible = t1.isChatWindowVisible
	})
end

return FriendsChatEventReceiverConnector
