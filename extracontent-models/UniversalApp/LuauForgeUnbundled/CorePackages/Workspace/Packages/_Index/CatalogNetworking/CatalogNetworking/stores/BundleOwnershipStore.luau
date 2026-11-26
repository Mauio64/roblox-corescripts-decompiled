local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CatalogNetworking/Signals")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/CatalogNetworking/Promise")
local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/CatalogNetworking/Dash")

local fetchBundleOwnership = require("@game/CorePackages/Workspace/Packages/_Index/CatalogNetworking/CatalogNetworking/networkRequests/fetchBundleOwnership")

local signal, v5 = Signals.createSignal({})

return {
	getCache = signal,
	fetchAndCache = function(p2, items)
		local v6 = signal(false)
		local v7 = {}

		for k, item in items do
			if v6[tostring(item)] == nil then
				table.insert(v7, item)
			end
		end

		if #v7 == 0 then
			return Promise.resolve()
		end

		local mapped = Dash.map(v7, function(p3)
			return fetchBundleOwnership(p2, p3)
		end)

		return Promise.all(mapped):andThen(function(items2)
			local clone = table.clone(signal(false))

			for k, item in items2 do
				if item then
					clone[item.id] = item.owned
				end
			end

			v5(clone)
		end)
	end,
	isOwned = function(p2)
		return signal(false)[p2]
	end,
	clear = function()
		v5({})
	end,
	markOwned = function(items)
		local clone = table.clone(signal(false))

		for k, item in items do
			clone[item] = true
		end

		v5(clone)
	end
}
