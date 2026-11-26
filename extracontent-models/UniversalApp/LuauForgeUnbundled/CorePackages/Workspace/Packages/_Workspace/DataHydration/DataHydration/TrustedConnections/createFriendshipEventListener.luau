local NotificationService = game:GetService("NotificationService")
local Players = game:GetService("Players")

local robloxEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/RealtimeDelivery").RobloxEventReceiver.new(NotificationService)

local getLocalPlayerUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils").getLocalPlayerUserId

local TrustedConnectionStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/TrustedConnections/Enums/TrustedConnectionStatus")

local v5 = {
	Namespace = "FriendshipNotifications",
	EventTypes = {
		FriendshipCreated = "FriendshipCreated",
		FriendshipDestroyed = "FriendshipDestroyed",
		FriendshipRequested = "FriendshipRequested",
		FriendshipDeclined = "FriendshipDeclined"
	}
}

local function createFriendshipEventListener(callback)
	local v6 = getLocalPlayerUserId()
	local localPlayerChangedConnection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
		local localPlayerUserId = getLocalPlayerUserId()

		if localPlayerUserId ~= v6 then
			v6 = localPlayerUserId
		end
	end)

	local v7 = robloxEventReceiver:observeEvent(v5.Namespace, function(p2)
		if not (p2.EventArgs and p2.EventArgs.UserId1 and p2.EventArgs.UserId2 and v6) then
			return
		end

		local userId2 = tostring(v6) == tostring(p2.EventArgs.UserId1) and tostring(p2.EventArgs.UserId2)
			or tostring(p2.EventArgs.UserId1)

		if p2.Type == v5.EventTypes.FriendshipDestroyed or p2.Type == v5.EventTypes.FriendshipDeclined then
			callback(userId2, TrustedConnectionStatus.NotFriends)
		end
	end)

	return function()
		if localPlayerChangedConnection then
			localPlayerChangedConnection:Disconnect()
			localPlayerChangedConnection = nil
		end

		if v7 then
			v7:disconnect()
			v7 = nil
		end
	end
end

return createFriendshipEventListener
