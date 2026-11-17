local parent = script:FindFirstAncestor("Impressions").Parent
local React = require(parent.React)
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal
local ImpressionsDetector = require(script.Parent.ImpressionsDetector)
local ImpressionDetectorWithoutNavigation = require(script.Parent.ImpressionDetectorWithoutNavigation)
local ImpressionsVisualizer = require(script.Parent.ImpressionsVisualizer)
local SharedFlags = require(parent.SharedFlags)

local defineFastFlag = game:DefineFastFlag("LuaAppFixImpressionsHookDependencies", false)

local FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions
local FFlagLuaAppSduiGameDwell = SharedFlags.FFlagLuaAppSduiGameDwell

return function(props)
	local ref = React.useRef({})
	local ref2 = React.useRef(Signal.new())

	local ref3 = React.useRef(nil)

	if ref3.current == nil then
		ref3.current = ImpressionsVisualizer.new(props.impressionsTag)
	end

	assert(ref3.current, "impressionsVisualizer should always be truthy; check needed for lint")
	local state, setState = React.useState({})
	local state2, setState2 = React.useState(props.dataUpdatedTimestamp)

	local ref4 = React.useRef(props.impressionsTag)
	local viewPortBounds = props.viewPortBounds

	local useEffect = React.useEffect
	local function fn()
		if ref4.current ~= props.impressionsTag then
			ref4.current = props.impressionsTag
			setState2(props.dataUpdatedTimestamp)
			ref.current = {}
			ref3.current:onClearAllImpressions()
			ref3.current:setImpressionsTag(props.impressionsTag)
			ref2.current:fire()
		end
	end
	local impressionsTag = props.impressionsTag
	local v

	if defineFastFlag then
		v = props.dataUpdatedTimestamp
	end

	useEffect(fn, { impressionsTag, v })

	React.useEffect(function()
		ref2.current:fire()
		local scrollViewPositionChangedSignalConnection

		if props.scrollViewPositionChangedSignal then
			scrollViewPositionChangedSignalConnection = props.scrollViewPositionChangedSignal:connect(function()
				ref2.current:fire()
			end)
		else
			scrollViewPositionChangedSignalConnection = nil
		end

		return function()
			if scrollViewPositionChangedSignalConnection ~= nil then
				scrollViewPositionChangedSignalConnection:disconnect()
			end
		end
	end, { props.scrollViewPositionChangedSignal })

	React.useEffect(function()
		if props.pageContext and props.routeName == props.pageContext then
			ref2.current:fire()

			if props.dataUpdatedTimestamp ~= state2 then
				setState2(props.dataUpdatedTimestamp)
				ref.current = {}
				ref3.current:onClearAllImpressions()
			end
		end
	end, { props.routeName, props.pageContext, props.dataUpdatedTimestamp, state2, viewPortBounds })

	local useEffect2 = React.useEffect
	local function fn2()
		if state ~= nil and #state > 0 then
			props.sendImpressions(state)
			ref3.current:onSendImpressions(state)
			setState({})
		end
	end

	local v2

	if defineFastFlag then
		v2 = props.sendImpressions
	end

	useEffect2(fn2, { state, v2 })

	React.useEffect(function()
		return function()
			ref3.current:destroy()
		end
	end, {})

	local filterImpressionFunc = React.useCallback(function(p): boolean
		if ref.current[p] ~= nil then
			return false
		end

		ref.current[p] = true
		return true
	end, {})

	local onImpressionsDetected = React.useCallback(function(list)
		if not list or #list == 0 then
			return
		end

		setState(list)
	end, {})
	local v3

	if props.pageContext then
		v3 = ImpressionsDetector
	else
		v3 = ImpressionDetectorWithoutNavigation
	end

	local createElement = React.createElement
	local v4 = {
		parentRef = props.parentRef,
		visibilityObserver = 0,
		viewPortBounds = 0,
		viewPortFillBounds = 0,
		onRequestImpressionsSignal = 0,
		filterImpressionFunc = 0,
		onImpressionsDetected = 0,
		impressionsTag = 0
	}
	local visibilityObserver

	if FFlagLuaAppSduiGameDwell then
		visibilityObserver = props.visibilityObserver
	end

	v4.visibilityObserver = visibilityObserver
	v4.viewPortBounds = viewPortBounds
	local viewPortFillBounds

	if FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then
		viewPortFillBounds = props.viewPortFillBounds
	end

	v4.viewPortFillBounds = viewPortFillBounds

	v4.onRequestImpressionsSignal = ref2.current
	v4.filterImpressionFunc = filterImpressionFunc
	v4.onImpressionsDetected = onImpressionsDetected
	v4.impressionsTag = props.impressionsTag
	return createElement(v3, v4)
end
