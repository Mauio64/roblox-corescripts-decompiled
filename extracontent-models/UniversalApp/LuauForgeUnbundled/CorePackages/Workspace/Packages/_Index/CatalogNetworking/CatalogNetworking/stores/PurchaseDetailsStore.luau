local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CatalogNetworking/Signals")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/CatalogNetworking/Promise")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/CatalogNetworking/Dash")

require("@game/CorePackages/Workspace/Packages/_Index/CatalogNetworking/CatalogNetworking/Types")
local fetchPurchaseDetails = require("@game/CorePackages/Workspace/Packages/_Index/CatalogNetworking/CatalogNetworking/networkRequests/fetchPurchaseDetails")

local signal, v5 = Signals.createSignal({})

local function mergeResponse(p2)
	if p2 and p2.look and p2.look.items then
		local clone = table.clone(signal(false))

		for k, item in p2.look.items do
			clone[tostring(item.id)] = item
		end

		v5(clone)
	end

	return p2
end

return {
	getCache = signal,
	fetchAndCache = function(p2, p3)
		local v6 = signal(false)
		local filtered = Dash.filter(p3, function(p4): boolean
			return not v6[tostring(p4.id)]
		end)

		if #filtered == 0 then
			return Promise.resolve()
		end

		return fetchPurchaseDetails(p2, filtered):andThen(mergeResponse)
	end,
	fetchAll = function(p2, p3)
		return fetchPurchaseDetails(p2, p3):andThen(mergeResponse)
	end,
	getItem = function(p2)
		return signal(false)[p2]
	end,
	clear = function()
		v5({})
	end,
	markItemsOwned = function(items)
		local clone = table.clone(signal(false))

		for k, item in items do
			if not clone[item] then
				continue
			end

			local clone2 = table.clone(clone[item])
			clone2.quantityOwned = (clone2.quantityOwned or 0) + 1
			clone2.isPurchasable = false
			clone[item] = clone2
		end

		v5(clone)
	end
}
