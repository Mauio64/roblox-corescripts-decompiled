local NotificationService = game:GetService("NotificationService")

local parent = script:FindFirstAncestor("AppChat").Parent

local RealtimeDelivery = require(parent.RealtimeDelivery)
local RobloxEventReceiver = RealtimeDelivery.RobloxEventReceiver

local createHttpPort = require(script.createHttpPort)
local createRealtimePort = require(script.createRealtimePort)

return {
	current = {
		http = createHttpPort(nil),
		realtime = createRealtimePort(function()
			return RobloxEventReceiver.new(NotificationService)
		end)
	}
}
