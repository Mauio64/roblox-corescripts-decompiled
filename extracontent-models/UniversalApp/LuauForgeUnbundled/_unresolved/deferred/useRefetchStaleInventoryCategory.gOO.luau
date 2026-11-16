local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getStaleInventoryGrantStore = require("@luauforge/bundled/fuM").Stores.getStaleInventoryGrantStore

local function useRefetchStaleInventoryCategory(p2, data, callback)
	local staleInventoryGrantStore = getStaleInventoryGrantStore()
	local v5 = useSignalState(staleInventoryGrantStore.getStaleSearchUuids)[p2] == true

	React.useEffect(function()
		if not (v5 and data) then
			return
		end

		if callback then
			local removedItemIds = staleInventoryGrantStore.getRemovedItemIds(p2)

			if removedItemIds then
				data.removeItems(removedItemIds)
			end

			data.startRefresh()
			staleInventoryGrantStore.clearSearchUuidStale(p2)
			callback()
		else
			data.startNewSearch()
			staleInventoryGrantStore.clearSearchUuidStale(p2)
		end
	end, { v5, p2, data, staleInventoryGrantStore, callback })
end

return useRefetchStaleInventoryCategory
