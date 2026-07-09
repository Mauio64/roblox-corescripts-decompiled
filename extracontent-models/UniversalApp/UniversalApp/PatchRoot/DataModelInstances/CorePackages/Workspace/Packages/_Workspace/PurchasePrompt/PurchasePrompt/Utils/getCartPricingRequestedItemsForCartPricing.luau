local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local ProductTypeEnum = require(PurchasePrompt.types).ProductTypeEnum

local function buildPermanentRowsFromIds(t1: {[any]: any}) -- line: 27
	local t2 = table.create(#t1)

	for _, v8 in t1 do
		if type(v8) == "string" and v8 ~= "" then
			table.insert(t2, {
				isPermanent = true,
				collectibleItemId = v8
			})
		end
	end

	return t2
end
local function getCartPricingRequestedItemsForCartPricing(s1: string?, p1, p2) -- line: 37
	-- upvalues: ProductTypeEnum (copy), buildPermanentRowsFromIds (copy)
	if type(p1) == "table" and p1.kind == ProductTypeEnum.Look then
		local cartPricingRequestedItems = p1.cartPricingRequestedItems

		if type(cartPricingRequestedItems) == "table" and #cartPricingRequestedItems > 0 then
			local t3 = table.create(#cartPricingRequestedItems)

			for _, v15 in cartPricingRequestedItems do
				local rentalDays = v15.rentalDays
				local v17 = type(rentalDays) == "number" and rentalDays > 0

				table.insert(t3, {
					collectibleItemId = v15.collectibleItemId,
					rentalDays = if not v17 then nil else rentalDays,
					isPermanent = not v17 or nil
				})
			end

			return t3
		end

		local v18 = if type(p2) ~= "table" then nil else p2.collectibleItemIds

		if type(v18) == "table" and #v18 > 0 then
			local v19 = buildPermanentRowsFromIds(v18)

			if #v19 > 0 then
				return v19
			end
		end

		return nil
	end

	if s1 == nil or s1 == "" then
		return nil
	end

	local t4 = {
		collectibleItemId = s1
	}

	if type(p1) == "table" and p1.kind == ProductTypeEnum.Asset then
		local timedOptionDays = p1.timedOptionDays

		if type(timedOptionDays) == "number" and timedOptionDays > 0 then
			t4.rentalDays = timedOptionDays
		end
	end

	if t4.rentalDays == nil then
		t4.isPermanent = true
	end

	return { t4 }
end

return getCartPricingRequestedItemsForCartPricing
