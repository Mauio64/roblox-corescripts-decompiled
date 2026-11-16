local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Analytics/EventNames")

return React.createContext({
	fireAnalyticsEvent = function() end
})
