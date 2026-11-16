local parent = script:FindFirstAncestor("AvatarExperienceUIKit").Parent

local React = require(parent.React)

local IntervalPerformanceTracker = require(parent.IntervalPerformanceTracker)
local createScrollIntervalPerformanceTracker = IntervalPerformanceTracker.createScrollIntervalPerformanceTracker

local function getNativeScrollingFrame(p) -- 1 equivalent call inferred from this helper
	local current = p.current

	if current == nil then
		return nil
	end

	local nativeScrollRef = current:getNativeScrollRef()

	if nativeScrollRef == nil or nativeScrollRef._nativeRef == nil then
		return nil
	end

	return nativeScrollRef._nativeRef.current
end

local function useFlatListScrollPerformanceTracker(p: string?, p2, p3)
	React.useEffect(function()
		if p == nil then
			return
		end

		local nativeScrollingFrame = getNativeScrollingFrame(p2) -- inferred equivalent call

		if nativeScrollingFrame == nil then
			return
		end

		local scrollIntervalPerformanceTracker = createScrollIntervalPerformanceTracker(p, nativeScrollingFrame)
		local canvasPositionChangedConnection = nativeScrollingFrame:GetPropertyChangedSignal("CanvasPosition"):Connect(scrollIntervalPerformanceTracker.onScrollTick)

		return function()
			canvasPositionChangedConnection:Disconnect()
			scrollIntervalPerformanceTracker.cleanup()
		end
	end, { p, p2, p3 })
end

return useFlatListScrollPerformanceTracker
