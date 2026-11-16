local CatalogNetworking = script:FindFirstAncestor("CatalogNetworking")
local parent = CatalogNetworking.Parent

local Signals = require(parent.Signals)
local Promise = require(parent.Promise)

require(CatalogNetworking.Types)
local fetchItemDetails = require(CatalogNetworking.networkRequests.fetchItemDetails)

local signal, v = Signals.createSignal({})
local ItemDetailsStore = {}
ItemDetailsStore.getCache = signal

function ItemDetailsStore.fetchAndCache(p, items)
	local v2 = signal(false)
	local v3 = {}

	for _, item in items do
		if not v2[tostring(item.id)] then
			table.insert(v3, item)
		end
	end

	if #v3 == 0 then
		return Promise.resolve()
	end

	return fetchItemDetails(p, v3):andThen(function(p2)
		if p2 and p2.data then
			local clone = table.clone(signal(false))

			for _, v4 in p2.data do
				clone[tostring(v4.id)] = v4
			end

			v(clone)
		end
	end)
end

function ItemDetailsStore.getItem(p: string)
	return signal(false)[p]
end

function ItemDetailsStore.clear()
	v({})
end

return ItemDetailsStore
