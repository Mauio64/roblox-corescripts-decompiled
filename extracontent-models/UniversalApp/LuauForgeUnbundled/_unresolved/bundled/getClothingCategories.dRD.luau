local CorePackages = game:GetService("CorePackages")

local Dash = require(CorePackages.Packages.Dash)

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local constants = AvatarExperienceCommon.Constants
local searchUuid = require("@luauforge/bundled/dRA").SearchUuid
local catalogSubcategories = AvatarExperienceCommon.Enums.CatalogSubcategories
local catalogCategoryIds = AvatarExperienceCommon.Enums.CatalogCategoryIds
local catalogSDUICategoryIds = AvatarExperienceCommon.Enums.CatalogSDUICategoryIds

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev

local module3 = require("@luauforge/bundled/dPt")
local catalogCategories = module3.Enums.CatalogCategories
local cameraZoomRadius = module3.Constants.CameraZoomRadius
local avatarEditorCategories = module3.Enums.AvatarEditorCategories
local avatarEditorSubcategories = module3.Enums.AvatarEditorSubcategories
local catalogCategoryTaxonomyUUIDs = module3.Enums.CatalogCategoryTaxonomyUUIDs
local focusType = module3.Enums.FocusType
local inventoryOutfitType = module3.Enums.InventoryOutfitType
local recommendationsType = module3.Enums.RecommendationsType

local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI

local fIntAXMinSecsToRefreshRecommendedCatalogPage = AvatarExperienceFlags.FIntAXMinSecsToRefreshRecommendedCatalogPage
local fFlagAXMigrateOutfitsToUserInventory = AvatarExperienceFlags.FFlagAXMigrateOutfitsToUserInventory

local v5 = game:DefineFastString(
	"AXCategories",
	"JacketAccessory.ClassicShirts.ClassicTShirts.ClassicPants.LeftShoeAccessory.RightShoeAccessory"
)
local v6 = Dash.collectSet(string.split(v5, "."))

local v7 = {
	Tops = "Tops",
	Outerwear = "Outerwear",
	Bottoms = "Bottoms",
	LeftShoeAccessory = "LeftShoeAccessory",
	RightShoeAccessory = "RightShoeAccessory",
	Shoes = "Shoes",
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
	Bodysuits = "Bodysuits"
}

local v8 = {
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

local function createCatalogSubcategories()
	return {
		ShirtAccessory = {
			Name = "Shirts",
			Title = "Feature.Avatar.Label.Shirts",
			CameraFocus = focusType.Arms,
			CameraZoomRadius = cameraZoomRadius.Clothing.Shirts,
			AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.ShirtAccessory },
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			Id = catalogSubcategories.Shirts:rawValue(),
			SubcategoryId = 59,
			isSubcategory = true,
			TaxonomyUuid = catalogCategoryTaxonomyUUIDs.Shirts:rawValue()
		},
		TShirtAccessory = {
			Name = "TShirts",
			Title = "Feature.Catalog.LabelTShirts",
			CameraFocus = focusType.Arms,
			CameraZoomRadius = cameraZoomRadius.Clothing.TShirts,
			AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.TShirtAccessory },
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			Id = catalogSubcategories.TShirts:rawValue(),
			SubcategoryId = 58,
			isSubcategory = true,
			TaxonomyUuid = catalogCategoryTaxonomyUUIDs.TShirts:rawValue()
		},
		SweaterAccessory = {
			Name = "Sweaters",
			Title = "Feature.Avatar.Label.Sweaters",
			CameraFocus = focusType.Arms,
			CameraZoomRadius = cameraZoomRadius.Clothing.Sweaters,
			AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.SweaterAccessory },
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			Id = catalogSubcategories.Sweaters:rawValue(),
			SubcategoryId = 62,
			isSubcategory = true,
			TaxonomyUuid = catalogCategoryTaxonomyUUIDs.Sweaters:rawValue()
		},
		JacketAccessory = {
			Name = "Jackets",
			Title = "Feature.Avatar.Label.Jackets",
			CameraFocus = focusType.Arms,
			CameraZoomRadius = cameraZoomRadius.Clothing.Jackets,
			AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.JacketAccessory },
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			Id = catalogSubcategories.Jackets:rawValue(),
			SubcategoryId = 61,
			isSubcategory = true,
			TaxonomyUuid = catalogCategoryTaxonomyUUIDs.Jackets:rawValue()
		},
		PantsAccessory = {
			Name = "Pants",
			Title = "Feature.Avatar.Label.Pants",
			CameraFocus = focusType.Legs,
			CameraZoomRadius = cameraZoomRadius.Clothing.Pants,
			AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.PantsAccessory },
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			Id = catalogSubcategories.Pants:rawValue(),
			SubcategoryId = 60,
			isSubcategory = true,
			TaxonomyUuid = catalogCategoryTaxonomyUUIDs.Pants:rawValue()
		},
		DressSkirtAccessory = {
			Name = "DressSkirt",
			Title = "Feature.Avatar.Label.DressesAndSkirts",
			AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.DressSkirtAccessory },
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			Id = catalogSubcategories.DressesAndSkirts:rawValue(),
			SubcategoryId = 65,
			isSubcategory = true,
			TaxonomyUuid = catalogCategoryTaxonomyUUIDs.DressesAndSkirts:rawValue()
		},
		ShortsAccessory = {
			Name = "Shorts",
			Title = "Feature.Avatar.Label.Shorts",
			CameraFocus = focusType.Legs,
			CameraZoomRadius = cameraZoomRadius.Clothing.Shorts,
			AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.ShortsAccessory },
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			Id = catalogSubcategories.Shorts:rawValue(),
			SubcategoryId = 63,
			isSubcategory = true,
			TaxonomyUuid = catalogCategoryTaxonomyUUIDs.Shorts:rawValue()
		},
		Shoes = {
			Name = "Shoes",
			Title = "Feature.Avatar.Label.Shoes",
			CameraFocus = focusType.Legs,
			CameraZoomRadius = cameraZoomRadius.Clothing.Shoes,
			BundleTypes = { module3.Constants.BundleTypeIdStrings.Shoes },
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			Id = catalogSubcategories.Shoes:rawValue(),
			SubcategoryId = 64,
			isSubcategory = true,
			TaxonomyUuid = catalogCategoryTaxonomyUUIDs.Shoes:rawValue()
		},
		ClassicShirts = {
			Name = "Classic Shirts",
			Title = "Feature.Avatar.Label.ClassicShirts",
			CameraFocus = focusType.Arms,
			CameraZoomRadius = cameraZoomRadius.Clothing.ClassicShirts,
			AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.Shirt },
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			Id = catalogSubcategories.ClassicShirts:rawValue(),
			SubcategoryId = 56,
			isSubcategory = true,
			TaxonomyUuid = catalogCategoryTaxonomyUUIDs.ClassicShirts:rawValue()
		},
		ClassicTShirts = {
			Name = "Classic T-Shirts",
			Title = "Feature.Avatar.Label.ClassicTShirts",
			CameraFocus = focusType.Arms,
			CameraZoomRadius = cameraZoomRadius.Clothing.ClassicTShirts,
			AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.TShirt },
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			Id = catalogSubcategories.ClassicTShirts:rawValue(),
			SubcategoryId = 55,
			isSubcategory = true,
			TaxonomyUuid = catalogCategoryTaxonomyUUIDs.ClassicTShirts:rawValue()
		},
		ClassicPants = {
			Name = "Classic Pants",
			Title = "Feature.Avatar.Label.ClassicPants",
			CameraFocus = focusType.Legs,
			CameraZoomRadius = cameraZoomRadius.Clothing.ClassicPants,
			AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.Pants },
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			Id = catalogSubcategories.ClassicPants:rawValue(),
			SubcategoryId = 57,
			isSubcategory = true,
			TaxonomyUuid = catalogCategoryTaxonomyUUIDs.ClassicPants:rawValue()
		},
		Bodysuits = {
			Name = "Bodysuits",
			Title = "Feature.Avatar.Label.Bodysuits",
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			Id = catalogSubcategories.Bodysuits:rawValue(),
			isSubcategory = true,
			TaxonomyUuid = catalogCategoryTaxonomyUUIDs.Bodysuits:rawValue()
		}
	}
end

local function buildCatalogClothingAssetTypes(data)
	local catalogClothingAssetTypes = {}

	if data.ShirtAccessory then
		table.insert(catalogClothingAssetTypes, constants.ASSET_TYPE_NAME_TO_ID_STRING.ShirtAccessory)
	end

	if data.TShirtAccessory then
		table.insert(catalogClothingAssetTypes, constants.ASSET_TYPE_NAME_TO_ID_STRING.TShirtAccessory)
	end

	if data.SweaterAccessory then
		table.insert(catalogClothingAssetTypes, constants.ASSET_TYPE_NAME_TO_ID_STRING.SweaterAccessory)
	end

	if data.JacketAccessory then
		table.insert(catalogClothingAssetTypes, constants.ASSET_TYPE_NAME_TO_ID_STRING.JacketAccessory)
	end

	if data.PantsAccessory then
		table.insert(catalogClothingAssetTypes, constants.ASSET_TYPE_NAME_TO_ID_STRING.PantsAccessory)
	end

	if data.ShortsAccessory then
		table.insert(catalogClothingAssetTypes, constants.ASSET_TYPE_NAME_TO_ID_STRING.ShortsAccessory)
	end

	if data.DressSkirtAccessory then
		table.insert(catalogClothingAssetTypes, constants.ASSET_TYPE_NAME_TO_ID_STRING.DressSkirtAccessory)
	end

	if data.LeftShoeAccessory then
		table.insert(catalogClothingAssetTypes, constants.ASSET_TYPE_NAME_TO_ID_STRING.LeftShoeAccessory)
	end

	if data.RightShoeAccessory then
		table.insert(catalogClothingAssetTypes, constants.ASSET_TYPE_NAME_TO_ID_STRING.RightShoeAccessory)
	end

	if data.ClassicShirts then
		table.insert(catalogClothingAssetTypes, constants.ASSET_TYPE_NAME_TO_ID_STRING.Shirt)
	end

	if data.ClassicTShirts then
		table.insert(catalogClothingAssetTypes, constants.ASSET_TYPE_NAME_TO_ID_STRING.TShirt)
	end

	if data.ClassicPants then
		table.insert(catalogClothingAssetTypes, constants.ASSET_TYPE_NAME_TO_ID_STRING.Pants)
	end

	return catalogClothingAssetTypes
end

local function buildCatalogSubcategoriesToUse(data, catalogSubcategories2)
	local catalogSubcategoriesToUse = {}

	if data.ShirtAccessory then
		table.insert(catalogSubcategoriesToUse, catalogSubcategories2.ShirtAccessory)
	end

	if data.TShirtAccessory then
		table.insert(catalogSubcategoriesToUse, catalogSubcategories2.TShirtAccessory)
	end

	if data.SweaterAccessory then
		table.insert(catalogSubcategoriesToUse, catalogSubcategories2.SweaterAccessory)
	end

	if data.JacketAccessory then
		table.insert(catalogSubcategoriesToUse, catalogSubcategories2.JacketAccessory)
	end

	if data.PantsAccessory then
		table.insert(catalogSubcategoriesToUse, catalogSubcategories2.PantsAccessory)
	end

	if data.DressSkirtAccessory then
		table.insert(catalogSubcategoriesToUse, catalogSubcategories2.DressSkirtAccessory)
	end

	table.insert(catalogSubcategoriesToUse, catalogSubcategories2.Bodysuits)

	if data.ShortsAccessory then
		table.insert(catalogSubcategoriesToUse, catalogSubcategories2.ShortsAccessory)
	end

	if data.LeftShoeAccessory then
		table.insert(catalogSubcategoriesToUse, catalogSubcategories2.Shoes)
	end

	if data.ClassicShirts then
		table.insert(catalogSubcategoriesToUse, catalogSubcategories2.ClassicShirts)
	end

	if data.ClassicTShirts then
		table.insert(catalogSubcategoriesToUse, catalogSubcategories2.ClassicTShirts)
	end

	if data.ClassicPants then
		table.insert(catalogSubcategoriesToUse, catalogSubcategories2.ClassicPants)
	end

	return catalogSubcategoriesToUse
end

local clothingCategories = nil
local function createClothingCategories()
	v5 = game:GetFastString("AXCategories")
	v6 = Dash.collectSet(string.split(v5, "."))
	local catalogSubcategories2 = createCatalogSubcategories()
	local catalogClothingAssetTypes = buildCatalogClothingAssetTypes(v6)

	local catalogSubcategoriesToUse = buildCatalogSubcategoriesToUse(v6, catalogSubcategories2)

	local v9 = {
		Name = "Clothing",
		Title = "Feature.Catalog.Label.Clothing",
		CanAnimateCameraBasedMood = true,
		AssetTypeIdStrings = catalogClothingAssetTypes,
		SearchUuid = searchUuid(),
		Subcategories = catalogSubcategoriesToUse,
		TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
		Id = catalogCategories.Clothing:rawValue(),
		CategoryId = catalogCategoryIds.Clothing:rawValue(),
		TaxonomyUuid = catalogCategoryTaxonomyUUIDs.Clothing:rawValue()
	}

	local v10 = {}

	if v6.ShirtAccessory then
		table.insert(v10, constants.ASSET_TYPE_NAME_TO_ID_STRING.ShirtAccessory)
	end

	if v6.TShirtAccessory then
		table.insert(v10, constants.ASSET_TYPE_NAME_TO_ID_STRING.TShirtAccessory)
	end

	if v6.SweaterAccessory then
		table.insert(v10, constants.ASSET_TYPE_NAME_TO_ID_STRING.SweaterAccessory)
	end

	local v11

	if v6.TShirtAccessory then
		v11 = constants.ASSET_TYPE_NAME_TO_ID_STRING.TShirtAccessory
	else
		v11 = v10[1]
	end

	local v12 = {}

	if v6.PantsAccessory then
		table.insert(v12, constants.ASSET_TYPE_NAME_TO_ID_STRING.PantsAccessory)
	end

	if v6.ShortsAccessory then
		table.insert(v12, constants.ASSET_TYPE_NAME_TO_ID_STRING.ShortsAccessory)
	end

	if v6.DressSkirtAccessory then
		table.insert(v12, constants.ASSET_TYPE_NAME_TO_ID_STRING.DressSkirtAccessory)
	end

	local v13

	if v6.PantsAccessory then
		v13 = constants.ASSET_TYPE_NAME_TO_ID_STRING.PantsAccessory
	else
		v13 = v12[1]
	end

	local tops = {
		Name = "Tops",
		NavigationKey = avatarEditorSubcategories.Tops,
		Title = "Feature.Catalog.Label.Tops",
		IconOn = "icons/menu/clothing/shirts_on",
		IconOff = "icons/menu/clothing/shirts_off",
		RecommendedAssetTypeIdString = v11,
		RenderItemTiles = true,
		CameraFocus = focusType.Arms,
		CameraZoomRadius = cameraZoomRadius.Clothing.Tops,
		RecommendationsType = recommendationsType.Asset,
		MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
			CategoryKey = catalogCategories.Clothing,
			SubcategoryKey = catalogSubcategories.Shirts
		} or nil,
		MatchingCatalogPageIds = 0,
		AssetTypeIdStrings = 0,
		SearchUuid = 0,
		Category = 2,
		TimeToRefresh = 0,
		Id = 0
	}

	local v15 = if fFlagAXMigrateAllTabToSduiDev then {
		CategoryId = catalogCategories.Clothing:rawValue(),
		SubcategoryId = catalogSubcategories.Shirts:rawValue()
	} else fFlagAXCatalogCategoriesSDUI and {
		CategoryId = catalogSDUICategoryIds.Clothing:rawValue(),
		SubcategoryId = catalogSDUICategoryIds.Clothing_Shirts:rawValue()
	} or nil
	tops.MatchingCatalogPageIds = v15

	tops.AssetTypeIdStrings = v10
	tops.SearchUuid = searchUuid()

	tops.TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage
	tops.Id = avatarEditorSubcategories.Tops

	local outerwear = {
		Name = "Outerwear",
		NavigationKey = avatarEditorSubcategories.Outerwear,
		Title = "Feature.Avatar.Label.Outerwear",
		IconOn = "icons/menu/clothing/jackets_on",
		IconOff = "icons/menu/clothing/jackets_off",
		RenderItemTiles = true,
		CameraFocus = focusType.Arms,
		CameraZoomRadius = cameraZoomRadius.Clothing.Outerwear,
		RecommendationsType = recommendationsType.Asset,
		MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
			CategoryKey = catalogCategories.Clothing,
			SubcategoryKey = catalogSubcategories.Jackets
		} or nil,
		MatchingCatalogPageIds = 0,
		AssetTypeIdStrings = 0,
		SearchUuid = 0,
		Category = 2,
		TimeToRefresh = 0,
		Id = 0
	}

	local v16 = if fFlagAXMigrateAllTabToSduiDev then {
		CategoryId = catalogCategories.Clothing:rawValue(),
		SubcategoryId = catalogSubcategories.Jackets:rawValue()
	} else fFlagAXCatalogCategoriesSDUI and {
		CategoryId = catalogSDUICategoryIds.Clothing:rawValue(),
		SubcategoryId = catalogSDUICategoryIds.Clothing_Jackets:rawValue()
	} or nil
	outerwear.MatchingCatalogPageIds = v16

	outerwear.AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.JacketAccessory }

	outerwear.SearchUuid = searchUuid()

	outerwear.TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage
	outerwear.Id = avatarEditorSubcategories.Outerwear

	local bottoms = {
		Name = "Bottoms",
		NavigationKey = avatarEditorSubcategories.Bottoms,
		Title = "Feature.Avatar.Label.Bottoms",
		IconOn = "icons/menu/clothing/pants_on",
		IconOff = "icons/menu/clothing/pants_off",
		RecommendedAssetTypeIdString = v13,
		RenderItemTiles = true,
		CameraFocus = focusType.Legs,
		CameraZoomRadius = cameraZoomRadius.Clothing.Bottoms,
		RecommendationsType = recommendationsType.Asset,
		MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
			CategoryKey = catalogCategories.Clothing,
			SubcategoryKey = catalogSubcategories.Pants
		} or nil,
		MatchingCatalogPageIds = 0,
		AssetTypeIdStrings = 0,
		SearchUuid = 0,
		Category = 2,
		TimeToRefresh = 0,
		Id = 0
	}

	local v17 = if fFlagAXMigrateAllTabToSduiDev then {
		CategoryId = catalogCategories.Clothing:rawValue(),
		SubcategoryId = catalogSubcategories.Pants:rawValue()
	} else fFlagAXCatalogCategoriesSDUI and {
		CategoryId = catalogSDUICategoryIds.Clothing:rawValue(),
		SubcategoryId = catalogSDUICategoryIds.Clothing_Pants:rawValue()
	} or nil
	bottoms.MatchingCatalogPageIds = v17

	bottoms.AssetTypeIdStrings = v12
	bottoms.SearchUuid = searchUuid()

	bottoms.TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage
	bottoms.Id = avatarEditorSubcategories.Bottoms

	local shoes = {
		Name = "Shoes",
		NavigationKey = avatarEditorSubcategories.Shoes,
		Title = "Feature.Avatar.Label.Shoes",
		IconOn = "icons/menu/clothing/shoes_on",
		IconOff = "icons/menu/clothing/shoes_off",
		RenderItemTiles = true,
		RenderOutfitItemTiles = true,
		CameraFocus = focusType.Legs,
		CameraZoomRadius = cameraZoomRadius.Clothing.Shoes,
		RecommendationsType = recommendationsType.Shoes,
		MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
			CategoryKey = catalogCategories.Clothing,
			SubcategoryKey = catalogSubcategories.Shoes
		} or nil,
		MatchingCatalogPageIds = 0,
		SearchUuid = 0,
		Category = 2,
		TimeToRefresh = 0,
		BundleTypeIdStrings = 0,
		InventoryOutfitTypes = 0,
		SubcategoryFiltersHeader = "Feature.Catalog.Heading.ShowShoes",
		SubcategoryFilters = 0,
		Id = 0
	}

	local v18 = if fFlagAXMigrateAllTabToSduiDev then {
		CategoryId = catalogCategories.Clothing:rawValue(),
		SubcategoryId = catalogSubcategories.Shoes:rawValue()
	} else fFlagAXCatalogCategoriesSDUI and {
		CategoryId = catalogSDUICategoryIds.Clothing:rawValue(),
		SubcategoryId = catalogSDUICategoryIds.Clothing_Shoes:rawValue()
	} or nil
	shoes.MatchingCatalogPageIds = v18

	shoes.SearchUuid = searchUuid()

	shoes.TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage

	shoes.BundleTypeIdStrings = { module3.Constants.BundleTypeIdStrings.Shoes }
	shoes.InventoryOutfitTypes = fFlagAXMigrateOutfitsToUserInventory and { inventoryOutfitType.Shoes }
		or nil

	shoes.SubcategoryFilters = {
		{
			Name = "Full Pairs",
			Title = "Feature.Avatar.Label.FullPair",
			NavigationKey = avatarEditorSubcategories.ShoesPairs,
			BundleTypeIdStrings = { module3.Constants.BundleTypeIdStrings.Shoes },
			InventoryOutfitTypes = fFlagAXMigrateOutfitsToUserInventory and { inventoryOutfitType.Shoes } or nil,
			RenderOutfitItemTiles = true,
			SearchUuid = searchUuid()
		},
		{
			Name = "Left Shoes",
			Title = "Feature.Avatar.Label.LeftShoe",
			NavigationKey = avatarEditorSubcategories.LeftShoes,
			AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.LeftShoeAccessory },
			SearchUuid = searchUuid()
		},
		{
			Name = "Right Shoes",
			Title = "Feature.Avatar.Label.RightShoe",
			NavigationKey = avatarEditorSubcategories.RightShoes,
			AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.RightShoeAccessory },
			SearchUuid = searchUuid()
		}
	}

	shoes.Id = avatarEditorSubcategories.Shoes

	local classicShirts = {
		Name = "Classic Shirts",
		NavigationKey = avatarEditorSubcategories.ClassicShirts,
		Title = "Feature.Avatar.Label.ClassicShirts",
		IconOn = "icons/menu/clothing/shirts_on",
		IconOff = "icons/menu/clothing/shirts_off",
		RenderItemTiles = true,
		CameraFocus = focusType.Arms,
		CameraZoomRadius = cameraZoomRadius.Clothing.ClassicShirts,
		RecommendationsType = recommendationsType.Asset,
		MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
			CategoryKey = catalogCategories.Clothing,
			SubcategoryKey = catalogSubcategories.ClassicShirts
		} or nil,
		MatchingCatalogPageIds = 0,
		AssetTypeIdStrings = 0,
		SearchUuid = 0,
		Category = 2,
		TimeToRefresh = 0,
		Id = 0
	}

	local v19 = if fFlagAXMigrateAllTabToSduiDev then {
		CategoryId = catalogCategories.Clothing:rawValue(),
		SubcategoryId = catalogSubcategories.ClassicShirts:rawValue()
	} else fFlagAXCatalogCategoriesSDUI and {
		CategoryId = catalogSDUICategoryIds.Clothing:rawValue(),
		SubcategoryId = catalogSDUICategoryIds.ClothingClassicShirts:rawValue()
	} or nil
	classicShirts.MatchingCatalogPageIds = v19

	classicShirts.AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.Shirt }
	classicShirts.SearchUuid = searchUuid()

	classicShirts.TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage
	classicShirts.Id = avatarEditorSubcategories.ClassicShirts

	local classicTShirts = {
		Name = "Classic T-Shirts",
		NavigationKey = avatarEditorSubcategories.ClassicTShirts,
		Title = "Feature.Avatar.Label.ClassicTShirts",
		IconOn = "icons/menu/clothing/shirts_on",
		IconOff = "icons/menu/clothing/shirts_off",
		RenderItemTiles = true,
		CameraFocus = focusType.Arms,
		CameraZoomRadius = cameraZoomRadius.Clothing.ClassicTShirts,
		RecommendationsType = recommendationsType.Asset,
		MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
			CategoryKey = catalogCategories.Clothing,
			SubcategoryKey = catalogSubcategories.ClassicTShirts
		} or nil,
		MatchingCatalogPageIds = 0,
		AssetTypeIdStrings = 0,
		SearchUuid = 0,
		Category = 2,
		TimeToRefresh = 0,
		Id = 0
	}

	local v20 = if fFlagAXMigrateAllTabToSduiDev then {
		CategoryId = catalogCategories.Clothing:rawValue(),
		SubcategoryId = catalogSubcategories.ClassicTShirts:rawValue()
	} else fFlagAXCatalogCategoriesSDUI and {
		CategoryId = catalogSDUICategoryIds.Clothing:rawValue(),
		SubcategoryId = catalogSDUICategoryIds.Clothing_ClassicTShirts:rawValue()
	} or nil
	classicTShirts.MatchingCatalogPageIds = v20

	classicTShirts.AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.TShirt }
	classicTShirts.SearchUuid = searchUuid()

	classicTShirts.TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage
	classicTShirts.Id = avatarEditorSubcategories.ClassicTShirts

	local classicPants = {
		Name = "Classic Pants",
		NavigationKey = avatarEditorSubcategories.ClassicPants,
		Title = "Feature.Avatar.Label.ClassicPants",
		IconOn = "icons/menu/clothing/pants_on",
		IconOff = "icons/menu/clothing/pants_off",
		RenderItemTiles = true,
		CameraFocus = focusType.Legs,
		CameraZoomRadius = cameraZoomRadius.Clothing.ClassicPants,
		RecommendationsType = recommendationsType.Asset,
		MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI and {
			CategoryKey = catalogCategories.Clothing,
			SubcategoryKey = catalogSubcategories.ClassicPants
		} or nil,
		MatchingCatalogPageIds = 0,
		AssetTypeIdStrings = 0,
		SearchUuid = 0,
		Category = 2,
		TimeToRefresh = 0,
		Id = 0
	}

	local v21 = if fFlagAXMigrateAllTabToSduiDev then {
		CategoryId = catalogCategories.Clothing:rawValue(),
		SubcategoryId = catalogSubcategories.ClassicPants:rawValue()
	} else fFlagAXCatalogCategoriesSDUI and {
		CategoryId = catalogSDUICategoryIds.Clothing:rawValue(),
		SubcategoryId = catalogSDUICategoryIds.Clothing_ClassicPants:rawValue()
	} or nil
	classicPants.MatchingCatalogPageIds = v21

	classicPants.AssetTypeIdStrings = { constants.ASSET_TYPE_NAME_TO_ID_STRING.Pants }
	classicPants.SearchUuid = searchUuid()

	classicPants.TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage
	classicPants.Id = avatarEditorSubcategories.ClassicPants
	local v14 = {
		["Tops"] = tops,
		Outerwear = outerwear,
		Bottoms = bottoms,
		Shoes = shoes,
		ClassicShirts = classicShirts,
		ClassicTShirts = classicTShirts,
		ClassicPants = classicPants
	}

	local v22 = {}
	local count = 0

	if v6.Tops then
		count += 1
		v14.Tops.Subcategory = count
		table.insert(v22, v14.Tops)
	end

	if v6.Outerwear or v6.JacketAccessory then
		count += 1
		v14.Outerwear.Subcategory = count
		table.insert(v22, v14.Outerwear)
	end

	if v6.Bottoms then
		count += 1
		v14.Bottoms.Subcategory = count
		table.insert(v22, v14.Bottoms)
	end

	local v23 = count + 1
	v14.Shoes.Subcategory = v23
	table.insert(v22, v14.Shoes)

	if v6.ClassicShirts then
		v23 += 1
		v14.ClassicShirts.Subcategory = v23
		table.insert(v22, v14.ClassicShirts)
	end

	if v6.ClassicPants then
		v23 += 1
		v14.ClassicPants.Subcategory = v23
		table.insert(v22, v14.ClassicPants)
	end

	if v6.ClassicTShirts then
		local v24 = v23 + 1
		v14.ClassicTShirts.Subcategory = v24
		table.insert(v22, v14.ClassicTShirts)
	end

	return {
		avatarEditorCategories = {
			Name = "Clothing",
			NavigationKey = avatarEditorCategories.Clothing,
			Title = "Feature.Catalog.Label.Clothing",
			IconOn = "icons/menu/clothing/clothing_on",
			IconOff = "icons/menu/clothing/clothing_off",
			Category = 2,
			Subcategory = nil,
			Subcategories = v22,
			CanAnimateCameraBasedMood = true,
			SearchUuid = searchUuid(),
			TimeToRefresh = fIntAXMinSecsToRefreshRecommendedCatalogPage,
			HideTextUnderTile = true,
			Id = avatarEditorCategories.Clothing
		},
		catalogCategories = v9
	}
end

local function getClothingCategories(p2)
	if not clothingCategories or p2 then
		clothingCategories = createClothingCategories()
	end

	return clothingCategories
end

return getClothingCategories
