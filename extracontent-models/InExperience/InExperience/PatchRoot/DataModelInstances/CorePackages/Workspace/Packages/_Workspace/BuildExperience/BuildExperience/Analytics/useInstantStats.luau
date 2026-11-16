local parent = script:FindFirstAncestor("BuildExperience").Parent

local SignalsReact = require(parent.SignalsReact)

local DataHydration = require(parent.DataHydration)
local getGameInfoStore = DataHydration.Game.getGameInfoStore
local getVotesStore = DataHydration.Game.getVotesStore
local DataStatus = DataHydration.DataStatus

local function useInstantStats(p: number)
	local v = tostring(p)
	local fetchGameInfo = getGameInfoStore(false).getAndFetchGameInfo(v)
	local fetchVote = getVotesStore(false).getAndFetchVote(v)
	local v2 = SignalsReact.useSignalState(fetchGameInfo.data)
	local v3 = SignalsReact.useSignalState(fetchGameInfo.status)
	local v4 = SignalsReact.useSignalState(fetchVote.data)
	local v5 = SignalsReact.useSignalState(fetchVote.status)

	local v6 = v3 == DataStatus.NotReady
	local likesLoading = v5 == DataStatus.NotReady
	local visits

	if v2 ~= nil then
		visits = v2.totalVisits
	end

	local players

	if v2 ~= nil then
		players = v2.playerCount
	end

	local likes

	if v4 ~= nil then
		likes = v4.upVotes
	end

	return {
		visits = visits,
		players = players,
		likes = likes,
		visitsLoading = v6,
		playersLoading = v6,
		likesLoading = likesLoading
	}
end

return useInstantStats
