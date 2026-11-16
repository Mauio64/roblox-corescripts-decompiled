local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/React")

local Timers = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Timing/Timers")
require("@game/CorePackages/Workspace/Packages/_Workspace/SocialLuaAnalytics/SocialLuaAnalytics/Analytics/Timing/SimpleTimer")

local function useLoadingTimers(p2)
	return React.useRef(Timers(p2)).current
end

return useLoadingTimers
