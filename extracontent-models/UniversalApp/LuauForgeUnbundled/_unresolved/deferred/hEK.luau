local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local signal = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Signal
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local topicContentsReducer = require("@luauforge/bundled/dzJ").TopicContentsReducer
local screenSizeImpressionsDetector = require("@luauforge/bundled/edd").ScreenSizeImpressionsDetector
local impressionsVisualizer = require("@luauforge/bundled/edd").ImpressionsVisualizer

return function(props)
	local ref = React.useRef({})

	local ref2 = React.useRef(signal.new())
	local v5 = React.useCallback(function(p2)
		return props.gameSortId .. "_" .. p2
	end, { props.gameSortId })

	local ref3 = React.useRef(nil)

	if ref3.current == nil then
		ref3.current = impressionsVisualizer.new(props.impressionsTag, v5)
	end

	assert(ref3.current)

	local v6 = useSelector(function(p2)
		local v7 = p2.Personalization[topicContentsReducer.key][props.gameSortId]
		return v7 and v7.updatedTimestamp or nil
	end)

	React.useEffect(function()
		ref3.current:setCustomKeyMapper(v5)
		ref2.current:fire()
	end, { v5 })

	React.useEffect(function()
		local v7 = ref.current[props.gameSortId] or {}

		if v7.lastUpdatedTimestamp ~= nil and v6 ~= v7.lastUpdatedTimestamp then
			local impressionsSeen = v7.impressionsSeen

			if impressionsSeen then
				local v8 = {}

				for k, v9 in pairs(impressionsSeen) do
					if v9 then
						table.insert(v8, k)
					end
				end

				if #v8 > 0 then
					ref3.current:onClearImpressions(v8)
				end
			end

			v7.impressionsSeen = {}
		end

		v7.lastUpdatedTimestamp = v6
		ref.current[props.gameSortId] = v7
		ref2.current:fire()
	end, { props.gameSortId, v6 })

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
		return function()
			ref3.current:destroy()
		end
	end, {})

	local v7 = React.useCallback(function(p2): boolean
		if ref.current[props.gameSortId] == nil then
			ref.current[props.gameSortId] = {
				impressionsSeen = {},
				lastUpdatedTimestamp = v6
			}
		end

		local v8 = ref.current[props.gameSortId]
		v8.impressionsSeen = v8.impressionsSeen or {}

		if v8.impressionsSeen[p2] ~= nil then
			return false
		end

		v8.impressionsSeen[p2] = true
		return true
	end, { props.gameSortId })

	local v8 = React.useCallback(function(list)
		if not list or #list == 0 then
			return
		end

		props.sendGameImpressions(list)
		ref3.current:onSendImpressions(list)
	end, { props.sendGameImpressions })

	return React.createElement(screenSizeImpressionsDetector, {
		onRequestImpressionsSignal = ref2.current,
		parentRef = props.parentRef,
		filterImpressionFunc = v7,
		onImpressionsDetected = v8,
		impressionsTag = props.impressionsTag
	})
end
