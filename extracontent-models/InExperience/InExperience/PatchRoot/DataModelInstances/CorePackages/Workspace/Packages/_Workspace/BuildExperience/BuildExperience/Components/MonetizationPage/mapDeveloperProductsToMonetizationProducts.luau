local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(parent.DataHydration.DeveloperProduct)

local LocalizationStrings = require(BuildExperience.LocalizationStrings)
require(script.Parent.MonetizationPageView)

local v = {
	formatDefaultProductName = function(p: number)
		return (string.gsub(LocalizationStrings.MONETIZATION_DEFAULT_PRODUCT_NAME, "{PRODUCT_ID}", (tostring(p))))
	end,
	priceUnavailable = LocalizationStrings.MONETIZATION_PRICE_UNAVAILABLE,
	productType = LocalizationStrings.AGENT_DEV_PRODUCT_TITLE,
	onSale = LocalizationStrings.MONETIZATION_ON_SALE,
	offSale = LocalizationStrings.MONETIZATION_OFF_SALE
}

local function hasEnabledFeature(data, p: string): boolean -- 1 equivalent call inferred from this helper
	local priceInformation = data.priceInformation

	if priceInformation == nil then
		return false
	end

	local enabledFeatures = priceInformation.enabledFeatures

	if enabledFeatures == nil then
		return false
	end

	for _, enabledFeature in enabledFeatures do
		if enabledFeature == p then
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

	local v2 = {
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
	local price

	if defaultPriceInRobux == nil then
		price = data.priceUnavailable
	else
		price = tostring(defaultPriceInRobux)
	end

	v2.price = price
	v2.priceInRobux = defaultPriceInRobux
	v2.isForSale = developerProduct.isForSale == true
	v2.isManagedPricingEnabled = developerProduct.isManagedPricingEnabled
	v2.isArchived = developerProduct.isArchived
	v2.isImmutable = developerProduct.isImmutable
	local isInActivePriceOptimizationExperiment
	isInActivePriceOptimizationExperiment = hasEnabledFeature(developerProduct, "PriceOptimization") -- inferred equivalent call
	v2.isInActivePriceOptimizationExperiment = isInActivePriceOptimizationExperiment
	v2.kind = data.productType
	local saleStatus

	if developerProduct.isForSale == true then
		saleStatus = data.onSale
	else
		saleStatus = data.offSale
	end

	v2.saleStatus = saleStatus
	local image

	if developerProduct.iconImageAssetId ~= nil then
		image = `rbxassetid://{developerProduct.iconImageAssetId}`
	end

	v2.image = image
	v2.description = developerProduct.description or ""
	return v2
end

local function mapDeveloperProductsToMonetizationProducts(p, p2)
	local result = {}

	if p == nil then
		return result
	end

	for _, developerProduct in p.developerProducts do
		table.insert(result, mapProduct(developerProduct, p2 or v))
	end

	return result
end

return mapDeveloperProductsToMonetizationProducts
