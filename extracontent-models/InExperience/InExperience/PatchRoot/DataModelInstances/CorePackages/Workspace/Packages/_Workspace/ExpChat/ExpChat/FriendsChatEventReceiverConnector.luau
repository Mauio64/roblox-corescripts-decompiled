local ExpChat = script:FindFirstAncestor("ExpChat")
local parent = ExpChat.Parent

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local SharedFlags = require(parent.SharedFlags)
local SignalsReact = require(parent.SignalsReact)

local FriendsChatEventReceiver = require(parent.FriendsChat.FriendsChatEventReceiver)
local FriendsChatTabName = require(parent.FriendsChat.FriendsChatTabName)
local GetTransparencyStore = require(ExpChat.Stores.GetTransparencyStore)
local GetChannelTabsStore = require(ExpChat.Stores.GetChannelTabsStore)
local selectSelectedTabName = require(ExpChat.selectSelectedTabName)
local useChannelTabUnreadWriter = require(ExpChat.useChannelTabUnreadWriter)

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector

local function selectIsChatWindowVisible(p)
	return p.ChatVisibility.isChatWindowEnabled.value
end

local function onActiveConversationMessageReceived()
	GetTransparencyStore(false).resetAllTransparency()
end

local function useSelectedTabNameFromSignals()
	return SignalsReact.useSignalState(GetChannelTabsStore(false).getSelectedTabName)
end

local function useSelectedTabNameFromRodux()
	return useSelector(selectSelectedTabName)
end

if not SharedFlags.FFlagExpChatUseChannelTabsStore then
	useSelectedTabNameFromSignals = useSelectedTabNameFromRodux
end

local function FriendsChatEventReceiverConnector()
	local selectedTabName = useSelectedTabNameFromSignals()
	local isChatWindowVisible = useSelector(selectIsChatWindowVisible)
	local setTabUnread = useChannelTabUnreadWriter(FriendsChatTabName)

	return React.createElement(FriendsChatEventReceiver, {
		setTabUnread = setTabUnread,
		selectedTabName = selectedTabName,
		isChatWindowVisible = isChatWindowVisible,
		onActiveConversationMessageReceived = onActiveConversationMessageReceived
	})
end

return FriendsChatEventReceiverConnector
