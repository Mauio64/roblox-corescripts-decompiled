local parent = script:FindFirstAncestor("RealtimeDelivery").Parent
local React = require(parent.React)

local NotificationService = game:GetService("NotificationService")
local RobloxEventReceiver = require(script.Parent.RobloxEventReceiver)

local v = RobloxEventReceiver.new(NotificationService)

return React.createContext(v)
