local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/DataHydration")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/Signals")
local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/SignalsReact")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/React")

local default = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsRoactCommon/CoreScriptsRoactCommon/Traversal/LocalTraversalHistory").default

local getGameInfoStore = DataHydration.Game.getGameInfoStore
local getVotesStore = DataHydration.Game.getVotesStore

local function getNMostRecentUniqueUniverseIds(items, p2)
	local set = {}
	local nMostRecentUniqueUniverseIds = {}

	for k, item in items do
		if set[item] then
			continue
		end

		set[item] = true
		table.insert(nMostRecentUniqueUniverseIds, item)
	end

	return nMostRecentUniqueUniverseIds
end

local function getHistoryInfo(data, p2)
	return {
		name = data.name,
		placeId = tonumber(data.rootPlaceId),
		universeId = tonumber(data.universeId),
		rating = p2.rating
	}
end

local function useHistoryItems(value)
	local v5 = value or 2
	local v6 = React.useMemo(function()
		return (Signals.createComputed(function(p2)
			local nMostRecentUniqueUniverseIds = getNMostRecentUniqueUniverseIds(
				default:getUniverseHistorySignal(v5)(p2),
				v5
			)
			local fetchGameInfos = getGameInfoStore(p2).getAndFetchGameInfos(nMostRecentUniqueUniverseIds)
			local fetchVotes = getVotesStore(p2).getAndFetchVotes(nMostRecentUniqueUniverseIds)
			local result = {}

			for k, nMostRecentUniqueUniverseId in nMostRecentUniqueUniverseIds do
				local v8

				if
					fetchGameInfos[nMostRecentUniqueUniverseId]
					and fetchGameInfos[nMostRecentUniqueUniverseId].data
				then
					v8 = fetchGameInfos[nMostRecentUniqueUniverseId].data(p2)
				end

				local v9

				if
					fetchVotes[nMostRecentUniqueUniverseId]
					and fetchVotes[nMostRecentUniqueUniverseId].data
				then
					v9 = fetchVotes[nMostRecentUniqueUniverseId].data(p2)
				end

				if v8 and v9 then
					table.insert(result, {
						name = v8.name,
						placeId = tonumber(v8.rootPlaceId),
						universeId = tonumber(v8.universeId),
						rating = v9.rating
					})
				end
			end

			return result
		end))
	end, { v5, getGameInfoStore, getVotesStore })

	return (SignalsReact.useSignalState(v6))
end

return useHistoryItems
