local HttpService = game:GetService("HttpService")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")
local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")
local module6 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/Requests/fetchUserMoments")

local function paramsKey(p2, value)
	return HttpService:JSONEncode({
		targetUserId = p2,
		hasCursor = value ~= nil,
		cursor = value or ""
	})
end

local function createMomentsUserStore(options)
	local v5 = options or {}
	local v6 = {}

	local v7 = {}

	local v8 = {}
	local v10 = createDataResolver({
		cache = createDataCache(),
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p2, p3)
			local v11 = v6[p2]

			if v11 == nil then
				return Promise.reject(`Missing user moments request params for {p2}`)
			end

			return HttpClient.asPromise(module6(v11.targetUserId, v11.cursor, v5.network))
		end
	})

	local function setParams(p2, value)
		local jsonEncode = HttpService:JSONEncode({
			targetUserId = p2,
			hasCursor = value ~= nil,
			cursor = value or ""
		})

		v6[jsonEncode] = { targetUserId = p2, cursor = value }

		return jsonEncode
	end

	local function getCachedUserMoments(p2, value)
		local getCachedItem = v10.getCachedItem
		local jsonEncode = HttpService:JSONEncode({
			targetUserId = p2,
			hasCursor = value ~= nil,
			cursor = value or ""
		})

		v6[jsonEncode] = { targetUserId = p2, cursor = value }

		return getCachedItem(jsonEncode)
	end

	local function fetchUserMomentsItem(p2, value)
		local fetchItem = v10.fetchItem
		local jsonEncode = HttpService:JSONEncode({
			targetUserId = p2,
			hasCursor = value ~= nil,
			cursor = value or ""
		})

		v6[jsonEncode] = { targetUserId = p2, cursor = value }

		return fetchItem(jsonEncode)
	end

	local function getAndFetchUserMoments(p2, value)
		local getAndFetchItem = v10.getAndFetchItem
		local jsonEncode = HttpService:JSONEncode({
			targetUserId = p2,
			hasCursor = value ~= nil,
			cursor = value or ""
		})

		v6[jsonEncode] = { targetUserId = p2, cursor = value }

		return getAndFetchItem(jsonEncode)
	end

	local function getUserMoments(p2, value)
		local jsonEncode = HttpService:JSONEncode({
			targetUserId = p2,
			hasCursor = value ~= nil,
			cursor = value or ""
		})

		local v11 = v7[jsonEncode]

		if v11 ~= nil then
			return v11
		end

		local promise = HttpClient.asPromise(module6(p2, value, v5.network))
		v7[jsonEncode] = promise
		v8[jsonEncode] = p2
		promise:catch(function()
			v7[jsonEncode] = nil
			v8[jsonEncode] = nil
		end)
		return promise
	end

	local signal, v11 = Signals.createSignal(0)

	local signal2, v12 = Signals.createSignal({})
	return {
		getUserMoments = getUserMoments,
		getFreshUserMoments = function(p2, p3)
			return HttpClient.asPromise(module6(p2, p3, v5.network))
		end,
		getCachedUserMoments = getCachedUserMoments,
		fetchUserMoments = fetchUserMomentsItem,
		getAndFetchUserMoments = getAndFetchUserMoments,
		evictUserMoments = function(p2)
			for k, v13 in v8 do
				if v13 ~= p2 then
					continue
				end

				v7[k] = nil
				v8[k] = nil
			end
		end,
		invalidateUser = function(p2)
			for k, v13 in v8 do
				if v13 ~= p2 then
					continue
				end

				v7[k] = nil
				v8[k] = nil
			end

			v11(signal(false) + 1)
		end,
		getUserMomentsVersion = signal,
		getPendingUserMoments = signal2,
		prependPendingUserMoment = function(p2, p3, p4)
			local clone = table.clone(signal2(false))
			local clone2 = table.clone(clone[p2] or {})
			table.insert(clone2, 1, { moment = p3, startedAtClock = p4 })
			clone[p2] = clone2
			v12(clone)
		end,
		removePendingUserMoment = function(p2, p3)
			local clone = table.clone(signal2(false))
			local v13 = clone[p2]

			if v13 == nil then
				return
			end

			local v14 = {}

			for k, v15 in v13 do
				if v15.moment.momentId ~= p3 then
					table.insert(v14, v15)
				end
			end

			if not (#v14 > 0) then
				v14 = nil
			end

			clone[p2] = v14
			v12(clone)
		end,
		resolvePendingUserMoment = function(p2, p3, publishedMoment): boolean
			local clone = table.clone(signal2(false))
			local v13 = clone[p2] or {}

			local feedItemId = publishedMoment.recommendationMetadata.feedItemId
			local v14 = nil

			for k, v15 in v13 do
				if v15.moment.momentId == p3 then
					v14 = k
				elseif v15.publishedMoment ~= nil then
					local publishedMoment2 = v15.publishedMoment

					if
						publishedMoment2.momentId == publishedMoment.momentId
						or feedItemId ~= nil
						and feedItemId ~= ""
						and publishedMoment2.recommendationMetadata.feedItemId == feedItemId
					then
						return false
					end
				end
			end

			if v14 == nil or v13[v14].status == "Moderated" then
				return false
			end

			local clone2 = table.clone(v13)
			local clone3 = table.clone(v13[v14])
			clone3.publishedMoment = publishedMoment
			clone2[v14] = clone3
			clone[p2] = clone2
			v12(clone)
			return true
		end,
		setPendingUserMomentStatus = function(p2, p3, status): boolean
			local v13 = signal2(false)[p2]

			if v13 == nil then
				return false
			end

			for k, v14 in v13 do
				if v14.moment.momentId == p3 then
					if v14.publishedMoment ~= nil or v14.status == "Moderated" then
						return false
					end

					local clone = table.clone(signal2(false))
					local clone2 = table.clone(v13)
					local clone3 = table.clone(v14)
					clone3.status = status
					clone2[k] = clone3
					clone[p2] = clone2
					v12(clone)
					return true
				end
			end

			return false
		end,
		clear = function()
			v12({})
			v6 = {}
			v7 = {}
			v8 = {}
			v10.clear()
		end,
		dispose = function()
			v12({})
			v6 = {}
			v7 = {}
			v8 = {}
			v10.dispose()
		end
	}
end

return createMomentsUserStore
