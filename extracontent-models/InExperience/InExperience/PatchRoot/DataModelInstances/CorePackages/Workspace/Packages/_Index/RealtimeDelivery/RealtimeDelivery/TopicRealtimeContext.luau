local RealtimeDelivery = script:FindFirstAncestor("RealtimeDelivery")
local React = require(RealtimeDelivery.Parent.React)

local NotificationService = game:GetService("NotificationService")
local TopicEventReceiver = require(script.Parent.TopicEventReceiver)

local v = TopicEventReceiver.new(NotificationService)

return React.createContext(v)
