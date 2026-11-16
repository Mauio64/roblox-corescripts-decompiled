local parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent

local React = require(parent.React)

local Timers = require(script.Parent.Timers)
require(script.Parent.SimpleTimer)

local function useLoadingTimers(p)
	return React.useRef(Timers(p)).current
end

return useLoadingTimers
