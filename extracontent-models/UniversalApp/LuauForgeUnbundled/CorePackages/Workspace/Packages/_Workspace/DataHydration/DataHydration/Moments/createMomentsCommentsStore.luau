local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/MomentsTypes")
local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")
local localUserIdStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/LocalUserIdStore").LocalUserIdStore
local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
local DataHydrationTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")
local DataHydrationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Moments/MomentsStoreTypes")

local function createMomentsCommentsStore(p2)
	local v5 = createDataCache()
	local v6 = createDataResolver({
		cache = v5,
		supportsMultiGet = false,
		replaceItems = true,
		fetchFn = function(p3, p4)
			return Promise.reject("Moments comments V1 has no get-comment-by-id API")
		end
	})

	local v7 = createDataCache()
	local signal, v8 = Signals.createSignal(0)

	local function normalizeOwnerId(p3)
		if p3 == nil or p3 == "" then
			return ""
		end

		local v9 = tostring(p3)
		local v10 = tonumber(v9)

		if v10 == nil or not (v10 <= 0) then
			return v9
		end

		return ""
	end

	local function getGenerationAwareResult(p3, p4)
		return {
			data = function(p5)
				if signal(p5) == p4 then
					return p3.data(p5)
				end

				return nil
			end,
			status = function(p5)
				if signal(p5) == p4 then
					return p3.status(p5)
				end

				return DataHydrationTypes.DataStatus.NotReady
			end
		}
	end

	local function clearCaches()
		v6.clear()
		v7.clear()
	end

	local function invalidate()
		v6.clear()
		v7.clear()

		v8(signal(false) + 1)
	end

	local currentUserId = localUserIdStore.getCurrentUserId(false)
	local v9

	if currentUserId == nil or currentUserId == "" then
		v9 = ""
	else
		local v10 = tostring(currentUserId)
		local v11 = tonumber(v10)
		v9 = v11 ~= nil and v11 <= 0 and "" or v10
	end

	local localPlayerUserId = DataHydrationUtils.getLocalPlayerUserId()
	local v10

	if localPlayerUserId == nil or localPlayerUserId == "" then
		v10 = ""
	else
		local v11 = tostring(localPlayerUserId)
		local v12 = tonumber(v11)
		v10 = v12 ~= nil and v12 <= 0 and "" or v11
	end

	if v9 ~= "" then
		v10 = v9
	end

	local function handleOwnerChange(p3)
		local v11

		if p3 == nil or p3 == "" then
			v11 = ""
		else
			local v12 = tostring(p3)
			local v13 = tonumber(v12)
			v11 = v13 ~= nil and v13 <= 0 and "" or v12
		end

		if v11 == v10 then
			return
		end

		v10 = v11
		v6.clear()
		v7.clear()

		v8(signal(false) + 1)
	end

	local v11 = DataHydrationUtils.observeLocalPlayerUserId(handleOwnerChange)
	local v12 = v9
	local effect = Signals.createEffect(function(p3)
		local currentUserId2 = localUserIdStore.getCurrentUserId(p3)
		local v13

		if currentUserId2 == nil or currentUserId2 == "" then
			v13 = ""
		else
			local v14 = tostring(currentUserId2)
			local v15 = tonumber(v14)
			v13 = v15 ~= nil and v15 <= 0 and "" or v14
		end

		if v13 == v12 then
			return
		end

		v12 = v13
		local v14

		if v13 == nil or v13 == "" then
			v14 = ""
		else
			local v15 = tostring(v13)
			local v16 = tonumber(v15)
			v14 = v16 ~= nil and v16 <= 0 and "" or v15
		end

		if v14 == v10 then
			return
		end

		v10 = v14
		v6.clear()
		v7.clear()

		v8(signal(false) + 1)
	end)
	local flag = false

	return {
		getCachedComment = function(p3)
			local v13 = signal(false)
			return getGenerationAwareResult(v6.getCachedItem(p3), v13)
		end,
		getCachedMomentComments = function(p3)
			local v13 = signal(false)
			return getGenerationAwareResult(v7.getItem(p3), v13)
		end,
		upsertComments = function(items, p3)
			if p3 ~= nil and p3 ~= signal(false) then
				return
			end

			local v13 = {}

			for k, item in items do
				v13[item.commentId] = item
			end

			v5.replaceItems(v13)
		end,
		upsertMomentComments = function(p3, p4)
			if p4 ~= nil and p4 ~= signal(false) then
				return
			end

			v7.replaceItems(p3)
		end,
		getOwnerGeneration = signal,
		clear = function()
			v6.clear()
			v7.clear()

			v8(signal(false) + 1)
		end,
		dispose = function()
			if flag then
				return
			end

			flag = true
			v11()
			effect()
			v8(signal(false) + 1)
			v6.dispose()
			v7.dispose()
		end
	}
end

return createMomentsCommentsStore
