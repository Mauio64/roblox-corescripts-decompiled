local parent = script:FindFirstAncestor("AvatarWorkshop").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local function VerticalLayout(props)
	return (React.createElement(Foundation.View, { tag = "col size-full-full" }, {
		Header = React.createElement(Foundation.View, {
			tag = "size-full-0 auto-y",
			LayoutOrder = 1
		}, {
			HeaderSlot = props.headerSlot
		}),
		Divider = React.createElement(Foundation.Divider, { LayoutOrder = 2, ZIndex = 2 }),
		Content = React.createElement(Foundation.View, {
			tag = "col fill size-full-0",
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
