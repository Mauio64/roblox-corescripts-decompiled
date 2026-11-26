local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInfosRodux/Cryo")
local DataHydration = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInfosRodux/DataHydration")
require("@game/CorePackages/Workspace/Packages/_Workspace/GameInfosRodux/DiscoveryTypes")
local tutils = require("@game/CorePackages/Workspace/Packages/_Workspace/GameInfosRodux/tutils")

local v5 = { creator = true }

local function toStoreItem(item)
	return {
		universeId = item.universeId,
		rootPlaceId = item.placeId,
		name = item.name,
		playerCount = item.playerCount,
		contentMaturity = item.contentMaturity,
		gameMinimumAge = item.minimumAge,
		gameAgeDisplayName = item.ageRecommendationDisplayName,
		creator = (item.creatorId or item.creatorName) and {
			id = item.creatorId,
			name = item.creatorName
		} or nil
	}
end

local function isUnchanged(p2, p3)
	if not (p2 and tutils.shallowEqual(p2, Cryo.Dictionary.join(p2, p3), v5)) then
		return false
	end

	local creator = p3.creator

	if creator == nil then
		return true
	end

	return tutils.shallowEqual(p2.creator, creator)
end

local function syncVotesToStore(items)
	local votesStore = DataHydration.Game.getVotesStore(false)

	local v6 = {}
	local flag = false

	for k, item in items do
		local totalUpVotes = item.totalUpVotes
		local totalDownVotes = item.totalDownVotes

		if not (totalUpVotes ~= nil and totalDownVotes ~= nil) then
			continue
		end

		local vote = votesStore.getVote(k)
		local v7 = vote and vote.data(false)

		if not (not v7 or v7.upVotes ~= totalUpVotes or v7.downVotes ~= totalDownVotes) then
			continue
		end

		v6[k] = { upVotes = totalUpVotes, downVotes = totalDownVotes }
		flag = true
	end

	if flag then
		votesStore.updateVoteItems(v6)
	end
end

local function syncGameInfosToStore(items)
	local gameInfoStore = DataHydration.Game.getGameInfoStore(false)

	local v6 = {}
	local flag = false

	for k, item in items do
		local v7 = toStoreItem(item)
		local gameInfo = gameInfoStore.getGameInfo(k)
		local v8 = if gameInfo then gameInfo.data(false) else nil

		local creator = if v8 then v8.creator else nil

		if creator and v7.creator then
			v7.creator = Cryo.Dictionary.join(creator, v7.creator)
		end

		local v9

		if v8 and tutils.shallowEqual(v8, Cryo.Dictionary.join(v8, v7), v5) then
			local creator2 = v7.creator
			v9 = creator2 == nil or tutils.shallowEqual(v8.creator, creator2)
		else
			v9 = false
		end

		if v9 then
			continue
		end

		v6[k] = v7
		flag = true
	end

	if flag then
		gameInfoStore.updateGameInfos(v6, false)
	end

	syncVotesToStore(items)
end

return syncGameInfosToStore
