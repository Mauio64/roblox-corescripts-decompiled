local t1 = {
	new = function() -- line: 17
		return {
			name = "",
			description = "",
			iconImageAssetId = 0,
			subscriptionPeriod = "",
			priceTier = 0,
			displayPrice = "",
			subscriptionProviderName = "",
			subscriptionProviderId = "",
			isForSale = false,
			subscriptionTargetKey = "",
			priceInRobux = nil
		}
	end
}

function t1.mock(p1, p2) -- line: 35
	-- upvalues: t1 (copy)
	local v4 = t1.new()

	v4.name = p2
	v4.description = "This is MeepCity"
	v4.iconImageAssetId = 123456
	v4.subscriptionPeriod = "Month"
	v4.priceTier = 299
	v4.displayPrice = "$2.99"
	v4.subscriptionProviderName = "RobloxTest"
	v4.subscriptionProviderId = p1
	v4.isForSale = true
	v4.subscriptionTargetKey = "EXP-123456"

	return v4
end
function t1.fromJsonData(p3) -- line: 51
	-- upvalues: t1 (copy)
	local v6 = t1.new()

	v6.name = p3.name
	v6.description = p3.description
	v6.iconImageAssetId = p3.iconImageAssetId
	v6.subscriptionPeriod = p3.subscriptionPeriod
	v6.priceTier = p3.priceTier
	v6.displayPrice = p3.displayPrice
	v6.subscriptionProviderName = p3.subscriptionProviderName
	v6.subscriptionProviderId = p3.subscriptionProviderId
	v6.isForSale = p3.isForSale
	v6.subscriptionTargetKey = p3.subscriptionTargetKey
	v6.priceInRobux = p3.priceInRobux

	return v6
end

return t1
