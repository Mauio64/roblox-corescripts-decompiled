local Parent = script:FindFirstAncestor("IAPExperience").Parent
local React = require(Parent.React)
local t1 = {
	["IAPExperience.PurchasePrompt.Label.BlackbirdDiscount"] = "Sit amet ({discountPercentage}% elit)",
	["IAPExperience.PurchasePrompt.Label.BlackbirdDiscountNoPercent"] = "Sit amet",
	["IAPExperience.PurchasePrompt.Label.GenericDiscount"] = "... ({discountPercentage}% elit)",
	["IAPExperience.PurchasePrompt.Label.GenericDiscountNoPercent"] = "...",
	["IAPExperience.PurchasePrompt.Label.BlackbirdSummary"] = "Lorem {robuxIcon} {savingsAmount} ipsum dolor",
	["IAPExperience.PurchasePrompt.Label.Subtotal"] = "Subtotal",
	["IAPExperience.PurchasePrompt.Label.SubtotalWithItemCount"] = "Subtotal ({itemCount} items)",
	["IAPExperience.PurchasePrompt.Label.Total"] = "Total"
}

local function usePlaceholderLocalization(t2: {[any]: any}) -- line: 24
	-- upvalues: React (copy), t1 (copy)
	return React.useMemo(function() -- line: 25
		-- upvalues: t2 (copy), t1 (copy)
		local t3 = {}

		for k, v in pairs(t2) do
			local v9 = if typeof(v) ~= "table" then v else v[1]
			local v10 = t1[v9] or v9

			if typeof(v) == "table" then
				for k2, v2 in pairs(v) do
					if typeof(k2) == "string" then
						v10 = string.gsub(v10, "{" .. k2 .. "}", function() -- line: 33
							-- upvalues: v2 (copy)
							return (tostring(v2))
						end)
					end
				end
			end

			t3[k] = v10
		end

		return t3
	end, { t2 })
end

return usePlaceholderLocalization
