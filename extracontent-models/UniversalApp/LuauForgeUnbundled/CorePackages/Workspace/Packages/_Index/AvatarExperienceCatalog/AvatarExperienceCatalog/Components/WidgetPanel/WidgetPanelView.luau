local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/React")
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/Foundation").View

require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AppCommonLib")

local avatarExperienceScreenSizeImpressionsDetector = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceCatalog/AvatarExperienceAnalytics").AvatarExperienceScreenSizeImpressionsDetector

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
		Panel = React.createElement(view, { tag = "col size-full-0 auto-y" }, props.children),
		WidgetImpressionsDetector = React.createElement(avatarExperienceScreenSizeImpressionsDetector, {
			parentRef = props.panelRef,
			onRequestImpressionsSignal = props.onRequestImpressionsSignal,
			pageFilter = props.pageFilter,
			onImpressionsDetected = props.onImpressionsDetected,
			collectObjectsFunc = props.collectObjectsFunc
		})
	})
end

return WidgetPanelView
