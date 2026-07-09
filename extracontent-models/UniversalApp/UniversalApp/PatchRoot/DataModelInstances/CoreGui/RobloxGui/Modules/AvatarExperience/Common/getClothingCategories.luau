local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Dash = require(CorePackages.Packages.Dash)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local Constants = AvatarExperienceCommon.Constants
local Constants2 = require(Modules.AvatarExperience.Common.Constants)
local Constants3 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local SearchUuid = require(Modules.LuaApp.SearchUuid)
local CatalogCategories = AvatarExperienceCommon.Enums.CatalogCategories
local CatalogSubcategories = AvatarExperienceCommon.Enums.CatalogSubcategories
local CatalogCategoryIds = AvatarExperienceCommon.Enums.CatalogCategoryIds
local CatalogSDUICategoryIds = AvatarExperienceCommon.Enums.CatalogSDUICategoryIds
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXRemoveCatalogCategoryNavKey = AvatarExperienceFlags.FFlagAXRemoveCatalogCategoryNavKey
local FFlagAXCatalogBodySuits = AvatarExperienceFlags.FFlagAXCatalogBodySuits
local FFlagAXShowBodySuitsCategoryInCatalog = AvatarExperienceFlags.FFlagAXShowBodySuitsCategoryInCatalog
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local AvatarEditorSubcategories = AvatarExperienceSlotBasedEditor.Enums.AvatarEditorSubcategories
local AvatarEditorCategories = AvatarExperienceSlotBasedEditor.Enums.AvatarEditorCategories
local CatalogCategoryTaxonomyUUIDs = require(Modules.AvatarExperience.Common.Enum.CatalogCategoryTaxonomyUUIDs)
local GetFFlagAXAddNavigationKeyToEditorSubcategories = require(Modules.AvatarExperience.Flags.GetFFlagAXAddNavigationKeyToEditorSubcategories)
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local FFlagAXSwapOuterwearSubcategoryOrder = require(Modules.AvatarExperience.Flags.FFlagAXSwapOuterwearSubcategoryOrder)
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local s1 = "JacketAccessory.ClassicShirts.ClassicTShirts.ClassicPants"

if GetFFlagAXEnableSlotBasedEditor() then
	s1 = "JacketAccessory.ClassicShirts.ClassicTShirts.ClassicPants.LeftShoeAccessory.RightShoeAccessory"
end

local u26 = game:DefineFastString("AXCategories", s1)
local u27 = Dash.collectSet(string.split(u26, "."))
local GetFIntMinSecsToRefreshRecommendedCatalogPage = require(Modules.AvatarExperience.Flags.GetFIntMinSecsToRefreshRecommendedCatalogPage)
local t1 = {
	Tops = "Tops",
	Outerwear = "Outerwear",
	Bottoms = "Bottoms",
	LeftShoeAccessory = "LeftShoeAccessory",
	RightShoeAccessory = "RightShoeAccessory",
	Shoes = "Shoes",
	DivisibleShoes = "DivisibleShoes",
	ClassicShirts = "ClassicShirts",
	ClassicTShirts = "ClassicTShirts",
	ClassicPants = "ClassicPants",
	ShirtAccessory = "ShirtAccessory",
	TShirtAccessory = "TShirtAccessory",
	SweaterAccessory = "SweaterAccessory",
	PantsAccessory = "PantsAccessory",
	JacketAccessory = "JacketAccessory",
	ShortsAccessory = "ShortsAccessory",
	DressSkirtAccessory = "DressSkirtAccessory",
	Bodysuits = if not FFlagAXCatalogBodySuits then nil else "Bodysuits"
}
local _ = {
	ShirtAccessory = 59,
	TShirtAccessory = 58,
	SweaterAccessory = 62,
	JacketAccessory = 61,
	PantsAccessory = 60,
	DressSkirtAccessory = 65,
	ShortsAccessory = 63,
	Shoes = 64,
	ClassicShirts = 56,
	ClassicTShirts = 55,
	ClassicPants = 57
}

local function createCatalogSubcategories() -- line: 100
	-- upvalues: t1 (copy), FFlagAXRemoveCatalogCategoryNavKey (copy), CatalogSubcategories (copy), Constants2 (copy), Constants (copy), SearchUuid (copy), GetFIntMinSecsToRefreshRecommendedCatalogPage (copy), CatalogCategoryTaxonomyUUIDs (copy), FFlagAXCatalogBodySuits (copy)
	local t2 = {
		[t1.ShirtAccessory] = {
			Name = "Shirts",
			Title = "Feature.Avatar.Label.Shirts",
			SubcategoryId = 59,
			isSubcategory = true,
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.Shirts else nil,
			CameraFocus = Constants2.FocusType.Arms,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Clothing.Shirts,
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.ShirtAccessory },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			Id = CatalogSubcategories.Shirts:rawValue(),
			TaxonomyUuid = CatalogCategoryTaxonomyUUIDs.Shirts:rawValue()
		},
		[t1.TShirtAccessory] = {
			Name = "TShirts",
			Title = "Feature.Catalog.LabelTShirts",
			SubcategoryId = 58,
			isSubcategory = true,
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.TShirts else nil,
			CameraFocus = Constants2.FocusType.Arms,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Clothing.TShirts,
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.TShirtAccessory },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			Id = CatalogSubcategories.TShirts:rawValue(),
			TaxonomyUuid = CatalogCategoryTaxonomyUUIDs.TShirts:rawValue()
		},
		[t1.SweaterAccessory] = {
			Name = "Sweaters",
			Title = "Feature.Avatar.Label.Sweaters",
			SubcategoryId = 62,
			isSubcategory = true,
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.Sweaters else nil,
			CameraFocus = Constants2.FocusType.Arms,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Clothing.Sweaters,
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.SweaterAccessory },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			Id = CatalogSubcategories.Sweaters:rawValue(),
			TaxonomyUuid = CatalogCategoryTaxonomyUUIDs.Sweaters:rawValue()
		},
		[t1.JacketAccessory] = {
			Name = "Jackets",
			Title = "Feature.Avatar.Label.Jackets",
			SubcategoryId = 61,
			isSubcategory = true,
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.Jackets else nil,
			CameraFocus = Constants2.FocusType.Arms,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Clothing.Jackets,
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.JacketAccessory },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			Id = CatalogSubcategories.Jackets:rawValue(),
			TaxonomyUuid = CatalogCategoryTaxonomyUUIDs.Jackets:rawValue()
		},
		[t1.PantsAccessory] = {
			Name = "Pants",
			Title = "Feature.Avatar.Label.Pants",
			SubcategoryId = 60,
			isSubcategory = true,
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.Pants else nil,
			CameraFocus = Constants2.FocusType.Legs,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Clothing.Pants,
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.PantsAccessory },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			Id = CatalogSubcategories.Pants:rawValue(),
			TaxonomyUuid = CatalogCategoryTaxonomyUUIDs.Pants:rawValue()
		},
		[t1.DressSkirtAccessory] = {
			Name = "DressSkirt",
			Title = "Feature.Avatar.Label.DressesAndSkirts",
			SubcategoryId = 65,
			isSubcategory = true,
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.DressesAndSkirts else nil,
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.DressSkirtAccessory },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			Id = CatalogSubcategories.DressesAndSkirts:rawValue(),
			TaxonomyUuid = CatalogCategoryTaxonomyUUIDs.DressesAndSkirts:rawValue()
		},
		[t1.ShortsAccessory] = {
			Name = "Shorts",
			Title = "Feature.Avatar.Label.Shorts",
			SubcategoryId = 63,
			isSubcategory = true,
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.Shorts else nil,
			CameraFocus = Constants2.FocusType.Legs,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Clothing.Shorts,
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.ShortsAccessory },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			Id = CatalogSubcategories.Shorts:rawValue(),
			TaxonomyUuid = CatalogCategoryTaxonomyUUIDs.Shorts:rawValue()
		},
		[t1.Shoes] = {
			Name = "Shoes",
			Title = "Feature.Avatar.Label.Shoes",
			SubcategoryId = 64,
			isSubcategory = true,
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.Shoes else nil,
			CameraFocus = Constants2.FocusType.Legs,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Clothing.Shoes,
			BundleTypes = { Constants2.BundleTypeIdStrings.Shoes },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			Id = CatalogSubcategories.Shoes:rawValue(),
			TaxonomyUuid = CatalogCategoryTaxonomyUUIDs.Shoes:rawValue()
		},
		[t1.ClassicShirts] = {
			Name = "Classic Shirts",
			Title = "Feature.Avatar.Label.ClassicShirts",
			SubcategoryId = 56,
			isSubcategory = true,
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.ClassicShirts else nil,
			CameraFocus = Constants2.FocusType.Arms,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Clothing.ClassicShirts,
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.Shirt },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			Id = CatalogSubcategories.ClassicShirts:rawValue(),
			TaxonomyUuid = CatalogCategoryTaxonomyUUIDs.ClassicShirts:rawValue()
		},
		[t1.ClassicTShirts] = {
			Name = "Classic T-Shirts",
			Title = "Feature.Avatar.Label.ClassicTShirts",
			SubcategoryId = 55,
			isSubcategory = true,
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.ClassicTShirts else nil,
			CameraFocus = Constants2.FocusType.Arms,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Clothing.ClassicTShirts,
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.TShirt },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			Id = CatalogSubcategories.ClassicTShirts:rawValue(),
			TaxonomyUuid = CatalogCategoryTaxonomyUUIDs.ClassicTShirts:rawValue()
		},
		[t1.ClassicPants] = {
			Name = "Classic Pants",
			Title = "Feature.Avatar.Label.ClassicPants",
			SubcategoryId = 57,
			isSubcategory = true,
			NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogSubcategories.ClassicPants else nil,
			CameraFocus = Constants2.FocusType.Legs,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Clothing.ClassicPants,
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.Pants },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			Id = CatalogSubcategories.ClassicPants:rawValue(),
			TaxonomyUuid = CatalogCategoryTaxonomyUUIDs.ClassicPants:rawValue()
		}
	}

	if FFlagAXCatalogBodySuits then
		t2[t1.Bodysuits] = {
			Name = "Bodysuits",
			Title = "Feature.Avatar.Label.Bodysuits",
			isSubcategory = true,
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			Id = CatalogSubcategories.Bodysuits:rawValue(),
			TaxonomyUuid = CatalogCategoryTaxonomyUUIDs.Bodysuits:rawValue()
		}
	end

	return t2
end
local function buildCatalogClothingAssetTypes(p1) -- line: 304
	-- upvalues: t1 (copy), Constants2 (copy)
	local t3 = {}

	if p1[t1.ShirtAccessory] then
		table.insert(t3, Constants2.AssetTypeIdStrings.ShirtAccessory)
	end

	if p1[t1.TShirtAccessory] then
		table.insert(t3, Constants2.AssetTypeIdStrings.TShirtAccessory)
	end

	if p1[t1.SweaterAccessory] then
		table.insert(t3, Constants2.AssetTypeIdStrings.SweaterAccessory)
	end

	if p1[t1.JacketAccessory] then
		table.insert(t3, Constants2.AssetTypeIdStrings.JacketAccessory)
	end

	if p1[t1.PantsAccessory] then
		table.insert(t3, Constants2.AssetTypeIdStrings.PantsAccessory)
	end

	if p1[t1.ShortsAccessory] then
		table.insert(t3, Constants2.AssetTypeIdStrings.ShortsAccessory)
	end

	if p1[t1.DressSkirtAccessory] then
		table.insert(t3, Constants2.AssetTypeIdStrings.DressSkirtAccessory)
	end

	if p1[t1.LeftShoeAccessory] then
		table.insert(t3, Constants2.AssetTypeIdStrings.LeftShoeAccessory)
	end

	if p1[t1.RightShoeAccessory] then
		table.insert(t3, Constants2.AssetTypeIdStrings.RightShoeAccessory)
	end

	if p1[t1.ClassicShirts] then
		table.insert(t3, Constants2.AssetTypeIdStrings.Shirt)
	end

	if p1[t1.ClassicTShirts] then
		table.insert(t3, Constants2.AssetTypeIdStrings.TShirt)
	end

	if p1[t1.ClassicPants] then
		table.insert(t3, Constants2.AssetTypeIdStrings.Pants)
	end

	return t3
end
local function buildCatalogSubcategoriesToUse(p2, p3) -- line: 346
	-- upvalues: t1 (copy), FFlagAXCatalogBodySuits (copy), FFlagAXShowBodySuitsCategoryInCatalog (copy)
	local t4 = {}

	if p2[t1.ShirtAccessory] then
		table.insert(t4, p3[t1.ShirtAccessory])
	end

	if p2[t1.TShirtAccessory] then
		table.insert(t4, p3[t1.TShirtAccessory])
	end

	if p2[t1.SweaterAccessory] then
		table.insert(t4, p3[t1.SweaterAccessory])
	end

	if p2[t1.JacketAccessory] then
		table.insert(t4, p3[t1.JacketAccessory])
	end

	if p2[t1.PantsAccessory] then
		table.insert(t4, p3[t1.PantsAccessory])
	end

	if p2[t1.DressSkirtAccessory] then
		table.insert(t4, p3[t1.DressSkirtAccessory])
	end

	if FFlagAXCatalogBodySuits and (p2[t1.Bodysuits] or FFlagAXShowBodySuitsCategoryInCatalog) then
		table.insert(t4, p3[t1.Bodysuits])
	end

	if p2[t1.ShortsAccessory] then
		table.insert(t4, p3[t1.ShortsAccessory])
	end

	if p2[t1.LeftShoeAccessory] then
		table.insert(t4, p3[t1.Shoes])
	end

	if p2[t1.ClassicShirts] then
		table.insert(t4, p3[t1.ClassicShirts])
	end

	if p2[t1.ClassicTShirts] then
		table.insert(t4, p3[t1.ClassicTShirts])
	end

	if p2[t1.ClassicPants] then
		table.insert(t4, p3[t1.ClassicPants])
	end

	return t4
end

local u34 = nil

local function createClothingCategories() -- line: 388
	-- upvalues: u26 (ref), u27 (ref), Dash (copy), createCatalogSubcategories (copy), buildCatalogClothingAssetTypes (copy), buildCatalogSubcategoriesToUse (copy), FFlagAXRemoveCatalogCategoryNavKey (copy), CatalogCategories (copy), SearchUuid (copy), GetFIntMinSecsToRefreshRecommendedCatalogPage (copy), CatalogCategoryIds (copy), CatalogCategoryTaxonomyUUIDs (copy), t1 (copy), Constants2 (copy), GetFFlagAXAddNavigationKeyToEditorSubcategories (copy), AvatarEditorSubcategories (copy), Constants (copy), Constants3 (copy), FFlagAXCatalogCategoriesSDUI (copy), GetFFlagAXEnableSlotBasedEditor (copy), CatalogSubcategories (copy), CatalogSDUICategoryIds (copy), FFlagAXSwapOuterwearSubcategoryOrder (copy), AvatarEditorCategories (copy)
	u26 = game:GetFastString("AXCategories")
	u27 = Dash.collectSet(string.split(u26, "."))

	local v43 = createCatalogSubcategories()
	local v44 = buildCatalogClothingAssetTypes(u27)
	local v45 = buildCatalogSubcategoriesToUse(u27, v43)
	local t5 = {
		Name = "Clothing",
		Title = "Feature.Catalog.Label.Clothing",
		CanAnimateCameraBasedMood = true,
		NavigationKey = if not FFlagAXRemoveCatalogCategoryNavKey then CatalogCategories.Clothing else nil,
		AssetTypeIdStrings = v44,
		SearchUuid = SearchUuid(),
		Subcategories = v45,
		TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
		Id = CatalogCategories.Clothing:rawValue(),
		CategoryId = CatalogCategoryIds.Clothing:rawValue(),
		TaxonomyUuid = CatalogCategoryTaxonomyUUIDs.Clothing:rawValue()
	}
	local t6 = {}

	if u27[t1.ShirtAccessory] then
		table.insert(t6, Constants2.AssetTypeIdStrings.ShirtAccessory)
	end

	if u27[t1.TShirtAccessory] then
		table.insert(t6, Constants2.AssetTypeIdStrings.TShirtAccessory)
	end

	if u27[t1.SweaterAccessory] then
		table.insert(t6, Constants2.AssetTypeIdStrings.SweaterAccessory)
	end

	local v48 = if not u27[t1.TShirtAccessory] then t6[1] else Constants2.AssetTypeIdStrings.TShirtAccessory
	local t7 = {}

	if u27[t1.PantsAccessory] then
		table.insert(t7, Constants2.AssetTypeIdStrings.PantsAccessory)
	end

	if u27[t1.ShortsAccessory] then
		table.insert(t7, Constants2.AssetTypeIdStrings.ShortsAccessory)
	end

	if u27[t1.DressSkirtAccessory] then
		table.insert(t7, Constants2.AssetTypeIdStrings.DressSkirtAccessory)
	end

	local v50 = if not u27[t1.PantsAccessory] then t7[1] else Constants2.AssetTypeIdStrings.PantsAccessory
	local t8 = {
		Tops = {
			Name = "Tops",
			Title = "Feature.Catalog.Label.Tops",
			IconOn = "icons/menu/clothing/shirts_on",
			IconOff = "icons/menu/clothing/shirts_off",
			RenderItemTiles = true,
			Category = 2,
			NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Tops,
			RecommendedAssetTypeIdString = v48,
			CameraFocus = Constants2.FocusType.Arms,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Clothing.Tops,
			RecommendationsType = Constants3.RecommendationsType.Asset,
			MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
				CategoryKey = CatalogCategories.Clothing,
				SubcategoryKey = if not GetFFlagAXEnableSlotBasedEditor() then CatalogSubcategories.TShirts else CatalogSubcategories.Shirts
			} else nil,
			MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
				CategoryId = CatalogSDUICategoryIds.Clothing:rawValue(),
				SubcategoryId = if not GetFFlagAXEnableSlotBasedEditor() then CatalogSDUICategoryIds.Clothing_TShirts:rawValue() else CatalogSDUICategoryIds.Clothing_Shirts:rawValue()
			},
			AssetTypeIdStrings = t6,
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			Id = AvatarEditorSubcategories.Tops
		},
		Outerwear = {
			Name = "Outerwear",
			Title = "Feature.Avatar.Label.Outerwear",
			IconOn = "icons/menu/clothing/jackets_on",
			IconOff = "icons/menu/clothing/jackets_off",
			RenderItemTiles = true,
			Category = 2,
			NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Outerwear,
			CameraFocus = Constants2.FocusType.Arms,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Clothing.Outerwear,
			RecommendationsType = Constants3.RecommendationsType.Asset,
			MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
				CategoryKey = CatalogCategories.Clothing,
				SubcategoryKey = CatalogSubcategories.Jackets
			} else nil,
			MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
				CategoryId = CatalogSDUICategoryIds.Clothing:rawValue(),
				SubcategoryId = CatalogSDUICategoryIds.Clothing_Jackets:rawValue()
			},
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.JacketAccessory },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			Id = AvatarEditorSubcategories.Outerwear
		},
		Bottoms = {
			Name = "Bottoms",
			Title = "Feature.Avatar.Label.Bottoms",
			IconOn = "icons/menu/clothing/pants_on",
			IconOff = "icons/menu/clothing/pants_off",
			RenderItemTiles = true,
			Category = 2,
			NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Bottoms,
			RecommendedAssetTypeIdString = v50,
			CameraFocus = Constants2.FocusType.Legs,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Clothing.Bottoms,
			RecommendationsType = Constants3.RecommendationsType.Asset,
			MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
				CategoryKey = CatalogCategories.Clothing,
				SubcategoryKey = CatalogSubcategories.Pants
			} else nil,
			MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
				CategoryId = CatalogSDUICategoryIds.Clothing:rawValue(),
				SubcategoryId = CatalogSDUICategoryIds.Clothing_Pants:rawValue()
			},
			AssetTypeIdStrings = t7,
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			Id = AvatarEditorSubcategories.Bottoms
		},
		Shoes = if not GetFFlagAXEnableSlotBasedEditor() then nil else {
			Name = "Shoes",
			Title = "Feature.Avatar.Label.Shoes",
			IconOn = "icons/menu/clothing/shoes_on",
			IconOff = "icons/menu/clothing/shoes_off",
			RenderItemTiles = true,
			RenderOutfitItemTiles = true,
			Category = 2,
			SubcategoryFiltersHeader = "Feature.Catalog.Heading.ShowShoes",
			NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.Shoes,
			CameraFocus = Constants2.FocusType.Legs,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Clothing.Shoes,
			RecommendationsType = Constants3.RecommendationsType.Shoes,
			MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
				CategoryKey = CatalogCategories.Clothing,
				SubcategoryKey = CatalogSubcategories.Shoes
			} else nil,
			MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
				CategoryId = CatalogSDUICategoryIds.Clothing:rawValue(),
				SubcategoryId = if not FFlagAXCatalogCategoriesSDUI then CatalogSubcategories.Shoes:rawValue() else CatalogSDUICategoryIds.Clothing_Shoes:rawValue()
			},
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			BundleTypeIdStrings = { Constants2.BundleTypeIdStrings.Shoes },
			SubcategoryFilters = {
				{
					Name = "Full Pairs",
					Title = "Feature.Avatar.Label.FullPair",
					RenderOutfitItemTiles = true,
					NavigationKey = AvatarEditorSubcategories.ShoesPairs,
					BundleTypeIdStrings = { Constants2.BundleTypeIdStrings.Shoes },
					SearchUuid = SearchUuid()
				},
				{
					Name = "Left Shoes",
					Title = "Feature.Avatar.Label.LeftShoe",
					NavigationKey = AvatarEditorSubcategories.LeftShoes,
					AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.LeftShoeAccessory },
					SearchUuid = SearchUuid()
				},
				{
					Name = "Right Shoes",
					Title = "Feature.Avatar.Label.RightShoe",
					NavigationKey = AvatarEditorSubcategories.RightShoes,
					AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.RightShoeAccessory },
					SearchUuid = SearchUuid()
				}
			},
			Id = AvatarEditorSubcategories.Shoes
		},
		LeftShoes = if not GetFFlagAXEnableSlotBasedEditor() then {
			Name = "Left Shoes",
			Title = "Feature.Avatar.Label.LeftShoes",
			IconOn = "icons/menu/clothing/shoes_on",
			IconOff = "icons/menu/clothing/shoes_off",
			RenderItemTiles = true,
			Category = 2,
			NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.LeftShoes,
			CameraFocus = Constants2.FocusType.Legs,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Clothing.Shoes,
			RecommendationsType = Constants3.RecommendationsType.Shoes,
			MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
				CategoryKey = CatalogCategories.Clothing,
				SubcategoryKey = CatalogSubcategories.Shoes
			} else nil,
			MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
				CategoryId = CatalogSDUICategoryIds.Clothing:rawValue(),
				SubcategoryId = CatalogSDUICategoryIds.Clothing_Shoes:rawValue()
			},
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.LeftShoeAccessory },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			Id = AvatarEditorSubcategories.LeftShoes
		} else nil,
		RightShoes = if not GetFFlagAXEnableSlotBasedEditor() then {
			Name = "Right Shoes",
			Title = "Feature.Avatar.Label.RightShoes",
			IconOn = "icons/menu/clothing/shoes_on",
			IconOff = "icons/menu/clothing/shoes_off",
			RenderItemTiles = true,
			Category = 2,
			NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.RightShoes,
			CameraFocus = Constants2.FocusType.Legs,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Clothing.Shoes,
			RecommendationsType = Constants3.RecommendationsType.Shoes,
			MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
				CategoryKey = CatalogCategories.Clothing,
				SubcategoryKey = CatalogSubcategories.Shoes
			} else nil,
			MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
				CategoryId = CatalogSDUICategoryIds.Clothing:rawValue(),
				SubcategoryId = CatalogSDUICategoryIds.Clothing_Shoes:rawValue()
			},
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.RightShoeAccessory },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			Id = AvatarEditorSubcategories.RightShoes
		} else nil,
		DivisibleShoes = if not GetFFlagAXEnableSlotBasedEditor() then {
			Name = "Divisible Shoes",
			Title = "Feature.Avatar.Label.Shoes",
			IconOn = "icons/menu/clothing/shoes_on",
			IconOff = "icons/menu/clothing/shoes_off",
			RenderItemTiles = true,
			Category = 2,
			NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.DivisibleShoes,
			CameraFocus = Constants2.FocusType.Legs,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Clothing.Shoes,
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			SubButtons = {
				[1] = {
					Name = "Left",
					Title = "Feature.Avatar.Label.LeftInitial",
					AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.LeftShoeAccessory },
					SearchUuid = SearchUuid(),
					TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage()
				},
				[2] = {
					Name = "Right",
					Title = "Feature.Avatar.Label.RightInitial",
					AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.RightShoeAccessory },
					SearchUuid = SearchUuid(),
					TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage()
				}
			},
			RecommendationsType = Constants3.RecommendationsType.Shoes,
			MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
				CategoryKey = CatalogCategories.Clothing,
				SubcategoryKey = CatalogSubcategories.Shoes
			} else nil,
			MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
				CategoryId = CatalogSDUICategoryIds.Clothing:rawValue(),
				SubcategoryId = CatalogSDUICategoryIds.Clothing_Shoes:rawValue()
			},
			Id = AvatarEditorSubcategories.DivisibleShoes
		} else nil,
		ClassicShirts = {
			Name = "Classic Shirts",
			Title = "Feature.Avatar.Label.ClassicShirts",
			IconOn = "icons/menu/clothing/shirts_on",
			IconOff = "icons/menu/clothing/shirts_off",
			RenderItemTiles = true,
			Category = 2,
			NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.ClassicShirts,
			CameraFocus = Constants2.FocusType.Arms,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Clothing.ClassicShirts,
			RecommendationsType = Constants3.RecommendationsType.Asset,
			MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
				CategoryKey = CatalogCategories.Clothing,
				SubcategoryKey = CatalogSubcategories.ClassicShirts
			} else nil,
			MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
				CategoryId = CatalogSDUICategoryIds.Clothing:rawValue(),
				SubcategoryId = CatalogSDUICategoryIds.ClothingClassicShirts:rawValue()
			},
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.Shirt },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			Id = AvatarEditorSubcategories.ClassicShirts
		},
		ClassicTShirts = {
			Name = "Classic T-Shirts",
			Title = "Feature.Avatar.Label.ClassicTShirts",
			IconOn = "icons/menu/clothing/shirts_on",
			IconOff = "icons/menu/clothing/shirts_off",
			RenderItemTiles = true,
			Category = 2,
			NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.ClassicTShirts,
			CameraFocus = Constants2.FocusType.Arms,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Clothing.ClassicTShirts,
			RecommendationsType = Constants3.RecommendationsType.Asset,
			MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
				CategoryKey = CatalogCategories.Clothing,
				SubcategoryKey = CatalogSubcategories.ClassicTShirts
			} else nil,
			MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
				CategoryId = CatalogSDUICategoryIds.Clothing:rawValue(),
				SubcategoryId = CatalogSDUICategoryIds.Clothing_ClassicTShirts:rawValue()
			},
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.TShirt },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			Id = AvatarEditorSubcategories.ClassicTShirts
		},
		ClassicPants = {
			Name = "Classic Pants",
			Title = "Feature.Avatar.Label.ClassicPants",
			IconOn = "icons/menu/clothing/pants_on",
			IconOff = "icons/menu/clothing/pants_off",
			RenderItemTiles = true,
			Category = 2,
			NavigationKey = if not GetFFlagAXAddNavigationKeyToEditorSubcategories() then nil else AvatarEditorSubcategories.ClassicPants,
			CameraFocus = Constants2.FocusType.Legs,
			CameraZoomRadius = Constants.CAMERA_ZOOM_RADIUS.Clothing.ClassicPants,
			RecommendationsType = Constants3.RecommendationsType.Asset,
			MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
				CategoryKey = CatalogCategories.Clothing,
				SubcategoryKey = CatalogSubcategories.ClassicPants
			} else nil,
			MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
				CategoryId = CatalogSDUICategoryIds.Clothing:rawValue(),
				SubcategoryId = CatalogSDUICategoryIds.Clothing_ClassicPants:rawValue()
			},
			AssetTypeIdStrings = { Constants2.AssetTypeIdStrings.Pants },
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			Id = AvatarEditorSubcategories.ClassicPants
		}
	}
	local t9 = {}
	local n1 = 0

	if FFlagAXSwapOuterwearSubcategoryOrder then
		if u27[t1.Outerwear] or u27[t1.JacketAccessory] then
			n1 += 1
			t8.Outerwear.Subcategory = n1
			table.insert(t9, t8.Outerwear)
		end

		if u27[t1.Tops] then
			n1 += 1
			t8.Tops.Subcategory = n1
			table.insert(t9, t8.Tops)
		end
	else
		if u27[t1.Tops] then
			n1 += 1
			t8.Tops.Subcategory = n1
			table.insert(t9, t8.Tops)
		end

		if u27[t1.Outerwear] or u27[t1.JacketAccessory] then
			n1 += 1
			t8.Outerwear.Subcategory = n1
			table.insert(t9, t8.Outerwear)
		end
	end

	if u27[t1.Bottoms] then
		n1 += 1
		t8.Bottoms.Subcategory = n1
		table.insert(t9, t8.Bottoms)
	end

	if GetFFlagAXEnableSlotBasedEditor() then
		n1 += 1
		t8.Shoes.Subcategory = n1
		table.insert(t9, t8.Shoes)
	else
		if u27[t1.LeftShoeAccessory] then
			n1 += 1
			t8.LeftShoes.Subcategory = n1
			table.insert(t9, t8.LeftShoes)
		end

		if u27[t1.RightShoeAccessory] then
			n1 += 1
			t8.RightShoes.Subcategory = n1
			table.insert(t9, t8.RightShoes)
		end
	end

	if u27[t1.ClassicShirts] then
		n1 += 1
		t8.ClassicShirts.Subcategory = n1
		table.insert(t9, t8.ClassicShirts)
	end

	if GetFFlagAXEnableSlotBasedEditor() then
		if u27[t1.ClassicPants] then
			n1 += 1
			t8.ClassicPants.Subcategory = n1
			table.insert(t9, t8.ClassicPants)
		end

		if u27[t1.ClassicTShirts] then
			local v54 = n1 + 1

			t8.ClassicTShirts.Subcategory = v54
			table.insert(t9, t8.ClassicTShirts)
		end
	else
		if u27[t1.ClassicTShirts] then
			n1 += 1
			t8.ClassicTShirts.Subcategory = n1
			table.insert(t9, t8.ClassicTShirts)
		end

		if u27[t1.ClassicPants] then
			local v55 = n1 + 1

			t8.ClassicPants.Subcategory = v55
			table.insert(t9, t8.ClassicPants)
		end
	end

	return {
		avatarEditorCategories = {
			Name = "Clothing",
			Title = "Feature.Catalog.Label.Clothing",
			IconOn = "icons/menu/clothing/clothing_on",
			IconOff = "icons/menu/clothing/clothing_off",
			Category = 2,
			Subcategory = nil,
			CanAnimateCameraBasedMood = true,
			HideTextUnderTile = true,
			NavigationKey = if not GetFFlagAXEnableSlotBasedEditor() then nil else AvatarEditorCategories.Clothing,
			Subcategories = t9,
			SearchUuid = SearchUuid(),
			TimeToRefresh = GetFIntMinSecsToRefreshRecommendedCatalogPage(),
			Id = AvatarEditorCategories.Clothing
		},
		catalogCategories = t5
	}
end
local function getClothingCategories(p4) -- line: 958
	-- upvalues: u34 (ref), createClothingCategories (copy)
	if not u34 or p4 then
		u34 = createClothingCategories()
	end

	return u34
end

return getClothingCategories
