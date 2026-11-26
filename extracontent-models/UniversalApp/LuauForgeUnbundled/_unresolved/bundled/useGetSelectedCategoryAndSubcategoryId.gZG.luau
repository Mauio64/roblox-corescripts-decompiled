local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dSW")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local function useGetSelectedCategoryAndSubcategoryId()
	local catalogSelectionStore = module.getCatalogSelectionStore()

	return
		useSignalState(catalogSelectionStore.selectedCategoryId),
		(useSignalState(catalogSelectionStore.selectedSubcategoryId))
end

return useGetSelectedCategoryAndSubcategoryId
