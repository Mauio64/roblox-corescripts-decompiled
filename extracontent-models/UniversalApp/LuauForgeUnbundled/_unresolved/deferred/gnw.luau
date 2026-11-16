local CorePackages = game:GetService("CorePackages")
local Cryo = require(CorePackages.Packages.Cryo)
local React = require(CorePackages.Packages.React)
local module = require("@luauforge/bundled/edl")
local module2 = require("@luauforge/bundled/ede")
local useAXAnimateScrollFrame = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Components.AnimatedScrollingFrame.useAXAnimateScrollFrame

local fFlagAXScrollTelemetryIntegration2 = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXScrollTelemetryIntegration2

local createScrollIntervalPerformanceTracker = require("@luauforge/bundled/fvL").createScrollIntervalPerformanceTracker
local module3 = require("@luauforge/bundled/dOc")
local v5 = module3() and game:DefineFastFlag("AXScrollingFramePreloadDistanceProp2", false)
local v6 = module3() and game:DefineFastFlag("AXScrollingFramePreventInitialLoadMore3", false)
local defineFastInt = game:DefineFastInt("AXScrollingPreloadDistance", 2000)

return React.forwardRef(function(props, p2)
	local ref, v7

	if v6 then
		ref = React.useRef(not props.preventInitialLoadMore)

		v7 = React.useCallback(module2(function()
			ref.current = true
		end, 0.5), {})
	else
		ref = nil
		v7 = nil
	end

	local function onScrollingFrameChanged(data)
		local onThresholdReached = props.onThresholdReached

		local v8 = if v6 then not props.preventInitialLoadMore or ref.current else nil

		if onThresholdReached then
			if v6 and not v8 then
				return
			end

			local y = data.CanvasPosition.Y
			local v9 = data.CanvasSize.Y.Offset - data.AbsoluteWindowSize.Y

			local v10 = if v5 and props.preloadDistance then props.preloadDistance else defineFastInt

			if v9 - v10 < y then
				onThresholdReached()
			end
		end
	end

	local function onCanvasPositionChanged(p3)
		onScrollingFrameChanged(p3)

		if props.onCanvasPositionChanged then
			props.onCanvasPositionChanged(p3)
		end
	end

	local function onCanvasSizeChanged(p3)
		if v6 and not (ref and ref.current) then
			v7()
		end

		onScrollingFrameChanged(p3)

		if props.onCanvasSizeChanged then
			props.onCanvasSizeChanged(p3)
		end
	end

	local function onAbsoluteWindowSizeChanged(p3)
		onScrollingFrameChanged(p3)

		if props.onAbsoluteWindowSizeChanged then
			props.onAbsoluteWindowSizeChanged(p3)
		end
	end

	local ref2 = React.useRef(nil)
	local v8 = p2 or ref2
	useAXAnimateScrollFrame(v8)

	local v9 = fFlagAXScrollTelemetryIntegration2 and props.scrollPerformanceIntervalName ~= nil
	local v10

	if fFlagAXScrollTelemetryIntegration2 then
		local ref3 = React.useRef(nil)

		v10 = React.useCallback(function(current)
			ref3.current = current

			if type(v8) == "function" then
				v8(current)
			elseif type(v8) == "table" then
				v8.current = current
			end
		end, { v8 })

		React.useEffect(function()
			local scrollPerformanceIntervalName = props.scrollPerformanceIntervalName
			local current = ref3.current

			if scrollPerformanceIntervalName == nil or current == nil then
				return
			end

			local scrollIntervalPerformanceTracker = createScrollIntervalPerformanceTracker(
				scrollPerformanceIntervalName,
				current
			)
			local canvasPositionChangedConnection = current:GetPropertyChangedSignal("CanvasPosition"):Connect(scrollIntervalPerformanceTracker.onScrollTick)
			return function()
				canvasPositionChangedConnection:Disconnect()
				scrollIntervalPerformanceTracker.cleanup()
			end
		end, { props.scrollPerformanceIntervalName })
	end

	local join = Cryo.Dictionary.join
	local v11 = {
		onCanvasPositionChangedCallback = onCanvasPositionChanged,
		onCanvasSizeChangedCallback = onCanvasSizeChanged,
		onAbsoluteWindowSizeChangedCallback = onAbsoluteWindowSizeChanged,
		onThresholdReached = Cryo.None,
		showLoadingBar = Cryo.None,
		onCanvasPositionChanged = Cryo.None,
		onCanvasSizeChanged = Cryo.None,
		onAbsoluteWindowSizeChanged = Cryo.None,
		scrollPerformanceIntervalName = Cryo.None,
		Selectable = props.Selectable,
		ref = 0
	}

	if not v9 then
		v10 = v8
	end

	v11.ref = v10
	local v12 = join(props, v11)

	return React.createElement(module, v12)
end)
