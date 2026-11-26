local CorePackages = game:GetService("CorePackages")

local t = require(CorePackages.Packages.t)

local fFlagFixOffSaleCurrentlyWearingItemNavigation = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagFixOffSaleCurrentlyWearingItemNavigation
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local itemLicenseType = require("@luauforge/bundled/dPt").Enums.ItemLicenseType
local fFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local fFlagAXAddHDRowInItemDetailsPage = AvatarExperienceFlags.FFlagAXAddHDRowInItemDetailsPage
local fFlagAXBackgroundGeneration = AvatarExperienceFlags.FFlagAXBackgroundGeneration
local fFlagAXMarketplaceLicensing = AvatarExperienceFlags.FFlagAXMarketplaceLicensing
local fFlagAXMarketplaceLicensingItemDetails = AvatarExperienceFlags.FFlagAXMarketplaceLicensingItemDetails

local strictInterface = t.strictInterface
local v5 = {
	id = t.optional(t.string),
	licenseType = t.literal(itemLicenseType.FirstParty, itemLicenseType.ThirdParty),
	badgeAssetId = t.optional(t.string),
	name = t.optional(t.string),
	licenseHolder = t.optional(t.string),
	licenseDisplayName = 0
}
local v6 = if fFlagAXMarketplaceLicensingItemDetails then t.optional(t.string) else nil
v5.licenseDisplayName = v6
local v7 = strictInterface(v5)

local strictInterface2 = t.strictInterface
local v8 = {}
v8.receivedCatalogData = t.optional(t.boolean)
v8.receivedRecommendedData = t.optional(t.boolean)
v8.receivedFromRecommendedData = t.optional(t.boolean)
v8.receivedFromBundleItemData = t.optional(t.boolean)
v8.receivedFromInventoryFetch = t.optional(t.boolean)
v8.receivedFromOutfitDetails = t.optional(t.boolean)
v8.receivedFromResaleData = t.optional(t.boolean)
v8.receivedFromSortResults = t.optional(t.boolean)

v8.receivedFromVersionData = t.optional(t.boolean)
v8.receivedBundleDetails = t.optional(t.boolean)
v8.receivedWidgetHydration = t.optional(t.boolean)

v8.name = t.string
v8.id = t.string

v8.description = t.optional(t.string)
v8.creatorName = t.optional(t.string)
v8.assetType = t.optional(t.string)
v8.bundleType = t.optional(t.string)
v8.itemType = t.optional(t.string)

v8.items = t.optional(t.array(t.strictInterface({
	owned = t.optional(t.boolean),
	id = t.string,
	name = t.optional(t.string),
	assetType = t.optional(t.string),
	type = t.string
})))

v8.priceInRobux = t.optional(t.integer)
v8.creator = t.optional(t.strictInterface({
	id = t.optional(t.string),
	name = t.optional(t.string),
	type = t.optional(t.string),
	targetId = t.optional(t.string),
	hasVerifiedBadge = t.optional(t.boolean)
}))

v8.created = t.optional(t.string)
v8.updated = t.optional(t.string)
v8.genres = t.optional(t.array(t.string))

v8.minimumMembershipLevel = t.optional(t.integer)
v8.premiumPricing = t.optional(t.strictInterface({
	premiumDiscountPercentage = t.optional(t.number),
	premiumPriceInRobux = t.optional(t.integer)
}))

v8.product = t.optional(t.strictInterface({
	id = t.string,
	type = t.optional(t.string),
	isForSale = t.optional(t.boolean)
}))

v8.recommendedItemSummaries = t.optional(t.array(t.strictInterface({
	id = t.string,
	type = t.string,
	subType = t.string,
	gridInformation = t.optional(t.table)
})))

v8.favoriteCount = t.optional(t.integer)
v8.priceStatus = t.optional(t.string)
v8.itemRestrictions = t.optional(t.map(t.string, t.boolean))
v8.tileRestrictionsMap = t.optional(t.map(t.userdata, t.boolean))
v8.itemStatus = t.optional(t.array(t.string))
v8.lowestPrice = t.optional(t.integer)
v8.lowestResalePrice = t.optional(t.integer)
v8.numberRobloxHasAvailable = t.optional(t.integer)
v8.totalQuantity = t.optional(t.integer)

v8.resellerUserAssetIds = t.optional(t.array(t.string))

v8.soldCount = t.optional(t.integer)
v8.averagePrice = t.optional(t.integer)
v8.originalPrice = t.optional(t.integer)

v8.discountInformation = t.optional(t.table)

v8.isForRent = t.optional(t.boolean)
v8.isOwned = t.optional(t.boolean)
local v9 = if fFlagAXBackgroundGeneration then t.optional(t.boolean) else nil
v8.isPlusExclusive = v9
v8.supportsHeadShapes = t.optional(t.boolean)
v8.isPurchasable = t.optional(t.boolean)
v8.isPublicDomain = t.optional(t.boolean)
local v10 = if fFlagAXAddHDRowInItemDetailsPage then t.optional(t.boolean) else nil
v8.isHighDefinition = v10
v8.isPBR = t.optional(t.boolean)
v8.renderProperties = t.optional(t.array(t.string))

v8.expectedSellerId = t.optional(t.string)

v8.collectibleItemId = t.optional(t.string)

v8.saleLocationType = t.optional(t.string)
v8.hasResellers = t.optional(t.boolean)

v8.creatingUniverseId = t.optional(t.string)
v8.isRecolorable = t.optional(t.boolean)
local v11 = if fFlagFixOffSaleCurrentlyWearingItemNavigation then t.optional(t.boolean) else nil
v8.isOffSale = v11
v8.variantAttributes = t.optional(t.table)
v8.relatedVariants = t.optional(t.table)
v8.timedOptions = t.optional(t.table)

v8.taxonomy = t.optional(t.table)

local v12 = if fFlagAXMarketplaceLicensing then t.optional(v7) else nil
v8.itemLicensingInfo = v12

v8.moderationStatus = t.optional(t.enum(Enum.ModerationStatus))
v8.updateCounter = t.optional(t.number)
local v13 = if fFlagAXInventoryDurablesSupport then t.optional(t.string) else nil
v8.expirationTime = v13
return strictInterface2(v8)
