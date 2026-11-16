local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

local IAPExperience = require(parent.IAPExperience)
local DiscountType = IAPExperience.DiscountType
local FFlagNormalizePriceDiscountAcceptLowercase = require(PurchasePrompt.Flags.FFlagNormalizePriceDiscountAcceptLowercase)

local set = {
	[DiscountType.BlackbirdSubscription] = true,
	[DiscountType.RobloxPlusSubscription] = true
}

local function isValidRawDiscount(data): boolean
	if type(data) ~= "table" then
		return false
	end

	if FFlagNormalizePriceDiscountAcceptLowercase then
		local kind = data.Type or data.type
		local amountInRobux = data.AmountInRobux or data.amountInRobux
		local percent = data.Percent or data.percent

		if type(kind) ~= "string" or kind == "" or type(amountInRobux) ~= "number" or type(percent) ~= "number" then
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

	for _, item in ipairs(list) do
		if not isValidRawDiscount(item) then
			return {}
		end

		if FFlagNormalizePriceDiscountAcceptLowercase then
			local v = item.Type or item.type
			local amountInRobux = item.AmountInRobux or item.amountInRobux
			local percent = item.Percent or item.percent

			if not set[v] then
				v = DiscountType.Uncategorized
			end

			local v2 = {
				type = v,
				amountInRobux = amountInRobux,
				percent = percent,
				localizedDiscountAttribution = item.LocalizedDiscountAttribution
			}
			table.insert(result, v2)
		else
			local v2

			if set[item.Type] then
				v2 = item.Type
			else
				v2 = DiscountType.Uncategorized
			end

			local v = {
				type = v2,
				amountInRobux = item.AmountInRobux,
				percent = item.Percent,
				localizedDiscountAttribution = item.LocalizedDiscountAttribution
			}
			table.insert(result, v)
		end
	end

	return result
end

return normalizePriceDiscountDetails
