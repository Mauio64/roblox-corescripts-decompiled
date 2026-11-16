local parent = script:FindFirstAncestor("GameCollections").Parent
local React = require(parent.React)
local AppCommonLib = require(parent.AppCommonLib)
local Signal = AppCommonLib.Signal
local Navigation = require(parent.Navigation)
local useRouteName = Navigation.useRouteName
local RoactUtils = require(parent.RoactUtils)
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local Cryo = require(parent.Cryo)
local Impressions = require(parent.Impressions)
local ScreenSizeImpressionsDetector = Impressions.ScreenSizeImpressionsDetector
local ImpressionsVisualizer = Impressions.ImpressionsVisualizer

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

	local v = useRouteName()
	local v2 = useSelector(function(p)
		return p.ScreenSize
	end)

	local ref4 = React.useRef(props.impressionsTag)

	React.useEffect(function()
		if ref4.current ~= props.impressionsTag then
			ref4.current = props.impressionsTag
			setState2(props.dataUpdatedTimestamp)
			ref.current = {}
			ref3.current:onClearAllImpressions()
			ref3.current:setImpressionsTag(props.impressionsTag)
		end
	end, { props.impressionsTag })

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
		local v3

		if type(props.pageContext) == "table" then
			v3 = Cryo.List.find(props.pageContext, v) ~= nil
		else
			v3 = v == props.pageContext
		end

		if v3 then
			ref2.current:fire()

			if props.dataUpdatedTimestamp ~= state2 then
				setState2(props.dataUpdatedTimestamp)
				ref.current = {}
				ref3.current:onClearAllImpressions()
			end
		end
	end, { v, props.pageContext, props.dataUpdatedTimestamp, state2, v2 })

	React.useEffect(function()
		if state ~= nil and #state > 0 then
			props.sendGameImpressions(state)
			ref3.current:onSendImpressions(state)
			setState({})
		end
	end, { state })

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

	return React.createElement(ScreenSizeImpressionsDetector, {
		onRequestImpressionsSignal = ref2.current,
		parentRef = props.parentRef,
		filterImpressionFunc = filterImpressionFunc,
		onImpressionsDetected = onImpressionsDetected,
		impressionsTag = props.impressionsTag
	})
end
