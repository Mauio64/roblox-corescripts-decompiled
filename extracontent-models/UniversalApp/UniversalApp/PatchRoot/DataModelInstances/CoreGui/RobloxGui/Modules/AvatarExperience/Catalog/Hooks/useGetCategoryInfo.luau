local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState

local function useGetCategoryInfo() -- line: 7
	-- upvalues: GetCatalogCategoriesStore (copy), useSignalState (copy)
	local v6 = GetCatalogCategoriesStore.getCatalogSelectionStore()

	return (useSignalState(v6.selectedCategoryInfo))
end

return useGetCategoryInfo
