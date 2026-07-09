local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local React = require(ServerDrivenUiParent.React)
local ArgCheck = require(ServerDrivenUiParent.ArgCheck)
local OmniFeedPropsKey = require(ServerDrivenUiParent.DiscoveryTypes).OmniFeedPropsKey
local SduiFeatureEntryPoint = require(ServerDrivenUiParent.SduiSharedUtilities).SduiFeatureEntryPoint
local FIntLuaAppDelayImpressionsMaxUpdates = require(ServerDrivenUiParent.SharedFlags).FIntLuaAppDelayImpressionsMaxUpdates
local SduiV2OmniFeedConstants = require(ServerDrivenUi.Migration.SduiV2OmniFeedConstants)

local function SduiV2OmniFeedItem(t1: {[any]: any}) -- line: 30
	-- upvalues: OmniFeedPropsKey (copy), ArgCheck (copy), React (copy), FIntLuaAppDelayImpressionsMaxUpdates (copy), SduiFeatureEntryPoint (copy), SduiV2OmniFeedConstants (copy)
	local v11 = t1[OmniFeedPropsKey]
	local appPage = v11.appPage

	ArgCheck.assert(appPage ~= nil, "appPage must exist")
	ArgCheck.assert(t1.sortIndex ~= nil, "sortIndex must exist")
	ArgCheck.assert(t1.feedItemKey ~= nil and t1.feedItemKey ~= "", "feedItemKey must exist for V2 SDUI omni feed item")

	local v13 = React.useMemo(function() -- line: 40
		-- upvalues: t1 (copy)
		return {
			collectionPosition = t1.sortIndex
		}
	end, { t1.sortIndex })
	local v14 = React.useMemo(function() -- line: 47
		-- upvalues: v11 (copy), FIntLuaAppDelayImpressionsMaxUpdates (copy), t1 (copy)
		return {
			scrollViewPositionChangedSignal = v11.scrollViewPositionChangedSignal,
			verticalScrollingFrameRef = v11.verticalScrollingFrameRef,
			startRow = v11.feedItemStartRow,
			numUpdatesToDelayImpressions = FIntLuaAppDelayImpressionsMaxUpdates,
			selectionOrderBase = v11.selectionOrderBase,
			onTileImageLoaded = v11.onTileImageLoaded,
			videoPlaybackContext = v11.videoPlaybackContext,
			index = t1.sortIndex,
			collectionPosition = t1.sortIndex
		}
	end, {
		v11.scrollViewPositionChangedSignal,
		v11.verticalScrollingFrameRef,
		v11.feedItemStartRow,
		v11.selectionOrderBase,
		v11.onTileImageLoaded,
		v11.videoPlaybackContext,
		t1.sortIndex
	})

	return React.createElement(SduiFeatureEntryPoint, {
		shouldDisplayError = false,
		shouldDisplayLoading = false,
		appPage = appPage,
		configKey = SduiV2OmniFeedConstants.HomeConfigKey,
		identifier = t1.feedItemKey,
		additionalAnalyticsData = v13,
		extraLocalProps = v14,
		appCompositionEnabledOverride = v11.appCompositionEnabled == true,
		LayoutOrder = t1.sortIndex
	})
end

return React.memo(SduiV2OmniFeedItem)
