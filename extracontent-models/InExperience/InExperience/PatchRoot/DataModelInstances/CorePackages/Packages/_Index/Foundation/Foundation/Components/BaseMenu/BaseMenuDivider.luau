local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function BaseMenuDivider(p)
	local v = useTokens()
	return React.createElement(
		View,
		{
			LayoutOrder = p.LayoutOrder,
			Size = UDim2.new(1, 0, 0, v.Stroke.Standard),
			tag = "row flex-x-fill",
			testId = "--foundation-menu-divider-item"
		},
		React.createElement(View, {
			tag = "grow size-0-full",
			backgroundStyle = v.Color.Stroke.Default
		})
	)
end

return BaseMenuDivider
