local Parent = script:FindFirstAncestor("AvatarSwitcher").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)

local function SingleItemLayout(t1: {[any]: any}) -- line: 16
	-- upvalues: React (copy), Foundation (copy)
	return (React.createElement(Foundation.View, {
		tag = "size-full-full col"
	}, {
		Header = React.createElement(Foundation.View, {
			tag = "auto-y size-full-0 shrink-0 padding-bottom-small",
			LayoutOrder = 1
		}, {
			HeaderSlot = t1.headerSlot
		}),
		Content = React.createElement(Foundation.View, {
			tag = "size-full-0 fill",
			LayoutOrder = 2
		}, {
			ContentSlot = t1.contentSlot
		})
	}))
end

return SingleItemLayout
