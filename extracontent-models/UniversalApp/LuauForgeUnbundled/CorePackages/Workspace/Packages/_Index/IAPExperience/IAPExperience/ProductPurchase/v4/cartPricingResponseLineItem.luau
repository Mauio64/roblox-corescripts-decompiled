local decodeLuauUnicodeEscapes = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Utility/decodeLuauUnicodeEscapes")
local FFlagCartPricingSupportGameItemOffer = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Flags/FFlagCartPricingSupportGameItemOffer")

local discountType = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/ProductPurchase/PricingTypes").DiscountType

local v5 = {
	RobloxPlus = "ROBLOX_PLUS",
	MarketplaceOffer = "MARKETPLACE_OFFER",
	Offer = "OFFER"
}

local function mapCartPricingDiscountType(p2)
	if p2 == "ROBLOX_PLUS" then
		return discountType.RobloxPlusSubscription
	end

	return discountType.Uncategorized
end

local function isOfferDiscountType(p2)
	if p2 == "MARKETPLACE_OFFER" then
		return true
	end

	return FFlagCartPricingSupportGameItemOffer and p2 == "OFFER"
end

local function consolidateRobloxPlusDiscounts(items)
	local v6 = nil
	local result = {}

	for k, item in items do
		if item.type == discountType.RobloxPlusSubscription then
			if v6 == nil then
				table.insert(result, {
					type = item.type,
					amountInRobux = item.amountInRobux,
					percent = item.percent,
					localizedDiscountAttribution = item.localizedDiscountAttribution
				})

				v6 = #result
			else
				result[v6].amountInRobux += item.amountInRobux
			end
		else
			table.insert(result, item)
		end
	end

	return result
end

local v6 = {
	getCartLineSalePriceInRobux = function(p2)
		if type(p2) ~= "table" then
			return nil
		end

		local priceInRobux = p2.priceInRobux

		if type(priceInRobux) == "number" and not (priceInRobux < 0) then
			return priceInRobux
		end

		return nil
	end,
	getCartLineRegularPriceInRobux = function(p2, p3)
		if type(p2) == "table" then
			local regularPriceInRobux = p2.regularPriceInRobux

			if type(regularPriceInRobux) == "number" and p3 <= regularPriceInRobux then
				return regularPriceInRobux
			end
		end

		return p3
	end,
	extractCartPricingMarketingOffers = function(p2)
		local cartPricingMarketingOffers = {}

		if type(p2) ~= "table" then
			return cartPricingMarketingOffers
		end

		local availableOffers = p2.availableOffers

		if type(availableOffers) ~= "table" then
			return cartPricingMarketingOffers
		end

		for k, availableOffer in availableOffers do
			if type(availableOffer) ~= "table" then
				continue
			end

			local offerId = availableOffer.offerId
			local localizedDescription = availableOffer.localizedDescription

			if not (type(offerId) == "string" and offerId ~= "" and type(localizedDescription) == "string" and localizedDescription ~= "") then
				continue
			end

			local expirationTimeUtc = availableOffer.expirationTimeUtc
			local v7 = {
				offerId = offerId,
				localizedDescription = decodeLuauUnicodeEscapes(localizedDescription),
				selected = availableOffer.selected == true,
				expirationTimeUtc = 0
			}

			if type(expirationTimeUtc) ~= "string" or expirationTimeUtc == "" then
				expirationTimeUtc = nil
			end

			v7.expirationTimeUtc = expirationTimeUtc
			table.insert(cartPricingMarketingOffers, v7)
		end

		return cartPricingMarketingOffers
	end,
	extractDiscountRowsFromLineItems = function(items)
		local discountRowsFromLineItems = {}

		if type(items) ~= "table" then
			return discountRowsFromLineItems
		end

		for k, item in items do
			if type(item) ~= "table" then
				continue
			end

			local discountInformation = item.discountInformation

			if type(discountInformation) ~= "table" then
				continue
			end

			local discounts = discountInformation.discounts

			if type(discounts) ~= "table" then
				continue
			end

			for k2, discount in discounts do
				if type(discount) ~= "table" then
					continue
				end

				local robuxDiscountAmount = discount.robuxDiscountAmount
				local localizedDiscountAttribution = discount.localizedDiscountAttribution

				if
					type(robuxDiscountAmount) ~= "number"
					or robuxDiscountAmount <= 0
					or type(localizedDiscountAttribution) ~= "string"
					or localizedDiscountAttribution == ""
				then
					continue
				end

				local v8 = if discount.discountType == v5.RobloxPlus then discountType.RobloxPlusSubscription else discountType.Uncategorized
				local v7 = {
					type = v8,
					amountInRobux = robuxDiscountAmount,
					percent = 0,
					localizedDiscountAttribution = decodeLuauUnicodeEscapes(localizedDiscountAttribution)
				}
				table.insert(discountRowsFromLineItems, v7)
			end
		end

		return discountRowsFromLineItems
	end,
	consolidateRobloxPlusDiscounts = 0,
	computePriceWithoutOffersDiscounts = 0,
	extractCartPricingSavingsSummary = 0
}

if not require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/SharedFlags").FFlagPurchasePromptFetchCartPricingForLooks then
	consolidateRobloxPlusDiscounts = nil
end

v6.consolidateRobloxPlusDiscounts = consolidateRobloxPlusDiscounts

function v6.computePriceWithoutOffersDiscounts(items, total)
	if type(items) ~= "table" then
		return total
	end

	for k, item in items do
		if type(item) ~= "table" then
			continue
		end

		local discountInformation = item.discountInformation

		if type(discountInformation) ~= "table" then
			continue
		end

		local discounts = discountInformation.discounts

		if type(discounts) ~= "table" then
			continue
		end

		for k2, discount in discounts do
			if type(discount) ~= "table" then
				continue
			end

			local discountType2 = discount.discountType

			if not (discountType2 == v5.MarketplaceOffer or FFlagCartPricingSupportGameItemOffer and discountType2 == v5.Offer) then
				continue
			end

			local robuxDiscountAmount = discount.robuxDiscountAmount

			if type(robuxDiscountAmount) == "number" and robuxDiscountAmount > 0 then
				total += robuxDiscountAmount
			end
		end
	end

	return total
end

function v6.extractCartPricingSavingsSummary(p2)
	if type(p2) ~= "table" then
		return nil
	end

	local savingsSummary = p2.savingsSummary

	if type(savingsSummary) == "string" and savingsSummary ~= "" then
		return decodeLuauUnicodeEscapes(savingsSummary)
	end

	return nil
end
return v6
