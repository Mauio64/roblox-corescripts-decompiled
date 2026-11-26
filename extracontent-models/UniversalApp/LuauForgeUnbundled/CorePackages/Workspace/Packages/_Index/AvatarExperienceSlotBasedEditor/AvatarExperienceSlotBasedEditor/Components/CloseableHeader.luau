local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/React")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceSlotBasedEditor/Foundation")
local useTokens = Foundation.Hooks.useTokens

return (React.forwardRef(function(props, p2)
	local v5 = useTokens()

	return React.createElement(Foundation.View, {
		tag = "size-full row flex-between",
		Size = props.Size,
		ZIndex = props.ZIndex,
		LayoutOrder = props.LayoutOrder,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown,
		backgroundStyle = v5.Color.Surface.Surface_0,
		ref = p2,
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
				imageStyle = v5.Color.Content.Emphasis,
				tag = "size-600-600"
			})
		})
	})
end))
