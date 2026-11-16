local NotificationService = game:GetService("NotificationService")
local Players = game:GetService("Players")

local parent = script:FindFirstAncestor("ProfileCtaService").Parent

local RealtimeDelivery = require(parent.RealtimeDelivery)
local robloxEventReceiver = RealtimeDelivery.RobloxEventReceiver.new(NotificationService)
local DataHydration = require(parent.DataHydration)
local getLocalPlayerUserId = DataHydration.DataHydrationUtils.getLocalPlayerUserId

local Constants = require(script.Parent.Constants)

local function createProfileCTAEventListener(callback)
	local v = getLocalPlayerUserId()
	local localPlayerChangedConnection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
		local localPlayerUserId = getLocalPlayerUserId()

		if localPlayerUserId ~= v then
			v = localPlayerUserId
		end
	end)

	local v2 = robloxEventReceiver:observeEvent(Constants.FRIENDSHIP_NOTIFICATIONS, function(p)
		if not (p.EventArgs and p.EventArgs.UserId1 and p.EventArgs.UserId2) then
			return
		end

		local v2

		if tostring(v) == tostring(p.EventArgs.UserId1) then
			v2 = tostring(p.EventArgs.UserId2)
		else
			v2 = tostring(p.EventArgs.UserId1)
		end

		callback(v2)
	end)

	local v3 = robloxEventReceiver:observeEvent(Constants.PRESENCE_BULK_NOTIFICATIONS, function(list)
		if not list or type(list) ~= "table" then
			return
		end

		for _, item in ipairs(list) do
			if item and item.UserId then
				callback((tostring(item.UserId)))
			end
		end
	end)

	return function()
		if localPlayerChangedConnection then
			localPlayerChangedConnection:Disconnect()
			localPlayerChangedConnection = nil
		end

		if v2 then
			v2:disconnect()
			v2 = nil
		end

		if v3 then
			v3:disconnect()
			v3 = nil
		end
	end
end

return createProfileCTAEventListener
