local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/React")
local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/AppCommonLib").Signal
local ImpressionsDetector = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/ImpressionsDetector")
local ImpressionDetectorWithoutNavigation = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/ImpressionDetectorWithoutNavigation")
local ImpressionsVisualizer = require("@game/CorePackages/Workspace/Packages/_Index/Impressions/Impressions/ImpressionsVisualizer")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Impressions/SharedFlags")

local defineFastFlag = game:DefineFastFlag("LuaAppFixImpressionsHookDependencies", false)

local fFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions = SharedFlags.FFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions

return function(props)
	local ref = React.useRef({})
	local ref2 = React.useRef(signal.new())

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
	local v6 = if defineFastFlag then props.dataUpdatedTimestamp else nil
	useEffect(fn, { impressionsTag, v6 })

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
	end, {
		props.routeName,
		props.pageContext,
		props.dataUpdatedTimestamp,
		state2,
		viewPortBounds
	})

	local useEffect2 = React.useEffect
	local function fn2()
		if state ~= nil and #state > 0 then
			props.sendImpressions(state)
			ref3.current:onSendImpressions(state)
			setState({})
		end
	end

	local v8 = if defineFastFlag then props.sendImpressions else nil
	useEffect2(fn2, { state, v8 })

	React.useEffect(function()
		return function()
			ref3.current:destroy()
		end
	end, {})

	local v9 = React.useCallback(function(p2): boolean
		if ref.current[p2] ~= nil then
			return false
		end

		ref.current[p2] = true
		return true
	end, {})

	local v10 = React.useCallback(function(list)
		if not list or #list == 0 then
			return
		end

		setState(list)
	end, {})

	local v11 = if props.pageContext then ImpressionsDetector else ImpressionDetectorWithoutNavigation

	local createElement = React.createElement
	local v12 = {
		parentRef = props.parentRef,
		viewPortBounds = viewPortBounds,
		viewPortFillBounds = 0,
		onRequestImpressionsSignal = 0,
		filterImpressionFunc = 0,
		onImpressionsDetected = 0,
		impressionsTag = 0
	}

	local v13 = if fFlagLuaAppUseScreenFillBoundsForFrameBoundsImpressions then props.viewPortFillBounds else nil
	v12.viewPortFillBounds = v13

	v12.onRequestImpressionsSignal = ref2.current
	v12.filterImpressionFunc = v9
	v12.onImpressionsDetected = v10
	v12.impressionsTag = props.impressionsTag
	return createElement(v11, v12)
end
