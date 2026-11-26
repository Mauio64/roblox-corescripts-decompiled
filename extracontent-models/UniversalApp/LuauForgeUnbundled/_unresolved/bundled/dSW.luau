local module = require("@luauforge/bundled/dSX")
local module2 = require("@luauforge/bundled/dTa")
local module3 = require("@luauforge/bundled/dTb")
local module4 = require("@luauforge/bundled/dTc")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local module6 = require("@luauforge/bundled/dTf")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXMigrateAllTabToSduiDev = AvatarExperienceFlags.FFlagAXMigrateAllTabToSduiDev
local fFlagSduiMarketplaceCatalogActions = SharedFlags.FFlagSduiMarketplaceCatalogActions

local catalogCategoriesStore = module()

local catalogSelectionStore = module2(catalogCategoriesStore)
local catalogSearchSelectionStore = module2(catalogCategoriesStore)

local function getCatalogCategoriesStore()
	return catalogCategoriesStore
end

local function getCatalogSelectionStore()
	return catalogSelectionStore
end

local function getCatalogSearchSelectionStore()
	return catalogSearchSelectionStore
end

local v5

if fFlagSduiMarketplaceCatalogActions then
	v5 = module4(module6.MarketplaceCatalogSduiSelectionBridge, getCatalogSelectionStore)
end

if not (fFlagAXCatalogCategoriesSDUI or fFlagAXMigrateAllTabToSduiDev) then
	module3 = nil
end

return {
	getCatalogCategoriesStore = getCatalogCategoriesStore,
	getCatalogSelectionStore = getCatalogSelectionStore,
	getCatalogSearchSelectionStore = getCatalogSearchSelectionStore,
	useDoesCatalogCategoryExist = module3,
	resetSduiSelectionBridge = v5
}
