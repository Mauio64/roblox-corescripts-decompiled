local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)

local Cryo = require(parent.Cryo)
local Promise = require(parent.Promise)

local Requests = require(script.Parent.Requests)
require(script.Parent.FollowingStoreTypes)
local classifyFollowingError = require(script.Parent.classifyFollowingError)

game:DefineFastInt("FollowingStoreProcessDelaySec", 1)
local function getFIntFollowingStoreProcessDelaySec() -- 2 equivalent calls inferred from this helper
	return game:GetFastInt("FollowingStoreProcessDelaySec")
end

local function normalizeId(userId) -- 1 equivalent call inferred from this helper
	if userId == nil then
		return nil
	end

	return (tostring(userId))
end

local function createFollowingStore()
	local dataCache = createDataCache()
	local dataCache2 = createDataCache()

	local function fetchFollowingExists(items) -- 2 equivalent calls inferred from this helper
		return Requests.GetFollowingExists(items):andThen(function(p)
			local isFollowing = {}
			local isFollowed = {}

			for _, v in not (p and p.followings) and {} or p.followings do
				local id = normalizeId(v.userId) -- inferred equivalent call

				if not id then
					continue
				end

				isFollowing[id] = v.isFollowing == true
				isFollowed[id] = v.isFollowed == true
			end

			for _, item in items do
				if isFollowing[item] == nil then
					isFollowing[item] = false
				end

				if isFollowed[item] == nil then
					isFollowed[item] = false
				end
			end

			return { isFollowing = isFollowing, isFollowed = isFollowed }
		end)
	end

	local dataResolver = createDataResolver({
		cache = dataCache,
		queueProcessDelaySec = getFIntFollowingStoreProcessDelaySec(), -- inferred equivalent call
		requestBatchSize = 100,
		fetchFn = function(p)
			return fetchFollowingExists(Cryo.Dictionary.keys(p)):andThen(function(p2) -- inferred equivalent call
				dataCache2.replaceItems(p2.isFollowed)
				return p2.isFollowing
			end)
		end,
		supportsMutations = true
	})

	local dataResolver2 = createDataResolver({
		cache = dataCache2,
		queueProcessDelaySec = getFIntFollowingStoreProcessDelaySec(), -- inferred equivalent call
		requestBatchSize = 100,
		fetchFn = function(p)
			return fetchFollowingExists(Cryo.Dictionary.keys(p)):andThen(function(p2) -- inferred equivalent call
				dataCache.replaceItems(p2.isFollowing)
				return p2.isFollowed
			end)
		end,
		supportsMutations = true
	})

	local getOptimisticCachedItem = dataResolver.getOptimisticCachedItem
	local getOptimisticAndFetchItem = dataResolver.getOptimisticAndFetchItem
	local getOptimisticCachedItem2 = dataResolver2.getOptimisticCachedItem
	local getOptimisticAndFetchItem2 = dataResolver2.getOptimisticAndFetchItem

	local function writeFollowing(p, isFollowing: boolean, callback, p2)
		dataResolver.setMutation(p, isFollowing)

		return callback(p, p2):andThen(function()
			dataResolver.commitMutation(p)
			return { type = "success", isFollowing = isFollowing }
		end, function(p3)
			dataResolver.clearMutation(p)
			return Promise.reject(classifyFollowingError(p3))
		end)
	end

	return {
		GetIsFollowing = function(p, p2)
			if p2 and p2.skipFetch or dataResolver2.isRequestInQueueOrInFlight(p) then
				return getOptimisticCachedItem(p)
			end

			return getOptimisticAndFetchItem(p)
		end,
		GetIsFollowed = function(p, p2)
			if p2 and p2.skipFetch or dataResolver.isRequestInQueueOrInFlight(p) then
				return getOptimisticCachedItem2(p)
			end

			return getOptimisticAndFetchItem2(p)
		end,
		Follow = function(p, p2)
			return writeFollowing(p, true, Requests.FollowUser, p2)
		end,
		Unfollow = function(p, p2)
			return writeFollowing(p, false, Requests.UnfollowUser, p2)
		end,
		clear = function()
			dataResolver.clear()
			dataResolver2.clear()
		end,
		dispose = function()
			dataResolver.dispose()
			dataResolver2.dispose()
		end
	}
end

return createFollowingStore
