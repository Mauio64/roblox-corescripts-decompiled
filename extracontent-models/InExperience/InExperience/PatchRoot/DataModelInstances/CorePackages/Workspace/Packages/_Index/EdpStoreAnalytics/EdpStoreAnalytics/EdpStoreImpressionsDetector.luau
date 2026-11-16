local EdpStoreAnalytics = script:FindFirstAncestor("EdpStoreAnalytics")
local parent = EdpStoreAnalytics.Parent
local React = require(parent.React)
local AppCommonLib = require(parent.AppCommonLib)
local Constants = require(EdpStoreAnalytics.Constants)
local EdpStoreAnalyticsLogger = require(EdpStoreAnalytics.EdpStoreAnalyticsLogger)
local Signal = AppCommonLib.Signal
local Impressions = require(parent.Impressions)
local ScreenSizeImpressionsDetector = Impressions.ScreenSizeImpressionsDetector

return function(props)
	local ref = React.useRef(Signal.new())
	local ref2 = React.useRef(false)

	React.useEffect(function()
		if props.scrollViewPositionChangedSignal.current then
			props.scrollViewPositionChangedSignal.current:connect(function()
				ref.current:fire()
			end)
		end
	end, { props.scrollViewPositionChangedSignal })

	local onImpressionsDetected = React.useCallback(function(list)
		if #list == 0 or ref2.current or props.parameters == nil then
			return
		end

		ref2.current = true

		local item = list[1]
		local v = {
			universeId = tonumber(props.parameters.universeId),
			productType = props.parameters.productType,
			actionType = Constants.StoreEnums.ActionType.Impression,
			locationType = props.parameters.locationType,
			layoutOrder = tonumber(item)
		}

		EdpStoreAnalyticsLogger.logImpression(v)
		EdpStoreAnalyticsLogger.logExperienceStoreExposure()
	end, { props.parameters })

	return React.createElement(ScreenSizeImpressionsDetector, {
		parentRef = props.parentRef,
		onRequestImpressionsSignal = ref.current,
		onImpressionsDetected = onImpressionsDetected,
		impressionsTag = props.impressionsTag
	})
end
