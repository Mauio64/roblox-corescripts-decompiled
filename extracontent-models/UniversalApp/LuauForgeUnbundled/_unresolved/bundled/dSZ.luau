local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local constants = AvatarExperienceCommon.Constants

local module2 = require("@luauforge/bundled/dPN")
local searchUuid = require("@luauforge/bundled/dRA").SearchUuid
local module3 = require("@luauforge/bundled/dRD")
local module4 = require("@luauforge/bundled/dzP")
local module5 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local catalogSubcategories = module5.Enums.CatalogSubcategories
local catalogCategoryIds = module5.Enums.CatalogCategoryIds
local catalogSubcategoryIds = module5.Enums.CatalogSubcategoryIds
local module6 = require("@luauforge/bundled/dPt")
local catalogCategories = module6.Enums.CatalogCategories
local animationCategoryCameraZoomRadius = module6.Constants.AnimationCategoryCameraZoomRadius
local cameraZoomRadius = module6.Constants.CameraZoomRadius
local catalogCategoryTaxonomyUUIDs = module6.Enums.CatalogCategoryTaxonomyUUIDs
local focusType = module6.Enums.FocusType
local module7 = require("@luauforge/bundled/dPR")

local axAvatarsTabIXP = AvatarExperienceCommon.Experiments.AXAvatarsTabIXP

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagRemoveClassicHeadsAndFaces = AvatarExperienceFlags.FFlagRemoveClassicHeadsAndFaces

local fFlagAXMigrateCategoryTooltip = AvatarExperienceFlags.FFlagAXMigrateCategoryTooltip
local fFlagAXCatalogSupportDisableFilters = AvatarExperienceFlags.FFlagAXCatalogSupportDisableFilters
local fFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local fIntAXMakeupCategoryPosition = AvatarExperienceFlags.FIntAXMakeupCategoryPosition

local fIntAXMinSecsToRefreshRecommendedCatalogPage = AvatarExperienceFlags.FIntAXMinSecsToRefreshRecommendedCatalogPage
local fFlagAXMakeupCategoryPositionExperiment = AvatarExperienceFlags.FFlagAXMakeupCategoryPositionExperiment
local fFlagAXCatalogMakeupTaxonomy = AvatarExperienceFlags.FFlagAXCatalogMakeupTaxonomy
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXFixWidgetOnlyTabNoItemsFound = AvatarExperienceFlags.FFlagAXFixWidgetOnlyTabNoItemsFound
local fFlagAXCatalogM41Props = AvatarExperienceFlags.FFlagAXCatalogM41Props
local fFlagAXCatalogM41FullMasks = AvatarExperienceFlags.FFlagAXCatalogM41FullMasks
local fFlagAXCatalogM41HandAndArm = AvatarExperienceFlags.FFlagAXCatalogM41HandAndArm
local fFlagAXFixHandAndArmWidgetApiContext = AvatarExperienceFlags.FFlagAXFixHandAndArmWidgetApiContext
local fFlagAXM41AllCategoriesToTaxonomy = AvatarExperienceFlags.FFlagAXM41AllCategoriesToTaxonomy
local fFlagAXAddHDCatalogTab = AvatarExperienceFlags.FFlagAXAddHDCatalogTab
local fFlagAXAddHDCatalogTooltip = AvatarExperienceFlags.FFlagAXAddHDCatalogTooltip
local fFlagAXCatalogBackgroundsSupport = AvatarExperienceFlags.FFlagAXCatalogBackgroundsSupport
local fFlagAXCatalogBackgroundsFilters = AvatarExperienceFlags.FFlagAXCatalogBackgroundsFilters
local fIntAXBackgroundsCatalogTabPosition = AvatarExperienceFlags.FIntAXBackgroundsCatalogTabPosition
local defineFastInt = game:DefineFastInt("AXHDCatalogTabPosition", 2)

local defineFastString = game:DefineFastString("AXBodyCategoryTooltipKey", "BodyCategoryCatalogTooltip")

local function buildCategories()
	local v5

	if axAvatarsTabIXP.isEnabled() then
		v5 = module7.readTestVariable(axAvatarsTabIXP.EnabledForUser)
	end

	local all = {
		Id = catalogCategories.Recommended:rawValue(),
		Name = "All",
		Title = "Feature.Avatar.Heading.All",
		CategoryFilter = "Recommended",
		DisableFilters = not fFlagAXCatalogSupportDisableFilters or nil,
		ShowSponsored = true,
		ShowWidgets = true,
		ShowTopics = true,
		CanAnimateCameraBasedMood = true,
		SearchUuid = searchUuid(),
		TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
		CategoryId = catalogCategoryIds.All:rawValue(),
		WidgetContext = fFlagAXMigrateAllTabToSduiDev and "catalog-tab:recommended" or (fFlagAXCatalogCategoriesSDUI or fFlagAXFixWidgetOnlyTabNoItemsFound) and "catalog-tab:all" or nil,
		TaxonomyUuid = 0
	}

	local v6 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.AllItems:rawValue() else nil
	all.TaxonomyUuid = v6

	local v7 = {
		Id = catalogCategories.Characters:rawValue(),
		Name = "Characters",
		Title = "Feature.Catalog.Label.Characters",
		BundleTypes = { module6.Constants.BundleTypeIdStrings.BodyParts },
		CanAnimateCameraBasedMood = true,
		SearchUuid = searchUuid(),
		TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
		CategoryId = catalogCategoryIds.Characters:rawValue()
	}

	local v8 = fFlagAXAddHDCatalogTab and {
		Id = catalogCategories.HighDefinition:rawValue(),
		Name = "HighDefinition",
		Title = "Feature.Catalog.Label.HD",
		CategoryFilter = "HighDefinition",
		TooltipKey = fFlagAXAddHDCatalogTooltip and "AXHDCategoryCatalogTooltip" or nil,
		TooltipLocalizationKey = fFlagAXAddHDCatalogTooltip and "Feature.Catalog.Message.HighDefinitionCategoryTooltip" or nil,
		SearchUuid = searchUuid(),
		TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage
	} or nil

	local v9 = fFlagAXCatalogBackgroundsSupport and {
		Id = catalogCategories.Backgrounds:rawValue(),
		Name = "Backgrounds",
		Title = "Feature.Avatar.Label.Backgrounds",
		SearchUuid = searchUuid(),
		TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
		TaxonomyUuid = catalogCategoryTaxonomyUUIDs.Backgrounds:rawValue(),
		DisableFilters = not fFlagAXCatalogBackgroundsFilters or nil
	} or nil

	local v10 = {}
	local makeup

	if fFlagAXCatalogMakeupSupport then
		table.insert(v10, {
			Id = catalogSubcategories.MakeupLooks:rawValue(),
			Name = "Looks",
			Title = "Feature.Catalog.Label.MakeupLooks",
			CameraFocus = focusType.Face,
			CameraZoomRadius = cameraZoomRadius.Makeup.FaceMakeup,
			DisableFilters = true,
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			LooksWidgetContextForOrganicContent = "makeup-tab",
			isSubcategory = true
		})

		local eyes = {
			Id = catalogSubcategories.EyeMakeup:rawValue(),
			Name = "Eyes",
			Title = "Feature.Catalog.Label.EyeMakeup",
			CameraFocus = focusType.Face,
			CameraZoomRadius = cameraZoomRadius.Makeup.EyeMakeup,
			AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.EyeMakeup },
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			isSubcategory = true,
			TaxonomyUuid = 0
		}

		local v11 = if fFlagAXCatalogMakeupTaxonomy then catalogCategoryTaxonomyUUIDs.EyeMakeup:rawValue() else nil
		eyes.TaxonomyUuid = v11
		table.insert(v10, eyes)

		local lips = {
			Id = catalogSubcategories.LipMakeup:rawValue(),
			Name = "Lips",
			Title = "Feature.Catalog.Label.LipMakeup",
			CameraFocus = focusType.Face,
			CameraZoomRadius = cameraZoomRadius.Makeup.LipMakeup,
			AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.LipMakeup },
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			isSubcategory = true,
			TaxonomyUuid = 0
		}

		local v12 = if fFlagAXCatalogMakeupTaxonomy then catalogCategoryTaxonomyUUIDs.LipMakeup:rawValue() else nil
		lips.TaxonomyUuid = v12
		table.insert(v10, lips)

		local face = {
			Id = catalogSubcategories.FaceMakeup:rawValue(),
			Name = "Face",
			Title = "Feature.Catalog.Label.FaceMakeup",
			CameraFocus = focusType.Face,
			CameraZoomRadius = cameraZoomRadius.Makeup.FaceMakeup,
			AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.FaceMakeup },
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			isSubcategory = true,
			TaxonomyUuid = 0
		}

		local v13 = if fFlagAXCatalogMakeupTaxonomy then catalogCategoryTaxonomyUUIDs.FaceMakeup:rawValue() else nil
		face.TaxonomyUuid = v13
		table.insert(v10, face)

		local eyelashes = {
			Id = catalogSubcategories.Eyelashes:rawValue(),
			Name = "Eyelashes",
			Title = "Feature.Catalog.Label.EyelashMakeup",
			CameraFocus = focusType.Face,
			CameraZoomRadius = cameraZoomRadius.Makeup.Eyelashes,
			AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.EyelashAccessory },
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			isSubcategory = true,
			TaxonomyUuid = 0
		}

		local v14 = if fFlagAXCatalogMakeupTaxonomy then catalogCategoryTaxonomyUUIDs.Eyelashes:rawValue() else nil
		eyelashes.TaxonomyUuid = v14
		table.insert(v10, eyelashes)

		local eyebrows = {
			Id = catalogSubcategories.Eyebrows:rawValue(),
			Name = "Eyebrows",
			Title = "Feature.Catalog.Label.EyebrowMakeup",
			CameraFocus = focusType.Face,
			CameraZoomRadius = cameraZoomRadius.Makeup.Eyebrows,
			AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.EyebrowAccessory },
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			isSubcategory = true,
			TaxonomyUuid = 0
		}

		local v15 = if fFlagAXCatalogMakeupTaxonomy then catalogCategoryTaxonomyUUIDs.Eyebrows:rawValue() else nil
		eyebrows.TaxonomyUuid = v15
		table.insert(v10, eyebrows)

		makeup = {
			Id = catalogCategories.Makeup:rawValue(),
			Name = "Makeup",
			Title = "Feature.Catalog.Label.Makeup",
			CameraFocus = focusType.Face,
			CameraZoomRadius = cameraZoomRadius.Makeup.Makeup,
			AssetTypeIdStrings = {
				constants.ASSET_TYPE_NAME_TO_ID_STRING.EyelashAccessory,
				constants.ASSET_TYPE_NAME_TO_ID_STRING.EyebrowAccessory,
				constants.ASSET_TYPE_NAME_TO_ID_STRING.FaceMakeup,
				constants.ASSET_TYPE_NAME_TO_ID_STRING.LipMakeup,
				constants.ASSET_TYPE_NAME_TO_ID_STRING.EyeMakeup
			},
			CanAnimateCameraBasedMood = true,
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			Subcategories = v10,
			TaxonomyUuid = 0
		}

		local v16 = if fFlagAXCatalogMakeupTaxonomy then catalogCategoryTaxonomyUUIDs.Makeup:rawValue() else nil
		makeup.TaxonomyUuid = v16
	end

	local v11 = {}
	local hats = {
		Id = catalogSubcategories.Hats:rawValue(),
		Name = "Hats",
		Title = "Feature.Avatar.Label.Head",
		CameraFocus = focusType.Head,
		CameraZoomRadius = cameraZoomRadius.CatalogAccessories.Hats,
		AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.Hat },
		SearchUuid = searchUuid(),
		TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
		SubcategoryId = catalogSubcategoryIds.Hats:rawValue(),
		isSubcategory = true,
		TaxonomyUuid = 0
	}

	local v12 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.HeadAccessories:rawValue() else nil
	hats.TaxonomyUuid = v12
	table.insert(v11, hats)

	local face = {
		Id = catalogSubcategories.Face:rawValue(),
		Name = "Face",
		Title = "Feature.Avatar.Label.Face",
		CameraFocus = focusType.Face,
		CameraZoomRadius = cameraZoomRadius.CatalogAccessories.Face,
		AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.FaceAccessory },
		SearchUuid = searchUuid(),
		TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
		SubcategoryId = catalogSubcategoryIds.Face:rawValue(),
		isSubcategory = true,
		TaxonomyUuid = 0
	}

	local v13 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.FaceAccessories:rawValue() else nil
	face.TaxonomyUuid = v13
	table.insert(v11, face)

	if fFlagAXCatalogM41FullMasks then
		table.insert(v11, {
			Id = catalogSubcategories.FullMasks:rawValue(),
			Name = "Full Masks",
			Title = "Feature.Avatar.Label.FullMasks",
			CameraFocus = focusType.Face,
			CameraZoomRadius = cameraZoomRadius.CatalogAccessories.Face,
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			isSubcategory = true,
			TaxonomyUuid = catalogCategoryTaxonomyUUIDs.FullMasks:rawValue()
		})
	end

	local neck = {
		Id = catalogSubcategories.Neck:rawValue(),
		Name = "Neck",
		Title = "Feature.Avatar.Label.Neck",
		CameraFocus = focusType.Neck,
		CameraZoomRadius = cameraZoomRadius.CatalogAccessories.Neck,
		AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.NeckAccessory },
		SearchUuid = searchUuid(),
		TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
		SubcategoryId = catalogSubcategoryIds.Neck:rawValue(),
		isSubcategory = true,
		TaxonomyUuid = 0
	}

	local v14 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.NeckAccessories:rawValue() else nil
	neck.TaxonomyUuid = v14
	table.insert(v11, neck)

	local shoulder = {
		Id = catalogSubcategories.Shoulder:rawValue(),
		Name = "Shoulder",
		Title = "Feature.Avatar.Label.Shoulder",
		CameraFocus = focusType.Shoulders,
		CameraZoomRadius = cameraZoomRadius.CatalogAccessories.Shoulder,
		AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.ShoulderAccessory },
		SearchUuid = searchUuid(),
		TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
		SubcategoryId = catalogSubcategoryIds.Shoulder:rawValue(),
		isSubcategory = true,
		TaxonomyUuid = 0
	}

	local v15 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.ShoulderAccessories:rawValue() else nil
	shoulder.TaxonomyUuid = v15
	table.insert(v11, shoulder)

	if fFlagAXCatalogM41HandAndArm then
		table.insert(v11, {
			Id = catalogSubcategories.HandAndArm:rawValue(),
			Name = fFlagAXFixHandAndArmWidgetApiContext and "Hand And Arm" or "Hand & Arm",
			Title = "Feature.Avatar.Label.HandAndArm",
			CameraFocus = focusType.Arms,
			CameraZoomRadius = cameraZoomRadius.CatalogAccessories.Shoulder,
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			isSubcategory = true,
			TaxonomyUuid = catalogCategoryTaxonomyUUIDs.HandAndArm:rawValue()
		})
	end

	local front = {
		Id = catalogSubcategories.Front:rawValue(),
		Name = "Front",
		Title = "Feature.Avatar.Label.Front",
		CameraFocus = focusType.Arms,
		CameraZoomRadius = cameraZoomRadius.CatalogAccessories.Front,
		AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.FrontAccessory },
		SearchUuid = searchUuid(),
		TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
		SubcategoryId = catalogSubcategoryIds.Front:rawValue(),
		isSubcategory = true,
		TaxonomyUuid = 0
	}

	local v16 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.FrontAccessories:rawValue() else nil
	front.TaxonomyUuid = v16
	table.insert(v11, front)

	local back = {
		Id = catalogSubcategories.Back:rawValue(),
		Name = "Back",
		Title = "Feature.Avatar.Label.Back",
		CameraFocus = focusType.Arms,
		CameraZoomRadius = cameraZoomRadius.CatalogAccessories.Back,
		AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.BackAccessory },
		SearchUuid = searchUuid(),
		TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
		SubcategoryId = catalogSubcategoryIds.Back:rawValue(),
		isSubcategory = true,
		TaxonomyUuid = 0
	}

	local v17 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.BackAccessories:rawValue() else nil
	back.TaxonomyUuid = v17
	table.insert(v11, back)

	local waist = {
		Id = catalogSubcategories.Waist:rawValue(),
		Name = "Waist",
		Title = "Feature.Avatar.Label.Waist",
		CameraFocus = focusType.Waist,
		CameraZoomRadius = cameraZoomRadius.CatalogAccessories.Waist,
		AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.WaistAccessory },
		SearchUuid = searchUuid(),
		TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
		SubcategoryId = catalogSubcategoryIds.Waist:rawValue(),
		isSubcategory = true,
		TaxonomyUuid = 0
	}

	local v18 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.WaistAccessories:rawValue() else nil
	waist.TaxonomyUuid = v18
	table.insert(v11, waist)

	if fFlagAXCatalogM41Props then
		table.insert(v11, {
			Id = catalogSubcategories.Props:rawValue(),
			Name = "Props",
			Title = "Feature.Avatar.Label.Props",
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			isSubcategory = true,
			TaxonomyUuid = catalogCategoryTaxonomyUUIDs.Props:rawValue()
		})
	end

	local gear = {
		Id = catalogSubcategories.Gear:rawValue(),
		Name = "Gear",
		Title = "Feature.Catalog.Label.Gear",
		AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.Gear },
		SearchUuid = searchUuid(),
		TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
		SubcategoryId = catalogSubcategoryIds.Gear:rawValue(),
		isSubcategory = true,
		TaxonomyUuid = 0
	}

	local v19 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.Gear:rawValue() else nil
	gear.TaxonomyUuid = v19
	table.insert(v11, gear)

	local accessories = {
		Id = catalogCategories.Accessories:rawValue(),
		Name = "Accessories",
		Title = "Feature.Catalog.LabelAccessories",
		TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
		AssetTypeIdStrings = {
			constants.ASSET_TYPE_NAME_TO_ID_STRING.Hat,
			constants.ASSET_TYPE_NAME_TO_ID_STRING.FaceAccessory,
			constants.ASSET_TYPE_NAME_TO_ID_STRING.NeckAccessory,
			constants.ASSET_TYPE_NAME_TO_ID_STRING.ShoulderAccessory,
			constants.ASSET_TYPE_NAME_TO_ID_STRING.FrontAccessory,
			constants.ASSET_TYPE_NAME_TO_ID_STRING.BackAccessory,
			constants.ASSET_TYPE_NAME_TO_ID_STRING.WaistAccessory,
			constants.ASSET_TYPE_NAME_TO_ID_STRING.Gear
		},
		CanAnimateCameraBasedMood = true,
		SearchUuid = searchUuid(),
		CategoryId = catalogCategoryIds.Accessories:rawValue(),
		Subcategories = v11,
		TaxonomyUuid = 0
	}

	local v20 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.Accessories:rawValue() else nil
	accessories.TaxonomyUuid = v20

	local v21 = {}
	local heads = {
		Id = catalogSubcategories.Heads:rawValue(),
		Name = "Heads",
		Title = "Feature.Avatar.Label.Heads",
		CameraFocus = focusType.Head,
		CameraZoomRadius = cameraZoomRadius.BodyCategories.Heads,
		BundleTypes = { module6.Constants.BundleTypeIdStrings.DynamicHead },
		SearchUuid = searchUuid(),
		TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
		isSubcategory = true,
		TaxonomyUuid = 0
	}

	local v22 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.DynamicHeads:rawValue() else nil
	heads.TaxonomyUuid = v22
	table.insert(v21, heads)

	local hair = {
		Id = catalogSubcategories.Hair:rawValue(),
		Name = "Hair",
		Title = "Feature.Catalog.Label.Hair",
		CameraFocus = focusType.Head,
		CameraZoomRadius = cameraZoomRadius.BodyCategories.Hair,
		AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.HairAccessory },
		SearchUuid = searchUuid(),
		TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
		isSubcategory = true,
		TaxonomyUuid = 0
	}

	local v23 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.Hair:rawValue() else nil
	hair.TaxonomyUuid = v23
	table.insert(v21, hair)

	if not fFlagRemoveClassicHeadsAndFaces then
		local classicHeads = {
			Id = catalogSubcategories.ClassicHeads:rawValue(),
			Name = "Classic Heads",
			Title = "Feature.Avatar.Label.ClassicHeads",
			CameraFocus = focusType.Head,
			CameraZoomRadius = cameraZoomRadius.BodyCategories.ClassicHeads,
			AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.Head },
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			isSubcategory = true,
			TaxonomyUuid = 0
		}

		local v24 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.ClassicHeads:rawValue() else nil
		classicHeads.TaxonomyUuid = v24
		table.insert(v21, classicHeads)

		local classicFaces = {
			Id = catalogSubcategories.ClassicFaces:rawValue(),
			Name = "Classic Faces",
			Title = "Feature.Avatar.Label.ClassicFaces",
			CameraFocus = focusType.Face,
			CameraZoomRadius = cameraZoomRadius.BodyCategories.ClassicFaces,
			AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.Face },
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			isSubcategory = true,
			TaxonomyUuid = 0
		}

		local v25 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.ClassicFaces:rawValue() else nil
		classicFaces.TaxonomyUuid = v25
		table.insert(v21, classicFaces)
	end

	local v24 = {
		Id = catalogCategories.Head:rawValue(),
		Name = "Heads",
		Title = "Feature.Avatar.Label.Heads",
		AssetTypeIdStrings = {
			constants.ASSET_TYPE_NAME_TO_ID_STRING.HairAccessory,
			constants.ASSET_TYPE_NAME_TO_ID_STRING.Head,
			constants.ASSET_TYPE_NAME_TO_ID_STRING.Face,
			constants.ASSET_TYPE_NAME_TO_ID_STRING.DynamicHead
		},
		BundleTypes = { module6.Constants.BundleTypeIdStrings.DynamicHead },
		CanAnimateCameraBasedMood = true,
		SearchUuid = searchUuid(),
		TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
		CategoryId = catalogCategoryIds.Heads:rawValue(),
		Subcategories = v21
	}

	local v25 = {}
	local animationBundles = {
		Id = catalogSubcategories.AnimationBundles:rawValue(),
		Name = "AnimationBundles",
		Title = "Feature.Catalog.Label.Bundles",
		CameraZoomRadius = animationCategoryCameraZoomRadius,
		CanAnimateCameraBasedMood = true,
		BundleTypes = { module6.Constants.BundleTypeIdStrings.Animations },
		PageType = module2.PageType.Animation,
		SearchUuid = searchUuid(),
		TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
		SubcategoryId = catalogSubcategoryIds.AnimationBundles:rawValue(),
		isSubcategory = true,
		TaxonomyUuid = 0
	}

	local v26 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.AnimationBundles:rawValue() else nil
	animationBundles.TaxonomyUuid = v26
	table.insert(v25, animationBundles)

	local emotes = {
		Id = catalogSubcategories.Emotes:rawValue(),
		Name = "Emotes",
		Title = "Feature.Catalog.Label.Emotes",
		CameraZoomRadius = animationCategoryCameraZoomRadius,
		CanAnimateCameraBasedMood = false,
		AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.EmoteAnimation },
		PageType = module2.PageType.Emotes,
		SearchUuid = searchUuid(),
		TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
		SubcategoryId = catalogSubcategoryIds.Emotes:rawValue(),
		isSubcategory = true,
		TaxonomyUuid = 0
	}

	local v27 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.Emotes:rawValue() else nil
	emotes.TaxonomyUuid = v27
	table.insert(v25, emotes)

	local allAnimations = {
		Id = catalogCategories.AllAnimations:rawValue(),
		Name = "AllAnimations",
		Title = "Feature.Avatar.Heading.Animations",
		CategoryId = catalogCategoryIds.AllAnimations:rawValue(),
		CameraZoomRadius = animationCategoryCameraZoomRadius,
		AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.EmoteAnimation },
		BundleTypes = { module6.Constants.BundleTypeIdStrings.Animations },
		PageType = module2.PageType.AllAnimation,
		CanAnimateCameraBasedMood = true,
		SearchUuid = searchUuid(),
		TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
		Subcategories = v25,
		TaxonomyUuid = 0
	}

	local v28 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.Animations:rawValue() else nil
	allAnimations.TaxonomyUuid = v28

	local v29 = {}
	local avatars, body

	if v5 then
		avatars = {
			Id = catalogCategories.Avatars:rawValue(),
			Name = "Avatars",
			Title = "Feature.Catalog.Label.Avatars",
			LooksWidgetContextForOrganicContent = "avatarTab",
			CanAnimateCameraBasedMood = true,
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			DisableFilters = fFlagAXCatalogSupportDisableFilters and true or nil
		}

		local fullBodies = {
			Id = catalogSubcategories.FullBodies:rawValue(),
			Name = "Full Bodies",
			Title = "Feature.Catalog.Label.FullBodies",
			BundleTypes = { module6.Constants.BundleTypeIdStrings.BodyParts },
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			SubcategoryId = catalogSubcategoryIds.FullBodies:rawValue(),
			isSubcategory = true,
			TaxonomyUuid = 0
		}

		local v30 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.FullBodies:rawValue() else nil
		fullBodies.TaxonomyUuid = v30
		table.insert(v29, fullBodies)

		local hair2 = {
			Id = catalogSubcategories.Hair:rawValue(),
			Name = "Hair",
			Title = "Feature.Catalog.Label.Hair",
			CameraFocus = focusType.Head,
			CameraZoomRadius = cameraZoomRadius.BodyCategories.Hair,
			AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.HairAccessory },
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			SubcategoryId = catalogSubcategoryIds.Hair:rawValue(),
			isSubcategory = true,
			TaxonomyUuid = 0
		}

		local v31 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.Hair:rawValue() else nil
		hair2.TaxonomyUuid = v31
		table.insert(v29, hair2)

		local heads2 = {
			Id = catalogSubcategories.Heads:rawValue(),
			Name = "Heads",
			Title = "Feature.Avatar.Label.Heads",
			CameraFocus = focusType.Head,
			CameraZoomRadius = cameraZoomRadius.BodyCategories.Heads,
			BundleTypes = { module6.Constants.BundleTypeIdStrings.DynamicHead },
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			SubcategoryId = catalogSubcategoryIds.Head:rawValue(),
			isSubcategory = true,
			TaxonomyUuid = 0
		}

		local v32 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.DynamicHeads:rawValue() else nil
		heads2.TaxonomyUuid = v32
		table.insert(v29, heads2)

		if not fFlagRemoveClassicHeadsAndFaces then
			local classicHeads = {
				Id = catalogSubcategories.ClassicHeads:rawValue(),
				Name = "Classic Heads",
				Title = "Feature.Avatar.Label.ClassicHeads",
				CameraFocus = focusType.Head,
				CameraZoomRadius = cameraZoomRadius.BodyCategories.ClassicHeads,
				AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.Head },
				SearchUuid = searchUuid(),
				TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
				SubcategoryId = catalogSubcategoryIds.ClassicHeads:rawValue(),
				isSubcategory = true,
				TaxonomyUuid = 0
			}

			local v33 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.ClassicHeads:rawValue() else nil
			classicHeads.TaxonomyUuid = v33
			table.insert(v29, classicHeads)

			local classicFaces = {
				Id = catalogSubcategories.ClassicFaces:rawValue(),
				Name = "Classic Faces",
				Title = "Feature.Avatar.Label.ClassicFaces",
				CameraFocus = focusType.Face,
				CameraZoomRadius = cameraZoomRadius.BodyCategories.ClassicFaces,
				AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.Face },
				SearchUuid = searchUuid(),
				TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
				SubcategoryId = catalogSubcategoryIds.ClassicFaces:rawValue(),
				isSubcategory = true,
				TaxonomyUuid = 0
			}

			local v34 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.ClassicFaces:rawValue() else nil
			classicFaces.TaxonomyUuid = v34
			table.insert(v29, classicFaces)
		end

		body = {
			Id = catalogCategories.Body:rawValue(),
			Name = "Body",
			Title = "Feature.Catalog.Label.Body",
			TooltipKey = not fFlagAXMigrateCategoryTooltip and "BodyCategoryCatalogTooltip" or defineFastString,
			TooltipLocalizationKey = fFlagAXMigrateCategoryTooltip and "Feature.Catalog.Message.BodyCategoryTooltip" or nil,
			AssetTypeIdStrings = {
				constants.ASSET_TYPE_NAME_TO_ID_STRING.HairAccessory,
				constants.ASSET_TYPE_NAME_TO_ID_STRING.Head,
				constants.ASSET_TYPE_NAME_TO_ID_STRING.Face,
				constants.ASSET_TYPE_NAME_TO_ID_STRING.DynamicHead
			},
			BundleTypes = {
				module6.Constants.BundleTypeIdStrings.BodyParts,
				module6.Constants.BundleTypeIdStrings.DynamicHead
			},
			CanAnimateCameraBasedMood = true,
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			CategoryId = catalogCategoryIds.Body:rawValue(),
			Subcategories = v29,
			TaxonomyUuid = 0
		}

		local v33 = if fFlagAXM41AllCategoriesToTaxonomy then catalogCategoryTaxonomyUUIDs.Body:rawValue() else nil
		body.TaxonomyUuid = v33
	end

	local categories = {}

	table.insert(categories, all)

	if v5 then
		table.insert(categories, avatars)
		table.insert(categories, body)
	else
		table.insert(categories, v7)
	end

	if fFlagAXCatalogMakeupSupport then
		table.insert(categories, makeup)
	end

	if fFlagAXCatalogBackgroundsSupport then
		table.insert(categories, v9)
	end

	table.insert(categories, module3().catalogCategories)
	table.insert(categories, accessories)

	if not v5 then
		table.insert(categories, v24)
	end

	table.insert(categories, allAnimations)

	if fFlagAXAddHDCatalogTab then
		table.insert(categories, math.clamp(defineFastInt, 1, #categories + 1), v8)
	end

	if
		fFlagAXCatalogMakeupSupport
		and fFlagAXMakeupCategoryPositionExperiment
		and fIntAXMakeupCategoryPosition > 0
	then
		local v30 = 0

		for k, category in categories do
			if category == makeup then
				v30 = k
				break
			end
		end

		if v30 > 0 then
			table.remove(categories, v30)
			table.insert(categories, math.clamp(fIntAXMakeupCategoryPosition, 1, #categories + 1), makeup)
		end
	end

	if not (fFlagAXCatalogBackgroundsSupport and fIntAXBackgroundsCatalogTabPosition > 0) then
		return categories
	end

	local v30 = 0

	for k, category in categories do
		if category == v9 then
			v30 = k
			break
		end
	end

	if v30 > 0 then
		table.remove(categories, v30)
		table.insert(categories, math.clamp(fIntAXBackgroundsCatalogTabPosition, 1, #categories + 1), v9)
	end

	return categories
end

local v5 = nil

local function sanityCheckCat(data)
	module4.isNotNil(data.SearchUuid, "category  " .. data.Name .. " is missing SearchUuid")
	module4.isNotNil(data.Id, "category  " .. data.Name .. " is missing Id")
	module4.isTypeOrNil(data.NavigationKey, "nil", "NavigationKey")
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
		module4.isNotNil(item.SearchUuid, "category  " .. item.Name .. " is missing SearchUuid")
		module4.isNotNil(item.Id, "category  " .. item.Name .. " is missing Id")
		module4.isTypeOrNil(item.NavigationKey, "nil", "NavigationKey")

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
			module4.isNotNil(
				subcategory.SearchUuid,
				"category  " .. subcategory.Name .. " is missing SearchUuid"
			)
			module4.isNotNil(subcategory.Id, "category  " .. subcategory.Name .. " is missing Id")
			module4.isTypeOrNil(subcategory.NavigationKey, "nil", "NavigationKey")

			local id2 = subcategory.Id

			if id2 then
				if idSet[id2] then
					error("Duplicate Id found: " .. id2)
				else
					idSet[id2] = true
				end
			end

			module4.isNotNil(
				subcategory.isSubcategory,
				"subcategory  " .. subcategory.Id .. " is missing isSubcategory"
			)
		end
	end
end

return function(p2)
	if p2 then
		local categories = buildCategories()
		sanityCheck(categories)
		return categories
	end

	if not v5 then
		v5 = buildCategories()
		sanityCheck(v5)
	end

	return v5
end
