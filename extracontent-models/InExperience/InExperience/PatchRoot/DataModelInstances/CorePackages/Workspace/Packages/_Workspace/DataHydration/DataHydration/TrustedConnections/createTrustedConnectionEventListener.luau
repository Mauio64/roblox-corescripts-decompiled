local NotificationService = game:GetService("NotificationService")
local Players = game:GetService("Players")
local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local v5 = require(DataHydrationParent.RealtimeDelivery).RobloxEventReceiver.new(NotificationService)
local getLocalPlayerUserId = require(DataHydration.DataHydrationUtils).getLocalPlayerUserId
local TrustedConnectionStatus = require(DataHydration.TrustedConnections.Enums.TrustedConnectionStatus)
local FFlagAddFriendsPageTrustedFriendRequestSection = require(DataHydrationParent.SharedFlags).FFlagAddFriendsPageTrustedFriendRequestSection
local t1 = {
	Namespace = "TrustedConnectionNotifications",
	EventTypes = {
		TrustedConnectionCreated = 1,
		TrustedConnectionDeleted = 2,
		TrustedConnectionRequestSent = 3,
		TrustedConnectionRequestAccepted = 4,
		TrustedConnectionRequestIgnored = 5
	}
}

local function createTrustedConnectionEventListener(p1: ((...any) -> ...any)) -- line: 40
	-- upvalues: getLocalPlayerUserId (copy), Players (copy), v5 (copy), t1 (copy), TrustedConnectionStatus (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy)
	local u12 = getLocalPlayerUserId()
	local connection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function() -- line: 48
		-- upvalues: getLocalPlayerUserId (copy), u12 (ref)
		local v15 = getLocalPlayerUserId()

		if v15 ~= u12 then
			u12 = v15
		end
	end)
	local v14 = v5:observeEvent(t1.Namespace, function(t2: {[any]: any}) -- line: 57
		-- upvalues: u12 (ref), t1 (copy), p1 (copy), TrustedConnectionStatus (copy), FFlagAddFriendsPageTrustedFriendRequestSection (copy)
		if not t2.Actor or (not t2.Target or not u12) then
			return
		end

		local str = tostring(t2.Actor)
		local str2 = tostring(t2.Target)
		local str3 = tostring(u12)

		if t2.EventType == t1.EventTypes.TrustedConnectionCreated then
			local v20 = if str ~= str3 then str else str2

			p1(v20, TrustedConnectionStatus.TrustedFriends)
		end

		if t2.EventType == t1.EventTypes.TrustedConnectionDeleted then
			if str3 == str then
				if FFlagAddFriendsPageTrustedFriendRequestSection then
					p1(str2, TrustedConnectionStatus.RequestIgnored)
				else
					p1(str2, TrustedConnectionStatus.RequestReceived)
				end
			else
				p1(str, TrustedConnectionStatus.RequestSent)
			end
		end

		if t2.EventType == t1.EventTypes.TrustedConnectionRequestSent then
			if str3 == str then
				p1(str2, TrustedConnectionStatus.RequestSent)

				return
			end

			p1(str, TrustedConnectionStatus.RequestReceived)
		end
	end)

	return function() -- line: 93
		-- upvalues: connection (ref), v14 (copy)
		if connection then
			connection:Disconnect()
			connection = nil
		end

		if v14 then
			v14:disconnect()
			connection = nil
		end
	end
end

return createTrustedConnectionEventListener
