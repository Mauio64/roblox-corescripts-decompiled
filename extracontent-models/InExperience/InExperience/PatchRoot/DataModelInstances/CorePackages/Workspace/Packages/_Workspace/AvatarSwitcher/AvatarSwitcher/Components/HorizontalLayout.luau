local Parent = script:FindFirstAncestor("AvatarSwitcher").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local DividerOrientation = Foundation.Enums.DividerOrientation
local FFlagAXAvatarTimeoutFlowIE = require(Parent.AvatarExperienceFlags).FFlagAXAvatarTimeoutFlowIE

local function HorizontalLayout(t1: {[any]: any}) -- line: 24
	-- upvalues: React (copy), Foundation (copy), FFlagAXAvatarTimeoutFlowIE (copy), DividerOrientation (copy)
	return (React.createElement(Foundation.View, {
		tag = "size-full-full"
	}, {
		LeftPanel = React.createElement(Foundation.View, {
			tag = if not FFlagAXAvatarTimeoutFlowIE then nil else "col",
			Size = UDim2.fromScale(0.67, 1)
		}, {
			Header = if not FFlagAXAvatarTimeoutFlowIE then t1.headerSlot else React.createElement(Foundation.View, {
				tag = "auto-y size-full-0 shrink-0 padding-bottom-small",
				LayoutOrder = 1
			}, {
				HeaderSlot = t1.headerSlot
			}),
			LeftItemContainer = React.createElement(Foundation.View, if not FFlagAXAvatarTimeoutFlowIE then {
				tag = "position-bottom-left anchor-bottom-left",
				Size = UDim2.new(1, 0, 1, -(t1.headerHeight or 0))
			} else {
				tag = "size-full-0 fill",
				LayoutOrder = 2
			}, {
				LeftItem = t1.leftItemSlot
			})
		}),
		RightPanel = React.createElement(Foundation.View, {
			tag = "position-top-right anchor-top-right",
			Size = UDim2.fromScale(0.32999999999999996, 1)
		}, {
			RightItem = t1.rightItemSlot
		}),
		Divider = React.createElement(Foundation.Divider, {
			ZIndex = 2,
			Position = UDim2.fromScale(0.67, 0),
			orientation = DividerOrientation.Vertical
		})
	}))
end

return HorizontalLayout
