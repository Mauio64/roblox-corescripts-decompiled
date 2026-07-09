local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local PurchasePromptParent = PurchasePrompt.Parent
local DiscountType = require(PurchasePromptParent.IAPExperience).DiscountType
local FFlagNormalizePriceDiscountAcceptLowercase = require(PurchasePrompt.Flags.FFlagNormalizePriceDiscountAcceptLowercase)
local FFlagPurchasePromptCartPricingEnabled = require(PurchasePrompt.Flags.FFlagPurchasePromptCartPricingEnabled)
local t1 = {
	[DiscountType.BlackbirdSubscription] = true,
	[DiscountType.RobloxPlusSubscription] = true
}

local function isValidRawDiscount(p1) -- line: 16
	-- upvalues: FFlagNormalizePriceDiscountAcceptLowercase (copy)
	if type(p1) ~= "table" then
		return false
	end

	if FFlagNormalizePriceDiscountAcceptLowercase then
		local v10 = p1.Type or p1.type
		local v11 = p1.AmountInRobux or p1.amountInRobux
		local v12 = p1.Percent or p1.percent

		if type(v10) ~= "string" or v10 == "" then
			return false
		end

		if type(v11) ~= "number" then
			return false
		end

		if type(v12) ~= "number" then
			return false
		end
	else
		if type(p1.Type) ~= "string" or p1.Type == "" then
			return false
		end

		if type(p1.AmountInRobux) ~= "number" then
			return false
		end

		if type(p1.Percent) ~= "number" then
			return false
		end
	end

	return true
end
local function normalizePriceDiscountDetails(t2: {[any]: any}?) -- line: 50
	-- upvalues: isValidRawDiscount (copy), FFlagNormalizePriceDiscountAcceptLowercase (copy), t1 (copy), DiscountType (copy), FFlagPurchasePromptCartPricingEnabled (copy)
	if type(t2) ~= "table" or #t2 == 0 then
		return {}
	end

	local t3 = {}

	for _, v in ipairs(t2) do
		if not isValidRawDiscount(v) then
			return {}
		end

		if FFlagNormalizePriceDiscountAcceptLowercase then
			local v17 = v.Type or v.type
			local v18 = v.AmountInRobux or v.amountInRobux
			local v19 = v.Percent or v.percent

			table.insert(t3, {
				type = if not t1[v17] then DiscountType.Uncategorized else v17,
				amountInRobux = v18,
				percent = v19,
				localizedDiscountAttribution = if not FFlagPurchasePromptCartPricingEnabled then nil else v.LocalizedDiscountAttribution
			})
		else
			table.insert(t3, {
				type = if not t1[v.Type] then DiscountType.Uncategorized else v.Type,
				amountInRobux = v.AmountInRobux,
				percent = v.Percent,
				localizedDiscountAttribution = if not FFlagPurchasePromptCartPricingEnabled then nil else v.LocalizedDiscountAttribution
			})
		end
	end

	return t3
end

return normalizePriceDiscountDetails
