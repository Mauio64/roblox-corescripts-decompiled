local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpService = game:GetService("HttpService")

local Promise = require(parent.Promise)
local HttpClient = require(parent.HttpClient)
local Signals = require(parent.Signals)
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)
require(script.Parent.MomentsStoreTypes)
local fetchUserMoments = require(script.Parent.Requests.fetchUserMoments)

local function paramsKey(targetUserId: number, value: string?) -- 2 equivalent calls inferred from this helper
	return HttpService:JSONEncode({
		targetUserId = targetUserId,
		hasCursor = value ~= nil,
		cursor = value or ""
	})
end

local function createMomentsUserStore(options)
	local v = options or {}
	local v2 = {}

	local v3 = {}

	local v4 = {}
	local dataResolver = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p: string, _)
			local v5 = v2[p]

			if v5 == nil then
				return Promise.reject(`Missing user moments request params for {p}`)
			end

			return HttpClient.asPromise(fetchUserMoments(v5.targetUserId, v5.cursor, v.network))
		end
	})

	local function setParams(targetUserId: number, cursor: string?) -- 3 equivalent calls inferred from this helper
		local v5 = paramsKey(targetUserId, cursor) -- inferred equivalent call
		v2[v5] = { targetUserId = targetUserId, cursor = cursor }

		return v5
	end

	local function getCachedUserMoments(targetUserId: number, cursor: string?)
		return dataResolver.getCachedItem(setParams(targetUserId, cursor)) -- inferred equivalent call
	end

	local function fetchUserMomentsItem(targetUserId: number, cursor: string?)
		return dataResolver.fetchItem(setParams(targetUserId, cursor)) -- inferred equivalent call
	end

	local function getAndFetchUserMoments(targetUserId: number, cursor: string?)
		return dataResolver.getAndFetchItem(setParams(targetUserId, cursor)) -- inferred equivalent call
	end

	local function getUserMoments(targetUserId: number, value: string?)
		local v5 = paramsKey(targetUserId, value) -- inferred equivalent call
		local v6 = v3[v5]

		if v6 ~= nil then
			return v6
		end

		local promise = HttpClient.asPromise(fetchUserMoments(targetUserId, value, v.network))
		v3[v5] = promise
		v4[v5] = targetUserId
		promise:catch(function()
			v3[v5] = nil
			v4[v5] = nil
		end)
		return promise
	end

	local signal, v5 = Signals.createSignal(0)

	local signal2, v6 = Signals.createSignal({})

	local function evictUserMoments(p: number) -- 1 equivalent call inferred from this helper
		for k, v7 in v4 do
			if v7 ~= p then
				continue
			end

			v3[k] = nil
			v4[k] = nil
		end
	end

	return {
		getUserMoments = getUserMoments,
		getFreshUserMoments = function(p: number, p2: string?)
			return HttpClient.asPromise(fetchUserMoments(p, p2, v.network))
		end,
		getCachedUserMoments = getCachedUserMoments,
		fetchUserMoments = fetchUserMomentsItem,
		getAndFetchUserMoments = getAndFetchUserMoments,
		evictUserMoments = evictUserMoments,
		invalidateUser = function(p: number)
			evictUserMoments(p) -- inferred equivalent call
			v5(signal(false) + 1)
		end,
		getUserMomentsVersion = signal,
		getPendingUserMoments = signal2,
		prependPendingUserMoment = function(p: number, moment)
			local clone = table.clone(signal2(false))
			local clone2 = table.clone(clone[p] or {})
			table.insert(clone2, 1, { moment = moment })
			clone[p] = clone2
			v6(clone)
		end,
		removePendingUserMoment = function(p: number, p2: string)
			local clone = table.clone(signal2(false))
			local v7 = clone[p]

			if v7 == nil then
				return
			end

			local v8 = {}

			for _, v9 in v7 do
				if v9.moment.momentId ~= p2 then
					table.insert(v8, v9)
				end
			end

			if not (#v8 > 0) then
				v8 = nil
			end

			clone[p] = v8
			v6(clone)
		end,
		resolvePendingUserMoment = function(p: number, p2: string, publishedMoment2): boolean
			local clone = table.clone(signal2(false))
			local v7 = clone[p] or {}

			local feedItemId = publishedMoment2.recommendationMetadata.feedItemId
			local v8 = nil

			for k, v9 in v7 do
				if v9.moment.momentId == p2 then
					v8 = k
				elseif v9.publishedMoment ~= nil then
					local publishedMoment = v9.publishedMoment

					if
						publishedMoment.momentId == publishedMoment2.momentId
						or feedItemId ~= nil
						and feedItemId ~= ""
						and publishedMoment.recommendationMetadata.feedItemId == feedItemId
					then
						return false
					end
				end
			end

			if v8 == nil then
				return false
			end

			local clone2 = table.clone(v7)
			clone2[v8] = { moment = v7[v8].moment, publishedMoment = publishedMoment2 }
			clone[p] = clone2
			v6(clone)
			return true
		end,
		clear = function()
			v6({})
			v2 = {}
			v3 = {}
			v4 = {}
			dataResolver.clear()
		end,
		dispose = function()
			v6({})
			v2 = {}
			v3 = {}
			v4 = {}
			dataResolver.dispose()
		end
	}
end

return createMomentsUserStore
