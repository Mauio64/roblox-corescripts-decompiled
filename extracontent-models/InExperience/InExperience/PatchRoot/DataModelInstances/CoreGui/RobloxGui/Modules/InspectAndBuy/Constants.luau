local CorePackages = game:GetService("CorePackages")
local FFlagAXInspectAndBuyMakeupSupport = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXInspectAndBuyMakeupSupport
local t1 = {
	NotificationKeys = {
		MultipleBundleNoticeKey = "InGame.InspectMenu.Description.MultipleBundlesNotice",
		SingleBundleNoticeKey = "InGame.InspectMenu.Description.SingleBundleNotice",
		LimitedItemNoticeKey = "InGame.InspectMenu.Description.LimitedNotice",
		LayeredClothingOnR6Key = "InGame.InspectMenu.Description.LayeredClothingR6"
	},
	ItemType = {
		Asset = "Asset",
		Bundle = "Bundle"
	},
	View = {
		Compact = 0,
		Wide = 1,
		WideLandscape = 2
	},
	AssetCategories = {
		Animation = "Animation",
		Body = "Body",
		Clothing = "Clothing",
		Accessory = "Accessory",
		Emotes = "Emotes",
		Makeup = if not FFlagAXInspectAndBuyMakeupSupport then nil else "Makeup"
	},
	AssetTypeIdStringToHumanoidDescriptionProp = {
		[tostring(Enum.AssetType.TShirt.Value)] = "GraphicTShirt",
		[tostring(Enum.AssetType.Hat.Value)] = "HatAccessory",
		[tostring(Enum.AssetType.Shirt.Value)] = "Shirt",
		[tostring(Enum.AssetType.Pants.Value)] = "Pants",
		[tostring(Enum.AssetType.Head.Value)] = "Head",
		[tostring(Enum.AssetType.Face.Value)] = "Face",
		[tostring(Enum.AssetType.Torso.Value)] = "Torso",
		[tostring(Enum.AssetType.RightArm.Value)] = "RightArm",
		[tostring(Enum.AssetType.LeftArm.Value)] = "LeftArm",
		[tostring(Enum.AssetType.LeftLeg.Value)] = "LeftLeg",
		[tostring(Enum.AssetType.RightLeg.Value)] = "RightLeg",
		[tostring(Enum.AssetType.HairAccessory.Value)] = "HairAccessory",
		[tostring(Enum.AssetType.FaceAccessory.Value)] = "FaceAccessory",
		[tostring(Enum.AssetType.NeckAccessory.Value)] = "NeckAccessory",
		[tostring(Enum.AssetType.ShoulderAccessory.Value)] = "ShouldersAccessory",
		[tostring(Enum.AssetType.FrontAccessory.Value)] = "FrontAccessory",
		[tostring(Enum.AssetType.BackAccessory.Value)] = "BackAccessory",
		[tostring(Enum.AssetType.WaistAccessory.Value)] = "WaistAccessory",
		[tostring(Enum.AssetType.ClimbAnimation.Value)] = "ClimbAnimation",
		[tostring(Enum.AssetType.FallAnimation.Value)] = "FallAnimation",
		[tostring(Enum.AssetType.IdleAnimation.Value)] = "IdleAnimation",
		[tostring(Enum.AssetType.JumpAnimation.Value)] = "JumpAnimation",
		[tostring(Enum.AssetType.RunAnimation.Value)] = "RunAnimation",
		[tostring(Enum.AssetType.SwimAnimation.Value)] = "SwimAnimation",
		[tostring(Enum.AssetType.WalkAnimation.Value)] = "WalkAnimation",
		[tostring(Enum.AssetType.DynamicHead.Value)] = "Head"
	},
	AnimationAssetTypes = {
		["48"] = 48,
		["50"] = 50,
		["51"] = 51,
		["52"] = 52,
		["53"] = 53,
		["54"] = 54,
		["55"] = 55,
		["61"] = 61,
		["78"] = 78
	},
	AssetTypeIdToAccessoryTypeEnum = {
		[tostring(Enum.AssetType.Hat.Value)] = Enum.AccessoryType.Hat,
		[tostring(Enum.AssetType.HairAccessory.Value)] = Enum.AccessoryType.Hair,
		[tostring(Enum.AssetType.FaceAccessory.Value)] = Enum.AccessoryType.Face,
		[tostring(Enum.AssetType.NeckAccessory.Value)] = Enum.AccessoryType.Neck,
		[tostring(Enum.AssetType.ShoulderAccessory.Value)] = Enum.AccessoryType.Shoulder,
		[tostring(Enum.AssetType.FrontAccessory.Value)] = Enum.AccessoryType.Front,
		[tostring(Enum.AssetType.BackAccessory.Value)] = Enum.AccessoryType.Back,
		[tostring(Enum.AssetType.WaistAccessory.Value)] = Enum.AccessoryType.Waist,
		[tostring(Enum.AssetType.TShirtAccessory.Value)] = Enum.AccessoryType.TShirt,
		[tostring(Enum.AssetType.ShirtAccessory.Value)] = Enum.AccessoryType.Shirt,
		[tostring(Enum.AssetType.PantsAccessory.Value)] = Enum.AccessoryType.Pants,
		[tostring(Enum.AssetType.JacketAccessory.Value)] = Enum.AccessoryType.Jacket,
		[tostring(Enum.AssetType.SweaterAccessory.Value)] = Enum.AccessoryType.Sweater,
		[tostring(Enum.AssetType.ShortsAccessory.Value)] = Enum.AccessoryType.Shorts,
		[tostring(Enum.AssetType.LeftShoeAccessory.Value)] = Enum.AccessoryType.LeftShoe,
		[tostring(Enum.AssetType.RightShoeAccessory.Value)] = Enum.AccessoryType.RightShoe,
		[tostring(Enum.AssetType.DressSkirtAccessory.Value)] = Enum.AccessoryType.DressSkirt,
		[tostring(Enum.AssetType.EyebrowAccessory.Value)] = Enum.AccessoryType.Eyebrow,
		[tostring(Enum.AssetType.EyelashAccessory.Value)] = Enum.AccessoryType.Eyelash
	},
	LayeredAssetTypes = {
		[tostring(Enum.AssetType.TShirtAccessory.Value)] = Enum.AccessoryType.TShirt,
		[tostring(Enum.AssetType.ShirtAccessory.Value)] = Enum.AccessoryType.Shirt,
		[tostring(Enum.AssetType.PantsAccessory.Value)] = Enum.AccessoryType.Pants,
		[tostring(Enum.AssetType.JacketAccessory.Value)] = Enum.AccessoryType.Jacket,
		[tostring(Enum.AssetType.SweaterAccessory.Value)] = Enum.AccessoryType.Sweater,
		[tostring(Enum.AssetType.ShortsAccessory.Value)] = Enum.AccessoryType.Shorts,
		[tostring(Enum.AssetType.LeftShoeAccessory.Value)] = Enum.AccessoryType.LeftShoe,
		[tostring(Enum.AssetType.RightShoeAccessory.Value)] = Enum.AccessoryType.RightShoe,
		[tostring(Enum.AssetType.DressSkirtAccessory.Value)] = Enum.AccessoryType.DressSkirt,
		[tostring(Enum.AssetType.HairAccessory.Value)] = Enum.AccessoryType.Hair,
		[tostring(Enum.AssetType.EyebrowAccessory.Value)] = Enum.AccessoryType.Eyebrow,
		[tostring(Enum.AssetType.EyelashAccessory.Value)] = Enum.AccessoryType.Eyelash
	},
	AssetCategory = {
		Tops = "Tops",
		Bottoms = "Bottoms"
	}
}

t1.AssetTypeIdToCategory = {
	[tostring(Enum.AssetType.TShirt.Value)] = t1.AssetCategories.Clothing,
	[tostring(Enum.AssetType.Hat.Value)] = t1.AssetCategories.Accessory,
	[tostring(Enum.AssetType.HairAccessory.Value)] = t1.AssetCategories.Accessory,
	[tostring(Enum.AssetType.FaceAccessory.Value)] = t1.AssetCategories.Accessory,
	[tostring(Enum.AssetType.NeckAccessory.Value)] = t1.AssetCategories.Accessory,
	[tostring(Enum.AssetType.ShoulderAccessory.Value)] = t1.AssetCategories.Accessory,
	[tostring(Enum.AssetType.FrontAccessory.Value)] = t1.AssetCategories.Accessory,
	[tostring(Enum.AssetType.BackAccessory.Value)] = t1.AssetCategories.Accessory,
	[tostring(Enum.AssetType.WaistAccessory.Value)] = t1.AssetCategories.Accessory,
	[tostring(Enum.AssetType.Shirt.Value)] = t1.AssetCategories.Clothing,
	[tostring(Enum.AssetType.Pants.Value)] = t1.AssetCategories.Clothing,
	[tostring(Enum.AssetType.Gear.Value)] = t1.AssetCategories.Accessory,
	[tostring(Enum.AssetType.Head.Value)] = t1.AssetCategories.Body,
	[tostring(Enum.AssetType.Face.Value)] = t1.AssetCategories.Body,
	[tostring(Enum.AssetType.Torso.Value)] = t1.AssetCategories.Body,
	[tostring(Enum.AssetType.RightArm.Value)] = t1.AssetCategories.Body,
	[tostring(Enum.AssetType.LeftArm.Value)] = t1.AssetCategories.Body,
	[tostring(Enum.AssetType.LeftLeg.Value)] = t1.AssetCategories.Body,
	[tostring(Enum.AssetType.RightLeg.Value)] = t1.AssetCategories.Body,
	[tostring(Enum.AssetType.ClimbAnimation.Value)] = t1.AssetCategories.Animation,
	[tostring(Enum.AssetType.FallAnimation.Value)] = t1.AssetCategories.Animation,
	[tostring(Enum.AssetType.IdleAnimation.Value)] = t1.AssetCategories.Animation,
	[tostring(Enum.AssetType.JumpAnimation.Value)] = t1.AssetCategories.Animation,
	[tostring(Enum.AssetType.RunAnimation.Value)] = t1.AssetCategories.Animation,
	[tostring(Enum.AssetType.SwimAnimation.Value)] = t1.AssetCategories.Animation,
	[tostring(Enum.AssetType.WalkAnimation.Value)] = t1.AssetCategories.Animation,
	[tostring(Enum.AssetType.EmoteAnimation.Value)] = t1.AssetCategories.Animation,
	[tostring(Enum.AssetType.TShirtAccessory.Value)] = t1.AssetCategories.Accessory,
	[tostring(Enum.AssetType.ShirtAccessory.Value)] = t1.AssetCategories.Accessory,
	[tostring(Enum.AssetType.PantsAccessory.Value)] = t1.AssetCategories.Accessory,
	[tostring(Enum.AssetType.JacketAccessory.Value)] = t1.AssetCategories.Accessory,
	[tostring(Enum.AssetType.SweaterAccessory.Value)] = t1.AssetCategories.Accessory,
	[tostring(Enum.AssetType.ShortsAccessory.Value)] = t1.AssetCategories.Accessory,
	[tostring(Enum.AssetType.LeftShoeAccessory.Value)] = t1.AssetCategories.Accessory,
	[tostring(Enum.AssetType.RightShoeAccessory.Value)] = t1.AssetCategories.Accessory,
	[tostring(Enum.AssetType.DressSkirtAccessory.Value)] = t1.AssetCategories.Accessory,
	[tostring(Enum.AssetType.EyelashAccessory.Value)] = t1.AssetCategories.Accessory,
	[tostring(Enum.AssetType.EyebrowAccessory.Value)] = t1.AssetCategories.Accessory,
	[tostring(Enum.AssetType.MoodAnimation.Value)] = t1.AssetCategories.Animation,
	[tostring(Enum.AssetType.DynamicHead.Value)] = t1.AssetCategories.Body
}

if FFlagAXInspectAndBuyMakeupSupport then
	t1.AssetTypeIdToCategory[tostring(Enum.AssetType.EyeMakeup.Value)] = t1.AssetCategories.Makeup
	t1.AssetTypeIdToCategory[tostring(Enum.AssetType.FaceMakeup.Value)] = t1.AssetCategories.Makeup
	t1.AssetTypeIdToCategory[tostring(Enum.AssetType.LipMakeup.Value)] = t1.AssetCategories.Makeup
end

t1.AssetCategoriesLocalized = {
	[t1.AssetCategories.Animation] = "Feature.Catalog.Label.Animation",
	[t1.AssetCategories.Body] = "Feature.Catalog.Label.Body",
	[t1.AssetCategories.Clothing] = "Feature.Avatar.Heading.Clothing",
	[t1.AssetCategories.Accessory] = "Feature.Avatar.Label.Accessory",
	[t1.AssetCategories.Emotes] = "Feature.Catalog.Label.Emotes"
}

if FFlagAXInspectAndBuyMakeupSupport then
	t1.AssetCategoriesLocalized[t1.AssetCategories.Makeup] = "Feature.Catalog.Label.Makeup"
end

t1.AssetTypeIdToTypeLocalized = {
	[tostring(Enum.AssetType.TShirt.Value)] = "Feature.Avatar.Label.ClassicTShirts",
	[tostring(Enum.AssetType.Hat.Value)] = "Feature.Avatar.Label.Hat",
	[tostring(Enum.AssetType.HairAccessory.Value)] = "Feature.Avatar.Label.Hair",
	[tostring(Enum.AssetType.FaceAccessory.Value)] = "Feature.Avatar.Label.Face",
	[tostring(Enum.AssetType.NeckAccessory.Value)] = "Feature.Avatar.Label.Neck",
	[tostring(Enum.AssetType.ShoulderAccessory.Value)] = "Feature.Avatar.Label.Shoulder",
	[tostring(Enum.AssetType.FrontAccessory.Value)] = "Feature.Avatar.Label.Front",
	[tostring(Enum.AssetType.BackAccessory.Value)] = "Feature.Avatar.Label.Back",
	[tostring(Enum.AssetType.WaistAccessory.Value)] = "Feature.Avatar.Label.Waist",
	[tostring(Enum.AssetType.Shirt.Value)] = "Feature.Avatar.Label.ClassicShirts",
	[tostring(Enum.AssetType.Pants.Value)] = "Feature.Avatar.Label.ClassicPants",
	[tostring(Enum.AssetType.Gear.Value)] = "Feature.Avatar.Label.Gear",
	[tostring(Enum.AssetType.Head.Value)] = "Feature.Avatar.Label.Head",
	[tostring(Enum.AssetType.Face.Value)] = "Feature.Avatar.Label.Face",
	[tostring(Enum.AssetType.Torso.Value)] = "Feature.Avatar.Label.Torso",
	[tostring(Enum.AssetType.RightArm.Value)] = "Feature.Avatar.Label.RightArms",
	[tostring(Enum.AssetType.LeftArm.Value)] = "Feature.Avatar.Label.LeftArms",
	[tostring(Enum.AssetType.LeftLeg.Value)] = "Feature.Avatar.Label.LeftLegs",
	[tostring(Enum.AssetType.RightLeg.Value)] = "Feature.Avatar.Label.RightLegs",
	[tostring(Enum.AssetType.ClimbAnimation.Value)] = "Feature.Avatar.Label.Climb",
	[tostring(Enum.AssetType.FallAnimation.Value)] = "Feature.Avatar.Label.Fall",
	[tostring(Enum.AssetType.IdleAnimation.Value)] = "Feature.Avatar.Label.Idle",
	[tostring(Enum.AssetType.JumpAnimation.Value)] = "Feature.Avatar.Label.Jump",
	[tostring(Enum.AssetType.RunAnimation.Value)] = "Feature.Avatar.Label.Run",
	[tostring(Enum.AssetType.SwimAnimation.Value)] = "Feature.Avatar.Label.Swim",
	[tostring(Enum.AssetType.WalkAnimation.Value)] = "Feature.Avatar.Label.Walk",
	[tostring(Enum.AssetType.EmoteAnimation.Value)] = "Feature.Avatar.Label.Emote",
	[tostring(Enum.AssetType.TShirtAccessory.Value)] = "Feature.Avatar.Label.TShirt",
	[tostring(Enum.AssetType.ShirtAccessory.Value)] = "Feature.Avatar.Label.Shirt",
	[tostring(Enum.AssetType.PantsAccessory.Value)] = "Feature.Avatar.Label.Pants",
	[tostring(Enum.AssetType.JacketAccessory.Value)] = "Feature.Avatar.Label.Jacket",
	[tostring(Enum.AssetType.SweaterAccessory.Value)] = "Feature.Avatar.Label.Sweater",
	[tostring(Enum.AssetType.ShortsAccessory.Value)] = "Feature.Avatar.Label.Shorts",
	[tostring(Enum.AssetType.LeftShoeAccessory.Value)] = "Feature.Avatar.Label.LeftShoe",
	[tostring(Enum.AssetType.RightShoeAccessory.Value)] = "Feature.Avatar.Label.RightShoe",
	[tostring(Enum.AssetType.DressSkirtAccessory.Value)] = "Feature.Avatar.Label.DressesAndSkirts",
	[tostring(Enum.AssetType.EyelashAccessory.Value)] = "Feature.Catalog.Label.Eyelash",
	[tostring(Enum.AssetType.EyebrowAccessory.Value)] = "Feature.Catalog.Label.Eyebrow",
	[tostring(Enum.AssetType.MoodAnimation.Value)] = "Feature.Avatar.Label.Mood",
	[tostring(Enum.AssetType.DynamicHead.Value)] = "Feature.Avatar.Label.DynamicHead"
}

if FFlagAXInspectAndBuyMakeupSupport then
	t1.AssetTypeIdToTypeLocalized[tostring(Enum.AssetType.EyeMakeup.Value)] = "Feature.Catalog.Label.EyeMakeup"
	t1.AssetTypeIdToTypeLocalized[tostring(Enum.AssetType.FaceMakeup.Value)] = "Feature.Catalog.Label.FaceMakeup"
	t1.AssetTypeIdToTypeLocalized[tostring(Enum.AssetType.LipMakeup.Value)] = "Feature.Catalog.Label.LipMakeup"
end

t1.MoodAnimationAssetTypeId = "78"
t1.DynamicHeadAssetTypeId = "79"
t1.DetailsThumbnailFrameHeight = 250
t1.LimitedIconFrameSizeXOffset = 9
t1.LimitedIconFrameSizeYOffset = 4
t1.DynamicHeadAssetTypes = {
	[tostring(Enum.AssetType.EyebrowAccessory.Value)] = true,
	[tostring(Enum.AssetType.EyelashAccessory.Value)] = true,
	[t1.MoodAnimationAssetTypeId] = true,
	[t1.DynamicHeadAssetTypeId] = true
}
t1.AccessoryTypeEnumToAssetTypeId = {}

for k, v in pairs(t1.AssetTypeIdToAccessoryTypeEnum) do
	t1.AccessoryTypeEnumToAssetTypeId[v] = k
end

t1.AssetCategoryToAssetType = {
	[t1.AssetCategory.Tops] = {
		tostring(Enum.AssetType.ShirtAccessory.Value),
		tostring(Enum.AssetType.TShirtAccessory.Value),
		(tostring(Enum.AssetType.SweaterAccessory.Value))
	},
	[t1.AssetCategory.Bottoms] = {
		tostring(Enum.AssetType.PantsAccessory.Value),
		tostring(Enum.AssetType.ShortsAccessory.Value),
		(tostring(Enum.AssetType.DressSkirtAccessory.Value))
	}
}
t1.AssetTypeToAssetCategory = {}

for k, v in pairs(t1.AssetCategoryToAssetType) do
	for _, v2 in ipairs(v) do
		t1.AssetTypeToAssetCategory[v2] = k
	end
end

t1.LayeredClothingOrder = {
	[tostring(Enum.AssetType.Pants.Value)] = 0,
	[tostring(Enum.AssetType.Shirt.Value)] = 1,
	[tostring(Enum.AssetType.TShirt.Value)] = 2,
	[tostring(Enum.AssetType.LeftShoeAccessory.Value)] = 3,
	[tostring(Enum.AssetType.RightShoeAccessory.Value)] = 3,
	[tostring(Enum.AssetType.PantsAccessory.Value)] = 4,
	[tostring(Enum.AssetType.ShortsAccessory.Value)] = 5,
	[tostring(Enum.AssetType.DressSkirtAccessory.Value)] = 6,
	[tostring(Enum.AssetType.TShirtAccessory.Value)] = 7,
	[tostring(Enum.AssetType.ShirtAccessory.Value)] = 8,
	[tostring(Enum.AssetType.SweaterAccessory.Value)] = 9,
	[tostring(Enum.AssetType.JacketAccessory.Value)] = 10,
	[tostring(Enum.AssetType.HairAccessory.Value)] = 11,
	[tostring(Enum.AssetType.EyebrowAccessory.Value)] = 3,
	[tostring(Enum.AssetType.EyelashAccessory.Value)] = 3
}
t1.ProductType = {
	CollectibleItem = "Collectible Item"
}
t1.ItemRestrictions = {
	Limited = "Limited",
	LimitedUnique = "LimitedUnique",
	Collectible = "Collectible"
}
t1.SaleStatus = {
	OnSale = "OnSale"
}
t1.SaleLocationType = {
	Invalid = 0,
	ShopOnly = 1,
	MyExperiencesOnly = 2,
	ShopAndMyExperiences = 3,
	ExperiencesById = 4,
	ShopAndAllExperiences = 5,
	ExperiencesDevApiOnly = 6,
	ShopAndExperiencesById = 7
}
t1.CounterSuffix = {
	RequestSucceeded = "RequestSucceeded",
	RequestRejected = "RequestRejected",
	RequestFailed = "RequestFailed"
}
t1.Counters = {
	CreateFavoriteForAsset = "CreateFavoriteForAsset",
	CreateFavoriteForBundle = "CreateFavoriteForBundle",
	DeleteFavoriteForAsset = "DeleteFavoriteForAsset",
	DeleteFavoriteForBundle = "DeleteFavoriteForBundle",
	GetAssetBundles = "GetAssetBundles",
	GetAssetFavoriteCount = "GetAssetFavoriteCount",
	GetBundleFavoriteCount = "GetBundleFavoriteCount",
	GetCharacterModelFromUserId = "GetCharacterModelFromUserId",
	GetCollectibleResellableInstances = "GetCollectibleResellableInstances",
	GetCollectibleResellableInstancesRequestSucceededWithoutResult = "GetCollectibleResellableInstancesRequestSucceededWithoutResult",
	GetEconomyProductInfo = "GetEconomyV1DeprecatedProductInfo",
	GetExperienceInfo = "GetExperienceInfo",
	GetExperiencePlayability = "GetExperiencePlayability",
	GetFavoriteForAsset = "GetFavoriteForAsset",
	GetFavoriteForBundle = "GetFavoriteForBundle",
	GetItemDetails = "GetItemDetails",
	GetItemDetailsRespondedWithUnknownItemType = "GetItemDetailsRespondedWithUnknownItemType",
	GetPlayerName = "GetPlayerName",
	GetProductInfo = "MarketplaceServiceGetProductInfo",
	GetVersionInfo = "GetVersionInfo",
	PromptLimitedCollectiblesPurchase = "PromptLimitedCollectiblesPurchase",
	PromptBundlePurchase = "PromptBundlePurchase",
	PromptUnlimitedCollectiblePurchase = "PromptUnlimitedCollectiblePurchase",
	PromptRobloxPurchase = "PromptRobloxPurchase",
	PromptPurchaseUnknownItemType = "PromptPurchaseUnknownItemType",
	PurchaseSucceededBundle = "PurchaseSucceededBundle",
	PurchaseSucceededAsset = "PurchaseSucceededAsset",
	PurchaseSucceededOther = "PurchaseSucceededOther",
	PurchaseFinished = "PurchaseFinished",
	ItemDetailPageOpened = "ItemDetailPageOpened",
	TryOnButtonClicked = "TryOnButtonClicked",
	GetAvatarPreview = "GetAvatarPreview",
	BatchGetAssets = "BatchGetAssets",
	BatchGetItemDetails = "BatchGetItemDetails"
}

return t1
