local CatalogNetworking = script:FindFirstAncestor("CatalogNetworking")
local parent = CatalogNetworking.Parent

local Signals = require(parent.Signals)
local Promise = require(parent.Promise)
local Dash = require(parent.Dash)

local fetchBundleOwnership = require(CatalogNetworking.networkRequests.fetchBundleOwnership)

local signal, v = Signals.createSignal({})
local BundleOwnershipStore = {}
BundleOwnershipStore.getCache = signal

function BundleOwnershipStore.fetchAndCache(p, items)
	local v2 = signal(false)
	local v3 = {}

	for _, item in items do
		if v2[tostring(item)] == nil then
			table.insert(v3, item)
		end
	end

	if #v3 == 0 then
		return Promise.resolve()
	end

	local mapped = Dash.map(v3, function(p2)
		return fetchBundleOwnership(p, p2)
	end)

	return Promise.all(mapped):andThen(function(items2)
		local clone = table.clone(signal(false))

		for _, item in items2 do
			if item then
				clone[item.id] = item.owned
			end
		end

		v(clone)
	end)
end

function BundleOwnershipStore.isOwned(p: string)
	return signal(false)[p]
end

function BundleOwnershipStore.clear()
	v({})
end

function BundleOwnershipStore.markOwned(items)
	local clone = table.clone(signal(false))

	for _, item in items do
		clone[item] = true
	end

	v(clone)
end

return BundleOwnershipStore
