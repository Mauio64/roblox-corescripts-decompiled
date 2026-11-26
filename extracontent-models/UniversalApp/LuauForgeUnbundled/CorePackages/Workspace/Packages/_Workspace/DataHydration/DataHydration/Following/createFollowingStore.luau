local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Cryo")
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")

local Requests = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Following/Requests")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Following/FollowingStoreTypes")
local classifyFollowingError = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Following/classifyFollowingError")

game:DefineFastInt("FollowingStoreProcessDelaySec", 1)
local function getFIntFollowingStoreProcessDelaySec()
	return game:GetFastInt("FollowingStoreProcessDelaySec")
end

local function normalizeId(p2)
	if p2 == nil then
		return nil
	end

	return (tostring(p2))
end

local function createFollowingStore()
	local v5 = createDataCache()
	local v6 = createDataCache()

	local function fetchFollowingExists(items)
		return Requests.GetFollowingExists(items):andThen(function(p2)
			local v7 = {}
			local v8 = {}

			for k, v9 in not (p2 and p2.followings) and {} or p2.followings do
				local userId = v9.userId
				local v10 = if userId ~= nil then tostring(userId) else nil

				if not v10 then
					continue
				end

				v7[v10] = v9.isFollowing == true
				v8[v10] = v9.isFollowed == true
			end

			for k, item in items do
				if v7[item] == nil then
					v7[item] = false
				end

				if v8[item] == nil then
					v8[item] = false
				end
			end

			return { isFollowing = v7, isFollowed = v8 }
		end)
	end

	local v7 = createDataResolver({
		cache = v5,
		queueProcessDelaySec = game:GetFastInt("FollowingStoreProcessDelaySec"),
		requestBatchSize = 100,
		fetchFn = function(p2)
			local keys = Cryo.Dictionary.keys(p2)
			return Requests.GetFollowingExists(keys):andThen(function(p3)
				local v8 = {}
				local v9 = {}

				for k, v10 in not (p3 and p3.followings) and {} or p3.followings do
					local userId = v10.userId
					local v11 = if userId ~= nil then tostring(userId) else nil

					if not v11 then
						continue
					end

					v8[v11] = v10.isFollowing == true
					v9[v11] = v10.isFollowed == true
				end

				for k, key in keys do
					if v8[key] == nil then
						v8[key] = false
					end

					if v9[key] == nil then
						v9[key] = false
					end
				end

				return { isFollowing = v8, isFollowed = v9 }
			end):andThen(function(p3)
				v6.replaceItems(p3.isFollowed)
				return p3.isFollowing
			end)
		end,
		supportsMutations = true
	})
	local v8 = createDataResolver({
		cache = v6,
		queueProcessDelaySec = game:GetFastInt("FollowingStoreProcessDelaySec"),
		requestBatchSize = 100,
		fetchFn = function(p2)
			local keys = Cryo.Dictionary.keys(p2)
			return Requests.GetFollowingExists(keys):andThen(function(p3)
				local v9 = {}
				local v10 = {}

				for k, v11 in not (p3 and p3.followings) and {} or p3.followings do
					local userId = v11.userId
					local v12 = if userId ~= nil then tostring(userId) else nil

					if not v12 then
						continue
					end

					v9[v12] = v11.isFollowing == true
					v10[v12] = v11.isFollowed == true
				end

				for k, key in keys do
					if v9[key] == nil then
						v9[key] = false
					end

					if v10[key] == nil then
						v10[key] = false
					end
				end

				return { isFollowing = v9, isFollowed = v10 }
			end):andThen(function(p3)
				v5.replaceItems(p3.isFollowing)
				return p3.isFollowed
			end)
		end,
		supportsMutations = true
	})

	local getOptimisticCachedItem = v7.getOptimisticCachedItem
	local getOptimisticAndFetchItem = v7.getOptimisticAndFetchItem
	local getOptimisticCachedItem2 = v8.getOptimisticCachedItem
	local getOptimisticAndFetchItem2 = v8.getOptimisticAndFetchItem

	local function writeFollowing(p2, p3, callback, p4)
		v7.setMutation(p2, p3)

		return callback(p2, p4):andThen(function()
			v7.commitMutation(p2)
			return { type = "success", isFollowing = p3 }
		end, function(p5)
			v7.clearMutation(p2)
			return Promise.reject(classifyFollowingError(p5))
		end)
	end

	return {
		GetIsFollowing = function(p2, p3)
			if p3 and p3.skipFetch or v8.isRequestInQueueOrInFlight(p2) then
				return getOptimisticCachedItem(p2)
			end

			return getOptimisticAndFetchItem(p2)
		end,
		GetIsFollowed = function(p2, p3)
			if p3 and p3.skipFetch or v7.isRequestInQueueOrInFlight(p2) then
				return getOptimisticCachedItem2(p2)
			end

			return getOptimisticAndFetchItem2(p2)
		end,
		Follow = function(p2, p3)
			return writeFollowing(p2, true, Requests.FollowUser, p3)
		end,
		Unfollow = function(p2, p3)
			return writeFollowing(p2, false, Requests.UnfollowUser, p3)
		end,
		clear = function()
			v7.clear()
			v8.clear()
		end,
		dispose = function()
			v7.dispose()
			v8.dispose()
		end
	}
end

return createFollowingStore
