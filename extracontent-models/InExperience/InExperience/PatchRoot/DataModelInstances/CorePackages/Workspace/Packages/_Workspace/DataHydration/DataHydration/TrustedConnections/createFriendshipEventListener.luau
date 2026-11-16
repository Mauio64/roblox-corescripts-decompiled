local NotificationService = game:GetService("NotificationService")
local Players = game:GetService("Players")

local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local RealtimeDelivery = require(parent.RealtimeDelivery)
local robloxEventReceiver = RealtimeDelivery.RobloxEventReceiver.new(NotificationService)

local DataHydrationUtils = require(DataHydration.DataHydrationUtils)
local getLocalPlayerUserId = DataHydrationUtils.getLocalPlayerUserId

local TrustedConnectionStatus = require(DataHydration.TrustedConnections.Enums.TrustedConnectionStatus)

local v = {
	Namespace = "FriendshipNotifications",
	EventTypes = {
		FriendshipCreated = "FriendshipCreated",
		FriendshipDestroyed = "FriendshipDestroyed",
		FriendshipRequested = "FriendshipRequested",
		FriendshipDeclined = "FriendshipDeclined"
	}
}

local function createFriendshipEventListener(callback)
	local v2 = getLocalPlayerUserId()
	local localPlayerChangedConnection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
		local localPlayerUserId = getLocalPlayerUserId()

		if localPlayerUserId ~= v2 then
			v2 = localPlayerUserId
		end
	end)

	local v3 = robloxEventReceiver:observeEvent(v.Namespace, function(p)
		if not (p.EventArgs and p.EventArgs.UserId1 and p.EventArgs.UserId2 and v2) then
			return
		end

		local userId2 = tostring(v2) == tostring(p.EventArgs.UserId1) and tostring(p.EventArgs.UserId2)
			or tostring(p.EventArgs.UserId1)

		if p.Type == v.EventTypes.FriendshipDestroyed or p.Type == v.EventTypes.FriendshipDeclined then
			callback(userId2, TrustedConnectionStatus.NotFriends)
		end
	end)

	return function()
		if localPlayerChangedConnection then
			localPlayerChangedConnection:Disconnect()
			localPlayerChangedConnection = nil
		end

		if v3 then
			v3:disconnect()
			v3 = nil
		end
	end
end

return createFriendshipEventListener
