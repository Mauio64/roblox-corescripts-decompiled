local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local Constants = require(Modules.AvatarExperience.Common.Constants)
local Constants2 = require(Modules.AvatarExperience.AvatarEditor.Constants)
local SearchUuid = require(Modules.LuaApp.SearchUuid)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local CatalogCategories = AvatarExperienceCommon.Enums.CatalogCategories
local CatalogSubcategories = AvatarExperienceCommon.Enums.CatalogSubcategories
local CatalogSDUICategoryIds = AvatarExperienceCommon.Enums.CatalogSDUICategoryIds
local GetFFlagAXEnableSlotBasedEditor = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableSlotBasedEditor)
local AvatarEditorCategories = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor).Enums.AvatarEditorCategories
local FFlagAXCatalogCategoriesSDUI = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXCatalogCategoriesSDUI
local t1 = {
	Title = "Feature.Avatar.Heading.Emotes",
	IconOn = "icons/menu/clothing/emotes_on",
	IconOff = "icons/menu/clothing/emotes_off",
	EquipSlotsCount = 8,
	RenderItemTiles = true,
	CanAnimateCameraBasedMood = false,
	Id = "Emotes",
	ShowName = true,
	Name = Constants.AssetCategories.Emotes,
	CameraZoomRadius = Constants.AnimationCategoryCameraZoomRadius,
	NavigationKey = if not GetFFlagAXEnableSlotBasedEditor() then nil else AvatarEditorCategories.Emotes,
	PageType = Constants.PageType.Emotes,
	RecommendationsType = Constants2.RecommendationsType.Asset,
	MatchingCatalogPage = if not FFlagAXCatalogCategoriesSDUI then {
		CategoryKey = CatalogCategories.AllAnimations,
		SubcategoryKey = CatalogSubcategories.Emotes
	} else nil,
	MatchingCatalogPageIds = if not FFlagAXCatalogCategoriesSDUI then nil else {
		CategoryId = CatalogSDUICategoryIds.AllAnimations:rawValue(),
		SubcategoryId = CatalogSDUICategoryIds.Emotes:rawValue()
	},
	AssetTypeIdStrings = { Constants.AssetTypeIdStrings.EmoteAnimation },
	SearchUuid = SearchUuid()
}

local function getEmotesCategory() -- line: 59
	-- upvalues: t1 (copy)
	return t1
end

return getEmotesCategory
