local discountType = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience").DiscountType
local FFlagNormalizePriceDiscountAcceptLowercase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagNormalizePriceDiscountAcceptLowercase")

local set = {
	[discountType.BlackbirdSubscription] = true,
	[discountType.RobloxPlusSubscription] = true
}

local function isValidRawDiscount(data): boolean
	if type(data) ~= "table" then
		return false
	end

	if FFlagNormalizePriceDiscountAcceptLowercase then
		local kind = data.Type or data.type
		local amountInRobux = data.AmountInRobux or data.amountInRobux
		local percent = data.Percent or data.percent

		if
			type(kind) ~= "string"
			or kind == ""
			or type(amountInRobux) ~= "number"
			or type(percent) ~= "number"
		then
			return false
		end
	else
		if type(data.Type) ~= "string" or data.Type == "" or type(data.AmountInRobux) ~= "number" then
			return false
		end

		if type(data.Percent) ~= "number" then
			return false
		end
	end

	return true
end

local function normalizePriceDiscountDetails(list)
	if type(list) ~= "table" or #list == 0 then
		return {}
	end

	local result = {}

	for i, item in ipairs(list) do
		if not isValidRawDiscount(item) then
			return {}
		end

		if FFlagNormalizePriceDiscountAcceptLowercase then
			local v5 = item.Type or item.type
			local amountInRobux = item.AmountInRobux or item.amountInRobux
			local percent = item.Percent or item.percent

			if not set[v5] then
				v5 = discountType.Uncategorized
			end

			local v6 = {
				type = v5,
				amountInRobux = amountInRobux,
				percent = percent,
				localizedDiscountAttribution = item.LocalizedDiscountAttribution
			}
			table.insert(result, v6)
		else
			local v6 = if set[item.Type] then item.Type else discountType.Uncategorized
			local v5 = {
				type = v6,
				amountInRobux = item.AmountInRobux,
				percent = item.Percent,
				localizedDiscountAttribution = item.LocalizedDiscountAttribution
			}
			table.insert(result, v5)
		end
	end

	return result
end

return normalizePriceDiscountDetails
