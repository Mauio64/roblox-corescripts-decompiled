local Foundation = script:FindFirstAncestor("Foundation")
local FoundationParent = Foundation.Parent
local React = require(FoundationParent.React)
local View = require(Foundation.Components.View)
local useTokens = require(Foundation.Providers.Style.useTokens)

local function BaseMenuDivider(t1: {[any]: any}) -- line: 9
	-- upvalues: useTokens (copy), React (copy), View (copy)
	local v8 = useTokens()

	return React.createElement(View, {
		tag = "row flex-x-fill",
		testId = "--foundation-menu-divider-item",
		LayoutOrder = t1.LayoutOrder,
		Size = UDim2.new(1, 0, 0, v8.Stroke.Standard)
	}, React.createElement(View, {
		tag = "grow size-0-full",
		backgroundStyle = v8.Color.Stroke.Default
	}))
end

return BaseMenuDivider
