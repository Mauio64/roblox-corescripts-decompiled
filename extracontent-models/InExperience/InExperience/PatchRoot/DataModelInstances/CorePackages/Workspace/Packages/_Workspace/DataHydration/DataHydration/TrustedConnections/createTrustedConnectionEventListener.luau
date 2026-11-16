local NotificationService = game:GetService("NotificationService")
local Players = game:GetService("Players")

local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local RealtimeDelivery = require(parent.RealtimeDelivery)
local robloxEventReceiver = RealtimeDelivery.RobloxEventReceiver.new(NotificationService)

local DataHydrationUtils = require(DataHydration.DataHydrationUtils)
local getLocalPlayerUserId = DataHydrationUtils.getLocalPlayerUserId

local TrustedConnectionStatus = require(DataHydration.TrustedConnections.Enums.TrustedConnectionStatus)

local SharedFlags = require(parent.SharedFlags)
local FFlagAddFriendsPageTrustedFriendRequestSection = SharedFlags.FFlagAddFriendsPageTrustedFriendRequestSection

local v = {
	Namespace = "TrustedConnectionNotifications",
	EventTypes = {
		TrustedConnectionCreated = 1,
		TrustedConnectionDeleted = 2,
		TrustedConnectionRequestSent = 3,
		TrustedConnectionRequestAccepted = 4,
		TrustedConnectionRequestIgnored = 5
	}
}

local function createTrustedConnectionEventListener(callback)
	local v2 = getLocalPlayerUserId()
	local localPlayerChangedConnection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
		local localPlayerUserId = getLocalPlayerUserId()

		if localPlayerUserId ~= v2 then
			v2 = localPlayerUserId
		end
	end)

	local v3 = robloxEventReceiver:observeEvent(v.Namespace, function(data)
		if not (data.Actor and data.Target and v2) then
			return
		end

		local actor = tostring(data.Actor)
		local target = tostring(data.Target)
		local v3 = tostring(v2)

		if data.EventType == v.EventTypes.TrustedConnectionCreated then
			local v4 = if actor == v3 then target else actor
			callback(v4, TrustedConnectionStatus.TrustedFriends)
		end

		if data.EventType == v.EventTypes.TrustedConnectionDeleted then
			if v3 == actor then
				if FFlagAddFriendsPageTrustedFriendRequestSection then
					callback(target, TrustedConnectionStatus.RequestIgnored)
				else
					callback(target, TrustedConnectionStatus.RequestReceived)
				end
			else
				callback(actor, TrustedConnectionStatus.RequestSent)
			end
		end

		if data.EventType == v.EventTypes.TrustedConnectionRequestSent then
			if v3 == actor then
				callback(target, TrustedConnectionStatus.RequestSent)
			else
				callback(actor, TrustedConnectionStatus.RequestReceived)
			end
		end
	end)

	return function()
		if localPlayerChangedConnection then
			localPlayerChangedConnection:Disconnect()
			localPlayerChangedConnection = nil
		end

		if v3 then
			v3:disconnect()
			localPlayerChangedConnection = nil
		end
	end
end

return createTrustedConnectionEventListener
