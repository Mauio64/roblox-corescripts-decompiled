local function parseEligibleOffers(eligibleOffers)
	assert(type(eligibleOffers) == "table", "Expected EligibleOffers to be a table")
	local eligibleOffers2 = {}

	for i, item in ipairs(eligibleOffers) do
		assert(type(item) == "table", "Expected each EligibleOffer to be a table")

		table.insert(eligibleOffers2, {
			Duration = tonumber(item.Duration) or 0,
			OfferType = tostring(item.OfferType or ""),
			PeriodType = tostring(item.PeriodType or "")
		})
	end

	return eligibleOffers2
end

local function parseRobloxSubscriptionDiscounts(list)
	if type(list) ~= "table" then
		return nil
	end

	local result = {}

	for i, item in ipairs(list) do
		if type(item) == "table" then
			table.insert(result, {
				DiscountPercent = tonumber(item.DiscountPercent) or 0,
				PeriodIndex = tonumber(item.PeriodIndex) or 0,
				TierId = tostring(item.TierId or "")
			})
		end
	end

	return result
end

local function parseFeatureConfig(featureConfig)
	assert(type(featureConfig) == "table", "Expected FeatureConfig to be a table")

	return {
		IsRobuxTransferEnabled = featureConfig.IsRobuxTransferEnabled == true,
		IsTradingEnabled = featureConfig.IsTradingEnabled == true,
		IsUgcPublishingEnabled = featureConfig.IsUgcPublishingEnabled == true,
		VirtualTransactionDiscounts = parseRobloxSubscriptionDiscounts(featureConfig.VirtualTransactionDiscounts),
		PrivateServerDiscounts = parseRobloxSubscriptionDiscounts(featureConfig.PrivateServerDiscounts)
	}
end

local function parseRobloxSubscriptionProductDetails(p2)
	assert(type(p2) == "table", "Expected RobloxSubscriptionProductDetails to be a table")
	return {
		FeatureConfig = parseFeatureConfig(p2.FeatureConfig)
	}
end

local function parseProductTypeDetails(p2)
	assert(type(p2) == "table", "Expected ProductTypeDetails to be a table")

	local robloxSubscriptionProductDetails = p2.RobloxSubscriptionProductDetails
	assert(
		type(robloxSubscriptionProductDetails) == "table",
		"Expected RobloxSubscriptionProductDetails to be a table"
	)
	return {
		RobloxSubscriptionProductDetails = {
			FeatureConfig = parseFeatureConfig(robloxSubscriptionProductDetails.FeatureConfig)
		}
	}
end

local function parseLocalizedPrice(localizedPrice)
	assert(type(localizedPrice) == "table", "Expected LocalizedPrice to be a table")
	return {
		CurrencyCode = tostring(localizedPrice.CurrencyCode or ""),
		Nanos = tonumber(localizedPrice.Nanos) or 0,
		Units = tonumber(localizedPrice.Units) or 0
	}
end

local function parseProductKey(productKey)
	if type(productKey) == "table" then
		return {
			Id = tostring(productKey.Id or ""),
			Type = tostring(productKey.Type or "")
		}
	end

	return { Id = "", Type = "" }
end

local function parseEligibleOffersFromRest(eligibleOffers)
	if type(eligibleOffers) ~= "table" then
		return {}
	end

	local result = {}

	for i, item in ipairs(eligibleOffers) do
		if type(item) ~= "table" then
			continue
		end

		local freeTrialOffer = if type(item.freeTrialOffer) == "table" then item.freeTrialOffer else nil
		table.insert(result, {
			Duration = tonumber(freeTrialOffer and freeTrialOffer.duration) or 0,
			OfferType = tostring(item.offerType or ""),
			PeriodType = tostring(freeTrialOffer and freeTrialOffer.periodType or "")
		})
	end

	return result
end

local function parseDiscountsFromRest(list)
	if type(list) ~= "table" then
		return nil
	end

	local result = {}

	for i, item in ipairs(list) do
		if type(item) == "table" then
			table.insert(result, {
				DiscountPercent = tonumber(item.discountPercent) or 0,
				PeriodIndex = tonumber(item.periodIndex) or 0,
				TierId = tostring(item.tierId or "")
			})
		end
	end

	return result
end

local function parseFeatureConfigFromRest(featureConfig)
	local v5 = type(featureConfig) ~= "table" and {} or featureConfig
	return {
		IsRobuxTransferEnabled = v5.isRobuxTransferEnabled == true,
		IsTradingEnabled = v5.isTradingEnabled == true,
		IsUgcPublishingEnabled = v5.isUgcPublishingEnabled == true,
		VirtualTransactionDiscounts = parseDiscountsFromRest(v5.virtualTransactionDiscounts),
		PrivateServerDiscounts = parseDiscountsFromRest(v5.privateServerDiscounts)
	}
end

local function parseLocalizedPriceFromRest(localizedPrice)
	local v5 = type(localizedPrice) ~= "table" and {} or localizedPrice
	return {
		CurrencyCode = tostring(v5.currencyCode or ""),
		Nanos = tonumber(v5.nanos) or 0,
		Units = tonumber(v5.units) or 0
	}
end

local function parseProductKeyFromRest(productKey)
	if type(productKey) == "table" then
		return {
			Id = tostring(productKey.id or ""),
			Type = tostring(productKey.type or "")
		}
	end

	return { Id = "", Type = "" }
end

local v5 = {}

function v5.new(p2)
	return p2
end

function v5.format(list)
	assert(type(list) == "table", "Expected products response to be a table")
	local result = {}

	for i, item in ipairs(list) do
		if type(item) == "table" then
			local v6 = type(item.PeriodType) == "string" and item.PeriodType ~= ""
			assert(v6, "Missing or invalid PeriodType")
			local v7 = {
				EligibleOffers = parseEligibleOffers(item.EligibleOffers),
				LocalizedPrice = parseLocalizedPrice(item.LocalizedPrice),
				LocalizedPriceDisplayString = 0,
				PeriodType = 0,
				ProductKey = 0,
				ProductTypeDetails = 0
			}
			local v8 = if type(item.LocalizedPriceDisplayString) == "string" then item.LocalizedPriceDisplayString or nil else nil
			v7.LocalizedPriceDisplayString = v8

			v7.PeriodType = tostring(item.PeriodType)
			v7.ProductKey = parseProductKey(item.ProductKey)
			local productTypeDetails = item.ProductTypeDetails
			assert(type(productTypeDetails) == "table", "Expected ProductTypeDetails to be a table")

			local robloxSubscriptionProductDetails = productTypeDetails.RobloxSubscriptionProductDetails
			assert(
				type(robloxSubscriptionProductDetails) == "table",
				"Expected RobloxSubscriptionProductDetails to be a table"
			)
			v7.ProductTypeDetails = {
				RobloxSubscriptionProductDetails = {
					FeatureConfig = parseFeatureConfig(robloxSubscriptionProductDetails.FeatureConfig)
				}
			}

			table.insert(result, v5.new(v7))
		else
			error("Expected each product to be a table")
		end
	end

	return result
end

function v5.formatFromRest(p2)
	assert(type(p2) == "table", "Expected products response to be a table")
	local products = p2.products

	if type(products) ~= "table" then
		return {}
	end

	local result = {}

	for i, product in ipairs(products) do
		if not (type(product) == "table" and type(product.periodType) == "string" and product.periodType ~= "") then
			continue
		end

		local featureConfig = product.productTypeDetails
			and product.productTypeDetails.robloxSubscriptionProductDetails
			and product.productTypeDetails.robloxSubscriptionProductDetails.featureConfig
		local v6 = {
			EligibleOffers = parseEligibleOffersFromRest(product.eligibleOffers),
			LocalizedPrice = parseLocalizedPriceFromRest(product.localizedPrice),
			LocalizedPriceDisplayString = 0,
			PeriodType = 0,
			ProductKey = 0,
			ProductTypeDetails = 0
		}
		local v7 = if type(product.localizedPriceDisplayString) == "string" then product.localizedPriceDisplayString or nil else nil
		v6.LocalizedPriceDisplayString = v7

		v6.PeriodType = tostring(product.periodType)
		v6.ProductKey = parseProductKeyFromRest(product.productKey)
		v6.ProductTypeDetails = {
			RobloxSubscriptionProductDetails = {
				FeatureConfig = parseFeatureConfigFromRest(featureConfig)
			}
		}

		table.insert(result, v5.new(v6))
	end

	return result
end

function v5.mock(items)
	local v6 = {
		EligibleOffers = {
			{ Duration = 1, OfferType = "FreeTrial", PeriodType = "Month" }
		},
		LocalizedPrice = { CurrencyCode = "USD", Nanos = 990000000, Units = 12 },
		LocalizedPriceDisplayString = "$12.99",
		PeriodType = "Month",
		ProductKey = { Id = "8429606799668938154", Type = "Blackbird" },
		ProductTypeDetails = {
			RobloxSubscriptionProductDetails = {
				FeatureConfig = {
					IsRobuxTransferEnabled = true,
					IsTradingEnabled = true,
					IsUgcPublishingEnabled = true,
					VirtualTransactionDiscounts = {
						{ DiscountPercent = 1, PeriodIndex = 0, TierId = "percent_1" },
						{ DiscountPercent = 50, PeriodIndex = 2, TierId = "percent_50" }
					},
					PrivateServerDiscounts = {
						{ DiscountPercent = 100, PeriodIndex = 0, TierId = "free" }
					}
				}
			}
		}
	}

	if type(items) == "table" then
		for k, item in pairs(items) do
			v6[k] = item
		end
	end

	return v5.new(v6)
end

return v5
