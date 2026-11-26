local productTypeEnum = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types").ProductTypeEnum

local function buildPermanentRowsFromIds(collectibleItemIds)
	local permanentRowsFromIds = table.create(#collectibleItemIds)

	for k, item in collectibleItemIds do
		if type(item) == "string" and item ~= "" then
			table.insert(permanentRowsFromIds, {
				collectibleItemId = item,
				isPermanent = true
			})
		end
	end

	return permanentRowsFromIds
end

local function getCartPricingRequestedItemsForCartPricing(p2, data, p3)
	if type(data) == "table" and data.kind == productTypeEnum.Look then
		local cartPricingRequestedItems = data.cartPricingRequestedItems

		if type(cartPricingRequestedItems) == "table" and #cartPricingRequestedItems > 0 then
			local result = table.create(#cartPricingRequestedItems)

			for k, cartPricingRequestedItem in cartPricingRequestedItems do
				local rentalDays = cartPricingRequestedItem.rentalDays
				local v5 = type(rentalDays) == "number" and rentalDays > 0
				local v6 = {
					collectibleItemId = cartPricingRequestedItem.collectibleItemId,
					rentalDays = 0,
					isPermanent = 0
				}

				if not v5 then
					rentalDays = nil
				end

				v6.rentalDays = rentalDays
				v6.isPermanent = not v5 or nil
				table.insert(result, v6)
			end

			return result
		else
			local collectibleItemIds = if type(p3) == "table" then p3.collectibleItemIds else nil

			if type(collectibleItemIds) == "table" and #collectibleItemIds > 0 then
				local permanentRowsFromIds = buildPermanentRowsFromIds(collectibleItemIds)

				if #permanentRowsFromIds > 0 then
					return permanentRowsFromIds
				end
			end

			return nil
		end
	else
		if p2 == nil or p2 == "" then
			return nil
		end

		local v5 = { collectibleItemId = p2 }

		if type(data) == "table" and data.kind == productTypeEnum.Asset then
			local timedOptionDays = data.timedOptionDays

			if type(timedOptionDays) == "number" and timedOptionDays > 0 then
				v5.rentalDays = timedOptionDays
			end
		end

		if v5.rentalDays == nil then
			v5.isPermanent = true
		end

		return { v5 }
	end
end

return getCartPricingRequestedItemsForCartPricing
