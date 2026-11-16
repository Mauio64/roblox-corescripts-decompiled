local DataHydration = script:FindFirstAncestor("DataHydration")

local Promise = require(DataHydration.Parent.Promise)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)

local playtestersRequests = require(script.Parent.playtestersRequests)
require(script.Parent.PrivatePlaytestersStoreTypes)
local createPlayersGetterCache = require(script.Parent.createPlayersGetterCache)

local function createPrivatePlaytestersStore(options)
	local v = options or {}
	local v2 = { network = v.network, baseUrl = v.baseUrl }

	local dataCache = createDataCache()

	local playersGetterCache = createPlayersGetterCache()

	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p: string, _)
			local v3 = tonumber(p)
			return playtestersRequests.fetchPlaytesters(v3, v2)
		end,
		onClear = playersGetterCache.clear
	})

	return {
		MAX_INVITES = 10,
		getAndFetchInvitedPlayers = function(p: number)
			local fetchItem = dataResolver.getAndFetchItem((tostring(p)))
			return {
				players = playersGetterCache.getFor(fetchItem.data),
				status = fetchItem.status
			}
		end,
		sendInvites = function(p: number, items, _: string?)
			return playtestersRequests.fetchPlaytesters(p, v2):andThen(function(list)
				local v3 = math.max(0, 10 - #list)
				local v4 = {}

				for _, item in items do
					if v3 <= #v4 then
						break
					end

					if table.find(list, item) == nil then
						table.insert(v4, item)
					end
				end

				if #v4 ~= 0 then
					return playtestersRequests.addPlaytester(p, v4, v2):andThen(function(list2)
						dataCache.replaceItem(tostring(p), list2)

						local rejected = {}
						local added = {}

						for _, v5 in v4 do
							if table.find(list2, v5) == nil then
								table.insert(rejected, v5)
							else
								table.insert(added, v5)
							end
						end

						return { added = added, rejected = rejected }
					end)
				end

				dataCache.replaceItem(tostring(p), list)
				return Promise.resolve({ added = {}, rejected = {} })
			end)
		end,
		removeInvite = function(p: number, p2: number)
			return playtestersRequests.removePlaytester(p, p2, v2):andThen(function(p3)
				dataCache.replaceItem(tostring(p), p3)
				return p3
			end)
		end
	}
end

return createPrivatePlaytestersStore
