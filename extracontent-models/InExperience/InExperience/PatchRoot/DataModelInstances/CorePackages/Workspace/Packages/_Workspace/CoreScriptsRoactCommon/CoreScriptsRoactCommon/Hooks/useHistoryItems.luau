local CoreScriptsRoactCommon = script:FindFirstAncestor("CoreScriptsRoactCommon")
local CoreScriptsRoactCommonParent = CoreScriptsRoactCommon.Parent
local DataHydration = require(CoreScriptsRoactCommonParent.DataHydration)
local Signals = require(CoreScriptsRoactCommonParent.Signals)
local SignalsReact = require(CoreScriptsRoactCommonParent.SignalsReact)
local React = require(CoreScriptsRoactCommonParent.React)
local Traversal = CoreScriptsRoactCommon.Traversal
local default = require(Traversal.LocalTraversalHistory).default
local getGameInfoStore = DataHydration.Game.getGameInfoStore
local getVotesStore = DataHydration.Game.getVotesStore

local function getNMostRecentUniqueUniverseIds(t1: {[any]: any}, _: number?) -- line: 24
	local t2 = {}
	local t3 = {}

	for _, v19 in t1 do
		if not t3[v19] then
			t3[v19] = true
			table.insert(t2, v19)
		end
	end

	return t2
end
local function getHistoryInfo(p1, p2) -- line: 37
	return {
		name = p1.name,
		placeId = tonumber(p1.rootPlaceId),
		universeId = tonumber(p1.universeId),
		rating = p2.rating
	}
end
local function useHistoryItems(n2: number?) -- line: 47
	-- upvalues: React (copy), Signals (copy), default (copy), getNMostRecentUniqueUniverseIds (copy), getGameInfoStore (copy), getVotesStore (copy), SignalsReact (copy)
	local v23 = n2 or 2
	local v24 = React.useMemo(function() -- line: 49
		-- upvalues: Signals (copy), default (copy), v23 (copy), getNMostRecentUniqueUniverseIds (copy), getGameInfoStore (copy), getVotesStore (copy)
		return (Signals.createComputed(function(p3) -- line: 50
			-- upvalues: default (copy), v23 (copy), getNMostRecentUniqueUniverseIds (copy), getGameInfoStore (copy), getVotesStore (copy)
			local t4 = {}
			local v27 = default:getUniverseHistorySignal(v23)(p3)
			local v28 = getNMostRecentUniqueUniverseIds(v27, v23)
			local v29 = getGameInfoStore(p3).getAndFetchGameInfos(v28)
			local v30 = getVotesStore(p3).getAndFetchVotes(v28)

			for _, v32 in v28 do
				local v33 = if not v29[v32] or not v29[v32].data then nil else v29[v32].data(p3)
				local v34 = if not v30[v32] or not v30[v32].data then nil else v30[v32].data(p3)

				if v33 and v34 then
					table.insert(t4, {
						name = v33.name,
						placeId = tonumber(v33.rootPlaceId),
						universeId = tonumber(v33.universeId),
						rating = v34.rating
					})
				end
			end

			return t4
		end))
	end, {
		v23,
		getGameInfoStore,
		getVotesStore
	})

	return (SignalsReact.useSignalState(v24))
end

return useHistoryItems
