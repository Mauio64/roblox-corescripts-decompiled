local React = require("@game/CorePackages/Workspace/Packages/_Workspace/EdpStoreAnalytics/React")
local AppCommonLib = require("@game/CorePackages/Workspace/Packages/_Workspace/EdpStoreAnalytics/AppCommonLib")
local Constants = require("@game/CorePackages/Workspace/Packages/_Index/EdpStoreAnalytics/EdpStoreAnalytics/Constants")
local EdpStoreAnalyticsLogger = require("@game/CorePackages/Workspace/Packages/_Index/EdpStoreAnalytics/EdpStoreAnalytics/EdpStoreAnalyticsLogger")
local signal = AppCommonLib.Signal
local screenSizeImpressionsDetector = require("@game/CorePackages/Workspace/Packages/_Workspace/EdpStoreAnalytics/Impressions").ScreenSizeImpressionsDetector

return function(props)
	local ref = React.useRef(signal.new())
	local ref2 = React.useRef(false)

	React.useEffect(function()
		if props.scrollViewPositionChangedSignal.current then
			props.scrollViewPositionChangedSignal.current:connect(function()
				ref.current:fire()
			end)
		end
	end, { props.scrollViewPositionChangedSignal })

	local v5 = React.useCallback(function(list)
		if #list == 0 or ref2.current or props.parameters == nil then
			return
		end

		ref2.current = true

		local item = list[1]
		local v6 = {
			universeId = tonumber(props.parameters.universeId),
			productType = props.parameters.productType,
			actionType = Constants.StoreEnums.ActionType.Impression,
			locationType = props.parameters.locationType,
			layoutOrder = tonumber(item)
		}

		EdpStoreAnalyticsLogger.logImpression(v6)
		EdpStoreAnalyticsLogger.logExperienceStoreExposure()
	end, { props.parameters })

	return React.createElement(screenSizeImpressionsDetector, {
		parentRef = props.parentRef,
		onRequestImpressionsSignal = ref.current,
		onImpressionsDetected = v5,
		impressionsTag = props.impressionsTag
	})
end
