require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags")

local FFlagHideLookDiscountPercentWithIneligibleItems = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagHideLookDiscountPercentWithIneligibleItems")
local fFlagPurchasePromptFetchCartPricingForLooks = SharedFlags.FFlagPurchasePromptFetchCartPricingForLooks
local fIntBlackbirdUpsellMinPriceForDiscountInclusive = SharedFlags.FIntBlackbirdUpsellMinPriceForDiscountInclusive
local fIntBlackbirdUpsellMaxPriceForDiscountInclusive = SharedFlags.FIntBlackbirdUpsellMaxPriceForDiscountInclusive

local function handleLooksProductInfoResult(p2, options)
	if not (p2 and p2.look and p2.look.items) then
		return nil
	end

	local look = p2.look
	local v5 = options or {}

	local set = {}

	for i, v6 in ipairs(v5.excludedAssetIds or {}) do
		set[tostring(v6)] = true
	end

	local set2 = {}

	for i, v6 in ipairs(v5.excludedBundleIds or {}) do
		set2[tostring(v6)] = true
	end

	local days = {}

	for i, v6 in ipairs(v5.timedOptions or {}) do
		days[v6.itemType .. ":" .. tostring(v6.itemId)] = v6.days
	end

	local total = 0
	local total2 = 0
	local v6 = {}

	local localizedDiscountAttributionsByDiscountCampaign = {}

	local collectibleItemIds = {}
	local v7 = {}
	local v8 = false
	local v9 = false

	for i, item in ipairs(look.items) do
		local id = tostring(item.id)

		if not ((item.itemType ~= "Asset" or not set[id]) and (item.itemType ~= "Bundle" or not set2[id])) then
			continue
		end

		local v10 = days[item.itemType .. ":" .. id]

		if fFlagPurchasePromptFetchCartPricingForLooks then
			local collectibleItemId = item.collectibleItemId
				or item.CollectibleItemId
				or item.collectible_item_id

			if type(collectibleItemId) == "string" and collectibleItemId ~= "" then
				table.insert(collectibleItemIds, collectibleItemId)
				local v11 = { collectibleItemId = collectibleItemId }

				if type(v10) == "number" and v10 > 0 then
					v11.rentalDays = v10
				else
					v11.isPermanent = true
				end

				table.insert(v7, v11)
			end
		end

		local v11 = nil
		local discountInformation = nil

		if v10 and item.timedOptions then
			local v12 = false

			for j, timedOption in ipairs(item.timedOptions) do
				if timedOption.days == v10 then
					v11 = timedOption.price or 0
					discountInformation = timedOption.discountInformation
					v12 = true
					break
				end
			end

			if not v12 then
				v11 = item.priceInRobux or 0
				discountInformation = item.discountInformation
			end
		else
			v11 = item.priceInRobux or 0
			discountInformation = item.discountInformation
		end

		total += v11

		local v12 = if discountInformation then discountInformation.originalPrice or v11 else v11
		local v13 = fIntBlackbirdUpsellMaxPriceForDiscountInclusive
		local v14 = v12 <= fIntBlackbirdUpsellMinPriceForDiscountInclusive or not (v13 == 0) and v13 <= v12

		if discountInformation and not v14 then
			v8 = true
		else
			v9 = true
		end

		if discountInformation then
			total2 += discountInformation.originalPrice or v11

			for j, v15 in ipairs(discountInformation.discounts or {}) do
				local discountCampaign = v15.discountCampaign

				if not discountCampaign then
					continue
				end

				v6[discountCampaign] = (v6[discountCampaign] or 0) + (v15.robuxDiscountAmount or 0)

				if not (fFlagPurchasePromptFetchCartPricingForLooks and localizedDiscountAttributionsByDiscountCampaign[discountCampaign] == nil) then
					continue
				end

				local localizedDiscountAttribution = v15.localizedDiscountAttribution

				if localizedDiscountAttribution ~= "" then
					localizedDiscountAttributionsByDiscountCampaign[discountCampaign] = localizedDiscountAttribution
				end
			end
		else
			total2 += v11
		end
	end

	local v10 = FFlagHideLookDiscountPercentWithIneligibleItems and v8 and v9
	local v11 = {}

	if total2 > 0 then
		for k, v12 in pairs(v6) do
			if not (v12 > 0) then
				continue
			end

			local v13 = {
				Type = k,
				AmountInRobux = v12,
				Percent = v10 and 0 or math.round(v12 / total2 * 100),
				LocalizedDiscountAttribution = 0
			}

			local v14 = if fFlagPurchasePromptFetchCartPricingForLooks then localizedDiscountAttributionsByDiscountCampaign[k] else nil
			v13.LocalizedDiscountAttribution = v14
			table.insert(v11, v13)
		end
	end

	local looks = {
		PriceInRobux = total,
		UserBasePriceInRobux = total2,
		PriceDiscountDetails = v11,
		IsForSale = true,
		Name = "Looks"
	}

	if not fFlagPurchasePromptFetchCartPricingForLooks then
		return looks
	end

	if #collectibleItemIds > 0 then
		looks.CollectibleItemIds = collectibleItemIds
		looks.CollectibleItemId = collectibleItemIds[1]
	end

	if #v7 > 0 then
		looks.CartPricingRequestedItems = v7
	end

	return looks
end

return handleLooksProductInfoResult
