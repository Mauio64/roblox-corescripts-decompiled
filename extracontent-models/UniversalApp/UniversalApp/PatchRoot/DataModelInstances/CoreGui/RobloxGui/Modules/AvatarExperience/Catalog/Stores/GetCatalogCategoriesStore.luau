local createCatalogCategoriesStore = require(script.createCatalogCategoriesStore)
local createCategorySelectionStore = require(script.Parent.GetCategorySelectionStore.createCategorySelectionStore)
local useDoesCatalogCategoryExist = require(script.useDoesCatalogCategoryExist)
local registerSduiSelectionBridge = require(script.registerSduiSelectionBridge)
local CorePackages = game:GetService("CorePackages")
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local AvatarExperienceServerDrivenUi = require(CorePackages.Workspace.Packages.AvatarExperienceServerDrivenUi)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local FFlagSduiMarketplaceCatalogActions = SharedFlags.FFlagSduiMarketplaceCatalogActions
local v11 = createCatalogCategoriesStore()
local v12 = createCategorySelectionStore(v11)
local v13 = createCategorySelectionStore(v11)
local v14 = nil

if FFlagSduiMarketplaceCatalogActions then
	v14 = registerSduiSelectionBridge(AvatarExperienceServerDrivenUi.MarketplaceCatalogSduiSelectionBridge, v12)
end

return {
	getCatalogCategoriesStore = function() -- line: 35
		-- upvalues: v11 (copy)
		return v11
	end,
	getCatalogSelectionStore = function() -- line: 38
		-- upvalues: v12 (copy)
		return v12
	end,
	getCatalogSearchSelectionStore = function() -- line: 41
		-- upvalues: v13 (copy)
		return v13
	end,
	useDoesCatalogCategoryExist = if not FFlagAXCatalogCategoriesSDUI then nil else useDoesCatalogCategoryExist,
	resetSduiSelectionBridge = v14
}
