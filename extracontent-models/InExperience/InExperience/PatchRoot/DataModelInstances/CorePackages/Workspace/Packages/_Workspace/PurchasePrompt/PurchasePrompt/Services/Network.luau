local PurchasePrompt = script:FindFirstAncestor("PurchasePrompt")
local parent = PurchasePrompt.Parent
local HttpService = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")
local MarketplaceService = game:GetService("MarketplaceService")
local InsertService = game:GetService("InsertService")
local Players = game:GetService("Players")
local CreatorStoreService = game:GetService("CreatorStoreService")

local PurchasePromptDeps = require(parent.PurchasePromptDeps)
local UrlBuilder = PurchasePromptDeps.UrlBuilder.UrlBuilder

local Promise = require(PurchasePrompt.Promise)
require(PurchasePrompt.types)
local debugLog = require(PurchasePrompt.Utils.debugLog)
local serializeTable = require(PurchasePrompt.Utils.serializeTable)
local isGenericChallengeResponse = require(PurchasePrompt.Utils.isGenericChallengeResponse)
local isGetPassOwnershipApiEnabled = require(PurchasePrompt.Utils.isGetPassOwnershipApiEnabled)

local engineFeature = game:GetEngineFeature("EnablePlayerOwnsBundleApi")
local engineFeature2 = game:GetEngineFeature("EnableDevSubscriptionPurchaseWithRobux")
local GetFFlagEnablePromptPurchaseRequestedV2 = require(PurchasePrompt.Flags.GetFFlagEnablePromptPurchaseRequestedV2)
local GetFFlagEnablePromptPurchaseRequestedV2Take2 = require(PurchasePrompt.Flags.GetFFlagEnablePromptPurchaseRequestedV2Take2)
local GetFFlagEnableCreatorStorePurchasingCutover = require(PurchasePrompt.Flags.GetFFlagEnableCreatorStorePurchasingCutover)
local SharedFlags = require(parent.SharedFlags)
local FFlagEnableUnifiedPurchaseFlowForDevSubs = SharedFlags.FFlagEnableUnifiedPurchaseFlowForDevSubs

local FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell = require(PurchasePrompt.Flags.FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell)
local FFlagEnableRequestLocationTypeForSduiPurchase = require(PurchasePrompt.Flags.FFlagEnableRequestLocationTypeForSduiPurchase)

local SharedFlags2 = require(parent.SharedFlags)
local FFlagUseGetGamePassOwnershipApi = SharedFlags2.FFlagUseGetGamePassOwnershipApi

local FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = SharedFlags2.FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
local FFlagEnablePurchasePayloadInExperienceShop = SharedFlags2.FFlagEnablePurchasePayloadInExperienceShop
local FFlagEnableMarketplacePurchaseDeepLinkAttribution = SharedFlags2.FFlagEnableMarketplacePurchaseDeepLinkAttribution
local FFlagRefreshPriceOnRetryAfterUpsell = require(PurchasePrompt.Flags.FFlagRefreshPriceOnRetryAfterUpsell)
local FFlagPurchasePromptFetchCartPricingForLooks = SharedFlags2.FFlagPurchasePromptFetchCartPricingForLooks
local FFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags2.FFlagLuaAppsEnablePromptVIPServerPurchase

local v = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")
local v2 = string.gsub(v, "http:", "https:")

string.gsub(v2, "https://www", "https://api")
local v3 = string.gsub(v2, "https://www", "https://apis")
local v4 = string.gsub(v2, "https://www", "https://games")
local v5 = string.gsub(v2, "https://www", "https://abtesting")
local v6 = string.gsub(v2, "https://www.", "https://catalog.")
local v7 = string.gsub(v2, "https://www.", "https://economy.")
local v8 = string.gsub(v2, "https://www", "https://users")

local function request(p, callback, callback2)
	debugLog(function()
		return "Request " .. p.Url .. "\n" .. serializeTable(p)
	end)

	return HttpService:RequestInternal(p):Start(function(p2, p3)
		debugLog(function()
			return "Response " .. p.Url .. "\n" .. serializeTable(p3)
		end)

		if not p2 then
			callback2((tostring(p3.StatusMessage)))

			return
		end

		local success, result = pcall(HttpService.JSONDecode, HttpService, p3.Body)

		if success then
			callback(result)
		else
			callback2("Could not parse JSON.")
		end
	end)
end

local function getABTestGroup(subjectTargetId, experimentName)
	local v9 = {
		{ ExperimentName = experimentName, SubjectType = 1, SubjectTargetId = subjectTargetId }
	}

	return Promise.new(function(p, p2)
		return request({
			Url = v5 .. "v1/get-enrollments",
			Method = "POST",
			Body = HttpService:JSONEncode(v9),
			Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
		}, p, p2)
	end)
end

local function getProductInfo(p, p2)
	return MarketplaceService:GetProductInfoAsync(p, p2)
end

local function getSubscriptionProductInfo(p)
	return MarketplaceService:GetSubscriptionProductInfoAsync(p)
end

local function getPlayerOwns(p, p2, p3)
	if p3 == Enum.InfoType.Asset then
		return MarketplaceService:PlayerOwnsAssetAsync(p, p2)
	end

	if engineFeature and p3 == Enum.InfoType.Bundle then
		return MarketplaceService:PlayerOwnsBundleAsync(p, p2)
	end

	if p3 == Enum.InfoType.GamePass then
		if FFlagUseGetGamePassOwnershipApi then
			local success, result = pcall(function()
				return MarketplaceService:GetPassOwnershipAsync(p, p2)
			end)

			if success then
				return typeof(result) == "table" and result.Owned == true
			elseif isGetPassOwnershipApiEnabled() then
				error(result, 0)
			end
		end

		return MarketplaceService:UserOwnsGamePassAsync(p.UserId, p2)
	elseif p3 == Enum.InfoType.Subscription then
		return MarketplaceService:IsPlayerSubscribed(p, p2)
	else
		return false
	end
end

local function performPurchase(p, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12)
	local success, result = pcall(function()
		if not (GetFFlagEnablePromptPurchaseRequestedV2() or GetFFlagEnablePromptPurchaseRequestedV2Take2()) then
			return MarketplaceService:PerformPurchase(p, p2, p3, p4, p5, p6, p7, p8)
		end

		if FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then
			local v9

			if FFlagEnablePurchasePayloadInExperienceShop then
				v9 = p11
			end

			return MarketplaceService:PerformPurchase(p, p2, p3, p4, p5, p6, p7, p8, p9, p10, v9, p12)
		elseif FFlagEnablePurchasePayloadInExperienceShop then
			local v9

			if FFlagEnableMarketplacePurchaseDeepLinkAttribution then
				v9 = p12
			end

			return MarketplaceService:PerformPurchase(p, p2, p3, p4, p5, p6, p7, p8, p9, nil, p11, v9)
		else
			local v9

			if FFlagEnableMarketplacePurchaseDeepLinkAttribution then
				v9 = p12
			end

			return MarketplaceService:PerformPurchase(p, p2, p3, p4, p5, p6, p7, p8, p9, nil, nil, v9)
		end
	end)

	if success or isGenericChallengeResponse(result) then
		return result
	end

	error((tostring(result)))
end

local function performPurchaseV2(p, p2, p3, p4, p5, collectibleItemId, collectibleProductId, idempotencyKey, purchaseAuthToken, collectibleItemInstanceId, purchaseOptions)
	local success, result = pcall(function()
		return MarketplaceService:PerformPurchaseV2(p, p2, p3, p4, p5, {
			CollectibleItemId = collectibleItemId,
			CollectibleProductId = collectibleProductId,
			IdempotencyKey = idempotencyKey,
			PurchaseAuthToken = purchaseAuthToken,
			CollectibleItemInstanceId = collectibleItemInstanceId,
			PurchaseOptions = purchaseOptions
		})
	end)

	if success or isGenericChallengeResponse(result) then
		return result
	end

	error((tostring(result)))
end

local function performCreatorStorePurchase(p, p2)
	local success, result = pcall(function()
		return CreatorStoreService:performCreatorStorePurchase(p, p2)
	end)

	if success or isGenericChallengeResponse(result) then
		return result
	end

	error((tostring(result)))
end

local function getAssetInfo(p: number)
	return CreatorStoreService:getAssetInfoAsync(p)
end

local function getCreatorStoreProductInfo(p: number, p2: string)
	return CreatorStoreService:getCreatorStoreProductInfoAsync(p, p2)
end

local function loadAssetForEquip(p)
	return InsertService:LoadAsset(p)
end

local function getAccountInfo()
	return Promise.new(function(p, p2)
		request({
			Url = v8 .. "v1/users/authenticated/app-launch-info",
			Method = "GET"
		}, p, p2)
	end)
end

local function getBalanceInfo()
	return Promise.new(function(p, p2)
		request({
			Url = v7 .. "v1/user/currency",
			Method = "GET"
		}, p, p2)
	end)
end

local function getBundleDetails(p)
	local v9 = {
		Url = v6 .. "v1/bundles/" .. tostring(p) .. "/details",
		Method = "GET"
	}

	return Promise.new(function(p2, p3)
		spawn(function()
			request(v9, p2, p3)
		end)
	end)
end

local function getProductPurchasableDetails(p)
	local v9 = {
		Url = v7 .. "v1/products/" .. tostring(p) .. "?showPurchasable=true",
		Method = "GET"
	}

	return Promise.new(function(p2, p3)
		spawn(function()
			request(v9, p2, p3)
		end)
	end)
end

local function getCatalogItemDetails(p: number, p2: string)
	local v9 = {
		Url = string.format("%sv1/catalog/items/%d/details?itemType=%s", v6, p, p2),
		Method = "GET"
	}

	return Promise.new(function(p3, p4)
		spawn(function()
			request(v9, p3, p4)
		end)
	end)
end

local function getResellers(p: string, value: number?)
	local v9 = {
		Url = string.format("%smarketplace-sales/v1/item/%s/resellers?cursor=&limit=%d", v3, p, value or 10),
		Method = "GET"
	}

	return Promise.new(function(p2, p3)
		spawn(function()
			request(v9, p2, p3)
		end)
	end)
end

local function postCartPricing(p)
	local v9 = {
		Url = v3 .. "marketplace-sales/v1/cart-pricing",
		Method = "POST",
		Body = HttpService:JSONEncode(p),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}

	return Promise.new(function(callback, callback2)
		spawn(function()
			request(v9, function(p2)
				callback(p2)
			end, function(p2)
				callback2(p2)
			end)
		end)
	end)
end

local function postInGameItemCartPricing(p)
	local v9 = {
		Url = v3 .. "checkout/v1/cart-pricing",
		Method = "POST",
		Body = HttpService:JSONEncode(p),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}

	return Promise.new(function(p2, p3)
		request(v9, p2, p3)
	end)
end

local function getSubscriptionPurchaseInfo(p)
	return MarketplaceService:GetSubscriptionPurchaseInfoAsync(p)
end

local function performSubscriptionPurchase(p, p2)
	return MarketplaceService:PerformSubscriptionPurchaseV2(p, p2)
end

local function getPurchaseWarning(p: string?, p2: number?, flag: boolean)
	local v9 = {
		Url = UrlBuilder.economy.purchaseWarning.getPurchaseWarning(p, p2, not flag),
		Method = "GET"
	}

	return Promise.new(function(p3, p4)
		spawn(function()
			request(v9, p3, p4)
		end)
	end)
end

local function postPurchaseWarningAcknowledge(acknowledgement)
	local v9 = {
		Url = UrlBuilder.economy.purchaseWarning.ackPurchaseWarning(),
		Method = "POST",
		Body = HttpService:JSONEncode({ acknowledgement = acknowledgement }),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}

	return Promise.new(function(_, _)
		spawn(function()
			return HttpService:RequestInternal(v9):Start(function(_, _) end)
		end)
	end)
end

local function checkUserPurchaseSettings()
	local v9 = {
		Url = UrlBuilder.economy.paymentsGateway.checkUserPurchaseSettings(),
		Method = "POST",
		Body = HttpService:JSONEncode("{}"),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}

	return Promise.new(function(p, p2)
		spawn(function()
			request(v9, p, p2)
		end)
	end)
end

local function getVngShopUrl()
	local v9 = {
		Url = UrlBuilder.economy.vngPayments.getVngShopUrl(),
		Method = "GET"
	}

	return Promise.new(function(p, p2)
		spawn(function()
			request(v9, p, p2)
		end)
	end)
end

local function performDevProductEdpPurchase(p: number, p2)
	local url

	if FFlagEnableRequestLocationTypeForSduiPurchase then
		local requestLocationType = p2.requestLocationType

		if requestLocationType == nil or requestLocationType == "" then
			url = ("%sdeveloper-products/v1/developer-products/%i/purchase"):format(v3, p)
		else
			url = ("%sdeveloper-products/v1/developer-products/%i/purchase?requestLocationType=%s"):format(
				v3,
				p,
				requestLocationType
			)
		end
	else
		url = ("%sdeveloper-products/v1/developer-products/%i/purchase?requestLocationType=ExperienceDetailPage"):format(
			v3,
			p
		)
	end

	local v9 = {
		Url = url,
		Method = "POST",
		Body = HttpService:JSONEncode(p2),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}

	return Promise.new(function(p3, p4)
		spawn(function()
			request(v9, p3, p4)
		end)
	end)
end

local function getExperienceProductInfo(p)
	local v9 = {
		Url = ("%sv1/games/games-product-info?universeIds=%s"):format(v4, p),
		Method = "GET"
	}

	return Promise.new(function(p2, p3)
		spawn(function()
			request(v9, p2, p3)
		end)
	end)
end

local function getUniversePrivateServerSettings(p: number)
	local v9 = {
		Url = ("%sprivate-servers-api/universe-private-server-settings?universeId=%d"):format(v3, p),
		Method = "GET"
	}

	return Promise.new(function(p2, p3)
		spawn(function()
			request(v9, p2, p3)
		end)
	end)
end

local function performExperiencePurchase(p: string, p2)
	local v9 = {
		Url = ("%sv1/purchases/products/%s"):format(v7, p),
		Method = "POST",
		Body = HttpService:JSONEncode(p2),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}

	return Promise.new(function(p3, p4)
		spawn(function()
			request(v9, p3, p4)
		end)
	end)
end

local function performVIPServerPurchase(p: number, p2)
	local v9 = {
		Url = ("%sv1/games/vip-servers/%d"):format(v4, p),
		Method = "POST",
		Body = HttpService:JSONEncode(p2),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}

	return Promise.new(function(p3, p4)
		request(v9, p3, p4)
	end)
end

local function patchVIPServer(p: string, p2)
	local v9 = {
		Url = ("%sv1/vip-servers/%s"):format(v4, p),
		Method = "PATCH",
		Body = HttpService:JSONEncode(p2),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}

	return Promise.new(function(p3, p4)
		request(v9, p3, p4)
	end)
end

local function updateVIPServer(p: number, p2)
	return patchVIPServer(`{p}`, p2)
end

local function updateVIPServerPermissions(p: number, p2)
	return patchVIPServer(`{p}/permissions`, p2)
end

local function searchUsers(p: string)
	local v9 = {
		Url = ("%sv1/users/search?keyword=%s&limit=10"):format(v8, HttpService:UrlEncode(p)),
		Method = "GET"
	}

	return Promise.new(function(p2, p3)
		request(v9, p2, p3)
	end)
end

local function performLookPurchase(p: string, p2)
	local v9 = {
		Url = ("%slook-api/v2/looks/%s/purchase"):format(v3, p),
		Method = "POST",
		Body = HttpService:JSONEncode(p2),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}

	return Promise.new(function(p3, p4)
		spawn(function()
			request(v9, p3, p4)
		end)
	end)
end

local function performLookPurchaseBulkPurchase(lookId: string, p: string, lineItems)
	local v9 = {
		Url = ("%scloud/v2/avatar-marketplace-orders?idempotencyKey.key=%s"):format(v3, p),
		Method = "POST",
		Body = HttpService:JSONEncode({
			purchasingUser = `users/{Players.LocalPlayer.UserId}`,
			context = {
				productSurface = "MARKETPLACE_UA",
				lookId = lookId,
				lookContext = {
					lookIds = { lookId }
				}
			},
			fulfillmentGroups = {
				{ strategy = "BEST_EFFORT", lineItems = lineItems }
			}
		}),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}

	return Promise.new(function(p2, p3)
		spawn(function()
			request(v9, p2, p3)
		end)
	end)
end

local function performDeveloperSubscriptionRobuxPurchase(p: string, p2: number)
	if not engineFeature2 then
		error("Developer subscription Robux purchase requires engine feature to be enabled")
		return
	end

	local success, result = pcall(function()
		MarketplaceService:PerformSubscriptionPurchaseWithRobuxAsync(p, p2)
	end)

	if not success then
		error(result)
	end
end

local function getUnifiedPurchaseFlowUserEligibility()
	local v9 = {
		Url = ("%sroblox-subscriptions/v1/metadata"):format(v3),
		Method = "GET"
	}

	return Promise.new(function(p, p2)
		spawn(function()
			request(v9, p, p2)
		end)
	end)
end

local function GetLookDetailsV2ProductInfo(p: string)
	local v9 = {
		Url = string.format("%slook-api/v2/looks/%s", v3, p),
		Method = "GET"
	}

	return Promise.new(function(p2, p3)
		spawn(function()
			request(v9, p2, p3)
		end)
	end)
end

return {
	new = function()
		local v9 = {}
		v9.getABTestGroup = Promise.promisify(getABTestGroup)
		v9.getProductInfo = Promise.promisify(getProductInfo)
		v9.getPlayerOwns = Promise.promisify(getPlayerOwns)
		v9.performPurchase = Promise.promisify(performPurchase)
		v9.performPurchaseV2 = Promise.promisify(performPurchaseV2)
		local performCreatorStorePurchase2

		if GetFFlagEnableCreatorStorePurchasingCutover() then
			performCreatorStorePurchase2 = Promise.promisify(performCreatorStorePurchase)
		end

		v9.performCreatorStorePurchase = performCreatorStorePurchase2

		v9.loadAssetForEquip = Promise.promisify(loadAssetForEquip)
		v9.getAccountInfo = Promise.promisify(getAccountInfo)
		local getAssetInfo2

		if GetFFlagEnableCreatorStorePurchasingCutover() then
			getAssetInfo2 = Promise.promisify(getAssetInfo)
		end

		v9.getAssetInfo = getAssetInfo2
		v9.getBalanceInfo = Promise.promisify(getBalanceInfo)
		v9.getBundleDetails = getBundleDetails
		v9.getProductPurchasableDetails = getProductPurchasableDetails
		local getCatalogItemDetails2

		if FFlagRefreshPriceOnRetryAfterUpsell then
			getCatalogItemDetails2 = getCatalogItemDetails
		end

		v9.getCatalogItemDetails = getCatalogItemDetails2
		local getResellers2

		if FFlagRefreshPriceOnRetryAfterUpsell then
			getResellers2 = getResellers
		end

		v9.getResellers = getResellers2
		local getCreatorStoreProductInfo2

		if GetFFlagEnableCreatorStorePurchasingCutover() then
			getCreatorStoreProductInfo2 = Promise.promisify(getCreatorStoreProductInfo)
		end

		v9.getCreatorStoreProductInfo = getCreatorStoreProductInfo2

		v9.getSubscriptionPurchaseInfo = Promise.promisify(getSubscriptionPurchaseInfo)
		v9.performSubscriptionPurchase = Promise.promisify(performSubscriptionPurchase)
		v9.getPurchaseWarning = Promise.promisify(getPurchaseWarning)
		v9.postPurchaseWarningAcknowledge = Promise.promisify(postPurchaseWarningAcknowledge)
		v9.checkUserPurchaseSettings = Promise.promisify(checkUserPurchaseSettings)
		v9.getVngShopUrl = Promise.promisify(getVngShopUrl)
		v9.performDevProductEdpPurchase = Promise.promisify(performDevProductEdpPurchase)
		v9.getExperienceProductInfo = Promise.promisify(getExperienceProductInfo)
		v9.performExperiencePurchase = Promise.promisify(performExperiencePurchase)
		v9.getUniversePrivateServerSettings = Promise.promisify(getUniversePrivateServerSettings)
		local performVIPServerPurchase2

		if FFlagLuaAppsEnablePromptVIPServerPurchase then
			performVIPServerPurchase2 = performVIPServerPurchase
		end

		v9.performVIPServerPurchase = performVIPServerPurchase2
		local updateVIPServer2

		if FFlagLuaAppsEnablePromptVIPServerPurchase then
			updateVIPServer2 = updateVIPServer
		end

		v9.updateVIPServer = updateVIPServer2
		local updateVIPServerPermissions2

		if FFlagLuaAppsEnablePromptVIPServerPurchase then
			updateVIPServerPermissions2 = updateVIPServerPermissions
		end

		v9.updateVIPServerPermissions = updateVIPServerPermissions2
		local searchUsers2

		if FFlagLuaAppsEnablePromptVIPServerPurchase then
			searchUsers2 = searchUsers
		end

		v9.searchUsers = searchUsers2
		v9.performLookPurchase = Promise.promisify(performLookPurchase)
		v9.getUnifiedPurchaseFlowUserEligibility = Promise.promisify(getUnifiedPurchaseFlowUserEligibility)
		local performLookPurchaseBulkPurchase2

		if FFlagPurchasePromptFetchCartPricingForLooks then
			performLookPurchaseBulkPurchase2 = Promise.promisify(performLookPurchaseBulkPurchase)
		end

		v9.performLookPurchaseBulkPurchase = performLookPurchaseBulkPurchase2
		local performDeveloperSubscriptionRobuxPurchase2

		if FFlagEnableUnifiedPurchaseFlowForDevSubs then
			performDeveloperSubscriptionRobuxPurchase2 = Promise.promisify(performDeveloperSubscriptionRobuxPurchase)
		end

		v9.performDeveloperSubscriptionRobuxPurchase = performDeveloperSubscriptionRobuxPurchase2
		local getSubscriptionProductInfo2

		if FFlagEnableUnifiedPurchaseFlowForDevSubs then
			getSubscriptionProductInfo2 = Promise.promisify(getSubscriptionProductInfo)
		end

		v9.getSubscriptionProductInfo = getSubscriptionProductInfo2
		local getLookDetailsV2ProductInfo

		if FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell then
			getLookDetailsV2ProductInfo = Promise.promisify(GetLookDetailsV2ProductInfo)
		end

		v9.GetLookDetailsV2ProductInfo = getLookDetailsV2ProductInfo

		v9.postCartPricing = postCartPricing
		v9.postInGameItemCartPricing = postInGameItemCartPricing

		setmetatable(v9, {
			__tostring = function(): string
				return "Service(Network)"
			end
		})

		return v9
	end
}
