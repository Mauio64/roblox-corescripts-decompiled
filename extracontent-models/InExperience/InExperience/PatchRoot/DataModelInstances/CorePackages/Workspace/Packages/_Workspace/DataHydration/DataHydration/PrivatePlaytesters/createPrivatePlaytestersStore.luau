local DataHydration = script:FindFirstAncestor("DataHydration")
local Promise = require(DataHydration.Parent.Promise)
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)

local playtestersRequests = require(script.Parent.playtestersRequests)

require(script.Parent.PrivatePlaytestersStoreTypes)

local createPlayersGetterCache = require(script.Parent.createPlayersGetterCache)

local function createPrivatePlaytestersStore(p1) -- line: 38
	-- upvalues: createDataCache (copy), createPlayersGetterCache (copy), createDataResolver (copy), playtestersRequests (copy), Promise (copy)
	local v9 = p1 or {}
	local t1 = {
		network = v9.network,
		baseUrl = v9.baseUrl
	}
	local v11 = createDataCache()
	local v12 = createPlayersGetterCache()
	local v13 = createDataResolver({
		supportsMultiGet = false,
		replaceItems = true,
		cache = v11,
		fetchFn = function(s1: string, _) -- line: 57
			-- upvalues: playtestersRequests (copy), t1 (copy)
			local num = tonumber(s1)

			return playtestersRequests.fetchPlaytesters(num, t1)
		end,
		onClear = v12.clear
	})

	return {
		MAX_INVITES = 10,
		getAndFetchInvitedPlayers = function(n1: number) -- line: 66
			-- upvalues: v13 (copy), v12 (copy)
			local v18 = v13.getAndFetchItem((tostring(n1)))

			return {
				players = v12.getFor(v18.data),
				status = v18.status
			}
		end,
		sendInvites = function(n2: number, t2: {[any]: any}, _: string?) -- line: 77
			-- upvalues: playtestersRequests (copy), t1 (copy), v11 (copy), Promise (copy)
			return playtestersRequests.fetchPlaytesters(n2, t1):andThen(function(t3: {[any]: any}) -- line: 78
				-- upvalues: t2 (copy), v11 (copy), n2 (copy), Promise (copy), playtestersRequests (copy), t1 (copy)
				local v25 = math.max(0, 10 - #t3)
				local t4 = {}

				for _, v28 in t2 do
					if v25 <= #t4 then
						break
					end

					if table.find(t3, v28) == nil then
						table.insert(t4, v28)
					end
				end

				if #t4 == 0 then
					v11.replaceItem(tostring(n2), t3)

					return Promise.resolve(t3)
				end

				return playtestersRequests.addPlaytester(n2, t4, t1):andThen(function(t5: {[any]: any}) -- line: 104
					-- upvalues: v11 (copy), n2 (copy)
					v11.replaceItem(tostring(n2), t5)

					return t5
				end)
			end)
		end,
		removeInvite = function(n3: number, n4: number) -- line: 111
			-- upvalues: playtestersRequests (copy), t1 (copy), v11 (copy)
			return playtestersRequests.removePlaytester(n3, n4, t1):andThen(function(t6: {[any]: any}) -- line: 114
				-- upvalues: v11 (copy), n3 (copy)
				v11.replaceItem(tostring(n3), t6)

				return t6
			end)
		end
	}
end

return createPrivatePlaytestersStore
