local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local Constants = AvatarExperienceCommon.Constants
local Modules = CoreGui.RobloxGui.Modules
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local SearchUuid = require(Modules.LuaApp.SearchUuid)
local getClothingCategories = require(Modules.AvatarExperience.Common.getClothingCategories)
local ArgCheck = require(CorePackages.Workspace.Packages.ArgCheck)
local AvatarExperienceCommon2 = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local CatalogCategories = AvatarExperienceCommon2.Enums.CatalogCategories
local CatalogSubcategories = AvatarExperienceCommon2.Enums.CatalogSubcategories
local CatalogCategoryIds = AvatarExperienceCommon2.Enums.CatalogCategoryIds
local CatalogSubcategoryIds = AvatarExperienceCommon2.Enums.CatalogSubcategoryIds
local CatalogCategoryTaxonomyUUIDs = require(Modules.AvatarExperience.Common.Enum.CatalogCategoryTaxonomyUUIDs)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local AXAvatarsTabIXP = AvatarExperienceCommon.Experiments.AXAvatarsTabIXP
local GetFIntMinSecsToRefreshRecommendedCatalogPage = require(Modules.AvatarExperience.Flags.GetFIntMinSecsToRefreshRecommendedCatalogPage)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagRemoveClassicHeadsAndFaces = AvatarExperienceFlags.FFlagRemoveClassicHeadsAndFaces
local FFlagAXCatalogCategoryTooltip = AvatarExperienceFlags.FFlagAXCatalogCategoryTooltip
local FFlagAXMigrateCategoryTooltip = AvatarExperienceFlags.FFlagAXMigrateCategoryTooltip
local FFlagAXRemoveCatalogCategoryNavKey = AvatarExperienceFlags.FFlagAXRemoveCatalogCategoryNavKey
local FFlagAXCatalogSupportDisableFilters = AvatarExperienceFlags.FFlagAXCatalogSupportDisableFilters
local FFlagAXCatalogMakeupSupport = AvatarExperienceFlags.FFlagAXCatalogMakeupSupport
local FIntAXMakeupCategoryPosition = AvatarExperienceFlags.FIntAXMakeupCategoryPosition
local FFlagAXMakeupCategoryPositionExperiment = AvatarExperienceFlags.FFlagAXMakeupCategoryPositionExperiment
local FFlagAXCatalogMakeupTaxonomy = AvatarExperienceFlags.FFlagAXCatalogMakeupTaxonomy
local FFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local FFlagAXFixWidgetOnlyTabNoItemsFound = AvatarExperienceFlags.FFlagAXFixWidgetOnlyTabNoItemsFound
local FFlagAXCatalogM41Props = AvatarExperienceFlags.FFlagAXCatalogM41Props
local FFlagAXCatalogM41FullMasks = AvatarExperienceFlags.FFlagAXCatalogM41FullMasks
local FFlagAXCatalogM41HandAndArm = AvatarExperienceFlags.FFlagAXCatalogM41HandAndArm
local FFlagAXFixHandAndArmWidgetApiContext = AvatarExperienceFlags.FFlagAXFixHandAndArmWidgetApiContext
local FFlagAXM41AllCategoriesToTaxonomy = AvatarExperienceFlags.FFlagAXM41AllCategoriesToTaxonomy
local FFlagAXAddHDCatalogTab = AvatarExperienceFlags.FFlagAXAddHDCatalogTab
local FFlagAXAddHDCatalogTooltip = AvatarExperienceFlags.FFlagAXAddHDCatalogTooltip
local FFlagAXCatalogBackgroundsSupport = AvatarExperienceFlags.FFlagAXCatalogBackgroundsSupport
local FIntAXBackgroundsCatalogTabPosition = AvatarExperienceFlags.FIntAXBackgroundsCatalogTabPosition
local v41 = game:DefineFastInt("AXHDCatalogTabPosition", 2)
local v42 = game:DefineFastString("AXBodyCategoryTooltipKey", "BodyCategoryCatalogTooltip")

local function buildCategories() -- line: 60
	-- upvalues: AXAvatarsTabIXP (copy), IxpUtils (copy), CatalogCategories (copy), FFlagAXRemoveCatalogCategoryNavKey (copy), FFlagAXCatalogSupportDisableFilters (copy), SearchUuid (copy), GetFIntMinSecsToRefreshRecommendedCatalogPage (copy), CatalogCategoryIds (copy), FFlagAXMigrateAllTabToSduiDev (copy), FFlagAXCatalogCategoriesSDUI (copy), FFlagAXFixWidgetOnlyTabNoItemsFound (copy), FFlagAXM41AllCategoriesToTaxonomy (copy), CatalogCategoryTaxonomyUUIDs (copy), Constants2 (copy), FFlagAXAddHDCatalogTab (copy), FFlagAXAddHDCatalogTooltip (copy), FFlagAXCatalogBackgroundsSupport (copy), FFlagAXCatalogMakeupSupport (copy), CatalogSubcategories (copy), Constants (copy), FFlagAXCatalogMakeupTaxonomy (copy), CatalogSubcategoryIds (copy), FFlagAXCatalogM41FullMasks (copy), FFlagAXCatalogM41HandAndArm (copy), FFlagAXFixHandAndArmWidgetApiContext (copy), FFlagAXCatalogM41Props (copy), FFlagRemoveClassicHeadsAndFaces (copy), FFlagAXMigrateCategoryTooltip (copy), v42 (copy), FFlagAXCatalogCategoryTooltip (copy), getClothingCategories (copy), v41 (copy), FFlagAXMakeupCategoryPositionExperiment (copy), FIntAXMakeupCategoryPosition (copy), FIntAXBackgroundsCatalogTabPosition (copy)
	local v48 = if not AXAvatarsTabIXP.isEnabled() then nil else IxpUtils.readTestVariable(AXAvatarsTabIXP.EnabledForUser)
	local t1 = {
		Name = "All",
		Title = "Feature.Avatar.Heading.All",
		CategoryFilter = "Recommended",
		ShowSponsored = true,
		ShowWidgets = true,
		ShowTopics = true,
		CanAnimateCameraBasedMood = true,
		Id = CatalogCategories.Recommended:rawValue(),
		NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogCategories.Recommended else nil,
		DisableFilters = not FFlagAXCatalogSupportDisableFilters or nil,
		SearchUuid = SearchUuid(),
		TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
		CategoryId = CatalogCategoryIds.All:rawValue(),
		WidgetContext = if not FFlagAXMigrateAllTabToSduiDev then if not FFlagAXCatalogCategoriesSDUI and not FFlagAXFixWidgetOnlyTabNoItemsFound then nil else "catalog-tab:all" else "catalog-tab:recommended",
		TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.AllItems:rawValue()
	}
	local t2 = {
		Name = "Characters",
		Title = "Feature.Catalog.Label.Characters",
		CanAnimateCameraBasedMood = true,
		Id = CatalogCategories.Characters:rawValue(),
		NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogCategories.Characters else nil,
		BundleTypes = { Constants2.BundleTypeIdStrings.BodyParts },
		SearchUuid = SearchUuid(),
		TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
		CategoryId = CatalogCategoryIds.Characters:rawValue()
	}
	local v51 = if not FFlagAXAddHDCatalogTab then nil else {
		Name = "HighDefinition",
		Title = "Feature.Catalog.Label.HD",
		CategoryFilter = "HighDefinition",
		Id = CatalogCategories.HighDefinition:rawValue(),
		TooltipKey = if not FFlagAXAddHDCatalogTooltip then nil else "AXHDCategoryCatalogTooltip",
		TooltipLocalizationKey = if not FFlagAXAddHDCatalogTooltip then nil else "Feature.Catalog.Message.HighDefinitionCategoryTooltip",
		SearchUuid = SearchUuid(),
		TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage()
	}
	local v52 = if not FFlagAXCatalogBackgroundsSupport then nil else {
		Name = "Backgrounds",
		Title = "Feature.Avatar.Label.Backgrounds",
		DisableFilters = true,
		Id = CatalogCategories.Backgrounds:rawValue(),
		SearchUuid = SearchUuid(),
		TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
		TaxonomyUuid = CatalogCategoryTaxonomyUUIDs.Backgrounds:rawValue()
	}
	local t3 = {}
	local t4 = nil

	if FFlagAXCatalogMakeupSupport then
		table.insert(t3, {
			Name = "Looks",
			Title = "Feature.Catalog.Label.MakeupLooks",
			DisableFilters = true,
			LooksWidgetContextForOrganicContent = "makeup-tab",
			isSubcategory = true,
			Id = CatalogSubcategories.MakeupLooks:rawValue(),
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.MakeupLooks else nil,
			CameraFocus = Constants2.FocusType.Face,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Makeup.FaceMakeup,
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage()
		})
		table.insert(t3, {
			Name = "Eyes",
			Title = "Feature.Catalog.Label.EyeMakeup",
			isSubcategory = true,
			Id = CatalogSubcategories.EyeMakeup:rawValue(),
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.EyeMakeup else nil,
			CameraFocus = Constants2.FocusType.Face,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Makeup.EyeMakeup,
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.EyeMakeup },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			TaxonomyUuid = if not FFlagAXCatalogMakeupTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.EyeMakeup:rawValue()
		})
		table.insert(t3, {
			Name = "Lips",
			Title = "Feature.Catalog.Label.LipMakeup",
			isSubcategory = true,
			Id = CatalogSubcategories.LipMakeup:rawValue(),
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.LipMakeup else nil,
			CameraFocus = Constants2.FocusType.Face,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Makeup.LipMakeup,
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.LipMakeup },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			TaxonomyUuid = if not FFlagAXCatalogMakeupTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.LipMakeup:rawValue()
		})
		table.insert(t3, {
			Name = "Face",
			Title = "Feature.Catalog.Label.FaceMakeup",
			isSubcategory = true,
			Id = CatalogSubcategories.FaceMakeup:rawValue(),
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.FaceMakeup else nil,
			CameraFocus = Constants2.FocusType.Face,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Makeup.FaceMakeup,
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.FaceMakeup },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			TaxonomyUuid = if not FFlagAXCatalogMakeupTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.FaceMakeup:rawValue()
		})
		table.insert(t3, {
			Name = "Eyelashes",
			Title = "Feature.Catalog.Label.EyelashMakeup",
			isSubcategory = true,
			Id = CatalogSubcategories.Eyelashes:rawValue(),
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.Eyelashes else nil,
			CameraFocus = Constants2.FocusType.Face,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Makeup.Eyelashes,
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.EyelashAccessory },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			TaxonomyUuid = if not FFlagAXCatalogMakeupTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.Eyelashes:rawValue()
		})
		table.insert(t3, {
			Name = "Eyebrows",
			Title = "Feature.Catalog.Label.EyebrowMakeup",
			isSubcategory = true,
			Id = CatalogSubcategories.Eyebrows:rawValue(),
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.Eyebrows else nil,
			CameraFocus = Constants2.FocusType.Face,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Makeup.Eyebrows,
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.EyebrowAccessory },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			TaxonomyUuid = if not FFlagAXCatalogMakeupTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.Eyebrows:rawValue()
		})
		t4 = {
			Name = "Makeup",
			Title = "Feature.Catalog.Label.Makeup",
			CanAnimateCameraBasedMood = true,
			Id = CatalogCategories.Makeup:rawValue(),
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogCategories.Makeup else nil,
			CameraFocus = Constants2.FocusType.Face,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Makeup.Makeup,
			AssetTypeIdStrings = {
				Constants2.AssetTypeIdStrings.EyelashAccessory,
				Constants2.AssetTypeIdStrings.EyebrowAccessory,
				Constants2.AssetTypeIdStrings.FaceMakeup,
				Constants2.AssetTypeIdStrings.LipMakeup,
				Constants2.AssetTypeIdStrings.EyeMakeup
			},
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			Subcategories = t3,
			TaxonomyUuid = if not FFlagAXCatalogMakeupTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.Makeup:rawValue()
		}
	end

	local t5 = {}

	table.insert(t5, {
		Name = "Hats",
		Title = "Feature.Avatar.Label.Head",
		isSubcategory = true,
		Id = CatalogSubcategories.Hats:rawValue(),
		NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.Hats else nil,
		CameraFocus = Constants2.FocusType.Head,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.CatalogAccessories.Hats,
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.Hat },
		SearchUuid = SearchUuid(),
		TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
		SubcategoryId = CatalogSubcategoryIds.Hats:rawValue(),
		TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.HeadAccessories:rawValue()
	})
	table.insert(t5, {
		Name = "Face",
		Title = "Feature.Avatar.Label.Face",
		isSubcategory = true,
		Id = CatalogSubcategories.Face:rawValue(),
		NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.Face else nil,
		CameraFocus = Constants2.FocusType.Face,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.CatalogAccessories.Face,
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.FaceAccessory },
		SearchUuid = SearchUuid(),
		TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
		SubcategoryId = CatalogSubcategoryIds.Face:rawValue(),
		TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.FaceAccessories:rawValue()
	})

	if FFlagAXCatalogM41FullMasks then
		table.insert(t5, {
			Name = "Full Masks",
			Title = "Feature.Avatar.Label.FullMasks",
			isSubcategory = true,
			Id = CatalogSubcategories.FullMasks:rawValue(),
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.FullMasks else nil,
			CameraFocus = Constants2.FocusType.Face,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.CatalogAccessories.Face,
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			TaxonomyUuid = CatalogCategoryTaxonomyUUIDs.FullMasks:rawValue()
		})
	end

	table.insert(t5, {
		Name = "Neck",
		Title = "Feature.Avatar.Label.Neck",
		isSubcategory = true,
		Id = CatalogSubcategories.Neck:rawValue(),
		NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.Neck else nil,
		CameraFocus = Constants2.FocusType.Neck,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.CatalogAccessories.Neck,
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.NeckAccessory },
		SearchUuid = SearchUuid(),
		TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
		SubcategoryId = CatalogSubcategoryIds.Neck:rawValue(),
		TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.NeckAccessories:rawValue()
	})
	table.insert(t5, {
		Name = "Shoulder",
		Title = "Feature.Avatar.Label.Shoulder",
		isSubcategory = true,
		Id = CatalogSubcategories.Shoulder:rawValue(),
		NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.Shoulder else nil,
		CameraFocus = Constants2.FocusType.Shoulders,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.CatalogAccessories.Shoulder,
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.ShoulderAccessory },
		SearchUuid = SearchUuid(),
		TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
		SubcategoryId = CatalogSubcategoryIds.Shoulder:rawValue(),
		TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.ShoulderAccessories:rawValue()
	})

	if FFlagAXCatalogM41HandAndArm then
		table.insert(t5, {
			Title = "Feature.Avatar.Label.HandAndArm",
			isSubcategory = true,
			Id = CatalogSubcategories.HandAndArm:rawValue(),
			Name = not FFlagAXFixHandAndArmWidgetApiContext and "Hand & Arm" or "Hand And Arm",
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.HandAndArm else nil,
			CameraFocus = Constants2.FocusType.Arms,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.CatalogAccessories.Shoulder,
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			TaxonomyUuid = CatalogCategoryTaxonomyUUIDs.HandAndArm:rawValue()
		})
	end

	table.insert(t5, {
		Name = "Front",
		Title = "Feature.Avatar.Label.Front",
		isSubcategory = true,
		Id = CatalogSubcategories.Front:rawValue(),
		NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.Front else nil,
		CameraFocus = Constants2.FocusType.Arms,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.CatalogAccessories.Front,
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.FrontAccessory },
		SearchUuid = SearchUuid(),
		TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
		SubcategoryId = CatalogSubcategoryIds.Front:rawValue(),
		TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.FrontAccessories:rawValue()
	})
	table.insert(t5, {
		Name = "Back",
		Title = "Feature.Avatar.Label.Back",
		isSubcategory = true,
		Id = CatalogSubcategories.Back:rawValue(),
		NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.Back else nil,
		CameraFocus = Constants2.FocusType.Arms,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.CatalogAccessories.Back,
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.BackAccessory },
		SearchUuid = SearchUuid(),
		TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
		SubcategoryId = CatalogSubcategoryIds.Back:rawValue(),
		TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.BackAccessories:rawValue()
	})
	table.insert(t5, {
		Name = "Waist",
		Title = "Feature.Avatar.Label.Waist",
		isSubcategory = true,
		Id = CatalogSubcategories.Waist:rawValue(),
		NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.Waist else nil,
		CameraFocus = Constants2.FocusType.Waist,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.CatalogAccessories.Waist,
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.WaistAccessory },
		SearchUuid = SearchUuid(),
		TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
		SubcategoryId = CatalogSubcategoryIds.Waist:rawValue(),
		TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.WaistAccessories:rawValue()
	})

	if FFlagAXCatalogM41Props then
		table.insert(t5, {
			Name = "Props",
			Title = "Feature.Avatar.Label.Props",
			isSubcategory = true,
			Id = CatalogSubcategories.Props:rawValue(),
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.Props else nil,
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			TaxonomyUuid = CatalogCategoryTaxonomyUUIDs.Props:rawValue()
		})
	end

	table.insert(t5, {
		Name = "Gear",
		Title = "Feature.Catalog.Label.Gear",
		isSubcategory = true,
		Id = CatalogSubcategories.Gear:rawValue(),
		NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.Gear else nil,
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.Gear },
		SearchUuid = SearchUuid(),
		TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
		SubcategoryId = CatalogSubcategoryIds.Gear:rawValue(),
		TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.Gear:rawValue()
	})

	local t6 = {
		Name = "Accessories",
		Title = "Feature.Catalog.LabelAccessories",
		CanAnimateCameraBasedMood = true,
		Id = CatalogCategories.Accessories:rawValue(),
		NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogCategories.Accessories else nil,
		TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
		AssetTypeIdStrings = {
			Constants2.AssetTypeIdStrings.Hat,
			Constants2.AssetTypeIdStrings.FaceAccessory,
			Constants2.AssetTypeIdStrings.NeckAccessory,
			Constants2.AssetTypeIdStrings.ShoulderAccessory,
			Constants2.AssetTypeIdStrings.FrontAccessory,
			Constants2.AssetTypeIdStrings.BackAccessory,
			Constants2.AssetTypeIdStrings.WaistAccessory,
			Constants2.AssetTypeIdStrings.Gear
		},
		SearchUuid = SearchUuid(),
		CategoryId = CatalogCategoryIds.Accessories:rawValue(),
		Subcategories = t5,
		TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.Accessories:rawValue()
	}
	local t7 = {}

	table.insert(t7, {
		Name = "Heads",
		Title = "Feature.Avatar.Label.Heads",
		isSubcategory = true,
		Id = CatalogSubcategories.Heads:rawValue(),
		NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.Heads else nil,
		CameraFocus = Constants2.FocusType.Head,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.BodyCategories.Heads,
		BundleTypes = { Constants2.BundleTypeIdStrings.DynamicHead },
		SearchUuid = SearchUuid(),
		TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
		TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.DynamicHeads:rawValue()
	})
	table.insert(t7, {
		Name = "Hair",
		Title = "Feature.Catalog.Label.Hair",
		isSubcategory = true,
		Id = CatalogSubcategories.Hair:rawValue(),
		NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.Hair else nil,
		CameraFocus = Constants2.FocusType.Head,
		CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.BodyCategories.Hair,
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.HairAccessory },
		SearchUuid = SearchUuid(),
		TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
		TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.Hair:rawValue()
	})

	if not FFlagRemoveClassicHeadsAndFaces then
		table.insert(t7, {
			Name = "Classic Heads",
			Title = "Feature.Avatar.Label.ClassicHeads",
			isSubcategory = true,
			Id = CatalogSubcategories.ClassicHeads:rawValue(),
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.ClassicHeads else nil,
			CameraFocus = Constants2.FocusType.Head,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.BodyCategories.ClassicHeads,
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.Head },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.ClassicHeads:rawValue()
		})
		table.insert(t7, {
			Name = "Classic Faces",
			Title = "Feature.Avatar.Label.ClassicFaces",
			isSubcategory = true,
			Id = CatalogSubcategories.ClassicFaces:rawValue(),
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.ClassicFaces else nil,
			CameraFocus = Constants2.FocusType.Face,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.BodyCategories.ClassicFaces,
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.Face },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.ClassicFaces:rawValue()
		})
	end

	local t8 = {
		Name = "Heads",
		Title = "Feature.Avatar.Label.Heads",
		CanAnimateCameraBasedMood = true,
		Id = CatalogCategories.Head:rawValue(),
		NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogCategories.Head else nil,
		AssetTypeIdStrings = {
			Constants2.AssetTypeIdStrings.HairAccessory,
			Constants2.AssetTypeIdStrings.Head,
			Constants2.AssetTypeIdStrings.Face,
			Constants2.AssetTypeIdStrings.DynamicHead
		},
		BundleTypes = { Constants2.BundleTypeIdStrings.DynamicHead },
		SearchUuid = SearchUuid(),
		TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
		CategoryId = CatalogCategoryIds.Heads:rawValue(),
		Subcategories = t7
	}
	local t9 = {}

	table.insert(t9, {
		Name = "AnimationBundles",
		Title = "Feature.Catalog.Label.Bundles",
		CanAnimateCameraBasedMood = true,
		isSubcategory = true,
		Id = CatalogSubcategories.AnimationBundles:rawValue(),
		NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.AnimationBundles else nil,
		CameraZoomRadius = Constants2.AnimationCategoryCameraZoomRadius,
		BundleTypes = { Constants2.BundleTypeIdStrings.Animations },
		PageType = Constants2.PageType.Animation,
		SearchUuid = SearchUuid(),
		TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
		SubcategoryId = CatalogSubcategoryIds.AnimationBundles:rawValue(),
		TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.AnimationBundles:rawValue()
	})
	table.insert(t9, {
		Name = "Emotes",
		Title = "Feature.Catalog.Label.Emotes",
		CanAnimateCameraBasedMood = false,
		isSubcategory = true,
		Id = CatalogSubcategories.Emotes:rawValue(),
		NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.Emotes else nil,
		CameraZoomRadius = Constants2.AnimationCategoryCameraZoomRadius,
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.EmoteAnimation },
		PageType = Constants2.PageType.Emotes,
		SearchUuid = SearchUuid(),
		TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
		SubcategoryId = CatalogSubcategoryIds.Emotes:rawValue(),
		TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.Emotes:rawValue()
	})

	local t10 = {
		Name = "AllAnimations",
		Title = "Feature.Avatar.Heading.Animations",
		CanAnimateCameraBasedMood = true,
		Id = CatalogCategories.AllAnimations:rawValue(),
		NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogCategories.AllAnimations else nil,
		CategoryId = CatalogCategoryIds.AllAnimations:rawValue(),
		CameraZoomRadius = Constants2.AnimationCategoryCameraZoomRadius,
		AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.EmoteAnimation },
		BundleTypes = { Constants2.BundleTypeIdStrings.Animations },
		PageType = Constants2.PageType.AllAnimation,
		SearchUuid = SearchUuid(),
		TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
		Subcategories = t9,
		TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.Animations:rawValue()
	}
	local t12 = nil
	local t11 = {}
	local t13 = nil

	if v48 then
		t12 = {
			Name = "Avatars",
			Title = "Feature.Catalog.Label.Avatars",
			LooksWidgetContextForOrganicContent = "avatarTab",
			CanAnimateCameraBasedMood = true,
			Id = CatalogCategories.Avatars:rawValue(),
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogCategories.Avatars else nil,
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			DisableFilters = not not FFlagAXCatalogSupportDisableFilters or nil
		}
		table.insert(t11, {
			Name = "Full Bodies",
			Title = "Feature.Catalog.Label.FullBodies",
			isSubcategory = true,
			Id = CatalogSubcategories.FullBodies:rawValue(),
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.FullBodies else nil,
			BundleTypes = { Constants2.BundleTypeIdStrings.BodyParts },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			SubcategoryId = CatalogSubcategoryIds.FullBodies:rawValue(),
			TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.FullBodies:rawValue()
		})
		table.insert(t11, {
			Name = "Hair",
			Title = "Feature.Catalog.Label.Hair",
			isSubcategory = true,
			Id = CatalogSubcategories.Hair:rawValue(),
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.Hair else nil,
			CameraFocus = Constants2.FocusType.Head,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.BodyCategories.Hair,
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.HairAccessory },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			SubcategoryId = CatalogSubcategoryIds.Hair:rawValue(),
			TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.Hair:rawValue()
		})
		table.insert(t11, {
			Name = "Heads",
			Title = "Feature.Avatar.Label.Heads",
			isSubcategory = true,
			Id = CatalogSubcategories.Heads:rawValue(),
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.Heads else nil,
			CameraFocus = Constants2.FocusType.Head,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.BodyCategories.Heads,
			BundleTypes = { Constants2.BundleTypeIdStrings.DynamicHead },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			SubcategoryId = CatalogSubcategoryIds.Head:rawValue(),
			TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.DynamicHeads:rawValue()
		})

		if not FFlagRemoveClassicHeadsAndFaces then
			table.insert(t11, {
				Name = "Classic Heads",
				Title = "Feature.Avatar.Label.ClassicHeads",
				isSubcategory = true,
				Id = CatalogSubcategories.ClassicHeads:rawValue(),
				NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.ClassicHeads else nil,
				CameraFocus = Constants2.FocusType.Head,
				CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.BodyCategories.ClassicHeads,
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.Head },
				SearchUuid = SearchUuid(),
				TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
				SubcategoryId = CatalogSubcategoryIds.ClassicHeads:rawValue(),
				TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.ClassicHeads:rawValue()
			})
			table.insert(t11, {
				Name = "Classic Faces",
				Title = "Feature.Avatar.Label.ClassicFaces",
				isSubcategory = true,
				Id = CatalogSubcategories.ClassicFaces:rawValue(),
				NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.ClassicFaces else nil,
				CameraFocus = Constants2.FocusType.Face,
				CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.BodyCategories.ClassicFaces,
				AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.Face },
				SearchUuid = SearchUuid(),
				TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
				SubcategoryId = CatalogSubcategoryIds.ClassicFaces:rawValue(),
				TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.ClassicFaces:rawValue()
			})
		end

		t13 = {
			Name = "Body",
			Title = "Feature.Catalog.Label.Body",
			CanAnimateCameraBasedMood = true,
			Id = CatalogCategories.Body:rawValue(),
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogCategories.Body else nil,
			TooltipKey = if not FFlagAXMigrateCategoryTooltip then if not FFlagAXCatalogCategoryTooltip then nil else "BodyCategoryCatalogTooltip" else v42,
			TooltipLocalizationKey = if not FFlagAXMigrateCategoryTooltip then nil else "Feature.Catalog.Message.BodyCategoryTooltip",
			AssetTypeIdStrings = {
				Constants2.AssetTypeIdStrings.HairAccessory,
				Constants2.AssetTypeIdStrings.Head,
				Constants2.AssetTypeIdStrings.Face,
				Constants2.AssetTypeIdStrings.DynamicHead
			},
			BundleTypes = {
				Constants2.BundleTypeIdStrings.BodyParts,
				Constants2.BundleTypeIdStrings.DynamicHead
			},
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			CategoryId = CatalogCategoryIds.Body:rawValue(),
			Subcategories = t11,
			TaxonomyUuid = if not FFlagAXM41AllCategoriesToTaxonomy then nil else CatalogCategoryTaxonomyUUIDs.Body:rawValue()
		}
	end

	local t14 = {}

	table.insert(t14, t1)

	if v48 then
		table.insert(t14, t12)
		table.insert(t14, t13)
	else
		table.insert(t14, t2)
	end

	if FFlagAXCatalogMakeupSupport then
		table.insert(t14, t4)
	end

	if FFlagAXCatalogBackgroundsSupport then
		table.insert(t14, v52)
	end

	table.insert(t14, getClothingCategories().catalogCategories)
	table.insert(t14, t6)

	if not v48 then
		table.insert(t14, t8)
	end

	table.insert(t14, t10)

	if FFlagAXAddHDCatalogTab then
		table.insert(t14, math.clamp(v41, 1, #t14 + 1), v51)
	end

	if FFlagAXCatalogMakeupSupport and FFlagAXMakeupCategoryPositionExperiment and FIntAXMakeupCategoryPosition > 0 then
		local n1 = 0

		for v66, v67 in t14 do
			if v67 == t4 then
				n1 = v66

				break
			end
		end

		if n1 > 0 then
			table.remove(t14, n1)
			table.insert(t14, math.clamp(FIntAXMakeupCategoryPosition, 1, #t14 + 1), t4)
		end
	end

	if FFlagAXCatalogBackgroundsSupport and FIntAXBackgroundsCatalogTabPosition > 0 then
		local n2 = 0

		for v69, v70 in t14 do
			if v70 == v52 then
				n2 = v69

				break
			end
		end

		if n2 > 0 then
			table.remove(t14, n2)
			table.insert(t14, math.clamp(FIntAXBackgroundsCatalogTabPosition, 1, #t14 + 1), v52)
		end
	end

	return t14
end

local u44 = nil

local function sanityCheckCat(p1) -- line: 773
	-- upvalues: ArgCheck (copy), FFlagAXRemoveCatalogCategoryNavKey (copy)
	ArgCheck.isNotNil(p1.SearchUuid, "category  " .. p1.Name .. " is missing SearchUuid")
	ArgCheck.isNotNil(p1.Id, "category  " .. p1.Name .. " is missing Id")

	if FFlagAXRemoveCatalogCategoryNavKey then
		ArgCheck.isTypeOrNil(p1.NavigationKey, "nil", "NavigationKey")
	end
end
local function checkDuplicateId(p2, p3) -- line: 781
	if p2 then
		if p3[p2] then
			error("Duplicate Id found: " .. p2)

			return
		end

		p3[p2] = true
	end
end
local function sanityCheck(p4) -- line: 791
	-- upvalues: ArgCheck (copy), FFlagAXRemoveCatalogCategoryNavKey (copy)
	local t15 = {}

	for _, v77 in p4 do
		ArgCheck.isNotNil(v77.SearchUuid, "category  " .. v77.Name .. " is missing SearchUuid")
		ArgCheck.isNotNil(v77.Id, "category  " .. v77.Name .. " is missing Id")

		if FFlagAXRemoveCatalogCategoryNavKey then
			ArgCheck.isTypeOrNil(v77.NavigationKey, "nil", "NavigationKey")
		end

		local Id = v77.Id

		if Id then
			if t15[Id] then
				error("Duplicate Id found: " .. Id)
			else
				t15[Id] = true
			end
		end

		if v77.Subcategories then
			for _, v80 in v77.Subcategories do
				ArgCheck.isNotNil(v80.SearchUuid, "category  " .. v80.Name .. " is missing SearchUuid")
				ArgCheck.isNotNil(v80.Id, "category  " .. v80.Name .. " is missing Id")

				if FFlagAXRemoveCatalogCategoryNavKey then
					ArgCheck.isTypeOrNil(v80.NavigationKey, "nil", "NavigationKey")
				end

				local Id2 = v80.Id

				if Id2 then
					if t15[Id2] then
						error("Duplicate Id found: " .. Id2)
					else
						t15[Id2] = true
					end
				end

				ArgCheck.isNotNil(v80.isSubcategory, "subcategory  " .. v80.Id .. " is missing isSubcategory")
			end
		end
	end
end

return function(b1: boolean?) -- line: 809
	-- upvalues: buildCategories (copy), sanityCheck (copy), u44 (ref)
	if b1 then
		local v83 = buildCategories()

		sanityCheck(v83)

		return v83
	end

	if not u44 then
		u44 = buildCategories()
		sanityCheck(u44)
	end

	return u44
end
