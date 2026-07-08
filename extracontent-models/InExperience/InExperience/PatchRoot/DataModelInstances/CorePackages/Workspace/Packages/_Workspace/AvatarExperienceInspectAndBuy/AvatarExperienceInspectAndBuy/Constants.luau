local AvatarExperienceInspectAndBuy = script:FindFirstAncestor("AvatarExperienceInspectAndBuy")
local AvatarExperienceInspectAndBuyParent = AvatarExperienceInspectAndBuy.Parent
local AvatarExperienceFlags = require(AvatarExperienceInspectAndBuyParent.AvatarExperienceFlags)
local FFlagAXInspectAndBuyMakeupSupport = AvatarExperienceFlags.FFlagAXInspectAndBuyMakeupSupport
local FFlagAXCatalogBackgroundsSupport = AvatarExperienceFlags.FFlagAXCatalogBackgroundsSupport
local t1 = {}
local PriceStatus = require(AvatarExperienceInspectAndBuy.Enums.PriceStatus)

t1.AssetLocalizationKeys = {
	[tostring(Enum.AssetType.Hat.Value)] = "Feature.Avatar.Label.Hat",
	[tostring(Enum.AssetType.HairAccessory.Value)] = "Feature.Avatar.Label.Hair",
	[tostring(Enum.AssetType.FaceAccessory.Value)] = "Feature.Avatar.Label.Face",
	[tostring(Enum.AssetType.NeckAccessory.Value)] = "Feature.Avatar.Label.Neck",
	[tostring(Enum.AssetType.ShoulderAccessory.Value)] = "Feature.Avatar.Label.Shoulder",
	[tostring(Enum.AssetType.FrontAccessory.Value)] = "Feature.Avatar.Label.Front",
	[tostring(Enum.AssetType.BackAccessory.Value)] = "Feature.Avatar.Label.Back",
	[tostring(Enum.AssetType.WaistAccessory.Value)] = "Feature.Avatar.Label.Waist",
	[tostring(Enum.AssetType.TShirtAccessory.Value)] = "Feature.Avatar.Label.TShirt",
	[tostring(Enum.AssetType.ShirtAccessory.Value)] = "Feature.Avatar.Label.Shirt",
	[tostring(Enum.AssetType.Shirt.Value)] = "Feature.Catalog.Feature.Catalog.Label.ClassicShirt",
	[tostring(Enum.AssetType.TShirt.Value)] = "Feature.Catalog.Feature.Catalog.Label.ClassicTShirt",
	[tostring(Enum.AssetType.PantsAccessory.Value)] = "Feature.Avatar.Label.Pants",
	[tostring(Enum.AssetType.Pants.Value)] = "Feature.Avatar.Label.ClassicPants",
	[tostring(Enum.AssetType.JacketAccessory.Value)] = "Feature.Avatar.Label.Jacket",
	[tostring(Enum.AssetType.SweaterAccessory.Value)] = "Feature.Avatar.Label.Sweater",
	[tostring(Enum.AssetType.ShortsAccessory.Value)] = "Feature.Avatar.Label.Shorts",
	[tostring(Enum.AssetType.DressSkirtAccessory.Value)] = "Feature.Avatar.Label.DressesAndSkirts",
	[tostring(Enum.AssetType.EmoteAnimation.Value)] = "Feature.Avatar.Label.Emote",
	[tostring(Enum.AssetType.Face.Value)] = "Feature.Avatar.Label.ClassicFaces",
	[tostring(Enum.AssetType.Head.Value)] = "Feature.Avatar.Label.ClassicHeads"
}

if FFlagAXInspectAndBuyMakeupSupport then
	t1.AssetLocalizationKeys[tostring(Enum.AssetType.EyeMakeup.Value)] = "Feature.Catalog.Label.EyeMakeup"
	t1.AssetLocalizationKeys[tostring(Enum.AssetType.FaceMakeup.Value)] = "Feature.Catalog.Label.FaceMakeup"
	t1.AssetLocalizationKeys[tostring(Enum.AssetType.LipMakeup.Value)] = "Feature.Catalog.Label.LipMakeup"
end

if FFlagAXCatalogBackgroundsSupport then
	t1.AssetLocalizationKeys[tostring(Enum.AssetType.AvatarBackground.Value)] = "Feature.Avatar.Label.Backgrounds"
end

t1.BundleLocalizationKeys = {
	[tostring(Enum.BundleType.BodyParts.Value)] = "Feature.Catalog.Label.Body",
	[tostring(Enum.BundleType.Animations.Value)] = "Feature.Catalog.Label.Animation",
	[tostring(Enum.BundleType.Shoes.Value)] = "Feature.Avatar.Label.Shoes",
	[tostring(Enum.BundleType.DynamicHead.Value)] = "Feature.Avatar.Label.DynamicHead"
}

local t2 = {
	[PriceStatus.Owned] = "Feature.Catalog.Label.Owned",
	[PriceStatus.Free] = "Feature.Catalog.LabelFree",
	[PriceStatus.QuantityLimitReached] = "InGame.InspectMenu.Action.LimitReached",
	[PriceStatus.SoldOut] = "InGame.InspectMenu.Action.SoldOut",
	[PriceStatus.OffSale] = "Feature.Catalog.LabelOffSale",
	[PriceStatus.Unavailable] = "Feature.Catalog.Label.Checkout.Unavailable",
	[PriceStatus.InExperienceOnly] = "Feature.Catalog.Label.InSingleExperience",
	[PriceStatus.PurchaseFromRoblox] = "Feature.Catalog.Heading.BuyItem",
	[PriceStatus.PurchaseFromResale] = "Feature.Catalog.Heading.BuyItem"
}
local t3 = {
	category = "Feature.Catalog.Label.Category",
	quantitySold = "Feature.Catalog.Label.QuantitySold",
	originalPrice = "Feature.Catalog.Label.OriginalPrice",
	tryOn = "InGame.InspectMenu.Action.TryOn",
	tradeable = "Feature.Catalog.Label.Tradable",
	yes = "Feature.Catalog.Label.Yes",
	no = "Feature.Catalog.Label.No",
	ownedItems = "InGame.InspectMenu.Label.OwnedItems",
	na = "Feature.Catalog.Label.NA",
	includedParts = "Feature.Catalog.Label.IncludedParts",
	madein = "Feature.Catalog.Label.Attribution"
}

t1.PriceStatusLocalizationKeys = t2
t1.ItemDetailsLocalizationKeys = t3
t1.BatchItemDetailsPerformFetchKey = "BatchItemDetailsV2"
t1.ShowPlayableAttributionMapper = {
	UnplayableOtherReason = true,
	Playable = true,
	GuestProhibited = true,
	GameUnapproved = false,
	IncorrectConfiguration = false,
	UniverseRootPlaceIsPrivate = false,
	InsufficientPermissionFriendsOnly = true,
	InsufficientPermissionGroupOnly = true,
	DeviceRestricted = true,
	UnderReview = true,
	PurchaseRequired = true,
	AccountRestricted = true,
	TemporarilyUnavailable = true,
	ComplianceBlocked = true,
	ContextualPlayabilityAgeRecommendationParentalControls = true,
	ContextualPlayabilityRegionalAvailability = true,
	ContextualPlayabilityRegionalCompliance = true,
	ContextualPlayabilityUnverifiedSeventeenPlusUser = true
}

return t1
