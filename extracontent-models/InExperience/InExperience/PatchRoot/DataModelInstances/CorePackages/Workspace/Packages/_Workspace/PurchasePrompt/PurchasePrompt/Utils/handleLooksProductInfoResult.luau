local Parent = script:FindFirstAncestor("PurchasePrompt").Parent

require(script.Parent.Parent.types)

local SharedFlags = require(Parent.SharedFlags)
local FFlagHideLookDiscountPercentWithIneligibleItems = require(script.Parent.Parent.Flags.FFlagHideLookDiscountPercentWithIneligibleItems)
local FFlagPurchasePromptFetchCartPricingForLooks = SharedFlags.FFlagPurchasePromptFetchCartPricingForLooks
local FIntBlackbirdUpsellMinPriceForDiscountInclusive = SharedFlags.FIntBlackbirdUpsellMinPriceForDiscountInclusive
local FIntBlackbirdUpsellMaxPriceForDiscountInclusive = SharedFlags.FIntBlackbirdUpsellMaxPriceForDiscountInclusive

local function handleLooksProductInfoResult(p1, t1: {[any]: any}) -- line: 37
	-- upvalues: FFlagPurchasePromptFetchCartPricingForLooks (copy), FIntBlackbirdUpsellMaxPriceForDiscountInclusive (copy), FIntBlackbirdUpsellMinPriceForDiscountInclusive (copy), FFlagHideLookDiscountPercentWithIneligibleItems (copy)
	if not p1 or (not p1.look or not p1.look.items) then
		return nil
	end

	local look = p1.look
	local v11 = t1 or {}
	local t2 = {}

	for _, v in ipairs(v11.excludedAssetIds or {}) do
		t2[tostring(v)] = true
	end

	local t3 = {}

	for _, v in ipairs(v11.excludedBundleIds or {}) do
		t3[tostring(v)] = true
	end

	local t4 = {}

	for _, v in ipairs(v11.timedOptions or {}) do
		t4[v.itemType .. ":" .. tostring(v.itemId)] = v.days
	end

	local n1 = 0
	local n2 = 0
	local t5 = {}
	local t6 = {}
	local v25 = false
	local v26 = false
	local t7 = {}
	local t8 = {}

	for _, v in ipairs(look.items) do
		local str = tostring(v.id)

		if (v.itemType ~= "Asset" or not t2[str]) and (v.itemType ~= "Bundle" or not t3[str]) then
			local v32 = t4[v.itemType .. ":" .. str]

			if FFlagPurchasePromptFetchCartPricingForLooks then
				local v33 = v.collectibleItemId or (v.CollectibleItemId or v.collectible_item_id)

				if type(v33) == "string" and v33 ~= "" then
					table.insert(t7, v33)

					local t9 = {
						collectibleItemId = v33
					}

					if type(v32) == "number" and v32 > 0 then
						t9.rentalDays = v32
					else
						t9.isPermanent = true
					end

					table.insert(t8, t9)
				end
			end

			local v35 = nil
			local discountInformation = nil

			if v32 and v.timedOptions then
				local v37 = false

				for _, v2 in ipairs(v.timedOptions) do
					if v32 == v2.days then
						v35 = v2.price or 0
						discountInformation = v2.discountInformation
						v37 = true

						break
					end
				end

				if not v37 then
					v35 = v.priceInRobux or 0
					discountInformation = v.discountInformation
				end
			else
				v35 = v.priceInRobux or 0
				discountInformation = v.discountInformation
			end

			n1 += v35

			local v40 = if not discountInformation then v35 else discountInformation.originalPrice or v35
			local v41 = FIntBlackbirdUpsellMaxPriceForDiscountInclusive
			local v42 = v40 <= FIntBlackbirdUpsellMinPriceForDiscountInclusive or v41 ~= 0 and v41 <= v40

			if discountInformation and not v42 then
				v25 = true
			else
				v26 = true
			end

			if discountInformation then
				n2 += discountInformation.originalPrice or v35

				for _, v3 in ipairs(discountInformation.discounts or {}) do
					local discountCampaign = v3.discountCampaign

					if discountCampaign then
						t5[discountCampaign] = (t5[discountCampaign] or 0) + (v3.robuxDiscountAmount or 0)

						if FFlagPurchasePromptFetchCartPricingForLooks and t6[discountCampaign] == nil then
							local localizedDiscountAttribution = v3.localizedDiscountAttribution

							if localizedDiscountAttribution ~= "" then
								t6[discountCampaign] = localizedDiscountAttribution
							end
						end
					end
				end
			else
				n2 += v35
			end
		end
	end

	local v47 = FFlagHideLookDiscountPercentWithIneligibleItems and (v25 and v26)
	local t10 = {}

	if n2 > 0 then
		for k, v in pairs(t5) do
			if v > 0 then
				table.insert(t10, {
					Type = k,
					AmountInRobux = v,
					Percent = if not v47 then math.round(v / n2 * 100) else 0,
					LocalizedDiscountAttribution = if not FFlagPurchasePromptFetchCartPricingForLooks then nil else t6[k]
				})
			end
		end
	end

	local t11 = {
		IsForSale = true,
		Name = "Looks",
		PriceInRobux = n1,
		UserBasePriceInRobux = n2,
		PriceDiscountDetails = t10
	}

	if FFlagPurchasePromptFetchCartPricingForLooks then
		if #t7 > 0 then
			t11.CollectibleItemIds = t7
			t11.CollectibleItemId = t7[1]
		end

		if #t8 > 0 then
			t11.CartPricingRequestedItems = t8
		end
	end

	return t11
end

return handleLooksProductInfoResult
