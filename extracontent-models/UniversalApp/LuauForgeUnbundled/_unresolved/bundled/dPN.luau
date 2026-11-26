local symbol = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Symbol
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module2 = require("@luauforge/bundled/dPt")
local cameraZoomRadius = module2.Constants.CameraZoomRadius
local focusType = module2.Enums.FocusType
local itemTypeEnum = module2.Enums.ItemTypeEnum
local fullView = AvatarExperienceCommon.Enums.FullView
require("@luauforge/bundled/dPs")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEnableSplitPane = SharedFlags.FFlagEnableSplitPane
local fFlagQRCodePageVisualRefresh = SharedFlags.FFlagQRCodePageVisualRefresh
local constants = AvatarExperienceCommon.Constants

local getFIntMaquettesAppPanelDistanceMultiplierPercentage = SharedFlags.GetFIntMaquettesAppPanelDistanceMultiplierPercentage

local module4 = require("@luauforge/bundled/dPO")
local module5 = require("@luauforge/bundled/dPP")

local defineFastInt = game:DefineFastInt("AXSponsoredItemsRow", 7)

local defineFastFlag = game:DefineFastFlag("AXEnableSearchLandingFocusedPageFullViewDefault", false)

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters
local fFlagAXRemoveLegacyTileLatencyStats = AvatarExperienceFlags.FFlagAXRemoveLegacyTileLatencyStats

local fFlagAXSlotsInventoryLoadableGridView = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXSlotsInventoryLoadableGridView
local module7 = require("@luauforge/bundled/dPS")
local fFlagParseHeadShapeFromAPIResponse = AvatarExperienceFlags.FFlagParseHeadShapeFromAPIResponse

local catalogCategories = module2.Enums.CatalogCategories

local fFlagAXIncreaseDefaultPeekViewHeight = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXIncreaseDefaultPeekViewHeight
local fFlagIncreaseMarketplaceContentHeight = SharedFlags.FFlagIncreaseMarketplaceContentHeight

local defineFastInt2 = game:DefineFastInt("AXCatalogMainNavHeight", 40)

local fFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local fFlagAXCatalogOffersBannerEnabled = AvatarExperienceFlags.FFlagAXCatalogOffersBannerEnabled
local fFlagAXMoveCatalogFilterToL1Navigation = AvatarExperienceFlags.FFlagAXMoveCatalogFilterToL1Navigation
local fFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local fFlagAXCatalogBackgroundsSupport = AvatarExperienceFlags.FFlagAXCatalogBackgroundsSupport

local defineFastFlag2 = game:DefineFastFlag("AXMigrateMainNavHeightToFInt", false)
local defineFastInt3 = game:DefineFastInt("AXMainNavHeight", 40)

local v5 = getFIntMaquettesAppPanelDistanceMultiplierPercentage() / 100

local v6 = {
	_150x150 = "w=150&h=150",
	_420x420 = "w=420&h=420",
	_300x450 = "w=300&h=450"
}

local v7 = {
	["WidgetListHorizontalMargin"] = nil,
	["WidgetListHorizontalMargin"] = nil,
	["WidgetListHorizontalMargin"] = nil,
	["WidgetListHorizontalMargin"] = nil,
	["WidgetListHorizontalMargin"] = nil,
	["WidgetListHorizontalMargin"] = nil,
	["WidgetListHorizontalMargin"] = nil,
	["WidgetListHorizontalMargin"] = nil,
	["WidgetListHorizontalMargin"] = nil,
	["WidgetListHorizontalMargin"] = nil,
	["WidgetListHorizontalMargin"] = nil,
	["WidgetListHorizontalMargin"] = nil,
	["WidgetListHorizontalMargin"] = nil,
	["WidgetListHorizontalMargin"] = nil,
	["WidgetListHorizontalMargin"] = nil,
	["WidgetListHorizontalMargin"] = nil,
	["WidgetListHorizontalMargin"] = nil,
	["WidgetListHorizontalMargin"] = nil,
	["WidgetListHorizontalMargin"] = nil,
	["WidgetListHorizontalMargin"] = nil,
	["WidgetListHorizontalMargin"] = nil,
	WidgetListHorizontalMargin = 15,
	WidgetListVerticalMargin = 10,
	PageButtonCornerRadius = 12,
	SponsoredItemsRow = defineFastInt,
	BackgroundsPlusUpsellRow = 1,
	CatalogThumbnailTypeToSize = { Asset = v6, BundleThumbnail = v6, Look = v6 },
	DefaultCatalogCategoryId = catalogCategories.Recommended:rawValue(),
	DeviceType = { Android = "Android", IOS = "iOS", Other = "Other" },
	BlockyBundleId = 356,
	NumRecommendedItems = 6,
	AnalyticsTag = "LuaAvatarExperience",
	ContentFeedAnalyticsTag = "ContentFeed",
	ProfileAnalyticsTag = "LuaProfile",
	DefaultRigPosition = Vector3.new(11.777739, 6.766531, 0.27431548),
	AvatarType = { R6 = "R6", R15 = "R15" },
	ItemPromptType = {
		OpenPurchasePrompt = "OpenPurchasePrompt",
		OpenGoToAvatarEditorPrompt = "OpenGoToAvatarEditorPrompt",
		OpenPremiumUpsellPrompt = "OpenPremiumUpsellPrompt",
		Disabled = "Disabled",
		SoldOut = "SoldOut"
	},
	ItemTilePadding = 10,
	ItemTileTitleMaxLines = 1,
	EditorItemTileTitleMaxLines = fFlagAXSlotsInventoryLoadableGridView and 1 or nil,
	ItemTileInnerPadding = 4,
	ItemTileTallAspectRatio = 0.7,
	ItemTileSquareAspectRatio = 1,
	LookTileAspectRatio = 0.7,
	CreatorNameItemTilePadding = 0,
	CreatorNameItemTileTitleMaxLines = 1,
	ImpressionsDetectionInterval = 1,
	AssetCategories = {
		Animation = "Animation",
		Body = "Body",
		Clothing = "Clothing",
		Accessory = "Accessory",
		Emotes = "Emotes"
	},
	PageType = {
		Normal = "Normal",
		Animation = "Animation",
		BodyColors = "BodyColors",
		BodyStyle = "BodyStyle",
		Avatars = "Avatars",
		MakeupLooks = "MakeupLooks",
		Emotes = "Emotes",
		Other = "Other",
		AllAnimation = "AllAnimation"
	},
	ParticleType = {
		CatalogToAvatarEditor = "CatalogToAvatarEditor",
		AvatarEditorToCatalog = "AvatarEditorToCatalog",
		None = "None"
	},
	BackgroundType = {
		LargerShapes = "LargerShapes",
		NoShapesNoWalls = "NoShapesNoWalls",
		Walls = "Walls"
	},
	NavigationDirection = { IS_LEFT = "IS_LEFT", IS_RIGHT = "IS_RIGHT" },
	ShimmerCardsToDisplay = 30,
	UserInventoryKey = "avatar.inventory.",
	OutfitsKey = "avatar.outfits.",
	OutfitInfoKey = "avatar.outfit.info.",
	RecommendedItemsKey = "avatar.recommendedItems.",
	GetAvatarRulesKey = "avatareditor.getavatarrules",
	SearchCatalogKey = "avatar.search.",
	AvatarHomeRecKey = "avatar.home.recommendations",
	NewOutfitNotificationKey = "avatar.newOutfitNotification",
	NewDHOutfitNotificationKey = "avatar.newDHOutfitNotification",
	PeekHeaderHeight = 25,
	PeekHeaderMinHeight = 5,
	MainNavHeight = not defineFastFlag2 and 60 or defineFastInt3
}

if not (module7() or fFlagAXMoveCatalogFilterToL1Navigation) then
	defineFastInt2 = nil
end

v7.CatalogMainNavHeight = defineFastInt2

v7.SubNavHeight = 40
v7.PillBarHeight = 52

v7.CatalogOffersBannerPeekClosedExtraHeight = fFlagAXCatalogOffersBannerEnabled and 48 or nil
v7.FocusedWidgetTitleHeight = 52
v7.ScrollYPositionDetectableEpsilon = 1

v7.LooksDetailsTabBarHeight = 50

v7.LandscapeNavWidth = 0.6
v7.LandscapeUiMargin = 24
v7.LandscapeSceneWidth = 0.4

v7.LoadableGridViewCellPadding = 10

v7.PortraitSceneHeight = fFlagIncreaseMarketplaceContentHeight and 0.29
	or fFlagAXIncreaseDefaultPeekViewHeight and 0.36
	or 0.4

v7.LandingPagePortraitSceneHeight = 0.5
v7.LandingPagePortraitMinItemsHeightPix = 300
v7.LandingPageMinTopFrameHeightPix = 100
v7.LandingPageMinBottomFrameHeightPix = 65
v7.PageButtonForegroundMinHeightPix = 100

v7.SceneButtonSize = 44
v7.SceneButtonCornerRadius = UDim.new(0, 8)
v7.SceneButtonHorizontalPadding = 24

v7.DynamicHeadSplashMaxViews = 3

local set = {
	[Enum.AccessoryType.Hat] = true,
	[Enum.AccessoryType.Face] = true,
	[Enum.AccessoryType.Neck] = true,
	[Enum.AccessoryType.Shoulder] = true,
	[Enum.AccessoryType.Front] = true,
	[Enum.AccessoryType.Back] = true,
	[Enum.AccessoryType.Waist] = true
}
v7.AccessoryAssetTypes = set

local set2 = {
	[tostring(Enum.AssetType.Hat.Value)] = true,
	[tostring(Enum.AssetType.FaceAccessory.Value)] = true,
	[tostring(Enum.AssetType.NeckAccessory.Value)] = true,
	[tostring(Enum.AssetType.ShoulderAccessory.Value)] = true,
	[tostring(Enum.AssetType.FrontAccessory.Value)] = true,
	[tostring(Enum.AssetType.BackAccessory.Value)] = true,
	[tostring(Enum.AssetType.WaistAccessory.Value)] = true
}
v7.BypassAccessoryLimitsAccessoryAssetTypeIdStrings = set2

v7.ContextWidgetsAllowedRoutes = { avatarScreen.Catalog }

v7.DraftLookId = "DraftLook"

v7.WearAfterPurchasePostPurchaseActionKey = "wearAfterPurchase"
v7.SaveAsCharacterPostPurchaseActionKey = "saveAsCharacter"

v7.AssetCategories.Makeup = "Makeup"

if fFlagAXCatalogBackgroundsSupport then
	v7.AssetCategories.Backgrounds = "Backgrounds"
end

v7.BundleTypeIdStrings = module2.Constants.BundleTypeIdStrings
v7.BundleTypeIdStringToName = module2.Constants.BundleTypeIdStringToName
v7.BundleTypeIdStringToNameForBackend = constants.BUNDLE_TYPE_ID_STRING_TO_NAME_FOR_BACKEND

v7.BundleTypeNameToIdStringForCatalogHydration = {
	BodyParts = "1",
	AvatarAnimations = "2",
	Shoes = "3",
	DynamicHead = "4"
}

if fFlagAXInventoryDurablesSupport and fFlagAXEditorSubcategoryFilters then
	v7.BundleTypeIdStringsForBackend = {
		[v7.BundleTypeIdStrings.BodyParts] = "1",
		[v7.BundleTypeIdStrings.DynamicHead] = "2",
		[v7.BundleTypeIdStrings.Avatars] = "3",
		[v7.BundleTypeIdStrings.Shoes] = "4",
		[v7.BundleTypeIdStrings.Animations] = "5"
	}
elseif fFlagAXEditorSubcategoryFilters then
	v7.BundleTypeIdStringsForBackend = {
		[v7.BundleTypeIdStrings.BodyParts] = "1",
		[v7.BundleTypeIdStrings.DynamicHead] = "2",
		[v7.BundleTypeIdStrings.Shoes] = "4",
		[v7.BundleTypeIdStrings.Animations] = "5"
	}
else
	v7.BundleTypeIdStringsForBackend = {
		[v7.BundleTypeIdStrings.BodyParts] = "1",
		[v7.BundleTypeIdStrings.DynamicHead] = "2",
		[v7.BundleTypeIdStrings.Shoes] = "3",
		[v7.BundleTypeIdStrings.Animations] = "4"
	}
end

v7.AssetTypeIdStrings = constants.ASSET_TYPE_NAME_TO_ID_STRING
v7.AssetTypeIdStringToName = constants.ASSET_TYPE_ID_STRING_TO_NAME

v7.SpawnEffectAssetTypeIdString = "97"

local set3 = {
	[v7.AssetTypeIdStrings.EyebrowAccessory] = true,
	[v7.AssetTypeIdStrings.EyelashAccessory] = true,
	[v7.AssetTypeIdStrings.MoodAnimation] = true,
	[v7.AssetTypeIdStrings.DynamicHead] = true
}
v7.DynamicHeadAssetTypes = set3

v7.OutfitTypes = AvatarExperienceCommon.Enums.OutfitTypes

v7.BundleTypeIdStringToOutfitType = {
	[v7.BundleTypeIdStrings.BodyParts] = v7.OutfitTypes.Avatar,
	[v7.BundleTypeIdStrings.DynamicHead] = v7.OutfitTypes.DynamicHead,
	[v7.BundleTypeIdStrings.Shoes] = v7.OutfitTypes.Shoes,
	[v7.BundleTypeIdStrings.Animations] = v7.OutfitTypes.Animations
}

v7.InventoryTypeToBundleTypeId = {
	Body = v7.BundleTypeIdStrings.BodyParts,
	DynamicHead = v7.BundleTypeIdStrings.DynamicHead,
	Shoes = v7.BundleTypeIdStrings.Shoes,
	Animations = v7.BundleTypeIdStrings.Animations
}

v7.InventoryOutfitTypeToOutfitType = constants.INVENTORY_OUTFIT_TYPE_TO_OUTFIT_TYPE

v7.InventoryTypeIdToInventoryOutfitType = constants.INVENTORY_TYPE_ID_TO_INVENTORY_OUTFIT_TYPE
v7.InventoryOutfitTypeToInventoryTypeId = constants.INVENTORY_OUTFIT_TYPE_TO_INVENTORY_TYPE_ID

v7.NonEditableMakeupGrantKey = constants.NON_EDITABLE_MAKEUP_GRANT_KEY

v7.ItemTileType = {
	AvatarEditorTile = "AvatarEditorTile",
	BodyColorButton = "BodyColorButton",
	BundleItemTile = "BundleItemTile",
	BundleItemTileNoText = "BundleItemTileNoText",
	CatalogItemTile = "CatalogItemTile",
	RecommendedCatalogItemTile = "RecommendedCatalogItemTile",
	TallCatalogItemTile = "TallCatalogItemTile",
	LookItemTile = "LookItemTile"
}

v7.ItemType = itemTypeEnum

v7.LookType = constants.LOOK_TYPE

function v7.confirmItemType(p2)
	if p2 == v7.ItemType.Asset then
		return v7.ItemType.Asset
	end

	if p2 == v7.ItemType.Bundle then
		return v7.ItemType.Bundle
	end

	if p2 == v7.ItemType.Outfit then
		return v7.ItemType.Asset
	end

	return nil
end

local v9 = {
	[avatarScreen.AvatarExperienceLandingPage] = avatarScreen.AvatarExperienceLandingPage,
	[avatarScreen.Catalog] = avatarScreen.Catalog,
	[avatarScreen.CatalogSearch] = avatarScreen.CatalogSearch,
	[avatarScreen.AvatarEditor] = avatarScreen.AvatarEditor,
	[avatarScreen.ProfilePictureEditorEmotes] = avatarScreen.ProfilePictureEditorEmotes,
	[avatarScreen.AccessoryAdjustment] = avatarScreen.AccessoryAdjustment,
	[avatarScreen.AvatarRefinement] = avatarScreen.AvatarRefinement,
	[avatarScreen.AdjustAccessoryView] = avatarScreen.AdjustAccessoryView,
	[avatarScreen.LayeredClothingSort] = avatarScreen.LayeredClothingSort,
	[avatarScreen.LayeredMakeupSort] = avatarScreen.LayeredMakeupSort,
	[avatarScreen.CatalogSearchLanding] = avatarScreen.CatalogSearchLanding,
	[avatarScreen.MySharedAvatars] = avatarScreen.MySharedAvatars,
	[avatarScreen.FavoritesSaved] = avatarScreen.FavoritesSaved,
	[avatarScreen.HeadRefinement] = avatarScreen.HeadRefinement,
	[avatarScreen.SearchLandingFocusedWidgetPage] = avatarScreen.SearchLandingFocusedWidgetPage,
	[avatarScreen.BodyShape] = avatarScreen.BodyShape,
	[avatarScreen.AvatarSwitcher] = avatarScreen.AvatarSwitcher,
	[avatarScreen.EditEmotes] = avatarScreen.EditEmotes,
	[avatarScreen.TryOnItem] = avatarScreen.TryOnItem
}
local backgroundGeneration = avatarScreen.BackgroundGeneration
local v10 = if AvatarExperienceFlags.FFlagAXBackgroundGeneration then avatarScreen.BackgroundGeneration else nil
v9[backgroundGeneration] = v10
v7.AnalyticsContext = v9

v7.PagePlayParticleType = {
	[avatarScreen.AvatarEditor] = v7.ParticleType.CatalogToAvatarEditor,
	[avatarScreen.MySharedAvatars] = v7.ParticleType.CatalogToAvatarEditor,
	[avatarScreen.ProfilePictureEditorEmotes] = v7.ParticleType.CatalogToAvatarEditor,
	[avatarScreen.ProfilePictureEditorCamera] = v7.ParticleType.None,
	[avatarScreen.ProfilePictureEditorFinal] = v7.ParticleType.None,
	[avatarScreen.AvatarBackground] = v7.ParticleType.None,
	[avatarScreen.Catalog] = v7.ParticleType.AvatarEditorToCatalog
}

local v12 = {
	[avatarScreen.AvatarEditor] = v7.BackgroundType.LargerShapes,
	[avatarScreen.MySharedAvatars] = v7.BackgroundType.LargerShapes,
	[avatarScreen.ProfilePictureEditorEmotes] = v7.BackgroundType.LargerShapes,
	[avatarScreen.ProfilePictureEditorCamera] = v7.BackgroundType.NoShapesNoWalls,
	[avatarScreen.ProfilePictureEditorFinal] = v7.BackgroundType.NoShapesNoWalls
}
local avatarBackground = avatarScreen.AvatarBackground
local v13 = if fFlagQRCodePageVisualRefresh then v7.BackgroundType.LargerShapes else v7.BackgroundType.Walls
v12[avatarBackground] = v13

local catalog = avatarScreen.Catalog
local v14 = if module4 then v7.BackgroundType.LargerShapes else v7.BackgroundType.Walls
v12[catalog] = v14

v12[avatarScreen.AvatarExperienceLandingPage] = v7.BackgroundType.Walls
v7.PageBackgroundType = v12

if fFlagEnableSplitPane then
	v7.PageBackgroundType[appPage.Home] = v7.BackgroundType.LargerShapes
	v7.SplitPaneBackgroundPage = appPage.Home
end

v7.AttachmentName = {
	BodyBackAttachment = "BodyBackAttachment",
	BodyFrontAttachment = "BodyFrontAttachment",
	Bone = "Bone",
	FaceCenterAttachment = "FaceCenterAttachment",
	FaceFrontAttachment = "FaceFrontAttachment",
	HairAttachment = "HairAttachment",
	HatAttachment = "HatAttachment",
	LeftAnkleRigAttachment = "LeftAnkleRigAttachment",
	LeftCollarAttachment = "LeftCollarAttachment",
	LeftElbowRigAttachment = "LeftElbowRigAttachment",
	LeftFootAttachment = "LeftFootAttachment",
	LeftGripAttachment = "LeftGripAttachment",
	LeftHipRigAttachment = "LeftHipRigAttachment",
	LeftKneeRigAttachment = "LeftKneeRigAttachment",
	LeftShoulderAttachment = "LeftShoulderAttachment",
	LeftShoulderRigAttachment = "LeftShoulderRigAttachment",
	LeftWristRigAttachment = "LeftWristRigAttachment",
	NeckAttachment = "NeckAttachment",
	NeckRigAttachment = "NeckRigAttachment",
	RightAnkleRigAttachment = "RightAnkleRigAttachment",
	RightCollarAttachment = "RightCollarAttachment",
	RightElbowRigAttachment = "RightElbowRigAttachment",
	RightFootAttachment = "RightFootAttachment",
	RightGripAttachment = "RightGripAttachment",
	RightHipRigAttachment = "RightHipRigAttachment",
	RightKneeRigAttachment = "RightKneeRigAttachment",
	RightShoulderAttachment = "RightShoulderAttachment",
	RightShoulderRigAttachment = "RightShoulderRigAttachment",
	RightWristRigAttachment = "RightWristRigAttachment",
	RootRigAttachment = "RootRigAttachment",
	WaistBackAttachment = "WaistBackAttachment",
	WaistCenterAttachment = "WaistCenterAttachment",
	WaistFrontAttachment = "WaistFrontAttachment",
	WaistRigAttachment = "WaistRigAttachment"
}

v7.PartName = {
	Head = "Head",
	Makeup = "Makeup",
	R6_BODY_PARTS = {
		Torso = "Torso",
		LeftLeg = "Left Leg",
		RightLeg = "Right Leg",
		LeftArm = "Left Arm",
		RightArm = "Right Arm"
	},
	R15_BODY_PARTS = {
		UpperTorso = "UpperTorso",
		LowerTorso = "LowerTorso",
		LeftUpperLeg = "LeftUpperLeg",
		LeftLowerLeg = "LeftLowerLeg",
		LeftFoot = "LeftFoot",
		RightUpperLeg = "RightUpperLeg",
		RightLowerLeg = "RightLowerLeg",
		RightFoot = "RightFoot",
		LeftUpperArm = "LeftUpperArm",
		LeftLowerArm = "LeftLowerArm",
		LeftHand = "LeftHand",
		RightUpperArm = "RightUpperArm",
		RightLowerArm = "RightLowerArm",
		RightHand = "RightHand"
	}
}

local v15 = {
	[v7.AvatarType.R6] = {
		[v7.AssetTypeIdStrings.Hat] = {
			{ Part = v7.PartName.Head, Attachment = v7.AttachmentName.HatAttachment }
		},
		[v7.AssetTypeIdStrings.HairAccessory] = {
			{ Part = v7.PartName.Head, Attachment = v7.AttachmentName.HairAttachment }
		},
		[v7.AssetTypeIdStrings.FaceAccessory] = {
			{
				Part = v7.PartName.Head,
				Attachment = v7.AttachmentName.FaceFrontAttachment
			}
		},
		[v7.AssetTypeIdStrings.NeckAccessory] = {
			{ Part = v7.PartName.Head }
		},
		[v7.AssetTypeIdStrings.FrontAccessory] = {
			{ Part = v7.PartName.R6_BODY_PARTS.Torso }
		},
		[v7.AssetTypeIdStrings.BackAccessory] = {
			{ Part = v7.PartName.R6_BODY_PARTS.Torso }
		},
		[v7.AssetTypeIdStrings.WaistAccessory] = {
			{ Part = v7.PartName.R6_BODY_PARTS.Torso }
		},
		[v7.AssetTypeIdStrings.Shirt] = {
			{ Part = v7.PartName.R6_BODY_PARTS.RightArm },
			{ Part = v7.PartName.R6_BODY_PARTS.LeftArm },
			{ Part = v7.PartName.R6_BODY_PARTS.Torso }
		},
		[v7.AssetTypeIdStrings.TShirt] = {
			{ Part = v7.PartName.R6_BODY_PARTS.RightArm },
			{ Part = v7.PartName.R6_BODY_PARTS.LeftArm },
			{ Part = v7.PartName.R6_BODY_PARTS.Torso }
		},
		[v7.AssetTypeIdStrings.Pants] = {
			{ Part = v7.PartName.R6_BODY_PARTS.RightLeg },
			{ Part = v7.PartName.R6_BODY_PARTS.LeftLeg }
		},
		[v7.AssetTypeIdStrings.Head] = {
			{ Part = v7.PartName.Head }
		},
		[v7.AssetTypeIdStrings.Face] = {
			{ Part = v7.PartName.Head }
		},
		[v7.AssetTypeIdStrings.Torso] = {
			{ Part = v7.PartName.R6_BODY_PARTS.Torso }
		},
		[v7.AssetTypeIdStrings.RightArm] = {
			{ Part = v7.PartName.R6_BODY_PARTS.RightArm }
		},
		[v7.AssetTypeIdStrings.LeftArm] = {
			{ Part = v7.PartName.R6_BODY_PARTS.LeftArm }
		},
		[v7.AssetTypeIdStrings.RightLeg] = {
			{ Part = v7.PartName.R6_BODY_PARTS.RightLeg }
		},
		[v7.AssetTypeIdStrings.LeftLeg] = {
			{ Part = v7.PartName.R6_BODY_PARTS.LeftLeg }
		},
		[v7.AssetTypeIdStrings.ClimbAnimation] = {
			{ Part = v7.PartName.R6_BODY_PARTS.Torso }
		},
		[v7.AssetTypeIdStrings.FallAnimation] = {
			{ Part = v7.PartName.R6_BODY_PARTS.Torso }
		},
		[v7.AssetTypeIdStrings.IdleAnimation] = {
			{ Part = v7.PartName.R6_BODY_PARTS.Torso }
		},
		[v7.AssetTypeIdStrings.JumpAnimation] = {
			{ Part = v7.PartName.R6_BODY_PARTS.Torso }
		},
		[v7.AssetTypeIdStrings.RunAnimation] = {
			{ Part = v7.PartName.R6_BODY_PARTS.Torso }
		},
		[v7.AssetTypeIdStrings.SwimAnimation] = {
			{ Part = v7.PartName.R6_BODY_PARTS.Torso }
		},
		[v7.AssetTypeIdStrings.WalkAnimation] = {
			{ Part = v7.PartName.R6_BODY_PARTS.Torso }
		},
		[v7.AssetTypeIdStrings.TShirtAccessory] = {
			{ Part = v7.PartName.R6_BODY_PARTS.Torso }
		},
		[v7.AssetTypeIdStrings.ShirtAccessory] = {
			{ Part = v7.PartName.R6_BODY_PARTS.Torso }
		},
		[v7.AssetTypeIdStrings.PantsAccessory] = {
			{ Part = v7.PartName.R6_BODY_PARTS.RightLeg },
			{ Part = v7.PartName.R6_BODY_PARTS.LeftLeg }
		},
		[v7.AssetTypeIdStrings.JacketAccessory] = {
			{ Part = v7.PartName.R6_BODY_PARTS.Torso }
		},
		[v7.AssetTypeIdStrings.SweaterAccessory] = {
			{ Part = v7.PartName.R6_BODY_PARTS.Torso }
		},
		[v7.AssetTypeIdStrings.ShortsAccessory] = {
			{ Part = v7.PartName.R6_BODY_PARTS.RightLeg },
			{ Part = v7.PartName.R6_BODY_PARTS.LeftLeg }
		},
		[v7.AssetTypeIdStrings.LeftShoeAccessory] = {
			{ Part = v7.PartName.R6_BODY_PARTS.LeftLeg }
		},
		[v7.AssetTypeIdStrings.RightShoeAccessory] = {
			{ Part = v7.PartName.R6_BODY_PARTS.RightLeg }
		},
		[v7.AssetTypeIdStrings.DressSkirtAccessory] = {
			{ Part = v7.PartName.R6_BODY_PARTS.RightLeg },
			{ Part = v7.PartName.R6_BODY_PARTS.LeftLeg }
		}
	}
}

local r15 = v7.AvatarType.R15
v15[r15] = {
	[v7.AssetTypeIdStrings.Hat] = {
		{ Part = v7.PartName.Head, Attachment = v7.AttachmentName.HatAttachment }
	},
	[v7.AssetTypeIdStrings.HairAccessory] = {
		{ Part = v7.PartName.Head, Attachment = v7.AttachmentName.HairAttachment }
	},
	[v7.AssetTypeIdStrings.FaceAccessory] = {
		{ Part = v7.PartName.Head, Attachment = v7.AttachmentName.FaceFrontAttachment }
	},
	[v7.AssetTypeIdStrings.NeckAccessory] = {
		{
			Part = v7.PartName.R15_BODY_PARTS.UpperTorso,
			Attachment = v7.AttachmentName.NeckAttachment
		}
	},
	[v7.AssetTypeIdStrings.FrontAccessory] = {
		{
			Part = v7.PartName.R15_BODY_PARTS.UpperTorso,
			Attachment = v7.AttachmentName.BodyFrontAttachment
		}
	},
	[v7.AssetTypeIdStrings.BackAccessory] = {
		{
			Part = v7.PartName.R15_BODY_PARTS.UpperTorso,
			Attachment = v7.AttachmentName.BodyBackAttachment
		}
	},
	[v7.AssetTypeIdStrings.WaistAccessory] = {
		{
			Part = v7.PartName.R15_BODY_PARTS.LowerTorso,
			Attachment = v7.AttachmentName.WaistCenterAttachment
		}
	},
	[v7.AssetTypeIdStrings.Shirt] = {
		{ Part = v7.PartName.R15_BODY_PARTS.RightUpperArm },
		{ Part = v7.PartName.R15_BODY_PARTS.LeftUpperArm },
		{ Part = v7.PartName.R15_BODY_PARTS.UpperTorso }
	},
	[v7.AssetTypeIdStrings.TShirt] = {
		{ Part = v7.PartName.R15_BODY_PARTS.RightUpperArm },
		{ Part = v7.PartName.R15_BODY_PARTS.LeftUpperArm },
		{ Part = v7.PartName.R15_BODY_PARTS.UpperTorso }
	},
	[v7.AssetTypeIdStrings.Pants] = {
		{ Part = v7.PartName.R15_BODY_PARTS.RightUpperLeg },
		{ Part = v7.PartName.R15_BODY_PARTS.RightLowerLeg },
		{ Part = v7.PartName.R15_BODY_PARTS.LeftUpperLeg },
		{ Part = v7.PartName.R15_BODY_PARTS.LeftLowerLeg }
	},
	[v7.AssetTypeIdStrings.Head] = {
		{ Part = v7.PartName.Head }
	},
	[v7.AssetTypeIdStrings.Face] = {
		{ Part = v7.PartName.Head }
	},
	[v7.AssetTypeIdStrings.Torso] = {
		{ Part = v7.PartName.R15_BODY_PARTS.UpperTorso }
	},
	[v7.AssetTypeIdStrings.RightArm] = {
		{ Part = v7.PartName.R15_BODY_PARTS.RightUpperArm },
		{ Part = v7.PartName.R15_BODY_PARTS.RightLowerArm }
	},
	[v7.AssetTypeIdStrings.LeftArm] = {
		{ Part = v7.PartName.R15_BODY_PARTS.LeftUpperArm },
		{ Part = v7.PartName.R15_BODY_PARTS.LeftLowerArm }
	},
	[v7.AssetTypeIdStrings.RightLeg] = {
		{ Part = v7.PartName.R15_BODY_PARTS.RightUpperLeg },
		{ Part = v7.PartName.R15_BODY_PARTS.RightLowerLeg }
	},
	[v7.AssetTypeIdStrings.LeftLeg] = {
		{ Part = v7.PartName.R15_BODY_PARTS.LeftUpperLeg },
		{ Part = v7.PartName.R15_BODY_PARTS.LeftLowerLeg }
	},
	[v7.AssetTypeIdStrings.ClimbAnimation] = {
		{ Part = v7.PartName.R15_BODY_PARTS.UpperTorso }
	},
	[v7.AssetTypeIdStrings.FallAnimation] = {
		{ Part = v7.PartName.R15_BODY_PARTS.UpperTorso }
	},
	[v7.AssetTypeIdStrings.IdleAnimation] = {
		{ Part = v7.PartName.R15_BODY_PARTS.UpperTorso }
	},
	[v7.AssetTypeIdStrings.JumpAnimation] = {
		{ Part = v7.PartName.R15_BODY_PARTS.UpperTorso }
	},
	[v7.AssetTypeIdStrings.RunAnimation] = {
		{ Part = v7.PartName.R15_BODY_PARTS.UpperTorso }
	},
	[v7.AssetTypeIdStrings.SwimAnimation] = {
		{ Part = v7.PartName.R15_BODY_PARTS.UpperTorso }
	},
	[v7.AssetTypeIdStrings.WalkAnimation] = {
		{ Part = v7.PartName.R15_BODY_PARTS.UpperTorso }
	},
	[v7.AssetTypeIdStrings.TShirtAccessory] = {
		{ Part = v7.PartName.R15_BODY_PARTS.UpperTorso }
	},
	[v7.AssetTypeIdStrings.ShirtAccessory] = {
		{ Part = v7.PartName.R15_BODY_PARTS.UpperTorso }
	},
	[v7.AssetTypeIdStrings.PantsAccessory] = {
		{ Part = v7.PartName.R15_BODY_PARTS.RightUpperLeg },
		{ Part = v7.PartName.R15_BODY_PARTS.RightLowerLeg },
		{ Part = v7.PartName.R15_BODY_PARTS.LeftUpperLeg },
		{ Part = v7.PartName.R15_BODY_PARTS.LeftLowerLeg }
	},
	[v7.AssetTypeIdStrings.JacketAccessory] = {
		{ Part = v7.PartName.R15_BODY_PARTS.UpperTorso }
	},
	[v7.AssetTypeIdStrings.SweaterAccessory] = {
		{ Part = v7.PartName.R15_BODY_PARTS.UpperTorso }
	},
	[v7.AssetTypeIdStrings.ShortsAccessory] = {
		{ Part = v7.PartName.R15_BODY_PARTS.RightUpperLeg },
		{ Part = v7.PartName.R15_BODY_PARTS.LeftUpperLeg }
	},
	[v7.AssetTypeIdStrings.LeftShoeAccessory] = {
		{ Part = v7.PartName.R15_BODY_PARTS.LeftFoot }
	},
	[v7.AssetTypeIdStrings.RightShoeAccessory] = {
		{ Part = v7.PartName.R15_BODY_PARTS.RightFoot }
	},
	[v7.AssetTypeIdStrings.DressSkirtAccessory] = {
		{ Part = v7.PartName.R15_BODY_PARTS.RightUpperLeg },
		{ Part = v7.PartName.R15_BODY_PARTS.LeftUpperLeg }
	}
}
v7.AssetTypeIdToPartsAndAttachments = v15

local v18 = {
	[v7.AvatarType.R15] = {
		[focusType.Legs] = {
			{ Part = v7.PartName.R15_BODY_PARTS.RightUpperLeg },
			{ Part = v7.PartName.R15_BODY_PARTS.LeftUpperLeg },
			{ Part = v7.PartName.R15_BODY_PARTS.RightLowerLeg },
			{ Part = v7.PartName.R15_BODY_PARTS.LeftLowerLeg }
		},
		[focusType.Face] = {
			{
				Part = v7.PartName.Head,
				Attachment = v7.AttachmentName.FaceFrontAttachment
			}
		},
		[focusType.Makeup] = {
			{ Part = v7.PartName.Makeup }
		},
		[focusType.Arms] = {
			{ Part = v7.PartName.R15_BODY_PARTS.UpperTorso }
		},
		[focusType.Head] = {
			{ Part = v7.PartName.Head, Attachment = v7.AttachmentName.HatAttachment },
			{
				Part = v7.PartName.Head,
				Attachment = v7.AttachmentName.NeckRigAttachment
			}
		},
		[focusType.Neck] = {
			{ Part = v7.PartName.Head },
			{ Part = v7.PartName.R15_BODY_PARTS.UpperTorso }
		},
		[focusType.Waist] = {
			{ Part = v7.PartName.R15_BODY_PARTS.LowerTorso },
			{ Part = v7.PartName.R15_BODY_PARTS.RightUpperLeg },
			{ Part = v7.PartName.R15_BODY_PARTS.LeftUpperLeg }
		},
		[focusType.Shoulders] = {
			{ Part = v7.PartName.Head },
			{ Part = v7.PartName.R15_BODY_PARTS.RightUpperArm },
			{ Part = v7.PartName.R15_BODY_PARTS.LeftUpperArm }
		}
	}
}

local r6_2 = v7.AvatarType.R6
v18[r6_2] = {
	[focusType.Legs] = {
		{ Part = v7.PartName.R6_BODY_PARTS.RightLeg },
		{ Part = v7.PartName.R6_BODY_PARTS.LeftLeg }
	},
	[focusType.Face] = {
		{ Part = v7.PartName.Head, Attachment = v7.AttachmentName.FaceFrontAttachment }
	},
	[focusType.Arms] = {
		{ Part = v7.PartName.R6_BODY_PARTS.Torso }
	},
	[focusType.Head] = {
		{ Part = v7.PartName.Head, Attachment = v7.AttachmentName.HatAttachment },
		{ Part = v7.PartName.Head, Attachment = v7.AttachmentName.NeckRigAttachment }
	},
	[focusType.Neck] = {
		{ Part = v7.PartName.Head },
		{ Part = v7.PartName.R6_BODY_PARTS.Torso }
	},
	[focusType.Waist] = {
		{ Part = v7.PartName.R6_BODY_PARTS.Torso },
		{ Part = v7.PartName.R6_BODY_PARTS.RightLeg },
		{ Part = v7.PartName.R6_BODY_PARTS.LeftLeg }
	},
	[focusType.Shoulders] = {
		{ Part = v7.PartName.Head },
		{ Part = v7.PartName.R6_BODY_PARTS.RightArm },
		{ Part = v7.PartName.R6_BODY_PARTS.LeftArm }
	}
}
v7.AvatarTypeFocusGroups = v18

v7.AssetTypeIdToCategory = {
	[v7.AssetTypeIdStrings.TShirt] = v7.AssetCategories.Clothing,
	[v7.AssetTypeIdStrings.Hat] = v7.AssetCategories.Accessory,
	[v7.AssetTypeIdStrings.HairAccessory] = v7.AssetCategories.Accessory,
	[v7.AssetTypeIdStrings.FaceAccessory] = v7.AssetCategories.Accessory,
	[v7.AssetTypeIdStrings.NeckAccessory] = v7.AssetCategories.Accessory,
	[v7.AssetTypeIdStrings.ShoulderAccessory] = v7.AssetCategories.Accessory,
	[v7.AssetTypeIdStrings.FrontAccessory] = v7.AssetCategories.Accessory,
	[v7.AssetTypeIdStrings.BackAccessory] = v7.AssetCategories.Accessory,
	[v7.AssetTypeIdStrings.WaistAccessory] = v7.AssetCategories.Accessory,
	[v7.AssetTypeIdStrings.Shirt] = v7.AssetCategories.Clothing,
	[v7.AssetTypeIdStrings.Pants] = v7.AssetCategories.Clothing,
	[v7.AssetTypeIdStrings.Gear] = v7.AssetCategories.Accessory,
	[v7.AssetTypeIdStrings.Head] = v7.AssetCategories.Body,
	[v7.AssetTypeIdStrings.Face] = v7.AssetCategories.Body,
	[v7.AssetTypeIdStrings.Torso] = v7.AssetCategories.Body,
	[v7.AssetTypeIdStrings.RightArm] = v7.AssetCategories.Body,
	[v7.AssetTypeIdStrings.LeftArm] = v7.AssetCategories.Body,
	[v7.AssetTypeIdStrings.RightLeg] = v7.AssetCategories.Body,
	[v7.AssetTypeIdStrings.LeftLeg] = v7.AssetCategories.Body,
	[v7.AssetTypeIdStrings.ClimbAnimation] = v7.AssetCategories.Animation,
	[v7.AssetTypeIdStrings.FallAnimation] = v7.AssetCategories.Animation,
	[v7.AssetTypeIdStrings.IdleAnimation] = v7.AssetCategories.Animation,
	[v7.AssetTypeIdStrings.JumpAnimation] = v7.AssetCategories.Animation,
	[v7.AssetTypeIdStrings.RunAnimation] = v7.AssetCategories.Animation,
	[v7.AssetTypeIdStrings.SwimAnimation] = v7.AssetCategories.Animation,
	[v7.AssetTypeIdStrings.WalkAnimation] = v7.AssetCategories.Animation,
	[v7.AssetTypeIdStrings.EmoteAnimation] = v7.AssetCategories.Animation,
	[v7.AssetTypeIdStrings.TShirtAccessory] = v7.AssetCategories.Accessory,
	[v7.AssetTypeIdStrings.ShirtAccessory] = v7.AssetCategories.Accessory,
	[v7.AssetTypeIdStrings.PantsAccessory] = v7.AssetCategories.Accessory,
	[v7.AssetTypeIdStrings.JacketAccessory] = v7.AssetCategories.Accessory,
	[v7.AssetTypeIdStrings.SweaterAccessory] = v7.AssetCategories.Accessory,
	[v7.AssetTypeIdStrings.ShortsAccessory] = v7.AssetCategories.Accessory,
	[v7.AssetTypeIdStrings.LeftShoeAccessory] = v7.AssetCategories.Accessory,
	[v7.AssetTypeIdStrings.RightShoeAccessory] = v7.AssetCategories.Accessory,
	[v7.AssetTypeIdStrings.DressSkirtAccessory] = v7.AssetCategories.Accessory,
	[v7.AssetTypeIdStrings.MoodAnimation] = v7.AssetCategories.Animation,
	[v7.AssetTypeIdStrings.EyebrowAccessory] = v7.AssetCategories.Makeup,
	[v7.AssetTypeIdStrings.EyelashAccessory] = v7.AssetCategories.Makeup,
	[v7.AssetTypeIdStrings.DynamicHead] = v7.AssetCategories.Body
}

v7.AssetTypeIdToCategory[v7.AssetTypeIdStrings.FaceMakeup] = v7.AssetCategories.Makeup
v7.AssetTypeIdToCategory[v7.AssetTypeIdStrings.LipMakeup] = v7.AssetCategories.Makeup
v7.AssetTypeIdToCategory[v7.AssetTypeIdStrings.EyeMakeup] = v7.AssetCategories.Makeup

if fFlagAXCatalogBackgroundsSupport then
	v7.AssetTypeIdToCategory[v7.AssetTypeIdStrings.AvatarBackground] = v7.AssetCategories.Backgrounds
end

local set4 = {
	[v7.AssetTypeIdStrings.TShirtAccessory] = true,
	[v7.AssetTypeIdStrings.ShirtAccessory] = true,
	[v7.AssetTypeIdStrings.PantsAccessory] = true,
	[v7.AssetTypeIdStrings.JacketAccessory] = true,
	[v7.AssetTypeIdStrings.SweaterAccessory] = true,
	[v7.AssetTypeIdStrings.ShortsAccessory] = true,
	[v7.AssetTypeIdStrings.LeftShoeAccessory] = true,
	[v7.AssetTypeIdStrings.RightShoeAccessory] = true,
	[v7.AssetTypeIdStrings.DressSkirtAccessory] = true
}
v7.GradientBackgroundAssetTypeIds = set4

v7.AssetCategoriesLocalized = {
	[v7.AssetCategories.Animation] = "Feature.Catalog.Label.Animation",
	[v7.AssetCategories.Body] = "Feature.Catalog.Label.Body",
	[v7.AssetCategories.Clothing] = "Feature.Avatar.Heading.Clothing",
	[v7.AssetCategories.Accessory] = "Feature.Avatar.Label.Accessory",
	[v7.AssetCategories.Emotes] = "Feature.Catalog.Label.Emotes"
}

v7.AssetCategoriesLocalized[v7.AssetCategories.Makeup] = "Feature.Catalog.Label.Makeup"

if fFlagAXCatalogBackgroundsSupport then
	v7.AssetCategoriesLocalized[v7.AssetCategories.Backgrounds] = "Feature.Avatar.Label.Backgrounds"
end

v7.AssetTypeLocalized = {
	[v7.AssetTypeIdStrings.TShirt] = "Feature.Avatar.Label.ClassicTShirts",
	[v7.AssetTypeIdStrings.Hat] = "Feature.Avatar.Label.Hat",
	[v7.AssetTypeIdStrings.HairAccessory] = "Feature.Avatar.Label.Hair",
	[v7.AssetTypeIdStrings.FaceAccessory] = "Feature.Avatar.Label.Face",
	[v7.AssetTypeIdStrings.NeckAccessory] = "Feature.Avatar.Label.Neck",
	[v7.AssetTypeIdStrings.ShoulderAccessory] = "Feature.Avatar.Label.Shoulder",
	[v7.AssetTypeIdStrings.FrontAccessory] = "Feature.Avatar.Label.Front",
	[v7.AssetTypeIdStrings.BackAccessory] = "Feature.Avatar.Label.Back",
	[v7.AssetTypeIdStrings.WaistAccessory] = "Feature.Avatar.Label.Waist",
	[v7.AssetTypeIdStrings.Shirt] = "Feature.Avatar.Label.ClassicShirts",
	[v7.AssetTypeIdStrings.Pants] = "Feature.Avatar.Label.ClassicPants",
	[v7.AssetTypeIdStrings.Gear] = "Feature.Avatar.Label.Gear",
	[v7.AssetTypeIdStrings.Head] = "Feature.Avatar.Label.Head",
	[v7.AssetTypeIdStrings.Face] = "Feature.Avatar.Label.Face",
	[v7.AssetTypeIdStrings.Torso] = "Feature.Avatar.Label.Torso",
	[v7.AssetTypeIdStrings.RightArm] = "Feature.Avatar.Label.RightArms",
	[v7.AssetTypeIdStrings.LeftArm] = "Feature.Avatar.Label.LeftArms",
	[v7.AssetTypeIdStrings.LeftLeg] = "Feature.Avatar.Label.LeftLegs",
	[v7.AssetTypeIdStrings.RightLeg] = "Feature.Avatar.Label.RightLegs",
	[v7.AssetTypeIdStrings.ClimbAnimation] = "Feature.Avatar.Label.Climb",
	[v7.AssetTypeIdStrings.FallAnimation] = "Feature.Avatar.Label.Fall",
	[v7.AssetTypeIdStrings.IdleAnimation] = "Feature.Avatar.Label.Idle",
	[v7.AssetTypeIdStrings.JumpAnimation] = "Feature.Avatar.Label.Jump",
	[v7.AssetTypeIdStrings.RunAnimation] = "Feature.Avatar.Label.Run",
	[v7.AssetTypeIdStrings.SwimAnimation] = "Feature.Avatar.Label.Swim",
	[v7.AssetTypeIdStrings.WalkAnimation] = "Feature.Avatar.Label.Walk",
	[v7.AssetTypeIdStrings.EmoteAnimation] = "Feature.Avatar.Label.Emote",
	[v7.AssetTypeIdStrings.TShirtAccessory] = "Feature.Avatar.Label.TShirt",
	[v7.AssetTypeIdStrings.ShirtAccessory] = "Feature.Avatar.Label.Shirt",
	[v7.AssetTypeIdStrings.PantsAccessory] = "Feature.Avatar.Label.Pants",
	[v7.AssetTypeIdStrings.JacketAccessory] = "Feature.Avatar.Label.Jacket",
	[v7.AssetTypeIdStrings.SweaterAccessory] = "Feature.Avatar.Label.Sweater",
	[v7.AssetTypeIdStrings.ShortsAccessory] = "Feature.Avatar.Label.Shorts",
	[v7.AssetTypeIdStrings.LeftShoeAccessory] = "Feature.Avatar.Label.LeftShoe",
	[v7.AssetTypeIdStrings.RightShoeAccessory] = "Feature.Avatar.Label.RightShoe",
	[v7.AssetTypeIdStrings.DressSkirtAccessory] = "Feature.Avatar.Label.DressesAndSkirts",
	[v7.AssetTypeIdStrings.EyelashAccessory] = "Feature.Catalog.Label.Eyelash",
	[v7.AssetTypeIdStrings.EyebrowAccessory] = "Feature.Catalog.Label.Eyebrow",
	[v7.AssetTypeIdStrings.MoodAnimation] = "Feature.Avatar.Label.Mood",
	[v7.AssetTypeIdStrings.DynamicHead] = "Feature.Avatar.Label.DynamicHead"
}

v7.AssetTypeLocalized[v7.AssetTypeIdStrings.FaceMakeup] = "Feature.Catalog.Label.FaceMakeup"
v7.AssetTypeLocalized[v7.AssetTypeIdStrings.LipMakeup] = "Feature.Catalog.Label.LipMakeup"
v7.AssetTypeLocalized[v7.AssetTypeIdStrings.EyeMakeup] = "Feature.Catalog.Label.EyeMakeup"

if fFlagAXCatalogBackgroundsSupport then
	v7.AssetTypeLocalized[v7.AssetTypeIdStrings.AvatarBackground] = "Feature.Avatar.Label.Backgrounds"
end

if fFlagHeadRefinementFacialAnimationToggle then
	v7.StaticFacialAnimation = constants.STATIC_FACIAL_ANIMATION
end

v7.AssetTypeIdStringToHumanoidDescriptionProp = {
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
	[tostring(Enum.AssetType.MoodAnimation.Value)] = "MoodAnimation",
	[tostring(Enum.AssetType.DynamicHead.Value)] = "Head"
}

v7.HumanoidDescriptionScaleToName = {
	bodyType = "BodyTypeScale",
	head = "HeadScale",
	height = "HeightScale",
	proportion = "ProportionScale",
	depth = "DepthScale",
	width = "WidthScale"
}

v7.BodyPartForSkinColoringIdToHumanoidDescription = {
	headColor3 = "HeadColor",
	leftArmColor3 = "LeftArmColor",
	leftLegColor3 = "LeftLegColor",
	rightArmColor3 = "RightArmColor",
	rightLegColor3 = "RightLegColor",
	torsoColor3 = "TorsoColor"
}

if fFlagParseHeadShapeFromAPIResponse then
	v7.BodyPartNameToEnum = constants.BODY_PART_NAME_TO_ENUM
end

local set5 = {
	[Enum.UserInputType.Keyboard] = true,
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true,
	[Enum.UserInputType.Gamepad5] = true,
	[Enum.UserInputType.Gamepad6] = true,
	[Enum.UserInputType.Gamepad7] = true,
	[Enum.UserInputType.Gamepad8] = true
}
v7.GamepadInputTypes = set5

v7.ThumbstickDeadzone = 0.2

v7.SceneGamepad = {
	FullViewIndicatorTag = symbol.named("FullViewIndicatorTag")
}

v7.SceneRowHeight = 28

v7.LayeredClothingOrder = constants.LAYERED_CLOTHING_ORDER

local set6 = {
	[v7.AssetTypeIdStrings.HairAccessory] = true,
	[v7.AssetTypeIdStrings.EyebrowAccessory] = true,
	[v7.AssetTypeIdStrings.EyelashAccessory] = true
}
v7.LCIgnoredForSorting = set6

v7.AssetTypeIdToAccessoryTypeEnum = constants.ASSET_TYPE_TO_ACCESSORY_TYPE
v7.AccessoryTypeEnumToAssetTypeId = constants.ACCESSORY_TYPE_TO_ASSET_TYPE

v7.LayeredAssetTypes = constants.LAYERED_ASSET_TYPES

v7.AssetCategory = { LCTops = "LCTops", LCBottoms = "LCBottoms" }

v7.NavOuterPadding = 6
v7.NavInnerPadding = 6
v7.NavButtonElementPadding = 4
v7.NavButtonElementMargin = 4
v7.NavCornerSize = 8
v7.NavButtonBorderSize = 2
v7.NavSubButtonInnerPadding = 4

v7.MinTileWidthToFontHeightRatio = 6

v7.SmallRadioButtonHeight = 56
v7.SortAndFiltersRowHeight = 45
v7.SortAndFiltersSmallRowHeight = 32
v7.SortAndFiltersSectionPadding = 8

local v25 = {
	[avatarScreen.AccessoryAdjustment] = fullView.None,
	[avatarScreen.LayeredClothingSort] = fullView.None,
	[avatarScreen.LayeredMakeupSort] = fullView.None,
	[avatarScreen.AvatarEditor] = fullView.None,
	[avatarScreen.AvatarExperienceLandingPage] = fullView.None,
	[avatarScreen.Catalog] = fullView.None,
	[avatarScreen.CatalogSearch] = fullView.None,
	[avatarScreen.ProfilePictureEditorEmotes] = fullView.None,
	[avatarScreen.MySharedAvatars] = fullView.None,
	[avatarScreen.FavoritesSaved] = fullView.None
}
local searchLandingFocusedWidgetPage = avatarScreen.SearchLandingFocusedWidgetPage
local v26 = if defineFastFlag then fullView.None else nil
v25[searchLandingFocusedWidgetPage] = v26

v25[avatarScreen.BodyShape] = fullView.None
v25[avatarScreen.AvatarSwitcher] = fullView.None
v25[avatarScreen.EditEmotes] = fullView.None
v7.FullViewPageDefaults = v25

if AvatarExperienceFlags.FFlagAXPhotoboothMomentsPage then
	v7.AnalyticsContext[avatarScreen.PhotoboothMomentsPage] = avatarScreen.PhotoboothMomentsPage
	v7.FullViewPageDefaults[avatarScreen.PhotoboothMomentsPage] = fullView.None
	v7.PageBackgroundType[avatarScreen.PhotoboothMomentsPage] = v7.BackgroundType.LargerShapes
end

local v27 = -2 * v5 + -1.2
local v28 = -4.4 * v5 + -1.2
local v29 = 3.2 * v5 * 0.9

local v30 = (3.52 * v5 - 3.52) / 2

v7.VR = {
	SPACE_BETWEEN_STACKED_PANELS = 0.01,
	PanelInfo = {
		Left = {
			PartSize = Vector2.new(2.2, 3.52) * v5,
			Offset = CFrame.lookAt(Vector3.new(-v29, 4.6, v27), Vector3.new(0, 4.6, 0)),
			VirtualScreenSize = Vector2.new(360, 704)
		},
		Right = {
			PartSize = Vector2.new(2.2, 3.52) * v5,
			Offset = CFrame.lookAt(Vector3.new(v29, 4.6, v27), Vector3.new(0, 4.6, 0)),
			VirtualScreenSize = Vector2.new(360, 704)
		},
		Center = {
			PartSize = Vector2.new(3, 3.52) * v5,
			Offset = CFrame.lookAt(Vector3.new(0, 4.6, v28), Vector3.new(0, 4.6, 0)),
			VirtualScreenSize = Vector2.new(600, 704)
		}
	},
	AvatarEditorNavBarSize = Vector2.new(2.5, 0.3) * v5,
	AvatarEditorNavBarPosition = Vector3.new(0, 6.9 + v30, v28),
	AvatarEditorNavBarOrientation = Vector3.new(0, 7 + v30, 0),
	AvatarEditorNavBarResolution = Vector2.new(650, 75)
}

v7.Counter = {
	PREFIX = "AvatarExperience_",
	TopLevelViews = "TopLevelViews",
	CatalogView = "CatalogView",
	SearchView = "SearchView",
	EditorView = "EditorView",
	CatalogItemDetailsView = "CatalogItemDetailsView",
	SearchItemDetailsView = "SearchItemDetailsView",
	CatalogFiltersView = "CatalogFiltersView",
	SearchFiltersView = "SearchFiltersView",
	SearchLandingView = "SearchLandingView",
	TryOnItemView = "TryOnItemView",
	OthersView = "OthersView",
	TopLevelErrors = {
		CatalogViewError = "CatalogViewError",
		SearchViewError = "SearchViewError",
		EditorViewError = "EditorViewError",
		CatalogItemDetailsViewError = "CatalogItemDetailsViewError",
		SearchItemDetailsViewError = "SearchItemDetailsViewError",
		CatalogFiltersViewError = "CatalogFiltersViewError",
		SearchFiltersViewError = "SearchFiltersViewError",
		UnknownViewError = "UnknownViewError"
	},
	TopLevelLatency = {
		Name = "TopLevelLatency",
		CatalogViewLatency = "CatalogViewLatency",
		SearchViewLatency = "SearchViewLatency",
		EditorViewLatency = "EditorViewLatency",
		CatalogItemDetailsViewLatency = "CatalogItemDetailsViewLatency",
		SearchItemDetailsViewLatency = "SearchItemDetailsViewLatency",
		CatalogFiltersViewLatency = "CatalogFiltersViewLatency",
		SearchFiltersViewLatency = "SearchFiltersViewLatency",
		UnknownViewLatency = "UnknownViewLatency"
	},
	TopLevelFPS = {
		Catalog = "tracking-pattern:catalog-view",
		Search = "tracking-pattern:search-view",
		Editor = "tracking-pattern:editor-view",
		CatalogItemDetails = "tracking-pattern:catalog-item-details-view",
		SearchItemDetails = "tracking-pattern:search-item-details-view",
		CatalogFilters = "tracking-pattern:catalog-filters-view",
		SearchFilters = "tracking-pattern:search-filters-view",
		Unknown = "tracking-pattern:unknown-view-latency"
	},
	TopLevelFPSForCatSubCat = {
		Catalog = "catalog-category-changed",
		Editor = "editor-category-changed"
	},
	TopLevelPageInitialView = {
		Catalog = "Catalog",
		Editor = "Editor",
		SlotBasedEditor = "SlotBasedEditor"
	},
	PopularLooksWidgetHomeView = "PopularLooksWidgetHomeView",
	PopularLooksWidgetHomeTileClicked = "PopularLooksWidgetHomeTileClicked",
	PopularLooksWidgetSearchTileClicked = "PopularLooksWidgetSearchTileClicked",
	PopularLooksWidgetHomeBuyClicked = "PopularLooksWidgetHomeBuyClicked",
	PopularLooksWidgetSearchBuyClicked = "PopularLooksWidgetSearchBuyClicked",
	AvatarWidget = {
		AvatarsWidgetSearchBuyClicked = "AvatarsWidgetSearchBuyClicked",
		AvatarsWidgetHomeBuyClicked = "AvatarsWidgetHomeBuyClicked",
		AvatarsWidgetBuyClickedInsufficientRobux = "AvatarsWidgetBuyClickedInsufficientRobux",
		AvatarsWidgetBuyClickedNoItemsToPurchase = "AvatarsWidgetBuyClickedNoItemsToPurchase",
		AvatarsWidgetBuyClickedMissingLookId = "AvatarsWidgetBuyClickedMissingLookId"
	},
	CatalogRefresh = { StaleResults = "CatalogRefreshStaleResults" },
	AvatarEditorServiceErrors = {
		GetRecommendedAssets = "AvatarEditorServiceGetRecommendedAssetsError",
		GetOutfits = "AvatarEditorServiceGetOutfitsError",
		CreateOutfit = "AvatarEditorServiceCreateOutfitError",
		GetAvatarRules = "AvatarEditorServiceGetAvatarRulesError",
		GetInventory = "AvatarEditorServiceGetInventoryError",
		SearchCatalog = "AvatarEditorServiceSearchCatalogError",
		GetBatchItemDetails = "AvatarEditorServiceGetBatchItemDetailsError",
		GetRecommendedBundles = "AvatarEditorServiceGetRecommendedBundlesError",
		NoPromptSetFavorite = "AvatarEditorServiceNoPromptSetFavoriteError",
		NoPromptSaveAvatarThumbnailCustomization = "AvatarEditorServiceNoPromptSaveAvatarThumbnailCustomizationError",
		NoPromptCreateOutfit = "AvatarEditorServiceNoPromptCreateOutfitError",
		GetOutfitDetails = "AvatarEditorServiceGetOutfitDetailsError",
		FetchAssetOrBundleInfo = "AvatarEditorServiceFetchAssetOrBundleInfoError",
		FetchBundleInfo = "AvatarEditorServiceFetchBundleInfoError",
		GetAssetFavorite = "AvatarEditorServiceGetAssetFavoriteError",
		GetBundleFavorite = "AvatarEditorServiceGetBundleFavoriteError",
		SetBundleFavorite = "AvatarEditorServiceSetBundleFavoriteError",
		SetAssetFavorite = "AvatarEditorServiceSetAssetFavoriteError",
		ConformToAvatarRules = "AvatarEditorServiceConformToAvatarRulesError",
		NoPromptSaveAvatar = "AvatarEditorServiceNoPromptSaveAvatarError",
		PromptSaveAvatarCompleted = "AvatarEditorServicePromptSaveAvatarCompletedError",
		NoPromptApplyProfileConfiguration = "AvatarEditorServiceNoPromptApplyProfileConfigurationError",
		PromptApplyProfileConfigurationCompleted = "AvatarEditorServicePromptApplyProfileConfigurationCompletedError",
		GetProfileConfiguration = "AvatarEditorServiceGetProfileConfigurationError"
	},
	LookComposer = {
		PreviewLook = "LookComposerPreviewLook",
		CreateLook = "LookComposerCreateLook"
	},
	MySharedAvatars = {
		ReloadTriggedInPage = "MySharedAvatarsReloadTriggedInPage",
		FetchMySharedAvatarsError = "MySharedAvatarsFetchMySharedAvatarsError",
		FetchMySharedAvatarsNewPage = "MySharedAvatarsFetchMySharedAvatarsNewPage",
		MySharedAvatarsDeleteAvatarError = "MySharedAvatarsDeleteAvatarError"
	},
	ShareButtonProfileration = {
		ShareButtonClicked = "ShareButtonProliferationButtonClicked",
		Experiment = "ShareButtonProliferationExperiment"
	},
	Errors = {
		NoInternetConnectionErrorSearchView = "NoInternetConnectionErrorSearchView",
		NoInternetConnectionErrorCatalogView = "NoInternetConnectionErrorCatalogView",
		PurchaseLooksProductError = "PurchaseLooksProductError",
		SduiTapActiveStoreMissing = "SduiTapActiveStoreMissing",
		FetcherCategoryInfoMissing = "FetcherCategoryInfoMissing"
	},
	GetOrGenerateShortShareLink = {
		Success = "GetOrGenerateShortShareLinkSuccess",
		Invalid = "GetOrGenerateShortShareLinkInvalid",
		Failure = "GetOrGenerateShortShareLinkFailure",
		HookSuccess = "GetOrGenerateShortShareLinkSuccessFromHook",
		HookInvalid = "GetOrGenerateShortShareLinkInvalidFromHook",
		HookFailure = "GetOrGenerateShortShareLinkFailureFromHook",
		LinkCopied = "GetOrGenerateShortShareLinkLinkCopied"
	},
	ContextFrame = {
		Open = "ContextFrameOpen",
		ViewDetailsPageClick = "ContextFrameViewDetailsPageClick",
		DeleteAvatarClick = "ContextFrameDeleteAvatarClick"
	},
	Toasts = { NoFaceHead = "ToastsNoFaceHead" },
	Latency = {
		Organic = not fFlagAXRemoveLegacyTileLatencyStats and {
			Thumbnails = "OrganicThumbnailLatency",
			Tiles = "OrganicTilesLatency"
		} or nil,
		Widget = not fFlagAXRemoveLegacyTileLatencyStats and {
			Thumbnails = "WidgetThumbnailLatency",
			Tiles = "WidgetTilesLatency"
		} or nil,
		Network = {
			FetchWidgetInfo = "NetworkFetchWidgetInfoLatency",
			ApiFetchCatalogSearch = "NetworkApiFetchCatalogSearchLatency",
			FetchSponsoredItems = "NetworkFetchSponsoredItemsLatency",
			FetchAssetOrBundleInfo = "NetworkFetchAssetOrBundleInfoLatency"
		}
	},
	AvatarInventory = { ReceivedDuplicateItem = "AvatarInventoryReceivedDuplicateItem" },
	SaveManager = {
		Attempt = "SaveManagerAttempt",
		Success = "SaveManagerSuccess",
		BlockedByOngoingSave = "SaveManagerBlockedByOngoingSave",
		Failure = "SaveManagerFailure"
	},
	CategoryButtonTooltip = {
		Seen = "CategoryButtonTooltipSeen",
		AutoDismiss = "CategoryButtonTooltipAutoDismiss",
		ClickDismiss = "CategoryButtonTooltipClickDismiss"
	},
	AvatarsTabError = "AvatarsTabError",
	FetchCatalogSearchForLooksError = "FetchCatalogSearchForLooksError",
	PrefetchMarketplace = {
		appLaunched = "PrefetchMarketplaceAppLaunched",
		isRecentMarketplaceUser = "PrefetchIsRecentMarketplaceUser",
		enteredMarketplaceAndIsRecentUser = "PrefetchEnteredMarketplaceAndIsRecentUser",
		inExperimentAndIsRecentUserAndEnteredMarketplace = "PrefetchInExperimentAndIsRecentUserAndEnteredMarketplace",
		inExperimentAndIsRecentUserAndEnteredMarketplaceThumbnails = "PrefetchInExperimentAndIsRecentUserAndEnteredMarketplaceThumbnails",
		inTreatmentAndHasPrefetchedMarketplace = "PrefetchInTreatmentAndHasPrefetchedMarketplace",
		enteredMarketplaceButPrefetchFailed = "PrefetchEnteredMarketplaceButPrefetchFailed"
	},
	FetchMarketplace = {
		ExitAndReEnterRefreshCounter = "FetchMarketplaceExitAndReEnterRefreshCounter",
		ExitAndReEnterRefreshTreatment = "FetchMarketplaceExitAndReEnterRefreshTreatment"
	},
	LayerExposure = { CatalogView = "CatalogViewLayerExposure" },
	NilGuard = {
		CharacterManager_initAvatarScalesChangedConnection_characterManagerEvents = "NilGuard_CharacterManager_initAvatarScalesChangedConnection_characterManagerEvents",
		CharacterManager_initBodyColorsChangedConnection_characterManagerEvents = "NilGuard_CharacterManager_initBodyColorsChangedConnection_characterManagerEvents",
		CharacterManager_initAdjustmentChangedConnection_characterManagerEvents = "NilGuard_CharacterManager_initAdjustmentChangedConnection_characterManagerEvents"
	},
	Catalog = (fFlagAXCatalogCategoriesSDUI or fFlagAXMigrateAllTabToSduiDev) and {
		Errors = {
			FetchCatalogCategoriesError = "FetchCatalogCategoriesError",
			FetchMarketplaceSduiError = "FetchMarketplaceSduiError"
		}
	} or nil
}

v7.MemStorageKeys = {
	ColdStart = { CatalogAndCatalogSearch = "AXColdStartCatalogAndSearch" }
}

v7.ModerationStatus = { PendingModeration = "Pending", Moderated = "Moderated" }

v7.HeadRefinementCameraCategory = {
	Name = "Head",
	Title = "Head",
	CameraFocus = focusType.Head,
	CameraZoomRadius = cameraZoomRadius.Special.HeadRefinement
}

v7.LayeredMakeupCameraCategory = {
	Name = "Makeup",
	Title = "Makeup",
	CameraFocus = focusType.Makeup,
	CameraZoomRadius = 4
}

if module5.isEnabled() then
	local set7 = {
		[v7.AssetTypeIdStrings.Hat] = true,
		[v7.AssetTypeIdStrings.HairAccessory] = true,
		[v7.AssetTypeIdStrings.FaceAccessory] = true,
		[v7.AssetTypeIdStrings.NeckAccessory] = true,
		[v7.AssetTypeIdStrings.ShoulderAccessory] = true,
		[v7.AssetTypeIdStrings.FrontAccessory] = true,
		[v7.AssetTypeIdStrings.BackAccessory] = true,
		[v7.AssetTypeIdStrings.WaistAccessory] = true,
		[v7.AssetTypeIdStrings.TShirtAccessory] = true,
		[v7.AssetTypeIdStrings.ShirtAccessory] = true,
		[v7.AssetTypeIdStrings.PantsAccessory] = true,
		[v7.AssetTypeIdStrings.JacketAccessory] = true,
		[v7.AssetTypeIdStrings.SweaterAccessory] = true,
		[v7.AssetTypeIdStrings.ShortsAccessory] = true,
		[v7.AssetTypeIdStrings.LeftShoeAccessory] = true,
		[v7.AssetTypeIdStrings.RightShoeAccessory] = true,
		[v7.AssetTypeIdStrings.DressSkirtAccessory] = true
	}
	v7.ItemViewportAssetTypes = set7

	local set8 = {
		[v7.BundleTypeIdStrings.BodyParts] = true,
		[v7.BundleTypeIdStrings.DynamicHead] = true,
		[v7.BundleTypeIdStrings.Shoes] = true
	}
	v7.ItemViewportBundleTypes = set8
end

v7.RobloxCreatorName = "Roblox"

v7.NavigationParams = { fromSurface = "fromSurface", deepLinkId = "deepLinkId" }

return v7
