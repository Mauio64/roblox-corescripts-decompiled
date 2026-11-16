local parent = script:FindFirstAncestor("AvatarWorkshop").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)
local DividerOrientation = Foundation.Enums.DividerOrientation

local function HorizontalLayout(props)
	return (React.createElement(Foundation.View, { tag = "size-full-full" }, {
		LeftPanel = React.createElement(Foundation.View, {
			tag = "col",
			Size = UDim2.fromScale(0.67, 1)
		}, {
			Header = React.createElement(
				Foundation.View,
				{ tag = "size-full-0 auto-y padding-bottom-small", LayoutOrder = 1 },
				{ HeaderSlot = props.headerSlot }
			),
			LeftItemContainer = React.createElement(Foundation.View, {
				tag = "fill size-full-0",
				LayoutOrder = 2
			}, {
				LeftItem = props.leftItemSlot
			})
		}),
		RightPanel = React.createElement(
			Foundation.View,
			{
				tag = "position-top-right anchor-top-right",
				Size = UDim2.fromScale(0.32999999999999996, 1)
			},
			{ RightItem = props.rightItemSlot }
		),
		Divider = React.createElement(Foundation.Divider, {
			Position = UDim2.fromScale(0.67, 0),
			ZIndex = 2,
			orientation = DividerOrientation.Vertical
		})
	}))
end

return HorizontalLayout
