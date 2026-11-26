local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/React")

local createScrollIntervalPerformanceTracker = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceUIKit/IntervalPerformanceTracker").createScrollIntervalPerformanceTracker

local function getNativeScrollingFrame(p2)
	local current = p2.current

	if current == nil then
		return nil
	end

	local nativeScrollRef = current:getNativeScrollRef()

	if nativeScrollRef == nil or nativeScrollRef._nativeRef == nil then
		return nil
	end

	return nativeScrollRef._nativeRef.current
end

local function useFlatListScrollPerformanceTracker(p2, p3, p4)
	React.useEffect(function()
		if p2 == nil then
			return
		end

		local current = p3.current
		local current2

		if current ~= nil then
			local nativeScrollRef = current:getNativeScrollRef()

			if not (nativeScrollRef == nil or nativeScrollRef._nativeRef == nil) then
				current2 = nativeScrollRef._nativeRef.current
			end
		end

		if current2 == nil then
			return
		end

		local scrollIntervalPerformanceTracker = createScrollIntervalPerformanceTracker(p2, current2)
		local canvasPositionChangedConnection = current2:GetPropertyChangedSignal("CanvasPosition"):Connect(scrollIntervalPerformanceTracker.onScrollTick)

		return function()
			canvasPositionChangedConnection:Disconnect()
			scrollIntervalPerformanceTracker.cleanup()
		end
	end, { p2, p3, p4 })
end

return useFlatListScrollPerformanceTracker
