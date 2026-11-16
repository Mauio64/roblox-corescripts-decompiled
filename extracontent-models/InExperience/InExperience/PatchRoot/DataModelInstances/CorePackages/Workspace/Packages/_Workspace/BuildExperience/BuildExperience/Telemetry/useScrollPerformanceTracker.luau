local parent = script:FindFirstAncestor("BuildExperience").Parent

local React = require(parent.React)

local IntervalPerformanceTracker = require(parent.IntervalPerformanceTracker)
local createScrollIntervalPerformanceTracker = IntervalPerformanceTracker.createScrollIntervalPerformanceTracker

local function useScrollPerformanceTracker(p: string, p2)
	React.useEffect(function()
		local current = p2.current

		if current == nil then
			return
		end

		local scrollIntervalPerformanceTracker = createScrollIntervalPerformanceTracker(p, current)
		local canvasPositionChangedConnection = current:GetPropertyChangedSignal("CanvasPosition"):Connect(scrollIntervalPerformanceTracker.onScrollTick)

		return function()
			canvasPositionChangedConnection:Disconnect()
			scrollIntervalPerformanceTracker.cleanup()
		end
	end, { p })
end

return useScrollPerformanceTracker
