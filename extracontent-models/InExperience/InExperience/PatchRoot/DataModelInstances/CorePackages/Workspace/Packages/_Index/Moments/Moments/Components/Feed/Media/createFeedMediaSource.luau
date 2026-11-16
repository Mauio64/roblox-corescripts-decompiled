local Moments = script:FindFirstAncestor("Moments")
local parent = Moments.Parent

require(parent.Signals)
require(parent.MomentsCommon)

require(Moments.Components.Feed.FeedTypes)
local FFlagMomentsModeratedMomentPage = require(Moments.Flags.FFlagMomentsModeratedMomentPage)
local SharedFlags = require(parent.SharedFlags)
local FFlagMomentsRenderAvatarPostsInFeed = SharedFlags.FFlagMomentsRenderAvatarPostsInFeed
local SharedFlags2 = require(parent.SharedFlags)
local FFlagMomentsServeEDPVideos = SharedFlags2.FFlagMomentsServeEDPVideos
local GameGetPlayabilityStore

if FFlagMomentsServeEDPVideos then
	GameGetPlayabilityStore = require(parent.DataHydration.GameGetPlayabilityStore)
else
	GameGetPlayabilityStore = nil
end

local isVideoEligibleForPlayability

if FFlagMomentsServeEDPVideos then
	local VideoUtils = require(parent.VideoUtils)
	isVideoEligibleForPlayability = VideoUtils.isVideoEligibleForPlayability
else
	isVideoEligibleForPlayability = nil
end

local toMediaItem = require(script.Parent.toMediaItem)

local function hasMedia(p): boolean -- 3 equivalent calls inferred from this helper
	if FFlagMomentsRenderAvatarPostsInFeed and p.kind == "avatarMoment" then
		return p.moment.metadata ~= nil
	end

	if p.kind ~= "moment" then
		return false
	end

	local moment = p.moment
	return moment ~= nil and moment.metadata ~= nil
end

local function createFeedMediaSource(p, getPlaybackActive, getCanAutoPlay)
	local v = FFlagMomentsServeEDPVideos and {} or nil

	local fn = FFlagMomentsServeEDPVideos and function(p2, p3)
		if not hasMedia(p2) then -- inferred equivalent call
			return false
		end

		local moment = p2.moment

		if moment.entityType ~= "edpVideo" then
			return true
		end

		local universeId = moment.metadata.universeId

		if universeId == nil or universeId <= 0 then
			return false
		end

		local v2 = tostring(universeId)
		local v3 = v[v2]

		if v3 == nil then
			v3 = GameGetPlayabilityStore(false).getPlayability(v2)
			v[v2] = v3
		end

		return isVideoEligibleForPlayability(v3.status(p3) == "Ready", v3.data(p3))
	end or nil

	local function fn2(p2)
		local items = p.getItems(p2)
		local result = {}

		for _, item in items do
			if not (not FFlagMomentsServeEDPVideos or fn(item, p2)) then
				continue
			end

			local v2 = toMediaItem(item, { includeLocalTts = true })

			if v2 ~= nil then
				table.insert(result, v2)
			end
		end

		return result
	end

	local function getActiveIndex(p2)
		local items = p.getItems(p2)
		local currentIndex = p.getCurrentIndex(p2)
		local count = 0

		for i = 1, math.min(currentIndex - 1, #items) do
			local v2

			if FFlagMomentsServeEDPVideos then
				v2 = fn(items[i], p2)
			else
				v2 = hasMedia(items[i]) -- inferred equivalent call
			end

			if v2 then
				count += 1
			end
		end

		local item = items[currentIndex]

		if item == nil then
			return count + 0.5
		end

		local v2

		if FFlagMomentsServeEDPVideos then
			v2 = fn(item, p2)
		else
			v2 = hasMedia(item) -- inferred equivalent call
		end

		if v2 then
			return count + 1
		end

		return count + 0.5
	end

	if not (FFlagMomentsModeratedMomentPage or FFlagMomentsServeEDPVideos) then
		getActiveIndex = p.getCurrentIndex
	end

	return {
		getActiveIndex = getActiveIndex,
		getItems = fn2,
		getPlaybackActive = getPlaybackActive,
		getCanAutoPlay = getCanAutoPlay
	}
end

return createFeedMediaSource
