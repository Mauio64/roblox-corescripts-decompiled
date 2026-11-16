local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Promise = require(parent.Promise)
require(parent.MomentsTypes)
local Signals = require(parent.Signals)
local LocalUserIdStore = require(parent.LocalUserIdStore)
local localUserIdStore = LocalUserIdStore.LocalUserIdStore
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
local DataHydrationTypes = require(DataHydration.DataHydrationTypes)
local DataHydrationUtils = require(DataHydration.DataHydrationUtils)
require(script.Parent.MomentsStoreTypes)

local function createMomentsCommentsStore(_)
	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(_: string, _)
			return Promise.reject("Moments comments V1 has no get-comment-by-id API")
		end
	})

	local dataCache2 = createDataCache()
	local signal, v = Signals.createSignal(0)

	local function normalizeOwnerId(p) -- 4 equivalent calls inferred from this helper
		if p == nil or p == "" then
			return ""
		end

		local v2 = tostring(p)
		local v3 = tonumber(v2)
		return if v3 == nil or not (v3 <= 0) then v2 else ""
	end

	local function getGenerationAwareResult(p, p2: number)
		return {
			data = function(p3)
				if signal(p3) == p2 then
					return p.data(p3)
				end

				return nil
			end,
			status = function(p3)
				if signal(p3) == p2 then
					return p.status(p3)
				end

				return DataHydrationTypes.DataStatus.NotReady
			end
		}
	end

	local function clearCaches() -- 1 equivalent call inferred from this helper
		dataResolver.clear()
		dataCache2.clear()
	end

	local function invalidate() -- 2 equivalent calls inferred from this helper
		clearCaches() -- inferred equivalent call
		v(signal(false) + 1)
	end

	local ownerId = normalizeOwnerId(localUserIdStore.getCurrentUserId(false)) -- inferred equivalent call
	local ownerId4 = normalizeOwnerId(DataHydrationUtils.getLocalPlayerUserId()) -- inferred equivalent call

	if ownerId ~= "" then
		ownerId4 = ownerId
	end

	local function handleOwnerChange(ownerId2) -- 1 equivalent call inferred from this helper
		local ownerId3 = normalizeOwnerId(ownerId2) -- inferred equivalent call

		if ownerId3 == ownerId4 then
			return
		end

		ownerId4 = ownerId3
		invalidate() -- inferred equivalent call
	end

	local v2 = DataHydrationUtils.observeLocalPlayerUserId(handleOwnerChange)
	local v3 = ownerId
	local effect = Signals.createEffect(function(p)
		local ownerId2 = normalizeOwnerId(localUserIdStore.getCurrentUserId(p)) -- inferred equivalent call

		if ownerId2 == v3 then
			return
		end

		v3 = ownerId2
		handleOwnerChange(ownerId2) -- inferred equivalent call
	end)
	local flag = false

	return {
		getCachedComment = function(p: string)
			local v4 = signal(false)
			return getGenerationAwareResult(dataResolver.getCachedItem(p), v4)
		end,
		getCachedMomentComments = function(p: string)
			local v4 = signal(false)
			return getGenerationAwareResult(dataCache2.getItem(p), v4)
		end,
		upsertComments = function(items, p: number?)
			if p ~= nil and p ~= signal(false) then
				return
			end

			local v4 = {}

			for _, item in items do
				v4[item.commentId] = item
			end

			dataCache.replaceItems(v4)
		end,
		upsertMomentComments = function(p, p2: number?)
			if p2 ~= nil and p2 ~= signal(false) then
				return
			end

			dataCache2.replaceItems(p)
		end,
		getOwnerGeneration = signal,
		clear = function()
			invalidate() -- inferred equivalent call
		end,
		dispose = function()
			if flag then
				return
			end

			flag = true
			v2()
			effect()
			v(signal(false) + 1)
			dataResolver.dispose()
			dataCache2.dispose()
		end
	}
end

return createMomentsCommentsStore
