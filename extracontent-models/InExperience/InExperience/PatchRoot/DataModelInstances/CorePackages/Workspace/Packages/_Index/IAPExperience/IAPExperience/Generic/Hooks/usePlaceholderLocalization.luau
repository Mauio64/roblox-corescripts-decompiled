local parent = script:FindFirstAncestor("IAPExperience").Parent
local React = require(parent.React)

local v = {
	["IAPExperience.PurchasePrompt.Label.BlackbirdDiscount"] = "Sit amet ({discountPercentage}% elit)",
	["IAPExperience.PurchasePrompt.Label.BlackbirdDiscountNoPercent"] = "Sit amet",
	["IAPExperience.PurchasePrompt.Label.GenericDiscount"] = "... ({discountPercentage}% elit)",
	["IAPExperience.PurchasePrompt.Label.GenericDiscountNoPercent"] = "...",
	["IAPExperience.PurchasePrompt.Label.BlackbirdSummary"] = "Lorem {robuxIcon} {savingsAmount} ipsum dolor",
	["IAPExperience.PurchasePrompt.Label.Subtotal"] = "Subtotal",
	["IAPExperience.PurchasePrompt.Label.SubtotalWithItemCount"] = "Subtotal ({itemCount} items)",
	["IAPExperience.PurchasePrompt.Label.Total"] = "Total"
}

local function usePlaceholderLocalization(items)
	return React.useMemo(function()
		local result = {}

		for k, item in pairs(items) do
			local v2

			if typeof(item) == "table" then
				v2 = item[1]
			else
				v2 = item
			end

			local v3 = v[v2] or v2

			if typeof(item) == "table" then
				for k2, v4 in pairs(item) do
					if typeof(k2) ~= "string" then
						continue
					end

					local v5 = v4
					v3 = string.gsub(v3, "{" .. k2 .. "}", function()
						return (tostring(v5))
					end)
				end
			end

			result[k] = v3
		end

		return result
	end, { items })
end

return usePlaceholderLocalization
