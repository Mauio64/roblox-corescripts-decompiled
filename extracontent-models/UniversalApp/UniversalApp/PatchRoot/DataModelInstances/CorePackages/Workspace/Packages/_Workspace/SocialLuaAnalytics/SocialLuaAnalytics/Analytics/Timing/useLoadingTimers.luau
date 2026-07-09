local Parent = script:FindFirstAncestor("SocialLuaAnalytics").Parent
local React = require(Parent.React)
local Timers = require(script.Parent.Timers)

require(script.Parent.SimpleTimer)

local function useLoadingTimers(p1) -- line: 9
	-- upvalues: React (copy), Timers (copy)
	return React.useRef(Timers(p1)).current
end

return useLoadingTimers
