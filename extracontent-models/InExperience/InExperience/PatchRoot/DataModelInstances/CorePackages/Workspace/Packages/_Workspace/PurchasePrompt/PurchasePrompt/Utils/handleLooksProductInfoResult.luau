local parent = script:FindFirstAncestor("PurchasePrompt").Parent

require(script.Parent.Parent.types)
local SharedFlags = require(parent.SharedFlags)

local FFlagHideLookDiscountPercentWithIneligibleItems = require(script.Parent.Parent.Flags.FFlagHideLookDiscountPercentWithIneligibleItems)
local FFlagPurchasePromptFetchCartPricingForLooks = SharedFlags.FFlagPurchasePromptFetchCartPricingForLooks
local FIntBlackbirdUpsellMinPriceForDiscountInclusive = SharedFlags.FIntBlackbirdUpsellMinPriceForDiscountInclusive
local FIntBlackbirdUpsellMaxPriceForDiscountInclusive = SharedFlags.FIntBlackbirdUpsellMaxPriceForDiscountInclusive

local function handleLooksProductInfoResult(p, options)
	if not (p and p.look and p.look.items) then
		return nil
	end

	local look = p.look
	local v = options or {}

	local set = {}

	for _, v2 in ipairs(v.excludedAssetIds or {}) do
		set[tostring(v2)] = true
	end

	local set2 = {}

	for _, v2 in ipairs(v.excludedBundleIds or {}) do
		set2[tostring(v2)] = true
	end

	local days = {}

	for _, v2 in ipairs(v.timedOptions or {}) do
		days[v2.itemType .. ":" .. tostring(v2.itemId)] = v2.days
	end

	local total = 0
	local total2 = 0
	local v2 = {}

	local localizedDiscountAttributionsByDiscountCampaign = {}

	local collectibleItemIds = {}
	local cartPricingRequestedItems = {}
	local v3 = false
	local v4 = false

	for _, item in ipairs(look.items) do
		local id = tostring(item.id)

		if not ((item.itemType ~= "Asset" or not set[id]) and (item.itemType ~= "Bundle" or not set2[id])) then
			continue
		end

		local rentalDays = days[item.itemType .. ":" .. id]

		if FFlagPurchasePromptFetchCartPricingForLooks then
			local collectibleItemId = item.collectibleItemId or item.CollectibleItemId or item.collectible_item_id

			if type(collectibleItemId) == "string" and collectibleItemId ~= "" then
				table.insert(collectibleItemIds, collectibleItemId)
				local v5 = { collectibleItemId = collectibleItemId }

				if type(rentalDays) == "number" and rentalDays > 0 then
					v5.rentalDays = rentalDays
				else
					v5.isPermanent = true
				end

				table.insert(cartPricingRequestedItems, v5)
			end
		end

		local v5 = nil
		local discountInformation = nil

		if rentalDays and item.timedOptions then
			local v6 = false

			for _, timedOption in ipairs(item.timedOptions) do
				if timedOption.days == rentalDays then
					v5 = timedOption.price or 0
					discountInformation = timedOption.discountInformation
					v6 = true
					break
				end
			end

			if not v6 then
				v5 = item.priceInRobux or 0
				discountInformation = item.discountInformation
			end
		else
			v5 = item.priceInRobux or 0
			discountInformation = item.discountInformation
		end

		total += v5
		local v6

		if discountInformation then
			v6 = discountInformation.originalPrice or v5
		else
			v6 = v5
		end

		local fIntBlackbirdUpsellMaxPriceForDiscountInclusive = FIntBlackbirdUpsellMaxPriceForDiscountInclusive
		local v7

		if v6 <= FIntBlackbirdUpsellMinPriceForDiscountInclusive then
			v7 = true
		elseif fIntBlackbirdUpsellMaxPriceForDiscountInclusive == 0 then
			v7 = false
		else
			v7 = fIntBlackbirdUpsellMaxPriceForDiscountInclusive <= v6
		end

		if discountInformation and not v7 then
			v3 = true
		else
			v4 = true
		end

		if discountInformation then
			total2 += discountInformation.originalPrice or v5

			for _, v8 in ipairs(discountInformation.discounts or {}) do
				local discountCampaign = v8.discountCampaign

				if not discountCampaign then
					continue
				end

				v2[discountCampaign] = (v2[discountCampaign] or 0) + (v8.robuxDiscountAmount or 0)

				if not (FFlagPurchasePromptFetchCartPricingForLooks and localizedDiscountAttributionsByDiscountCampaign[discountCampaign] == nil) then
					continue
				end

				local localizedDiscountAttribution = v8.localizedDiscountAttribution

				if localizedDiscountAttribution ~= "" then
					localizedDiscountAttributionsByDiscountCampaign[discountCampaign] = localizedDiscountAttribution
				end
			end
		else
			total2 += v5
		end
	end

	local v5 = FFlagHideLookDiscountPercentWithIneligibleItems and v3 and v4
	local priceDiscountDetails = {}

	if total2 > 0 then
		for k, amountInRobux in pairs(v2) do
			if not (amountInRobux > 0) then
				continue
			end

			local v6 = {
				Type = k,
				AmountInRobux = amountInRobux,
				Percent = v5 and 0 or math.round(amountInRobux / total2 * 100),
				LocalizedDiscountAttribution = 0
			}
			local localizedDiscountAttribution

			if FFlagPurchasePromptFetchCartPricingForLooks then
				localizedDiscountAttribution = localizedDiscountAttributionsByDiscountCampaign[k]
			end

			v6.LocalizedDiscountAttribution = localizedDiscountAttribution
			table.insert(priceDiscountDetails, v6)
		end
	end

	local looks = {
		PriceInRobux = total,
		UserBasePriceInRobux = total2,
		PriceDiscountDetails = priceDiscountDetails,
		IsForSale = true,
		Name = "Looks"
	}

	if not FFlagPurchasePromptFetchCartPricingForLooks then
		return looks
	end

	if #collectibleItemIds > 0 then
		looks.CollectibleItemIds = collectibleItemIds
		looks.CollectibleItemId = collectibleItemIds[1]
	end

	if #cartPricingRequestedItems > 0 then
		looks.CartPricingRequestedItems = cartPricingRequestedItems
	end

	return looks
end

return handleLooksProductInfoResult
