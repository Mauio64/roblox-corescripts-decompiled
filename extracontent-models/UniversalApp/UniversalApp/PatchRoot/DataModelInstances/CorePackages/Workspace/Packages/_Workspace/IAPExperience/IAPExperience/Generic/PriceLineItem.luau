local Parent = script:FindFirstAncestor("IAPExperience").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local View = Foundation.View
local FoundationText = Foundation.Text
local combineReactTags = require(Parent.RoactUtils).combineReactTags
local FFlagPurchasePromptFetchCartPricing = require(Parent.SharedFlags).FFlagPurchasePromptFetchCartPricing

local function PriceLineItem(t1: {[any]: any}) -- line: 26
	-- upvalues: React (copy), combineReactTags (copy), View (copy), FoundationText (copy), FFlagPurchasePromptFetchCartPricing (copy)
	local v10 = t1.textStyle or "text-body-small content-emphasis"
	local v11 = React.useMemo(function() -- line: 28
		-- upvalues: combineReactTags (copy), v10 (copy)
		return combineReactTags("auto-y", v10, "content-emphasis", "text-align-x-left")
	end, { v10 })
	local v12 = React.useMemo(function() -- line: 31
		-- upvalues: combineReactTags (copy), v10 (copy)
		return combineReactTags("auto-y", v10, "content-emphasis", "text-align-x-right")
	end, { v10 })

	return React.createElement(View, {
		LayoutOrder = t1.LayoutOrder,
		tag = t1.tag or "row size-full-0 auto-y align-y-center padding-x-xsmall"
	}, {
		Label = React.createElement(FoundationText, {
			LayoutOrder = 1,
			Text = t1.label,
			Size = UDim2.new(0.5, 0, 0, 0),
			tag = v11,
			RichText = not not FFlagPurchasePromptFetchCartPricing or nil
		}),
		Amount = React.createElement(FoundationText, {
			LayoutOrder = 2,
			RichText = true,
			Text = t1.amount,
			Size = UDim2.new(0.5, 0, 0, 0),
			tag = v12
		})
	})
end

return PriceLineItem
