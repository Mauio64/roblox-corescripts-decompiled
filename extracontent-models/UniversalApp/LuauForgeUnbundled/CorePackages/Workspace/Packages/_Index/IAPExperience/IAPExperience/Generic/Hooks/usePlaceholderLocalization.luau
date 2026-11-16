local React = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/React")

local v5 = {
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
			local v6 = if typeof(item) == "table" then item[1] else item
			local v7 = v5[v6] or v6

			if typeof(item) == "table" then
				for k2, v8 in pairs(item) do
					if typeof(k2) ~= "string" then
						continue
					end

					local v9 = v8
					v7 = string.gsub(v7, "{" .. k2 .. "}", function()
						return (tostring(v9))
					end)
				end
			end

			result[k] = v7
		end

		return result
	end, { items })
end

return usePlaceholderLocalization
