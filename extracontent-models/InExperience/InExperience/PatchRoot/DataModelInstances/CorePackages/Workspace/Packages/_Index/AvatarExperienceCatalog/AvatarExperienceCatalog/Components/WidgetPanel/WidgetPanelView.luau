local parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local View = Foundation.View

require(parent.AppCommonLib)

local AvatarExperienceAnalytics = require(parent.AvatarExperienceAnalytics)

local AvatarExperienceScreenSizeImpressionsDetector = AvatarExperienceAnalytics.AvatarExperienceScreenSizeImpressionsDetector

local function WidgetPanelView(props)
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = props.LayoutOrder,
		ref = props.panelRef,
		[React.Change.AbsoluteSize] = props.onAbsoluteSizeChanged
	}, {
		Panel = React.createElement(View, { tag = "col size-full-0 auto-y" }, props.children),
		WidgetImpressionsDetector = React.createElement(AvatarExperienceScreenSizeImpressionsDetector, {
			parentRef = props.panelRef,
			onRequestImpressionsSignal = props.onRequestImpressionsSignal,
			pageFilter = props.pageFilter,
			onImpressionsDetected = props.onImpressionsDetected,
			collectObjectsFunc = props.collectObjectsFunc
		})
	})
end

return WidgetPanelView
