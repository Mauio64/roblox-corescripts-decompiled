local IAPExperience = script:FindFirstAncestor("IAPExperience")
local decodeLuauUnicodeEscapes = require(IAPExperience.Utility.decodeLuauUnicodeEscapes)
local FFlagCartPricingSupportGameItemOffer = require(IAPExperience.Flags.FFlagCartPricingSupportGameItemOffer)

local PricingTypes = require(script.Parent.Parent.PricingTypes)

local DiscountType = PricingTypes.DiscountType

local SharedFlags = require(IAPExperience.Parent.SharedFlags)

local v = { RobloxPlus = "ROBLOX_PLUS", MarketplaceOffer = "MARKETPLACE_OFFER", Offer = "OFFER" }

local function mapCartPricingDiscountType(p)
	if p == "ROBLOX_PLUS" then
		return DiscountType.RobloxPlusSubscription
	end

	return DiscountType.Uncategorized
end

local function isOfferDiscountType(p)
	return p == "MARKETPLACE_OFFER" or FFlagCartPricingSupportGameItemOffer and p == "OFFER"
end

local function consolidateRobloxPlusDiscounts(items)
	local v2 = nil
	local result = {}

	for _, item in items do
		if item.type == DiscountType.RobloxPlusSubscription then
			if v2 == nil then
				table.insert(result, {
					type = item.type,
					amountInRobux = item.amountInRobux,
					percent = item.percent,
					localizedDiscountAttribution = item.localizedDiscountAttribution
				})

				v2 = #result
			else
				result[v2].amountInRobux += item.amountInRobux
			end
		else
			table.insert(result, item)
		end
	end

	return result
end

local CartPricingResponseLineItem = {
	getCartLineSalePriceInRobux = function(p)
		if type(p) ~= "table" then
			return nil
		end

		local priceInRobux = p.priceInRobux

		if type(priceInRobux) == "number" and not (priceInRobux < 0) then
			return priceInRobux
		end

		return nil
	end,
	getCartLineRegularPriceInRobux = function(p, p2: number)
		if type(p) == "table" then
			local regularPriceInRobux = p.regularPriceInRobux

			if type(regularPriceInRobux) == "number" and p2 <= regularPriceInRobux then
				return regularPriceInRobux
			end
		end

		return p2
	end,
	extractCartPricingMarketingOffers = function(p)
		local cartPricingMarketingOffers = {}

		if type(p) ~= "table" then
			return cartPricingMarketingOffers
		end

		local availableOffers = p.availableOffers

		if type(availableOffers) ~= "table" then
			return cartPricingMarketingOffers
		end

		for _, availableOffer in availableOffers do
			if type(availableOffer) ~= "table" then
				continue
			end

			local offerId = availableOffer.offerId
			local localizedDescription = availableOffer.localizedDescription

			if not (type(offerId) == "string" and offerId ~= "" and type(localizedDescription) == "string" and localizedDescription ~= "") then
				continue
			end

			local expirationTimeUtc = availableOffer.expirationTimeUtc
			local v2 = {
				offerId = offerId,
				localizedDescription = decodeLuauUnicodeEscapes(localizedDescription),
				selected = availableOffer.selected == true,
				expirationTimeUtc = 0
			}

			if type(expirationTimeUtc) ~= "string" or expirationTimeUtc == "" then
				expirationTimeUtc = nil
			end

			v2.expirationTimeUtc = expirationTimeUtc
			table.insert(cartPricingMarketingOffers, v2)
		end

		return cartPricingMarketingOffers
	end,
	extractDiscountRowsFromLineItems = function(items)
		local discountRowsFromLineItems = {}

		if type(items) ~= "table" then
			return discountRowsFromLineItems
		end

		for _, item in items do
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

			for _, discount in discounts do
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

				local v3

				if discount.discountType == v.RobloxPlus then
					v3 = DiscountType.RobloxPlusSubscription
				else
					v3 = DiscountType.Uncategorized
				end

				local v2 = {
					type = v3,
					amountInRobux = robuxDiscountAmount,
					percent = 0,
					localizedDiscountAttribution = decodeLuauUnicodeEscapes(localizedDiscountAttribution)
				}
				table.insert(discountRowsFromLineItems, v2)
			end
		end

		return discountRowsFromLineItems
	end,
	consolidateRobloxPlusDiscounts = 0,
	computePriceWithoutOffersDiscounts = 0,
	extractCartPricingSavingsSummary = 0
}

if not SharedFlags.FFlagPurchasePromptFetchCartPricingForLooks then
	consolidateRobloxPlusDiscounts = nil
end

CartPricingResponseLineItem.consolidateRobloxPlusDiscounts = consolidateRobloxPlusDiscounts

function CartPricingResponseLineItem.computePriceWithoutOffersDiscounts(items, total: number)
	if type(items) ~= "table" then
		return total
	end

	for _, item in items do
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

		for _, discount in discounts do
			if type(discount) ~= "table" then
				continue
			end

			local discountType = discount.discountType

			if not (discountType == v.MarketplaceOffer or FFlagCartPricingSupportGameItemOffer and discountType == v.Offer) then
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

function CartPricingResponseLineItem.extractCartPricingSavingsSummary(p)
	if type(p) ~= "table" then
		return nil
	end

	local savingsSummary = p.savingsSummary

	if type(savingsSummary) == "string" and savingsSummary ~= "" then
		return decodeLuauUnicodeEscapes(savingsSummary)
	end

	return nil
end
return CartPricingResponseLineItem
