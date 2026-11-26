require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/DeveloperProduct")
local DeveloperSubscription = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/DeveloperSubscription")
local GamePassConfig = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration/GamePassConfig")

local FFlagBuildExperienceMonetizationKindRegionalPricing = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Flags/FFlagBuildExperienceMonetizationKindRegionalPricing")
require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MonetizationPage/MonetizationPageView")
local mapDeveloperProductsToMonetizationProducts = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/BuildExperience/Components/MonetizationPage/mapDeveloperProductsToMonetizationProducts")

local currencyType = DeveloperSubscription.CurrencyType
local productStatusType = DeveloperSubscription.ProductStatusType

local function identity(p2, p3)
	return `{p2}:{p3}`
end

local function robuxPrice(p2, p3)
	if p2 ~= nil then
		p3 = tostring(p2)
	end

	return p3, p2 ~= nil
end

local function mapGamePasses(gamePasses, data, list)
	if gamePasses == nil then
		return
	end

	for k, gamePass in gamePasses.gamePasses do
		local gamePassId = tostring(gamePass.gamePassId)
		local defaultPriceInRobux

		if gamePass.priceInformation ~= nil then
			defaultPriceInRobux = gamePass.priceInformation.defaultPriceInRobux
		end

		local v5 = data.priceUnavailable

		if defaultPriceInRobux ~= nil then
			v5 = tostring(defaultPriceInRobux)
		end

		local v6 = defaultPriceInRobux ~= nil
		local v7 = {
			id = gamePassId,
			identity = `GamePass:{gamePassId}`,
			productKind = "GamePass",
			canManage = false,
			name = gamePass.name or data.gamePassType,
			price = v5,
			priceInRobux = defaultPriceInRobux,
			showRobuxIcon = v6,
			isForSale = gamePass.isForSale == true,
			isManagedPricingEnabled = 0,
			isArchived = 0,
			kind = 0,
			saleStatus = 0,
			image = 0,
			description = 0
		}

		local v8 = if FFlagBuildExperienceMonetizationKindRegionalPricing then GamePassConfig.isManagedPricingEnabled(gamePass) == true else nil
		v7.isManagedPricingEnabled = v8

		v7.isArchived = gamePass.isArchived
		v7.kind = data.gamePassType
		local v9 = if gamePass.isForSale == true then data.onSale else data.offSale
		v7.saleStatus = v9
		local v10 = if gamePass.iconAssetId ~= nil then `rbxassetid://{gamePass.iconAssetId}` else nil
		v7.image = v10
		v7.description = gamePass.description or ""
		table.insert(list, v7)
	end
end

local function mapSubscriptions(subscriptions, data, list)
	if subscriptions == nil then
		return
	end

	for k, developerSubscription in subscriptions.developerSubscriptions do
		local priceInRobux

		if developerSubscription.currencyType == currencyType.Robux then
			priceInRobux = developerSubscription.priceInRobux
		end

		local v5 = data.priceUnavailable

		if priceInRobux ~= nil then
			v5 = tostring(priceInRobux)
		end

		local v6 = priceInRobux ~= nil
		local v7

		if developerSubscription.productStatusType ~= nil then
			v7 = developerSubscription.productStatusType == productStatusType.Active
		end

		local v8 = {
			id = developerSubscription.id,
			identity = `Subscription:{developerSubscription.id}`,
			productKind = "Subscription",
			canManage = false,
			name = developerSubscription.name or data.subscriptionType,
			price = v5,
			priceInRobux = priceInRobux,
			showRobuxIcon = v6,
			isForSale = v7,
			isImmutable = developerSubscription.productStatusType == productStatusType.ToBeActivated or developerSubscription.productStatusType == productStatusType.ToBeDeactivated,
			kind = data.subscriptionType,
			saleStatus = 0,
			image = 0,
			description = 0
		}
		local v9 = if v7 ~= nil then (if v7 then data.onSale else data.offSale) else nil
		v8.saleStatus = v9
		local v10 = if developerSubscription.imageAssetId ~= nil then `rbxassetid://{developerSubscription.imageAssetId}` else nil
		v8.image = v10
		v8.description = developerSubscription.description or ""
		table.insert(list, v8)
	end
end

local function mapMonetizationCatalog(data, data2)
	local v5 = mapDeveloperProductsToMonetizationProducts(data.developerProducts, {
		formatDefaultProductName = data2.formatDefaultProductName,
		priceUnavailable = data2.priceUnavailable,
		productType = data2.developerProductType,
		onSale = data2.onSale,
		offSale = data2.offSale
	})

	for k, v6 in v5 do
		v6.identity = `DeveloperProduct:{v6.id}`
		v6.productKind = "DeveloperProduct"
		v6.canManage = true
		v6.showRobuxIcon = v6.priceInRobux ~= nil
	end

	mapGamePasses(data.gamePasses, data2, v5)
	mapSubscriptions(data.subscriptions, data2, v5)
	return v5
end

return mapMonetizationCatalog
