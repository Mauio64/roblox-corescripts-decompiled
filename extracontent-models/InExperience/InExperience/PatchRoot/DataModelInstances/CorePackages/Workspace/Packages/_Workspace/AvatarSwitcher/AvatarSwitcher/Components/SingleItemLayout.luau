local parent = script:FindFirstAncestor("AvatarSwitcher").Parent

local React = require(parent.React)
local Foundation = require(parent.Foundation)

local function SingleItemLayout(p)
	return (React.createElement(Foundation.View, { tag = "size-full-full col" }, {
		Header = React.createElement(
			Foundation.View,
			{ tag = "auto-y size-full-0 shrink-0 padding-bottom-small", LayoutOrder = 1 },
			{ HeaderSlot = p.headerSlot }
		),
		Content = React.createElement(Foundation.View, { tag = "size-full-0 fill", LayoutOrder = 2 }, {
			ContentSlot = p.contentSlot
		})
	}))
end

return SingleItemLayout
