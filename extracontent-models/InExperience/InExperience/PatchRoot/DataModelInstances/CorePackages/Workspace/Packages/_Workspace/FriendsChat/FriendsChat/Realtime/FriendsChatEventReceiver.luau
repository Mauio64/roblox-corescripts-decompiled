local parent = script:FindFirstAncestor("FriendsChat").Parent

local React = require(parent.React)
local SignalsReact = require(parent.SignalsReact)
local SharedFlags = require(parent.SharedFlags)

local ExpChatShared = require(parent.ExpChatShared)
local FriendsSurfaceVisibility = ExpChatShared.FriendsSurfaceVisibility
local GetFriendsChatNavigationStore = require(script.Parent.Parent.Stores.GetFriendsChatNavigationStore)
local GetFriendsChatRealtimeStore = require(script.Parent.Parent.Stores.GetFriendsChatRealtimeStore)
local FriendsChatRealtimeSubscriber = require(script.Parent.FriendsChatRealtimeSubscriber)
local FriendsCountRefetchBridge = require(script.Parent.FriendsCountRefetchBridge)
local FriendsTabUnreadBridge = require(script.Parent.FriendsTabUnreadBridge)
local FriendsChatTabName = require(script.Parent.Parent.FriendsChatTabName)

local FFlagFriendsChatHasFriendsGate = SharedFlags.FFlagFriendsChatHasFriendsGate
local FFlagExpChatCanShowFriendsTab = SharedFlags.FFlagExpChatCanShowFriendsTab

local function FriendsChatEventReceiver(props)
	local friendsChatRealtimeStore = GetFriendsChatRealtimeStore(false)
	local v = SignalsReact.useSignalState(friendsChatRealtimeStore.getHasEnteredFriendsTab)

	local v2 = SignalsReact.useSignalState(GetFriendsChatNavigationStore(false).getSelectedConversationId)

	React.useEffect(function()
		local v3

		if props.isChatWindowVisible and props.selectedTabName == FriendsChatTabName then
			v3 = v2
		else
			v3 = nil
		end

		FriendsSurfaceVisibility.setVisibleConversationId(v3)

		return function()
			if FriendsSurfaceVisibility.getVisibleConversationId(false) == v3 then
				FriendsSurfaceVisibility.setVisibleConversationId(nil)
			end
		end
	end, { props.isChatWindowVisible, props.selectedTabName, v2 })

	local createElement = React.createElement
	local fragment = React.Fragment
	local v3 = {
		unreadBridge = React.createElement(FriendsTabUnreadBridge, {
			setTabUnread = props.setTabUnread,
			selectedTabName = props.selectedTabName,
			isChatWindowVisible = props.isChatWindowVisible
		}),
		countRefetchBridge = 0,
		subscriber = 0
	}
	local countRefetchBridge

	if FFlagFriendsChatHasFriendsGate and FFlagExpChatCanShowFriendsTab then
		countRefetchBridge = React.createElement(FriendsCountRefetchBridge)
	end

	v3.countRefetchBridge = countRefetchBridge
	local subscriber

	if v then
		subscriber = React.createElement(FriendsChatRealtimeSubscriber, {
			onActiveConversationMessageReceived = props.onActiveConversationMessageReceived
		})
	end

	v3.subscriber = subscriber
	return createElement(fragment, nil, v3)
end

return FriendsChatEventReceiver
