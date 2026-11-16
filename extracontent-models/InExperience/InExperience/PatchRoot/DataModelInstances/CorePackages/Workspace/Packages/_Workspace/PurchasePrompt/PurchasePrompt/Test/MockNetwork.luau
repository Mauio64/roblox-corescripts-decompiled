local parent = script.Parent.Parent
local Promise = require(parent.Promise)

local PurchaseWarning = require(parent.Enums.PurchaseWarning)

local FFlagRefreshPriceOnRetryAfterUpsell = require(parent.Flags.FFlagRefreshPriceOnRetryAfterUpsell)

local function getABTestGroup()
	return Promise.resolve(false)
end

local function getProductInfo(_, _)
	return Promise.resolve({
		AssetId = 1,
		AssetTypeId = 2,
		ContentRatingTypeId = 0,
		Creator = { CreatorType = "Group", CreatorTargetId = 1, Name = "ROBLOX", Id = 1 },
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
		ProductId = 1
	})
end

local function getPlayerOwns(_, _, _)
	return Promise.resolve(false)
end

local function performPurchase(_, _, _, _)
	return Promise.resolve({ success = true, purchased = true, receipt = "fake-receipt-hash" })
end

local function loadAssetForEquip(_)
	return Promise.resolve(Instance.new("Tool"))
end

local function getAccountInfo()
	return Promise.resolve({ isPremium = false })
end

local function getBalanceInfo()
	return Promise.resolve({ robux = 2147483647 })
end

local function getBundleDetails(_)
	return Promise.resolve({
		id = 1,
		name = "mock-name",
		description = "mock-description",
		items = {
			{ id = 1, name = "outfit-name", type = "UserOutfit" }
		},
		creator = { id = 1, name = "ROBLOX", type = "User" },
		product = { id = 1, isForSale = true, priceInRobux = 100 }
	})
end

local function getProductPurchasableDetails(_)
	return Promise.resolve({ purchasable = false, reason = "mock-reason", price = 100 })
end

local function getCatalogItemDetails(_: number, _: string)
	return Promise.resolve({
		bundleType = 1,
		bundledItems = {
			{ id = 10001, name = "Mock bundle - Left Arm", owned = true, type = "Asset" },
			{ id = 1002, name = "Mock bundle - Right Leg", owned = true, type = "Asset" },
			{ id = 1003, name = "Mock bundle - Right Arm", owned = true, type = "Asset" },
			{ id = 1004, name = "Mock bundle - Left Leg", owned = true, type = "Asset" },
			{ id = 1005, name = "Mock bundle - Dynamic Head", owned = true, type = "Asset" },
			{ id = 1006, name = "Default Mood", owned = true, type = "Asset" },
			{ id = 1007, name = "Mock bundle - Torso", owned = true, type = "Asset" },
			{ id = 1008, name = "Mock item", owned = true, type = "UserOutfit" },
			{ id = 1009, name = "Mock bundle Head", owned = true, type = "UserOutfit" }
		},
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
		itemRestrictions = {},
		itemStatus = {},
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
		unitsAvailableForConsumption = 0
	})
end

local function getResellers(_: string, _: number?)
	return Promise.resolve({ data = {}, nextPageCursor = nil })
end

local function getRobuxUpsellProductWithUniverseItemInfo(_, _, _, _, _, _)
	return Promise.resolve({
		roblox_product_id = 50,
		provider_product_id = "robux50",
		roblox_product_name = "providerRobux50",
		robux_amount = 500
	})
end

local function getPurchaseWarning(_)
	return Promise.resolve({ action = PurchaseWarning.NoAction })
end

local function postPurchaseWarningAcknowledge()
	return Promise.resolve()
end

local function checkUserPurchaseSettings()
	return Promise.resolve({ isEligible = false, failureReason = "PurchaseNotEnabled" })
end

local function getUnifiedPurchaseFlowUserEligibility()
	return Promise.resolve({ isUserEligibleForUnifiedPurchaseFlow = true, expiresInSeconds = 120 })
end

local function getSubscriptionProductInfo(_)
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

local function GetLookDetailsV2ProductInfo(_)
	return Promise.resolve({
		look = {
			items = {
				{ id = 1, itemType = "Asset", priceInRobux = 100 }
			}
		}
	})
end

local MockNetwork = {}
MockNetwork.__index = MockNetwork

function MockNetwork.new(p, p2)
	local v

	if p2 or p then
		local function fn()
			if p then
				return Promise.resolve(p)
			end

			return Promise.reject(p2)
		end

		v = {
			getABTestGroup = fn,
			getProductInfo = fn,
			getPlayerOwns = fn,
			performPurchase = fn,
			loadAssetForEquip = fn,
			getAccountInfo = fn,
			getBalanceInfo = fn,
			getBundleDetails = fn,
			getProductPurchasableDetails = fn,
			getCatalogItemDetails = 0,
			getResellers = 0,
			getRobuxUpsellProductWithUniverseItemInfo = 0,
			getPurchaseWarning = 0,
			postPurchaseWarningAcknowledge = 0,
			checkUserPurchaseSettings = 0,
			getUnifiedPurchaseFlowUserEligibility = 0,
			getSubscriptionProductInfo = 0
		}
		local getCatalogItemDetails2

		if FFlagRefreshPriceOnRetryAfterUpsell then
			getCatalogItemDetails2 = fn
		end

		v.getCatalogItemDetails = getCatalogItemDetails2
		local getResellers2

		if FFlagRefreshPriceOnRetryAfterUpsell then
			getResellers2 = fn
		end

		v.getResellers = getResellers2
		v.getRobuxUpsellProductWithUniverseItemInfo = fn
		v.getPurchaseWarning = fn
		v.postPurchaseWarningAcknowledge = fn
		v.checkUserPurchaseSettings = fn
		v.getUnifiedPurchaseFlowUserEligibility = fn
		v.getSubscriptionProductInfo = fn
	else
		v = {
			getABTestGroup = getABTestGroup,
			getProductInfo = getProductInfo,
			getPlayerOwns = getPlayerOwns,
			performPurchase = performPurchase,
			loadAssetForEquip = loadAssetForEquip,
			getAccountInfo = getAccountInfo,
			getBalanceInfo = getBalanceInfo,
			getBundleDetails = getBundleDetails,
			getProductPurchasableDetails = getProductPurchasableDetails,
			getCatalogItemDetails = 0,
			getResellers = 0,
			getRobuxUpsellProductWithUniverseItemInfo = 0,
			getPurchaseWarning = 0,
			postPurchaseWarningAcknowledge = 0,
			checkUserPurchaseSettings = 0,
			getUnifiedPurchaseFlowUserEligibility = 0,
			getSubscriptionProductInfo = 0,
			GetLookDetailsV2ProductInfo = 0
		}
		local getCatalogItemDetails2

		if FFlagRefreshPriceOnRetryAfterUpsell then
			getCatalogItemDetails2 = getCatalogItemDetails
		end

		v.getCatalogItemDetails = getCatalogItemDetails2
		local getResellers2

		if FFlagRefreshPriceOnRetryAfterUpsell then
			getResellers2 = getResellers
		end

		v.getResellers = getResellers2
		v.getRobuxUpsellProductWithUniverseItemInfo = getRobuxUpsellProductWithUniverseItemInfo
		v.getPurchaseWarning = getPurchaseWarning
		v.postPurchaseWarningAcknowledge = postPurchaseWarningAcknowledge
		v.checkUserPurchaseSettings = checkUserPurchaseSettings
		v.getUnifiedPurchaseFlowUserEligibility = getUnifiedPurchaseFlowUserEligibility
		v.getSubscriptionProductInfo = getSubscriptionProductInfo
		v.GetLookDetailsV2ProductInfo = GetLookDetailsV2ProductInfo
	end

	setmetatable(v, {
		__tostring = function(): string
			return "MockService(Network)"
		end
	})

	return v
end

return MockNetwork
