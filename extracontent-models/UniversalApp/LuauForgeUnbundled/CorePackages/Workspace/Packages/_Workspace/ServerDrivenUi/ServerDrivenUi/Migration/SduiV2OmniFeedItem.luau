local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/React")
local ArgCheck = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ArgCheck")
local omniFeedPropsKey = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/DiscoveryTypes").OmniFeedPropsKey
local sduiFeatureEntryPoint = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SduiSharedUtilities").SduiFeatureEntryPoint

local fIntLuaAppDelayImpressionsMaxUpdates = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/SharedFlags").FIntLuaAppDelayImpressionsMaxUpdates

local SduiV2OmniFeedConstants = require("@game/CorePackages/Workspace/Packages/_Workspace/ServerDrivenUi/ServerDrivenUi/Migration/SduiV2OmniFeedConstants")

local function SduiV2OmniFeedItem(p2)
	local v5 = p2[omniFeedPropsKey]
	local appPage = v5.appPage
	ArgCheck.assert(appPage ~= nil, "appPage must exist")
	ArgCheck.assert(p2.sortIndex ~= nil, "sortIndex must exist")
	ArgCheck.assert(
		p2.feedItemKey ~= nil and p2.feedItemKey ~= "",
		"feedItemKey must exist for V2 SDUI omni feed item"
	)

	local v7 = React.useMemo(function()
		return { collectionPosition = p2.sortIndex }
	end, { p2.sortIndex })

	local v8 = React.useMemo(function()
		return {
			scrollViewPositionChangedSignal = v5.scrollViewPositionChangedSignal,
			verticalScrollingFrameRef = v5.verticalScrollingFrameRef,
			startRow = v5.feedItemStartRow,
			numUpdatesToDelayImpressions = fIntLuaAppDelayImpressionsMaxUpdates,
			selectionOrderBase = v5.selectionOrderBase,
			videoPlaybackContext = v5.videoPlaybackContext,
			index = p2.sortIndex,
			collectionPosition = p2.sortIndex
		}
	end, {
		v5.scrollViewPositionChangedSignal,
		v5.verticalScrollingFrameRef,
		v5.feedItemStartRow,
		v5.selectionOrderBase,
		v5.videoPlaybackContext,
		p2.sortIndex
	})

	return React.createElement(sduiFeatureEntryPoint, {
		appPage = appPage,
		configKey = SduiV2OmniFeedConstants.HomeConfigKey,
		identifier = p2.feedItemKey,
		additionalAnalyticsData = v7,
		extraLocalProps = v8,
		appCompositionEnabledOverride = v5.appCompositionEnabled == true,
		LayoutOrder = p2.sortIndex,
		shouldDisplayError = false,
		shouldDisplayLoading = false
	})
end

return React.memo(SduiV2OmniFeedItem)
