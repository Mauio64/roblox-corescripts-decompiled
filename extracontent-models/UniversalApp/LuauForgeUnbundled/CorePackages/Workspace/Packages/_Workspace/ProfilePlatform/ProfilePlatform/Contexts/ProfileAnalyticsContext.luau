local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Analytics/EventNames")
local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/AppCommonLib")

return React.createContext({
	fireAnalyticsEvent = function() end,
	scrollViewPositionChangedSignal = AppCommonLib.Signal.new()
})
