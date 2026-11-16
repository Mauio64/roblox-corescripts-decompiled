local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CatalogNetworking/Signals")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/CatalogNetworking/Promise")

local fetchCollectibleProductIds = require("@game/CorePackages/Workspace/Packages/_Index/CatalogNetworking/CatalogNetworking/networkRequests/fetchCollectibleProductIds")

local signal, v5 = Signals.createSignal({})

return {
	getCache = signal,
	fetchAndCache = function(p2, items)
		local v6 = signal(false)
		local v7 = {}

		for k, item in items do
			if not v6[item] then
				table.insert(v7, item)
			end
		end

		if #v7 == 0 then
			return Promise.resolve()
		end

		return fetchCollectibleProductIds(p2, v7):andThen(function(items2)
			local clone = table.clone(signal(false))

			for k, item in items2 do
				clone[item.collectibleItemId] = {
					productId = item.collectibleProductId,
					resaleProductId = item.resaleProductId
				}
			end

			v5(clone)
		end)
	end,
	getProductId = function(p2)
		local v6 = signal(false)[p2]

		if v6 then
			return v6.productId
		end

		return nil
	end,
	getResaleProductId = function(p2)
		local v6 = signal(false)[p2]

		if v6 then
			return v6.resaleProductId
		end

		return nil
	end,
	clear = function()
		v5({})
	end
}
