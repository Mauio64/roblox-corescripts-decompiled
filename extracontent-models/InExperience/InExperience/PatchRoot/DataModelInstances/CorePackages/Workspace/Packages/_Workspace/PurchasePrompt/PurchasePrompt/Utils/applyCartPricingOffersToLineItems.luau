local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent

require(parent.IAPExperience)
require(PurchasePrompt.types)

local function applyCartPricingOffersToLineItems(items, p, items2)
	local set = {}

	for _, item in items2 do
		set[item] = true
	end

	local v = {}

	for _, v2 in p.items or {} do
		local discountInformation = v2.discountInformation
		local discountIds = {}

		for _, v3 in discountInformation and discountInformation.discounts or {} do
			local discountId = v3.discountId

			if discountId ~= nil and set[discountId] then
				table.insert(discountIds, discountId)
			end
		end

		if #discountIds > 0 then
			v[v2.collectibleItemId] = { offerIds = discountIds, priceInRobux = v2.priceInRobux }
		end
	end

	local result = {}

	for _, item in items do
		local v2 = v[item.collectibleItemId]

		if v2 == nil then
			table.insert(result, item)
		else
			local clone = table.clone(item)
			clone.offerIds = v2.offerIds

			if v2.priceInRobux ~= nil then
				clone.agreedPriceRobux = v2.priceInRobux
			end

			table.insert(result, clone)
		end
	end

	return result
end

return applyCartPricingOffersToLineItems
