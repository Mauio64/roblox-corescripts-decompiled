local ParentParent = script.Parent.Parent
local Promise = require(ParentParent.Promise)
local PurchaseWarning = require(ParentParent.Enums.PurchaseWarning)
local GetFFlagUseCatalogItemDetailsToResolveBundlePurchase = require(ParentParent.Flags.GetFFlagUseCatalogItemDetailsToResolveBundlePurchase)
local FFlagRefreshPriceOnRetryAfterUpsell = require(ParentParent.Flags.FFlagRefreshPriceOnRetryAfterUpsell)

local function getABTestGroup() -- line: 15
	-- upvalues: Promise (copy)
	return Promise.resolve(false)
end
local function getProductInfo(_, _) -- line: 19
	-- upvalues: Promise (copy)
	return Promise.resolve({
		AssetId = 1,
		AssetTypeId = 2,
		ContentRatingTypeId = 0,
		Description = "This item isn't real!",
		IconImageAssetId = 1,
		IsForSale = true,
		IsLimited = false,
		IsLimitedUnique = false,
		IsNew = false,
		IsPublicDomain = false,
		MinimumMembershipLevel = 0,
		Name = "Test Item",
		PriceInRobux = 100,
		ProductId = 1,
		Creator = {
			CreatorType = "Group",
			CreatorTargetId = 1,
			Name = "ROBLOX",
			Id = 1
		}
	})
end
local function getPlayerOwns(_, _, _) -- line: 44
	-- upvalues: Promise (copy)
	return Promise.resolve(false)
end
local function performPurchase(_, _, _, _) -- line: 48
	-- upvalues: Promise (copy)
	return Promise.resolve({
		success = true,
		purchased = true,
		receipt = "fake-receipt-hash"
	})
end
local function loadAssetForEquip(_) -- line: 56
	-- upvalues: Promise (copy)
	return Promise.resolve(Instance.new("Tool"))
end
local function getAccountInfo() -- line: 60
	-- upvalues: Promise (copy)
	return Promise.resolve({
		isPremium = false
	})
end
local function getBalanceInfo() -- line: 66
	-- upvalues: Promise (copy)
	return Promise.resolve({
		robux = 2147483647
	})
end
local function getBundleDetails(_) -- line: 72
	-- upvalues: Promise (copy)
	return Promise.resolve({
		id = 1,
		name = "mock-name",
		description = "mock-description",
		items = {
			[1] = {
				id = 1,
				name = "outfit-name",
				type = "UserOutfit"
			}
		},
		creator = {
			id = 1,
			name = "ROBLOX",
			type = "User"
		},
		product = {
			id = 1,
			isForSale = true,
			priceInRobux = 100
		}
	})
end
local function getProductPurchasableDetails(_) -- line: 97
	-- upvalues: Promise (copy)
	return Promise.resolve({
		purchasable = false,
		reason = "mock-reason",
		price = 100
	})
end
local function getCatalogItemDetails(_: number, _: string) -- line: 105
	-- upvalues: Promise (copy)
	return Promise.resolve({
		bundleType = 1,
		collectibleItemId = "random-collectible-item-id-123",
		creatorHasVerifiedBadge = true,
		creatorName = "mockRobloxCreator",
		creatorTargetId = 123,
		creatorType = "User",
		description = "Mock bundle",
		expectedSellerId = 123,
		favoriteCount = 908,
		hasReseller = false,
		id = 123456,
		isPurchasable = true,
		itemType = "Bundle",
		lowestPrice = 175,
		lowestResalePrice = 0,
		name = "Roblox Collectible Bundle",
		owned = false,
		price = 175,
		productId = 1234567890123456,
		purchaseCount = 0,
		saleLocationType = "ShopAndAllExperiences",
		totalQuantity = 0,
		unitsAvailableForConsumption = 0,
		bundledItems = {
			[1] = {
				id = 10001,
				name = "Mock bundle - Left Arm",
				owned = true,
				type = "Asset"
			},
			[2] = {
				id = 1002,
				name = "Mock bundle - Right Leg",
				owned = true,
				type = "Asset"
			},
			[3] = {
				id = 1003,
				name = "Mock bundle - Right Arm",
				owned = true,
				type = "Asset"
			},
			[4] = {
				id = 1004,
				name = "Mock bundle - Left Leg",
				owned = true,
				type = "Asset"
			},
			[5] = {
				id = 1005,
				name = "Mock bundle - Dynamic Head",
				owned = true,
				type = "Asset"
			},
			[6] = {
				id = 1006,
				name = "Default Mood",
				owned = true,
				type = "Asset"
			},
			[7] = {
				id = 1007,
				name = "Mock bundle - Torso",
				owned = true,
				type = "Asset"
			},
			[8] = {
				id = 1008,
				name = "Mock item",
				owned = true,
				type = "UserOutfit"
			},
			[9] = {
				id = 1009,
				name = "Mock bundle Head",
				owned = true,
				type = "UserOutfit"
			}
		},
		itemRestrictions = {},
		itemStatus = {}
	})
end
local function getResellers(_: string, _: number?) -- line: 191
	-- upvalues: Promise (copy)
	return Promise.resolve({
		nextPageCursor = nil,
		data = {}
	})
end
local function getRobuxUpsellProductWithUniverseItemInfo(_, _, _, _, _, _) -- line: 198
	-- upvalues: Promise (copy)
	return Promise.resolve({
		roblox_product_id = 50,
		provider_product_id = "robux50",
		roblox_product_name = "providerRobux50",
		robux_amount = 500
	})
end
local function postPremiumImpression() -- line: 214
	-- upvalues: Promise (copy)
	return Promise.resolve()
end
local function getPremiumUpsellPrecheck() -- line: 218
	-- upvalues: Promise (copy)
	return Promise.resolve(true)
end
local function getPurchaseWarning(_) -- line: 222
	-- upvalues: Promise (copy), PurchaseWarning (copy)
	return Promise.resolve({
		action = PurchaseWarning.NoAction
	})
end
local function postPurchaseWarningAcknowledge() -- line: 228
	-- upvalues: Promise (copy)
	return Promise.resolve()
end
local function checkUserPurchaseSettings() -- line: 232
	-- upvalues: Promise (copy)
	return Promise.resolve({
		isEligible = false,
		failureReason = "PurchaseNotEnabled"
	})
end
local function getUnifiedPurchaseFlowUserEligibility() -- line: 239
	-- upvalues: Promise (copy)
	return Promise.resolve({
		isUserEligibleForUnifiedPurchaseFlow = true,
		expiresInSeconds = 120
	})
end
local function getSubscriptionProductInfo(_) -- line: 246
	-- upvalues: Promise (copy)
	return Promise.resolve({
		Name = "Mock Subscription",
		Description = "A mock developer subscription",
		IconImageAssetId = 12345,
		IsForSale = true,
		DisplayPrice = "$4.99",
		DisplaySubscriptionPeriod = "/month",
		SubscriptionProviderName = "MockGame",
		PriceTier = 499,
		PriceInRobux = 0
	})
end
local function GetLookDetailsV2ProductInfo(_) -- line: 260
	-- upvalues: Promise (copy)
	return Promise.resolve({
		look = {
			items = {{
				id = 1,
				itemType = "Asset",
				priceInRobux = 100
			}}
		}
	})
end

local t1 = {}

t1.__index = t1

function t1.new(p22, p23) -- line: 277
	-- upvalues: Promise (copy), GetFFlagUseCatalogItemDetailsToResolveBundlePurchase (copy), FFlagRefreshPriceOnRetryAfterUpsell (copy), getABTestGroup (copy), getProductInfo (copy), getPlayerOwns (copy), performPurchase (copy), loadAssetForEquip (copy), getAccountInfo (copy), getBalanceInfo (copy), getBundleDetails (copy), getProductPurchasableDetails (copy), getCatalogItemDetails (copy), getResellers (copy), getRobuxUpsellProductWithUniverseItemInfo (copy), postPremiumImpression (copy), getPremiumUpsellPrecheck (copy), getPurchaseWarning (copy), postPurchaseWarningAcknowledge (copy), checkUserPurchaseSettings (copy), getUnifiedPurchaseFlowUserEligibility (copy), getSubscriptionProductInfo (copy), GetLookDetailsV2ProductInfo (copy)
	local t2

	if p23 or p22 then
		local function v54() -- line: 281
			-- upvalues: p22 (copy), Promise (copy), p23 (copy)
			if p22 then
				return Promise.resolve(p22)
			end

			return Promise.reject(p23)
		end

		t2 = {
			getABTestGroup = v54,
			getProductInfo = v54,
			getPlayerOwns = v54,
			performPurchase = v54,
			loadAssetForEquip = v54,
			getAccountInfo = v54,
			getBalanceInfo = v54,
			getBundleDetails = v54,
			getProductPurchasableDetails = v54,
			getCatalogItemDetails = if not GetFFlagUseCatalogItemDetailsToResolveBundlePurchase() and not FFlagRefreshPriceOnRetryAfterUpsell then nil else v54,
			getResellers = if not FFlagRefreshPriceOnRetryAfterUpsell then nil else v54,
			getRobuxUpsellProductWithUniverseItemInfo = v54,
			postPremiumImpression = v54,
			getPremiumUpsellPrecheck = v54,
			getPurchaseWarning = v54,
			postPurchaseWarningAcknowledge = v54,
			checkUserPurchaseSettings = v54,
			getUnifiedPurchaseFlowUserEligibility = v54,
			getSubscriptionProductInfo = v54
		}
	else
		t2 = {
			getABTestGroup = getABTestGroup,
			getProductInfo = getProductInfo,
			getPlayerOwns = getPlayerOwns,
			performPurchase = performPurchase,
			loadAssetForEquip = loadAssetForEquip,
			getAccountInfo = getAccountInfo,
			getBalanceInfo = getBalanceInfo,
			getBundleDetails = getBundleDetails,
			getProductPurchasableDetails = getProductPurchasableDetails,
			getCatalogItemDetails = if not GetFFlagUseCatalogItemDetailsToResolveBundlePurchase() and not FFlagRefreshPriceOnRetryAfterUpsell then nil else getCatalogItemDetails,
			getResellers = if not FFlagRefreshPriceOnRetryAfterUpsell then nil else getResellers,
			getRobuxUpsellProductWithUniverseItemInfo = getRobuxUpsellProductWithUniverseItemInfo,
			postPremiumImpression = postPremiumImpression,
			getPremiumUpsellPrecheck = getPremiumUpsellPrecheck,
			getPurchaseWarning = getPurchaseWarning,
			postPurchaseWarningAcknowledge = postPurchaseWarningAcknowledge,
			checkUserPurchaseSettings = checkUserPurchaseSettings,
			getUnifiedPurchaseFlowUserEligibility = getUnifiedPurchaseFlowUserEligibility,
			getSubscriptionProductInfo = getSubscriptionProductInfo,
			GetLookDetailsV2ProductInfo = GetLookDetailsV2ProductInfo
		}
	end

	setmetatable(t2, {
		__tostring = function() -- line: 341
			return "MockService(Network)"
		end
	})

	return t2
end

return t1
