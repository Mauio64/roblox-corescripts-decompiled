local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RealtimeDelivery/React")

local NotificationService = game:GetService("NotificationService")
local v5 = require("@game/CorePackages/Workspace/Packages/_Index/RealtimeDelivery/RealtimeDelivery/TopicEventReceiver").new(NotificationService)

return React.createContext(v5)
