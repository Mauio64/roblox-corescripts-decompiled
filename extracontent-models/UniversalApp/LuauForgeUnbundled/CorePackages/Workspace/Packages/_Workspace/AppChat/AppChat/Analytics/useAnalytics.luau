local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/React")

local RoactChatAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/AppChat/AppChat/Analytics/RoactChatAnalyticsContext")

return function()
	return React.useContext(RoactChatAnalyticsContext)
end
