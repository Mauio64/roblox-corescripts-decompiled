require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/Signals")
require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/MomentsCommon")

require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/FeedTypes")
local FFlagMomentsModeratedMomentPage = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Flags/FFlagMomentsModeratedMomentPage")
local fFlagMomentsRenderAvatarPostsInFeed = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsRenderAvatarPostsInFeed
local fFlagMomentsServeEDPVideos = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/SharedFlags").FFlagMomentsServeEDPVideos

local v5 = if fFlagMomentsServeEDPVideos then require("@game/CorePackages/Workspace/Packages/_Index/Moments/DataHydration/GameGetPlayabilityStore") else nil
local isVideoEligibleForPlayability

if fFlagMomentsServeEDPVideos then
	isVideoEligibleForPlayability = require("@game/CorePackages/Workspace/Packages/_Workspace/Moments/VideoUtils").isVideoEligibleForPlayability
else
	isVideoEligibleForPlayability = nil
end

local toMediaItem = require("@game/CorePackages/Workspace/Packages/_Index/Moments/Moments/Components/Feed/Media/toMediaItem")

local function hasMedia(p2): boolean
	if fFlagMomentsRenderAvatarPostsInFeed and p2.kind == "avatarMoment" then
		return p2.moment.metadata ~= nil
	end

	if p2.kind ~= "moment" then
		return false
	end

	local moment = p2.moment
	return moment ~= nil and moment.metadata ~= nil
end

local function createFeedMediaSource(p2, getPlaybackActive, getCanAutoPlay)
	local v6 = fFlagMomentsServeEDPVideos and {} or nil

	local fn = fFlagMomentsServeEDPVideos and function(p3, p4)
		local v7

		if fFlagMomentsRenderAvatarPostsInFeed and p3.kind == "avatarMoment" then
			v7 = p3.moment.metadata ~= nil
		elseif p3.kind == "moment" then
			local moment = p3.moment
			v7 = not (moment == nil) and moment.metadata ~= nil
		else
			v7 = false
		end

		if not v7 then
			return false
		end

		local moment = p3.moment

		if moment.entityType ~= "edpVideo" then
			return true
		end

		local universeId = moment.metadata.universeId

		if universeId == nil or universeId <= 0 then
			return false
		end

		local v8 = tostring(universeId)
		local v9 = v6[v8]

		if v9 == nil then
			v9 = v5(false).getPlayability(v8)
			v6[v8] = v9
		end

		return isVideoEligibleForPlayability(v9.status(p4) == "Ready", v9.data(p4))
	end or nil

	local function fn2(p3)
		local items = p2.getItems(p3)
		local result = {}

		for k, item in items do
			if not (not fFlagMomentsServeEDPVideos or fn(item, p3)) then
				continue
			end

			local v7 = toMediaItem(item, { includeLocalTts = true })

			if v7 ~= nil then
				table.insert(result, v7)
			end
		end

		return result
	end

	local function v7(p3)
		local items = p2.getItems(p3)
		local currentIndex = p2.getCurrentIndex(p3)
		local count = 0

		for i = 1, math.min(currentIndex - 1, #items) do
			local v8

			if fFlagMomentsServeEDPVideos then
				v8 = fn(items[i], p3)
			else
				local item = items[i]

				if fFlagMomentsRenderAvatarPostsInFeed and item.kind == "avatarMoment" then
					v8 = item.moment.metadata ~= nil
				elseif item.kind == "moment" then
					local moment = item.moment
					v8 = not (moment == nil) and moment.metadata ~= nil
				else
					v8 = false
				end
			end

			if v8 then
				count += 1
			end
		end

		local item = items[currentIndex]

		if item == nil then
			return count + 0.5
		end

		local v8

		if fFlagMomentsServeEDPVideos then
			v8 = fn(item, p3)
		elseif fFlagMomentsRenderAvatarPostsInFeed and item.kind == "avatarMoment" then
			v8 = item.moment.metadata ~= nil
		elseif item.kind == "moment" then
			local moment = item.moment
			v8 = not (moment == nil) and moment.metadata ~= nil
		else
			v8 = false
		end

		if v8 then
			return count + 1
		end

		return count + 0.5
	end

	if not (FFlagMomentsModeratedMomentPage or fFlagMomentsServeEDPVideos) then
		v7 = p2.getCurrentIndex
	end

	return {
		getActiveIndex = v7,
		getItems = fn2,
		getPlaybackActive = getPlaybackActive,
		getCanAutoPlay = getCanAutoPlay
	}
end

return createFeedMediaSource
