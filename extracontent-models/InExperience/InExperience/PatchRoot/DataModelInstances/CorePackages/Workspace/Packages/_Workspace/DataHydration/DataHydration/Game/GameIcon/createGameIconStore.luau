local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Dash = require(DataHydrationParent.Dash)
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)

local fetchGameIcons = require(script.Parent.fetchGameIcons)

require(script.Parent.GameIconStoreTypes)

local GameIconSize = require(script.Parent.GameIconSize)
local GameIconConstants = require(script.Parent.GameIconConstants)
local sizeString = GameIconConstants.sizeString
local FIntGameIconSmallSizePx = GameIconConstants.FIntGameIconSmallSizePx
local FIntGameIconLargeSizePx = GameIconConstants.FIntGameIconLargeSizePx

local function toId(p1) -- line: 31
	return (tostring(p1))
end
local function toIds(t1: {[any]: any}) -- line: 35
	local t2 = {}

	for _, v20 in t1 do
		table.insert(t2, (tostring(v20)))
	end

	return t2
end
local function createResolver(s1: string) -- line: 43
	-- upvalues: createDataCache (copy), createDataResolver (copy), Dash (copy), fetchGameIcons (copy)
	local v22 = createDataCache()

	return v22, (createDataResolver({
		queueProcessDelaySec = 0,
		requestBatchSize = 100,
		cache = v22,
		fetchFn = function(t3: {[any]: any}) -- line: 49
			-- upvalues: Dash (copy), fetchGameIcons (copy), s1 (copy)
			local v30 = Dash.keys(t3)

			return fetchGameIcons(v30, s1):andThen(function(t4: {[any]: any}) -- line: 53
				-- upvalues: s1 (copy)
				local t5 = {}

				for _, v64 in t4 do
					if type(v64) == "table" and type(v64.targetId) == "number" and v64.state ~= "Pending" then
						local str = tostring(v64.targetId)

						t5[str] = {
							universeId = str,
							state = v64.state,
							url = v64.imageUrl,
							size = s1
						}
					end
				end

				return t5
			end)
		end
	}))
end
local function createGameIconStore() -- line: 80
	-- upvalues: createResolver (copy), sizeString (copy), FIntGameIconSmallSizePx (copy), FIntGameIconLargeSizePx (copy), GameIconSize (copy)
	local v23, v24 = createResolver(sizeString(FIntGameIconSmallSizePx))
	local v25, v26 = createResolver(sizeString(FIntGameIconLargeSizePx))

	local function resolverFor(p2) -- line: 84
		-- upvalues: GameIconSize (copy), v26 (copy), v24 (copy)
		if p2 == GameIconSize.Large then
			return v26
		end

		return v24
	end
	local function cacheFor(p3) -- line: 91
		-- upvalues: GameIconSize (copy), v25 (copy), v23 (copy)
		if p3 == GameIconSize.Large then
			return v25
		end

		return v23
	end

	return {
		fetchGameIcon = function(p4, p5) -- line: 99
			-- upvalues: GameIconSize (copy), v26 (copy), v24 (copy)
			return ((if p5 ~= GameIconSize.Large then v24 else v26)).fetchItem((tostring(p4)))
		end,
		fetchGameIcons = function(p6, p7) -- line: 102
			-- upvalues: GameIconSize (copy), v26 (copy), v24 (copy)
			local fetchItems = ((if p7 ~= GameIconSize.Large then v24 else v26)).fetchItems
			local t6 = {}

			for _, v40 in p6 do
				table.insert(t6, (tostring(v40)))
			end

			return fetchItems(t6)
		end,
		getGameIcon = function(p8, p9) -- line: 105
			-- upvalues: GameIconSize (copy), v26 (copy), v24 (copy)
			return ((if p9 ~= GameIconSize.Large then v24 else v26)).getCachedItem((tostring(p8)))
		end,
		getGameIcons = function(p10, p11) -- line: 108
			-- upvalues: GameIconSize (copy), v26 (copy), v24 (copy)
			local getCachedItems = ((if p11 ~= GameIconSize.Large then v24 else v26)).getCachedItems
			local t7 = {}

			for _, v48 in p10 do
				table.insert(t7, (tostring(v48)))
			end

			return getCachedItems(t7)
		end,
		getAndFetchGameIcon = function(p12, p13, p14) -- line: 111
			-- upvalues: GameIconSize (copy), v26 (copy), v24 (copy)
			return ((if p13 ~= GameIconSize.Large then v24 else v26)).getAndFetchItem(tostring(p12), p14)
		end,
		getAndFetchGameIcons = function(p15, p16, p17) -- line: 114
			-- upvalues: GameIconSize (copy), v26 (copy), v24 (copy)
			local getAndFetchItems = ((if p16 ~= GameIconSize.Large then v24 else v26)).getAndFetchItems
			local t8 = {}

			for _, v58 in p15 do
				table.insert(t8, (tostring(v58)))
			end

			return getAndFetchItems(t8, p17)
		end,
		updateGameIcons = function(p18, p19) -- line: 118
			-- upvalues: GameIconSize (copy), v25 (copy), v23 (copy);
			((if p19 ~= GameIconSize.Large then v23 else v25)).updateItems(p18)
		end,
		clear = function() -- line: 122
			-- upvalues: v24 (copy), v26 (copy)
			v24.clear()
			v26.clear()
		end,
		dispose = function() -- line: 126
			-- upvalues: v24 (copy), v26 (copy)
			v24.dispose()
			v26.dispose()
		end
	}
end

return createGameIconStore
