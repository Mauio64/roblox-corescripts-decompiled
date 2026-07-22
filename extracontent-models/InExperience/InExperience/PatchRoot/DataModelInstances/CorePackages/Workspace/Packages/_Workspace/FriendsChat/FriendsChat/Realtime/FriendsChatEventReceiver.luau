local Parent = script:FindFirstAncestor("FriendsChat").Parent
local React = require(Parent.React)
local SignalsReact = require(Parent.SignalsReact)
local GetFriendsChatRealtimeStore = require(script.Parent.Parent.Stores.GetFriendsChatRealtimeStore)
local FriendsChatRealtimeSubscriber = require(script.Parent.FriendsChatRealtimeSubscriber)
local FriendsTabUnreadBridge = require(script.Parent.FriendsTabUnreadBridge)

local function FriendsChatEventReceiver(t1: {[any]: any}) -- line: 34
	-- upvalues: GetFriendsChatRealtimeStore (copy), SignalsReact (copy), React (copy), FriendsTabUnreadBridge (copy), FriendsChatRealtimeSubscriber (copy)
	local v9 = GetFriendsChatRealtimeStore(false)
	local v10 = SignalsReact.useSignalState(v9.getHasEnteredFriendsTab)

	return React.createElement(React.Fragment, nil, {
		unreadBridge = React.createElement(FriendsTabUnreadBridge, {
			setTabUnread = t1.setTabUnread,
			selectedTabName = t1.selectedTabName,
			isChatWindowVisible = t1.isChatWindowVisible
		}),
		subscriber = if not v10 then nil else React.createElement(FriendsChatRealtimeSubscriber)
	})
end

return FriendsChatEventReceiver
