local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local useAdaptiveScrolling = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Hooks.useAdaptiveScrolling
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AXRefreshScrollingFrameWithLoadMore = require(Modules.AvatarExperience.Common.Components.AXRefreshScrollingFrameWithLoadMore)
local FFlagAXRecommendedItemsImpressionExposureLogging = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRecommendedItemsImpressionExposureLogging

local function AvatarSwitcherScrollingContent(t1: {[any]: any}) -- line: 26
	-- upvalues: useAdaptiveScrolling (copy), React (copy), AXRefreshScrollingFrameWithLoadMore (copy), AvatarScreen (copy), FFlagAXRecommendedItemsImpressionExposureLogging (copy)
	local v10 = useAdaptiveScrolling()
	local v11 = React.useCallback(function(p1) -- line: 29
		-- upvalues: t1 (copy), v10 (copy)
		if t1.onCanvasPositionChanged then
			t1.onCanvasPositionChanged(p1)
		end

		if v10 and v10.onCanvasYChanged and p1 and p1.CanvasPosition then
			v10.onCanvasYChanged(p1.CanvasPosition.Y)
		end
	end, {
		v10,
		t1.onCanvasPositionChanged
	})

	return React.createElement(AXRefreshScrollingFrameWithLoadMore, {
		createEndOfScrollElement = true,
		preloadDistance = 500,
		preventInitialLoadMore = true,
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0, 0),
		parentAppPage = AvatarScreen.AvatarSwitcher,
		ScrollingEnabled = not v10 or v10.scrollingEnabledBinding,
		onCanvasPositionChanged = v11,
		onThresholdReached = t1.onThresholdReached,
		onAbsoluteWindowSizeChanged = t1.onAbsoluteWindowSizeChanged,
		ref = if not FFlagAXRecommendedItemsImpressionExposureLogging then nil else t1.scrollingFrameRef
	}, t1.children)
end

return AvatarSwitcherScrollingContent
