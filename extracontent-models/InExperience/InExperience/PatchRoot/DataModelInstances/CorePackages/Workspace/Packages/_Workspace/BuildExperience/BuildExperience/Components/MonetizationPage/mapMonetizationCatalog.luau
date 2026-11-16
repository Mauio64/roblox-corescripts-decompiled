local BuildExperience = script:FindFirstAncestor("BuildExperience")
local parent = BuildExperience.Parent

require(parent.DataHydration.DeveloperProduct)
local DeveloperSubscription = require(parent.DataHydration.DeveloperSubscription)
local GamePassConfig = require(parent.DataHydration.GamePassConfig)

local FFlagBuildExperienceMonetizationKindRegionalPricing = require(BuildExperience.Flags.FFlagBuildExperienceMonetizationKindRegionalPricing)
require(script.Parent.MonetizationPageView)
local mapDeveloperProductsToMonetizationProducts = require(script.Parent.mapDeveloperProductsToMonetizationProducts)

local CurrencyType = DeveloperSubscription.CurrencyType
local ProductStatusType = DeveloperSubscription.ProductStatusType

local function identity(p, p2: string)
	return `{p}:{p2}`
end

local function robuxPrice(p: number?, p2: string)
	if p ~= nil then
		p2 = tostring(p)
	end

	return p2, p ~= nil
end

local function mapGamePasses(gamePasses, data, list)
	if gamePasses == nil then
		return
	end

	for _, gamePass in gamePasses.gamePasses do
		local gamePassId = tostring(gamePass.gamePassId)
		local defaultPriceInRobux

		if gamePass.priceInformation ~= nil then
			defaultPriceInRobux = gamePass.priceInformation.defaultPriceInRobux
		end

		local price = data.priceUnavailable

		if defaultPriceInRobux ~= nil then
			price = tostring(defaultPriceInRobux)
		end

		local showRobuxIcon = defaultPriceInRobux ~= nil
		local v = {
			id = gamePassId,
			identity = `GamePass:{gamePassId}`,
			productKind = "GamePass",
			canManage = false,
			name = gamePass.name or data.gamePassType,
			price = price,
			priceInRobux = defaultPriceInRobux,
			showRobuxIcon = showRobuxIcon,
			isForSale = gamePass.isForSale == true,
			isManagedPricingEnabled = 0,
			isArchived = 0,
			kind = 0,
			saleStatus = 0,
			image = 0,
			description = 0
		}
		local isManagedPricingEnabled

		if FFlagBuildExperienceMonetizationKindRegionalPricing then
			isManagedPricingEnabled = GamePassConfig.isManagedPricingEnabled(gamePass) == true
		end

		v.isManagedPricingEnabled = isManagedPricingEnabled

		v.isArchived = gamePass.isArchived
		v.kind = data.gamePassType
		local saleStatus

		if gamePass.isForSale == true then
			saleStatus = data.onSale
		else
			saleStatus = data.offSale
		end

		v.saleStatus = saleStatus
		local image

		if gamePass.iconAssetId ~= nil then
			image = `rbxassetid://{gamePass.iconAssetId}`
		end

		v.image = image
		v.description = gamePass.description or ""
		table.insert(list, v)
	end
end

local function mapSubscriptions(subscriptions, data, list)
	if subscriptions == nil then
		return
	end

	for _, developerSubscription in subscriptions.developerSubscriptions do
		local priceInRobux

		if developerSubscription.currencyType == CurrencyType.Robux then
			priceInRobux = developerSubscription.priceInRobux
		end

		local price = data.priceUnavailable

		if priceInRobux ~= nil then
			price = tostring(priceInRobux)
		end

		local showRobuxIcon = priceInRobux ~= nil
		local isForSale

		if developerSubscription.productStatusType ~= nil then
			isForSale = developerSubscription.productStatusType == ProductStatusType.Active
		end

		local v = {
			id = developerSubscription.id,
			identity = `Subscription:{developerSubscription.id}`,
			productKind = "Subscription",
			canManage = false,
			name = developerSubscription.name or data.subscriptionType,
			price = price,
			priceInRobux = priceInRobux,
			showRobuxIcon = showRobuxIcon,
			isForSale = isForSale,
			isImmutable = developerSubscription.productStatusType == ProductStatusType.ToBeActivated or developerSubscription.productStatusType == ProductStatusType.ToBeDeactivated,
			kind = data.subscriptionType,
			saleStatus = 0,
			image = 0,
			description = 0
		}
		local saleStatus

		if isForSale ~= nil then
			saleStatus = if isForSale then data.onSale else data.offSale
		end

		v.saleStatus = saleStatus
		local image

		if developerSubscription.imageAssetId ~= nil then
			image = `rbxassetid://{developerSubscription.imageAssetId}`
		end

		v.image = image
		v.description = developerSubscription.description or ""
		table.insert(list, v)
	end
end

local function mapMonetizationCatalog(data, data2)
	local v = mapDeveloperProductsToMonetizationProducts(data.developerProducts, {
		formatDefaultProductName = data2.formatDefaultProductName,
		priceUnavailable = data2.priceUnavailable,
		productType = data2.developerProductType,
		onSale = data2.onSale,
		offSale = data2.offSale
	})

	for _, v2 in v do
		v2.identity = `DeveloperProduct:{v2.id}`
		v2.productKind = "DeveloperProduct"
		v2.canManage = true
		v2.showRobuxIcon = v2.priceInRobux ~= nil
	end

	mapGamePasses(data.gamePasses, data2, v)
	mapSubscriptions(data.subscriptions, data2, v)
	return v
end

return mapMonetizationCatalog
