local parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent

local React = require(parent.React)
require(parent.AppCommonLib)
local Foundation = require(parent.Foundation)
local SduiCoreSystem = require(parent.SduiCoreSystem)

local getSduiComponentWrapper = SduiCoreSystem.getSduiComponentWrapper

local View = Foundation.View

local function SocialSduiComponentWrapper(props)
	local sduiComponentWrapper = getSduiComponentWrapper(props.sduiComponentConfig)

	return React.createElement(
		View,
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
