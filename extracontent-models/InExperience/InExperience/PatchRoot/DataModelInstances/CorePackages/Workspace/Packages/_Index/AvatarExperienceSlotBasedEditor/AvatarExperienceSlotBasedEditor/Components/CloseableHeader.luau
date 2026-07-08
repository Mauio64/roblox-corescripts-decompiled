local Parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

return (React.forwardRef(function(t1: {[any]: any}, p1) -- line: 29
	-- upvalues: useTokens (copy), React (copy), Foundation (copy)
	local v7 = useTokens()

	return React.createElement(Foundation.View, {
		tag = "size-full row flex-between",
		Size = t1.Size,
		ZIndex = t1.ZIndex,
		LayoutOrder = t1.LayoutOrder,
		NextSelectionUp = t1.NextSelectionUp,
		NextSelectionDown = t1.NextSelectionDown,
		backgroundStyle = v7.Color.Surface.Surface_0,
		ref = p1,
		padding = if not t1.padding then nil else {
			left = UDim.new(0, t1.padding.left or 0),
			right = UDim.new(0, t1.padding.right or 0),
			top = UDim.new(0, t1.padding.top or 0),
			bottom = UDim.new(0, t1.padding.bottom or 0)
		}
	}, {
		Title = React.createElement(Foundation.Text, {
			tag = "auto-xy text-align-x-left text-heading-small",
			LayoutOrder = 1,
			Text = t1.text or ""
		}),
		CloseButton = React.createElement(Foundation.View, {
			tag = "auto-xy",
			LayoutOrder = 2,
			stateLayer = {
				affordance = Foundation.Enums.StateLayerAffordance.None
			},
			onActivated = t1.onClose
		}, {
			ButtonImage = React.createElement(Foundation.Image, {
				Image = "icons/navigation/close",
				tag = "size-600-600",
				imageStyle = v7.Color.Content.Emphasis
			})
		})
	})
end))
