local CorePackages = game:GetService("CorePackages")

local module = require("@luauforge/bundled/dPG")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local function useGetCategoryInfo()
	return (useSignalState(module.getCatalogSelectionStore().selectedCategoryInfo))
end

return useGetCategoryInfo
