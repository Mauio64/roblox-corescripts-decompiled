local HelpPage = script:FindFirstAncestor("HelpPage")
local parent = HelpPage.Parent
local React = require(parent.React)
require(HelpPage.Components.Common.ActionText)
local DiagramLayoutView = require(HelpPage.Components.Common.DiagramLayoutView)
local TouchControlList = require(HelpPage.Components.Touch.TouchControlList)
local TouchDeviceMock = require(HelpPage.Components.Touch.TouchDeviceMock)
local TouchHelpPage = require(HelpPage.Components.Touch.TouchHelpPage)

local function CCLTouchHelpPageView(props)
	if not props.abilitiesAvailable then
		return React.createElement(TouchHelpPage)
	end

	local textVariant = props.layout.columnWidth == 0.5 and "title-large" or "label-small"

	return React.createElement(DiagramLayoutView, {
		layout = props.layout,
		testId = "Touch",
		diagramTestId = "TouchDiagram",
		onSizeChanged = props.onSizeChanged,
		onLeftSizeChanged = props.onLeftSizeChanged,
		onRightSizeChanged = props.onRightSizeChanged,
		left = React.createElement(TouchControlList, {
			controls = props.leftControls,
			layoutOrderReversed = false,
			showIconBackground = false,
			textVariant = textVariant
		}),
		right = React.createElement(TouchControlList, {
			controls = props.rightControls,
			layoutOrderReversed = true,
			textVariant = textVariant
		}),
		renderDiagram = function(vector2: Vector2)
			return React.createElement(TouchDeviceMock, {
				centerControl = props.centerControl,
				slots = props.slots,
				layout = props.mockLayout,
				scale = vector2.X / props.mockLayout.size.X
			})
		end
	})
end

return CCLTouchHelpPageView
