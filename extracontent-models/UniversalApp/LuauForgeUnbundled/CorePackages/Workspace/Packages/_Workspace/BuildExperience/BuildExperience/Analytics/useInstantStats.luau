local SignalsReact = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/SignalsReact")

local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/BuildExperience/DataHydration")
local getGameInfoStore = DataHydration.Game.getGameInfoStore
local getVotesStore = DataHydration.Game.getVotesStore
local dataStatus = DataHydration.DataStatus

local function useInstantStats(p2)
	local v5 = tostring(p2)
	local fetchGameInfo = getGameInfoStore(false).getAndFetchGameInfo(v5)
	local fetchVote = getVotesStore(false).getAndFetchVote(v5)
	local v6 = SignalsReact.useSignalState(fetchGameInfo.data)
	local v7 = SignalsReact.useSignalState(fetchGameInfo.status)
	local v8 = SignalsReact.useSignalState(fetchVote.data)
	local v9 = SignalsReact.useSignalState(fetchVote.status)

	local v10 = v7 == dataStatus.NotReady
	local v11 = v9 == dataStatus.NotReady

	local v13 = if v6 ~= nil then v6.totalVisits else nil
	local v14 = if v6 ~= nil then v6.playerCount else nil
	local v15 = if v8 ~= nil then v8.upVotes else nil
	return {
		visits = v13,
		players = v14,
		likes = v15,
		visitsLoading = v10,
		playersLoading = v10,
		likesLoading = v11
	}
end

return useInstantStats
