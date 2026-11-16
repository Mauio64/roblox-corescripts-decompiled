local v5 = {}

function v5.new()
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

function v5.mock(subscriptionProviderId, name)
	local v6 = v5.new()

	v6.name = name
	v6.description = "This is MeepCity"
	v6.iconImageAssetId = 123456
	v6.subscriptionPeriod = "Month"
	v6.priceTier = 299
	v6.displayPrice = "$2.99"
	v6.subscriptionProviderName = "RobloxTest"
	v6.subscriptionProviderId = subscriptionProviderId
	v6.isForSale = true
	v6.subscriptionTargetKey = "EXP-123456"
	return v6
end

function v5.fromJsonData(data)
	local v6 = v5.new()

	v6.name = data.name
	v6.description = data.description
	v6.iconImageAssetId = data.iconImageAssetId
	v6.subscriptionPeriod = data.subscriptionPeriod
	v6.priceTier = data.priceTier
	v6.displayPrice = data.displayPrice
	v6.subscriptionProviderName = data.subscriptionProviderName
	v6.subscriptionProviderId = data.subscriptionProviderId
	v6.isForSale = data.isForSale
	v6.subscriptionTargetKey = data.subscriptionTargetKey
	v6.priceInRobux = data.priceInRobux
	return v6
end

return v5
