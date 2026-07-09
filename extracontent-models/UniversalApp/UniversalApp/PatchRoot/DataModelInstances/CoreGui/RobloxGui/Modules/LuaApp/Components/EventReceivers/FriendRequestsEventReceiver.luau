local CorePackages = game:GetService("CorePackages")
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local EventNetworking = require(script.Parent.EventNetworking)
local v5 = Roact.PureComponent:extend("FriendRequestsEventReceiver")

function v5.init(p1) -- line: 20
	-- upvalues: EventNetworking (copy)
	p1.tokens = { p1.props.RobloxEventReceiver:observeEvent("FriendshipNotifications", function(p2) -- line: 24
		-- upvalues: p1 (copy), EventNetworking (copy)
		local p2Type = p2.Type

		if ({
			FriendshipRequested = true,
			FriendshipDeclined = true,
			FriendshipCreated = true
		})[p2Type] then
			local friendRequestCountStatus = p1.props.friendRequestCountStatus

			if EventNetworking.RoduxNetworking.Enum.NetworkStatus.Fetching ~= not friendRequestCountStatus then
				p1.props.dispatchFetchFriendRequestsCount(p1.props.localUserId)
				p1.props.updateNewFriendRequestsCount(p1.props.localUserId)
			end
		end
	end) }
end
function v5.render(_) -- line: 39
	return nil
end
function v5.willUnmount(p4) -- line: 43
	for _, v in pairs(p4.tokens) do
		v:disconnect()
	end
end

return RoactRodux.connect(function(p5) -- line: 49
	-- upvalues: EventNetworking (copy)
	return {
		localUserId = p5.LocalUserId,
		friendRequestCountStatus = EventNetworking.FriendsNetworking.GetFriendRequestsCount.getStatus(p5)
	}
end, function(p6, _) -- line: 54
	-- upvalues: EventNetworking (copy)
	return {
		dispatchFetchFriendRequestsCount = function(p8) -- line: 56
			-- upvalues: p6 (copy), EventNetworking (copy)
			return p6(EventNetworking.FriendsNetworking.GetFriendRequestsCount.API(p8))
		end,
		updateNewFriendRequestsCount = function(p9) -- line: 59
			-- upvalues: p6 (copy), EventNetworking (copy)
			return p6(EventNetworking.FriendsNetworking.GetNewFriendRequestsCount.API(p9))
		end
	}
end)(v5)
