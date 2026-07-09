local Parent = script:FindFirstAncestor("BulkPurchaseApp").Parent
local React = require(Parent.React)
local View = require(Parent.Foundation).View

local function PriceBoxLineLayout(t1: {[any]: any}) -- line: 13
	-- upvalues: React (copy), View (copy)
	return React.createElement(View, {
		tag = "row align-y-center gap-large size-full-0 auto-y",
		LayoutOrder = t1.LayoutOrder
	}, {
		Start = React.createElement(View, {
			LayoutOrder = 1,
			tag = "fill auto-y"
		}, {
			Content = t1.startSlot
		}),
		End = React.createElement(View, {
			LayoutOrder = 2,
			tag = "auto-xy"
		}, {
			Content = t1.endSlot
		})
	})
end

return PriceBoxLineLayout
