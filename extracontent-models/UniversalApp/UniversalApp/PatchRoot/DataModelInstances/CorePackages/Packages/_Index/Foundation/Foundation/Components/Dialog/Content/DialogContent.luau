local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local ScrollView = require(Foundation.Components.ScrollView)
require(Foundation.Components.Types)
local Visibility = require(Foundation.Enums.Visibility)
local withCommonProps = require(Foundation.Utility.withCommonProps)

local useScrollBarPadding = require(script.Parent.useScrollBarPadding)
local useDialogVariants = require(script.Parent.Parent.useDialogVariants)
local useDialogVariants2 = useDialogVariants.useDialogVariants
local useDialog = require(script.Parent.Parent.useDialog)

local function DialogContent(state)
	local v, v2, v3 = useScrollBarPadding()
	local v4 = useDialogVariants2()
	state.testId = `{useDialog().testId}--content`

	local selectable = (state.Selectable == nil or state.Selectable) and v

	local createElement = React.createElement

	local scroll = {
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		scrollBarVisibility = 0
	}
	local scrollBarVisibility

	if v then
		scrollBarVisibility = Visibility.Auto
	else
		scrollBarVisibility = Visibility.None
	end

	scroll.scrollBarVisibility = scrollBarVisibility
	return createElement(ScrollView, withCommonProps(state, {
		scroll = scroll,
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		selection = {
			Selectable = selectable,
			NextSelectionUp = state.NextSelectionUp,
			NextSelectionDown = state.NextSelectionDown,
			NextSelectionLeft = state.NextSelectionLeft,
			NextSelectionRight = state.NextSelectionRight
		},
		onAbsoluteCanvasSizeChanged = v3,
		onAbsoluteWindowSizeChanged = v3,
		tag = v4.content.tag
	}), {
		ScrollPadding = React.createElement("UIPadding", {
			PaddingRight = v2:map(function(p: number)
				return UDim.new(0, p)
			end)
		}),
		ScrollContent = React.createElement(React.Fragment, nil, state.children)
	})
end

return DialogContent
