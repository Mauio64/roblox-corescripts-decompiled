local IAPExperience = script:FindFirstAncestor("IAPExperience")
local decodeLuauUnicodeEscapes = require(IAPExperience.Utility.decodeLuauUnicodeEscapes)
local DiscountType = require(script.Parent.Parent.PricingTypes).DiscountType

local function mapCartPricingDiscountType(p1) -- line: 125
	-- upvalues: DiscountType (copy)
	if p1 == "ROBLOX_PLUS" then
		return DiscountType.RobloxPlusSubscription
	end

	return DiscountType.Uncategorized
end

return {
	getCartLineSalePriceInRobux = function(t1: {[any]: any}?) -- line: 74
		if type(t1) ~= "table" then
			return nil
		end

		local priceInRobux = t1.priceInRobux

		if type(priceInRobux) ~= "number" or priceInRobux < 0 then
			return nil
		end

		return priceInRobux
	end,
	getCartLineRegularPriceInRobux = function(t2: {[any]: any}?, n1: number) -- line: 85
		if type(t2) == "table" then
			local regularPriceInRobux = t2.regularPriceInRobux

			if type(regularPriceInRobux) == "number" and n1 <= regularPriceInRobux then
				return regularPriceInRobux
			end
		end

		return n1
	end,
	extractCartPricingMarketingOffers = function(t3: {[any]: any}?) -- line: 95
		-- upvalues: decodeLuauUnicodeEscapes (copy)
		local t4 = {}

		if type(t3) ~= "table" then
			return t4
		end

		local availableOffers = t3.availableOffers

		if type(availableOffers) ~= "table" then
			return t4
		end

		for _, v14 in availableOffers do
			if type(v14) == "table" then
				local offerId = v14.offerId
				local localizedDescription = v14.localizedDescription

				if type(offerId) == "string" and offerId ~= "" and type(localizedDescription) == "string" and localizedDescription ~= "" then
					table.insert(t4, {
						offerId = offerId,
						localizedDescription = decodeLuauUnicodeEscapes(localizedDescription),
						selected = v14.selected == true
					})
				end
			end
		end

		return t4
	end,
	extractDiscountRowsFromLineItems = function(t5: {[any]: any}?) -- line: 139
		-- upvalues: DiscountType (copy), decodeLuauUnicodeEscapes (copy)
		local t6 = {}

		if type(t5) ~= "table" then
			return t6
		end

		for _, v21 in t5 do
			if type(v21) == "table" then
				local discountInformation = v21.discountInformation

				if type(discountInformation) == "table" then
					local discounts = discountInformation.discounts

					if type(discounts) == "table" then
						for _, v25 in discounts do
							if type(v25) == "table" then
								local robuxDiscountAmount = v25.robuxDiscountAmount
								local localizedDiscountAttribution = v25.localizedDiscountAttribution

								if type(robuxDiscountAmount) == "number" and not (robuxDiscountAmount <= 0) and type(localizedDiscountAttribution) == "string" and localizedDiscountAttribution ~= "" then
									table.insert(t6, {
										percent = 0,
										type = if v25.discountType ~= "ROBLOX_PLUS" then DiscountType.Uncategorized else DiscountType.RobloxPlusSubscription,
										amountInRobux = robuxDiscountAmount,
										localizedDiscountAttribution = decodeLuauUnicodeEscapes(localizedDiscountAttribution)
									})
								end
							end
						end
					end
				end
			end
		end

		return t6
	end,
	extractCartPricingSavingsSummary = function(t7: {[any]: any}?) -- line: 184
		-- upvalues: decodeLuauUnicodeEscapes (copy)
		if type(t7) ~= "table" then
			return nil
		end

		local savingsSummary = t7.savingsSummary

		if type(savingsSummary) ~= "string" or savingsSummary == "" then
			return nil
		end

		return decodeLuauUnicodeEscapes(savingsSummary)
	end
}
