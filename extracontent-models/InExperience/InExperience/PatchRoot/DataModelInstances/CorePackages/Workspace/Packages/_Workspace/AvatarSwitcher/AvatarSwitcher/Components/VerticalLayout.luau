local Parent = script:FindFirstAncestor("AvatarSwitcher").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

local function VerticalLayout(t1: {[any]: any}) -- line: 18
	-- upvalues: React (copy), Foundation (copy)
	return (React.createElement(Foundation.View, {
		tag = "size-full-full col"
	}, {
		Header = React.createElement(Foundation.View, {
			tag = "auto-y size-full-0 shrink-0",
			LayoutOrder = 1
		}, {
			HeaderSlot = t1.headerSlot
		}),
		Divider = React.createElement(Foundation.Divider, {
			LayoutOrder = 2,
			ZIndex = 2
		}),
		Content = React.createElement(Foundation.View, {
			tag = "size-full-0 fill col",
			LayoutOrder = 3
		}, {
			TopItemContainer = React.createElement(Foundation.View, {
				Size = UDim2.fromScale(1, 0.5)
			}, {
				TopItem = t1.topItemSlot
			}),
			Divider = React.createElement(Foundation.Divider, {
				ZIndex = 2,
				Position = UDim2.fromScale(0, 0.5)
			}),
			BottomItemContainer = React.createElement(Foundation.View, {
				tag = "position-bottom-left anchor-bottom-left",
				Size = UDim2.fromScale(1, 0.5)
			}, {
				BottomItem = t1.bottomItemSlot
			})
		})
	}))
end

return VerticalLayout
