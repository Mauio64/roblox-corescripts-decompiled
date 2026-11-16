local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/React")

local createScrollIntervalPerformanceTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/IntervalPerformanceTracker").createScrollIntervalPerformanceTracker

local function useScrollPerformanceTracker(p2, p3)
	React.useEffect(function()
		local current = p3.current

		if current == nil then
			return
		end

		local scrollIntervalPerformanceTracker = createScrollIntervalPerformanceTracker(p2, current)
		local canvasPositionChangedConnection = current:GetPropertyChangedSignal("CanvasPosition"):Connect(scrollIntervalPerformanceTracker.onScrollTick)

		return function()
			canvasPositionChangedConnection:Disconnect()
			scrollIntervalPerformanceTracker.cleanup()
		end
	end, { p2 })
end

return useScrollPerformanceTracker
