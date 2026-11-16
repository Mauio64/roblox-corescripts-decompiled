local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RealtimeDelivery/React")

local TopicRealtimeContext = require("@game/CorePackages/Workspace/Packages/_Index/RealtimeDelivery/RealtimeDelivery/TopicRealtimeContext")

local function useRobloxEventReceiver()
	return React.useContext(TopicRealtimeContext)
end

return useRobloxEventReceiver
