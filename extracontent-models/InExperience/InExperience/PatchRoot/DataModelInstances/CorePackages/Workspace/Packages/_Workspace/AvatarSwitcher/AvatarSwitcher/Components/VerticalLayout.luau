local Parent = script:FindFirstAncestor("AvatarSwitcher").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FFlagAXAvatarTimeoutFlowIE = require(Parent.AvatarExperienceFlags).FFlagAXAvatarTimeoutFlowIE

local function VerticalLayout(t1: {[any]: any}) -- line: 21
	-- upvalues: React (copy), Foundation (copy), FFlagAXAvatarTimeoutFlowIE (copy)
	return (React.createElement(Foundation.View, {
		tag = not FFlagAXAvatarTimeoutFlowIE and "size-full-full" or "size-full-full col"
	}, {
		Header = if not FFlagAXAvatarTimeoutFlowIE then t1.headerSlot else React.createElement(Foundation.View, {
			tag = "auto-y size-full-0 shrink-0",
			LayoutOrder = 1
		}, {
			HeaderSlot = t1.headerSlot
		}),
		Divider = React.createElement(Foundation.Divider, {
			ZIndex = 2,
			Position = if not FFlagAXAvatarTimeoutFlowIE then UDim2.fromOffset(0, t1.headerHeight or 0) else nil,
			LayoutOrder = if not FFlagAXAvatarTimeoutFlowIE then nil else 2
		}),
		Content = React.createElement(Foundation.View, if not FFlagAXAvatarTimeoutFlowIE then {
			Size = UDim2.new(1, 0, 1, -(t1.headerHeight or 0)),
			Position = UDim2.fromOffset(0, t1.headerHeight or 0)
		} else {
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
