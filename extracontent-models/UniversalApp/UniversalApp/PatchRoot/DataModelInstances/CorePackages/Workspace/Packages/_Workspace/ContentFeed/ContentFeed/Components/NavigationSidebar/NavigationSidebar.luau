local ParentParent = script.Parent.Parent.Parent.Parent
local React = require(ParentParent.React)
local Foundation = require(ParentParent.Foundation)
local Icon = Foundation.Icon
local IconSize = Foundation.Enums.IconSize
local View = Foundation.View
local useTokens = Foundation.Hooks.useTokens

return function(t1: {[any]: any}) -- line: 21
	-- upvalues: useTokens (copy), React (copy), View (copy), Icon (copy), IconSize (copy)
	local v9 = useTokens()

	return React.createElement(View, {
		tag = "align-x-center align-y-center anchor-center-left auto-xy bg-action-subtle col gap-medium items-center",
		Position = t1.position
	}, {
		PreviousButton = React.createElement(View, {
			LayoutOrder = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			isDisabled = t1.isTerminalInitialPost,
			onActivated = t1.onNavigateUp,
			Position = UDim2.fromScale(0.5, 0.5),
			tag = {
				["auto-xy bg-action-standard padding-medium radius-circle"] = true,
				["bg-action-subtle"] = t1.isTerminalInitialPost
			}
		}, {
			CycleUpIcon = React.createElement(Icon, {
				name = "icons/actions/truncationCollapse",
				ZIndex = 2,
				AnchorPoint = Vector2.new(0.5, 0.5),
				IconSize = IconSize.Small,
				Position = UDim2.fromScale(0.5, 0.5),
				style = if not t1.isTerminalInitialPost then v9.Color.ActionEmphasis.Foreground else v9.Color.None
			})
		}),
		NextButton = React.createElement(View, {
			LayoutOrder = 2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			isDisabled = t1.isTerminalFinalPost,
			onActivated = t1.onNavigateDown,
			Position = UDim2.fromScale(0.5, 0.5),
			tag = {
				["auto-xy bg-action-standard padding-medium radius-circle"] = true,
				["bg-action-subtle"] = t1.isTerminalFinalPost
			}
		}, {
			CycleDownIcon = React.createElement(Icon, {
				name = "icons/actions/truncationExpand",
				ZIndex = 2,
				AnchorPoint = Vector2.new(0.5, 0.5),
				IconSize = IconSize.Small,
				Position = UDim2.fromScale(0.5, 0.5),
				style = if not t1.isTerminalFinalPost then v9.Color.ActionEmphasis.Foreground else v9.Color.None
			})
		})
	})
end
