local module = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Enums/AvatarEditorCategories")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Enums/AvatarEditorSubcategories")
local module3 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Enums/CatalogCategories")
local module4 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Enums/CatalogCategoryTaxonomyUUIDs")
local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Constants")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Enums/FocusType")
local module7 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Enums/HeadShape")
local module8 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Enums/InventoryOutfitType")
local module9 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Enums/ItemTypeEnum")
local module10 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Enums/ItemLicenseType")
local module11 = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Enums/RecommendationsType")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Types/CommonTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Types/DiscountType")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Types/TimedOptionType")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Types/IncludedItem")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Types/ItemExperienceData")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Types/AXItemInfo")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Types/AXCollectibleItemInfo")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Types/AXCollectibleInstance")
require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Types/WidgetContentTypes")

return {
	Constants = module5,
	Enums = {
		AvatarEditorCategories = module,
		AvatarEditorSubcategories = module2,
		CatalogCategories = module3,
		CatalogCategoryTaxonomyUUIDs = module4,
		FocusType = module6,
		HeadShape = module7,
		InventoryOutfitType = module8,
		ItemTypeEnum = module9,
		ItemLicenseType = module10,
		RecommendationsType = module11
	},
	Stores = {
		getLayeredClothingEntryPageStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Stores/LayeredClothingEntryPageStore/getLayeredClothingEntryPageStore"),
		getLayeredClothingLastSavedSortStore = require("@game/CorePackages/Workspace/Packages/_Workspace/AvatarExperienceModel/AvatarExperienceModel/Stores/LayeredClothingLastSavedSortStore/getLayeredClothingLastSavedSortStore")
	}
}
