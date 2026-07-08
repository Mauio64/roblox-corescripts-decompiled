local CatalogNetworking = script:FindFirstAncestor("CatalogNetworking")
local CatalogNetworkingParent = CatalogNetworking.Parent
local Signals = require(CatalogNetworkingParent.Signals)
local Promise = require(CatalogNetworkingParent.Promise)
local Dash = require(CatalogNetworkingParent.Dash)

require(CatalogNetworking.Types)

local fetchPurchaseDetails = require(CatalogNetworking.networkRequests.fetchPurchaseDetails)
local v7, v8 = Signals.createSignal({})

local function mergeResponse(p1) -- line: 15
	-- upvalues: v7 (copy), v8 (copy)
	if p1 and (p1.look and p1.look.items) then
		local v11 = table.clone(v7(false))

		for _, v13 in p1.look.items do
			v11[tostring(v13.id)] = v13
		end

		v8(v11)
	end

	return p1
end

return {
	getCache = v7,
	fetchAndCache = function(p2, t1: {[any]: any}) -- line: 26
		-- upvalues: v7 (copy), Dash (copy), Promise (copy), fetchPurchaseDetails (copy), mergeResponse (copy)
		local v16 = v7(false)
		local v17 = Dash.filter(t1, function(p3) -- line: 28
			-- upvalues: v16 (copy)
			return not v16[tostring(p3.id)]
		end)

		if #v17 == 0 then
			return Promise.resolve()
		end

		return fetchPurchaseDetails(p2, v17):andThen(mergeResponse)
	end,
	fetchAll = function(p4, t2: {[any]: any}) -- line: 37
		-- upvalues: fetchPurchaseDetails (copy), mergeResponse (copy)
		return fetchPurchaseDetails(p4, t2):andThen(mergeResponse)
	end,
	getItem = function(s1: string) -- line: 41
		-- upvalues: v7 (copy)
		return v7(false)[s1]
	end,
	clear = function() -- line: 45
		-- upvalues: v8 (copy)
		v8({})
	end,
	markItemsOwned = function(t3: {[any]: any}) -- line: 49
		-- upvalues: v7 (copy), v8 (copy)
		local v22 = table.clone(v7(false))

		for _, v24 in t3 do
			if v22[v24] then
				local v25 = table.clone(v22[v24])

				v25.quantityOwned = (v25.quantityOwned or 0) + 1
				v25.isPurchasable = false
				v22[v24] = v25
			end
		end

		v8(v22)
	end
}
