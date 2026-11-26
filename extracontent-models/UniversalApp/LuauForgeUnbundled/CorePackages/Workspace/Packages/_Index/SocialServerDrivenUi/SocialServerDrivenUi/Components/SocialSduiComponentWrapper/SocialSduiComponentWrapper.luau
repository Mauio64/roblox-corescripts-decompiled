local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/React")
require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/AppCommonLib")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/Foundation")
local getSduiComponentWrapper = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialServerDrivenUi/SduiCoreSystem").getSduiComponentWrapper

local view = Foundation.View

local function SocialSduiComponentWrapper(props)
	local sduiComponentWrapper = getSduiComponentWrapper(props.sduiComponentConfig)

	return React.createElement(
		view,
		{
			tag = "size-full-0 auto-y",
			LayoutOrder = props.layoutOrder,
			onAbsoluteSizeChanged = props.onFrameResized
		},
		{
			SocialSduiComponentWrapper = React.createElement(sduiComponentWrapper, {
				debugName = props.debugName,
				componentConfig = props.sduiComponentConfig,
				sduiContext = props.sduiContext,
				extraLocalProps = {
					index = props.layoutOrder,
					pageSideMargin = props.pageSideMargin,
					verticalScrollingFrameRef = props.verticalScrollingFrameRef,
					scrollViewPositionChangedSignal = props.scrollViewPositionChangedSignal,
					testId = props.testId
				},
				localAnalyticsData = props.analyticsContext
			})
		}
	)
end

return React.memo(SocialSduiComponentWrapper)
