local parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(parent.React)

local Foundation = require(parent.Foundation)
local View = Foundation.View

local function PriceBoxLineLayout(props)
	return React.createElement(
		View,
		{ LayoutOrder = props.LayoutOrder, tag = "row align-y-center gap-large size-full-0 auto-y" },
		{
			Start = React.createElement(View, { LayoutOrder = 1, tag = "fill auto-y" }, {
				Content = props.startSlot
			}),
			End = React.createElement(View, { LayoutOrder = 2, tag = "auto-xy" }, {
				Content = props.endSlot
			})
		}
	)
end

return PriceBoxLineLayout
