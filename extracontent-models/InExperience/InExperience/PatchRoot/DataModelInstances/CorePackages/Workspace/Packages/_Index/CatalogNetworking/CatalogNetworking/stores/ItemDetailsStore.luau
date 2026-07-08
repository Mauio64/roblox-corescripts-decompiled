local CatalogNetworking = script:FindFirstAncestor("CatalogNetworking")
local CatalogNetworkingParent = CatalogNetworking.Parent
local Signals = require(CatalogNetworkingParent.Signals)
local Promise = require(CatalogNetworkingParent.Promise)

require(CatalogNetworking.Types)

local fetchItemDetails = require(CatalogNetworking.networkRequests.fetchItemDetails)
local v6, v7 = Signals.createSignal({})

return {
	getCache = v6,
	fetchAndCache = function(p1, t1: {[any]: any}) -- line: 14
		-- upvalues: v6 (copy), Promise (copy), fetchItemDetails (copy), v7 (copy)
		local v10 = v6(false)
		local t2 = {}

		for _, v13 in t1 do
			if not v10[tostring(v13.id)] then
				table.insert(t2, v13)
			end
		end

		if #t2 == 0 then
			return Promise.resolve()
		end

		return fetchItemDetails(p1, t2):andThen(function(p2) -- line: 26
			-- upvalues: v6 (copy), v7 (copy)
			if p2 and p2.data then
				local v16 = table.clone(v6(false))

				for _, v18 in p2.data do
					v16[tostring(v18.id)] = v18
				end

				v7(v16)
			end
		end)
	end,
	getItem = function(s1: string) -- line: 37
		-- upvalues: v6 (copy)
		return v6(false)[s1]
	end,
	clear = function() -- line: 41
		-- upvalues: v7 (copy)
		v7({})
	end
}
