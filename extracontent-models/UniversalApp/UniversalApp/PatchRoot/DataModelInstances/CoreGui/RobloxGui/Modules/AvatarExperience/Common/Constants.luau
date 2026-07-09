local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local Modules = CoreGui.RobloxGui.Modules
local Symbol = require(CorePackages.Workspace.Packages.AppCommonLib).Symbol
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local ItemTypeEnum = AvatarExperienceCommon.Enums.ItemTypeEnum
local FullView = AvatarExperienceCommon.Enums.FullView

require(Modules.AvatarExperience.Common.Types)

local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local Constants = AvatarExperienceCommon.Constants
local GetFIntMaquettesAppPanelDistanceMultiplierPercentage = SharedFlags.GetFIntMaquettesAppPanelDistanceMultiplierPercentage
local FFlagUseUpdatedBackgroundSceneSettingsOnMobile = require(Modules.AvatarExperience.Flags.FFlagUseUpdatedBackgroundSceneSettingsOnMobile)
local AXItemDetails3DPreviewIXP = require(Modules.AvatarExperience.Experiments.AXItemDetails3DPreviewIXP)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local GetFFlagAXSupportShoesInItemViewport = require(Modules.AvatarExperience.Flags.GetFFlagAXSupportShoesInItemViewport)
local v16 = game:DefineFastInt("AXSponsoredItemsRow", 7)
local v17 = game:DefineFastFlag("AXEnableSearchLandingFocusedPageFullViewDefault", false)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXEditorSubcategoryFilters = AvatarExperienceFlags.FFlagAXEditorSubcategoryFilters
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXSlotsInventoryLoadableGridView = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXSlotsInventoryLoadableGridView
local GetFFlagAXEnableCategoryPills = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableCategoryPills)
local FFlagParseHeadShapeFromAPIResponse = AvatarExperienceFlags.FFlagParseHeadShapeFromAPIResponse
local CatalogCategories = AvatarExperienceCommon.Enums.CatalogCategories
local FFlagAXIncreaseDefaultPeekViewHeight = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXIncreaseDefaultPeekViewHeight
local FFlagIncreaseMarketplaceContentHeight = SharedFlags.FFlagIncreaseMarketplaceContentHeight
local v27 = game:DefineFastInt("AXCatalogMainNavHeight", 40)
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local FFlagAXCatalogOffersBannerEnabled = AvatarExperienceFlags.FFlagAXCatalogOffersBannerEnabled
local FFlagAXMoveCatalogFilterToL1Navigation = AvatarExperienceFlags.FFlagAXMoveCatalogFilterToL1Navigation
local FFlagAXEyebrowEyelashToMakeupCategory = AvatarExperienceFlags.FFlagAXEyebrowEyelashToMakeupCategory
local FFlagLuaAppForceVrAppPanelWidthRollout = SharedFlags.FFlagLuaAppForceVrAppPanelWidthRollout
local FFlagHeadRefinementFacialAnimationToggle = AvatarExperienceFlags.FFlagHeadRefinementFacialAnimationToggle
local FFlagAXCatalogBackgroundsSupport = AvatarExperienceFlags.FFlagAXCatalogBackgroundsSupport
local v37 = game:DefineFastFlag("AXMigrateMainNavHeightToFInt", false)
local v38 = game:DefineFastInt("AXMainNavHeight", 40)
local v39 = GetFIntMaquettesAppPanelDistanceMultiplierPercentage() / 100
local t1 = {
	_150x150 = "w=150&h=150",
	_420x420 = "w=420&h=420",
	_300x450 = "w=300&h=450"
}
local t2 = {
	Asset = t1,
	BundleThumbnail = t1,
	Look = t1
}
local t3 = {
	WidgetListHorizontalMargin = 15,
	WidgetListVerticalMargin = 10,
	PageButtonCornerRadius = 12,
	SponsoredItemsRow = v16,
	CatalogThumbnailTypeToSize = t2,
	DefaultCatalogCategoryId = CatalogCategories.Recommended:rawValue(),
	DeviceType = {
		Android = "Android",
		IOS = "iOS",
		Other = "Other"
	},
	BlockyBundleId = 356,
	NumRecommendedItems = 6,
	AnalyticsTag = "LuaAvatarExperience",
	ContentFeedAnalyticsTag = "ContentFeed",
	ProfileAnalyticsTag = "LuaProfile",
	DefaultRigPosition = Vector3.new(11.777738571166992, 6.766530990600586, 0.2743154764175415),
	AvatarType = {
		R6 = "R6",
		R15 = "R15"
	},
	ItemPromptType = {
		OpenPurchasePrompt = "OpenPurchasePrompt",
		OpenGoToAvatarEditorPrompt = "OpenGoToAvatarEditorPrompt",
		OpenPremiumUpsellPrompt = "OpenPremiumUpsellPrompt",
		Disabled = "Disabled",
		SoldOut = "SoldOut"
	},
	ItemTilePadding = 10,
	ItemTileTitleMaxLines = not FFlagAXMigrateAXToGlobalAutofocus and 2 or 1,
	EditorItemTileTitleMaxLines = if not FFlagAXSlotsInventoryLoadableGridView then nil else 1,
	ItemTileInnerPadding = 4,
	ItemTileTallAspectRatio = 0.7,
	ItemTileSquareAspectRatio = 1,
	LookTileAspectRatio = 0.7,
	CreatorNameItemTilePadding = 0,
	CreatorNameItemTileTitleMaxLines = 1,
	ImpressionsDetectionInterval = 1,
	FocusType = {
		Legs = "Legs",
		Face = "Face",
		Arms = "Arms",
		Head = "Head",
		Neck = "Neck",
		Waist = "Waist",
		Shoulders = "Shoulders",
		Makeup = "Makeup"
	},
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
		Emotes = "Emotes",
		Other = "Other",
		AllAnimation = "AllAnimation",
		MakeupLooks = if not FFlagAXCustomizeMakeupSupport then nil else "MakeupLooks"
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
	NavigationDirection = {
		IS_LEFT = "IS_LEFT",
		IS_RIGHT = "IS_RIGHT"
	},
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
	MainNavHeight = not v37 and 60 or v38,
	CatalogMainNavHeight = if not GetFFlagAXEnableCategoryPills() and not FFlagAXMoveCatalogFilterToL1Navigation then nil else v27,
	SubNavHeight = 40,
	MainNavPhotoboothHeight = 36,
	PillBarHeight = 52,
	CatalogOffersBannerPeekClosedExtraHeight = if not FFlagAXCatalogOffersBannerEnabled then nil else 48,
	FocusedWidgetTitleHeight = 52,
	ScrollYPositionDetectableEpsilon = 1,
	LooksDetailsTabBarHeight = 50,
	LandscapeNavWidth = 0.6,
	LandscapeUiMargin = 24,
	LandscapeSceneWidth = 0.4,
	LoadableGridViewCellPadding = 10,
	PortraitSceneHeight = if not FFlagIncreaseMarketplaceContentHeight then not FFlagAXIncreaseDefaultPeekViewHeight and 0.4 or 0.36 else 0.29,
	LandingPagePortraitSceneHeight = 0.5,
	LandingPagePortraitMinItemsHeightPix = 300,
	LandingPageMinTopFrameHeightPix = 100,
	LandingPageMinBottomFrameHeightPix = 65,
	PageButtonForegroundMinHeightPix = 100,
	SceneButtonSize = 44,
	SceneButtonCornerRadius = UDim.new(0, 8),
	SceneButtonHorizontalPadding = 24,
	DynamicHeadSplashMaxViews = 3,
	AccessoryAssetTypes = {
		[Enum.AccessoryType.Hat] = true,
		[Enum.AccessoryType.Face] = true,
		[Enum.AccessoryType.Neck] = true,
		[Enum.AccessoryType.Shoulder] = true,
		[Enum.AccessoryType.Front] = true,
		[Enum.AccessoryType.Back] = true,
		[Enum.AccessoryType.Waist] = true
	},
	BypassAccessoryLimitsAccessoryAssetTypeIdStrings = {
		[tostring(Enum.AssetType.Hat.Value)] = true,
		[tostring(Enum.AssetType.FaceAccessory.Value)] = true,
		[tostring(Enum.AssetType.NeckAccessory.Value)] = true,
		[tostring(Enum.AssetType.ShoulderAccessory.Value)] = true,
		[tostring(Enum.AssetType.FrontAccessory.Value)] = true,
		[tostring(Enum.AssetType.BackAccessory.Value)] = true,
		[tostring(Enum.AssetType.WaistAccessory.Value)] = true
	},
	ContextWidgetsAllowedRoutes = { AvatarScreen.Catalog },
	DraftLookId = "DraftLook",
	WearAfterPurchasePostPurchaseActionKey = "wearAfterPurchase",
	SaveAsCharacterPostPurchaseActionKey = "saveAsCharacter"
}

if FFlagAXCustomizeMakeupSupport then
	t3.AssetCategories.Makeup = "Makeup"
end

if FFlagAXCatalogBackgroundsSupport then
	t3.AssetCategories.Backgrounds = "Backgrounds"
end

t3.BundleTypeIdStrings = Constants.BUNDLE_TYPE_ID_STRINGS
t3.BundleTypeIdStringToName = Constants.BUNDLE_TYPE_ID_STRING_TO_NAME
t3.BundleTypeIdStringToNameForBackend = Constants.BUNDLE_TYPE_ID_STRING_TO_NAME_FOR_BACKEND
t3.BundleTypeNameToIdStringForCatalogHydration = {
	BodyParts = "1",
	AvatarAnimations = "2",
	Shoes = "3",
	DynamicHead = "4"
}

if FFlagAXInventoryDurablesSupport and FFlagAXEditorSubcategoryFilters then
	t3.BundleTypeIdStringsForBackend = {
		[t3.BundleTypeIdStrings.BodyParts] = "1",
		[t3.BundleTypeIdStrings.DynamicHead] = "2",
		[t3.BundleTypeIdStrings.Avatars] = "3",
		[t3.BundleTypeIdStrings.Shoes] = "4",
		[t3.BundleTypeIdStrings.Animations] = "5"
	}
elseif FFlagAXEditorSubcategoryFilters then
	t3.BundleTypeIdStringsForBackend = {
		[t3.BundleTypeIdStrings.BodyParts] = "1",
		[t3.BundleTypeIdStrings.DynamicHead] = "2",
		[t3.BundleTypeIdStrings.Shoes] = "4",
		[t3.BundleTypeIdStrings.Animations] = "5"
	}
else
	t3.BundleTypeIdStringsForBackend = {
		[t3.BundleTypeIdStrings.BodyParts] = "1",
		[t3.BundleTypeIdStrings.DynamicHead] = "2",
		[t3.BundleTypeIdStrings.Shoes] = "3",
		[t3.BundleTypeIdStrings.Animations] = "4"
	}
end

t3.AssetTypeIdStrings = Constants.ASSET_TYPE_NAME_TO_ID_STRING
t3.AssetTypeIdStringToName = Constants.ASSET_TYPE_ID_STRING_TO_NAME
t3.DynamicHeadAssetTypes = {
	[t3.AssetTypeIdStrings.EyebrowAccessory] = true,
	[t3.AssetTypeIdStrings.EyelashAccessory] = true,
	[t3.AssetTypeIdStrings.MoodAnimation] = true,
	[t3.AssetTypeIdStrings.DynamicHead] = true
}
t3.OutfitTypes = AvatarExperienceCommon.Enums.OutfitTypes
t3.BundleTypeIdStringToOutfitType = {
	[t3.BundleTypeIdStrings.BodyParts] = t3.OutfitTypes.Avatar,
	[t3.BundleTypeIdStrings.DynamicHead] = t3.OutfitTypes.DynamicHead,
	[t3.BundleTypeIdStrings.Shoes] = t3.OutfitTypes.Shoes,
	[t3.BundleTypeIdStrings.Animations] = if not GetFFlagAXEnableSlotBasedEditor() then nil else t3.OutfitTypes.Animations
}
t3.InventoryTypeToBundleTypeId = {
	Body = t3.BundleTypeIdStrings.BodyParts,
	DynamicHead = t3.BundleTypeIdStrings.DynamicHead,
	Shoes = t3.BundleTypeIdStrings.Shoes,
	Animations = t3.BundleTypeIdStrings.Animations
}
t3.ItemTileType = {
	AvatarEditorTile = "AvatarEditorTile",
	BodyColorButton = "BodyColorButton",
	BundleItemTile = "BundleItemTile",
	BundleItemTileNoText = "BundleItemTileNoText",
	CatalogItemTile = "CatalogItemTile",
	RecommendedCatalogItemTile = "RecommendedCatalogItemTile",
	TallCatalogItemTile = "TallCatalogItemTile",
	LookItemTile = "LookItemTile"
}
t3.ItemType = ItemTypeEnum
t3.LookType = Constants.LOOK_TYPE

function t3.confirmItemType(s1: string) -- line: 379
	-- upvalues: t3 (copy)
	if s1 == t3.ItemType.Asset then
		return t3.ItemType.Asset
	end

	if s1 == t3.ItemType.Bundle then
		return t3.ItemType.Bundle
	end

	if s1 == t3.ItemType.Outfit then
		return t3.ItemType.Asset
	end

	return nil
end

t3.AnalyticsContext = {
	[AvatarScreen.AvatarExperienceLandingPage] = AvatarScreen.AvatarExperienceLandingPage,
	[AvatarScreen.Catalog] = AvatarScreen.Catalog,
	[AvatarScreen.CatalogSearch] = AvatarScreen.CatalogSearch,
	[AvatarScreen.AvatarEditor] = AvatarScreen.AvatarEditor,
	[AvatarScreen.ProfilePictureEditorEmotes] = AvatarScreen.ProfilePictureEditorEmotes,
	[AvatarScreen.AccessoryAdjustment] = AvatarScreen.AccessoryAdjustment,
	[AvatarScreen.AvatarRefinement] = AvatarScreen.AvatarRefinement,
	[AvatarScreen.AdjustAccessoryView] = AvatarScreen.AdjustAccessoryView,
	[AvatarScreen.LayeredClothingSort] = AvatarScreen.LayeredClothingSort,
	[AvatarScreen.LayeredMakeupSort] = if not FFlagAXCustomizeMakeupSupport then nil else AvatarScreen.LayeredMakeupSort,
	[AvatarScreen.CatalogSearchLanding] = AvatarScreen.CatalogSearchLanding,
	[AvatarScreen.MySharedAvatars] = AvatarScreen.MySharedAvatars,
	[AvatarScreen.FavoritesSaved] = AvatarScreen.FavoritesSaved,
	[AvatarScreen.HeadRefinement] = AvatarScreen.HeadRefinement,
	[AvatarScreen.SearchLandingFocusedWidgetPage] = AvatarScreen.SearchLandingFocusedWidgetPage,
	[AvatarScreen.BodyShape] = if not GetFFlagAXEnableSlotBasedEditor() then nil else AvatarScreen.BodyShape,
	[AvatarScreen.AvatarSwitcher] = if not GetFFlagAXEnableSlotBasedEditor() then nil else AvatarScreen.AvatarSwitcher,
	[AvatarScreen.EditEmotes] = if not GetFFlagAXEnableSlotBasedEditor() then nil else AvatarScreen.EditEmotes,
	[AvatarScreen.TryOnItem] = AvatarScreen.TryOnItem,
	[AvatarScreen.Photobooth] = if not AvatarExperienceFlags.FFlagAXPhotoboothFunctionality then nil else AvatarScreen.Photobooth
}
t3.PagePlayParticleType = {
	[AvatarScreen.AvatarEditor] = t3.ParticleType.CatalogToAvatarEditor,
	[AvatarScreen.MySharedAvatars] = t3.ParticleType.CatalogToAvatarEditor,
	[AvatarScreen.ProfilePictureEditorEmotes] = t3.ParticleType.CatalogToAvatarEditor,
	[AvatarScreen.ProfilePictureEditorCamera] = t3.ParticleType.None,
	[AvatarScreen.ProfilePictureEditorFinal] = t3.ParticleType.None,
	[AvatarScreen.AvatarBackground] = t3.ParticleType.None,
	[AvatarScreen.Catalog] = t3.ParticleType.AvatarEditorToCatalog
}
t3.PageBackgroundType = {
	[AvatarScreen.AvatarEditor] = t3.BackgroundType.LargerShapes,
	[AvatarScreen.MySharedAvatars] = t3.BackgroundType.LargerShapes,
	[AvatarScreen.ProfilePictureEditorEmotes] = t3.BackgroundType.LargerShapes,
	[AvatarScreen.ProfilePictureEditorCamera] = t3.BackgroundType.NoShapesNoWalls,
	[AvatarScreen.ProfilePictureEditorFinal] = t3.BackgroundType.NoShapesNoWalls,
	[AvatarScreen.AvatarBackground] = t3.BackgroundType.Walls,
	[AvatarScreen.Catalog] = if not FFlagUseUpdatedBackgroundSceneSettingsOnMobile then t3.BackgroundType.Walls else t3.BackgroundType.LargerShapes,
	[AvatarScreen.AvatarExperienceLandingPage] = t3.BackgroundType.Walls
}
t3.AttachmentName = {
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
t3.PartName = {
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
t3.AssetTypeIdToPartsAndAttachments = {
	[t3.AvatarType.R6] = {
		[t3.AssetTypeIdStrings.Hat] = {{
			Part = t3.PartName.Head,
			Attachment = t3.AttachmentName.HatAttachment
		}},
		[t3.AssetTypeIdStrings.HairAccessory] = {{
			Part = t3.PartName.Head,
			Attachment = t3.AttachmentName.HairAttachment
		}},
		[t3.AssetTypeIdStrings.FaceAccessory] = {{
			Part = t3.PartName.Head,
			Attachment = t3.AttachmentName.FaceFrontAttachment
		}},
		[t3.AssetTypeIdStrings.NeckAccessory] = {{
			Part = t3.PartName.Head
		}},
		[t3.AssetTypeIdStrings.FrontAccessory] = {{
			Part = t3.PartName.R6_BODY_PARTS.Torso
		}},
		[t3.AssetTypeIdStrings.BackAccessory] = {{
			Part = t3.PartName.R6_BODY_PARTS.Torso
		}},
		[t3.AssetTypeIdStrings.WaistAccessory] = {{
			Part = t3.PartName.R6_BODY_PARTS.Torso
		}},
		[t3.AssetTypeIdStrings.Shirt] = {
			{
				Part = t3.PartName.R6_BODY_PARTS.RightArm
			},
			{
				Part = t3.PartName.R6_BODY_PARTS.LeftArm
			},
			{
				Part = t3.PartName.R6_BODY_PARTS.Torso
			}
		},
		[t3.AssetTypeIdStrings.TShirt] = {
			{
				Part = t3.PartName.R6_BODY_PARTS.RightArm
			},
			{
				Part = t3.PartName.R6_BODY_PARTS.LeftArm
			},
			{
				Part = t3.PartName.R6_BODY_PARTS.Torso
			}
		},
		[t3.AssetTypeIdStrings.Pants] = {
			{
				Part = t3.PartName.R6_BODY_PARTS.RightLeg
			},
			{
				Part = t3.PartName.R6_BODY_PARTS.LeftLeg
			}
		},
		[t3.AssetTypeIdStrings.Head] = {{
			Part = t3.PartName.Head
		}},
		[t3.AssetTypeIdStrings.Face] = {{
			Part = t3.PartName.Head
		}},
		[t3.AssetTypeIdStrings.Torso] = {{
			Part = t3.PartName.R6_BODY_PARTS.Torso
		}},
		[t3.AssetTypeIdStrings.RightArm] = {{
			Part = t3.PartName.R6_BODY_PARTS.RightArm
		}},
		[t3.AssetTypeIdStrings.LeftArm] = {{
			Part = t3.PartName.R6_BODY_PARTS.LeftArm
		}},
		[t3.AssetTypeIdStrings.RightLeg] = {{
			Part = t3.PartName.R6_BODY_PARTS.RightLeg
		}},
		[t3.AssetTypeIdStrings.LeftLeg] = {{
			Part = t3.PartName.R6_BODY_PARTS.LeftLeg
		}},
		[t3.AssetTypeIdStrings.ClimbAnimation] = {{
			Part = t3.PartName.R6_BODY_PARTS.Torso
		}},
		[t3.AssetTypeIdStrings.FallAnimation] = {{
			Part = t3.PartName.R6_BODY_PARTS.Torso
		}},
		[t3.AssetTypeIdStrings.IdleAnimation] = {{
			Part = t3.PartName.R6_BODY_PARTS.Torso
		}},
		[t3.AssetTypeIdStrings.JumpAnimation] = {{
			Part = t3.PartName.R6_BODY_PARTS.Torso
		}},
		[t3.AssetTypeIdStrings.RunAnimation] = {{
			Part = t3.PartName.R6_BODY_PARTS.Torso
		}},
		[t3.AssetTypeIdStrings.SwimAnimation] = {{
			Part = t3.PartName.R6_BODY_PARTS.Torso
		}},
		[t3.AssetTypeIdStrings.WalkAnimation] = {{
			Part = t3.PartName.R6_BODY_PARTS.Torso
		}},
		[t3.AssetTypeIdStrings.TShirtAccessory] = {{
			Part = t3.PartName.R6_BODY_PARTS.Torso
		}},
		[t3.AssetTypeIdStrings.ShirtAccessory] = {{
			Part = t3.PartName.R6_BODY_PARTS.Torso
		}},
		[t3.AssetTypeIdStrings.PantsAccessory] = {
			{
				Part = t3.PartName.R6_BODY_PARTS.RightLeg
			},
			{
				Part = t3.PartName.R6_BODY_PARTS.LeftLeg
			}
		},
		[t3.AssetTypeIdStrings.JacketAccessory] = {{
			Part = t3.PartName.R6_BODY_PARTS.Torso
		}},
		[t3.AssetTypeIdStrings.SweaterAccessory] = {{
			Part = t3.PartName.R6_BODY_PARTS.Torso
		}},
		[t3.AssetTypeIdStrings.ShortsAccessory] = {
			{
				Part = t3.PartName.R6_BODY_PARTS.RightLeg
			},
			{
				Part = t3.PartName.R6_BODY_PARTS.LeftLeg
			}
		},
		[t3.AssetTypeIdStrings.LeftShoeAccessory] = {{
			Part = t3.PartName.R6_BODY_PARTS.LeftLeg
		}},
		[t3.AssetTypeIdStrings.RightShoeAccessory] = {{
			Part = t3.PartName.R6_BODY_PARTS.RightLeg
		}},
		[t3.AssetTypeIdStrings.DressSkirtAccessory] = {
			{
				Part = t3.PartName.R6_BODY_PARTS.RightLeg
			},
			{
				Part = t3.PartName.R6_BODY_PARTS.LeftLeg
			}
		}
	},
	[t3.AvatarType.R15] = {
		[t3.AssetTypeIdStrings.Hat] = {{
			Part = t3.PartName.Head,
			Attachment = t3.AttachmentName.HatAttachment
		}},
		[t3.AssetTypeIdStrings.HairAccessory] = {{
			Part = t3.PartName.Head,
			Attachment = t3.AttachmentName.HairAttachment
		}},
		[t3.AssetTypeIdStrings.FaceAccessory] = {{
			Part = t3.PartName.Head,
			Attachment = t3.AttachmentName.FaceFrontAttachment
		}},
		[t3.AssetTypeIdStrings.NeckAccessory] = {{
			Part = t3.PartName.R15_BODY_PARTS.UpperTorso,
			Attachment = t3.AttachmentName.NeckAttachment
		}},
		[t3.AssetTypeIdStrings.FrontAccessory] = {{
			Part = t3.PartName.R15_BODY_PARTS.UpperTorso,
			Attachment = t3.AttachmentName.BodyFrontAttachment
		}},
		[t3.AssetTypeIdStrings.BackAccessory] = {{
			Part = t3.PartName.R15_BODY_PARTS.UpperTorso,
			Attachment = t3.AttachmentName.BodyBackAttachment
		}},
		[t3.AssetTypeIdStrings.WaistAccessory] = {{
			Part = t3.PartName.R15_BODY_PARTS.LowerTorso,
			Attachment = t3.AttachmentName.WaistCenterAttachment
		}},
		[t3.AssetTypeIdStrings.Shirt] = {
			{
				Part = t3.PartName.R15_BODY_PARTS.RightUpperArm
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.LeftUpperArm
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.UpperTorso
			}
		},
		[t3.AssetTypeIdStrings.TShirt] = {
			{
				Part = t3.PartName.R15_BODY_PARTS.RightUpperArm
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.LeftUpperArm
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.UpperTorso
			}
		},
		[t3.AssetTypeIdStrings.Pants] = {
			{
				Part = t3.PartName.R15_BODY_PARTS.RightUpperLeg
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.RightLowerLeg
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.LeftUpperLeg
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.LeftLowerLeg
			}
		},
		[t3.AssetTypeIdStrings.Head] = {{
			Part = t3.PartName.Head
		}},
		[t3.AssetTypeIdStrings.Face] = {{
			Part = t3.PartName.Head
		}},
		[t3.AssetTypeIdStrings.Torso] = {{
			Part = t3.PartName.R15_BODY_PARTS.UpperTorso
		}},
		[t3.AssetTypeIdStrings.RightArm] = {
			{
				Part = t3.PartName.R15_BODY_PARTS.RightUpperArm
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.RightLowerArm
			}
		},
		[t3.AssetTypeIdStrings.LeftArm] = {
			{
				Part = t3.PartName.R15_BODY_PARTS.LeftUpperArm
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.LeftLowerArm
			}
		},
		[t3.AssetTypeIdStrings.RightLeg] = {
			{
				Part = t3.PartName.R15_BODY_PARTS.RightUpperLeg
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.RightLowerLeg
			}
		},
		[t3.AssetTypeIdStrings.LeftLeg] = {
			{
				Part = t3.PartName.R15_BODY_PARTS.LeftUpperLeg
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.LeftLowerLeg
			}
		},
		[t3.AssetTypeIdStrings.ClimbAnimation] = {{
			Part = t3.PartName.R15_BODY_PARTS.UpperTorso
		}},
		[t3.AssetTypeIdStrings.FallAnimation] = {{
			Part = t3.PartName.R15_BODY_PARTS.UpperTorso
		}},
		[t3.AssetTypeIdStrings.IdleAnimation] = {{
			Part = t3.PartName.R15_BODY_PARTS.UpperTorso
		}},
		[t3.AssetTypeIdStrings.JumpAnimation] = {{
			Part = t3.PartName.R15_BODY_PARTS.UpperTorso
		}},
		[t3.AssetTypeIdStrings.RunAnimation] = {{
			Part = t3.PartName.R15_BODY_PARTS.UpperTorso
		}},
		[t3.AssetTypeIdStrings.SwimAnimation] = {{
			Part = t3.PartName.R15_BODY_PARTS.UpperTorso
		}},
		[t3.AssetTypeIdStrings.WalkAnimation] = {{
			Part = t3.PartName.R15_BODY_PARTS.UpperTorso
		}},
		[t3.AssetTypeIdStrings.TShirtAccessory] = {{
			Part = t3.PartName.R15_BODY_PARTS.UpperTorso
		}},
		[t3.AssetTypeIdStrings.ShirtAccessory] = {{
			Part = t3.PartName.R15_BODY_PARTS.UpperTorso
		}},
		[t3.AssetTypeIdStrings.PantsAccessory] = {
			{
				Part = t3.PartName.R15_BODY_PARTS.RightUpperLeg
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.RightLowerLeg
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.LeftUpperLeg
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.LeftLowerLeg
			}
		},
		[t3.AssetTypeIdStrings.JacketAccessory] = {{
			Part = t3.PartName.R15_BODY_PARTS.UpperTorso
		}},
		[t3.AssetTypeIdStrings.SweaterAccessory] = {{
			Part = t3.PartName.R15_BODY_PARTS.UpperTorso
		}},
		[t3.AssetTypeIdStrings.ShortsAccessory] = {
			{
				Part = t3.PartName.R15_BODY_PARTS.RightUpperLeg
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.LeftUpperLeg
			}
		},
		[t3.AssetTypeIdStrings.LeftShoeAccessory] = {{
			Part = t3.PartName.R15_BODY_PARTS.LeftFoot
		}},
		[t3.AssetTypeIdStrings.RightShoeAccessory] = {{
			Part = t3.PartName.R15_BODY_PARTS.RightFoot
		}},
		[t3.AssetTypeIdStrings.DressSkirtAccessory] = {
			{
				Part = t3.PartName.R15_BODY_PARTS.RightUpperLeg
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.LeftUpperLeg
			}
		}
	}
}
t3.AvatarTypeFocusGroups = {
	[t3.AvatarType.R15] = {
		[t3.FocusType.Legs] = {
			{
				Part = t3.PartName.R15_BODY_PARTS.RightUpperLeg
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.LeftUpperLeg
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.RightLowerLeg
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.LeftLowerLeg
			}
		},
		[t3.FocusType.Face] = {{
			Part = t3.PartName.Head,
			Attachment = t3.AttachmentName.FaceFrontAttachment
		}},
		[t3.FocusType.Makeup] = {{
			Part = t3.PartName.Makeup
		}},
		[t3.FocusType.Arms] = {{
			Part = t3.PartName.R15_BODY_PARTS.UpperTorso
		}},
		[t3.FocusType.Head] = {
			{
				Part = t3.PartName.Head,
				Attachment = t3.AttachmentName.HatAttachment
			},
			{
				Part = t3.PartName.Head,
				Attachment = t3.AttachmentName.NeckRigAttachment
			}
		},
		[t3.FocusType.Neck] = {
			{
				Part = t3.PartName.Head
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.UpperTorso
			}
		},
		[t3.FocusType.Waist] = {
			{
				Part = t3.PartName.R15_BODY_PARTS.LowerTorso
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.RightUpperLeg
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.LeftUpperLeg
			}
		},
		[t3.FocusType.Shoulders] = {
			{
				Part = t3.PartName.Head
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.RightUpperArm
			},
			{
				Part = t3.PartName.R15_BODY_PARTS.LeftUpperArm
			}
		}
	},
	[t3.AvatarType.R6] = {
		[t3.FocusType.Legs] = {
			{
				Part = t3.PartName.R6_BODY_PARTS.RightLeg
			},
			{
				Part = t3.PartName.R6_BODY_PARTS.LeftLeg
			}
		},
		[t3.FocusType.Face] = {{
			Part = t3.PartName.Head,
			Attachment = t3.AttachmentName.FaceFrontAttachment
		}},
		[t3.FocusType.Arms] = {{
			Part = t3.PartName.R6_BODY_PARTS.Torso
		}},
		[t3.FocusType.Head] = {
			{
				Part = t3.PartName.Head,
				Attachment = t3.AttachmentName.HatAttachment
			},
			{
				Part = t3.PartName.Head,
				Attachment = t3.AttachmentName.NeckRigAttachment
			}
		},
		[t3.FocusType.Neck] = {
			{
				Part = t3.PartName.Head
			},
			{
				Part = t3.PartName.R6_BODY_PARTS.Torso
			}
		},
		[t3.FocusType.Waist] = {
			{
				Part = t3.PartName.R6_BODY_PARTS.Torso
			},
			{
				Part = t3.PartName.R6_BODY_PARTS.RightLeg
			},
			{
				Part = t3.PartName.R6_BODY_PARTS.LeftLeg
			}
		},
		[t3.FocusType.Shoulders] = {
			{
				Part = t3.PartName.Head
			},
			{
				Part = t3.PartName.R6_BODY_PARTS.RightArm
			},
			{
				Part = t3.PartName.R6_BODY_PARTS.LeftArm
			}
		}
	}
}
t3.AssetTypeIdToCategory = {
	[t3.AssetTypeIdStrings.TShirt] = t3.AssetCategories.Clothing,
	[t3.AssetTypeIdStrings.Hat] = t3.AssetCategories.Accessory,
	[t3.AssetTypeIdStrings.HairAccessory] = t3.AssetCategories.Accessory,
	[t3.AssetTypeIdStrings.FaceAccessory] = t3.AssetCategories.Accessory,
	[t3.AssetTypeIdStrings.NeckAccessory] = t3.AssetCategories.Accessory,
	[t3.AssetTypeIdStrings.ShoulderAccessory] = t3.AssetCategories.Accessory,
	[t3.AssetTypeIdStrings.FrontAccessory] = t3.AssetCategories.Accessory,
	[t3.AssetTypeIdStrings.BackAccessory] = t3.AssetCategories.Accessory,
	[t3.AssetTypeIdStrings.WaistAccessory] = t3.AssetCategories.Accessory,
	[t3.AssetTypeIdStrings.Shirt] = t3.AssetCategories.Clothing,
	[t3.AssetTypeIdStrings.Pants] = t3.AssetCategories.Clothing,
	[t3.AssetTypeIdStrings.Gear] = t3.AssetCategories.Accessory,
	[t3.AssetTypeIdStrings.Head] = t3.AssetCategories.Body,
	[t3.AssetTypeIdStrings.Face] = t3.AssetCategories.Body,
	[t3.AssetTypeIdStrings.Torso] = t3.AssetCategories.Body,
	[t3.AssetTypeIdStrings.RightArm] = t3.AssetCategories.Body,
	[t3.AssetTypeIdStrings.LeftArm] = t3.AssetCategories.Body,
	[t3.AssetTypeIdStrings.RightLeg] = t3.AssetCategories.Body,
	[t3.AssetTypeIdStrings.LeftLeg] = t3.AssetCategories.Body,
	[t3.AssetTypeIdStrings.ClimbAnimation] = t3.AssetCategories.Animation,
	[t3.AssetTypeIdStrings.FallAnimation] = t3.AssetCategories.Animation,
	[t3.AssetTypeIdStrings.IdleAnimation] = t3.AssetCategories.Animation,
	[t3.AssetTypeIdStrings.JumpAnimation] = t3.AssetCategories.Animation,
	[t3.AssetTypeIdStrings.RunAnimation] = t3.AssetCategories.Animation,
	[t3.AssetTypeIdStrings.SwimAnimation] = t3.AssetCategories.Animation,
	[t3.AssetTypeIdStrings.WalkAnimation] = t3.AssetCategories.Animation,
	[t3.AssetTypeIdStrings.EmoteAnimation] = t3.AssetCategories.Animation,
	[t3.AssetTypeIdStrings.TShirtAccessory] = t3.AssetCategories.Accessory,
	[t3.AssetTypeIdStrings.ShirtAccessory] = t3.AssetCategories.Accessory,
	[t3.AssetTypeIdStrings.PantsAccessory] = t3.AssetCategories.Accessory,
	[t3.AssetTypeIdStrings.JacketAccessory] = t3.AssetCategories.Accessory,
	[t3.AssetTypeIdStrings.SweaterAccessory] = t3.AssetCategories.Accessory,
	[t3.AssetTypeIdStrings.ShortsAccessory] = t3.AssetCategories.Accessory,
	[t3.AssetTypeIdStrings.LeftShoeAccessory] = t3.AssetCategories.Accessory,
	[t3.AssetTypeIdStrings.RightShoeAccessory] = t3.AssetCategories.Accessory,
	[t3.AssetTypeIdStrings.DressSkirtAccessory] = t3.AssetCategories.Accessory,
	[t3.AssetTypeIdStrings.MoodAnimation] = t3.AssetCategories.Animation,
	[t3.AssetTypeIdStrings.EyebrowAccessory] = t3.AssetCategories.Accessory,
	[t3.AssetTypeIdStrings.EyelashAccessory] = t3.AssetCategories.Accessory,
	[t3.AssetTypeIdStrings.DynamicHead] = t3.AssetCategories.Body
}

if FFlagAXCustomizeMakeupSupport then
	t3.AssetTypeIdToCategory[t3.AssetTypeIdStrings.FaceMakeup] = t3.AssetCategories.Makeup
	t3.AssetTypeIdToCategory[t3.AssetTypeIdStrings.LipMakeup] = t3.AssetCategories.Makeup
	t3.AssetTypeIdToCategory[t3.AssetTypeIdStrings.EyeMakeup] = t3.AssetCategories.Makeup
end

if FFlagAXEyebrowEyelashToMakeupCategory then
	t3.AssetTypeIdToCategory[t3.AssetTypeIdStrings.EyebrowAccessory] = t3.AssetCategories.Makeup
	t3.AssetTypeIdToCategory[t3.AssetTypeIdStrings.EyelashAccessory] = t3.AssetCategories.Makeup
end

if FFlagAXCatalogBackgroundsSupport then
	t3.AssetTypeIdToCategory[t3.AssetTypeIdStrings.AvatarBackground] = t3.AssetCategories.Backgrounds
end

t3.GradientBackgroundAssetTypeIds = {
	[t3.AssetTypeIdStrings.TShirtAccessory] = true,
	[t3.AssetTypeIdStrings.ShirtAccessory] = true,
	[t3.AssetTypeIdStrings.PantsAccessory] = true,
	[t3.AssetTypeIdStrings.JacketAccessory] = true,
	[t3.AssetTypeIdStrings.SweaterAccessory] = true,
	[t3.AssetTypeIdStrings.ShortsAccessory] = true,
	[t3.AssetTypeIdStrings.LeftShoeAccessory] = true,
	[t3.AssetTypeIdStrings.RightShoeAccessory] = true,
	[t3.AssetTypeIdStrings.DressSkirtAccessory] = true
}
t3.AssetCategoriesLocalized = {
	[t3.AssetCategories.Animation] = "Feature.Catalog.Label.Animation",
	[t3.AssetCategories.Body] = "Feature.Catalog.Label.Body",
	[t3.AssetCategories.Clothing] = "Feature.Avatar.Heading.Clothing",
	[t3.AssetCategories.Accessory] = "Feature.Avatar.Label.Accessory",
	[t3.AssetCategories.Emotes] = "Feature.Catalog.Label.Emotes"
}

if FFlagAXCustomizeMakeupSupport then
	t3.AssetCategoriesLocalized[t3.AssetCategories.Makeup] = "Feature.Catalog.Label.Makeup"
end

if FFlagAXCatalogBackgroundsSupport then
	t3.AssetCategoriesLocalized[t3.AssetCategories.Backgrounds] = "Feature.Avatar.Label.Backgrounds"
end

t3.AssetTypeLocalized = {
	[t3.AssetTypeIdStrings.TShirt] = "Feature.Avatar.Label.ClassicTShirts",
	[t3.AssetTypeIdStrings.Hat] = "Feature.Avatar.Label.Hat",
	[t3.AssetTypeIdStrings.HairAccessory] = "Feature.Avatar.Label.Hair",
	[t3.AssetTypeIdStrings.FaceAccessory] = "Feature.Avatar.Label.Face",
	[t3.AssetTypeIdStrings.NeckAccessory] = "Feature.Avatar.Label.Neck",
	[t3.AssetTypeIdStrings.ShoulderAccessory] = "Feature.Avatar.Label.Shoulder",
	[t3.AssetTypeIdStrings.FrontAccessory] = "Feature.Avatar.Label.Front",
	[t3.AssetTypeIdStrings.BackAccessory] = "Feature.Avatar.Label.Back",
	[t3.AssetTypeIdStrings.WaistAccessory] = "Feature.Avatar.Label.Waist",
	[t3.AssetTypeIdStrings.Shirt] = "Feature.Avatar.Label.ClassicShirts",
	[t3.AssetTypeIdStrings.Pants] = "Feature.Avatar.Label.ClassicPants",
	[t3.AssetTypeIdStrings.Gear] = "Feature.Avatar.Label.Gear",
	[t3.AssetTypeIdStrings.Head] = "Feature.Avatar.Label.Head",
	[t3.AssetTypeIdStrings.Face] = "Feature.Avatar.Label.Face",
	[t3.AssetTypeIdStrings.Torso] = "Feature.Avatar.Label.Torso",
	[t3.AssetTypeIdStrings.RightArm] = "Feature.Avatar.Label.RightArms",
	[t3.AssetTypeIdStrings.LeftArm] = "Feature.Avatar.Label.LeftArms",
	[t3.AssetTypeIdStrings.LeftLeg] = "Feature.Avatar.Label.LeftLegs",
	[t3.AssetTypeIdStrings.RightLeg] = "Feature.Avatar.Label.RightLegs",
	[t3.AssetTypeIdStrings.ClimbAnimation] = "Feature.Avatar.Label.Climb",
	[t3.AssetTypeIdStrings.FallAnimation] = "Feature.Avatar.Label.Fall",
	[t3.AssetTypeIdStrings.IdleAnimation] = "Feature.Avatar.Label.Idle",
	[t3.AssetTypeIdStrings.JumpAnimation] = "Feature.Avatar.Label.Jump",
	[t3.AssetTypeIdStrings.RunAnimation] = "Feature.Avatar.Label.Run",
	[t3.AssetTypeIdStrings.SwimAnimation] = "Feature.Avatar.Label.Swim",
	[t3.AssetTypeIdStrings.WalkAnimation] = "Feature.Avatar.Label.Walk",
	[t3.AssetTypeIdStrings.EmoteAnimation] = "Feature.Avatar.Label.Emote",
	[t3.AssetTypeIdStrings.TShirtAccessory] = "Feature.Avatar.Label.TShirt",
	[t3.AssetTypeIdStrings.ShirtAccessory] = "Feature.Avatar.Label.Shirt",
	[t3.AssetTypeIdStrings.PantsAccessory] = "Feature.Avatar.Label.Pants",
	[t3.AssetTypeIdStrings.JacketAccessory] = "Feature.Avatar.Label.Jacket",
	[t3.AssetTypeIdStrings.SweaterAccessory] = "Feature.Avatar.Label.Sweater",
	[t3.AssetTypeIdStrings.ShortsAccessory] = "Feature.Avatar.Label.Shorts",
	[t3.AssetTypeIdStrings.LeftShoeAccessory] = "Feature.Avatar.Label.LeftShoe",
	[t3.AssetTypeIdStrings.RightShoeAccessory] = "Feature.Avatar.Label.RightShoe",
	[t3.AssetTypeIdStrings.DressSkirtAccessory] = "Feature.Avatar.Label.DressesAndSkirts",
	[t3.AssetTypeIdStrings.EyelashAccessory] = "Feature.Catalog.Label.Eyelash",
	[t3.AssetTypeIdStrings.EyebrowAccessory] = "Feature.Catalog.Label.Eyebrow",
	[t3.AssetTypeIdStrings.MoodAnimation] = "Feature.Avatar.Label.Mood",
	[t3.AssetTypeIdStrings.DynamicHead] = "Feature.Avatar.Label.DynamicHead"
}

if FFlagAXCustomizeMakeupSupport then
	t3.AssetTypeLocalized[t3.AssetTypeIdStrings.FaceMakeup] = "Feature.Catalog.Label.FaceMakeup"
	t3.AssetTypeLocalized[t3.AssetTypeIdStrings.LipMakeup] = "Feature.Catalog.Label.LipMakeup"
	t3.AssetTypeLocalized[t3.AssetTypeIdStrings.EyeMakeup] = "Feature.Catalog.Label.EyeMakeup"
end

if FFlagAXCatalogBackgroundsSupport then
	t3.AssetTypeLocalized[t3.AssetTypeIdStrings.AvatarBackground] = "Feature.Avatar.Label.Backgrounds"
end

if FFlagHeadRefinementFacialAnimationToggle then
	t3.StaticFacialAnimation = "StaticFacialAnimation"
end

t3.AssetTypeIdStringToHumanoidDescriptionProp = {
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
t3.HumanoidDescriptionScaleToName = {
	bodyType = "BodyTypeScale",
	head = "HeadScale",
	height = "HeightScale",
	proportion = "ProportionScale",
	depth = "DepthScale",
	width = "WidthScale"
}
t3.BodyPartForSkinColoringIdToHumanoidDescription = {
	headColor3 = "HeadColor",
	leftArmColor3 = "LeftArmColor",
	leftLegColor3 = "LeftLegColor",
	rightArmColor3 = "RightArmColor",
	rightLegColor3 = "RightLegColor",
	torsoColor3 = "TorsoColor"
}

if FFlagParseHeadShapeFromAPIResponse then
	t3.BodyPartNameToEnum = {
		Head = Enum.BodyPart.Head,
		LeftArm = Enum.BodyPart.LeftArm,
		LeftLeg = Enum.BodyPart.LeftLeg,
		RightArm = Enum.BodyPart.RightArm,
		RightLeg = Enum.BodyPart.RightLeg,
		Torso = Enum.BodyPart.Torso
	}
end

t3.GamepadInputTypes = {
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
t3.ThumbstickDeadzone = 0.2
t3.SceneGamepad = {
	FullViewIndicatorTag = Symbol.named("FullViewIndicatorTag")
}
t3.AnimationCategoryCameraZoomRadius = 5
t3.SceneRowHeight = 28
t3.LayeredClothingOrder = Constants.LAYERED_CLOTHING_ORDER
t3.LCIgnoredForSorting = {
	[t3.AssetTypeIdStrings.HairAccessory] = true,
	[t3.AssetTypeIdStrings.EyebrowAccessory] = true,
	[t3.AssetTypeIdStrings.EyelashAccessory] = true
}
t3.AssetTypeIdToAccessoryTypeEnum = Constants.ASSET_TYPE_TO_ACCESSORY_TYPE
t3.AccessoryTypeEnumToAssetTypeId = Constants.ACCESSORY_TYPE_TO_ASSET_TYPE
t3.LayeredAssetTypes = Constants.LAYERED_ASSET_TYPES
t3.AssetCategory = {
	LCTops = "LCTops",
	LCBottoms = "LCBottoms"
}
t3.NavOuterPadding = 6
t3.NavInnerPadding = 6
t3.NavButtonElementPadding = 4
t3.NavButtonElementMargin = 4
t3.NavCornerSize = 8
t3.NavButtonBorderSize = 2
t3.NavSubButtonInnerPadding = 4
t3.MinTileWidthToFontHeightRatio = 6
t3.SmallRadioButtonHeight = 56
t3.SortAndFiltersRowHeight = 45
t3.SortAndFiltersSmallRowHeight = 32
t3.SortAndFiltersSectionPadding = 8
t3.FullViewPageDefaults = {
	[AvatarScreen.AccessoryAdjustment] = FullView.None,
	[AvatarScreen.LayeredClothingSort] = FullView.None,
	[AvatarScreen.LayeredMakeupSort] = if not FFlagAXCustomizeMakeupSupport then nil else FullView.None,
	[AvatarScreen.AvatarEditor] = FullView.None,
	[AvatarScreen.AvatarExperienceLandingPage] = FullView.None,
	[AvatarScreen.Catalog] = FullView.None,
	[AvatarScreen.CatalogSearch] = FullView.None,
	[AvatarScreen.ProfilePictureEditorEmotes] = FullView.None,
	[AvatarScreen.MySharedAvatars] = FullView.None,
	[AvatarScreen.FavoritesSaved] = FullView.None,
	[AvatarScreen.SearchLandingFocusedWidgetPage] = if not v17 then nil else FullView.None,
	[AvatarScreen.BodyShape] = if not GetFFlagAXEnableSlotBasedEditor() then nil else FullView.None,
	[AvatarScreen.AvatarSwitcher] = if not GetFFlagAXEnableSlotBasedEditor() then nil else FullView.None,
	[AvatarScreen.EditEmotes] = if not GetFFlagAXEnableSlotBasedEditor() then nil else FullView.None,
	[AvatarScreen.Photobooth] = if not AvatarExperienceFlags.FFlagAXPhotoboothFunctionality then nil else FullView.SceneFullView
}

local v43 = if not FFlagLuaAppForceVrAppPanelWidthRollout then nil else -1.2
local v44 = if not FFlagLuaAppForceVrAppPanelWidthRollout then -2 * v39 else -2 * v39 + v43
local v45 = if not FFlagLuaAppForceVrAppPanelWidthRollout then -4.4 * v39 else -4.4 * v39 + v43
local v46 = if not FFlagLuaAppForceVrAppPanelWidthRollout then 3.2 * v39 else 3.2 * v39 * if not FFlagLuaAppForceVrAppPanelWidthRollout then nil else 0.9
local v47 = (3.52 * v39 - 3.52) / 2

t3.VR = {
	SPACE_BETWEEN_STACKED_PANELS = 0.01,
	PANELS_HEIGHT_OFFSET = 4.6,
	PanelInfo = {
		Left = {
			PartSize = Vector2.new(2.2, 3.52) * v39,
			Offset = CFrame.lookAt(Vector3.new(-v46, 4.6, v44), (Vector3.new(0, 4.599999904632568, 0))),
			VirtualScreenSize = Vector2.new(360, 704)
		},
		Right = {
			PartSize = Vector2.new(2.2, 3.52) * v39,
			Offset = CFrame.lookAt(Vector3.new(v46, 4.6, v44), (Vector3.new(0, 4.599999904632568, 0))),
			VirtualScreenSize = Vector2.new(360, 704)
		},
		Center = {
			PartSize = Vector2.new(3, 3.52) * v39,
			Offset = CFrame.lookAt(Vector3.new(0, 4.6, v45), (Vector3.new(0, 4.599999904632568, 0))),
			VirtualScreenSize = Vector2.new(600, 704)
		}
	},
	AvatarEditorNavBarSize = Vector2.new(2.5, 0.3) * v39,
	AvatarEditorNavBarPosition = Vector3.new(0, 6.9 + v47, v45),
	AvatarEditorNavBarOrientation = Vector3.new(0, 7 + v47, 0),
	AvatarEditorNavBarResolution = Vector2.new(650, 75)
}
t3.Counter = {
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
	CatalogRefresh = {
		StaleResults = "CatalogRefreshStaleResults"
	},
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
		FetchFaeFeatureAccessError = "FetchFaeFeatureAccessError"
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
	Toasts = {
		NoFaceHead = "ToastsNoFaceHead"
	},
	Latency = {
		Organic = {
			Thumbnails = "OrganicThumbnailLatency",
			Tiles = "OrganicTilesLatency"
		},
		Widget = {
			Thumbnails = "WidgetThumbnailLatency",
			Tiles = "WidgetTilesLatency"
		},
		Network = {
			FetchWidgetInfo = "NetworkFetchWidgetInfoLatency",
			ApiFetchCatalogSearch = "NetworkApiFetchCatalogSearchLatency",
			FetchSponsoredItems = "NetworkFetchSponsoredItemsLatency"
		}
	},
	AvatarInventory = {
		ReceivedDuplicateItem = "AvatarInventoryReceivedDuplicateItem"
	},
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
	LayerExposure = {
		CatalogView = "CatalogViewLayerExposure"
	},
	NilGuard = {
		CharacterManager_initAvatarScalesChangedConnection_characterManagerEvents = "NilGuard_CharacterManager_initAvatarScalesChangedConnection_characterManagerEvents",
		CharacterManager_initBodyColorsChangedConnection_characterManagerEvents = "NilGuard_CharacterManager_initBodyColorsChangedConnection_characterManagerEvents",
		CharacterManager_initAdjustmentChangedConnection_characterManagerEvents = "NilGuard_CharacterManager_initAdjustmentChangedConnection_characterManagerEvents"
	},
	Catalog = if not FFlagAXCatalogCategoriesSDUI then nil else {
		Errors = {
			FetchCatalogCategoriesError = "FetchCatalogCategoriesError",
			FetchMarketplaceSduiError = "FetchMarketplaceSduiError"
		}
	}
}
t3.MemStorageKeys = {
	ColdStart = {
		CatalogAndCatalogSearch = "AXColdStartCatalogAndSearch"
	}
}
t3.ModerationStatus = {
	PendingModeration = "Pending",
	Moderated = "Moderated"
}
t3.HeadRefinementCameraCategory = {
	Name = "Head",
	Title = "Head",
	CameraFocus = t3.FocusType.Head,
	CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Special.HeadRefinement
}
t3.LayeredMakeupCameraCategory = {
	Name = "Makeup",
	Title = "Makeup",
	CameraZoomRadius = 4,
	CameraFocus = t3.FocusType.Makeup
}

if AXItemDetails3DPreviewIXP.isEnabled() then
	t3.ItemViewportAssetTypes = {
		[t3.AssetTypeIdStrings.Hat] = true,
		[t3.AssetTypeIdStrings.HairAccessory] = true,
		[t3.AssetTypeIdStrings.FaceAccessory] = true,
		[t3.AssetTypeIdStrings.NeckAccessory] = true,
		[t3.AssetTypeIdStrings.ShoulderAccessory] = true,
		[t3.AssetTypeIdStrings.FrontAccessory] = true,
		[t3.AssetTypeIdStrings.BackAccessory] = true,
		[t3.AssetTypeIdStrings.WaistAccessory] = true,
		[t3.AssetTypeIdStrings.TShirtAccessory] = true,
		[t3.AssetTypeIdStrings.ShirtAccessory] = true,
		[t3.AssetTypeIdStrings.PantsAccessory] = true,
		[t3.AssetTypeIdStrings.JacketAccessory] = true,
		[t3.AssetTypeIdStrings.SweaterAccessory] = true,
		[t3.AssetTypeIdStrings.ShortsAccessory] = true,
		[t3.AssetTypeIdStrings.LeftShoeAccessory] = true,
		[t3.AssetTypeIdStrings.RightShoeAccessory] = true,
		[t3.AssetTypeIdStrings.DressSkirtAccessory] = true,
		[t3.AssetTypeIdStrings.EyebrowAccessory] = not FFlagAXEyebrowEyelashToMakeupCategory or nil,
		[t3.AssetTypeIdStrings.EyelashAccessory] = not FFlagAXEyebrowEyelashToMakeupCategory or nil
	}
	t3.ItemViewportBundleTypes = {
		[t3.BundleTypeIdStrings.BodyParts] = true,
		[t3.BundleTypeIdStrings.DynamicHead] = true,
		[t3.BundleTypeIdStrings.Shoes] = not not GetFFlagAXSupportShoesInItemViewport() or nil
	}
end

t3.RobloxCreatorName = "Roblox"
t3.NavigationParams = {
	fromSurface = "fromSurface"
}

return t3
