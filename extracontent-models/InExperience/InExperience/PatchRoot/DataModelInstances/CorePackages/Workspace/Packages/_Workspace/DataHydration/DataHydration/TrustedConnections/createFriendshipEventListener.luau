local NotificationService = game:GetService("NotificationService")
local Players = game:GetService("Players")
local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local v5 = require(DataHydrationParent.RealtimeDelivery).RobloxEventReceiver.new(NotificationService)
local getLocalPlayerUserId = require(DataHydration.DataHydrationUtils).getLocalPlayerUserId
local TrustedConnectionStatus = require(DataHydration.TrustedConnections.Enums.TrustedConnectionStatus)
local t1 = {
	Namespace = "FriendshipNotifications",
	EventTypes = {
		FriendshipCreated = "FriendshipCreated",
		FriendshipDestroyed = "FriendshipDestroyed",
		FriendshipRequested = "FriendshipRequested",
		FriendshipDeclined = "FriendshipDeclined"
	}
}

local function createFriendshipEventListener(p1: ((...any) -> ...any)) -- line: 27
	-- upvalues: getLocalPlayerUserId (copy), Players (copy), v5 (copy), t1 (copy), TrustedConnectionStatus (copy)
	local u11 = getLocalPlayerUserId()
	local connection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function() -- line: 32
		-- upvalues: getLocalPlayerUserId (copy), u11 (ref)
		local v14 = getLocalPlayerUserId()

		if v14 ~= u11 then
			u11 = v14
		end
	end)
	local u13 = v5:observeEvent(t1.Namespace, function(p2) -- line: 41
		-- upvalues: u11 (ref), t1 (copy), p1 (copy), TrustedConnectionStatus (copy)
		if not p2.EventArgs or (not p2.EventArgs.UserId1 or not p2.EventArgs.UserId2 or not u11) then
			return
		end

		local v16 = tostring(u11) == tostring(p2.EventArgs.UserId1) and tostring(p2.EventArgs.UserId2) or tostring(p2.EventArgs.UserId1)

		if p2.Type == t1.EventTypes.FriendshipDestroyed or p2.Type == t1.EventTypes.FriendshipDeclined then
			p1(v16, TrustedConnectionStatus.NotFriends)
		end
	end)

	return function() -- line: 66
		-- upvalues: connection (ref), u13 (ref)
		if connection then
			connection:Disconnect()
			connection = nil
		end

		if u13 then
			u13:disconnect()
			u13 = nil
		end
	end
end

return createFriendshipEventListener
