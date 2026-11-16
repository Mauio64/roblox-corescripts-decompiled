local function parseEligibleOffers(eligibleOffers)
	assert(type(eligibleOffers) == "table", "Expected EligibleOffers to be a table")
	local eligibleOffers2 = {}

	for _, item in ipairs(eligibleOffers) do
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

	for _, item in ipairs(list) do
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

local function parseRobloxSubscriptionProductDetails(robloxSubscriptionProductDetails) -- 1 equivalent call inferred from this helper
	assert(type(robloxSubscriptionProductDetails) == "table", "Expected RobloxSubscriptionProductDetails to be a table")
	return {
		FeatureConfig = parseFeatureConfig(robloxSubscriptionProductDetails.FeatureConfig)
	}
end

local function parseProductTypeDetails(productTypeDetails) -- 1 equivalent call inferred from this helper
	assert(type(productTypeDetails) == "table", "Expected ProductTypeDetails to be a table")
	return {
		RobloxSubscriptionProductDetails = parseRobloxSubscriptionProductDetails(productTypeDetails.RobloxSubscriptionProductDetails) -- inferred equivalent call
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

	for _, item in ipairs(eligibleOffers) do
		if type(item) ~= "table" then
			continue
		end

		local freeTrialOffer

		if type(item.freeTrialOffer) == "table" then
			freeTrialOffer = item.freeTrialOffer
		end

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

	for _, item in ipairs(list) do
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
	local v = type(featureConfig) ~= "table" and {} or featureConfig
	return {
		IsRobuxTransferEnabled = v.isRobuxTransferEnabled == true,
		IsTradingEnabled = v.isTradingEnabled == true,
		IsUgcPublishingEnabled = v.isUgcPublishingEnabled == true,
		VirtualTransactionDiscounts = parseDiscountsFromRest(v.virtualTransactionDiscounts),
		PrivateServerDiscounts = parseDiscountsFromRest(v.privateServerDiscounts)
	}
end

local function parseLocalizedPriceFromRest(localizedPrice)
	local v = type(localizedPrice) ~= "table" and {} or localizedPrice
	return {
		CurrencyCode = tostring(v.currencyCode or ""),
		Nanos = tonumber(v.nanos) or 0,
		Units = tonumber(v.units) or 0
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

local GetRobloxSubscriptionProductsModel = {}

function GetRobloxSubscriptionProductsModel.new(p)
	return p
end

function GetRobloxSubscriptionProductsModel.format(list)
	assert(type(list) == "table", "Expected products response to be a table")
	local result = {}

	for _, item in ipairs(list) do
		if type(item) == "table" then
			local v = type(item.PeriodType) == "string" and item.PeriodType ~= ""
			assert(v, "Missing or invalid PeriodType")
			local v2 = {
				EligibleOffers = parseEligibleOffers(item.EligibleOffers),
				LocalizedPrice = parseLocalizedPrice(item.LocalizedPrice),
				LocalizedPriceDisplayString = 0,
				PeriodType = 0,
				ProductKey = 0,
				ProductTypeDetails = 0
			}
			local localizedPriceDisplayString

			if type(item.LocalizedPriceDisplayString) == "string" then
				localizedPriceDisplayString = item.LocalizedPriceDisplayString or nil
			end

			v2.LocalizedPriceDisplayString = localizedPriceDisplayString

			v2.PeriodType = tostring(item.PeriodType)
			v2.ProductKey = parseProductKey(item.ProductKey)
			v2.ProductTypeDetails = parseProductTypeDetails(item.ProductTypeDetails) -- inferred equivalent call

			table.insert(result, GetRobloxSubscriptionProductsModel.new(v2))
		else
			error("Expected each product to be a table")
		end
	end

	return result
end

function GetRobloxSubscriptionProductsModel.formatFromRest(p)
	assert(type(p) == "table", "Expected products response to be a table")
	local products = p.products

	if type(products) ~= "table" then
		return {}
	end

	local result = {}

	for _, product in ipairs(products) do
		if not (type(product) == "table" and type(product.periodType) == "string" and product.periodType ~= "") then
			continue
		end

		local featureConfig = product.productTypeDetails
			and product.productTypeDetails.robloxSubscriptionProductDetails
			and product.productTypeDetails.robloxSubscriptionProductDetails.featureConfig
		local v = {
			EligibleOffers = parseEligibleOffersFromRest(product.eligibleOffers),
			LocalizedPrice = parseLocalizedPriceFromRest(product.localizedPrice),
			LocalizedPriceDisplayString = 0,
			PeriodType = 0,
			ProductKey = 0,
			ProductTypeDetails = 0
		}
		local localizedPriceDisplayString

		if type(product.localizedPriceDisplayString) == "string" then
			localizedPriceDisplayString = product.localizedPriceDisplayString or nil
		end

		v.LocalizedPriceDisplayString = localizedPriceDisplayString

		v.PeriodType = tostring(product.periodType)
		v.ProductKey = parseProductKeyFromRest(product.productKey)
		v.ProductTypeDetails = {
			RobloxSubscriptionProductDetails = {
				FeatureConfig = parseFeatureConfigFromRest(featureConfig)
			}
		}

		table.insert(result, GetRobloxSubscriptionProductsModel.new(v))
	end

	return result
end

function GetRobloxSubscriptionProductsModel.mock(items)
	local v = {
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
			v[k] = item
		end
	end

	return GetRobloxSubscriptionProductsModel.new(v)
end

return GetRobloxSubscriptionProductsModel
