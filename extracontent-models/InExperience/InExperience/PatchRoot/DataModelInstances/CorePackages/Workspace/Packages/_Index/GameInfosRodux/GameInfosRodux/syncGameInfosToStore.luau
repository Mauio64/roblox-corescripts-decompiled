local parent = script:FindFirstAncestor("GameInfosRodux").Parent

local Cryo = require(parent.Cryo)
local DataHydration = require(parent.DataHydration)
require(parent.DiscoveryTypes)
local tutils = require(parent.tutils)

local v = { creator = true }

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

local function isUnchanged(p, p2)
	if not (p and tutils.shallowEqual(p, Cryo.Dictionary.join(p, p2), v)) then
		return false
	end

	local creator = p2.creator

	if creator == nil then
		return true
	end

	return tutils.shallowEqual(p.creator, creator)
end

local function syncVotesToStore(items)
	local votesStore = DataHydration.Game.getVotesStore(false)

	local v2 = {}
	local flag = false

	for k, item in items do
		local totalUpVotes = item.totalUpVotes
		local totalDownVotes = item.totalDownVotes

		if not (totalUpVotes ~= nil and totalDownVotes ~= nil) then
			continue
		end

		local vote = votesStore.getVote(k)
		local v3 = vote and vote.data(false)

		if not (not v3 or v3.upVotes ~= totalUpVotes or v3.downVotes ~= totalDownVotes) then
			continue
		end

		v2[k] = { upVotes = totalUpVotes, downVotes = totalDownVotes }
		flag = true
	end

	if flag then
		votesStore.updateVoteItems(v2)
	end
end

local function syncGameInfosToStore(items)
	local gameInfoStore = DataHydration.Game.getGameInfoStore(false)

	local v2 = {}
	local flag = false

	for k, item in items do
		local v3 = toStoreItem(item)
		local gameInfo = gameInfoStore.getGameInfo(k)
		local v4

		if gameInfo then
			v4 = gameInfo.data(false)
		end

		local creator

		if v4 then
			creator = v4.creator
		end

		if creator and v3.creator then
			v3.creator = Cryo.Dictionary.join(creator, v3.creator)
		end

		local v5

		if v4 and tutils.shallowEqual(v4, Cryo.Dictionary.join(v4, v3), v) then
			local creator2 = v3.creator
			v5 = creator2 == nil or tutils.shallowEqual(v4.creator, creator2)
		else
			v5 = false
		end

		if v5 then
			continue
		end

		v2[k] = v3
		flag = true
	end

	if flag then
		gameInfoStore.updateGameInfos(v2, false)
	end

	syncVotesToStore(items)
end

return syncGameInfosToStore
