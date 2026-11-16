local CatalogNetworking = script:FindFirstAncestor("CatalogNetworking")
local parent = CatalogNetworking.Parent

local Signals = require(parent.Signals)
local Promise = require(parent.Promise)
local Dash = require(parent.Dash)

require(CatalogNetworking.Types)
local fetchPurchaseDetails = require(CatalogNetworking.networkRequests.fetchPurchaseDetails)

local signal, v = Signals.createSignal({})

local function mergeResponse(p)
	if p and p.look and p.look.items then
		local clone = table.clone(signal(false))

		for _, item in p.look.items do
			clone[tostring(item.id)] = item
		end

		v(clone)
	end

	return p
end

local PurchaseDetailsStore = {}
PurchaseDetailsStore.getCache = signal

function PurchaseDetailsStore.fetchAndCache(p, p2)
	local v2 = signal(false)
	local filtered = Dash.filter(p2, function(p3): boolean
		return not v2[tostring(p3.id)]
	end)

	if #filtered == 0 then
		return Promise.resolve()
	end

	return fetchPurchaseDetails(p, filtered):andThen(mergeResponse)
end

function PurchaseDetailsStore.fetchAll(p, p2)
	return fetchPurchaseDetails(p, p2):andThen(mergeResponse)
end

function PurchaseDetailsStore.getItem(p: string)
	return signal(false)[p]
end

function PurchaseDetailsStore.clear()
	v({})
end

function PurchaseDetailsStore.markItemsOwned(items)
	local clone = table.clone(signal(false))

	for _, item in items do
		if not clone[item] then
			continue
		end

		local clone2 = table.clone(clone[item])
		clone2.quantityOwned = (clone2.quantityOwned or 0) + 1
		clone2.isPurchasable = false
		clone[item] = clone2
	end

	v(clone)
end

return PurchaseDetailsStore
