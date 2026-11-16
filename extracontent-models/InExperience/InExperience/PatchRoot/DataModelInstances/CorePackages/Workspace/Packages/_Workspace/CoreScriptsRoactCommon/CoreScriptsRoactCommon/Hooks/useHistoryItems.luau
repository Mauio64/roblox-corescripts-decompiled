local CoreScriptsRoactCommon = script:FindFirstAncestor("CoreScriptsRoactCommon")
local parent = CoreScriptsRoactCommon.Parent

local DataHydration = require(parent.DataHydration)
local Signals = require(parent.Signals)
local SignalsReact = require(parent.SignalsReact)
local React = require(parent.React)

local Traversal = CoreScriptsRoactCommon.Traversal
local LocalTraversalHistory = require(Traversal.LocalTraversalHistory)
local default = LocalTraversalHistory.default

local getGameInfoStore = DataHydration.Game.getGameInfoStore
local getVotesStore = DataHydration.Game.getVotesStore

local function getNMostRecentUniqueUniverseIds(items, _: number?)
	local set = {}
	local nMostRecentUniqueUniverseIds = {}

	for _, item in items do
		if set[item] then
			continue
		end

		set[item] = true
		table.insert(nMostRecentUniqueUniverseIds, item)
	end

	return nMostRecentUniqueUniverseIds
end

local function getHistoryInfo(data, p) -- 1 equivalent call inferred from this helper
	return {
		name = data.name,
		placeId = tonumber(data.rootPlaceId),
		universeId = tonumber(data.universeId),
		rating = p.rating
	}
end

local function useHistoryItems(value: number?)
	local v = value or 2
	local v2 = React.useMemo(function()
		return (Signals.createComputed(function(p)
			local nMostRecentUniqueUniverseIds = getNMostRecentUniqueUniverseIds(
				default:getUniverseHistorySignal(v)(p),
				v
			)
			local fetchGameInfos = getGameInfoStore(p).getAndFetchGameInfos(nMostRecentUniqueUniverseIds)
			local fetchVotes = getVotesStore(p).getAndFetchVotes(nMostRecentUniqueUniverseIds)
			local result = {}

			for _, nMostRecentUniqueUniverseId in nMostRecentUniqueUniverseIds do
				local v2

				if fetchGameInfos[nMostRecentUniqueUniverseId] and fetchGameInfos[nMostRecentUniqueUniverseId].data then
					v2 = fetchGameInfos[nMostRecentUniqueUniverseId].data(p)
				end

				local v3

				if fetchVotes[nMostRecentUniqueUniverseId] and fetchVotes[nMostRecentUniqueUniverseId].data then
					v3 = fetchVotes[nMostRecentUniqueUniverseId].data(p)
				end

				if v2 and v3 then
					table.insert(result, getHistoryInfo(v2, v3)) -- inferred equivalent call
				end
			end

			return result
		end))
	end, { v, getGameInfoStore, getVotesStore })

	return (SignalsReact.useSignalState(v2))
end

return useHistoryItems
