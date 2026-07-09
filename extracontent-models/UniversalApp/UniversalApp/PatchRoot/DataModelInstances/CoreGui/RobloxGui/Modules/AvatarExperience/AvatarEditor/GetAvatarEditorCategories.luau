local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local Constants = AvatarExperienceCommon.Constants
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local Constants3 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local SearchUuid = require(Modules.LuaApp.SearchUuid)
local getClothingCategories = require(Modules.AvatarExperience.Common.getClothingCategories)
local getEmotesCategory = require(Modules.AvatarExperience.Common.getEmotesCategory)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local AvatarExperienceCommon2 = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local CatalogCategories = AvatarExperienceCommon2.Enums.CatalogCategories
local CatalogSubcategories = AvatarExperienceCommon2.Enums.CatalogSubcategories
local CatalogSDUICategoryIds = AvatarExperienceCommon2.Enums.CatalogSDUICategoryIds
local IsVRAppBuild = require(CorePackages.Workspace.Packages.AppCommonLib).IsVRAppBuild
local IconName = require(CorePackages.Packages.Foundation).Enums.IconName
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local AXCatalogHeadCategoryCombineIXP = require(Modules.AvatarExperience.Experiments.AXCatalogHeadCategoryCombineIXP)
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local AvatarEditorSubcategories = AvatarExperienceSlotBasedEditor.Enums.AvatarEditorSubcategories
local AvatarEditorCategories = AvatarExperienceSlotBasedEditor.Enums.AvatarEditorCategories
local FFlagAEGetEditableOutfitsType = require(Modules.AvatarExperience.Flags.FFlagAEGetEditableOutfitsType)
local GetFFlagAXAddNavigationKeyToEditorSubcategories = require(Modules.AvatarExperience.Flags.GetFFlagAXAddNavigationKeyToEditorSubcategories)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local GetFFlagAXExtractEmotesCategory = require(Modules.AvatarExperience.Flags.GetFFlagAXExtractEmotesCategory)
local GetFFlagAXEnableRecommendationTypeAllInCustomize = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableRecommendationTypeAllInCustomize)
local FFlagAXTweakSlotsCameraPositioning = require(Modules.AvatarExperience.Flags.FFlagAXTweakSlotsCameraPositioning)
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagRemoveClassicHeadsAndFaces = AvatarExperienceFlags.FFlagRemoveClassicHeadsAndFaces
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local FFlagAXCustomizeBackgrounds = AvatarExperienceFlags.FFlagAXCustomizeBackgrounds
local FFlagAXBackgroundsCustomizeHydration = AvatarExperienceFlags.FFlagAXBackgroundsCustomizeHydration
local FFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local FFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local v37 = game:DefineFastFlag("AXAvatarTabShopForMore", false)
local FFlagAXAvatarTabLooksYouMayAlsoLike = AvatarExperienceFlags.FFlagAXAvatarTabLooksYouMayAlsoLike
local FFlagAXDownrankMakeupCustomize = AvatarExperienceFlags.FFlagAXDownrankMakeupCustomize
local AXAvatarsTabIXP = AvatarExperienceCommon.Experiments.AXAvatarsTabIXP
local t22 = nil

local function v42() -- line: 65
	-- upvalues: AXAvatarsTabIXP (copy), IxpUtils (copy), Constants3 (copy), FFlagAXCatalogCategoriesSDUI (copy), CatalogCategories (copy), CatalogSubcategories (copy), CatalogSDUICategoryIds (copy), FFlagAEGetEditableOutfitsType (copy), Constants2 (copy), GetFFlagAXAddNavigationKeyToEditorSubcategories (copy), AvatarEditorSubcategories (copy), AvatarEditorCategories (copy)
	local v55 = if not AXAvatarsTabIXP.isEnabled() then nil else IxpUtils.readTestVariable(AXAvatarsTabIXP.EnabledForUser)

	return {
		Title = "Feature.Catalog.Label.Characters",
		IconOn = "icons/menu/clothing/characters_on",
		IconOff = "icons/menu/clothing/characters_off",
		RenderItemTiles = true,
		RenderOutfitItemTiles = true,
		CanAnimateCameraBasedMood = true,
		Name = Constants3.CharacterKey,
		RecommendationsType = Constants3.RecommendationsType.BodyParts,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			CategoryKey = if not v55 then CatalogCategories.Characters else CatalogCategories.Body,
			SubcategoryKey = if not v55 then nil else CatalogSubcategories.FullBodies
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			CategoryId = if not v55 then CatalogSDUICategoryIds.Characters:rawValue() else CatalogSDUICategoryIds.Body:rawValue(),
			SubcategoryId = if not v55 then nil else CatalogSDUICategoryIds.Body_FullBodies:rawValue()
		},
		SearchUuid = Constants3.CharacterKey,
		OutfitType = if not FFlagAEGetEditableOutfitsType then nil else Constants2.OutfitTypes.Avatar,
		Subcategories = {
			[1] = {
				Name = "Creations",
				Title = "Feature.Avatar.Label.Creations",
				IconOn = "icons/menu/clothing/creations_on",
				IconOff = "icons/menu/clothing/creations_off",
				RenderItemTiles = true,
				RenderOutfitItemTiles = true,
				ManageOutfitsEnabled = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.CreatedCharacters,
				RecommendationsType = Constants3.RecommendationsType.BodyParts,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
					CategoryKey = if not v55 then CatalogCategories.Characters else CatalogCategories.Avatars
				} else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryId = if not v55 then CatalogSDUICategoryIds.Characters:rawValue() else CatalogSDUICategoryIds.Avatars:rawValue()
				},
				SearchUuid = Constants3.EditableCharacterKey,
				OutfitType = if not FFlagAEGetEditableOutfitsType then nil else Constants2.OutfitTypes.Avatar,
				BundleTypes = {
					Constants2.BundleTypeIdStrings.BodyParts,
					Constants2.BundleTypeIdStrings.Animations
				},
				Id = AvatarEditorSubcategories.CreatedCharacters
			},
			[2] = {
				Name = "Purchased",
				Title = "Feature.Avatar.Label.Purchased",
				IconOn = "icons/menu/clothing/purchased_on",
				IconOff = "icons/menu/clothing/purchased_off",
				RenderItemTiles = true,
				RenderOutfitItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.PurchasedCharacters,
				RecommendationsType = Constants3.RecommendationsType.BodyParts,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
					CategoryKey = if not v55 then CatalogCategories.Characters else CatalogCategories.Body,
					SubcategoryKey = if not v55 then nil else CatalogSubcategories.FullBodies
				} else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryId = if not v55 then CatalogSDUICategoryIds.Characters:rawValue() else CatalogSDUICategoryIds.Body:rawValue(),
					SubcategoryId = if not v55 then nil else CatalogSDUICategoryIds.Body_FullBodies:rawValue()
				},
				SearchUuid = Constants3.PurchasedCharacterKey,
				OutfitType = Constants2.OutfitTypes.Avatar,
				Id = AvatarEditorSubcategories.PurchasedCharacters
			}
		} or nil,
		Id = AvatarEditorCategories.Characters
	}
end
local function v43() -- line: 174
	-- upvalues: AXAvatarsTabIXP (copy), IxpUtils (copy), GetFFlagAXEnableSlotBasedEditor (copy), AvatarEditorCategories (copy), SearchUuid (copy), GetFFlagAXAddNavigationKeyToEditorSubcategories (copy), AvatarEditorSubcategories (copy), Constants3 (copy), Constants2 (copy), Constants (copy), FFlagAXCatalogCategoriesSDUI (copy), CatalogCategories (copy), CatalogSubcategories (copy), CatalogSDUICategoryIds (copy), FFlagRemoveClassicHeadsAndFaces (copy), FFlagAXRootSlotBasedEditorFlag (copy)
	local v56 = if not AXAvatarsTabIXP.isEnabled() then nil else IxpUtils.readTestVariable(AXAvatarsTabIXP.EnabledForUser)
	local t1 = {
		Name = "Body",
		Title = "Feature.Catalog.Label.Body",
		IconOn = "icons/menu/clothing/body_on",
		IconOff = "icons/menu/clothing/body_off",
		CanAnimateCameraBasedMood = true,
		NavigationKey = if not GetFFlagAXEnableSlotBasedEditor() then nil else AvatarEditorCategories.Body,
		SearchUuid = SearchUuid(),
		Subcategories = {},
		Id = AvatarEditorCategories.Body
	}
	local t2 = {
		Name = "Skin",
		Title = "Feature.Avatar.Label.Skin",
		IconOn = "icons/menu/clothing/skin_on",
		IconOff = "icons/menu/clothing/skin_off",
		RenderItemTiles = false,
		hideFilter = true,
		NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Skin,
		RecommendationsType = Constants3.RecommendationsType.None,
		PageType = Constants2.PageType.BodyColors,
		SearchUuid = SearchUuid(),
		Id = AvatarEditorSubcategories.Skin
	}
	local t3 = {
		Name = "Build",
		Title = "Feature.Avatar.Label.Build",
		IconOn = "icons/menu/clothing/build_on",
		IconOff = "icons/menu/clothing/build_off",
		RenderItemTiles = false,
		hideFilter = true,
		NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Build,
		RecommendationsType = Constants3.RecommendationsType.None,
		PageType = Constants2.PageType.BodyStyle,
		SearchUuid = SearchUuid(),
		Id = AvatarEditorSubcategories.Build
	}
	local t4 = {
		Name = "Hair",
		Title = "Feature.Avatar.Label.Hair",
		IconOn = "icons/menu/clothing/hair_on",
		IconOff = "icons/menu/clothing/hair_off",
		RenderItemTiles = true,
		UseGetInventoryV2 = true,
		NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Hair,
		CameraFocus = Constants2.FocusType.Head,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.BodyCategories.Hair,
		RecommendationsType = Constants3.RecommendationsType.Asset,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			CategoryKey = if not v56 then CatalogCategories.Head else CatalogCategories.Body,
			SubcategoryKey = CatalogSubcategories.Hair
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			CategoryId = if not v56 then CatalogSDUICategoryIds.Head:rawValue() else CatalogSDUICategoryIds.Body:rawValue(),
			SubcategoryId = CatalogSDUICategoryIds.Body_Hair:rawValue()
		},
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.HairAccessory },
		SearchUuid = SearchUuid(),
		Id = AvatarEditorSubcategories.Hair
	}
	local t5 = {
		Name = "Heads",
		Title = "Feature.Avatar.Label.Head",
		IconOn = "icons/menu/clothing/type_on",
		IconOff = "icons/menu/clothing/type_off",
		RenderItemTiles = true,
		RenderOutfitItemTiles = true,
		UseGetInventoryV2 = true,
		NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Heads,
		CameraFocus = Constants2.FocusType.Face,
		CameraZoomRadius = if FFlagRemoveClassicHeadsAndFaces then Constants.CAMERA_ZOOM_RADIUS.BodyCategories.Heads else Constants.CAMERA_ZOOM_RADIUS.BodyCategories.ClassicHeads,
		RecommendationsType = Constants3.RecommendationsType.DynamicHeads,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			CategoryKey = if not v56 then CatalogCategories.Head else CatalogCategories.Body,
			SubcategoryKey = CatalogSubcategories.Heads
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			CategoryId = if not v56 then CatalogSDUICategoryIds.Head:rawValue() else CatalogSDUICategoryIds.Body:rawValue(),
			SubcategoryId = CatalogSDUICategoryIds.Body_Heads:rawValue()
		},
		AssetTypeIdStrings = if FFlagRemoveClassicHeadsAndFaces then nil else { Constants2.AssetTypeIdStrings.Head },
		BundleTypeIdStrings = { Constants2.BundleTypeIdStrings.DynamicHead },
		SubcategoryFiltersHeader = if FFlagRemoveClassicHeadsAndFaces then nil else "Feature.Catalog.Heading.ShowHeadType",
		SubcategoryFilters = if FFlagRemoveClassicHeadsAndFaces then nil else {
			{
				Name = "All Heads",
				Title = "Feature.Avatar.Label.AllHeads",
				RenderOutfitItemTiles = true,
				NavigationKey = AvatarEditorSubcategories.AllHeads,
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.Head },
				BundleTypeIdStrings = { Constants2.BundleTypeIdStrings.DynamicHead },
				SearchUuid = SearchUuid()
			},
			{
				Name = "Dynamic Heads",
				Title = "Feature.Avatar.Label.DynamicHeads",
				RenderOutfitItemTiles = true,
				NavigationKey = AvatarEditorSubcategories.DynamicHeads,
				BundleTypeIdStrings = { Constants2.BundleTypeIdStrings.DynamicHead },
				SearchUuid = SearchUuid()
			},
			{
				Name = "Classic Heads",
				Title = "Feature.Avatar.Label.ClassicHeads",
				NavigationKey = AvatarEditorSubcategories.ClassicHeads,
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.Head },
				SearchUuid = SearchUuid()
			}
		},
		SearchUuid = SearchUuid(),
		Id = AvatarEditorSubcategories.Heads
	}
	local v62 = if FFlagRemoveClassicHeadsAndFaces then nil else {
		Name = "Faces",
		Title = "Feature.Avatar.Label.Face",
		IconOn = "icons/menu/clothing/faces_on",
		IconOff = "icons/menu/clothing/faces_off",
		RenderItemTiles = true,
		UseGetInventoryV2 = true,
		NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.ClassicFaces,
		CameraFocus = Constants2.FocusType.Face,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.BodyCategories.ClassicFaces,
		RecommendationsType = Constants3.RecommendationsType.Asset,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			CategoryKey = if not v56 then CatalogCategories.Head else CatalogCategories.Body,
			SubcategoryKey = CatalogSubcategories.ClassicFaces
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			CategoryId = if not v56 then CatalogSDUICategoryIds.Head:rawValue() else CatalogSDUICategoryIds.Body:rawValue(),
			SubcategoryId = CatalogSDUICategoryIds.Body_ClassicFaces:rawValue()
		},
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.Face },
		SearchUuid = SearchUuid(),
		Id = AvatarEditorSubcategories.ClassicFaces
	}
	local t6 = {
		Name = "Full Body",
		Title = "Feature.Catalog.Label.FullBody",
		IconOn = "icons/menu/clothing/body_on",
		IconOff = "icons/menu/clothing/body_off",
		RenderItemTiles = true,
		RenderOutfitItemTiles = true,
		UseGetInventoryV2 = true,
		SubcategoryFiltersHeader = "Feature.Catalog.Heading.ShowBodyParts",
		NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.PurchasedCharacters,
		RecommendationsType = Constants3.RecommendationsType.BodyParts,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			CategoryKey = if not v56 then CatalogCategories.Characters else CatalogCategories.Body,
			SubcategoryKey = if not v56 then nil else CatalogSubcategories.FullBodies
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			CategoryId = if not v56 then CatalogSDUICategoryIds.Characters:rawValue() else CatalogSDUICategoryIds.Body:rawValue(),
			SubcategoryId = if not v56 then nil else CatalogSDUICategoryIds.Body_FullBodies:rawValue()
		},
		SearchUuid = Constants3.PurchasedCharacterKey,
		OutfitType = Constants2.OutfitTypes.Avatar,
		BundleTypeIdStrings = { Constants2.BundleTypeIdStrings.BodyParts },
		SubcategoryFilters = {
			{
				Name = "Full Body",
				Title = "Feature.Avatar.Label.FullBody",
				RenderOutfitItemTiles = true,
				NavigationKey = AvatarEditorSubcategories.FullBody,
				BundleTypeIdStrings = { Constants2.BundleTypeIdStrings.BodyParts },
				SearchUuid = SearchUuid()
			},
			{
				Name = "Torso",
				Title = "Feature.Avatar.Label.Torso",
				NavigationKey = AvatarEditorSubcategories.Torsos,
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.Torso },
				SearchUuid = SearchUuid()
			},
			{
				Name = "Right Arms",
				Title = "Feature.Avatar.Label.RightArm",
				NavigationKey = AvatarEditorSubcategories.RightArms,
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.RightArm },
				SearchUuid = SearchUuid()
			},
			{
				Name = "Left Arms",
				Title = "Feature.Avatar.Label.LeftArm",
				NavigationKey = AvatarEditorSubcategories.LeftArms,
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.LeftArm },
				SearchUuid = SearchUuid()
			},
			{
				Name = "Right Legs",
				Title = "Feature.Avatar.Label.RightLeg",
				NavigationKey = AvatarEditorSubcategories.RightLegs,
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.RightLeg },
				SearchUuid = SearchUuid()
			},
			{
				Name = "Left Legs",
				Title = "Feature.Avatar.Label.LeftLeg",
				NavigationKey = AvatarEditorSubcategories.LeftLegs,
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.LeftLeg },
				SearchUuid = SearchUuid()
			}
		},
		Id = AvatarEditorSubcategories.PurchasedCharacters
	}

	table.insert(t1.Subcategories, t6)
	table.insert(t1.Subcategories, t4)

	if not FFlagAXRootSlotBasedEditorFlag then
		table.insert(t1.Subcategories, t3)
	end

	table.insert(t1.Subcategories, t5)

	if not FFlagRemoveClassicHeadsAndFaces then
		table.insert(t1.Subcategories, v62)
	end

	if FFlagAXRootSlotBasedEditorFlag then
		table.insert(t1.Subcategories, t3)
	end

	table.insert(t1.Subcategories, t2)

	return t1
end

local v44 = FFlagAXCustomizeMakeupSupport and function() -- line: 473
	-- upvalues: GetFFlagAXEnableSlotBasedEditor (copy), AvatarEditorCategories (copy), IconName (copy), SearchUuid (copy), GetFFlagAXAddNavigationKeyToEditorSubcategories (copy), AvatarEditorSubcategories (copy), Constants2 (copy), Constants (copy), Constants3 (copy), FFlagAXCatalogMakeupSupport (copy), FFlagAXCatalogCategoriesSDUI (copy), CatalogCategories (copy), CatalogSubcategories (copy)
	return {
		Name = "Makeup",
		Title = "Feature.Avatar.Label.Makeup",
		CanAnimateCameraBasedMood = true,
		ShowSubcategoriesAsSubnavigation = true,
		NavigationKey = if not GetFFlagAXEnableSlotBasedEditor() then nil else AvatarEditorCategories.Makeup,
		IconOn = IconName.TwoMakeupBrushes,
		IconOff = IconName.TwoMakeupBrushes,
		SearchUuid = SearchUuid(),
		Subcategories = {
			{
				Name = "MakeupLooks",
				Title = "Feature.Avatar.Label.Looks",
				IconOn = "icons/menu/clothing/type_on",
				IconOff = "icons/menu/clothing/type_off",
				RenderItemTiles = true,
				RenderOutfitItemTiles = true,
				UseGetInventoryV2 = true,
				hideFilter = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.MakeupLooks,
				PageType = Constants2.PageType.MakeupLooks,
				CameraFocus = Constants2.FocusType.Face,
				CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Makeup.MakeupLooks,
				RecommendationsType = Constants3.RecommendationsType.None,
				MatchingCatalogPage = if not FFlagAXCatalogMakeupSupport or FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryKey = CatalogCategories.Makeup,
					SubcategoryKey = CatalogSubcategories.MakeupLooks
				},
				AssetTypeIdStrings = {},
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.MakeupLooks
			},
			{
				Name = "EyeMakeup",
				Title = "Feature.Avatar.Label.EyeMakeup",
				IconOn = "icons/menu/clothing/type_on",
				IconOff = "icons/menu/clothing/type_off",
				RenderItemTiles = true,
				RenderOutfitItemTiles = true,
				UseGetInventoryV2 = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.EyeMakeup,
				CameraFocus = Constants2.FocusType.Face,
				CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Makeup.EyeMakeup,
				RecommendationsType = Constants3.RecommendationsType.Asset,
				MatchingCatalogPage = if not FFlagAXCatalogMakeupSupport or FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryKey = CatalogCategories.Makeup,
					SubcategoryKey = CatalogSubcategories.EyeMakeup
				},
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.EyeMakeup },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.EyeMakeup
			},
			{
				Name = "LipMakeup",
				Title = "Feature.Avatar.Label.LipMakeup",
				IconOn = "icons/menu/clothing/type_on",
				IconOff = "icons/menu/clothing/type_off",
				RenderItemTiles = true,
				RenderOutfitItemTiles = true,
				UseGetInventoryV2 = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.LipMakeup,
				CameraFocus = Constants2.FocusType.Face,
				CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Makeup.LipMakeup,
				RecommendationsType = Constants3.RecommendationsType.Asset,
				MatchingCatalogPage = if not FFlagAXCatalogMakeupSupport or FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryKey = CatalogCategories.Makeup,
					SubcategoryKey = CatalogSubcategories.FaceMakeup
				},
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.LipMakeup },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.LipMakeup
			},
			{
				Name = "FaceMakeup",
				Title = "Feature.Avatar.Label.FaceMakeup",
				IconOn = "icons/menu/clothing/type_on",
				IconOff = "icons/menu/clothing/type_off",
				RenderItemTiles = true,
				RenderOutfitItemTiles = true,
				UseGetInventoryV2 = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.FaceMakeup,
				CameraFocus = Constants2.FocusType.Face,
				CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Makeup.FaceMakeup,
				RecommendationsType = Constants3.RecommendationsType.Asset,
				MatchingCatalogPage = if not FFlagAXCatalogMakeupSupport or FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryKey = CatalogCategories.Makeup,
					SubcategoryKey = CatalogSubcategories.LipMakeup
				},
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.FaceMakeup },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.FaceMakeup
			},
			{
				Name = "Eyelashes",
				Title = "Feature.Avatar.Label.Eyelashes",
				RenderItemTiles = true,
				UseGetInventoryV2 = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Eyelashes,
				IconOn = IconName.Eyelashes,
				IconOff = IconName.Eyelashes,
				CameraFocus = Constants2.FocusType.Face,
				CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Makeup.Eyelashes,
				RecommendationsType = Constants3.RecommendationsType.Asset,
				MatchingCatalogPage = if not FFlagAXCatalogMakeupSupport or FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryKey = CatalogCategories.Makeup,
					SubcategoryKey = CatalogSubcategories.Eyelashes
				},
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.EyelashAccessory },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.Eyelashes
			},
			{
				Name = "Eyebrows",
				Title = "Feature.Avatar.Label.Eyebrows",
				RenderItemTiles = true,
				UseGetInventoryV2 = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Eyebrows,
				IconOn = IconName.Eyebrows,
				IconOff = IconName.Eyebrows,
				CameraFocus = Constants2.FocusType.Face,
				CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Makeup.Eyebrows,
				RecommendationsType = Constants3.RecommendationsType.Asset,
				MatchingCatalogPage = if not FFlagAXCatalogMakeupSupport or FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryKey = CatalogCategories.Makeup,
					SubcategoryKey = CatalogSubcategories.Eyebrows
				},
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.EyebrowAccessory },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.Eyebrows
			}
		},
		Id = AvatarEditorCategories.Makeup
	}
end or nil
local v45 = FFlagAXCustomizeBackgrounds and function() -- line: 677
	-- upvalues: GetFFlagAXEnableSlotBasedEditor (copy), AvatarEditorCategories (copy), IconName (copy), SearchUuid (copy), FFlagAXBackgroundsCustomizeHydration (copy), Constants2 (copy)
	return {
		Name = "Backgrounds",
		Title = "Feature.Catalog.Label.Backgrounds",
		RenderItemTiles = true,
		UseGetInventoryV2 = true,
		NavigationKey = if not GetFFlagAXEnableSlotBasedEditor() then nil else AvatarEditorCategories.Backgrounds,
		IconOn = IconName.Image,
		IconOff = IconName.Image,
		SearchUuid = SearchUuid(),
		Id = AvatarEditorCategories.Backgrounds,
		AssetTypeIdStrings = if not FFlagAXBackgroundsCustomizeHydration then nil else { Constants2.AssetTypeIdStrings.AvatarBackground }
	}
end or nil

local function v46() -- line: 696
	-- upvalues: GetFFlagAXEnableSlotBasedEditor (copy), AvatarEditorCategories (copy), SearchUuid (copy), GetFFlagAXAddNavigationKeyToEditorSubcategories (copy), AvatarEditorSubcategories (copy), Constants2 (copy), Constants (copy), Constants3 (copy), FFlagAXCatalogCategoriesSDUI (copy), CatalogCategories (copy), CatalogSubcategories (copy), CatalogSDUICategoryIds (copy)
	return {
		Name = "Accessories",
		Title = "Feature.Catalog.LabelAccessories",
		IconOn = "icons/menu/clothing/accessories_on",
		IconOff = "icons/menu/clothing/accessories_off",
		HideTextUnderTile = true,
		CanAnimateCameraBasedMood = true,
		NavigationKey = if not GetFFlagAXEnableSlotBasedEditor() then nil else AvatarEditorCategories.Accessories,
		SearchUuid = SearchUuid(),
		Subcategories = if not GetFFlagAXEnableSlotBasedEditor() then {
			[1] = {
				Name = "Hats",
				Title = "Feature.Avatar.Label.Head",
				IconOn = "icons/menu/clothing/hats_on",
				IconOff = "icons/menu/clothing/hats_off",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Hats,
				CameraFocus = Constants2.FocusType.Head,
				CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.AvatarEditorAccessories.Hats,
				RecommendationsType = Constants3.RecommendationsType.Asset,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
					CategoryKey = CatalogCategories.Accessories,
					SubcategoryKey = CatalogSubcategories.Hats
				} else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryId = CatalogSDUICategoryIds.Accessories:rawValue(),
					SubcategoryId = CatalogSDUICategoryIds.Accessories_Heads:rawValue()
				},
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.Hat },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.Hats
			},
			[2] = {
				Name = "Face",
				Title = "Feature.Avatar.Label.Face",
				IconOn = "icons/menu/clothing/face_on",
				IconOff = "icons/menu/clothing/face_off",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Face,
				CameraFocus = Constants2.FocusType.Face,
				CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.AvatarEditorAccessories.Face,
				RecommendationsType = Constants3.RecommendationsType.Asset,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
					CategoryKey = CatalogCategories.Accessories,
					SubcategoryKey = CatalogSubcategories.Face
				} else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryId = CatalogSDUICategoryIds.Accessories:rawValue(),
					SubcategoryId = CatalogSDUICategoryIds.Accessories_Face:rawValue()
				},
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.FaceAccessory },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.Face
			},
			[3] = {
				Name = "Neck",
				Title = "Feature.Avatar.Label.Neck",
				IconOn = "icons/menu/clothing/neck_on",
				IconOff = "icons/menu/clothing/neck_off",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Neck,
				CameraFocus = Constants2.FocusType.Neck,
				CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.AvatarEditorAccessories.Neck,
				RecommendationsType = Constants3.RecommendationsType.Asset,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
					CategoryKey = CatalogCategories.Accessories,
					SubcategoryKey = CatalogSubcategories.Neck
				} else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryId = CatalogSDUICategoryIds.Accessories:rawValue(),
					SubcategoryId = CatalogSDUICategoryIds.Accessories_Neck:rawValue()
				},
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.NeckAccessory },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.Neck
			},
			[4] = {
				Name = "Shoulder",
				Title = "Feature.Avatar.Label.Shoulder",
				IconOn = "icons/menu/clothing/shoulder_on",
				IconOff = "icons/menu/clothing/shoulder_off",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Shoulder,
				CameraFocus = Constants2.FocusType.Shoulders,
				CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.AvatarEditorAccessories.Shoulder,
				RecommendationsType = Constants3.RecommendationsType.Asset,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
					CategoryKey = CatalogCategories.Accessories,
					SubcategoryKey = CatalogSubcategories.Shoulder
				} else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryId = CatalogSDUICategoryIds.Accessories:rawValue(),
					SubcategoryId = CatalogSDUICategoryIds.Accessories_Shoulder:rawValue()
				},
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.ShoulderAccessory },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.Shoulder
			},
			[5] = {
				Name = "Front",
				Title = "Feature.Avatar.Label.Front",
				IconOn = "icons/menu/clothing/front_on",
				IconOff = "icons/menu/clothing/front_off",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Front,
				CameraFocus = Constants2.FocusType.Arms,
				CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.AvatarEditorAccessories.Front,
				RecommendationsType = Constants3.RecommendationsType.Asset,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
					CategoryKey = CatalogCategories.Accessories,
					SubcategoryKey = CatalogSubcategories.Front
				} else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryId = CatalogSDUICategoryIds.Accessories:rawValue(),
					SubcategoryId = CatalogSDUICategoryIds.Accessories_Front:rawValue()
				},
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.FrontAccessory },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.Front
			},
			[6] = {
				Name = "Back",
				Title = "Feature.Avatar.Label.Back",
				IconOn = "icons/menu/clothing/back_on",
				IconOff = "icons/menu/clothing/back_off",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Back,
				CameraFocus = Constants2.FocusType.Arms,
				CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.AvatarEditorAccessories.Back,
				RecommendationsType = Constants3.RecommendationsType.Asset,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
					CategoryKey = CatalogCategories.Accessories,
					SubcategoryKey = CatalogSubcategories.Back
				} else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryId = CatalogSDUICategoryIds.Accessories:rawValue(),
					SubcategoryId = CatalogSDUICategoryIds.Accessories_Back:rawValue()
				},
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.BackAccessory },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.Back
			},
			[7] = {
				Name = "Waist",
				Title = "Feature.Avatar.Label.Waist",
				IconOn = "icons/menu/clothing/waist_on",
				IconOff = "icons/menu/clothing/waist_off",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Waist,
				CameraFocus = Constants2.FocusType.Waist,
				CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.AvatarEditorAccessories.Waist,
				RecommendationsType = Constants3.RecommendationsType.Asset,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
					CategoryKey = CatalogCategories.Accessories,
					SubcategoryKey = CatalogSubcategories.Waist
				} else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryId = CatalogSDUICategoryIds.Accessories:rawValue(),
					SubcategoryId = CatalogSDUICategoryIds.Accessories_Waist:rawValue()
				},
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.WaistAccessory },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.Waist
			},
			[8] = {
				Name = "Gear",
				Title = "Feature.Avatar.Label.Gear",
				IconOn = "icons/menu/clothing/gear_on",
				IconOff = "icons/menu/clothing/gear_off",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Gear,
				RecommendationsType = Constants3.RecommendationsType.Asset,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
					CategoryKey = CatalogCategories.Accessories,
					SubcategoryKey = CatalogSubcategories.Gear
				} else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryId = CatalogSDUICategoryIds.Accessories:rawValue(),
					SubcategoryId = CatalogSDUICategoryIds.Accessories_Gear:rawValue()
				},
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.Gear },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.Gear
			}
		} else {
			[1] = {
				Name = "Hats",
				Title = "Feature.Avatar.Label.Head",
				IconOn = "icons/menu/clothing/hats_on",
				IconOff = "icons/menu/clothing/hats_off",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Hats,
				CameraFocus = Constants2.FocusType.Head,
				CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.AvatarEditorAccessories.Hats,
				RecommendationsType = Constants3.RecommendationsType.Asset,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
					CategoryKey = CatalogCategories.Accessories,
					SubcategoryKey = CatalogSubcategories.Hats
				} else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryId = CatalogSDUICategoryIds.Accessories:rawValue(),
					SubcategoryId = CatalogSDUICategoryIds.Accessories_Heads:rawValue()
				},
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.Hat },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.Hats
			},
			[2] = {
				Name = "Face",
				Title = "Feature.Avatar.Label.Face",
				IconOn = "icons/menu/clothing/face_on",
				IconOff = "icons/menu/clothing/face_off",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Face,
				CameraFocus = Constants2.FocusType.Face,
				CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.AvatarEditorAccessories.Face,
				RecommendationsType = Constants3.RecommendationsType.Asset,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
					CategoryKey = CatalogCategories.Accessories,
					SubcategoryKey = CatalogSubcategories.Face
				} else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryId = CatalogSDUICategoryIds.Accessories:rawValue(),
					SubcategoryId = CatalogSDUICategoryIds.Accessories_Face:rawValue()
				},
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.FaceAccessory },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.Face
			},
			[3] = {
				Name = "Neck",
				Title = "Feature.Avatar.Label.Neck",
				IconOn = "icons/menu/clothing/neck_on",
				IconOff = "icons/menu/clothing/neck_off",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Neck,
				CameraFocus = Constants2.FocusType.Neck,
				CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.AvatarEditorAccessories.Neck,
				RecommendationsType = Constants3.RecommendationsType.Asset,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
					CategoryKey = CatalogCategories.Accessories,
					SubcategoryKey = CatalogSubcategories.Neck
				} else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryId = CatalogSDUICategoryIds.Accessories:rawValue(),
					SubcategoryId = CatalogSDUICategoryIds.Accessories_Neck:rawValue()
				},
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.NeckAccessory },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.Neck
			},
			[4] = {
				Name = "Back",
				Title = "Feature.Avatar.Label.Back",
				IconOn = "icons/menu/clothing/back_on",
				IconOff = "icons/menu/clothing/back_off",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Back,
				CameraFocus = Constants2.FocusType.Arms,
				CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.AvatarEditorAccessories.Back,
				RecommendationsType = Constants3.RecommendationsType.Asset,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
					CategoryKey = CatalogCategories.Accessories,
					SubcategoryKey = CatalogSubcategories.Back
				} else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryId = CatalogSDUICategoryIds.Accessories:rawValue(),
					SubcategoryId = CatalogSDUICategoryIds.Accessories_Back:rawValue()
				},
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.BackAccessory },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.Back
			},
			[5] = {
				Name = "Waist",
				Title = "Feature.Avatar.Label.Waist",
				IconOn = "icons/menu/clothing/waist_on",
				IconOff = "icons/menu/clothing/waist_off",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Waist,
				CameraFocus = Constants2.FocusType.Waist,
				CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.AvatarEditorAccessories.Waist,
				RecommendationsType = Constants3.RecommendationsType.Asset,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
					CategoryKey = CatalogCategories.Accessories,
					SubcategoryKey = CatalogSubcategories.Waist
				} else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryId = CatalogSDUICategoryIds.Accessories:rawValue(),
					SubcategoryId = CatalogSDUICategoryIds.Accessories_Waist:rawValue()
				},
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.WaistAccessory },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.Waist
			},
			[6] = {
				Name = "Shoulder",
				Title = "Feature.Avatar.Label.Shoulder",
				IconOn = "icons/menu/clothing/shoulder_on",
				IconOff = "icons/menu/clothing/shoulder_off",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Shoulder,
				CameraFocus = Constants2.FocusType.Shoulders,
				CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.AvatarEditorAccessories.Shoulder,
				RecommendationsType = Constants3.RecommendationsType.Asset,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
					CategoryKey = CatalogCategories.Accessories,
					SubcategoryKey = CatalogSubcategories.Shoulder
				} else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryId = CatalogSDUICategoryIds.Accessories:rawValue(),
					SubcategoryId = CatalogSDUICategoryIds.Accessories_Shoulder:rawValue()
				},
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.ShoulderAccessory },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.Shoulder
			},
			[7] = {
				Name = "Front",
				Title = "Feature.Avatar.Label.Front",
				IconOn = "icons/menu/clothing/front_on",
				IconOff = "icons/menu/clothing/front_off",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Front,
				CameraFocus = Constants2.FocusType.Arms,
				CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.AvatarEditorAccessories.Front,
				RecommendationsType = Constants3.RecommendationsType.Asset,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
					CategoryKey = CatalogCategories.Accessories,
					SubcategoryKey = CatalogSubcategories.Front
				} else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryId = CatalogSDUICategoryIds.Accessories:rawValue(),
					SubcategoryId = CatalogSDUICategoryIds.Accessories_Front:rawValue()
				},
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.FrontAccessory },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.Front
			},
			[8] = {
				Name = "Gear",
				Title = "Feature.Avatar.Label.Gear",
				IconOn = "icons/menu/clothing/gear_on",
				IconOff = "icons/menu/clothing/gear_off",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Gear,
				RecommendationsType = Constants3.RecommendationsType.Asset,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
					CategoryKey = CatalogCategories.Accessories,
					SubcategoryKey = CatalogSubcategories.Gear
				} else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
					CategoryId = CatalogSDUICategoryIds.Accessories:rawValue(),
					SubcategoryId = CatalogSDUICategoryIds.Accessories_Gear:rawValue()
				},
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.Gear },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.Gear
			}
		},
		Id = AvatarEditorCategories.Accessories
	}
end
local function v47() -- line: 1206
	-- upvalues: AXAvatarsTabIXP (copy), IxpUtils (copy), Constants3 (copy), GetFFlagAXEnableSlotBasedEditor (copy), AvatarEditorCategories (copy), SearchUuid (copy), Constants2 (copy), FFlagAXAvatarTabLooksYouMayAlsoLike (copy), FFlagAXInventoryDurablesSupport (copy), FFlagAXCatalogCategoriesSDUI (copy), v37 (copy), CatalogCategories (copy), CatalogSubcategories (copy), CatalogSDUICategoryIds (copy)
	local v64 = if not AXAvatarsTabIXP.isEnabled() then nil else IxpUtils.readTestVariable(AXAvatarsTabIXP.EnabledForUser)

	return {
		Title = "Feature.Catalog.Label.Avatars",
		IconOn = "icons/menu/clothing/avatars_on",
		IconOff = "icons/menu/clothing/avatars_off",
		hideFilter = true,
		Name = Constants3.CharacterKey,
		NavigationKey = if not GetFFlagAXEnableSlotBasedEditor() then nil else AvatarEditorCategories.Avatars,
		SearchUuid = SearchUuid(),
		PageType = Constants2.PageType.Avatars,
		Id = AvatarEditorCategories.Avatars,
		RecommendationsType = if not GetFFlagAXEnableSlotBasedEditor() then Constants3.RecommendationsType.All else if not FFlagAXAvatarTabLooksYouMayAlsoLike then Constants3.RecommendationsType.BodyParts else Constants3.RecommendationsType.AvatarLooks,
		ShowName = not not GetFFlagAXEnableSlotBasedEditor() or nil,
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.AvatarOutfit },
		BundleTypeIdStrings = if not FFlagAXInventoryDurablesSupport then nil else { Constants2.BundleTypeIdStrings.Avatars },
		MatchingCatalogPage = if FFlagAXCatalogCategoriesSDUI or not GetFFlagAXEnableSlotBasedEditor() then nil else if not v37 then {
			CategoryKey = CatalogCategories.Body,
			SubcategoryKey = CatalogSubcategories.FullBodies
		} else {
			CategoryKey = if not v64 then CatalogCategories.Characters else CatalogCategories.Avatars
		},
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI or not GetFFlagAXEnableSlotBasedEditor() then nil else if not v37 then {
			CategoryId = CatalogSDUICategoryIds.Body:rawValue(),
			SubcategoryId = CatalogSDUICategoryIds.Body_FullBodies:rawValue()
		} else {
			CategoryId = if not v64 then CatalogSDUICategoryIds.Characters:rawValue() else CatalogSDUICategoryIds.Avatars:rawValue()
		}
	}
end
local function v48() -- line: 1262
	-- upvalues: CatalogCategories (copy), CatalogSubcategories (copy), FFlagAXCatalogCategoriesSDUI (copy), CatalogSDUICategoryIds (copy), GetFFlagAXEnableSlotBasedEditor (copy), FFlagAXCustomizeMakeupSupport (copy), AvatarEditorCategories (copy), SearchUuid (copy), Constants2 (copy), GetFFlagAXAddNavigationKeyToEditorSubcategories (copy), AvatarEditorSubcategories (copy), Constants3 (copy)
	local t7 = {
		CategoryKey = CatalogCategories.AllAnimations,
		SubcategoryKey = CatalogSubcategories.AnimationBundles
	}
	local t8 = nil

	if FFlagAXCatalogCategoriesSDUI then
		t8 = {
			CategoryId = CatalogSDUICategoryIds.AllAnimations:rawValue(),
			SubcategoryId = CatalogSDUICategoryIds.AnimationBundles:rawValue()
		}
	end

	if GetFFlagAXEnableSlotBasedEditor() then
		return {
			Name = "Animation",
			Title = "Feature.Avatar.Heading.Animations",
			IconOn = "icons/menu/clothing/animation_on",
			IconOff = "icons/menu/clothing/animation_off",
			CanAnimateCameraBasedMood = true,
			Id = if not FFlagAXCustomizeMakeupSupport then AvatarEditorCategories.Animation else AvatarEditorCategories.Animations,
			NavigationKey = if not GetFFlagAXEnableSlotBasedEditor() then nil else if not FFlagAXCustomizeMakeupSupport then AvatarEditorCategories.Animation else AvatarEditorCategories.Animations,
			SearchUuid = SearchUuid(),
			CameraZoomRadius = Constants2.AnimationCategoryCameraZoomRadius,
			PageType = Constants2.PageType.Animation,
			ShowName = not not GetFFlagAXEnableSlotBasedEditor() or nil,
			Subcategories = {
				{
					Name = "Animation Full Sets",
					Title = "Feature.Avatar.Label.AnimationFullSet",
					IconOn = "icons/menu/clothing/animation_on",
					IconOff = "icons/menu/clothing/animation_off",
					EmptyString = "Feature.Avatar.Heading.Animations",
					RenderItemTiles = true,
					RenderOutfitItemTiles = true,
					NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.AnimationFullSets,
					RecommendationsType = Constants3.RecommendationsType.AvatarAnimations,
					MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then t7 else nil,
					MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else t8,
					BundleTypeIdStrings = { Constants2.BundleTypeIdStrings.Animations },
					SearchUuid = SearchUuid(),
					Id = AvatarEditorSubcategories.AnimationFullSets
				},
				{
					Name = "Idle Animations",
					Title = "Feature.Avatar.Label.Idle",
					IconOn = "icons/menu/clothing/idle_on",
					IconOff = "icons/menu/clothing/idle_off",
					EmptyString = "Feature.Avatar.Label.IdleAnimations",
					RenderItemTiles = true,
					NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.IdleAnimations,
					RecommendationsType = Constants3.RecommendationsType.AvatarAnimations,
					MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then t7 else nil,
					MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else t8,
					AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.IdleAnimation },
					SearchUuid = SearchUuid(),
					Id = AvatarEditorSubcategories.IdleAnimations
				},
				{
					Name = "Walk Animations",
					Title = "Feature.Avatar.Label.Walk",
					IconOn = "icons/menu/clothing/walk_on",
					IconOff = "icons/menu/clothing/walk_off",
					EmptyString = "Feature.Avatar.Label.WalkAnimations",
					RenderItemTiles = true,
					NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.WalkAnimations,
					RecommendationsType = Constants3.RecommendationsType.AvatarAnimations,
					MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then t7 else nil,
					MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else t8,
					AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.WalkAnimation },
					SearchUuid = SearchUuid(),
					Id = AvatarEditorSubcategories.WalkAnimations
				},
				{
					Name = "Run Animations",
					Title = "Feature.Avatar.Label.Run",
					IconOn = "icons/menu/clothing/animation_on",
					IconOff = "icons/menu/clothing/animation_off",
					EmptyString = "Feature.Avatar.Label.RunAnimations",
					RenderItemTiles = true,
					NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.RunAnimations,
					RecommendationsType = Constants3.RecommendationsType.AvatarAnimations,
					MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then t7 else nil,
					MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else t8,
					AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.RunAnimation },
					SearchUuid = SearchUuid(),
					Id = AvatarEditorSubcategories.RunAnimations
				},
				{
					Name = "Jump Animations",
					Title = "Feature.Avatar.Label.Jump",
					IconOn = "icons/menu/clothing/jump_on",
					IconOff = "icons/menu/clothing/jump_off",
					EmptyString = "Feature.Avatar.Label.JumpAnimations",
					RenderItemTiles = true,
					NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.JumpAnimations,
					RecommendationsType = Constants3.RecommendationsType.AvatarAnimations,
					MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then t7 else nil,
					MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else t8,
					AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.JumpAnimation },
					SearchUuid = SearchUuid(),
					Id = AvatarEditorSubcategories.JumpAnimations
				},
				{
					Name = "Fall Animations",
					Title = "Feature.Avatar.Label.Fall",
					IconOn = "icons/menu/clothing/fall_on",
					IconOff = "icons/menu/clothing/fall_off",
					EmptyString = "Feature.Avatar.Label.FallAnimations",
					RenderItemTiles = true,
					NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.FallAnimations,
					RecommendationsType = Constants3.RecommendationsType.AvatarAnimations,
					MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then t7 else nil,
					MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else t8,
					AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.FallAnimation },
					SearchUuid = SearchUuid(),
					Id = AvatarEditorSubcategories.FallAnimations
				},
				{
					Name = "Climb Animations",
					Title = "Feature.Avatar.Label.Climb",
					IconOn = "icons/menu/clothing/climb_on",
					IconOff = "icons/menu/clothing/climb_off",
					EmptyString = "Feature.Avatar.Label.ClimbAnimations",
					RenderItemTiles = true,
					NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.ClimbAnimations,
					RecommendationsType = Constants3.RecommendationsType.AvatarAnimations,
					MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then t7 else nil,
					MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else t8,
					AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.ClimbAnimation },
					SearchUuid = SearchUuid(),
					Id = AvatarEditorSubcategories.ClimbAnimations
				},
				{
					Name = "Swim Animations",
					Title = "Feature.Avatar.Label.Swim",
					IconOn = "icons/menu/clothing/swim_on",
					IconOff = "icons/menu/clothing/swim_off",
					EmptyString = "Feature.Avatar.Label.SwimAnimations",
					RenderItemTiles = true,
					NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.SwimAnimations,
					RecommendationsType = Constants3.RecommendationsType.AvatarAnimations,
					MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then t7 else nil,
					MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else t8,
					AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.SwimAnimation },
					SearchUuid = SearchUuid(),
					Id = AvatarEditorSubcategories.SwimAnimations
				}
			}
		}
	end

	return {
		Name = "Animation",
		Title = "Feature.Catalog.Label.Animation",
		IconOn = "icons/menu/clothing/animation_on",
		IconOff = "icons/menu/clothing/animation_off",
		CanAnimateCameraBasedMood = true,
		Id = AvatarEditorCategories.Animation,
		NavigationKey = if not GetFFlagAXEnableSlotBasedEditor() then nil else AvatarEditorCategories.Animation,
		SearchUuid = SearchUuid(),
		CameraZoomRadius = Constants2.AnimationCategoryCameraZoomRadius,
		PageType = Constants2.PageType.Animation,
		Subcategories = {
			[1] = {
				Name = "Idle Animations",
				Title = "Feature.Avatar.Label.Idle",
				IconOn = "icons/menu/clothing/idle_on",
				IconOff = "icons/menu/clothing/idle_off",
				EmptyString = "Feature.Avatar.Label.IdleAnimations",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.IdleAnimations,
				RecommendationsType = Constants3.RecommendationsType.AvatarAnimations,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then t7 else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else t8,
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.IdleAnimation },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.IdleAnimations
			},
			[2] = {
				Name = "Walk Animations",
				Title = "Feature.Avatar.Label.Walk",
				IconOn = "icons/menu/clothing/walk_on",
				IconOff = "icons/menu/clothing/walk_off",
				EmptyString = "Feature.Avatar.Label.WalkAnimations",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.WalkAnimations,
				RecommendationsType = Constants3.RecommendationsType.AvatarAnimations,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then t7 else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else t8,
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.WalkAnimation },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.WalkAnimations
			},
			[3] = {
				Name = "Run Animations",
				Title = "Feature.Avatar.Label.Run",
				IconOn = "icons/menu/clothing/animation_on",
				IconOff = "icons/menu/clothing/animation_off",
				EmptyString = "Feature.Avatar.Label.RunAnimations",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.RunAnimations,
				RecommendationsType = Constants3.RecommendationsType.AvatarAnimations,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then t7 else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else t8,
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.RunAnimation },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.RunAnimations
			},
			[4] = {
				Name = "Jump Animations",
				Title = "Feature.Avatar.Label.Jump",
				IconOn = "icons/menu/clothing/jump_on",
				IconOff = "icons/menu/clothing/jump_off",
				EmptyString = "Feature.Avatar.Label.JumpAnimations",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.JumpAnimations,
				RecommendationsType = Constants3.RecommendationsType.AvatarAnimations,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then t7 else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else t8,
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.JumpAnimation },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.JumpAnimations
			},
			[5] = {
				Name = "Fall Animations",
				Title = "Feature.Avatar.Label.Fall",
				IconOn = "icons/menu/clothing/fall_on",
				IconOff = "icons/menu/clothing/fall_off",
				EmptyString = "Feature.Avatar.Label.FallAnimations",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.FallAnimations,
				RecommendationsType = Constants3.RecommendationsType.AvatarAnimations,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then t7 else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else t8,
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.FallAnimation },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.FallAnimations
			},
			[6] = {
				Name = "Climb Animations",
				Title = "Feature.Avatar.Label.Climb",
				IconOn = "icons/menu/clothing/climb_on",
				IconOff = "icons/menu/clothing/climb_off",
				EmptyString = "Feature.Avatar.Label.ClimbAnimations",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.ClimbAnimations,
				RecommendationsType = Constants3.RecommendationsType.AvatarAnimations,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then t7 else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else t8,
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.ClimbAnimation },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.ClimbAnimations
			},
			[7] = {
				Name = "Swim Animations",
				Title = "Feature.Avatar.Label.Swim",
				IconOn = "icons/menu/clothing/swim_on",
				IconOff = "icons/menu/clothing/swim_off",
				EmptyString = "Feature.Avatar.Label.SwimAnimations",
				RenderItemTiles = true,
				NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.SwimAnimations,
				RecommendationsType = Constants3.RecommendationsType.AvatarAnimations,
				MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then t7 else nil,
				MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else t8,
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.SwimAnimation },
				SearchUuid = SearchUuid(),
				Id = AvatarEditorSubcategories.SwimAnimations
			}
		}
	}
end
local function v49() -- line: 1603
	-- upvalues: AXCatalogHeadCategoryCombineIXP (copy), IxpUtils (copy), AXAvatarsTabIXP (copy), v42 (copy), SearchUuid (copy), AvatarEditorCategories (copy), GetFFlagAXAddNavigationKeyToEditorSubcategories (copy), AvatarEditorSubcategories (copy), Constants2 (copy), Constants (copy), Constants3 (copy), FFlagAXCatalogCategoriesSDUI (copy), CatalogCategories (copy), CatalogSubcategories (copy), CatalogSDUICategoryIds (copy), FFlagRemoveClassicHeadsAndFaces (copy), IsVRAppBuild (copy), v46 (copy), v48 (copy), GetFFlagAXExtractEmotesCategory (copy), getEmotesCategory (copy), GetFFlagAXEnableSlotBasedEditor (copy), t22 (ref), getClothingCategories (copy)
	local v67 = if not AXCatalogHeadCategoryCombineIXP.isEnabled() then nil else IxpUtils.readTestVariable(AXCatalogHeadCategoryCombineIXP.EnableHeadCategoryCombination)
	local v68 = if not AXAvatarsTabIXP.isEnabled() then nil else IxpUtils.readTestVariable(AXAvatarsTabIXP.EnabledForUser)
	local v69 = v42()
	local t9 = {
		Name = "HeadAndBody",
		Title = "Feature.Avatar.Label.HeadBody",
		IconOn = "icons/menu/clothing/body_on",
		IconOff = "icons/menu/clothing/body_off",
		CanAnimateCameraBasedMood = true,
		SearchUuid = SearchUuid(),
		Id = AvatarEditorCategories.Body
	}
	local t10 = {
		Name = "Style",
		Title = "Feature.Avatar.Label.Heads",
		IconOn = "icons/menu/clothing/type_on",
		IconOff = "icons/menu/clothing/type_off",
		RenderItemTiles = true,
		RenderOutfitItemTiles = true,
		NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Heads,
		UseGetInventoryV2 = AXCatalogHeadCategoryCombineIXP.isEnabled() and not not v67 or nil,
		CameraFocus = Constants2.FocusType.Face,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.DynamicBodyCategories.Style,
		RecommendationsType = Constants3.RecommendationsType.DynamicHeads,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			CategoryKey = if not v68 then CatalogCategories.Head else CatalogCategories.Body,
			SubcategoryKey = CatalogSubcategories.Heads
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			CategoryId = if not v68 then CatalogSDUICategoryIds.Head:rawValue() else CatalogSDUICategoryIds.Body:rawValue(),
			SubcategoryId = CatalogSDUICategoryIds.Body_Heads:rawValue()
		},
		OutfitType = Constants2.OutfitTypes.DynamicHead,
		OutfitFilter = Enum.OutfitSource.Purchased,
		AssetTypeIdStrings = if not AXCatalogHeadCategoryCombineIXP.isEnabled() or not v67 then nil else {
			Constants2.AssetTypeIdStrings.Head,
			Constants2.AssetTypeIdStrings.Face
		},
		OutfitTypeIdStrings = if not AXCatalogHeadCategoryCombineIXP.isEnabled() or not v67 then nil else { Constants2.BundleTypeIdStrings.DynamicHead },
		SearchUuid = SearchUuid(),
		Id = AvatarEditorSubcategories.Heads
	}
	local t11 = {
		Name = "Hair",
		Title = "Feature.Avatar.Label.Hair",
		IconOn = "icons/menu/clothing/hair_on",
		IconOff = "icons/menu/clothing/hair_off",
		RenderItemTiles = true,
		NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Hair,
		CameraFocus = Constants2.FocusType.Head,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.DynamicBodyCategories.Hair,
		RecommendationsType = Constants3.RecommendationsType.Asset,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			CategoryKey = if not v68 then CatalogCategories.Head else CatalogCategories.Body,
			SubcategoryKey = CatalogSubcategories.Hair
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			CategoryId = if not v68 then CatalogSDUICategoryIds.Head:rawValue() else CatalogSDUICategoryIds.Body:rawValue(),
			SubcategoryId = CatalogSDUICategoryIds.Body_Hair:rawValue()
		},
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.HairAccessory },
		SearchUuid = SearchUuid(),
		Id = AvatarEditorSubcategories.Hair
	}
	local t12 = {
		Name = "Skin",
		Title = "Feature.Avatar.Label.Skin",
		IconOn = "icons/menu/clothing/skin_on",
		IconOff = "icons/menu/clothing/skin_off",
		RenderItemTiles = false,
		hideFilter = true,
		NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Skin,
		RecommendationsType = Constants3.RecommendationsType.None,
		PageType = Constants2.PageType.BodyColors,
		SearchUuid = SearchUuid(),
		Id = AvatarEditorSubcategories.Skin
	}
	local t13 = {
		Name = "Classic Heads",
		Title = "Feature.Avatar.Label.ClassicHeads",
		IconOn = "icons/menu/clothing/classicHead_on",
		IconOff = "icons/menu/clothing/classicHead_off",
		RenderItemTiles = true,
		NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.ClassicHeads,
		CameraFocus = Constants2.FocusType.Face,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.DynamicBodyCategories.ClassicHeads,
		RecommendationsType = Constants3.RecommendationsType.Asset,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			CategoryKey = if not v68 then CatalogCategories.Head else CatalogCategories.Body,
			SubcategoryKey = if not AXCatalogHeadCategoryCombineIXP.isEnabled() or not v67 then if not FFlagRemoveClassicHeadsAndFaces then CatalogSubcategories.ClassicHeads else CatalogSubcategories.Heads else CatalogSubcategories.Heads
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			CategoryId = if not v68 then CatalogSDUICategoryIds.Head:rawValue() else CatalogSDUICategoryIds.Body:rawValue(),
			SubcategoryId = if not AXCatalogHeadCategoryCombineIXP.isEnabled() or not v67 then if not FFlagRemoveClassicHeadsAndFaces then CatalogSDUICategoryIds.Body_ClassicHeads:rawValue() else CatalogSDUICategoryIds.Body_Heads:rawValue() else CatalogSDUICategoryIds.Body_Heads:rawValue()
		},
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.Head },
		SearchUuid = SearchUuid(),
		Id = AvatarEditorSubcategories.ClassicHeads
	}
	local t14 = {
		Name = "Classic Faces",
		Title = "Feature.Avatar.Label.ClassicFaces",
		IconOn = "icons/menu/clothing/faces_on",
		IconOff = "icons/menu/clothing/faces_off",
		RenderItemTiles = true,
		NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.ClassicFaces,
		CameraFocus = Constants2.FocusType.Face,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.DynamicBodyCategories.ClassicFaces,
		RecommendationsType = Constants3.RecommendationsType.Asset,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			CategoryKey = if not v68 then CatalogCategories.Head else CatalogCategories.Body,
			SubcategoryKey = if not AXCatalogHeadCategoryCombineIXP.isEnabled() or not v67 then if not FFlagRemoveClassicHeadsAndFaces then CatalogSubcategories.ClassicFaces else CatalogSubcategories.Face else CatalogSubcategories.Heads
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			CategoryId = if not v68 then CatalogSDUICategoryIds.Characters:rawValue() else CatalogSDUICategoryIds.Body:rawValue(),
			SubcategoryId = if not AXCatalogHeadCategoryCombineIXP.isEnabled() or not v67 then if not FFlagRemoveClassicHeadsAndFaces then CatalogSDUICategoryIds.Body_ClassicFaces:rawValue() else CatalogSDUICategoryIds.Accessories_Face:rawValue() else CatalogSDUICategoryIds.Body_Heads:rawValue()
		},
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.Face },
		SearchUuid = SearchUuid(),
		Id = AvatarEditorSubcategories.ClassicFaces
	}
	local t15 = {
		Name = "Torsos",
		Title = "Feature.Avatar.Label.Torsos",
		IconOn = "icons/menu/clothing/torsos_on",
		IconOff = "icons/menu/clothing/torsos_off",
		RenderItemTiles = true,
		NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Torsos,
		CameraFocus = Constants2.FocusType.Arms,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.DynamicBodyCategories.Torsos,
		RecommendationsType = Constants3.RecommendationsType.BodyParts,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			CategoryKey = if not v68 then CatalogCategories.Characters else CatalogCategories.Body,
			SubcategoryKey = if not v68 then nil else CatalogSubcategories.FullBodies
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			CategoryId = if not v68 then CatalogSDUICategoryIds.Characters:rawValue() else CatalogSDUICategoryIds.Body:rawValue(),
			SubcategoryId = if not v68 then nil else CatalogSDUICategoryIds.Body_FullBodies:rawValue()
		},
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.Torso },
		SearchUuid = SearchUuid(),
		Id = AvatarEditorSubcategories.Torsos
	}
	local t16 = {
		Name = "Left Arms",
		Title = "Feature.Avatar.Label.LeftArms",
		IconOn = "icons/menu/clothing/arms_on",
		IconOff = "icons/menu/clothing/arms_off",
		RenderItemTiles = true,
		NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.LeftArms,
		CameraFocus = Constants2.FocusType.Arms,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.DynamicBodyCategories.Arms,
		RecommendationsType = Constants3.RecommendationsType.BodyParts,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			CategoryKey = if not v68 then CatalogCategories.Characters else CatalogCategories.Body,
			SubcategoryKey = if not v68 then nil else CatalogSubcategories.FullBodies
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			CategoryId = if not v68 then CatalogSDUICategoryIds.Characters:rawValue() else CatalogSDUICategoryIds.Body:rawValue(),
			SubcategoryId = if not v68 then nil else CatalogSDUICategoryIds.Body_FullBodies:rawValue()
		},
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.LeftArm },
		SearchUuid = SearchUuid(),
		Id = AvatarEditorSubcategories.LeftArms
	}
	local t17 = {
		Name = "Right Arms",
		Title = "Feature.Avatar.Label.RightArms",
		IconOn = "icons/menu/clothing/arms_on",
		IconOff = "icons/menu/clothing/arms_off",
		RenderItemTiles = true,
		NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.RightArms,
		CameraFocus = Constants2.FocusType.Arms,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.DynamicBodyCategories.Arms,
		RecommendationsType = Constants3.RecommendationsType.BodyParts,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			CategoryKey = if not v68 then CatalogCategories.Characters else CatalogCategories.Body,
			SubcategoryKey = if not v68 then nil else CatalogSubcategories.FullBodies
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			CategoryId = if not v68 then CatalogSDUICategoryIds.Characters:rawValue() else CatalogSDUICategoryIds.Body:rawValue(),
			SubcategoryId = if not v68 then nil else CatalogSDUICategoryIds.Body_FullBodies:rawValue()
		},
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.RightArm },
		SearchUuid = SearchUuid(),
		Id = AvatarEditorSubcategories.RightArms
	}
	local t18 = {
		Name = "Left Legs",
		Title = "Feature.Avatar.Label.LeftLegs",
		IconOn = "icons/menu/clothing/legs_on",
		IconOff = "icons/menu/clothing/legs_off",
		RenderItemTiles = true,
		NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.LeftLegs,
		CameraFocus = Constants2.FocusType.Legs,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.DynamicBodyCategories.Legs,
		RecommendationsType = Constants3.RecommendationsType.BodyParts,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			CategoryKey = if not v68 then CatalogCategories.Characters else CatalogCategories.Body,
			SubcategoryKey = if not v68 then nil else CatalogSubcategories.FullBodies
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			CategoryId = if not v68 then CatalogSDUICategoryIds.Characters:rawValue() else CatalogSDUICategoryIds.Body:rawValue(),
			SubcategoryId = if not v68 then nil else CatalogSDUICategoryIds.Body_FullBodies:rawValue()
		},
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.LeftLeg },
		SearchUuid = SearchUuid(),
		Id = AvatarEditorSubcategories.LeftLegs
	}
	local t19 = {
		Name = "Right Legs",
		Title = "Feature.Avatar.Label.RightLegs",
		IconOn = "icons/menu/clothing/legs_on",
		IconOff = "icons/menu/clothing/legs_off",
		RenderItemTiles = true,
		NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.RightLegs,
		CameraFocus = Constants2.FocusType.Legs,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.DynamicBodyCategories.Legs,
		RecommendationsType = Constants3.RecommendationsType.BodyParts,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			CategoryKey = if not v68 then CatalogCategories.Characters else CatalogCategories.Body,
			SubcategoryKey = if not v68 then nil else CatalogSubcategories.FullBodies
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			CategoryId = if not v68 then CatalogSDUICategoryIds.Characters:rawValue() else CatalogSDUICategoryIds.Body:rawValue(),
			SubcategoryId = if not v68 then nil else CatalogSDUICategoryIds.Body_FullBodies:rawValue()
		},
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.RightLeg },
		SearchUuid = SearchUuid(),
		Id = AvatarEditorSubcategories.RightLegs
	}
	local t20 = {
		Name = "Build",
		Title = "Feature.Avatar.Label.Build",
		IconOn = "icons/menu/clothing/build_on",
		IconOff = "icons/menu/clothing/build_off",
		RenderItemTiles = false,
		hideFilter = true,
		NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Build,
		RecommendationsType = Constants3.RecommendationsType.None,
		PageType = Constants2.PageType.BodyStyle,
		SearchUuid = SearchUuid(),
		Id = AvatarEditorSubcategories.Build
	}
	local t21 = {}

	table.insert(t21, t10)
	table.insert(t21, t11)
	table.insert(t21, t12)

	if (not AXCatalogHeadCategoryCombineIXP.isEnabled() or not v67) and not FFlagRemoveClassicHeadsAndFaces then
		table.insert(t21, t13)
		table.insert(t21, t14)
	end

	table.insert(t21, t15)
	table.insert(t21, t16)
	table.insert(t21, t17)
	table.insert(t21, t18)
	table.insert(t21, t19)

	if not IsVRAppBuild() then
		table.insert(t21, t20)
	end

	t9.Subcategories = t21

	local v83 = v46()
	local v84 = v48()
	local v85 = if not GetFFlagAXExtractEmotesCategory() then {
		Title = "Feature.Avatar.Heading.Emotes",
		IconOn = "icons/menu/clothing/emotes_on",
		IconOff = "icons/menu/clothing/emotes_off",
		EquipSlotsCount = 8,
		RenderItemTiles = true,
		CanAnimateCameraBasedMood = false,
		Name = Constants2.AssetCategories.Emotes,
		CameraZoomRadius = Constants2.AnimationCategoryCameraZoomRadius,
		PageType = Constants2.PageType.Emotes,
		RecommendationsType = Constants3.RecommendationsType.Asset,
		MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
			CategoryKey = CatalogCategories.AllAnimations,
			SubcategoryKey = CatalogSubcategories.Emotes
		} else nil,
		MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
			CategoryId = CatalogSDUICategoryIds.AllAnimations:rawValue(),
			SubcategoryId = CatalogSDUICategoryIds.Emotes:rawValue()
		},
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.EmoteAnimation },
		SearchUuid = SearchUuid(),
		Id = AvatarEditorCategories.Emotes,
		ShowName = not not GetFFlagAXEnableSlotBasedEditor() or nil
	} else getEmotesCategory()

	t22 = {
		v69,
		t9,
		getClothingCategories().avatarEditorCategories,
		v83,
		v85,
		v84
	}

	for v86, v87 in t22 do
		v87.Category = v86
		v87.Subcategory = nil

		if v87.Subcategories then
			for v88, v89 in v87.Subcategories do
				v89.Category = v86
				v89.Subcategory = v88
			end
		end
	end
end
local function buildSlotBasedEditorCategories() -- line: 2095
	-- upvalues: GetFFlagAXEnableSlotBasedEditor (copy), AvatarEditorCategories (copy), SearchUuid (copy), FFlagAXTweakSlotsCameraPositioning (copy), Constants2 (copy), FFlagAXCustomizeMakeupSupport (copy), GetFFlagAXEnableRecommendationTypeAllInCustomize (copy), CatalogCategories (copy), Constants3 (copy), v43 (copy), v44 (copy), v46 (copy), FFlagAXCustomizeBackgrounds (copy), v45 (copy), v48 (copy), v47 (copy), getEmotesCategory (copy), FFlagAXDownrankMakeupCustomize (copy), getClothingCategories (copy)
	local t23 = {
		Name = "All",
		Title = "Feature.Avatar.Heading.All",
		CanAnimateCameraBasedMood = true,
		RenderOutfitItemTiles = true,
		IconOn = "icons/menu/clothing/purchased_on",
		IconOff = "icons/menu/clothing/purchased_off",
		RenderItemTiles = true,
		UseGetInventoryV2 = true,
		NavigationKey = if not GetFFlagAXEnableSlotBasedEditor() then nil else AvatarEditorCategories.All,
		SearchUuid = SearchUuid(),
		CameraFocus = if not FFlagAXTweakSlotsCameraPositioning then Constants2.FocusType.Arms else Constants2.FocusType.Neck,
		CameraZoomRadius = not FFlagAXTweakSlotsCameraPositioning and 13 or 15,
		AssetTypeIdStrings = if not FFlagAXCustomizeMakeupSupport then {
			Constants2.AssetTypeIdStrings.TShirt,
			Constants2.AssetTypeIdStrings.Shirt,
			Constants2.AssetTypeIdStrings.Pants,
			Constants2.AssetTypeIdStrings.Hat,
			Constants2.AssetTypeIdStrings.Face,
			Constants2.AssetTypeIdStrings.Gear,
			Constants2.AssetTypeIdStrings.HairAccessory,
			Constants2.AssetTypeIdStrings.FaceAccessory,
			Constants2.AssetTypeIdStrings.NeckAccessory,
			Constants2.AssetTypeIdStrings.ShoulderAccessory,
			Constants2.AssetTypeIdStrings.FrontAccessory,
			Constants2.AssetTypeIdStrings.BackAccessory,
			Constants2.AssetTypeIdStrings.WaistAccessory,
			Constants2.AssetTypeIdStrings.TShirtAccessory,
			Constants2.AssetTypeIdStrings.ShirtAccessory,
			Constants2.AssetTypeIdStrings.PantsAccessory,
			Constants2.AssetTypeIdStrings.JacketAccessory,
			Constants2.AssetTypeIdStrings.SweaterAccessory,
			Constants2.AssetTypeIdStrings.ShortsAccessory,
			Constants2.AssetTypeIdStrings.DressSkirtAccessory,
			Constants2.AssetTypeIdStrings.Head
		} else {
			Constants2.AssetTypeIdStrings.TShirt,
			Constants2.AssetTypeIdStrings.Shirt,
			Constants2.AssetTypeIdStrings.Pants,
			Constants2.AssetTypeIdStrings.Hat,
			Constants2.AssetTypeIdStrings.Face,
			Constants2.AssetTypeIdStrings.Gear,
			Constants2.AssetTypeIdStrings.HairAccessory,
			Constants2.AssetTypeIdStrings.FaceAccessory,
			Constants2.AssetTypeIdStrings.NeckAccessory,
			Constants2.AssetTypeIdStrings.ShoulderAccessory,
			Constants2.AssetTypeIdStrings.FrontAccessory,
			Constants2.AssetTypeIdStrings.BackAccessory,
			Constants2.AssetTypeIdStrings.WaistAccessory,
			Constants2.AssetTypeIdStrings.TShirtAccessory,
			Constants2.AssetTypeIdStrings.ShirtAccessory,
			Constants2.AssetTypeIdStrings.PantsAccessory,
			Constants2.AssetTypeIdStrings.JacketAccessory,
			Constants2.AssetTypeIdStrings.SweaterAccessory,
			Constants2.AssetTypeIdStrings.ShortsAccessory,
			Constants2.AssetTypeIdStrings.DressSkirtAccessory,
			Constants2.AssetTypeIdStrings.Head,
			Constants2.AssetTypeIdStrings.EyelashAccessory,
			Constants2.AssetTypeIdStrings.EyebrowAccessory,
			Constants2.AssetTypeIdStrings.FaceMakeup,
			Constants2.AssetTypeIdStrings.EyeMakeup,
			Constants2.AssetTypeIdStrings.LipMakeup
		},
		BundleTypeIdStrings = {
			Constants2.BundleTypeIdStrings.BodyParts,
			Constants2.BundleTypeIdStrings.DynamicHead,
			Constants2.BundleTypeIdStrings.Shoes,
			Constants2.BundleTypeIdStrings.Animations
		},
		MatchingCatalogPage = if not GetFFlagAXEnableRecommendationTypeAllInCustomize() then nil else {
			CategoryKey = CatalogCategories.Recommended
		},
		RecommendationsType = if not GetFFlagAXEnableRecommendationTypeAllInCustomize() then nil else Constants3.RecommendationsType.All,
		Id = AvatarEditorCategories.All
	}
	local v91 = v43()
	local v92 = if not FFlagAXCustomizeMakeupSupport then nil else v44()
	local v93 = v46()
	local v94 = if not FFlagAXCustomizeBackgrounds then nil else v45()
	local v95 = v48()
	local v96 = v47()
	local v97 = getEmotesCategory()
	local v98 = if not FFlagAXCustomizeMakeupSupport or FFlagAXDownrankMakeupCustomize then {
		t23,
		v96,
		v91,
		getClothingCategories().avatarEditorCategories,
		v93,
		v95,
		v97
	} else {
		t23,
		v96,
		v91,
		v92,
		getClothingCategories().avatarEditorCategories,
		v93,
		v95,
		v97
	}

	if FFlagAXDownrankMakeupCustomize then
		table.insert(v98, v92)
	end

	if v94 then
		for v99, v100 in v98 do
			if v100 == v93 then
				table.insert(v98, v99 + 1, v94)

				break
			end
		end
	end

	for v101, v102 in v98 do
		v102.Category = v101
		v102.Subcategory = nil

		if v102.Subcategories then
			for v103, v104 in v102.Subcategories do
				v104.Category = v101
				v104.Subcategory = v103
				v104.UseGetInventoryV2 = true
			end
		end
	end

	return v98
end
local function sanityCheckCat(p1) -- line: 2247
	-- upvalues: ArgCheck (copy)
	ArgCheck.isNotNil(p1.IconOn, `category { p1.Name } is missing iconOn`)
	ArgCheck.isNotNil(p1.IconOff, `category { p1.Name } is missing IconOff`)
	ArgCheck.isNotNil(p1.SearchUuid, `category { p1.Name } is missing SearchUuid`)
	ArgCheck.isNotNil(p1.Id, "category  " .. p1.Name .. " is missing Id")
end
local function checkDuplicateId(p2, p3) -- line: 2254
	if p2 then
		if p3[p2] then
			error("Duplicate Id found: " .. p2)

			return
		end

		p3[p2] = true
	end
end
local function sanityCheck(p4) -- line: 2264
	-- upvalues: sanityCheckCat (copy)
	local t24 = {}

	for _, v111 in p4 do
		sanityCheckCat(v111)

		local Id = v111.Id

		if Id then
			if t24[Id] then
				error("Duplicate Id found: " .. Id)
			else
				t24[Id] = true
			end
		end

		if v111.Subcategories then
			for _, v114 in v111.Subcategories do
				sanityCheckCat(v114)

				local Id2 = v114.Id

				if Id2 then
					if t24[Id2] then
						error("Duplicate Id found: " .. Id2)
					else
						t24[Id2] = true
					end
				end
			end
		end
	end
end

local u54 = nil

return function() -- line: 2280
	-- upvalues: GetFFlagAXEnableSlotBasedEditor (copy), u54 (ref), buildSlotBasedEditorCategories (copy), sanityCheck (copy), t22 (ref), v49 (copy)
	if GetFFlagAXEnableSlotBasedEditor() then
		if not u54 then
			u54 = buildSlotBasedEditorCategories()
			sanityCheck(u54)
		end

		return u54
	end

	if not t22 then
		v49()
		sanityCheck(t22)
	end

	return t22
end
