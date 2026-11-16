local parent = script:FindFirstAncestor("AvatarSwitcher").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local function VerticalLayout(props)
	return (React.createElement(Foundation.View, { tag = "size-full-full col" }, {
		Header = React.createElement(Foundation.View, {
			tag = "auto-y size-full-0 shrink-0",
			LayoutOrder = 1
		}, {
			HeaderSlot = props.headerSlot
		}),
		Divider = React.createElement(Foundation.Divider, { LayoutOrder = 2, ZIndex = 2 }),
		Content = React.createElement(Foundation.View, {
			tag = "size-full-0 fill col",
			LayoutOrder = 3
		}, {
			TopItemContainer = React.createElement(Foundation.View, {
				Size = UDim2.fromScale(1, 0.5)
			}, {
				TopItem = props.topItemSlot
			}),
			Divider = React.createElement(Foundation.Divider, {
				Position = UDim2.fromScale(0, 0.5),
				ZIndex = 2
			}),
			BottomItemContainer = React.createElement(
				Foundation.View,
				{ tag = "position-bottom-left anchor-bottom-left", Size = UDim2.fromScale(1, 0.5) },
				{ BottomItem = props.bottomItemSlot }
			)
		})
	}))
end

return VerticalLayout
