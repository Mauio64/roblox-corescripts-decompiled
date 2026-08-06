local Parent = script:FindFirstAncestor("BuildExperience").Parent
local React = require(Parent.React)
local createScrollIntervalPerformanceTracker = require(Parent.IntervalPerformanceTracker).createScrollIntervalPerformanceTracker

local function useScrollPerformanceTracker(s1: string, p1) -- line: 9
	-- upvalues: React (copy), createScrollIntervalPerformanceTracker (copy)
	React.useEffect(function() -- line: 10
		-- upvalues: p1 (copy), createScrollIntervalPerformanceTracker (copy), s1 (copy)
		local current = p1.current

		if current == nil then
			return
		end

		local v8 = createScrollIntervalPerformanceTracker(s1, current)
		local connection = current:GetPropertyChangedSignal("CanvasPosition"):Connect(v8.onScrollTick)

		return function() -- line: 19
			-- upvalues: connection (copy), v8 (copy)
			connection:Disconnect()
			v8.cleanup()
		end
	end, { s1 })
end

return useScrollPerformanceTracker
