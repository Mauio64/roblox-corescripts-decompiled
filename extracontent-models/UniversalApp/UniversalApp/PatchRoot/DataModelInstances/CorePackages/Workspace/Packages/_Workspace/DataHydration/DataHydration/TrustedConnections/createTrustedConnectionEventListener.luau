local NotificationService = game:GetService("NotificationService")
local Players = game:GetService("Players")
local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local v5 = require(DataHydrationParent.RealtimeDelivery).RobloxEventReceiver.new(NotificationService)
local getLocalPlayerUserId = require(DataHydration.DataHydrationUtils).getLocalPlayerUserId
local TrustedConnectionStatus = require(DataHydration.TrustedConnections.Enums.TrustedConnectionStatus)
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

local function createTrustedConnectionEventListener(p1: ((...any) -> ...any)) -- line: 37
	-- upvalues: getLocalPlayerUserId (copy), Players (copy), v5 (copy), t1 (copy), TrustedConnectionStatus (copy)
	local u11 = getLocalPlayerUserId()
	local connection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function() -- line: 45
		-- upvalues: getLocalPlayerUserId (copy), u11 (ref)
		local v14 = getLocalPlayerUserId()

		if v14 ~= u11 then
			u11 = v14
		end
	end)
	local v13 = v5:observeEvent(t1.Namespace, function(t2: {[any]: any}) -- line: 54
		-- upvalues: u11 (ref), t1 (copy), p1 (copy), TrustedConnectionStatus (copy)
		if not t2.Actor or (not t2.Target or not u11) then
			return
		end

		local str = tostring(t2.Actor)
		local str2 = tostring(t2.Target)
		local str3 = tostring(u11)

		if t2.EventType == t1.EventTypes.TrustedConnectionCreated then
			local v19 = if str ~= str3 then str else str2

			p1(v19, TrustedConnectionStatus.TrustedFriends)
		end

		if t2.EventType == t1.EventTypes.TrustedConnectionDeleted then
			if str3 == str then
				p1(str2, TrustedConnectionStatus.RequestReceived)
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

	return function() -- line: 86
		-- upvalues: connection (ref), v13 (copy)
		if connection then
			connection:Disconnect()
			connection = nil
		end

		if v13 then
			v13:disconnect()
			connection = nil
		end
	end
end

return createTrustedConnectionEventListener
