local module = require("@luauforge/deferred/gNV")

local useFoldersStore = require("@luauforge/deferred/gNU").useFoldersStore

local function useReconcileDeletedOutfits()
	local v5 = useFoldersStore()

	return {
		reconcile = module.useCallback(function(items)
			for k, item in items do
				v5.removeOutfitFromAllFolders(item)
			end
		end, { v5 })
	}
end

return useReconcileDeletedOutfits
