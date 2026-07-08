local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local ScrollView = require(Foundation.Components.ScrollView)

require(Foundation.Components.Types)

local Visibility = require(Foundation.Enums.Visibility)
local withCommonProps = require(Foundation.Utility.withCommonProps)
local useScrollBarPadding = require(script.Parent.useScrollBarPadding)
local useDialogVariants = require(script.Parent.Parent.useDialogVariants).useDialogVariants
local useDialog = require(script.Parent.Parent.useDialog)

local function DialogContent(p1) -- line: 19
	-- upvalues: useScrollBarPadding (copy), useDialogVariants (copy), useDialog (copy), React (copy), ScrollView (copy), withCommonProps (copy), Visibility (copy)
	local v12, v13, v14 = useScrollBarPadding()
	local v15 = useDialogVariants()

	p1.testId = `{ useDialog().testId }--content`

	local v16 = (p1.Selectable == nil or p1.Selectable) and v12

	return React.createElement(ScrollView, withCommonProps(p1, {
		scroll = {
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			scrollBarVisibility = if not v12 then Visibility.None else Visibility.Auto
		},
		layout = {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalFlex = Enum.UIFlexAlignment.Fill,
			SortOrder = Enum.SortOrder.LayoutOrder
		},
		selection = {
			Selectable = v16,
			NextSelectionUp = p1.NextSelectionUp,
			NextSelectionDown = p1.NextSelectionDown,
			NextSelectionLeft = p1.NextSelectionLeft,
			NextSelectionRight = p1.NextSelectionRight
		},
		onAbsoluteCanvasSizeChanged = v14,
		onAbsoluteWindowSizeChanged = v14,
		tag = v15.content.tag
	}), {
		ScrollPadding = React.createElement("UIPadding", {
			PaddingRight = v13:map(function(n1: number) -- line: 55
				return UDim.new(0, n1)
			end)
		}),
		ScrollContent = React.createElement(React.Fragment, nil, p1.children)
	})
end

return DialogContent
