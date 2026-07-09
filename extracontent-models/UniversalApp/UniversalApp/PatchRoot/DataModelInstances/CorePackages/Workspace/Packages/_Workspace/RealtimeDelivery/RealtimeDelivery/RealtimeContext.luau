local Parent = script:FindFirstAncestor("RealtimeDelivery").Parent
local React = require(Parent.React)
local NotificationService = game:GetService("NotificationService")
local v4 = require(script.Parent.RobloxEventReceiver).new(NotificationService)

return React.createContext(v4)
