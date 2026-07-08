local Parent = script:FindFirstAncestor("SocialServerDrivenUi").Parent
local React = require(Parent.React)

require(Parent.AppCommonLib)

local Foundation = require(Parent.Foundation)
local getSduiComponentWrapper = require(Parent.SduiCoreSystem).getSduiComponentWrapper
local View = Foundation.View

local function SocialSduiComponentWrapper(t1: {[any]: any}) -- line: 29
	-- upvalues: getSduiComponentWrapper (copy), React (copy), View (copy)
	local v8 = getSduiComponentWrapper(t1.sduiComponentConfig)

	return React.createElement(View, {
		tag = "size-full-0 auto-y",
		LayoutOrder = t1.layoutOrder,
		onAbsoluteSizeChanged = t1.onFrameResized
	}, {
		SocialSduiComponentWrapper = React.createElement(v8, {
			debugName = t1.debugName,
			componentConfig = t1.sduiComponentConfig,
			sduiContext = t1.sduiContext,
			extraLocalProps = {
				index = t1.layoutOrder,
				pageSideMargin = t1.pageSideMargin,
				verticalScrollingFrameRef = t1.verticalScrollingFrameRef,
				scrollViewPositionChangedSignal = t1.scrollViewPositionChangedSignal,
				testId = t1.testId
			},
			localAnalyticsData = t1.analyticsContext
		})
	})
end

return React.memo(SocialSduiComponentWrapper)
