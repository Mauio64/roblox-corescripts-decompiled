local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local types = require(PurchasePrompt.types)
local productTypeEnum = types.ProductTypeEnum

local function buildPermanentRowsFromIds(collectibleItemIds)
	local permanentRowsFromIds = table.create(#collectibleItemIds)

	for _, item in collectibleItemIds do
		if type(item) == "string" and item ~= "" then
			table.insert(permanentRowsFromIds, { collectibleItemId = item, isPermanent = true })
		end
	end

	return permanentRowsFromIds
end

local function getCartPricingRequestedItemsForCartPricing(collectibleItemId: string?, data, p)
	if type(data) == "table" and data.kind == productTypeEnum.Look then
		local cartPricingRequestedItems = data.cartPricingRequestedItems

		if type(cartPricingRequestedItems) == "table" and #cartPricingRequestedItems > 0 then
			local result = table.create(#cartPricingRequestedItems)

			for _, cartPricingRequestedItem in cartPricingRequestedItems do
				local rentalDays = cartPricingRequestedItem.rentalDays
				local v

				if type(rentalDays) == "number" then
					v = rentalDays > 0
				else
					v = false
				end

				local v2 = {
					collectibleItemId = cartPricingRequestedItem.collectibleItemId,
					rentalDays = 0,
					isPermanent = 0
				}

				if not v then
					rentalDays = nil
				end

				v2.rentalDays = rentalDays
				v2.isPermanent = not v or nil
				table.insert(result, v2)
			end

			return result
		else
			local collectibleItemIds

			if type(p) == "table" then
				collectibleItemIds = p.collectibleItemIds
			end

			if type(collectibleItemIds) == "table" and #collectibleItemIds > 0 then
				local permanentRowsFromIds = buildPermanentRowsFromIds(collectibleItemIds)

				if #permanentRowsFromIds > 0 then
					return permanentRowsFromIds
				end
			end

			return nil
		end
	else
		if collectibleItemId == nil or collectibleItemId == "" then
			return nil
		end

		local v = { collectibleItemId = collectibleItemId }

		if type(data) == "table" and data.kind == productTypeEnum.Asset then
			local timedOptionDays = data.timedOptionDays

			if type(timedOptionDays) == "number" and timedOptionDays > 0 then
				v.rentalDays = timedOptionDays
			end
		end

		if v.rentalDays == nil then
			v.isPermanent = true
		end

		return { v }
	end
end

return getCartPricingRequestedItemsForCartPricing
