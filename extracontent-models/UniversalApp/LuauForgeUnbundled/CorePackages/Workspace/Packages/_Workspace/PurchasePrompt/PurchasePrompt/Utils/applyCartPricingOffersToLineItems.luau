require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/IAPExperience")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")

local function applyCartPricingOffersToLineItems(items, p2, items2)
	local set = {}

	for k, item in items2 do
		set[item] = true
	end

	local v5 = {}

	for k, v6 in p2.items or {} do
		local discountInformation = v6.discountInformation
		local discountIds = {}

		for k2, v7 in discountInformation and discountInformation.discounts or {} do
			local discountId = v7.discountId

			if discountId ~= nil and set[discountId] then
				table.insert(discountIds, discountId)
			end
		end

		if #discountIds > 0 then
			v5[v6.collectibleItemId] = {
				offerIds = discountIds,
				priceInRobux = v6.priceInRobux
			}
		end
	end

	local result = {}

	for k, item in items do
		local v6 = v5[item.collectibleItemId]

		if v6 == nil then
			table.insert(result, item)
		else
			local clone = table.clone(item)
			clone.offerIds = v6.offerIds

			if v6.priceInRobux ~= nil then
				clone.agreedPriceRobux = v6.priceInRobux
			end

			table.insert(result, clone)
		end
	end

	return result
end

return applyCartPricingOffersToLineItems
