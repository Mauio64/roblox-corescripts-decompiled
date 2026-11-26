require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/DeveloperProduct")

local LocalizationStrings = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/LocalizationStrings")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MonetizationPage/MonetizationPageView")

local v5 = {
	formatDefaultProductName = function(p2)
		return (string.gsub(LocalizationStrings.MONETIZATION_DEFAULT_PRODUCT_NAME, "{PRODUCT_ID}", (tostring(p2))))
	end,
	priceUnavailable = LocalizationStrings.MONETIZATION_PRICE_UNAVAILABLE,
	productType = LocalizationStrings.AGENT_DEV_PRODUCT_TITLE,
	onSale = LocalizationStrings.MONETIZATION_ON_SALE,
	offSale = LocalizationStrings.MONETIZATION_OFF_SALE
}

local function hasEnabledFeature(p2, p3): boolean
	local priceInformation = p2.priceInformation

	if priceInformation == nil then
		return false
	end

	local enabledFeatures = priceInformation.enabledFeatures

	if enabledFeatures == nil then
		return false
	end

	for k, enabledFeature in enabledFeatures do
		if enabledFeature == p3 then
			return true
		end
	end

	return false
end

local function mapProduct(developerProduct, data)
	local defaultPriceInRobux

	if developerProduct.priceInformation ~= nil then
		defaultPriceInRobux = developerProduct.priceInformation.defaultPriceInRobux
	end

	local v6 = {
		id = tostring(developerProduct.productId),
		name = developerProduct.name or data.formatDefaultProductName(developerProduct.productId),
		price = 0,
		priceInRobux = 0,
		isForSale = 0,
		isManagedPricingEnabled = 0,
		isArchived = 0,
		isImmutable = 0,
		isInActivePriceOptimizationExperiment = 0,
		kind = 0,
		saleStatus = 0,
		image = 0,
		description = 0
	}
	local v7 = if defaultPriceInRobux == nil then data.priceUnavailable else tostring(defaultPriceInRobux)
	v6.price = v7
	v6.priceInRobux = defaultPriceInRobux
	v6.isForSale = developerProduct.isForSale == true
	v6.isManagedPricingEnabled = developerProduct.isManagedPricingEnabled
	v6.isArchived = developerProduct.isArchived
	v6.isImmutable = developerProduct.isImmutable
	local priceInformation = developerProduct.priceInformation
	local v8

	if priceInformation == nil then
		v8 = false
	else
		local enabledFeatures = priceInformation.enabledFeatures

		if enabledFeatures == nil then
			v8 = false
		else
			local flag = true

			for k, enabledFeature in enabledFeatures do
				if enabledFeature == "PriceOptimization" then
					v8 = true
					flag = false
					break
				end
			end

			if flag then
				v8 = false
			end
		end
	end

	v6.isInActivePriceOptimizationExperiment = v8
	v6.kind = data.productType
	local v9 = if developerProduct.isForSale == true then data.onSale else data.offSale
	v6.saleStatus = v9
	local v10 = if developerProduct.iconImageAssetId ~= nil then `rbxassetid://{developerProduct.iconImageAssetId}` else nil
	v6.image = v10
	v6.description = developerProduct.description or ""
	return v6
end

local function mapDeveloperProductsToMonetizationProducts(p2, p3)
	local result = {}

	if p2 == nil then
		return result
	end

	for k, developerProduct in p2.developerProducts do
		table.insert(result, mapProduct(developerProduct, p3 or v5))
	end

	return result
end

return mapDeveloperProductsToMonetizationProducts
