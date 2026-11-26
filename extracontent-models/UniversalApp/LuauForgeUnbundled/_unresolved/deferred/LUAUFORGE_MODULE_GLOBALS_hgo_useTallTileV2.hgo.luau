local CorePackages = game:GetService("CorePackages")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local catalogCategories = require("@luauforge/bundled/dPt").Enums.CatalogCategories
local catalogSubcategories = AvatarExperienceCommon.Enums.CatalogSubcategories

local module2 = require("@luauforge/bundled/dSW")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

function LUAUFORGE_MODULE_GLOBALS_hgo_useTallTileV2(p2, p3): boolean
	local catalogSelectionStore = module2.getCatalogSelectionStore()
	local catalogSearchSelectionStore = module2.getCatalogSearchSelectionStore()

	local v5 = useSignalState(catalogSelectionStore.selectedCategoryId)
	local v6 = useSignalState(catalogSelectionStore.selectedSubcategoryId)
	local v7 = useSignalState(catalogSearchSelectionStore.selectedCategoryId)
	local v8 = useSignalState(catalogSearchSelectionStore.selectedSubcategoryId)

	if not p2 then
		v7 = v5
	end

	if p2 then
		v6 = v8
	end

	return v7 == catalogCategories.AllAnimations:rawValue()
		or v7 == catalogCategories.Characters:rawValue()
		or v7 == catalogCategories.Avatars:rawValue()
		or v6 == catalogSubcategories.FullBodies:rawValue()
		or v6 == catalogSubcategories.MakeupLooks:rawValue()
end

return LUAUFORGE_MODULE_GLOBALS_hgo_useTallTileV2
