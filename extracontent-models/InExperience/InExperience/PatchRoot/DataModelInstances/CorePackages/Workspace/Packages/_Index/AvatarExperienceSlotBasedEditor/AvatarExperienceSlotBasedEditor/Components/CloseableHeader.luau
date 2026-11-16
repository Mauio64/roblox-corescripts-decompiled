local parent = script:FindFirstAncestor("AvatarExperienceSlotBasedEditor").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local useTokens = Foundation.Hooks.useTokens

return (React.forwardRef(function(props, ref)
	local v = useTokens()

	return React.createElement(Foundation.View, {
		tag = "size-full row flex-between",
		Size = props.Size,
		ZIndex = props.ZIndex,
		LayoutOrder = props.LayoutOrder,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown,
		backgroundStyle = v.Color.Surface.Surface_0,
		ref = ref,
		padding = props.padding and {
			left = UDim.new(0, props.padding.left or 0),
			right = UDim.new(0, props.padding.right or 0),
			top = UDim.new(0, props.padding.top or 0),
			bottom = UDim.new(0, props.padding.bottom or 0)
		} or nil
	}, {
		Title = React.createElement(Foundation.Text, {
			Text = props.text or "",
			tag = "auto-xy text-align-x-left text-heading-small",
			LayoutOrder = 1
		}),
		CloseButton = React.createElement(Foundation.View, {
			tag = "auto-xy",
			stateLayer = { affordance = Foundation.Enums.StateLayerAffordance.None },
			onActivated = props.onClose,
			LayoutOrder = 2
		}, {
			ButtonImage = React.createElement(Foundation.Image, {
				Image = "icons/navigation/close",
				imageStyle = v.Color.Content.Emphasis,
				tag = "size-600-600"
			})
		})
	})
end))
