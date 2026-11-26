local NotificationService = game:GetService("NotificationService")
local Players = game:GetService("Players")

local robloxEventReceiver = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileCtaService/RealtimeDelivery").RobloxEventReceiver.new(NotificationService)
local getLocalPlayerUserId = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfileCtaService/DataHydration").DataHydrationUtils.getLocalPlayerUserId

local Constants = require("@game/CorePackages/Workspace/Packages/_Index/ProfileCtaService/ProfileCtaService/Constants")

local function createProfileCTAEventListener(callback)
	local v5 = getLocalPlayerUserId()
	local localPlayerChangedConnection = Players:GetPropertyChangedSignal("LocalPlayer"):Connect(function()
		local localPlayerUserId = getLocalPlayerUserId()

		if localPlayerUserId ~= v5 then
			v5 = localPlayerUserId
		end
	end)

	local v6 = robloxEventReceiver:observeEvent(Constants.FRIENDSHIP_NOTIFICATIONS, function(p2)
		if not (p2.EventArgs and p2.EventArgs.UserId1 and p2.EventArgs.UserId2) then
			return
		end

		local v7 = if tostring(v5) == tostring(p2.EventArgs.UserId1) then tostring(p2.EventArgs.UserId2) else tostring(p2.EventArgs.UserId1)
		callback(v7)
	end)

	local v7 = robloxEventReceiver:observeEvent(Constants.PRESENCE_BULK_NOTIFICATIONS, function(list)
		if not list or type(list) ~= "table" then
			return
		end

		for i, item in ipairs(list) do
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

		if v6 then
			v6:disconnect()
			v6 = nil
		end

		if v7 then
			v7:disconnect()
			v7 = nil
		end
	end
end

return createProfileCTAEventListener
