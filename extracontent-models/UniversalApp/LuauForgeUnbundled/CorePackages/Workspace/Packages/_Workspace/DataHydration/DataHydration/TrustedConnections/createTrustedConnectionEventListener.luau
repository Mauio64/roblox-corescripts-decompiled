local NotificationService = game:GetService("NotificationService")
local Players = game:GetService("Players")

local robloxEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/RealtimeDelivery").RobloxEventReceiver.new(NotificationService)

local getLocalPlayerUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils").getLocalPlayerUserId

local TrustedConnectionStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/TrustedConnections/Enums/TrustedConnectionStatus")

local fFlagAddFriendsPageTrustedFriendRequestSection = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagAddFriendsPageTrustedFriendRequestSection

local v5 = {
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
	local v6 = getLocalPlayerUserId()
	local localPlayerChangedConnection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
		local localPlayerUserId = getLocalPlayerUserId()

		if localPlayerUserId ~= v6 then
			v6 = localPlayerUserId
		end
	end)

	local v7 = robloxEventReceiver:observeEvent(v5.Namespace, function(data)
		if not (data.Actor and data.Target and v6) then
			return
		end

		local actor = tostring(data.Actor)
		local target = tostring(data.Target)
		local v8 = tostring(v6)

		if data.EventType == v5.EventTypes.TrustedConnectionCreated then
			local v9 = if actor == v8 then target else actor
			callback(v9, TrustedConnectionStatus.TrustedFriends)
		end

		if data.EventType == v5.EventTypes.TrustedConnectionDeleted then
			if v8 == actor then
				if fFlagAddFriendsPageTrustedFriendRequestSection then
					callback(target, TrustedConnectionStatus.RequestIgnored)
				else
					callback(target, TrustedConnectionStatus.RequestReceived)
				end
			else
				callback(actor, TrustedConnectionStatus.RequestSent)
			end
		end

		if data.EventType == v5.EventTypes.TrustedConnectionRequestSent then
			if v8 == actor then
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

		if v7 then
			v7:disconnect()
			localPlayerChangedConnection = nil
		end
	end
end

return createTrustedConnectionEventListener
