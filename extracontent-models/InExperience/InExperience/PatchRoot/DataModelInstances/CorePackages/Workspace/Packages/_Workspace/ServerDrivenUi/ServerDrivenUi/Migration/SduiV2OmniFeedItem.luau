local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local parent = ServerDrivenUi.Parent
local React = require(parent.React)
local ArgCheck = require(parent.ArgCheck)
local DiscoveryTypes = require(parent.DiscoveryTypes)
local OmniFeedPropsKey = DiscoveryTypes.OmniFeedPropsKey
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiFeatureEntryPoint = SduiSharedUtilities.SduiFeatureEntryPoint

local SharedFlags = require(parent.SharedFlags)
local FIntLuaAppDelayImpressionsMaxUpdates = SharedFlags.FIntLuaAppDelayImpressionsMaxUpdates

local SduiV2OmniFeedConstants = require(ServerDrivenUi.Migration.SduiV2OmniFeedConstants)

local function SduiV2OmniFeedItem(p)
	local v = p[OmniFeedPropsKey]
	local appPage = v.appPage
	ArgCheck.assert(appPage ~= nil, "appPage must exist")
	ArgCheck.assert(p.sortIndex ~= nil, "sortIndex must exist")
	ArgCheck.assert(p.feedItemKey ~= nil and p.feedItemKey ~= "", "feedItemKey must exist for V2 SDUI omni feed item")

	local additionalAnalyticsData = React.useMemo(function()
		return { collectionPosition = p.sortIndex }
	end, { p.sortIndex })

	local extraLocalProps = React.useMemo(function()
		return {
			scrollViewPositionChangedSignal = v.scrollViewPositionChangedSignal,
			verticalScrollingFrameRef = v.verticalScrollingFrameRef,
			startRow = v.feedItemStartRow,
			numUpdatesToDelayImpressions = FIntLuaAppDelayImpressionsMaxUpdates,
			selectionOrderBase = v.selectionOrderBase,
			videoPlaybackContext = v.videoPlaybackContext,
			index = p.sortIndex,
			collectionPosition = p.sortIndex
		}
	end, {
		v.scrollViewPositionChangedSignal,
		v.verticalScrollingFrameRef,
		v.feedItemStartRow,
		v.selectionOrderBase,
		v.videoPlaybackContext,
		p.sortIndex
	})

	return React.createElement(SduiFeatureEntryPoint, {
		appPage = appPage,
		configKey = SduiV2OmniFeedConstants.HomeConfigKey,
		identifier = p.feedItemKey,
		additionalAnalyticsData = additionalAnalyticsData,
		extraLocalProps = extraLocalProps,
		appCompositionEnabledOverride = v.appCompositionEnabled == true,
		LayoutOrder = p.sortIndex,
		shouldDisplayError = false,
		shouldDisplayLoading = false
	})
end

return React.memo(SduiV2OmniFeedItem)
