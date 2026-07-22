local ExpChat = script:FindFirstAncestor("ExpChat")
local ExpChatParent = ExpChat.Parent
local React = require(ExpChatParent.React)
local RoactUtils = require(ExpChatParent.RoactUtils)
local FriendsChatEventReceiver = require(ExpChatParent.FriendsChat.FriendsChatEventReceiver)
local selectSelectedTabName = require(ExpChat.selectSelectedTabName)
local useChannelTabUnreadWriter = require(ExpChat.useChannelTabUnreadWriter)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function selectIsChatWindowVisible(p1) -- line: 34
	return p1.ChatVisibility.isChatWindowEnabled.value
end
local function FriendsChatEventReceiverConnector() -- line: 38
	-- upvalues: useSelector (copy), selectSelectedTabName (copy), selectIsChatWindowVisible (copy), useChannelTabUnreadWriter (copy), React (copy), FriendsChatEventReceiver (copy)
	local v12 = useSelector(selectSelectedTabName)
	local v13 = useSelector(selectIsChatWindowVisible)
	local v14 = useChannelTabUnreadWriter("FriendsChat")

	return React.createElement(FriendsChatEventReceiver, {
		setTabUnread = v14,
		selectedTabName = v12,
		isChatWindowVisible = v13
	})
end

return FriendsChatEventReceiverConnector
