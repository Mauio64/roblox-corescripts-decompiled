local AvatarEditorCategories = require(script.Enums.AvatarEditorCategories)
local AvatarEditorSubcategories = require(script.Enums.AvatarEditorSubcategories)
local CatalogCategories = require(script.Enums.CatalogCategories)
local CatalogCategoryTaxonomyUUIDs = require(script.Enums.CatalogCategoryTaxonomyUUIDs)
local Constants = require(script.Constants)
local FocusType = require(script.Enums.FocusType)
local HeadShape = require(script.Enums.HeadShape)
local InventoryOutfitType = require(script.Enums.InventoryOutfitType)
local ItemTypeEnum = require(script.Enums.ItemTypeEnum)
local ItemLicenseType = require(script.Enums.ItemLicenseType)
local RecommendationsType = require(script.Enums.RecommendationsType)
require(script.Types.CommonTypes)
require(script.Types.DiscountType)
require(script.Types.TimedOptionType)
require(script.Types.IncludedItem)
require(script.Types.ItemExperienceData)
require(script.Types.AXItemInfo)
require(script.Types.AXCollectibleItemInfo)
require(script.Types.AXCollectibleInstance)
require(script.Types.WidgetContentTypes)

return {
	["jest.config"] = script["jest.config"],
	Constants = Constants,
	Enums = {
		AvatarEditorCategories = AvatarEditorCategories,
		AvatarEditorSubcategories = AvatarEditorSubcategories,
		CatalogCategories = CatalogCategories,
		CatalogCategoryTaxonomyUUIDs = CatalogCategoryTaxonomyUUIDs,
		FocusType = FocusType,
		HeadShape = HeadShape,
		InventoryOutfitType = InventoryOutfitType,
		ItemTypeEnum = ItemTypeEnum,
		ItemLicenseType = ItemLicenseType,
		RecommendationsType = RecommendationsType
	},
	Stores = {
		getLayeredClothingEntryPageStore = require(script.Stores.LayeredClothingEntryPageStore.getLayeredClothingEntryPageStore),
		getLayeredClothingLastSavedSortStore = require(script.Stores.LayeredClothingLastSavedSortStore.getLayeredClothingLastSavedSortStore)
	}
}
