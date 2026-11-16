local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useAdaptiveScrolling = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Hooks.useAdaptiveScrolling

local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module = require("@luauforge/deferred/gnw")
local module2 = require("@luauforge/deferred/gnq")

local fFlagAXScrollTelemetryIntegration2 = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXScrollTelemetryIntegration2
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local fFlagAXRecommendedItemsImpressionExposureLogging = AvatarExperienceFlags.FFlagAXRecommendedItemsImpressionExposureLogging
local fFlagAXAvatarFoldersEnabled = AvatarExperienceFlags.FFlagAXAvatarFoldersEnabled

local function AvatarSwitcherScrollingContent(props)
	local v5 = useAdaptiveScrolling()

	local v6 = React.useCallback(function(p2)
		if props.onCanvasPositionChanged then
			props.onCanvasPositionChanged(p2)
		end

		if v5 and v5.onCanvasYChanged and p2 and p2.CanvasPosition then
			v5.onCanvasYChanged(p2.CanvasPosition.Y)
		end
	end, { v5, props.onCanvasPositionChanged })

	local createElement = React.createElement
	local v8 = {
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0, 0),
		parentAppPage = avatarScreen.AvatarSwitcher,
		scrollPerformanceIntervalName = 0,
		ScrollingEnabled = 0,
		onCanvasPositionChanged = 0,
		onThresholdReached = 0,
		createEndOfScrollElement = true,
		preloadDistance = 500,
		preventInitialLoadMore = true,
		onAbsoluteWindowSizeChanged = 0,
		ref = 0
	}

	local v9 = if fFlagAXScrollTelemetryIntegration2 then props.scrollPerformanceIntervalName or module2.AvatarSwitcher else nil
	v8.scrollPerformanceIntervalName = v9

	v8.ScrollingEnabled = not v5 or v5.scrollingEnabledBinding
	v8.onCanvasPositionChanged = v6
	v8.onThresholdReached = props.onThresholdReached

	v8.onAbsoluteWindowSizeChanged = props.onAbsoluteWindowSizeChanged

	local v10 = if fFlagAXRecommendedItemsImpressionExposureLogging or fFlagAXAvatarFoldersEnabled then props.scrollingFrameRef else nil
	v8.ref = v10
	return createElement(module, v8, props.children)
end

return AvatarSwitcherScrollingContent
