local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

local playtestersRequests = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/PrivatePlaytesters/playtestersRequests")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/PrivatePlaytesters/PrivatePlaytestersStoreTypes")
local createPlayersGetterCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/PrivatePlaytesters/createPlayersGetterCache")

local function createPrivatePlaytestersStore(options)
	local v5 = options or {}
	local v6 = { network = v5.network, baseUrl = v5.baseUrl }

	local v7 = createDataCache()

	local v8 = createPlayersGetterCache()

	local v9 = createDataResolver({
		cache = v7,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p2, p3)
			local v10 = tonumber(p2)
			return playtestersRequests.fetchPlaytesters(v10, v6)
		end,
		onClear = v8.clear
	})

	return {
		MAX_INVITES = 10,
		getAndFetchInvitedPlayers = function(p2)
			local fetchItem = v9.getAndFetchItem((tostring(p2)))
			return { players = v8.getFor(fetchItem.data), status = fetchItem.status }
		end,
		sendInvites = function(p2, items, p3)
			return playtestersRequests.fetchPlaytesters(p2, v6):andThen(function(list)
				local v10 = math.max(0, 10 - #list)
				local v11 = {}

				for k, item in items do
					if v10 <= #v11 then
						break
					end

					if table.find(list, item) == nil then
						table.insert(v11, item)
					end
				end

				if #v11 ~= 0 then
					return playtestersRequests.addPlaytester(p2, v11, v6):andThen(function(list2)
						v7.replaceItem(tostring(p2), list2)

						local v12 = {}
						local v13 = {}

						for k, v14 in v11 do
							if table.find(list2, v14) == nil then
								table.insert(v12, v14)
							else
								table.insert(v13, v14)
							end
						end

						return { added = v13, rejected = v12 }
					end)
				end

				v7.replaceItem(tostring(p2), list)
				return Promise.resolve({ added = {}, rejected = {} })
			end)
		end,
		removeInvite = function(p2, p3)
			return playtestersRequests.removePlaytester(p2, p3, v6):andThen(function(p4)
				v7.replaceItem(tostring(p2), p4)
				return p4
			end)
		end
	}
end

return createPrivatePlaytestersStore
