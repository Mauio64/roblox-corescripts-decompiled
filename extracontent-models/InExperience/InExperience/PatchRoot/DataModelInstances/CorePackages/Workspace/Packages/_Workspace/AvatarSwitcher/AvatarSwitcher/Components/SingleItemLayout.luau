local Parent = script:FindFirstAncestor("AvatarSwitcher").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local FFlagAXAvatarTimeoutFlowIE = require(Parent.AvatarExperienceFlags).FFlagAXAvatarTimeoutFlowIE

local function SingleItemLayout(t1: {[any]: any}) -- line: 19
	-- upvalues: React (copy), Foundation (copy), FFlagAXAvatarTimeoutFlowIE (copy)
	return (React.createElement(Foundation.View, {
		tag = not FFlagAXAvatarTimeoutFlowIE and "size-full-full" or "size-full-full col"
	}, {
		Header = if not FFlagAXAvatarTimeoutFlowIE then t1.headerSlot else React.createElement(Foundation.View, {
			tag = "auto-y size-full-0 shrink-0 padding-bottom-small",
			LayoutOrder = 1
		}, {
			HeaderSlot = t1.headerSlot
		}),
		Content = React.createElement(Foundation.View, if not FFlagAXAvatarTimeoutFlowIE then {
			Size = UDim2.new(1, 0, 1, -(t1.headerHeight or 0)),
			Position = UDim2.fromOffset(0, t1.headerHeight or 0)
		} else {
			tag = "size-full-0 fill",
			LayoutOrder = 2
		}, {
			ContentSlot = t1.contentSlot
		})
	}))
end

return SingleItemLayout
