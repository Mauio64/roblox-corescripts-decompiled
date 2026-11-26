local React = require("@game/CorePackages/Workspace/Packages/_Workspace/RealtimeDelivery/React")

local TopicRealtimeContext = require("@game/CorePackages/Workspace/Packages/_Index/RealtimeDelivery/RealtimeDelivery/TopicRealtimeContext")

local function RealtimeProvider(p2)
	return React.createElement(TopicRealtimeContext.Provider, { value = p2.realtime }, p2.children)
end

return RealtimeProvider
