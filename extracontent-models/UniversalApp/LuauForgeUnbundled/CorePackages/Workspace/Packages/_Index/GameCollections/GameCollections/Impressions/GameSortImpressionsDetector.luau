local React = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/React")
local signal = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/AppCommonLib").Signal
local useRouteName = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Navigation").useRouteName
local useSelector = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/RoactUtils").Hooks.RoactRodux.useSelector
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Cryo")
local Impressions = require("@game/CorePackages/Workspace/Packages/_Workspace/GameCollections/Impressions")
local screenSizeImpressionsDetector = Impressions.ScreenSizeImpressionsDetector
local impressionsVisualizer = Impressions.ImpressionsVisualizer

return function(props)
	local ref = React.useRef({})
	local ref2 = React.useRef(signal.new())

	local ref3 = React.useRef(nil)

	if ref3.current == nil then
		ref3.current = impressionsVisualizer.new(props.impressionsTag)
	end

	assert(ref3.current, "impressionsVisualizer should always be truthy; check needed for lint")
	local state, setState = React.useState({})
	local state2, setState2 = React.useState(props.dataUpdatedTimestamp)

	local v5 = useRouteName()
	local v6 = useSelector(function(p2)
		return p2.ScreenSize
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
		local v7

		if type(props.pageContext) == "table" then
			v7 = Cryo.List.find(props.pageContext, v5) ~= nil
		else
			v7 = v5 == props.pageContext
		end

		if v7 then
			ref2.current:fire()

			if props.dataUpdatedTimestamp ~= state2 then
				setState2(props.dataUpdatedTimestamp)
				ref.current = {}
				ref3.current:onClearAllImpressions()
			end
		end
	end, { v5, props.pageContext, props.dataUpdatedTimestamp, state2, v6 })

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

	local v7 = React.useCallback(function(p2): boolean
		if ref.current[p2] ~= nil then
			return false
		end

		ref.current[p2] = true
		return true
	end, {})

	local v8 = React.useCallback(function(list)
		if not list or #list == 0 then
			return
		end

		setState(list)
	end, {})

	return React.createElement(screenSizeImpressionsDetector, {
		onRequestImpressionsSignal = ref2.current,
		parentRef = props.parentRef,
		filterImpressionFunc = v7,
		onImpressionsDetected = v8,
		impressionsTag = props.impressionsTag
	})
end
