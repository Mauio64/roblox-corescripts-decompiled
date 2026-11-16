local module = require("@luauforge/deferred/gjp")

local useFoldersStore = require("@luauforge/deferred/gjo").useFoldersStore

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
