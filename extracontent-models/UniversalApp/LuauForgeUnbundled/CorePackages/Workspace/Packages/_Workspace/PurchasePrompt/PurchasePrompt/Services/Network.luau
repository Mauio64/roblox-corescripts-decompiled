local HttpService = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")
local MarketplaceService = game:GetService("MarketplaceService")
local InsertService = game:GetService("InsertService")
local Players = game:GetService("Players")
local CreatorStoreService = game:GetService("CreatorStoreService")

local urlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePromptDeps").UrlBuilder.UrlBuilder

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/types")
local debugLog = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/debugLog")
local serializeTable = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/serializeTable")
local isGenericChallengeResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/isGenericChallengeResponse")
local isGetPassOwnershipApiEnabled = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Utils/isGetPassOwnershipApiEnabled")

local engineFeature = game:GetEngineFeature("EnablePlayerOwnsBundleApi")
local engineFeature2 = game:GetEngineFeature("EnableDevSubscriptionPurchaseWithRobux")
local GetFFlagEnablePromptPurchaseRequestedV2 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnablePromptPurchaseRequestedV2")
local GetFFlagEnablePromptPurchaseRequestedV2Take2 = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnablePromptPurchaseRequestedV2Take2")
local GetFFlagEnableCreatorStorePurchasingCutover = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/GetFFlagEnableCreatorStorePurchasingCutover")
local fFlagEnableUnifiedPurchaseFlowForDevSubs = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags").FFlagEnableUnifiedPurchaseFlowForDevSubs

local FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell")
local FFlagEnableRequestLocationTypeForSduiPurchase = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagEnableRequestLocationTypeForSduiPurchase")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/SharedFlags")
local fFlagUseGetGamePassOwnershipApi = SharedFlags.FFlagUseGetGamePassOwnershipApi

local fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow = SharedFlags.FFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow
local fFlagEnablePurchasePayloadInExperienceShop = SharedFlags.FFlagEnablePurchasePayloadInExperienceShop
local fFlagEnableMarketplacePurchaseDeepLinkAttribution = SharedFlags.FFlagEnableMarketplacePurchaseDeepLinkAttribution
local FFlagRefreshPriceOnRetryAfterUpsell = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePrompt/PurchasePrompt/Flags/FFlagRefreshPriceOnRetryAfterUpsell")
local fFlagPurchasePromptFetchCartPricingForLooks = SharedFlags.FFlagPurchasePromptFetchCartPricingForLooks
local fFlagLuaAppsEnablePromptVIPServerPurchase = SharedFlags.FFlagLuaAppsEnablePromptVIPServerPurchase

local v5 = string.gsub(ContentProvider.BaseUrl:lower(), "/m.", "/www.")
local v6 = string.gsub(v5, "http:", "https:")

string.gsub(v6, "https://www", "https://api")
local v7 = string.gsub(v6, "https://www", "https://apis")
local v8 = string.gsub(v6, "https://www", "https://games")
local v9 = string.gsub(v6, "https://www", "https://abtesting")
local v10 = string.gsub(v6, "https://www.", "https://catalog.")
local v11 = string.gsub(v6, "https://www.", "https://economy.")
local v12 = string.gsub(v6, "https://www", "https://users")

local function request(p2, callback, callback2)
	debugLog(function()
		return "Request " .. p2.Url .. "\n" .. serializeTable(p2)
	end)

	return HttpService:RequestInternal(p2):Start(function(p3, p4)
		debugLog(function()
			return "Response " .. p2.Url .. "\n" .. serializeTable(p4)
		end)

		if not p3 then
			callback2((tostring(p4.StatusMessage)))

			return
		end

		local success, result = pcall(HttpService.JSONDecode, HttpService, p4.Body)

		if success then
			callback(result)
		else
			callback2("Could not parse JSON.")
		end
	end)
end

local function getABTestGroup(p2, p3)
	local v13 = {
		{ ExperimentName = p3, SubjectType = 1, SubjectTargetId = p2 }
	}

	return Promise.new(function(p4, p5)
		return request({
			Url = v9 .. "v1/get-enrollments",
			Method = "POST",
			Body = HttpService:JSONEncode(v13),
			Headers = {
				["Content-Type"] = "application/json",
				Accept = "application/json"
			}
		}, p4, p5)
	end)
end

local function getProductInfo(p2, p3)
	return MarketplaceService:GetProductInfoAsync(p2, p3)
end

local function getSubscriptionProductInfo(p2)
	return MarketplaceService:GetSubscriptionProductInfoAsync(p2)
end

local function getPlayerOwns(p2, p3, p4)
	if p4 == Enum.InfoType.Asset then
		return MarketplaceService:PlayerOwnsAssetAsync(p2, p3)
	end

	if engineFeature and p4 == Enum.InfoType.Bundle then
		return MarketplaceService:PlayerOwnsBundleAsync(p2, p3)
	end

	if p4 == Enum.InfoType.GamePass then
		if fFlagUseGetGamePassOwnershipApi then
			local success, result = pcall(function()
				return MarketplaceService:GetPassOwnershipAsync(p2, p3)
			end)

			if success then
				return typeof(result) == "table" and result.Owned == true
			elseif isGetPassOwnershipApiEnabled() then
				error(result, 0)
			end
		end

		return MarketplaceService:UserOwnsGamePassAsync(p2.UserId, p3)
	elseif p4 == Enum.InfoType.Subscription then
		return MarketplaceService:IsPlayerSubscribed(p2, p3)
	else
		return false
	end
end

local function performPurchase(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13)
	local success, result = pcall(function()
		if not (GetFFlagEnablePromptPurchaseRequestedV2() or GetFFlagEnablePromptPurchaseRequestedV2Take2()) then
			return MarketplaceService:PerformPurchase(p2, p3, p4, p5, p6, p7, p8, p9)
		end

		if fFlagAXSupportRentalPurchaseInUnifiedProductPurchaseFlow then
			return MarketplaceService:PerformPurchase(
				p2,
				p3,
				p4,
				p5,
				p6,
				p7,
				p8,
				p9,
				p10,
				p11,
				if fFlagEnablePurchasePayloadInExperienceShop then p12 else nil,
				p13
			)
		elseif fFlagEnablePurchasePayloadInExperienceShop then
			return MarketplaceService:PerformPurchase(
				p2,
				p3,
				p4,
				p5,
				p6,
				p7,
				p8,
				p9,
				p10,
				nil,
				p12,
				if fFlagEnableMarketplacePurchaseDeepLinkAttribution then p13 else nil
			)
		else
			return MarketplaceService:PerformPurchase(
				p2,
				p3,
				p4,
				p5,
				p6,
				p7,
				p8,
				p9,
				p10,
				nil,
				nil,
				if fFlagEnableMarketplacePurchaseDeepLinkAttribution then p13 else nil
			)
		end
	end)

	if success or isGenericChallengeResponse(result) then
		return result
	end

	error((tostring(result)))
end

local function performPurchaseV2(p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12)
	local success, result = pcall(function()
		return MarketplaceService:PerformPurchaseV2(p2, p3, p4, p5, p6, {
			CollectibleItemId = p7,
			CollectibleProductId = p8,
			IdempotencyKey = p9,
			PurchaseAuthToken = p10,
			CollectibleItemInstanceId = p11,
			PurchaseOptions = p12
		})
	end)

	if success or isGenericChallengeResponse(result) then
		return result
	end

	error((tostring(result)))
end

local function performCreatorStorePurchase(p2, p3)
	local success, result = pcall(function()
		return CreatorStoreService:performCreatorStorePurchase(p2, p3)
	end)

	if success or isGenericChallengeResponse(result) then
		return result
	end

	error((tostring(result)))
end

local function getAssetInfo(p2)
	return CreatorStoreService:getAssetInfoAsync(p2)
end

local function getCreatorStoreProductInfo(p2, p3)
	return CreatorStoreService:getCreatorStoreProductInfoAsync(p2, p3)
end

local function loadAssetForEquip(p2)
	return InsertService:LoadAsset(p2)
end

local function getAccountInfo()
	return Promise.new(function(p2, p3)
		request({
			Url = v12 .. "v1/users/authenticated/app-launch-info",
			Method = "GET"
		}, p2, p3)
	end)
end

local function getBalanceInfo()
	return Promise.new(function(p2, p3)
		request({
			Url = v11 .. "v1/user/currency",
			Method = "GET"
		}, p2, p3)
	end)
end

local function getBundleDetails(p2)
	local v13 = {
		Url = v10 .. "v1/bundles/" .. tostring(p2) .. "/details",
		Method = "GET"
	}

	return Promise.new(function(p3, p4)
		spawn(function()
			request(v13, p3, p4)
		end)
	end)
end

local function getProductPurchasableDetails(p2)
	local v13 = {
		Url = v11 .. "v1/products/" .. tostring(p2) .. "?showPurchasable=true",
		Method = "GET"
	}

	return Promise.new(function(p3, p4)
		spawn(function()
			request(v13, p3, p4)
		end)
	end)
end

local function getCatalogItemDetails(p2, p3)
	local v13 = {
		Url = string.format("%sv1/catalog/items/%d/details?itemType=%s", v10, p2, p3),
		Method = "GET"
	}

	return Promise.new(function(p4, p5)
		spawn(function()
			request(v13, p4, p5)
		end)
	end)
end

local function getResellers(p2, value)
	local v13 = {
		Url = string.format(
			"%smarketplace-sales/v1/item/%s/resellers?cursor=&limit=%d",
			v7,
			p2,
			value or 10
		),
		Method = "GET"
	}

	return Promise.new(function(p3, p4)
		spawn(function()
			request(v13, p3, p4)
		end)
	end)
end

local function postCartPricing(p2)
	local v13 = {
		Url = v7 .. "marketplace-sales/v1/cart-pricing",
		Method = "POST",
		Body = HttpService:JSONEncode(p2),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}

	return Promise.new(function(callback, callback2)
		spawn(function()
			request(v13, function(p3)
				callback(p3)
			end, function(p3)
				callback2(p3)
			end)
		end)
	end)
end

local function postInGameItemCartPricing(p2)
	local v13 = {
		Url = v7 .. "checkout/v1/cart-pricing",
		Method = "POST",
		Body = HttpService:JSONEncode(p2),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}

	return Promise.new(function(p3, p4)
		request(v13, p3, p4)
	end)
end

local function getSubscriptionPurchaseInfo(p2)
	return MarketplaceService:GetSubscriptionPurchaseInfoAsync(p2)
end

local function performSubscriptionPurchase(p2, p3)
	return MarketplaceService:PerformSubscriptionPurchaseV2(p2, p3)
end

local function getPurchaseWarning(p2, p3, p4)
	local v13 = {
		Url = urlBuilder.economy.purchaseWarning.getPurchaseWarning(p2, p3, not p4),
		Method = "GET"
	}

	return Promise.new(function(p5, p6)
		spawn(function()
			request(v13, p5, p6)
		end)
	end)
end

local function postPurchaseWarningAcknowledge(p2)
	local v13 = {
		Url = urlBuilder.economy.purchaseWarning.ackPurchaseWarning(),
		Method = "POST",
		Body = HttpService:JSONEncode({ acknowledgement = p2 }),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}

	return Promise.new(function(p3, p4)
		spawn(function()
			return HttpService:RequestInternal(v13):Start(function(p5, p6) end)
		end)
	end)
end

local function checkUserPurchaseSettings()
	local v13 = {
		Url = urlBuilder.economy.paymentsGateway.checkUserPurchaseSettings(),
		Method = "POST",
		Body = HttpService:JSONEncode("{}"),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}

	return Promise.new(function(p2, p3)
		spawn(function()
			request(v13, p2, p3)
		end)
	end)
end

local function getVngShopUrl()
	local v13 = {
		Url = urlBuilder.economy.vngPayments.getVngShopUrl(),
		Method = "GET"
	}

	return Promise.new(function(p2, p3)
		spawn(function()
			request(v13, p2, p3)
		end)
	end)
end

local function performDevProductEdpPurchase(p2, p3)
	local v13

	if FFlagEnableRequestLocationTypeForSduiPurchase then
		local requestLocationType = p3.requestLocationType

		if requestLocationType == nil or requestLocationType == "" then
			v13 = ("%sdeveloper-products/v1/developer-products/%i/purchase"):format(v7, p2)
		else
			v13 = ("%sdeveloper-products/v1/developer-products/%i/purchase?requestLocationType=%s"):format(
				v7,
				p2,
				requestLocationType
			)
		end
	else
		v13 = ("%sdeveloper-products/v1/developer-products/%i/purchase?requestLocationType=ExperienceDetailPage"):format(
			v7,
			p2
		)
	end

	local v14 = {
		Url = v13,
		Method = "POST",
		Body = HttpService:JSONEncode(p3),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}

	return Promise.new(function(p4, p5)
		spawn(function()
			request(v14, p4, p5)
		end)
	end)
end

local function getExperienceProductInfo(p2)
	local v13 = {
		Url = ("%sv1/games/games-product-info?universeIds=%s"):format(v8, p2),
		Method = "GET"
	}

	return Promise.new(function(p3, p4)
		spawn(function()
			request(v13, p3, p4)
		end)
	end)
end

local function getUniversePrivateServerSettings(p2)
	local v13 = {
		Url = ("%sprivate-servers-api/universe-private-server-settings?universeId=%d"):format(v7, p2),
		Method = "GET"
	}

	return Promise.new(function(p3, p4)
		spawn(function()
			request(v13, p3, p4)
		end)
	end)
end

local function performExperiencePurchase(p2, p3)
	local v13 = {
		Url = ("%sv1/purchases/products/%s"):format(v11, p2),
		Method = "POST",
		Body = HttpService:JSONEncode(p3),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}

	return Promise.new(function(p4, p5)
		spawn(function()
			request(v13, p4, p5)
		end)
	end)
end

local function performVIPServerPurchase(p2, p3)
	local v13 = {
		Url = ("%sv1/games/vip-servers/%d"):format(v8, p2),
		Method = "POST",
		Body = HttpService:JSONEncode(p3),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}

	return Promise.new(function(p4, p5)
		request(v13, p4, p5)
	end)
end

local function patchVIPServer(p2, p3)
	local v13 = {
		Url = ("%sv1/vip-servers/%s"):format(v8, p2),
		Method = "PATCH",
		Body = HttpService:JSONEncode(p3),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}

	return Promise.new(function(p4, p5)
		request(v13, p4, p5)
	end)
end

local function updateVIPServer(p2, p3)
	return patchVIPServer(`{p2}`, p3)
end

local function updateVIPServerPermissions(p2, p3)
	return patchVIPServer(`{p2}/permissions`, p3)
end

local function searchUsers(p2)
	local v13 = {
		Url = ("%sv1/users/search?keyword=%s&limit=10"):format(v12, HttpService:UrlEncode(p2)),
		Method = "GET"
	}

	return Promise.new(function(p3, p4)
		request(v13, p3, p4)
	end)
end

local function performLookPurchase(p2, p3)
	local v13 = {
		Url = ("%slook-api/v2/looks/%s/purchase"):format(v7, p2),
		Method = "POST",
		Body = HttpService:JSONEncode(p3),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}

	return Promise.new(function(p4, p5)
		spawn(function()
			request(v13, p4, p5)
		end)
	end)
end

local function performLookPurchaseBulkPurchase(p2, p3, p4)
	local v13 = {
		Url = ("%scloud/v2/avatar-marketplace-orders?idempotencyKey.key=%s"):format(v7, p3),
		Method = "POST",
		Body = HttpService:JSONEncode({
			purchasingUser = `users/{Players.LocalPlayer.UserId}`,
			context = {
				productSurface = "MARKETPLACE_UA",
				lookId = p2,
				lookContext = {
					lookIds = { p2 }
				}
			},
			fulfillmentGroups = {
				{ strategy = "BEST_EFFORT", lineItems = p4 }
			}
		}),
		Headers = { ["Content-Type"] = "application/json", Accept = "application/json" }
	}

	return Promise.new(function(p5, p6)
		spawn(function()
			request(v13, p5, p6)
		end)
	end)
end

local function performDeveloperSubscriptionRobuxPurchase(p2, p3)
	if not engineFeature2 then
		error("Developer subscription Robux purchase requires engine feature to be enabled")
		return
	end

	local success, result = pcall(function()
		MarketplaceService:PerformSubscriptionPurchaseWithRobuxAsync(p2, p3)
	end)

	if not success then
		error(result)
	end
end

local function getUnifiedPurchaseFlowUserEligibility()
	local v13 = {
		Url = ("%sroblox-subscriptions/v1/metadata"):format(v7),
		Method = "GET"
	}

	return Promise.new(function(p2, p3)
		spawn(function()
			request(v13, p2, p3)
		end)
	end)
end

local function GetLookDetailsV2ProductInfo(p2)
	local v13 = {
		Url = string.format("%slook-api/v2/looks/%s", v7, p2),
		Method = "GET"
	}

	return Promise.new(function(p3, p4)
		spawn(function()
			request(v13, p3, p4)
		end)
	end)
end

return {
	new = function()
		local v13 = {}
		v13.getABTestGroup = Promise.promisify(getABTestGroup)
		v13.getProductInfo = Promise.promisify(getProductInfo)
		v13.getPlayerOwns = Promise.promisify(getPlayerOwns)
		v13.performPurchase = Promise.promisify(performPurchase)
		v13.performPurchaseV2 = Promise.promisify(performPurchaseV2)
		local v14 = if GetFFlagEnableCreatorStorePurchasingCutover() then Promise.promisify(performCreatorStorePurchase) else nil
		v13.performCreatorStorePurchase = v14

		v13.loadAssetForEquip = Promise.promisify(loadAssetForEquip)
		v13.getAccountInfo = Promise.promisify(getAccountInfo)
		local v15 = if GetFFlagEnableCreatorStorePurchasingCutover() then Promise.promisify(getAssetInfo) else nil
		v13.getAssetInfo = v15
		v13.getBalanceInfo = Promise.promisify(getBalanceInfo)
		v13.getBundleDetails = getBundleDetails
		v13.getProductPurchasableDetails = getProductPurchasableDetails
		v13.getCatalogItemDetails = if FFlagRefreshPriceOnRetryAfterUpsell then getCatalogItemDetails else nil
		v13.getResellers = if FFlagRefreshPriceOnRetryAfterUpsell then getResellers else nil
		local v18 = if GetFFlagEnableCreatorStorePurchasingCutover() then Promise.promisify(getCreatorStoreProductInfo) else nil
		v13.getCreatorStoreProductInfo = v18

		v13.getSubscriptionPurchaseInfo = Promise.promisify(getSubscriptionPurchaseInfo)
		v13.performSubscriptionPurchase = Promise.promisify(performSubscriptionPurchase)
		v13.getPurchaseWarning = Promise.promisify(getPurchaseWarning)
		v13.postPurchaseWarningAcknowledge = Promise.promisify(postPurchaseWarningAcknowledge)
		v13.checkUserPurchaseSettings = Promise.promisify(checkUserPurchaseSettings)
		v13.getVngShopUrl = Promise.promisify(getVngShopUrl)
		v13.performDevProductEdpPurchase = Promise.promisify(performDevProductEdpPurchase)
		v13.getExperienceProductInfo = Promise.promisify(getExperienceProductInfo)
		v13.performExperiencePurchase = Promise.promisify(performExperiencePurchase)
		v13.getUniversePrivateServerSettings = Promise.promisify(getUniversePrivateServerSettings)
		v13.performVIPServerPurchase = if fFlagLuaAppsEnablePromptVIPServerPurchase then performVIPServerPurchase else nil
		v13.updateVIPServer = if fFlagLuaAppsEnablePromptVIPServerPurchase then updateVIPServer else nil
		v13.updateVIPServerPermissions = if fFlagLuaAppsEnablePromptVIPServerPurchase then updateVIPServerPermissions else nil

		v13.searchUsers = if fFlagLuaAppsEnablePromptVIPServerPurchase then searchUsers else nil
		v13.performLookPurchase = Promise.promisify(performLookPurchase)
		v13.getUnifiedPurchaseFlowUserEligibility = Promise.promisify(getUnifiedPurchaseFlowUserEligibility)

		local v23 = if fFlagPurchasePromptFetchCartPricingForLooks then Promise.promisify(performLookPurchaseBulkPurchase) else nil
		v13.performLookPurchaseBulkPurchase = v23

		local v24 = if fFlagEnableUnifiedPurchaseFlowForDevSubs then Promise.promisify(performDeveloperSubscriptionRobuxPurchase) else nil
		v13.performDeveloperSubscriptionRobuxPurchase = v24

		local v25 = if fFlagEnableUnifiedPurchaseFlowForDevSubs then Promise.promisify(getSubscriptionProductInfo) else nil
		v13.getSubscriptionProductInfo = v25

		local v26 = if FFlagUnifiedPurchaseSupportRefetchingLooksAfterUpsell then Promise.promisify(GetLookDetailsV2ProductInfo) else nil
		v13.GetLookDetailsV2ProductInfo = v26

		v13.postCartPricing = postCartPricing
		v13.postInGameItemCartPricing = postInGameItemCartPricing

		setmetatable(v13, {
			__tostring = function(): string
				return "Service(Network)"
			end
		})

		return v13
	end
}
