local CorePackages = game:GetService("CorePackages")

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module2 = require("@luauforge/bundled/dMx")
local module3 = require("@luauforge/bundled/dNQ")
local module4 = require("@luauforge/bundled/dMd")
local animationCategoryCameraZoomRadius = module4.Constants.AnimationCategoryCameraZoomRadius
local cameraZoomRadius = module4.Constants.CameraZoomRadius
local focusType = module4.Enums.FocusType
local inventoryOutfitType = module4.Enums.InventoryOutfitType
local recommendationsType = module4.Enums.RecommendationsType
local searchUuid = require("@luauforge/bundled/dOk").SearchUuid
local module5 = require("@luauforge/bundled/dOn")
local module6 = require("@luauforge/bundled/dOo")
local module7 = require("@luauforge/bundled/dwM")
local module8 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local catalogCategories = module4.Enums.CatalogCategories
local catalogSubcategories = module8.Enums.CatalogSubcategories
local catalogSDUICategoryIds = module8.Enums.CatalogSDUICategoryIds
local catalogCategoryKeys = module8.Enums.CatalogCategoryKeys
local catalogSubcategoryKeys = module8.Enums.CatalogSubcategoryKeys
local isVRAppBuild = require("@game/CorePackages/Workspace/Packages/AppCommonLib").IsVRAppBuild

local Foundation = require(CorePackages.Packages.Foundation)
local iconName = Foundation.Enums.IconName

local module9 = require("@luauforge/bundled/dMB")
local module10 = require("@luauforge/bundled/dOp")
local avatarEditorCategories = module4.Enums.AvatarEditorCategories
local avatarEditorSubcategories = module4.Enums.AvatarEditorSubcategories
local module11 = require("@luauforge/bundled/dOc")
local module12 = require("@luauforge/bundled/dOr")

local module13 = require("@luauforge/bundled/dOs")
local module14 = require("@luauforge/bundled/dOt")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagRemoveClassicHeadsAndFaces = AvatarExperienceFlags.FFlagRemoveClassicHeadsAndFaces
local fFlagAXCustomizeBackgrounds = AvatarExperienceFlags.FFlagAXCustomizeBackgrounds
local fFlagAXBackgroundsCustomizeHydration = AvatarExperienceFlags.FFlagAXBackgroundsCustomizeHydration
local fFlagAXBackgroundsYouMayAlsoLike = AvatarExperienceFlags.FFlagAXBackgroundsYouMayAlsoLike
local fFlagAXInventoryDurablesSupport = AvatarExperienceFlags.FFlagAXInventoryDurablesSupport
local fFlagAXMigrateOutfitsToUserInventory = AvatarExperienceFlags.FFlagAXMigrateOutfitsToUserInventory
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local fFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local defineFastFlag = game:DefineFastFlag("AXAvatarTabShopForMore", false)
local fFlagAXAvatarTabLooksYouMayAlsoLike = AvatarExperienceFlags.FFlagAXAvatarTabLooksYouMayAlsoLike
local fFlagAXDownrankMakeupCustomize = AvatarExperienceFlags.FFlagAXDownrankMakeupCustomize
local fFlagAXAvatarTabWidgetRecommendation = AvatarExperienceFlags.FFlagAXAvatarTabWidgetRecommendation

local axAvatarsTabIXP = AvatarExperienceCommon.Experiments.AXAvatarsTabIXP

local v5 = nil

local function fn()
	local v6

	if axAvatarsTabIXP.isEnabled() then
		v6 = module9.readTestVariable(axAvatarsTabIXP.EnabledForUser)
	end

	local v7 = {
		Name = module3.CharacterKey,
		Title = "Feature.Catalog.Label.Characters",
		IconOn = "icons/menu/clothing/characters_on",
		IconOff = "icons/menu/clothing/characters_off",
		RenderItemTiles = true,
		RenderOutfitItemTiles = true,
		RecommendationsType = recommendationsType.BodyParts,
		MatchingCatalogPage = 0,
		MatchingCatalogPageIds = 0,
		SearchUuid = 0,
		OutfitType = 0,
		CanAnimateCameraBasedMood = true,
		Subcategories = 0,
		Id = 0
	}
	local v8

	if not fFlagAXCatalogCategoriesSDUI then
		v8 = { CategoryKey = 0, SubcategoryKey = 0 }
		local v9 = if v6 then catalogCategories.Body else catalogCategories.Characters
		v8.CategoryKey = v9
		local v10 = if v6 then catalogSubcategories.FullBodies else nil
		v8.SubcategoryKey = v10
	end

	v7.MatchingCatalogPage = v8
	local v9

	if fFlagAXMigrateAllTabToSduiDev then
		v9 = { CategoryId = 0, SubcategoryId = 0 }

		local v10 = if v6 then catalogCategoryKeys.Body else catalogCategoryKeys.Characters
		v9.CategoryId = v10

		local v11 = if v6 then catalogSubcategoryKeys.FullBodies else nil
		v9.SubcategoryId = v11
	elseif fFlagAXCatalogCategoriesSDUI then
		v9 = { CategoryId = 0, SubcategoryId = 0 }

		local v10 = if v6 then catalogSDUICategoryIds.Body:rawValue() else catalogSDUICategoryIds.Characters:rawValue()
		v9.CategoryId = v10

		local v11 = if v6 then catalogSDUICategoryIds.Body_FullBodies:rawValue() else nil
		v9.SubcategoryId = v11
	end

	v7.MatchingCatalogPageIds = v9

	v7.SearchUuid = module3.CharacterKey
	v7.OutfitType = module2.OutfitTypes.Avatar

	local creations = {
		Name = "Creations",
		NavigationKey = avatarEditorSubcategories.CreatedCharacters,
		Title = "Feature.Avatar.Label.Creations",
		IconOn = "icons/menu/clothing/creations_on",
		IconOff = "icons/menu/clothing/creations_off",
		RenderItemTiles = true,
		RenderOutfitItemTiles = true,
		ManageOutfitsEnabled = true,
		RecommendationsType = recommendationsType.BodyParts,
		MatchingCatalogPage = 0,
		MatchingCatalogPageIds = 0,
		SearchUuid = 0,
		OutfitType = 0,
		BundleTypes = 0,
		Id = 0
	}
	local v11

	if not fFlagAXCatalogCategoriesSDUI then
		v11 = { CategoryKey = 0 }

		local v12 = if v6 then catalogCategories.Avatars else catalogCategories.Characters
		v11.CategoryKey = v12
	end

	creations.MatchingCatalogPage = v11
	local v12

	if fFlagAXMigrateAllTabToSduiDev then
		v12 = { CategoryId = 0 }

		local v13 = if v6 then catalogCategoryKeys.Avatars else catalogCategoryKeys.Characters
		v12.CategoryId = v13
	elseif fFlagAXCatalogCategoriesSDUI then
		v12 = { CategoryId = 0 }

		local v13 = if v6 then catalogSDUICategoryIds.Avatars:rawValue() else catalogSDUICategoryIds.Characters:rawValue()
		v12.CategoryId = v13
	end

	creations.MatchingCatalogPageIds = v12

	creations.SearchUuid = module3.EditableCharacterKey
	creations.OutfitType = module2.OutfitTypes.Avatar
	creations.BundleTypes = {
		module2.BundleTypeIdStrings.BodyParts,
		module2.BundleTypeIdStrings.Animations
	}

	creations.Id = avatarEditorSubcategories.CreatedCharacters

	local purchased = {
		Name = "Purchased",
		NavigationKey = avatarEditorSubcategories.PurchasedCharacters,
		Title = "Feature.Avatar.Label.Purchased",
		IconOn = "icons/menu/clothing/purchased_on",
		IconOff = "icons/menu/clothing/purchased_off",
		RenderItemTiles = true,
		RenderOutfitItemTiles = true,
		RecommendationsType = recommendationsType.BodyParts,
		MatchingCatalogPage = 0,
		MatchingCatalogPageIds = 0,
		SearchUuid = 0,
		OutfitType = 0,
		Id = 0
	}
	local v13

	if not fFlagAXCatalogCategoriesSDUI then
		v13 = { CategoryKey = 0, SubcategoryKey = 0 }

		local v14 = if v6 then catalogCategories.Body else catalogCategories.Characters
		v13.CategoryKey = v14

		local v15 = if v6 then catalogSubcategories.FullBodies else nil
		v13.SubcategoryKey = v15
	end

	purchased.MatchingCatalogPage = v13
	local v14

	if fFlagAXMigrateAllTabToSduiDev then
		v14 = { CategoryId = 0, SubcategoryId = 0 }

		local v15 = if v6 then catalogCategoryKeys.Body else catalogCategoryKeys.Characters
		v14.CategoryId = v15

		local v16 = if v6 then catalogSubcategoryKeys.FullBodies else nil
		v14.SubcategoryId = v16
	elseif fFlagAXCatalogCategoriesSDUI then
		v14 = { CategoryId = 0, SubcategoryId = 0 }

		local v15 = if v6 then catalogSDUICategoryIds.Body:rawValue() else catalogSDUICategoryIds.Characters:rawValue()
		v14.CategoryId = v15

		local v16 = if v6 then catalogSDUICategoryIds.Body_FullBodies:rawValue() else nil
		v14.SubcategoryId = v16
	end

	purchased.MatchingCatalogPageIds = v14

	purchased.SearchUuid = module3.PurchasedCharacterKey
	purchased.OutfitType = module2.OutfitTypes.Avatar
	purchased.Id = avatarEditorSubcategories.PurchasedCharacters
	v7.Subcategories = { creations, purchased } or nil

	v7.Id = avatarEditorCategories.Characters

	return v7
end

local function fn2()
	local v6

	if axAvatarsTabIXP.isEnabled() then
		v6 = module9.readTestVariable(axAvatarsTabIXP.EnabledForUser)
	end

	local v7 = if module11() then avatarEditorCategories.Body else nil
	local body = {
		Name = "Body",
		NavigationKey = v7,
		Title = "Feature.Catalog.Label.Body",
		IconOn = "icons/menu/clothing/body_on",
		IconOff = "icons/menu/clothing/body_off",
		SearchUuid = searchUuid(),
		CanAnimateCameraBasedMood = true,
		Subcategories = {},
		Id = avatarEditorCategories.Body
	}

	local v8 = {
		Name = "Skin",
		NavigationKey = avatarEditorSubcategories.Skin,
		Title = "Feature.Avatar.Label.Skin",
		IconOn = "icons/menu/clothing/skin_on",
		IconOff = "icons/menu/clothing/skin_off",
		RenderItemTiles = false,
		RecommendationsType = recommendationsType.None,
		PageType = module2.PageType.BodyColors,
		SearchUuid = searchUuid(),
		Id = avatarEditorSubcategories.Skin,
		hideFilter = true
	}

	local v9 = {
		Name = "Build",
		NavigationKey = avatarEditorSubcategories.Build,
		Title = "Feature.Avatar.Label.Build",
		IconOn = "icons/menu/clothing/build_on",
		IconOff = "icons/menu/clothing/build_off",
		RenderItemTiles = false,
		RecommendationsType = recommendationsType.None,
		PageType = module2.PageType.BodyStyle,
		SearchUuid = searchUuid(),
		Id = avatarEditorSubcategories.Build,
		hideFilter = true
	}

	local hair = {
		Name = "Hair",
		NavigationKey = avatarEditorSubcategories.Hair,
		Title = "Feature.Avatar.Label.Hair",
		IconOn = "icons/menu/clothing/hair_on",
		IconOff = "icons/menu/clothing/hair_off",
		RenderItemTiles = true,
		UseGetInventoryV2 = true,
		CameraFocus = focusType.Head,
		CameraZoomRadius = cameraZoomRadius.BodyCategories.Hair,
		RecommendationsType = recommendationsType.Asset,
		MatchingCatalogPage = 0,
		MatchingCatalogPageIds = 0,
		AssetTypeIdStrings = 0,
		SearchUuid = 0,
		Id = 0
	}
	local v10

	if not fFlagAXCatalogCategoriesSDUI then
		v10 = { CategoryKey = 0, SubcategoryKey = 0 }
		local v11 = if v6 then catalogCategories.Body else catalogCategories.Head
		v10.CategoryKey = v11
		v10.SubcategoryKey = catalogSubcategories.Hair
	end

	hair.MatchingCatalogPage = v10
	local v11

	if fFlagAXMigrateAllTabToSduiDev then
		v11 = {
			CategoryId = catalogCategoryKeys.Body,
			SubcategoryId = catalogSubcategoryKeys.Hair
		}
	elseif fFlagAXCatalogCategoriesSDUI then
		v11 = { CategoryId = 0, SubcategoryId = 0 }

		local v12 = if v6 then catalogSDUICategoryIds.Body:rawValue() else catalogSDUICategoryIds.Head:rawValue()
		v11.CategoryId = v12

		v11.SubcategoryId = catalogSDUICategoryIds.Body_Hair:rawValue()
	end

	hair.MatchingCatalogPageIds = v11

	hair.AssetTypeIdStrings = { module2.AssetTypeIdStrings.HairAccessory }
	hair.SearchUuid = searchUuid()
	hair.Id = avatarEditorSubcategories.Hair

	local heads = {
		Name = "Heads",
		NavigationKey = avatarEditorSubcategories.Heads,
		Title = "Feature.Avatar.Label.Head",
		IconOn = "icons/menu/clothing/type_on",
		IconOff = "icons/menu/clothing/type_off",
		RenderItemTiles = true,
		RenderOutfitItemTiles = true,
		UseGetInventoryV2 = true,
		CameraFocus = focusType.Face,
		CameraZoomRadius = 0,
		RecommendationsType = 0,
		MatchingCatalogPage = 0,
		MatchingCatalogPageIds = 0,
		AssetTypeIdStrings = 0,
		BundleTypeIdStrings = 0,
		InventoryOutfitTypes = 0,
		SubcategoryFiltersHeader = 0,
		SubcategoryFilters = 0,
		SearchUuid = 0,
		Id = 0
	}

	local v12 = if fFlagRemoveClassicHeadsAndFaces then cameraZoomRadius.BodyCategories.Heads else cameraZoomRadius.BodyCategories.ClassicHeads
	heads.CameraZoomRadius = v12

	heads.RecommendationsType = recommendationsType.DynamicHeads
	local v13

	if not fFlagAXCatalogCategoriesSDUI then
		v13 = { CategoryKey = 0, SubcategoryKey = 0 }
		local v14 = if v6 then catalogCategories.Body else catalogCategories.Head
		v13.CategoryKey = v14
		v13.SubcategoryKey = catalogSubcategories.Heads
	end

	heads.MatchingCatalogPage = v13
	local v14

	if fFlagAXMigrateAllTabToSduiDev then
		v14 = {
			CategoryId = catalogCategoryKeys.Body,
			SubcategoryId = catalogSubcategoryKeys.Heads
		}
	elseif fFlagAXCatalogCategoriesSDUI then
		v14 = { CategoryId = 0, SubcategoryId = 0 }

		local v15 = if v6 then catalogSDUICategoryIds.Body:rawValue() else catalogSDUICategoryIds.Head:rawValue()
		v14.CategoryId = v15

		v14.SubcategoryId = catalogSDUICategoryIds.Body_Heads:rawValue()
	end

	heads.MatchingCatalogPageIds = v14

	heads.AssetTypeIdStrings = not fFlagRemoveClassicHeadsAndFaces
		and { module2.AssetTypeIdStrings.Head }
		or nil

	heads.BundleTypeIdStrings = { module2.BundleTypeIdStrings.DynamicHead }
	heads.InventoryOutfitTypes = fFlagAXMigrateOutfitsToUserInventory
		and { inventoryOutfitType.DynamicHead }
		or nil

	heads.SubcategoryFiltersHeader = not fFlagRemoveClassicHeadsAndFaces
		and "Feature.Catalog.Heading.ShowHeadType"
		or nil

	heads.SubcategoryFilters = not fFlagRemoveClassicHeadsAndFaces and {
		{
			Name = "All Heads",
			Title = "Feature.Avatar.Label.AllHeads",
			NavigationKey = avatarEditorSubcategories.AllHeads,
			AssetTypeIdStrings = { module2.AssetTypeIdStrings.Head },
			BundleTypeIdStrings = { module2.BundleTypeIdStrings.DynamicHead },
			InventoryOutfitTypes = fFlagAXMigrateOutfitsToUserInventory and { inventoryOutfitType.DynamicHead } or nil,
			RenderOutfitItemTiles = true,
			SearchUuid = searchUuid()
		},
		{
			Name = "Dynamic Heads",
			Title = "Feature.Avatar.Label.DynamicHeads",
			NavigationKey = avatarEditorSubcategories.DynamicHeads,
			BundleTypeIdStrings = { module2.BundleTypeIdStrings.DynamicHead },
			InventoryOutfitTypes = fFlagAXMigrateOutfitsToUserInventory and { inventoryOutfitType.DynamicHead } or nil,
			RenderOutfitItemTiles = true,
			SearchUuid = searchUuid()
		},
		{
			Name = "Classic Heads",
			Title = "Feature.Avatar.Label.ClassicHeads",
			NavigationKey = avatarEditorSubcategories.ClassicHeads,
			AssetTypeIdStrings = { module2.AssetTypeIdStrings.Head },
			SearchUuid = searchUuid()
		}
	} or nil

	heads.SearchUuid = searchUuid()
	heads.Id = avatarEditorSubcategories.Heads
	local faces

	if not fFlagRemoveClassicHeadsAndFaces then
		faces = {
			Name = "Faces",
			NavigationKey = avatarEditorSubcategories.ClassicFaces,
			Title = "Feature.Avatar.Label.Face",
			IconOn = "icons/menu/clothing/faces_on",
			IconOff = "icons/menu/clothing/faces_off",
			RenderItemTiles = true,
			UseGetInventoryV2 = true,
			CameraFocus = focusType.Face,
			CameraZoomRadius = cameraZoomRadius.BodyCategories.ClassicFaces,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = 0,
			MatchingCatalogPageIds = 0,
			AssetTypeIdStrings = 0,
			SearchUuid = 0,
			Id = 0
		}
		local v15

		if not fFlagAXCatalogCategoriesSDUI then
			v15 = { CategoryKey = 0, SubcategoryKey = 0 }
			local v16 = if v6 then catalogCategories.Body else catalogCategories.Head
			v15.CategoryKey = v16
			v15.SubcategoryKey = catalogSubcategories.ClassicFaces
		end

		faces.MatchingCatalogPage = v15
		local v16

		if fFlagAXMigrateAllTabToSduiDev then
			v16 = { CategoryId = catalogSubcategoryKeys.ClassicFaces }
		elseif fFlagAXCatalogCategoriesSDUI then
			v16 = { CategoryId = 0, SubcategoryId = 0 }

			local v17 = if v6 then catalogSDUICategoryIds.Body:rawValue() else catalogSDUICategoryIds.Head:rawValue()
			v16.CategoryId = v17

			v16.SubcategoryId = catalogSDUICategoryIds.Body_ClassicFaces:rawValue()
		end

		faces.MatchingCatalogPageIds = v16

		faces.AssetTypeIdStrings = { module2.AssetTypeIdStrings.Face }
		faces.SearchUuid = searchUuid()
		faces.Id = avatarEditorSubcategories.ClassicFaces
	end

	local fullBody = {
		Name = "Full Body",
		NavigationKey = avatarEditorSubcategories.PurchasedCharacters,
		Title = "Feature.Catalog.Label.FullBody",
		IconOn = "icons/menu/clothing/body_on",
		IconOff = "icons/menu/clothing/body_off",
		RenderItemTiles = true,
		RenderOutfitItemTiles = true,
		UseGetInventoryV2 = true,
		RecommendationsType = recommendationsType.BodyParts,
		MatchingCatalogPage = 0,
		MatchingCatalogPageIds = 0,
		SearchUuid = 0,
		OutfitType = 0,
		BundleTypeIdStrings = 0,
		InventoryOutfitTypes = 0,
		SubcategoryFiltersHeader = "Feature.Catalog.Heading.ShowBodyParts",
		SubcategoryFilters = 0,
		Id = 0
	}
	local v15

	if not fFlagAXCatalogCategoriesSDUI then
		v15 = { CategoryKey = 0, SubcategoryKey = 0 }
		local v16 = if v6 then catalogCategories.Body else catalogCategories.Characters
		v15.CategoryKey = v16
		local v17 = if v6 then catalogSubcategories.FullBodies else nil
		v15.SubcategoryKey = v17
	end

	fullBody.MatchingCatalogPage = v15
	local v16

	if fFlagAXMigrateAllTabToSduiDev then
		v16 = { CategoryId = 0, SubcategoryId = 0 }

		local v17 = if v6 then catalogCategoryKeys.Body else catalogCategoryKeys.Characters
		v16.CategoryId = v17

		local v18 = if v6 then catalogSubcategoryKeys.FullBodies else nil
		v16.SubcategoryId = v18
	elseif fFlagAXCatalogCategoriesSDUI then
		v16 = { CategoryId = 0, SubcategoryId = 0 }

		local v17 = if v6 then catalogSDUICategoryIds.Body:rawValue() else catalogSDUICategoryIds.Characters:rawValue()
		v16.CategoryId = v17

		local v18 = if v6 then catalogSDUICategoryIds.Body_FullBodies:rawValue() else nil
		v16.SubcategoryId = v18
	end

	fullBody.MatchingCatalogPageIds = v16

	fullBody.SearchUuid = module3.PurchasedCharacterKey
	fullBody.OutfitType = module2.OutfitTypes.Avatar

	fullBody.BundleTypeIdStrings = { module2.BundleTypeIdStrings.BodyParts }
	fullBody.InventoryOutfitTypes = fFlagAXMigrateOutfitsToUserInventory and { inventoryOutfitType.Body }
		or nil

	fullBody.SubcategoryFilters = {
		{
			Name = "Full Body",
			Title = "Feature.Avatar.Label.FullBody",
			NavigationKey = avatarEditorSubcategories.FullBody,
			BundleTypeIdStrings = { module2.BundleTypeIdStrings.BodyParts },
			InventoryOutfitTypes = fFlagAXMigrateOutfitsToUserInventory and { inventoryOutfitType.Body } or nil,
			RenderOutfitItemTiles = true,
			SearchUuid = searchUuid()
		},
		{
			Name = "Torso",
			Title = "Feature.Avatar.Label.Torso",
			NavigationKey = avatarEditorSubcategories.Torsos,
			AssetTypeIdStrings = { module2.AssetTypeIdStrings.Torso },
			SearchUuid = searchUuid()
		},
		{
			Name = "Right Arms",
			Title = "Feature.Avatar.Label.RightArm",
			NavigationKey = avatarEditorSubcategories.RightArms,
			AssetTypeIdStrings = { module2.AssetTypeIdStrings.RightArm },
			SearchUuid = searchUuid()
		},
		{
			Name = "Left Arms",
			Title = "Feature.Avatar.Label.LeftArm",
			NavigationKey = avatarEditorSubcategories.LeftArms,
			AssetTypeIdStrings = { module2.AssetTypeIdStrings.LeftArm },
			SearchUuid = searchUuid()
		},
		{
			Name = "Right Legs",
			Title = "Feature.Avatar.Label.RightLeg",
			NavigationKey = avatarEditorSubcategories.RightLegs,
			AssetTypeIdStrings = { module2.AssetTypeIdStrings.RightLeg },
			SearchUuid = searchUuid()
		},
		{
			Name = "Left Legs",
			Title = "Feature.Avatar.Label.LeftLeg",
			NavigationKey = avatarEditorSubcategories.LeftLegs,
			AssetTypeIdStrings = { module2.AssetTypeIdStrings.LeftLeg },
			SearchUuid = searchUuid()
		}
	}

	fullBody.Id = avatarEditorSubcategories.PurchasedCharacters

	table.insert(body.Subcategories, fullBody)
	table.insert(body.Subcategories, hair)
	table.insert(body.Subcategories, heads)

	if not fFlagRemoveClassicHeadsAndFaces then
		table.insert(body.Subcategories, faces)
	end

	table.insert(body.Subcategories, v9)

	table.insert(body.Subcategories, v8)

	return body
end

local function fn3()
	local v6 = if module11() then avatarEditorCategories.Makeup else nil
	local makeup = {
		Name = "Makeup",
		NavigationKey = v6,
		Title = "Feature.Avatar.Label.Makeup",
		IconOn = iconName.TwoMakeupBrushes,
		IconOff = iconName.TwoMakeupBrushes,
		SearchUuid = searchUuid(),
		CanAnimateCameraBasedMood = true,
		ShowSubcategoriesAsSubnavigation = true,
		Subcategories = 0,
		Id = 0
	}

	local makeupLooks = {
		Name = "MakeupLooks",
		NavigationKey = avatarEditorSubcategories.MakeupLooks,
		Title = "Feature.Avatar.Label.Looks",
		IconOn = "icons/menu/clothing/type_on",
		IconOff = "icons/menu/clothing/type_off",
		RenderItemTiles = true,
		RenderOutfitItemTiles = true,
		UseGetInventoryV2 = true,
		PageType = module2.PageType.MakeupLooks,
		CameraFocus = focusType.Face,
		CameraZoomRadius = cameraZoomRadius.Makeup.MakeupLooks,
		RecommendationsType = recommendationsType.None,
		MatchingCatalogPage = fFlagAXCatalogMakeupSupport and not fFlagAXCatalogCategoriesSDUI and {
			CategoryKey = catalogCategories.Makeup,
			SubcategoryKey = catalogSubcategories.MakeupLooks
		} or nil,
		MatchingCatalogPageIds = fFlagAXCatalogMakeupSupport and fFlagAXMigrateAllTabToSduiDev and {
			CategoryId = catalogCategoryKeys.Makeup,
			SubcategoryId = catalogSubcategoryKeys.MakeupLooks
		} or nil,
		InventoryOutfitTypes = fFlagAXMigrateOutfitsToUserInventory and {
			inventoryOutfitType.CreatedMakeup,
			inventoryOutfitType.PurchasedMakeup
		} or nil,
		SearchUuid = 0,
		Id = 0,
		hideFilter = true
	}

	local v8 = if fFlagAXMigrateOutfitsToUserInventory then avatarEditorSubcategories.MakeupLooks else searchUuid()
	makeupLooks.SearchUuid = v8

	makeupLooks.Id = avatarEditorSubcategories.MakeupLooks
	makeup.Subcategories = {
		makeupLooks,
		{
			Name = "EyeMakeup",
			NavigationKey = avatarEditorSubcategories.EyeMakeup,
			Title = "Feature.Avatar.Label.EyeMakeup",
			IconOn = "icons/menu/clothing/type_on",
			IconOff = "icons/menu/clothing/type_off",
			RenderItemTiles = true,
			RenderOutfitItemTiles = true,
			UseGetInventoryV2 = true,
			CameraFocus = focusType.Face,
			CameraZoomRadius = cameraZoomRadius.Makeup.EyeMakeup,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = fFlagAXCatalogMakeupSupport and not fFlagAXCatalogCategoriesSDUI and {
				CategoryKey = catalogCategories.Makeup,
				SubcategoryKey = catalogSubcategories.EyeMakeup
			} or nil,
			MatchingCatalogPageIds = fFlagAXCatalogMakeupSupport and fFlagAXMigrateAllTabToSduiDev and {
				CategoryId = catalogCategoryKeys.Makeup,
				SubcategoryId = catalogSubcategoryKeys.EyeMakeup
			} or nil,
			AssetTypeIdStrings = { module2.AssetTypeIdStrings.EyeMakeup },
			SearchUuid = searchUuid(),
			Id = avatarEditorSubcategories.EyeMakeup
		},
		{
			Name = "LipMakeup",
			NavigationKey = avatarEditorSubcategories.LipMakeup,
			Title = "Feature.Avatar.Label.LipMakeup",
			IconOn = "icons/menu/clothing/type_on",
			IconOff = "icons/menu/clothing/type_off",
			RenderItemTiles = true,
			RenderOutfitItemTiles = true,
			UseGetInventoryV2 = true,
			CameraFocus = focusType.Face,
			CameraZoomRadius = cameraZoomRadius.Makeup.LipMakeup,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = fFlagAXCatalogMakeupSupport and not fFlagAXCatalogCategoriesSDUI and {
				CategoryKey = catalogCategories.Makeup,
				SubcategoryKey = catalogSubcategories.FaceMakeup
			} or nil,
			MatchingCatalogPageIds = fFlagAXCatalogMakeupSupport and fFlagAXMigrateAllTabToSduiDev and {
				CategoryId = catalogCategoryKeys.Makeup,
				SubcategoryId = catalogSubcategoryKeys.LipMakeup
			} or nil,
			AssetTypeIdStrings = { module2.AssetTypeIdStrings.LipMakeup },
			SearchUuid = searchUuid(),
			Id = avatarEditorSubcategories.LipMakeup
		},
		{
			Name = "FaceMakeup",
			NavigationKey = avatarEditorSubcategories.FaceMakeup,
			Title = "Feature.Avatar.Label.FaceMakeup",
			IconOn = "icons/menu/clothing/type_on",
			IconOff = "icons/menu/clothing/type_off",
			RenderItemTiles = true,
			RenderOutfitItemTiles = true,
			UseGetInventoryV2 = true,
			CameraFocus = focusType.Face,
			CameraZoomRadius = cameraZoomRadius.Makeup.FaceMakeup,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = fFlagAXCatalogMakeupSupport and not fFlagAXCatalogCategoriesSDUI and {
				CategoryKey = catalogCategories.Makeup,
				SubcategoryKey = catalogSubcategories.LipMakeup
			} or nil,
			MatchingCatalogPageIds = fFlagAXCatalogMakeupSupport and fFlagAXMigrateAllTabToSduiDev and {
				CategoryId = catalogCategoryKeys.Makeup,
				SubcategoryId = catalogSubcategoryKeys.FaceMakeup
			} or nil,
			AssetTypeIdStrings = { module2.AssetTypeIdStrings.FaceMakeup },
			SearchUuid = searchUuid(),
			Id = avatarEditorSubcategories.FaceMakeup
		},
		{
			Name = "Eyelashes",
			NavigationKey = avatarEditorSubcategories.Eyelashes,
			Title = "Feature.Avatar.Label.Eyelashes",
			IconOn = iconName.Eyelashes,
			IconOff = iconName.Eyelashes,
			RenderItemTiles = true,
			UseGetInventoryV2 = true,
			CameraFocus = focusType.Face,
			CameraZoomRadius = cameraZoomRadius.Makeup.Eyelashes,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = fFlagAXCatalogMakeupSupport and not fFlagAXCatalogCategoriesSDUI and {
				CategoryKey = catalogCategories.Makeup,
				SubcategoryKey = catalogSubcategories.Eyelashes
			} or nil,
			MatchingCatalogPageIds = fFlagAXCatalogMakeupSupport and fFlagAXMigrateAllTabToSduiDev and {
				CategoryId = catalogCategoryKeys.Makeup,
				SubcategoryId = catalogSubcategoryKeys.Eyelashes
			} or nil,
			AssetTypeIdStrings = { module2.AssetTypeIdStrings.EyelashAccessory },
			SearchUuid = searchUuid(),
			Id = avatarEditorSubcategories.Eyelashes
		},
		{
			Name = "Eyebrows",
			NavigationKey = avatarEditorSubcategories.Eyebrows,
			Title = "Feature.Avatar.Label.Eyebrows",
			IconOn = iconName.Eyebrows,
			IconOff = iconName.Eyebrows,
			RenderItemTiles = true,
			UseGetInventoryV2 = true,
			CameraFocus = focusType.Face,
			CameraZoomRadius = cameraZoomRadius.Makeup.Eyebrows,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = fFlagAXCatalogMakeupSupport and not fFlagAXCatalogCategoriesSDUI and {
				CategoryKey = catalogCategories.Makeup,
				SubcategoryKey = catalogSubcategories.Eyebrows
			} or nil,
			MatchingCatalogPageIds = fFlagAXCatalogMakeupSupport and fFlagAXMigrateAllTabToSduiDev and {
				CategoryId = catalogCategoryKeys.Makeup,
				SubcategoryId = catalogSubcategoryKeys.Eyebrows
			} or nil,
			AssetTypeIdStrings = { module2.AssetTypeIdStrings.EyebrowAccessory },
			SearchUuid = searchUuid(),
			Id = avatarEditorSubcategories.Eyebrows
		}
	}

	makeup.Id = avatarEditorCategories.Makeup

	return makeup
end

local fn4 = fFlagAXCustomizeBackgrounds and function()
	local v6 = if module11() then avatarEditorCategories.Backgrounds else nil
	local backgrounds = {
		Name = "Backgrounds",
		NavigationKey = v6,
		Title = "Feature.Catalog.Label.Backgrounds",
		IconOn = iconName.Image,
		IconOff = iconName.Image,
		SearchUuid = searchUuid(),
		RenderItemTiles = true,
		UseGetInventoryV2 = true,
		Id = avatarEditorCategories.Backgrounds,
		AssetTypeIdStrings = fFlagAXBackgroundsCustomizeHydration and { module2.AssetTypeIdStrings.AvatarBackground } or nil,
		RecommendationsType = 0,
		MatchingCatalogPage = 0
	}

	local v7 = if fFlagAXBackgroundsYouMayAlsoLike then recommendationsType.Asset else nil
	backgrounds.RecommendationsType = v7

	backgrounds.MatchingCatalogPage = fFlagAXBackgroundsYouMayAlsoLike
		and { CategoryKey = catalogCategories.Backgrounds }
		or nil

	return backgrounds
end or nil

local function fn5()
	local v6 = if module11() then avatarEditorCategories.Accessories else nil
	local accessories = {
		Name = "Accessories",
		NavigationKey = v6,
		Title = "Feature.Catalog.LabelAccessories",
		IconOn = "icons/menu/clothing/accessories_on",
		IconOff = "icons/menu/clothing/accessories_off",
		SearchUuid = searchUuid(),
		HideTextUnderTile = true,
		CanAnimateCameraBasedMood = true,
		Subcategories = 0,
		Id = 0
	}
	local v7

	if module11() then
		v7 = { nil, nil, nil, nil, nil, nil, nil, nil }
		local hats = {
			Name = "Hats",
			NavigationKey = avatarEditorSubcategories.Hats,
			Title = "Feature.Avatar.Label.Head",
			IconOn = "icons/menu/clothing/hats_on",
			IconOff = "icons/menu/clothing/hats_off",
			RenderItemTiles = true,
			CameraFocus = focusType.Head,
			CameraZoomRadius = cameraZoomRadius.AvatarEditorAccessories.Hats,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
				CategoryKey = catalogCategories.Accessories,
				SubcategoryKey = catalogSubcategories.Hats
			} or nil,
			MatchingCatalogPageIds = 0,
			AssetTypeIdStrings = 0,
			SearchUuid = 0,
			Id = 0
		}

		local v8 = if fFlagAXMigrateAllTabToSduiDev then {
			CategoryId = catalogCategoryKeys.Accessories,
			SubcategoryId = catalogSubcategoryKeys.Hats
		} else fFlagAXCatalogCategoriesSDUI and {
			CategoryId = catalogSDUICategoryIds.Accessories:rawValue(),
			SubcategoryId = catalogSDUICategoryIds.Accessories_Heads:rawValue()
		} or nil
		hats.MatchingCatalogPageIds = v8

		hats.AssetTypeIdStrings = { module2.AssetTypeIdStrings.Hat }
		hats.SearchUuid = searchUuid()
		hats.Id = avatarEditorSubcategories.Hats
		v7[1] = hats

		local face = {
			Name = "Face",
			NavigationKey = avatarEditorSubcategories.Face,
			Title = "Feature.Avatar.Label.Face",
			IconOn = "icons/menu/clothing/face_on",
			IconOff = "icons/menu/clothing/face_off",
			RenderItemTiles = true,
			CameraFocus = focusType.Face,
			CameraZoomRadius = cameraZoomRadius.AvatarEditorAccessories.Face,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
				CategoryKey = catalogCategories.Accessories,
				SubcategoryKey = catalogSubcategories.Face
			} or nil,
			MatchingCatalogPageIds = 0,
			AssetTypeIdStrings = 0,
			SearchUuid = 0,
			Id = 0
		}

		local v9 = if fFlagAXMigrateAllTabToSduiDev then {
			CategoryId = catalogCategoryKeys.Accessories,
			SubcategoryId = catalogSubcategoryKeys.Face
		} else fFlagAXCatalogCategoriesSDUI and {
			CategoryId = catalogSDUICategoryIds.Accessories:rawValue(),
			SubcategoryId = catalogSDUICategoryIds.Accessories_Face:rawValue()
		} or nil
		face.MatchingCatalogPageIds = v9

		face.AssetTypeIdStrings = { module2.AssetTypeIdStrings.FaceAccessory }
		face.SearchUuid = searchUuid()
		face.Id = avatarEditorSubcategories.Face
		v7[2] = face

		local neck = {
			Name = "Neck",
			NavigationKey = avatarEditorSubcategories.Neck,
			Title = "Feature.Avatar.Label.Neck",
			IconOn = "icons/menu/clothing/neck_on",
			IconOff = "icons/menu/clothing/neck_off",
			RenderItemTiles = true,
			CameraFocus = focusType.Neck,
			CameraZoomRadius = cameraZoomRadius.AvatarEditorAccessories.Neck,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
				CategoryKey = catalogCategories.Accessories,
				SubcategoryKey = catalogSubcategories.Neck
			} or nil,
			MatchingCatalogPageIds = 0,
			AssetTypeIdStrings = 0,
			SearchUuid = 0,
			Id = 0
		}

		local v10 = if fFlagAXMigrateAllTabToSduiDev then {
			CategoryId = catalogCategoryKeys.Accessories,
			SubcategoryId = catalogSubcategoryKeys.Neck
		} else fFlagAXCatalogCategoriesSDUI and {
			CategoryId = catalogSDUICategoryIds.Accessories:rawValue(),
			SubcategoryId = catalogSDUICategoryIds.Accessories_Neck:rawValue()
		} or nil
		neck.MatchingCatalogPageIds = v10

		neck.AssetTypeIdStrings = { module2.AssetTypeIdStrings.NeckAccessory }
		neck.SearchUuid = searchUuid()
		neck.Id = avatarEditorSubcategories.Neck
		v7[3] = neck

		local back = {
			Name = "Back",
			NavigationKey = avatarEditorSubcategories.Back,
			Title = "Feature.Avatar.Label.Back",
			IconOn = "icons/menu/clothing/back_on",
			IconOff = "icons/menu/clothing/back_off",
			RenderItemTiles = true,
			CameraFocus = focusType.Arms,
			CameraZoomRadius = cameraZoomRadius.AvatarEditorAccessories.Back,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
				CategoryKey = catalogCategories.Accessories,
				SubcategoryKey = catalogSubcategories.Back
			} or nil,
			MatchingCatalogPageIds = 0,
			AssetTypeIdStrings = 0,
			SearchUuid = 0,
			Id = 0
		}

		local v11 = if fFlagAXMigrateAllTabToSduiDev then {
			CategoryId = catalogCategoryKeys.Accessories,
			SubcategoryId = catalogSubcategoryKeys.Back
		} else fFlagAXCatalogCategoriesSDUI and {
			CategoryId = catalogSDUICategoryIds.Accessories:rawValue(),
			SubcategoryId = catalogSDUICategoryIds.Accessories_Back:rawValue()
		} or nil
		back.MatchingCatalogPageIds = v11

		back.AssetTypeIdStrings = { module2.AssetTypeIdStrings.BackAccessory }
		back.SearchUuid = searchUuid()
		back.Id = avatarEditorSubcategories.Back
		v7[4] = back

		local waist = {
			Name = "Waist",
			NavigationKey = avatarEditorSubcategories.Waist,
			Title = "Feature.Avatar.Label.Waist",
			IconOn = "icons/menu/clothing/waist_on",
			IconOff = "icons/menu/clothing/waist_off",
			RenderItemTiles = true,
			CameraFocus = focusType.Waist,
			CameraZoomRadius = cameraZoomRadius.AvatarEditorAccessories.Waist,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
				CategoryKey = catalogCategories.Accessories,
				SubcategoryKey = catalogSubcategories.Waist
			} or nil,
			MatchingCatalogPageIds = 0,
			AssetTypeIdStrings = 0,
			SearchUuid = 0,
			Id = 0
		}

		local v12 = if fFlagAXMigrateAllTabToSduiDev then {
			CategoryId = catalogCategoryKeys.Accessories,
			SubcategoryId = catalogSubcategoryKeys.Waist
		} else fFlagAXCatalogCategoriesSDUI and {
			CategoryId = catalogSDUICategoryIds.Accessories:rawValue(),
			SubcategoryId = catalogSDUICategoryIds.Accessories_Waist:rawValue()
		} or nil
		waist.MatchingCatalogPageIds = v12

		waist.AssetTypeIdStrings = { module2.AssetTypeIdStrings.WaistAccessory }
		waist.SearchUuid = searchUuid()
		waist.Id = avatarEditorSubcategories.Waist
		v7[5] = waist

		local shoulder = {
			Name = "Shoulder",
			NavigationKey = avatarEditorSubcategories.Shoulder,
			Title = "Feature.Avatar.Label.Shoulder",
			IconOn = "icons/menu/clothing/shoulder_on",
			IconOff = "icons/menu/clothing/shoulder_off",
			RenderItemTiles = true,
			CameraFocus = focusType.Shoulders,
			CameraZoomRadius = cameraZoomRadius.AvatarEditorAccessories.Shoulder,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
				CategoryKey = catalogCategories.Accessories,
				SubcategoryKey = catalogSubcategories.Shoulder
			} or nil,
			MatchingCatalogPageIds = 0,
			AssetTypeIdStrings = 0,
			SearchUuid = 0,
			Id = 0
		}

		local v13 = if fFlagAXMigrateAllTabToSduiDev then {
			CategoryId = catalogCategoryKeys.Accessories,
			SubcategoryId = catalogSubcategoryKeys.Shoulder
		} else fFlagAXCatalogCategoriesSDUI and {
			CategoryId = catalogSDUICategoryIds.Accessories:rawValue(),
			SubcategoryId = catalogSDUICategoryIds.Accessories_Shoulder:rawValue()
		} or nil
		shoulder.MatchingCatalogPageIds = v13

		shoulder.AssetTypeIdStrings = { module2.AssetTypeIdStrings.ShoulderAccessory }
		shoulder.SearchUuid = searchUuid()
		shoulder.Id = avatarEditorSubcategories.Shoulder
		v7[6] = shoulder

		local front = {
			Name = "Front",
			NavigationKey = avatarEditorSubcategories.Front,
			Title = "Feature.Avatar.Label.Front",
			IconOn = "icons/menu/clothing/front_on",
			IconOff = "icons/menu/clothing/front_off",
			RenderItemTiles = true,
			CameraFocus = focusType.Arms,
			CameraZoomRadius = cameraZoomRadius.AvatarEditorAccessories.Front,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
				CategoryKey = catalogCategories.Accessories,
				SubcategoryKey = catalogSubcategories.Front
			} or nil,
			MatchingCatalogPageIds = 0,
			AssetTypeIdStrings = 0,
			SearchUuid = 0,
			Id = 0
		}

		local v14 = if fFlagAXMigrateAllTabToSduiDev then {
			CategoryId = catalogCategoryKeys.Accessories,
			SubcategoryId = catalogSubcategoryKeys.Front
		} else fFlagAXCatalogCategoriesSDUI and {
			CategoryId = catalogSDUICategoryIds.Accessories:rawValue(),
			SubcategoryId = catalogSDUICategoryIds.Accessories_Front:rawValue()
		} or nil
		front.MatchingCatalogPageIds = v14

		front.AssetTypeIdStrings = { module2.AssetTypeIdStrings.FrontAccessory }
		front.SearchUuid = searchUuid()
		front.Id = avatarEditorSubcategories.Front
		v7[7] = front

		local gear = {
			Name = "Gear",
			NavigationKey = avatarEditorSubcategories.Gear,
			Title = "Feature.Avatar.Label.Gear",
			IconOn = "icons/menu/clothing/gear_on",
			IconOff = "icons/menu/clothing/gear_off",
			RenderItemTiles = true,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
				CategoryKey = catalogCategories.Accessories,
				SubcategoryKey = catalogSubcategories.Gear
			} or nil,
			MatchingCatalogPageIds = 0,
			AssetTypeIdStrings = 0,
			SearchUuid = 0,
			Id = 0
		}

		local v15 = if fFlagAXMigrateAllTabToSduiDev then {
			CategoryId = catalogCategoryKeys.Accessories,
			SubcategoryId = catalogSubcategoryKeys.Gear
		} else fFlagAXCatalogCategoriesSDUI and {
			CategoryId = catalogSDUICategoryIds.Accessories:rawValue(),
			SubcategoryId = catalogSDUICategoryIds.Accessories_Gear:rawValue()
		} or nil
		gear.MatchingCatalogPageIds = v15

		gear.AssetTypeIdStrings = { module2.AssetTypeIdStrings.Gear }
		gear.SearchUuid = searchUuid()
		gear.Id = avatarEditorSubcategories.Gear
		v7[8] = gear
	else
		v7 = { nil, nil, nil, nil, nil, nil, nil, nil }
		local hats = {
			Name = "Hats",
			NavigationKey = avatarEditorSubcategories.Hats,
			Title = "Feature.Avatar.Label.Head",
			IconOn = "icons/menu/clothing/hats_on",
			IconOff = "icons/menu/clothing/hats_off",
			RenderItemTiles = true,
			CameraFocus = focusType.Head,
			CameraZoomRadius = cameraZoomRadius.AvatarEditorAccessories.Hats,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
				CategoryKey = catalogCategories.Accessories,
				SubcategoryKey = catalogSubcategories.Hats
			} or nil,
			MatchingCatalogPageIds = 0,
			AssetTypeIdStrings = 0,
			SearchUuid = 0,
			Id = 0
		}

		local v8 = if fFlagAXMigrateAllTabToSduiDev then {
			CategoryId = catalogCategoryKeys.Accessories,
			SubcategoryId = catalogSubcategoryKeys.Hats
		} else fFlagAXCatalogCategoriesSDUI and {
			CategoryId = catalogSDUICategoryIds.Accessories:rawValue(),
			SubcategoryId = catalogSDUICategoryIds.Accessories_Heads:rawValue()
		} or nil
		hats.MatchingCatalogPageIds = v8

		hats.AssetTypeIdStrings = { module2.AssetTypeIdStrings.Hat }
		hats.SearchUuid = searchUuid()
		hats.Id = avatarEditorSubcategories.Hats
		v7[1] = hats

		local face = {
			Name = "Face",
			NavigationKey = avatarEditorSubcategories.Face,
			Title = "Feature.Avatar.Label.Face",
			IconOn = "icons/menu/clothing/face_on",
			IconOff = "icons/menu/clothing/face_off",
			RenderItemTiles = true,
			CameraFocus = focusType.Face,
			CameraZoomRadius = cameraZoomRadius.AvatarEditorAccessories.Face,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
				CategoryKey = catalogCategories.Accessories,
				SubcategoryKey = catalogSubcategories.Face
			} or nil,
			MatchingCatalogPageIds = 0,
			AssetTypeIdStrings = 0,
			SearchUuid = 0,
			Id = 0
		}

		local v9 = if fFlagAXMigrateAllTabToSduiDev then {
			CategoryId = catalogCategoryKeys.Accessories,
			SubcategoryId = catalogSubcategoryKeys.Face
		} else fFlagAXCatalogCategoriesSDUI and {
			CategoryId = catalogSDUICategoryIds.Accessories:rawValue(),
			SubcategoryId = catalogSDUICategoryIds.Accessories_Face:rawValue()
		} or nil
		face.MatchingCatalogPageIds = v9

		face.AssetTypeIdStrings = { module2.AssetTypeIdStrings.FaceAccessory }
		face.SearchUuid = searchUuid()
		face.Id = avatarEditorSubcategories.Face
		v7[2] = face

		local neck = {
			Name = "Neck",
			NavigationKey = avatarEditorSubcategories.Neck,
			Title = "Feature.Avatar.Label.Neck",
			IconOn = "icons/menu/clothing/neck_on",
			IconOff = "icons/menu/clothing/neck_off",
			RenderItemTiles = true,
			CameraFocus = focusType.Neck,
			CameraZoomRadius = cameraZoomRadius.AvatarEditorAccessories.Neck,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
				CategoryKey = catalogCategories.Accessories,
				SubcategoryKey = catalogSubcategories.Neck
			} or nil,
			MatchingCatalogPageIds = 0,
			AssetTypeIdStrings = 0,
			SearchUuid = 0,
			Id = 0
		}

		local v10 = if fFlagAXMigrateAllTabToSduiDev then {
			CategoryId = catalogCategoryKeys.Accessories,
			SubcategoryId = catalogSubcategoryKeys.Neck
		} else fFlagAXCatalogCategoriesSDUI and {
			CategoryId = catalogSDUICategoryIds.Accessories:rawValue(),
			SubcategoryId = catalogSDUICategoryIds.Accessories_Neck:rawValue()
		} or nil
		neck.MatchingCatalogPageIds = v10

		neck.AssetTypeIdStrings = { module2.AssetTypeIdStrings.NeckAccessory }
		neck.SearchUuid = searchUuid()
		neck.Id = avatarEditorSubcategories.Neck
		v7[3] = neck

		local shoulder = {
			Name = "Shoulder",
			NavigationKey = avatarEditorSubcategories.Shoulder,
			Title = "Feature.Avatar.Label.Shoulder",
			IconOn = "icons/menu/clothing/shoulder_on",
			IconOff = "icons/menu/clothing/shoulder_off",
			RenderItemTiles = true,
			CameraFocus = focusType.Shoulders,
			CameraZoomRadius = cameraZoomRadius.AvatarEditorAccessories.Shoulder,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
				CategoryKey = catalogCategories.Accessories,
				SubcategoryKey = catalogSubcategories.Shoulder
			} or nil,
			MatchingCatalogPageIds = 0,
			AssetTypeIdStrings = 0,
			SearchUuid = 0,
			Id = 0
		}

		local v11 = if fFlagAXMigrateAllTabToSduiDev then {
			CategoryId = catalogCategoryKeys.Accessories,
			SubcategoryId = catalogSubcategoryKeys.Shoulder
		} else fFlagAXCatalogCategoriesSDUI and {
			CategoryId = catalogSDUICategoryIds.Accessories:rawValue(),
			SubcategoryId = catalogSDUICategoryIds.Accessories_Shoulder:rawValue()
		} or nil
		shoulder.MatchingCatalogPageIds = v11

		shoulder.AssetTypeIdStrings = { module2.AssetTypeIdStrings.ShoulderAccessory }
		shoulder.SearchUuid = searchUuid()
		shoulder.Id = avatarEditorSubcategories.Shoulder
		v7[4] = shoulder

		local front = {
			Name = "Front",
			NavigationKey = avatarEditorSubcategories.Front,
			Title = "Feature.Avatar.Label.Front",
			IconOn = "icons/menu/clothing/front_on",
			IconOff = "icons/menu/clothing/front_off",
			RenderItemTiles = true,
			CameraFocus = focusType.Arms,
			CameraZoomRadius = cameraZoomRadius.AvatarEditorAccessories.Front,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
				CategoryKey = catalogCategories.Accessories,
				SubcategoryKey = catalogSubcategories.Front
			} or nil,
			MatchingCatalogPageIds = 0,
			AssetTypeIdStrings = 0,
			SearchUuid = 0,
			Id = 0
		}

		local v12 = if fFlagAXMigrateAllTabToSduiDev then {
			CategoryId = catalogCategoryKeys.Accessories,
			SubcategoryId = catalogSubcategoryKeys.Front
		} else fFlagAXCatalogCategoriesSDUI and {
			CategoryId = catalogSDUICategoryIds.Accessories:rawValue(),
			SubcategoryId = catalogSDUICategoryIds.Accessories_Front:rawValue()
		} or nil
		front.MatchingCatalogPageIds = v12

		front.AssetTypeIdStrings = { module2.AssetTypeIdStrings.FrontAccessory }
		front.SearchUuid = searchUuid()
		front.Id = avatarEditorSubcategories.Front
		v7[5] = front

		local back = {
			Name = "Back",
			NavigationKey = avatarEditorSubcategories.Back,
			Title = "Feature.Avatar.Label.Back",
			IconOn = "icons/menu/clothing/back_on",
			IconOff = "icons/menu/clothing/back_off",
			RenderItemTiles = true,
			CameraFocus = focusType.Arms,
			CameraZoomRadius = cameraZoomRadius.AvatarEditorAccessories.Back,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
				CategoryKey = catalogCategories.Accessories,
				SubcategoryKey = catalogSubcategories.Back
			} or nil,
			MatchingCatalogPageIds = 0,
			AssetTypeIdStrings = 0,
			SearchUuid = 0,
			Id = 0
		}

		local v13 = if fFlagAXMigrateAllTabToSduiDev then {
			CategoryId = catalogCategoryKeys.Accessories,
			SubcategoryId = catalogSubcategoryKeys.Back
		} else fFlagAXCatalogCategoriesSDUI and {
			CategoryId = catalogSDUICategoryIds.Accessories:rawValue(),
			SubcategoryId = catalogSDUICategoryIds.Accessories_Back:rawValue()
		} or nil
		back.MatchingCatalogPageIds = v13

		back.AssetTypeIdStrings = { module2.AssetTypeIdStrings.BackAccessory }
		back.SearchUuid = searchUuid()
		back.Id = avatarEditorSubcategories.Back
		v7[6] = back

		local waist = {
			Name = "Waist",
			NavigationKey = avatarEditorSubcategories.Waist,
			Title = "Feature.Avatar.Label.Waist",
			IconOn = "icons/menu/clothing/waist_on",
			IconOff = "icons/menu/clothing/waist_off",
			RenderItemTiles = true,
			CameraFocus = focusType.Waist,
			CameraZoomRadius = cameraZoomRadius.AvatarEditorAccessories.Waist,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
				CategoryKey = catalogCategories.Accessories,
				SubcategoryKey = catalogSubcategories.Waist
			} or nil,
			MatchingCatalogPageIds = 0,
			AssetTypeIdStrings = 0,
			SearchUuid = 0,
			Id = 0
		}

		local v14 = if fFlagAXMigrateAllTabToSduiDev then {
			CategoryId = catalogCategoryKeys.Accessories,
			SubcategoryId = catalogSubcategoryKeys.Waist
		} else fFlagAXCatalogCategoriesSDUI and {
			CategoryId = catalogSDUICategoryIds.Accessories:rawValue(),
			SubcategoryId = catalogSDUICategoryIds.Accessories_Waist:rawValue()
		} or nil
		waist.MatchingCatalogPageIds = v14

		waist.AssetTypeIdStrings = { module2.AssetTypeIdStrings.WaistAccessory }
		waist.SearchUuid = searchUuid()
		waist.Id = avatarEditorSubcategories.Waist
		v7[7] = waist

		local gear = {
			Name = "Gear",
			NavigationKey = avatarEditorSubcategories.Gear,
			Title = "Feature.Avatar.Label.Gear",
			IconOn = "icons/menu/clothing/gear_on",
			IconOff = "icons/menu/clothing/gear_off",
			RenderItemTiles = true,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
				CategoryKey = catalogCategories.Accessories,
				SubcategoryKey = catalogSubcategories.Gear
			} or nil,
			MatchingCatalogPageIds = 0,
			AssetTypeIdStrings = 0,
			SearchUuid = 0,
			Id = 0
		}

		local v15 = if fFlagAXMigrateAllTabToSduiDev then {
			CategoryId = catalogCategoryKeys.Accessories,
			SubcategoryId = catalogSubcategoryKeys.Gear
		} else fFlagAXCatalogCategoriesSDUI and {
			CategoryId = catalogSDUICategoryIds.Accessories:rawValue(),
			SubcategoryId = catalogSDUICategoryIds.Accessories_Gear:rawValue()
		} or nil
		gear.MatchingCatalogPageIds = v15

		gear.AssetTypeIdStrings = { module2.AssetTypeIdStrings.Gear }
		gear.SearchUuid = searchUuid()
		gear.Id = avatarEditorSubcategories.Gear
		v7[8] = gear
	end

	accessories.Subcategories = v7

	accessories.Id = avatarEditorCategories.Accessories

	return accessories
end

local function fn6()
	local v6

	if axAvatarsTabIXP.isEnabled() then
		v6 = module9.readTestVariable(axAvatarsTabIXP.EnabledForUser)
	end

	local v7 = {
		Name = module3.CharacterKey,
		NavigationKey = 0,
		Title = "Feature.Catalog.Label.Avatars",
		IconOn = "icons/menu/clothing/avatars_on",
		IconOff = "icons/menu/clothing/avatars_off",
		SearchUuid = 0,
		PageType = 0,
		Id = 0,
		RecommendationsType = 0,
		RecommendationWidgetContext = 0,
		ShowName = 0,
		AssetTypeIdStrings = 0,
		BundleTypeIdStrings = 0,
		InventoryOutfitTypes = 0,
		MatchingCatalogPage = 0,
		MatchingCatalogPageIds = 0,
		hideFilter = true
	}
	local v8 = if module11() then avatarEditorCategories.Avatars else nil
	v7.NavigationKey = v8

	local v9 = if fFlagAXMigrateOutfitsToUserInventory then avatarEditorCategories.Avatars else searchUuid()
	v7.SearchUuid = v9

	v7.PageType = module2.PageType.Avatars
	v7.Id = avatarEditorCategories.Avatars
	local v10

	if fFlagAXAvatarTabWidgetRecommendation then
		v10 = recommendationsType.Widget
	elseif module11() then
		if fFlagAXAvatarTabLooksYouMayAlsoLike then
			v10 = recommendationsType.AvatarLooks
		else
			v10 = recommendationsType.BodyParts
		end
	else
		v10 = recommendationsType.All
	end

	v7.RecommendationsType = v10

	v7.RecommendationWidgetContext = fFlagAXAvatarTabWidgetRecommendation and "editor-tab:avatars" or nil
	v7.ShowName = module11() and true or nil
	v7.AssetTypeIdStrings = { module2.AssetTypeIdStrings.AvatarOutfit }
	v7.BundleTypeIdStrings = fFlagAXInventoryDurablesSupport and { module2.BundleTypeIdStrings.Avatars }
		or nil

	v7.InventoryOutfitTypes = fFlagAXMigrateOutfitsToUserInventory and { inventoryOutfitType.Avatar } or nil
	local v11

	if not (fFlagAXCatalogCategoriesSDUI or not module11()) then
		if defineFastFlag then
			v11 = { CategoryKey = 0 }

			local v12 = if v6 then catalogCategories.Avatars else catalogCategories.Characters
			v11.CategoryKey = v12
		else
			v11 = {
				CategoryKey = catalogCategories.Body,
				SubcategoryKey = catalogSubcategories.FullBodies
			}
		end
	end

	v7.MatchingCatalogPage = v11
	local v12

	if module11() then
		if defineFastFlag then
			if fFlagAXMigrateAllTabToSduiDev then
				v12 = { CategoryId = 0 }

				local v13 = if v6 then catalogCategoryKeys.Avatars else catalogCategoryKeys.Characters
				v12.CategoryId = v13
			elseif fFlagAXCatalogCategoriesSDUI then
				v12 = { CategoryId = 0 }

				local v13 = if v6 then catalogSDUICategoryIds.Avatars:rawValue() else catalogSDUICategoryIds.Characters:rawValue()
				v12.CategoryId = v13
			end
		elseif fFlagAXMigrateAllTabToSduiDev then
			v12 = {
				CategoryId = catalogCategoryKeys.Body,
				SubcategoryId = catalogSubcategoryKeys.FullBodies
			}
		else
			v12 = fFlagAXCatalogCategoriesSDUI
				and {
					CategoryId = catalogSDUICategoryIds.Body:rawValue(),
					SubcategoryId = catalogSDUICategoryIds.Body_FullBodies:rawValue()
				}
				or nil
		end
	end

	v7.MatchingCatalogPageIds = v12

	return v7
end

local function fn7()
	local v6 = {
		CategoryKey = catalogCategories.AllAnimations,
		SubcategoryKey = catalogSubcategories.AnimationBundles
	}
	local v7

	if fFlagAXMigrateAllTabToSduiDev then
		v7 = {
			CategoryId = catalogCategoryKeys.AllAnimations,
			SubcategoryId = catalogSubcategoryKeys.AnimationBundles
		}
	else
		v7 = fFlagAXCatalogCategoriesSDUI
			and {
				CategoryId = catalogSDUICategoryIds.AllAnimations:rawValue(),
				SubcategoryId = catalogSDUICategoryIds.AnimationBundles:rawValue()
			}
			or nil
	end

	if module11() then
		local animation = {
			Id = avatarEditorCategories.Animations,
			Name = "Animation",
			NavigationKey = 0,
			Title = "Feature.Avatar.Heading.Animations",
			IconOn = "icons/menu/clothing/animation_on",
			IconOff = "icons/menu/clothing/animation_off",
			SearchUuid = 0,
			CameraZoomRadius = 0,
			PageType = 0,
			CanAnimateCameraBasedMood = true,
			ShowName = 0,
			Subcategories = 0
		}

		local v8 = if module11() then avatarEditorCategories.Animations else nil
		animation.NavigationKey = v8

		animation.SearchUuid = searchUuid()

		animation.CameraZoomRadius = animationCategoryCameraZoomRadius
		animation.PageType = module2.PageType.Animation

		animation.ShowName = module11() and true or nil

		local animationFullSets = {
			Name = "Animation Full Sets",
			NavigationKey = avatarEditorSubcategories.AnimationFullSets,
			Title = "Feature.Avatar.Label.AnimationFullSet",
			IconOn = "icons/menu/clothing/animation_on",
			IconOff = "icons/menu/clothing/animation_off",
			EmptyString = "Feature.Avatar.Heading.Animations",
			RenderItemTiles = true,
			RenderOutfitItemTiles = true,
			RecommendationsType = recommendationsType.AvatarAnimations,
			MatchingCatalogPage = if not fFlagAXCatalogCategoriesSDUI then v6 else nil,
			MatchingCatalogPageIds = v7,
			BundleTypeIdStrings = { module2.BundleTypeIdStrings.Animations },
			InventoryOutfitTypes = fFlagAXMigrateOutfitsToUserInventory and { inventoryOutfitType.Animations } or nil,
			SearchUuid = searchUuid(),
			Id = avatarEditorSubcategories.AnimationFullSets
		}

		local idleAnimations = {
			Name = "Idle Animations",
			NavigationKey = avatarEditorSubcategories.IdleAnimations,
			Title = "Feature.Avatar.Label.Idle",
			IconOn = "icons/menu/clothing/idle_on",
			IconOff = "icons/menu/clothing/idle_off",
			EmptyString = "Feature.Avatar.Label.IdleAnimations",
			RenderItemTiles = true,
			RecommendationsType = recommendationsType.AvatarAnimations,
			MatchingCatalogPage = if not fFlagAXCatalogCategoriesSDUI then v6 else nil,
			MatchingCatalogPageIds = v7,
			AssetTypeIdStrings = { module2.AssetTypeIdStrings.IdleAnimation },
			SearchUuid = searchUuid(),
			Id = avatarEditorSubcategories.IdleAnimations
		}

		local walkAnimations = {
			Name = "Walk Animations",
			NavigationKey = avatarEditorSubcategories.WalkAnimations,
			Title = "Feature.Avatar.Label.Walk",
			IconOn = "icons/menu/clothing/walk_on",
			IconOff = "icons/menu/clothing/walk_off",
			EmptyString = "Feature.Avatar.Label.WalkAnimations",
			RenderItemTiles = true,
			RecommendationsType = recommendationsType.AvatarAnimations,
			MatchingCatalogPage = if not fFlagAXCatalogCategoriesSDUI then v6 else nil,
			MatchingCatalogPageIds = v7,
			AssetTypeIdStrings = { module2.AssetTypeIdStrings.WalkAnimation },
			SearchUuid = searchUuid(),
			Id = avatarEditorSubcategories.WalkAnimations
		}

		local runAnimations = {
			Name = "Run Animations",
			NavigationKey = avatarEditorSubcategories.RunAnimations,
			Title = "Feature.Avatar.Label.Run",
			IconOn = "icons/menu/clothing/animation_on",
			IconOff = "icons/menu/clothing/animation_off",
			EmptyString = "Feature.Avatar.Label.RunAnimations",
			RenderItemTiles = true,
			RecommendationsType = recommendationsType.AvatarAnimations,
			MatchingCatalogPage = if not fFlagAXCatalogCategoriesSDUI then v6 else nil,
			MatchingCatalogPageIds = v7,
			AssetTypeIdStrings = { module2.AssetTypeIdStrings.RunAnimation },
			SearchUuid = searchUuid(),
			Id = avatarEditorSubcategories.RunAnimations
		}

		local jumpAnimations = {
			Name = "Jump Animations",
			NavigationKey = avatarEditorSubcategories.JumpAnimations,
			Title = "Feature.Avatar.Label.Jump",
			IconOn = "icons/menu/clothing/jump_on",
			IconOff = "icons/menu/clothing/jump_off",
			EmptyString = "Feature.Avatar.Label.JumpAnimations",
			RenderItemTiles = true,
			RecommendationsType = recommendationsType.AvatarAnimations,
			MatchingCatalogPage = if not fFlagAXCatalogCategoriesSDUI then v6 else nil,
			MatchingCatalogPageIds = v7,
			AssetTypeIdStrings = { module2.AssetTypeIdStrings.JumpAnimation },
			SearchUuid = searchUuid(),
			Id = avatarEditorSubcategories.JumpAnimations
		}

		local fallAnimations = {
			Name = "Fall Animations",
			NavigationKey = avatarEditorSubcategories.FallAnimations,
			Title = "Feature.Avatar.Label.Fall",
			IconOn = "icons/menu/clothing/fall_on",
			IconOff = "icons/menu/clothing/fall_off",
			EmptyString = "Feature.Avatar.Label.FallAnimations",
			RenderItemTiles = true,
			RecommendationsType = recommendationsType.AvatarAnimations,
			MatchingCatalogPage = if not fFlagAXCatalogCategoriesSDUI then v6 else nil,
			MatchingCatalogPageIds = v7,
			AssetTypeIdStrings = { module2.AssetTypeIdStrings.FallAnimation },
			SearchUuid = searchUuid(),
			Id = avatarEditorSubcategories.FallAnimations
		}

		local climbAnimations = {
			Name = "Climb Animations",
			NavigationKey = avatarEditorSubcategories.ClimbAnimations,
			Title = "Feature.Avatar.Label.Climb",
			IconOn = "icons/menu/clothing/climb_on",
			IconOff = "icons/menu/clothing/climb_off",
			EmptyString = "Feature.Avatar.Label.ClimbAnimations",
			RenderItemTiles = true,
			RecommendationsType = recommendationsType.AvatarAnimations,
			MatchingCatalogPage = if not fFlagAXCatalogCategoriesSDUI then v6 else nil,
			MatchingCatalogPageIds = v7,
			AssetTypeIdStrings = { module2.AssetTypeIdStrings.ClimbAnimation },
			SearchUuid = searchUuid(),
			Id = avatarEditorSubcategories.ClimbAnimations
		}

		local swimAnimations = {
			Name = "Swim Animations",
			NavigationKey = avatarEditorSubcategories.SwimAnimations,
			Title = "Feature.Avatar.Label.Swim",
			IconOn = "icons/menu/clothing/swim_on",
			IconOff = "icons/menu/clothing/swim_off",
			EmptyString = "Feature.Avatar.Label.SwimAnimations",
			RenderItemTiles = true,
			RecommendationsType = recommendationsType.AvatarAnimations,
			MatchingCatalogPage = 0,
			MatchingCatalogPageIds = 0,
			AssetTypeIdStrings = 0,
			SearchUuid = 0,
			Id = 0
		}

		if fFlagAXCatalogCategoriesSDUI then
			v6 = nil
		end

		swimAnimations.MatchingCatalogPage = v6
		swimAnimations.MatchingCatalogPageIds = v7

		swimAnimations.AssetTypeIdStrings = { module2.AssetTypeIdStrings.SwimAnimation }
		swimAnimations.SearchUuid = searchUuid()
		swimAnimations.Id = avatarEditorSubcategories.SwimAnimations
		animation.Subcategories = {
			animationFullSets,
			idleAnimations,
			walkAnimations,
			runAnimations,
			jumpAnimations,
			fallAnimations,
			climbAnimations,
			swimAnimations
		}
		return animation
	else
		local animation = {
			Id = avatarEditorCategories.Animation,
			Name = "Animation",
			NavigationKey = 0,
			Title = "Feature.Catalog.Label.Animation",
			IconOn = "icons/menu/clothing/animation_on",
			IconOff = "icons/menu/clothing/animation_off",
			SearchUuid = 0,
			CameraZoomRadius = 0,
			PageType = 0,
			CanAnimateCameraBasedMood = true,
			Subcategories = 0
		}

		local v8 = if module11() then avatarEditorCategories.Animation else nil
		animation.NavigationKey = v8

		animation.SearchUuid = searchUuid()

		animation.CameraZoomRadius = animationCategoryCameraZoomRadius
		animation.PageType = module2.PageType.Animation

		local v9 = {
			{
				Name = "Idle Animations",
				NavigationKey = avatarEditorSubcategories.IdleAnimations,
				Title = "Feature.Avatar.Label.Idle",
				IconOn = "icons/menu/clothing/idle_on",
				IconOff = "icons/menu/clothing/idle_off",
				EmptyString = "Feature.Avatar.Label.IdleAnimations",
				RenderItemTiles = true,
				RecommendationsType = recommendationsType.AvatarAnimations,
				MatchingCatalogPage = if not fFlagAXCatalogCategoriesSDUI then v6 else nil,
				MatchingCatalogPageIds = v7,
				AssetTypeIdStrings = { module2.AssetTypeIdStrings.IdleAnimation },
				SearchUuid = searchUuid(),
				Id = avatarEditorSubcategories.IdleAnimations
			},
			{
				Name = "Walk Animations",
				NavigationKey = avatarEditorSubcategories.WalkAnimations,
				Title = "Feature.Avatar.Label.Walk",
				IconOn = "icons/menu/clothing/walk_on",
				IconOff = "icons/menu/clothing/walk_off",
				EmptyString = "Feature.Avatar.Label.WalkAnimations",
				RenderItemTiles = true,
				RecommendationsType = recommendationsType.AvatarAnimations,
				MatchingCatalogPage = if not fFlagAXCatalogCategoriesSDUI then v6 else nil,
				MatchingCatalogPageIds = v7,
				AssetTypeIdStrings = { module2.AssetTypeIdStrings.WalkAnimation },
				SearchUuid = searchUuid(),
				Id = avatarEditorSubcategories.WalkAnimations
			},
			nil,
			nil,
			nil,
			nil,
			nil
		}

		local runAnimations = {
			Name = "Run Animations",
			NavigationKey = avatarEditorSubcategories.RunAnimations,
			Title = "Feature.Avatar.Label.Run",
			IconOn = "icons/menu/clothing/animation_on",
			IconOff = "icons/menu/clothing/animation_off",
			EmptyString = "Feature.Avatar.Label.RunAnimations",
			RenderItemTiles = true,
			RecommendationsType = recommendationsType.AvatarAnimations,
			MatchingCatalogPage = if not fFlagAXCatalogCategoriesSDUI then v6 else nil,
			MatchingCatalogPageIds = v7,
			AssetTypeIdStrings = { module2.AssetTypeIdStrings.RunAnimation },
			SearchUuid = searchUuid(),
			Id = avatarEditorSubcategories.RunAnimations
		}
		v9[3] = runAnimations

		local jumpAnimations = {
			Name = "Jump Animations",
			NavigationKey = avatarEditorSubcategories.JumpAnimations,
			Title = "Feature.Avatar.Label.Jump",
			IconOn = "icons/menu/clothing/jump_on",
			IconOff = "icons/menu/clothing/jump_off",
			EmptyString = "Feature.Avatar.Label.JumpAnimations",
			RenderItemTiles = true,
			RecommendationsType = recommendationsType.AvatarAnimations,
			MatchingCatalogPage = if not fFlagAXCatalogCategoriesSDUI then v6 else nil,
			MatchingCatalogPageIds = v7,
			AssetTypeIdStrings = { module2.AssetTypeIdStrings.JumpAnimation },
			SearchUuid = searchUuid(),
			Id = avatarEditorSubcategories.JumpAnimations
		}
		v9[4] = jumpAnimations

		local fallAnimations = {
			Name = "Fall Animations",
			NavigationKey = avatarEditorSubcategories.FallAnimations,
			Title = "Feature.Avatar.Label.Fall",
			IconOn = "icons/menu/clothing/fall_on",
			IconOff = "icons/menu/clothing/fall_off",
			EmptyString = "Feature.Avatar.Label.FallAnimations",
			RenderItemTiles = true,
			RecommendationsType = recommendationsType.AvatarAnimations,
			MatchingCatalogPage = if not fFlagAXCatalogCategoriesSDUI then v6 else nil,
			MatchingCatalogPageIds = v7,
			AssetTypeIdStrings = { module2.AssetTypeIdStrings.FallAnimation },
			SearchUuid = searchUuid(),
			Id = avatarEditorSubcategories.FallAnimations
		}
		v9[5] = fallAnimations

		local climbAnimations = {
			Name = "Climb Animations",
			NavigationKey = avatarEditorSubcategories.ClimbAnimations,
			Title = "Feature.Avatar.Label.Climb",
			IconOn = "icons/menu/clothing/climb_on",
			IconOff = "icons/menu/clothing/climb_off",
			EmptyString = "Feature.Avatar.Label.ClimbAnimations",
			RenderItemTiles = true,
			RecommendationsType = recommendationsType.AvatarAnimations,
			MatchingCatalogPage = if not fFlagAXCatalogCategoriesSDUI then v6 else nil,
			MatchingCatalogPageIds = v7,
			AssetTypeIdStrings = { module2.AssetTypeIdStrings.ClimbAnimation },
			SearchUuid = searchUuid(),
			Id = avatarEditorSubcategories.ClimbAnimations
		}
		v9[6] = climbAnimations

		local swimAnimations = {
			Name = "Swim Animations",
			NavigationKey = avatarEditorSubcategories.SwimAnimations,
			Title = "Feature.Avatar.Label.Swim",
			IconOn = "icons/menu/clothing/swim_on",
			IconOff = "icons/menu/clothing/swim_off",
			EmptyString = "Feature.Avatar.Label.SwimAnimations",
			RenderItemTiles = true,
			RecommendationsType = recommendationsType.AvatarAnimations,
			MatchingCatalogPage = 0,
			MatchingCatalogPageIds = 0,
			AssetTypeIdStrings = 0,
			SearchUuid = 0,
			Id = 0
		}

		if fFlagAXCatalogCategoriesSDUI then
			v6 = nil
		end

		swimAnimations.MatchingCatalogPage = v6
		swimAnimations.MatchingCatalogPageIds = v7

		swimAnimations.AssetTypeIdStrings = { module2.AssetTypeIdStrings.SwimAnimation }
		swimAnimations.SearchUuid = searchUuid()
		swimAnimations.Id = avatarEditorSubcategories.SwimAnimations
		v9[7] = swimAnimations
		animation.Subcategories = v9

		return animation
	end
end

local function fn8()
	local v6

	if module10.isEnabled() then
		v6 = module9.readTestVariable(module10.EnableHeadCategoryCombination)
	end

	local v7

	if axAvatarsTabIXP.isEnabled() then
		v7 = module9.readTestVariable(axAvatarsTabIXP.EnabledForUser)
	end

	local v8 = fn()

	local headAndBody = {
		Name = "HeadAndBody",
		Title = "Feature.Avatar.Label.HeadBody",
		IconOn = "icons/menu/clothing/body_on",
		IconOff = "icons/menu/clothing/body_off",
		SearchUuid = searchUuid(),
		CanAnimateCameraBasedMood = true,
		Id = avatarEditorCategories.Body
	}

	local style = {
		Name = "Style",
		NavigationKey = avatarEditorSubcategories.Heads,
		Title = "Feature.Avatar.Label.Heads",
		IconOn = "icons/menu/clothing/type_on",
		IconOff = "icons/menu/clothing/type_off",
		RenderItemTiles = true,
		RenderOutfitItemTiles = true,
		UseGetInventoryV2 = module10.isEnabled() and v6 and true or nil,
		CameraFocus = focusType.Face,
		CameraZoomRadius = cameraZoomRadius.DynamicBodyCategories.Style,
		RecommendationsType = recommendationsType.DynamicHeads,
		MatchingCatalogPage = 0,
		MatchingCatalogPageIds = 0,
		OutfitType = 0,
		OutfitFilter = 0,
		AssetTypeIdStrings = 0,
		OutfitTypeIdStrings = 0,
		InventoryOutfitTypes = 0,
		SearchUuid = 0,
		Id = 0
	}
	local v9

	if not fFlagAXCatalogCategoriesSDUI then
		v9 = { CategoryKey = 0, SubcategoryKey = 0 }
		local v10 = if v7 then catalogCategories.Body else catalogCategories.Head
		v9.CategoryKey = v10
		v9.SubcategoryKey = catalogSubcategories.Heads
	end

	style.MatchingCatalogPage = v9
	local v10

	if fFlagAXMigrateAllTabToSduiDev then
		v10 = {
			CategoryId = catalogCategoryKeys.Body,
			SubcategoryId = catalogSubcategoryKeys.Heads
		}
	elseif fFlagAXCatalogCategoriesSDUI then
		v10 = { CategoryId = 0, SubcategoryId = 0 }

		local v11 = if v7 then catalogSDUICategoryIds.Body:rawValue() else catalogSDUICategoryIds.Head:rawValue()
		v10.CategoryId = v11

		v10.SubcategoryId = catalogSDUICategoryIds.Body_Heads:rawValue()
	end

	style.MatchingCatalogPageIds = v10

	style.OutfitType = module2.OutfitTypes.DynamicHead
	style.OutfitFilter = Enum.OutfitSource.Purchased

	style.AssetTypeIdStrings = module10.isEnabled()
		and v6
		and { module2.AssetTypeIdStrings.Head, module2.AssetTypeIdStrings.Face }
		or nil

	style.OutfitTypeIdStrings = module10.isEnabled()
		and v6
		and { module2.BundleTypeIdStrings.DynamicHead }
		or nil

	style.InventoryOutfitTypes = fFlagAXMigrateOutfitsToUserInventory
		and module10.isEnabled()
		and v6
		and { inventoryOutfitType.DynamicHead }
		or nil

	style.SearchUuid = searchUuid()
	style.Id = avatarEditorSubcategories.Heads

	local hair = {
		Name = "Hair",
		NavigationKey = avatarEditorSubcategories.Hair,
		Title = "Feature.Avatar.Label.Hair",
		IconOn = "icons/menu/clothing/hair_on",
		IconOff = "icons/menu/clothing/hair_off",
		RenderItemTiles = true,
		CameraFocus = focusType.Head,
		CameraZoomRadius = cameraZoomRadius.DynamicBodyCategories.Hair,
		RecommendationsType = recommendationsType.Asset,
		MatchingCatalogPage = 0,
		MatchingCatalogPageIds = 0,
		AssetTypeIdStrings = 0,
		SearchUuid = 0,
		Id = 0
	}
	local v11

	if not fFlagAXCatalogCategoriesSDUI then
		v11 = { CategoryKey = 0, SubcategoryKey = 0 }
		local v12 = if v7 then catalogCategories.Body else catalogCategories.Head
		v11.CategoryKey = v12
		v11.SubcategoryKey = catalogSubcategories.Hair
	end

	hair.MatchingCatalogPage = v11
	local v12

	if fFlagAXMigrateAllTabToSduiDev then
		v12 = {
			CategoryId = catalogCategoryKeys.Body,
			SubcategoryId = catalogSubcategoryKeys.Hair
		}
	elseif fFlagAXCatalogCategoriesSDUI then
		v12 = { CategoryId = 0, SubcategoryId = 0 }

		local v13 = if v7 then catalogSDUICategoryIds.Body:rawValue() else catalogSDUICategoryIds.Head:rawValue()
		v12.CategoryId = v13

		v12.SubcategoryId = catalogSDUICategoryIds.Body_Hair:rawValue()
	end

	hair.MatchingCatalogPageIds = v12

	hair.AssetTypeIdStrings = { module2.AssetTypeIdStrings.HairAccessory }
	hair.SearchUuid = searchUuid()
	hair.Id = avatarEditorSubcategories.Hair

	local v13 = {
		Name = "Skin",
		NavigationKey = avatarEditorSubcategories.Skin,
		Title = "Feature.Avatar.Label.Skin",
		IconOn = "icons/menu/clothing/skin_on",
		IconOff = "icons/menu/clothing/skin_off",
		RenderItemTiles = false,
		RecommendationsType = recommendationsType.None,
		PageType = module2.PageType.BodyColors,
		SearchUuid = searchUuid(),
		Id = avatarEditorSubcategories.Skin,
		hideFilter = true
	}

	local classicHeads = {
		Name = "Classic Heads",
		NavigationKey = avatarEditorSubcategories.ClassicHeads,
		Title = "Feature.Avatar.Label.ClassicHeads",
		IconOn = "icons/menu/clothing/classicHead_on",
		IconOff = "icons/menu/clothing/classicHead_off",
		RenderItemTiles = true,
		CameraFocus = focusType.Face,
		CameraZoomRadius = cameraZoomRadius.DynamicBodyCategories.ClassicHeads,
		RecommendationsType = recommendationsType.Asset,
		MatchingCatalogPage = 0,
		MatchingCatalogPageIds = 0,
		AssetTypeIdStrings = 0,
		SearchUuid = 0,
		Id = 0
	}
	local v14

	if not fFlagAXCatalogCategoriesSDUI then
		v14 = { CategoryKey = 0, SubcategoryKey = 0 }
		local v15 = if v7 then catalogCategories.Body else catalogCategories.Head
		v14.CategoryKey = v15
		local v16

		if module10.isEnabled() and v6 then
			v16 = catalogSubcategories.Heads
		elseif fFlagRemoveClassicHeadsAndFaces then
			v16 = catalogSubcategories.Heads
		else
			v16 = catalogSubcategories.ClassicHeads
		end

		v14.SubcategoryKey = v16
	end

	classicHeads.MatchingCatalogPage = v14
	local v15

	if fFlagAXMigrateAllTabToSduiDev then
		v15 = { CategoryId = 0 }
		local v16

		if module10.isEnabled() and v6 then
			v16 = catalogSubcategoryKeys.Heads
		elseif fFlagRemoveClassicHeadsAndFaces then
			v16 = catalogSubcategoryKeys.Heads
		else
			v16 = catalogSubcategoryKeys.ClassicHeads
		end

		v15.CategoryId = v16
	elseif fFlagAXCatalogCategoriesSDUI then
		v15 = { CategoryId = 0, SubcategoryId = 0 }

		local v16 = if v7 then catalogSDUICategoryIds.Body:rawValue() else catalogSDUICategoryIds.Head:rawValue()
		v15.CategoryId = v16
		local v17

		if module10.isEnabled() and v6 then
			v17 = catalogSDUICategoryIds.Body_Heads:rawValue()
		elseif fFlagRemoveClassicHeadsAndFaces then
			v17 = catalogSDUICategoryIds.Body_Heads:rawValue()
		else
			v17 = catalogSDUICategoryIds.Body_ClassicHeads:rawValue()
		end

		v15.SubcategoryId = v17
	end

	classicHeads.MatchingCatalogPageIds = v15

	classicHeads.AssetTypeIdStrings = { module2.AssetTypeIdStrings.Head }
	classicHeads.SearchUuid = searchUuid()
	classicHeads.Id = avatarEditorSubcategories.ClassicHeads

	local classicFaces = {
		Name = "Classic Faces",
		NavigationKey = avatarEditorSubcategories.ClassicFaces,
		Title = "Feature.Avatar.Label.ClassicFaces",
		IconOn = "icons/menu/clothing/faces_on",
		IconOff = "icons/menu/clothing/faces_off",
		RenderItemTiles = true,
		CameraFocus = focusType.Face,
		CameraZoomRadius = cameraZoomRadius.DynamicBodyCategories.ClassicFaces,
		RecommendationsType = recommendationsType.Asset,
		MatchingCatalogPage = 0,
		MatchingCatalogPageIds = 0,
		AssetTypeIdStrings = 0,
		SearchUuid = 0,
		Id = 0
	}
	local v16

	if not fFlagAXCatalogCategoriesSDUI then
		v16 = { CategoryKey = 0, SubcategoryKey = 0 }
		local v17 = if v7 then catalogCategories.Body else catalogCategories.Head
		v16.CategoryKey = v17
		local v18

		if module10.isEnabled() and v6 then
			v18 = catalogSubcategories.Heads
		elseif fFlagRemoveClassicHeadsAndFaces then
			v18 = catalogSubcategories.Face
		else
			v18 = catalogSubcategories.ClassicFaces
		end

		v16.SubcategoryKey = v18
	end

	classicFaces.MatchingCatalogPage = v16
	local v17

	if fFlagAXMigrateAllTabToSduiDev then
		v17 = { CategoryId = 0, SubcategoryId = 0 }
		local v18

		if module10.isEnabled() and v6 then
			v18 = catalogSubcategoryKeys.Heads
		elseif fFlagRemoveClassicHeadsAndFaces then
			v18 = catalogCategoryKeys.Accessories
		else
			v18 = catalogSubcategoryKeys.ClassicFaces
		end

		v17.CategoryId = v18

		local v19 = if not (module10.isEnabled() and v6 or not fFlagRemoveClassicHeadsAndFaces) then catalogSubcategoryKeys.Face else nil
		v17.SubcategoryId = v19
	elseif fFlagAXCatalogCategoriesSDUI then
		v17 = { CategoryId = 0, SubcategoryId = 0 }

		local v18 = if v7 then catalogSDUICategoryIds.Body:rawValue() else catalogSDUICategoryIds.Characters:rawValue()
		v17.CategoryId = v18
		local v19

		if module10.isEnabled() and v6 then
			v19 = catalogSDUICategoryIds.Body_Heads:rawValue()
		elseif fFlagRemoveClassicHeadsAndFaces then
			v19 = catalogSDUICategoryIds.Accessories_Face:rawValue()
		else
			v19 = catalogSDUICategoryIds.Body_ClassicFaces:rawValue()
		end

		v17.SubcategoryId = v19
	end

	classicFaces.MatchingCatalogPageIds = v17

	classicFaces.AssetTypeIdStrings = { module2.AssetTypeIdStrings.Face }
	classicFaces.SearchUuid = searchUuid()
	classicFaces.Id = avatarEditorSubcategories.ClassicFaces

	local torsos = {
		Name = "Torsos",
		NavigationKey = avatarEditorSubcategories.Torsos,
		Title = "Feature.Avatar.Label.Torsos",
		IconOn = "icons/menu/clothing/torsos_on",
		IconOff = "icons/menu/clothing/torsos_off",
		RenderItemTiles = true,
		CameraFocus = focusType.Arms,
		CameraZoomRadius = cameraZoomRadius.DynamicBodyCategories.Torsos,
		RecommendationsType = recommendationsType.BodyParts,
		MatchingCatalogPage = 0,
		MatchingCatalogPageIds = 0,
		AssetTypeIdStrings = 0,
		SearchUuid = 0,
		Id = 0
	}
	local v18

	if not fFlagAXCatalogCategoriesSDUI then
		v18 = { CategoryKey = 0, SubcategoryKey = 0 }
		local v19 = if v7 then catalogCategories.Body else catalogCategories.Characters
		v18.CategoryKey = v19
		local v20 = if v7 then catalogSubcategories.FullBodies else nil
		v18.SubcategoryKey = v20
	end

	torsos.MatchingCatalogPage = v18
	local v19

	if fFlagAXMigrateAllTabToSduiDev then
		v19 = { CategoryId = 0, SubcategoryId = 0 }

		local v20 = if v7 then catalogCategoryKeys.Body else catalogCategoryKeys.Characters
		v19.CategoryId = v20

		local v21 = if v7 then catalogSubcategoryKeys.FullBodies else nil
		v19.SubcategoryId = v21
	elseif fFlagAXCatalogCategoriesSDUI then
		v19 = { CategoryId = 0, SubcategoryId = 0 }

		local v20 = if v7 then catalogSDUICategoryIds.Body:rawValue() else catalogSDUICategoryIds.Characters:rawValue()
		v19.CategoryId = v20

		local v21 = if v7 then catalogSDUICategoryIds.Body_FullBodies:rawValue() else nil
		v19.SubcategoryId = v21
	end

	torsos.MatchingCatalogPageIds = v19

	torsos.AssetTypeIdStrings = { module2.AssetTypeIdStrings.Torso }
	torsos.SearchUuid = searchUuid()
	torsos.Id = avatarEditorSubcategories.Torsos

	local leftArms = {
		Name = "Left Arms",
		NavigationKey = avatarEditorSubcategories.LeftArms,
		Title = "Feature.Avatar.Label.LeftArms",
		IconOn = "icons/menu/clothing/arms_on",
		IconOff = "icons/menu/clothing/arms_off",
		RenderItemTiles = true,
		CameraFocus = focusType.Arms,
		CameraZoomRadius = cameraZoomRadius.DynamicBodyCategories.Arms,
		RecommendationsType = recommendationsType.BodyParts,
		MatchingCatalogPage = 0,
		MatchingCatalogPageIds = 0,
		AssetTypeIdStrings = 0,
		SearchUuid = 0,
		Id = 0
	}
	local v20

	if not fFlagAXCatalogCategoriesSDUI then
		v20 = { CategoryKey = 0, SubcategoryKey = 0 }
		local v21 = if v7 then catalogCategories.Body else catalogCategories.Characters
		v20.CategoryKey = v21
		local v22 = if v7 then catalogSubcategories.FullBodies else nil
		v20.SubcategoryKey = v22
	end

	leftArms.MatchingCatalogPage = v20
	local v21

	if fFlagAXMigrateAllTabToSduiDev then
		v21 = { CategoryId = 0, SubcategoryId = 0 }

		local v22 = if v7 then catalogCategoryKeys.Body else catalogCategoryKeys.Characters
		v21.CategoryId = v22

		local v23 = if v7 then catalogSubcategoryKeys.FullBodies else nil
		v21.SubcategoryId = v23
	elseif fFlagAXCatalogCategoriesSDUI then
		v21 = { CategoryId = 0, SubcategoryId = 0 }

		local v22 = if v7 then catalogSDUICategoryIds.Body:rawValue() else catalogSDUICategoryIds.Characters:rawValue()
		v21.CategoryId = v22

		local v23 = if v7 then catalogSDUICategoryIds.Body_FullBodies:rawValue() else nil
		v21.SubcategoryId = v23
	end

	leftArms.MatchingCatalogPageIds = v21

	leftArms.AssetTypeIdStrings = { module2.AssetTypeIdStrings.LeftArm }
	leftArms.SearchUuid = searchUuid()
	leftArms.Id = avatarEditorSubcategories.LeftArms

	local rightArms = {
		Name = "Right Arms",
		NavigationKey = avatarEditorSubcategories.RightArms,
		Title = "Feature.Avatar.Label.RightArms",
		IconOn = "icons/menu/clothing/arms_on",
		IconOff = "icons/menu/clothing/arms_off",
		RenderItemTiles = true,
		CameraFocus = focusType.Arms,
		CameraZoomRadius = cameraZoomRadius.DynamicBodyCategories.Arms,
		RecommendationsType = recommendationsType.BodyParts,
		MatchingCatalogPage = 0,
		MatchingCatalogPageIds = 0,
		AssetTypeIdStrings = 0,
		SearchUuid = 0,
		Id = 0
	}
	local v22

	if not fFlagAXCatalogCategoriesSDUI then
		v22 = { CategoryKey = 0, SubcategoryKey = 0 }
		local v23 = if v7 then catalogCategories.Body else catalogCategories.Characters
		v22.CategoryKey = v23
		local v24 = if v7 then catalogSubcategories.FullBodies else nil
		v22.SubcategoryKey = v24
	end

	rightArms.MatchingCatalogPage = v22
	local v23

	if fFlagAXMigrateAllTabToSduiDev then
		v23 = { CategoryId = 0, SubcategoryId = 0 }

		local v24 = if v7 then catalogCategoryKeys.Body else catalogCategoryKeys.Characters
		v23.CategoryId = v24

		local v25 = if v7 then catalogSubcategoryKeys.FullBodies else nil
		v23.SubcategoryId = v25
	elseif fFlagAXCatalogCategoriesSDUI then
		v23 = { CategoryId = 0, SubcategoryId = 0 }

		local v24 = if v7 then catalogSDUICategoryIds.Body:rawValue() else catalogSDUICategoryIds.Characters:rawValue()
		v23.CategoryId = v24

		local v25 = if v7 then catalogSDUICategoryIds.Body_FullBodies:rawValue() else nil
		v23.SubcategoryId = v25
	end

	rightArms.MatchingCatalogPageIds = v23

	rightArms.AssetTypeIdStrings = { module2.AssetTypeIdStrings.RightArm }
	rightArms.SearchUuid = searchUuid()
	rightArms.Id = avatarEditorSubcategories.RightArms

	local leftLegs = {
		Name = "Left Legs",
		NavigationKey = avatarEditorSubcategories.LeftLegs,
		Title = "Feature.Avatar.Label.LeftLegs",
		IconOn = "icons/menu/clothing/legs_on",
		IconOff = "icons/menu/clothing/legs_off",
		RenderItemTiles = true,
		CameraFocus = focusType.Legs,
		CameraZoomRadius = cameraZoomRadius.DynamicBodyCategories.Legs,
		RecommendationsType = recommendationsType.BodyParts,
		MatchingCatalogPage = 0,
		MatchingCatalogPageIds = 0,
		AssetTypeIdStrings = 0,
		SearchUuid = 0,
		Id = 0
	}
	local v24

	if not fFlagAXCatalogCategoriesSDUI then
		v24 = { CategoryKey = 0, SubcategoryKey = 0 }
		local v25 = if v7 then catalogCategories.Body else catalogCategories.Characters
		v24.CategoryKey = v25
		local v26 = if v7 then catalogSubcategories.FullBodies else nil
		v24.SubcategoryKey = v26
	end

	leftLegs.MatchingCatalogPage = v24
	local v25

	if fFlagAXMigrateAllTabToSduiDev then
		v25 = { CategoryId = 0, SubcategoryId = 0 }

		local v26 = if v7 then catalogCategoryKeys.Body else catalogCategoryKeys.Characters
		v25.CategoryId = v26

		local v27 = if v7 then catalogSubcategoryKeys.FullBodies else nil
		v25.SubcategoryId = v27
	elseif fFlagAXCatalogCategoriesSDUI then
		v25 = { CategoryId = 0, SubcategoryId = 0 }

		local v26 = if v7 then catalogSDUICategoryIds.Body:rawValue() else catalogSDUICategoryIds.Characters:rawValue()
		v25.CategoryId = v26

		local v27 = if v7 then catalogSDUICategoryIds.Body_FullBodies:rawValue() else nil
		v25.SubcategoryId = v27
	end

	leftLegs.MatchingCatalogPageIds = v25

	leftLegs.AssetTypeIdStrings = { module2.AssetTypeIdStrings.LeftLeg }
	leftLegs.SearchUuid = searchUuid()
	leftLegs.Id = avatarEditorSubcategories.LeftLegs

	local rightLegs = {
		Name = "Right Legs",
		NavigationKey = avatarEditorSubcategories.RightLegs,
		Title = "Feature.Avatar.Label.RightLegs",
		IconOn = "icons/menu/clothing/legs_on",
		IconOff = "icons/menu/clothing/legs_off",
		RenderItemTiles = true,
		CameraFocus = focusType.Legs,
		CameraZoomRadius = cameraZoomRadius.DynamicBodyCategories.Legs,
		RecommendationsType = recommendationsType.BodyParts,
		MatchingCatalogPage = 0,
		MatchingCatalogPageIds = 0,
		AssetTypeIdStrings = 0,
		SearchUuid = 0,
		Id = 0
	}
	local v26

	if not fFlagAXCatalogCategoriesSDUI then
		v26 = { CategoryKey = 0, SubcategoryKey = 0 }
		local v27 = if v7 then catalogCategories.Body else catalogCategories.Characters
		v26.CategoryKey = v27
		local v28 = if v7 then catalogSubcategories.FullBodies else nil
		v26.SubcategoryKey = v28
	end

	rightLegs.MatchingCatalogPage = v26
	local v27

	if fFlagAXMigrateAllTabToSduiDev then
		v27 = { CategoryId = 0, SubcategoryId = 0 }

		local v28 = if v7 then catalogCategoryKeys.Body else catalogCategoryKeys.Characters
		v27.CategoryId = v28

		local v29 = if v7 then catalogSubcategoryKeys.FullBodies else nil
		v27.SubcategoryId = v29
	elseif fFlagAXCatalogCategoriesSDUI then
		v27 = { CategoryId = 0, SubcategoryId = 0 }

		local v28 = if v7 then catalogSDUICategoryIds.Body:rawValue() else catalogSDUICategoryIds.Characters:rawValue()
		v27.CategoryId = v28

		local v29 = if v7 then catalogSDUICategoryIds.Body_FullBodies:rawValue() else nil
		v27.SubcategoryId = v29
	end

	rightLegs.MatchingCatalogPageIds = v27

	rightLegs.AssetTypeIdStrings = { module2.AssetTypeIdStrings.RightLeg }
	rightLegs.SearchUuid = searchUuid()
	rightLegs.Id = avatarEditorSubcategories.RightLegs

	local v28 = {
		Name = "Build",
		NavigationKey = avatarEditorSubcategories.Build,
		Title = "Feature.Avatar.Label.Build",
		IconOn = "icons/menu/clothing/build_on",
		IconOff = "icons/menu/clothing/build_off",
		RenderItemTiles = false,
		RecommendationsType = recommendationsType.None,
		PageType = module2.PageType.BodyStyle,
		SearchUuid = searchUuid(),
		Id = avatarEditorSubcategories.Build,
		hideFilter = true
	}

	local v29 = {}

	table.insert(v29, style)
	table.insert(v29, hair)
	table.insert(v29, v13)

	if not (module10.isEnabled() and v6 or fFlagRemoveClassicHeadsAndFaces) then
		table.insert(v29, classicHeads)
		table.insert(v29, classicFaces)
	end

	table.insert(v29, torsos)

	table.insert(v29, leftArms)
	table.insert(v29, rightArms)
	table.insert(v29, leftLegs)
	table.insert(v29, rightLegs)

	if not isVRAppBuild() then
		table.insert(v29, v28)
	end

	headAndBody.Subcategories = v29

	local v30 = fn5()

	local v31 = fn7()
	local v32

	if module12() then
		v32 = module6()
	else
		v32 = {
			Name = module2.AssetCategories.Emotes,
			Title = "Feature.Avatar.Heading.Emotes",
			IconOn = "icons/menu/clothing/emotes_on",
			IconOff = "icons/menu/clothing/emotes_off",
			CameraZoomRadius = animationCategoryCameraZoomRadius,
			EquipSlotsCount = 8,
			RenderItemTiles = true,
			PageType = module2.PageType.Emotes,
			CanAnimateCameraBasedMood = false,
			RecommendationsType = recommendationsType.Asset,
			MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
				CategoryKey = catalogCategories.AllAnimations,
				SubcategoryKey = catalogSubcategories.Emotes
			} or nil,
			MatchingCatalogPageIds = 0,
			AssetTypeIdStrings = 0,
			SearchUuid = 0,
			Id = 0,
			ShowName = 0
		}

		local v33 = if fFlagAXMigrateAllTabToSduiDev then {
			CategoryId = catalogCategoryKeys.AllAnimations,
			SubcategoryId = catalogSubcategoryKeys.Emotes
		} else fFlagAXCatalogCategoriesSDUI and {
			CategoryId = catalogSDUICategoryIds.AllAnimations:rawValue(),
			SubcategoryId = catalogSDUICategoryIds.Emotes:rawValue()
		} or nil
		v32.MatchingCatalogPageIds = v33

		v32.AssetTypeIdStrings = { module2.AssetTypeIdStrings.EmoteAnimation }
		v32.SearchUuid = searchUuid()
		v32.Id = avatarEditorCategories.Emotes
		v32.ShowName = module11() and true or nil
	end

	v5 = { v8, headAndBody, module5().avatarEditorCategories, v30, v32, v31 }

	for k, v33 in v5 do
		v33.Category = k
		v33.Subcategory = nil

		if not v33.Subcategories then
			continue
		end

		for k2, subcategory in v33.Subcategories do
			subcategory.Category = k
			subcategory.Subcategory = k2
		end
	end
end

local function buildSlotBasedEditorCategories()
	local v6 = if module11() then avatarEditorCategories.All else nil
	local all = {
		Name = "All",
		NavigationKey = v6,
		Title = "Feature.Avatar.Heading.All",
		SearchUuid = searchUuid(),
		CanAnimateCameraBasedMood = true,
		RenderOutfitItemTiles = true,
		CameraFocus = 0,
		CameraZoomRadius = 0,
		AssetTypeIdStrings = 0,
		BundleTypeIdStrings = 0,
		InventoryOutfitTypes = 0,
		MatchingCatalogPage = 0,
		RecommendationsType = 0,
		IconOn = "icons/menu/clothing/purchased_on",
		IconOff = "icons/menu/clothing/purchased_off",
		RenderItemTiles = true,
		UseGetInventoryV2 = true,
		Id = 0
	}

	local v7 = if module14 then focusType.Neck else focusType.Arms
	all.CameraFocus = v7
	all.CameraZoomRadius = module14 and 15 or 13

	all.AssetTypeIdStrings = {
		module2.AssetTypeIdStrings.TShirt,
		module2.AssetTypeIdStrings.Shirt,
		module2.AssetTypeIdStrings.Pants,
		module2.AssetTypeIdStrings.Hat,
		module2.AssetTypeIdStrings.Face,
		module2.AssetTypeIdStrings.Gear,
		module2.AssetTypeIdStrings.HairAccessory,
		module2.AssetTypeIdStrings.FaceAccessory,
		module2.AssetTypeIdStrings.NeckAccessory,
		module2.AssetTypeIdStrings.ShoulderAccessory,
		module2.AssetTypeIdStrings.FrontAccessory,
		module2.AssetTypeIdStrings.BackAccessory,
		module2.AssetTypeIdStrings.WaistAccessory,
		module2.AssetTypeIdStrings.TShirtAccessory,
		module2.AssetTypeIdStrings.ShirtAccessory,
		module2.AssetTypeIdStrings.PantsAccessory,
		module2.AssetTypeIdStrings.JacketAccessory,
		module2.AssetTypeIdStrings.SweaterAccessory,
		module2.AssetTypeIdStrings.ShortsAccessory,
		module2.AssetTypeIdStrings.DressSkirtAccessory,
		module2.AssetTypeIdStrings.Head,
		module2.AssetTypeIdStrings.EyelashAccessory,
		module2.AssetTypeIdStrings.EyebrowAccessory,
		module2.AssetTypeIdStrings.FaceMakeup,
		module2.AssetTypeIdStrings.EyeMakeup,
		module2.AssetTypeIdStrings.LipMakeup
	}

	all.BundleTypeIdStrings = {
		module2.BundleTypeIdStrings.BodyParts,
		module2.BundleTypeIdStrings.DynamicHead,
		module2.BundleTypeIdStrings.Shoes,
		module2.BundleTypeIdStrings.Animations
	}

	all.InventoryOutfitTypes = fFlagAXMigrateOutfitsToUserInventory
		and {
			inventoryOutfitType.Body,
			inventoryOutfitType.DynamicHead,
			inventoryOutfitType.Shoes,
			inventoryOutfitType.Animations,
			inventoryOutfitType.PurchasedMakeup
		}
		or nil

	all.MatchingCatalogPage = module13() and {
		CategoryKey = catalogCategories.Recommended
	} or nil

	local v8 = if module13() then recommendationsType.All else nil
	all.RecommendationsType = v8

	all.Id = avatarEditorCategories.All

	local v9 = fn2()
	local v10 = fn3()
	local v11 = fn5()
	local v12 = if fFlagAXCustomizeBackgrounds then fn4() else nil
	local v13 = fn7()
	local v14 = fn6()
	local v15 = module6()
	local slotBasedEditorCategories

	if fFlagAXDownrankMakeupCustomize then
		slotBasedEditorCategories = {
			all,
			v14,
			v9,
			module5().avatarEditorCategories,
			v11,
			v13,
			v15
		}
	else
		slotBasedEditorCategories = {
			all,
			v14,
			v9,
			v10,
			module5().avatarEditorCategories,
			v11,
			v13,
			v15
		}
	end

	if fFlagAXDownrankMakeupCustomize then
		table.insert(slotBasedEditorCategories, v10)
	end

	if v12 then
		for k, slotBasedEditorCategory in slotBasedEditorCategories do
			if slotBasedEditorCategory == v11 then
				table.insert(slotBasedEditorCategories, k + 1, v12)
				break
			end
		end
	end

	for k, slotBasedEditorCategory in slotBasedEditorCategories do
		slotBasedEditorCategory.Category = k
		slotBasedEditorCategory.Subcategory = nil

		if not slotBasedEditorCategory.Subcategories then
			continue
		end

		for k2, subcategory in slotBasedEditorCategory.Subcategories do
			subcategory.Category = k
			subcategory.Subcategory = k2
			subcategory.UseGetInventoryV2 = true
		end
	end

	return slotBasedEditorCategories
end

local function sanityCheckCat(data)
	module7.isNotNil(data.IconOn, `category {data.Name} is missing iconOn`)
	module7.isNotNil(data.IconOff, `category {data.Name} is missing IconOff`)
	module7.isNotNil(data.SearchUuid, `category {data.Name} is missing SearchUuid`)
	module7.isNotNil(data.Id, "category  " .. data.Name .. " is missing Id")
end

local function checkDuplicateId(p2, p3)
	if p2 then
		if p3[p2] then
			error("Duplicate Id found: " .. p2)
		else
			p3[p2] = true
		end
	end
end

local function sanityCheck(items)
	local idSet = {}

	for k, item in items do
		sanityCheckCat(item)
		local id = item.Id

		if id then
			if idSet[id] then
				error("Duplicate Id found: " .. id)
			else
				idSet[id] = true
			end
		end

		if not item.Subcategories then
			continue
		end

		for k2, subcategory in item.Subcategories do
			sanityCheckCat(subcategory)
			local id2 = subcategory.Id

			if not id2 then
				continue
			end

			if idSet[id2] then
				error("Duplicate Id found: " .. id2)
			else
				idSet[id2] = true
			end
		end
	end
end

local v6 = nil
return function()
	if module11() then
		if not v6 then
			v6 = buildSlotBasedEditorCategories()
			sanityCheck(v6)
		end

		return v6
	end

	if not v5 then
		fn8()
		sanityCheck(v5)
	end

	return v5
end
