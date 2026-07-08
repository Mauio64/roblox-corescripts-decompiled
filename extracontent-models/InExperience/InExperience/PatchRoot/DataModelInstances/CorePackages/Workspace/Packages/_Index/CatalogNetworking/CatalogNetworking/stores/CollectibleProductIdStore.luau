local CatalogNetworking = script:FindFirstAncestor("CatalogNetworking")
local CatalogNetworkingParent = CatalogNetworking.Parent
local Signals = require(CatalogNetworkingParent.Signals)
local Promise = require(CatalogNetworkingParent.Promise)
local fetchCollectibleProductIds = require(CatalogNetworking.networkRequests.fetchCollectibleProductIds)
local v6, v7 = Signals.createSignal({})

return {
	getCache = v6,
	fetchAndCache = function(p1, t1: {[any]: any}) -- line: 16
		-- upvalues: v6 (copy), Promise (copy), fetchCollectibleProductIds (copy), v7 (copy)
		local v10 = v6(false)
		local t2 = {}

		for _, v13 in t1 do
			if not v10[v13] then
				table.insert(t2, v13)
			end
		end

		if #t2 == 0 then
			return Promise.resolve()
		end

		return fetchCollectibleProductIds(p1, t2):andThen(function(p2) -- line: 28
			-- upvalues: v6 (copy), v7 (copy)
			local v19 = table.clone(v6(false))

			for _, v21 in p2 do
				v19[v21.collectibleItemId] = {
					productId = v21.collectibleProductId,
					resaleProductId = v21.resaleProductId
				}
			end

			v7(v19)
		end)
	end,
	getProductId = function(s1: string) -- line: 40
		-- upvalues: v6 (copy)
		local v15 = v6(false)[s1]

		if v15 then
			return v15.productId
		end

		return nil
	end,
	getResaleProductId = function(s2: string) -- line: 45
		-- upvalues: v6 (copy)
		local v17 = v6(false)[s2]

		if v17 then
			return v17.resaleProductId
		end

		return nil
	end,
	clear = function() -- line: 50
		-- upvalues: v7 (copy)
		v7({})
	end
}
