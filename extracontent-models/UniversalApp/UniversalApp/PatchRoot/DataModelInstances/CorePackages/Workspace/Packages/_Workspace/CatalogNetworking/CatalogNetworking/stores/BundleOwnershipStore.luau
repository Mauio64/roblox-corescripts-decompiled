local CatalogNetworking = script:FindFirstAncestor("CatalogNetworking")
local CatalogNetworkingParent = CatalogNetworking.Parent
local Signals = require(CatalogNetworkingParent.Signals)
local Promise = require(CatalogNetworkingParent.Promise)
local Dash = require(CatalogNetworkingParent.Dash)
local fetchBundleOwnership = require(CatalogNetworking.networkRequests.fetchBundleOwnership)
local v7, v8 = Signals.createSignal({})

return {
	getCache = v7,
	fetchAndCache = function(p1, t1: {[any]: any}) -- line: 12
		-- upvalues: v7 (copy), Promise (copy), Dash (copy), fetchBundleOwnership (copy), v8 (copy)
		local v11 = v7(false)
		local t2 = {}

		for _, v14 in t1 do
			if v11[tostring(v14)] == nil then
				table.insert(t2, v14)
			end
		end

		if #t2 == 0 then
			return Promise.resolve()
		end

		local v15 = Dash.map(t2, function(p2) -- line: 24
			-- upvalues: fetchBundleOwnership (copy), p1 (copy)
			return fetchBundleOwnership(p1, p2)
		end)

		return Promise.all(v15):andThen(function(p3) -- line: 28
			-- upvalues: v7 (copy), v8 (copy)
			local v23 = table.clone(v7(false))

			for _, v25 in p3 do
				if v25 then
					v23[v25.id] = v25.owned
				end
			end

			v8(v23)
		end)
	end,
	isOwned = function(s1: string) -- line: 39
		-- upvalues: v7 (copy)
		return v7(false)[s1]
	end,
	clear = function() -- line: 43
		-- upvalues: v8 (copy)
		v8({})
	end,
	markOwned = function(t3: {[any]: any}) -- line: 47
		-- upvalues: v7 (copy), v8 (copy)
		local v18 = table.clone(v7(false))

		for _, v20 in t3 do
			v18[v20] = true
		end

		v8(v18)
	end
}
