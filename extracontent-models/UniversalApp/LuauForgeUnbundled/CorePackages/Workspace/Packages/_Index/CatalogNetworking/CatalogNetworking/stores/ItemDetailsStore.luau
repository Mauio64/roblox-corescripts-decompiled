local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CatalogNetworking/Signals")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/CatalogNetworking/Promise")

require("@game/CorePackages/Workspace/Packages/_Index/CatalogNetworking/CatalogNetworking/Types")
local fetchItemDetails = require("@game/CorePackages/Workspace/Packages/_Index/CatalogNetworking/CatalogNetworking/networkRequests/fetchItemDetails")

local signal, v5 = Signals.createSignal({})

return {
	getCache = signal,
	fetchAndCache = function(p2, items)
		local v6 = signal(false)
		local v7 = {}

		for k, item in items do
			if not v6[tostring(item.id)] then
				table.insert(v7, item)
			end
		end

		if #v7 == 0 then
			return Promise.resolve()
		end

		return fetchItemDetails(p2, v7):andThen(function(p3)
			if p3 and p3.data then
				local clone = table.clone(signal(false))

				for k, v8 in p3.data do
					clone[tostring(v8.id)] = v8
				end

				v5(clone)
			end
		end)
	end,
	getItem = function(p2)
		return signal(false)[p2]
	end,
	clear = function()
		v5({})
	end
}
