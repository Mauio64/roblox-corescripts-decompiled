local scriptParent = script.Parent
local dependencies = require(scriptParent.dependencies)
local Roact = dependencies.Roact
local RoactRodux = dependencies.RoactRodux
local RoduxFriends = dependencies.RoduxFriends
local v6 = Roact.Component:extend("SocialTabEventReceiver")

function v6.init(p1) -- line: 16
	local robloxEventReceiver = p1.props.robloxEventReceiver

	p1.lastSeqNumByNamespace = {}
	p1.lastConnectionState = Enum.ConnectionState.Connected
	p1.tokens = {
		robloxEventReceiver:observeEvent("FriendshipNotifications", function(p2) -- line: 24
			-- upvalues: p1 (copy)
			if p2.Type == "FriendshipDestroyed" and p2.EventArgs then
				local str = tostring(p2.EventArgs.UserId1)
				local str2 = tostring(p2.EventArgs.UserId2)

				if str == p1.props.localUserId then
					str = "localUserId"
				end

				if str2 == p1.props.localUserId then
					str2 = "localUserId"
				end

				p1.props.friendshipDestroyed(str, str2)
			end
		end),
		robloxEventReceiver:observeEvent("AppShellNotifications", function(_, p4) -- line: 42
			-- upvalues: p1 (copy)
			if p4 == "StartConversationWithUserId" or p4 == "StartConversationWithId" then
				p1.props.goToChat()
			end
		end),
		robloxEventReceiver:observeEvent("AppInput", function(_, p6) -- line: 49
			-- upvalues: p1 (copy)
			if p6 == "Focused" then
				p1.props.showTabBar()
			end
		end)
	}
end
function v6.render(_) -- line: 57
	return nil
end
function v6.willUnmount(p8) -- line: 61
	for _, v in pairs(p8.tokens) do
		v:disconnect()
	end
end

return RoactRodux.connect(function(p9) -- line: 67
	return {
		localUserId = p9.LocalUserId
	}
end, function(p10) -- line: 71
	-- upvalues: RoduxFriends (copy)
	return {
		friendshipDestroyed = function(p11, p12) -- line: 73
			-- upvalues: p10 (copy), RoduxFriends (copy)
			return p10(RoduxFriends.Actions.FriendshipDestroyed(p11, p12))
		end
	}
end)(v6)
