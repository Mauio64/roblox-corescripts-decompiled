local module = require("@luauforge/bundled/dMx")
local module2 = require("@luauforge/bundled/dMd")
local animationCategoryCameraZoomRadius = module2.Constants.AnimationCategoryCameraZoomRadius
local recommendationsType = module2.Enums.RecommendationsType
local searchUuid = require("@luauforge/bundled/dOk").SearchUuid
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local catalogCategories = module2.Enums.CatalogCategories
local catalogSubcategories = AvatarExperienceCommon.Enums.CatalogSubcategories
local catalogSDUICategoryIds = AvatarExperienceCommon.Enums.CatalogSDUICategoryIds
local catalogCategoryKeys = AvatarExperienceCommon.Enums.CatalogCategoryKeys
local catalogSubcategoryKeys = AvatarExperienceCommon.Enums.CatalogSubcategoryKeys
local module4 = require("@luauforge/bundled/dOc")

local avatarEditorCategories = module2.Enums.AvatarEditorCategories

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev

local emotesCategory = {
	Name = module.AssetCategories.Emotes,
	Title = "Feature.Avatar.Heading.Emotes",
	IconOn = "icons/menu/clothing/emotes_on",
	IconOff = "icons/menu/clothing/emotes_off",
	CameraZoomRadius = animationCategoryCameraZoomRadius,
	NavigationKey = 0,
	EquipSlotsCount = 8,
	RenderItemTiles = true,
	PageType = 0,
	CanAnimateCameraBasedMood = false,
	RecommendationsType = 0,
	MatchingCatalogPage = 0,
	MatchingCatalogPageIds = 0,
	AssetTypeIdStrings = 0,
	SearchUuid = 0,
	Id = "Emotes",
	ShowName = true
}

local v5 = if module4() then avatarEditorCategories.Emotes else nil
emotesCategory.NavigationKey = v5

emotesCategory.PageType = module.PageType.Emotes

emotesCategory.RecommendationsType = recommendationsType.Asset
emotesCategory.MatchingCatalogPage = not fFlagAXCatalogCategoriesSDUI
	and {
		CategoryKey = catalogCategories.AllAnimations,
		SubcategoryKey = catalogSubcategories.Emotes
	}
	or nil

local v6 = if fFlagAXMigrateAllTabToSduiDev then {
	CategoryId = catalogCategoryKeys.AllAnimations,
	SubcategoryId = catalogSubcategoryKeys.Emotes
} else fFlagAXCatalogCategoriesSDUI and {
	CategoryId = catalogSDUICategoryIds.AllAnimations:rawValue(),
	SubcategoryId = catalogSDUICategoryIds.Emotes:rawValue()
} or nil
emotesCategory.MatchingCatalogPageIds = v6

emotesCategory.AssetTypeIdStrings = { module.AssetTypeIdStrings.EmoteAnimation }
emotesCategory.SearchUuid = searchUuid()

local function getEmotesCategory()
	return emotesCategory
end

return getEmotesCategory
