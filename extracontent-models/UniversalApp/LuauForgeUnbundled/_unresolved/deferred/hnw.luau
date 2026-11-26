local module = require("@luauforge/deferred/hmD")

local roact = module.Roact
local roactRodux = module.RoactRodux
local roduxFriends = module.RoduxFriends

local extended = roact.Component:extend("SocialTabEventReceiver")

function extended:init()
	local robloxEventReceiver = self.props.robloxEventReceiver

	self.lastSeqNumByNamespace = {}
	self.lastConnectionState = Enum.ConnectionState.Connected

	self.tokens = {
		robloxEventReceiver:observeEvent("FriendshipNotifications", function(p3)
			if p3.Type == "FriendshipDestroyed" and p3.EventArgs then
				local userId1 = tostring(p3.EventArgs.UserId1)
				local userId2 = tostring(p3.EventArgs.UserId2)
				local v5 = userId1 == self.props.localUserId and "localUserId" or userId1

				local v6 = userId2 == self.props.localUserId and "localUserId" or userId2

				self.props.friendshipDestroyed(v5, v6)
			end
		end),
		robloxEventReceiver:observeEvent("AppShellNotifications", function(p3, p4)
			if p4 == "StartConversationWithUserId" or p4 == "StartConversationWithId" then
				self.props.goToChat()
			end
		end),
		robloxEventReceiver:observeEvent("AppInput", function(p3, p4)
			if p4 == "Focused" then
				self.props.showTabBar()
			end
		end)
	}
end

function extended.render(p2): nil
	return nil
end

function extended.willUnmount(p2)
	for k, token in pairs(p2.tokens) do
		token:disconnect()
	end
end

return roactRodux.connect(function(p2)
	return { localUserId = p2.LocalUserId }
end, function(callback)
	return {
		friendshipDestroyed = function(p2, p3)
			return callback(roduxFriends.Actions.FriendshipDestroyed(p2, p3))
		end
	}
end)(extended)
