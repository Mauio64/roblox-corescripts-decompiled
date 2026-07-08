local function parseEligibleOffers(p1) -- line: 51
	assert(type(p1) == "table", "Expected EligibleOffers to be a table")

	local t1 = {}

	for _, v in ipairs(p1) do
		assert(type(v) == "table", "Expected each EligibleOffer to be a table")
		table.insert(t1, {
			Duration = tonumber(v.Duration) or 0,
			OfferType = tostring(v.OfferType or ""),
			PeriodType = tostring(v.PeriodType or "")
		})
	end

	return t1
end
local function parseRobloxSubscriptionDiscounts(p2) -- line: 65
	if type(p2) ~= "table" then
		return nil
	end

	local t2 = {}

	for _, v in ipairs(p2) do
		if type(v) == "table" then
			table.insert(t2, {
				DiscountPercent = tonumber(v.DiscountPercent) or 0,
				PeriodIndex = tonumber(v.PeriodIndex) or 0,
				TierId = tostring(v.TierId or "")
			})
		end
	end

	return t2
end
local function parseFeatureConfig(p3) -- line: 82
	-- upvalues: parseRobloxSubscriptionDiscounts (copy)
	assert(type(p3) == "table", "Expected FeatureConfig to be a table")

	return {
		IsRobuxTransferEnabled = p3.IsRobuxTransferEnabled == true,
		IsTradingEnabled = p3.IsTradingEnabled == true,
		IsUgcPublishingEnabled = p3.IsUgcPublishingEnabled == true,
		VirtualTransactionDiscounts = parseRobloxSubscriptionDiscounts(p3.VirtualTransactionDiscounts),
		PrivateServerDiscounts = parseRobloxSubscriptionDiscounts(p3.PrivateServerDiscounts)
	}
end
local function parseRobloxSubscriptionProductDetails(p4) -- line: 94
	-- upvalues: parseFeatureConfig (copy)
	assert(type(p4) == "table", "Expected RobloxSubscriptionProductDetails to be a table")

	return {
		FeatureConfig = parseFeatureConfig(p4.FeatureConfig)
	}
end
local function parseProductTypeDetails(p5) -- line: 101
	-- upvalues: parseFeatureConfig (copy)
	assert(type(p5) == "table", "Expected ProductTypeDetails to be a table")

	local t3 = {}
	local RobloxSubscriptionProductDetails = p5.RobloxSubscriptionProductDetails

	assert(type(RobloxSubscriptionProductDetails) == "table", "Expected RobloxSubscriptionProductDetails to be a table")
	t3.RobloxSubscriptionProductDetails = {
		FeatureConfig = parseFeatureConfig(RobloxSubscriptionProductDetails.FeatureConfig)
	}

	return t3
end
local function parseLocalizedPrice(p6) -- line: 108
	assert(type(p6) == "table", "Expected LocalizedPrice to be a table")

	return {
		CurrencyCode = tostring(p6.CurrencyCode or ""),
		Nanos = tonumber(p6.Nanos) or 0,
		Units = tonumber(p6.Units) or 0
	}
end
local function parseProductKey(p7) -- line: 117
	if type(p7) ~= "table" then
		return {
			Id = "",
			Type = ""
		}
	end

	return {
		Id = tostring(p7.Id or ""),
		Type = tostring(p7.Type or "")
	}
end

local t5 = {
	new = function(t4: {[any]: any}) -- line: 129
		return t4
	end
}

function t5.format(p8) -- line: 134
	-- upvalues: parseEligibleOffers (copy), parseLocalizedPrice (copy), parseProductKey (copy), parseFeatureConfig (copy), t5 (copy)
	assert(type(p8) == "table", "Expected products response to be a table")

	local t6 = {}

	for _, v in ipairs(p8) do
		if type(v) == "table" then
			assert(type(v.PeriodType) == "string" and v.PeriodType ~= "", "Missing or invalid PeriodType")

			local t7 = {
				EligibleOffers = parseEligibleOffers(v.EligibleOffers),
				LocalizedPrice = parseLocalizedPrice(v.LocalizedPrice),
				LocalizedPriceDisplayString = type(v.LocalizedPriceDisplayString) == "string" and v.LocalizedPriceDisplayString or nil,
				PeriodType = tostring(v.PeriodType),
				ProductKey = parseProductKey(v.ProductKey)
			}
			local ProductTypeDetails = v.ProductTypeDetails

			assert(type(ProductTypeDetails) == "table", "Expected ProductTypeDetails to be a table")

			local t8 = {}
			local RobloxSubscriptionProductDetails = ProductTypeDetails.RobloxSubscriptionProductDetails

			assert(type(RobloxSubscriptionProductDetails) == "table", "Expected RobloxSubscriptionProductDetails to be a table")
			t8.RobloxSubscriptionProductDetails = {
				FeatureConfig = parseFeatureConfig(RobloxSubscriptionProductDetails.FeatureConfig)
			}
			t7.ProductTypeDetails = t8
			table.insert(t6, t5.new(t7))
		else
			error("Expected each product to be a table")
		end
	end

	return t6
end
function t5.mock(t9: {[any]: any}?) -- line: 158
	-- upvalues: t5 (copy)
	local t10 = {
		LocalizedPriceDisplayString = "$12.99",
		PeriodType = "Month",
		EligibleOffers = {{
			Duration = 1,
			OfferType = "FreeTrial",
			PeriodType = "Month"
		}},
		LocalizedPrice = {
			CurrencyCode = "USD",
			Nanos = 990000000,
			Units = 12
		},
		ProductKey = {
			Id = "8429606799668938154",
			Type = "Blackbird"
		},
		ProductTypeDetails = {
			RobloxSubscriptionProductDetails = {
				FeatureConfig = {
					IsRobuxTransferEnabled = true,
					IsTradingEnabled = true,
					IsUgcPublishingEnabled = true,
					VirtualTransactionDiscounts = {
						{
							DiscountPercent = 1,
							PeriodIndex = 0,
							TierId = "percent_1"
						},
						{
							DiscountPercent = 50,
							PeriodIndex = 2,
							TierId = "percent_50"
						}
					},
					PrivateServerDiscounts = {{
						DiscountPercent = 100,
						PeriodIndex = 0,
						TierId = "free"
					}}
				}
			}
		}
	}

	if type(t9) == "table" then
		for k, v in pairs(t9) do
			t10[k] = v
		end
	end

	return t5.new(t10)
end

return t5
