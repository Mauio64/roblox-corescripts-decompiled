local CatalogNetworking = script:FindFirstAncestor("CatalogNetworking")
local parent = CatalogNetworking.Parent

local Signals = require(parent.Signals)
local Promise = require(parent.Promise)

local fetchCollectibleProductIds = require(CatalogNetworking.networkRequests.fetchCollectibleProductIds)

local signal, v = Signals.createSignal({})
local CollectibleProductIdStore = {}
CollectibleProductIdStore.getCache = signal

function CollectibleProductIdStore.fetchAndCache(p, items)
	local v2 = signal(false)
	local v3 = {}

	for _, item in items do
		if not v2[item] then
			table.insert(v3, item)
		end
	end

	if #v3 == 0 then
		return Promise.resolve()
	end

	return fetchCollectibleProductIds(p, v3):andThen(function(items2)
		local clone = table.clone(signal(false))

		for _, item in items2 do
			clone[item.collectibleItemId] = {
				productId = item.collectibleProductId,
				resaleProductId = item.resaleProductId
			}
		end

		v(clone)
	end)
end

function CollectibleProductIdStore.getProductId(p: string)
	local v2 = signal(false)[p]
	return if v2 then v2.productId else nil
end

function CollectibleProductIdStore.getResaleProductId(p: string)
	local v2 = signal(false)[p]
	return if v2 then v2.resaleProductId else nil
end

function CollectibleProductIdStore.clear()
	v({})
end

return CollectibleProductIdStore
