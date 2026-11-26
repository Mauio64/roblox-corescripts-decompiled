require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Promise")

local fetchAssetUserAuth = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/AssetUserAuth/fetchAssetUserAuth")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/AssetUserAuth/AssetUserAuthStoreTypes")

local function ALWAYS_REFRESH(): boolean
	return true
end

local function createAssetUserAuthStore(options)
	local v5 = options or {}
	local v6 = { network = v5.network, baseUrl = v5.baseUrl }

	local v7 = createDataCache()
	local v8 = createDataResolver({
		cache = v7,
		supportsMultiGet = false,
		fetchFn = function(p2, p3)
			return fetchAssetUserAuth.fetchOperation(p2, v6)
		end
	})

	local function seedAndReturn(p2)
		local path = p2.path

		if typeof(path) == "string" and #path > 0 then
			local v9 = string.match(path, "operations/(.+)$") or path
			v7.updateItem(v9, p2)
		end

		return p2
	end

	return {
		patchAssetIcon = function(p2, p3)
			return fetchAssetUserAuth.patchAssetIcon(p2, p3, v6):andThen(function(p4)
				local path = p4.path

				if typeof(path) == "string" and #path > 0 then
					local v9 = string.match(path, "operations/(.+)$") or path
					v7.updateItem(v9, p4)
				end

				return p4
			end)
		end,
		updateIcon = function(p2, p3)
			return fetchAssetUserAuth.updateIcon(p2, p3, v6):andThen(seedAndReturn)
		end,
		getPreviews = function(p2)
			return fetchAssetUserAuth.getPreviews(p2, v6)
		end,
		updatePreviews = function(p2, p3)
			return fetchAssetUserAuth.updatePreviews(p2, p3, v6):andThen(seedAndReturn)
		end,
		createImageAsset = function(p2, p3, p4)
			return fetchAssetUserAuth.createImageAsset(p2, p3, p4, v6):andThen(seedAndReturn)
		end,
		pollUntilDone = function(value)
			if typeof(value) ~= "string" then
				local path = value.path or ""
				value = string.match(path, "operations/(.+)$") or value.operationId or path
			end

			return Promise.new(function(callback, callback2)
				local count = 0
				local count2 = 0
				local function poll()
					count += 1
					local v9 = value
					fetchAssetUserAuth.fetchOperation(v9, v6):andThen(function(p2)
						v7.updateItem(v9, p2)
						return p2
					end):andThen(function(p2)
						count2 = 0

						if p2.done then
							if p2.error then
								callback2(p2.error.message or "Operation failed")
							else
								callback({ status = "done", operation = p2 })
							end
						elseif count >= 30 then
							callback({ status = "timed_out", operationId = value })
						else
							task.delay(2, poll)
						end
					end):catch(function(p2)
						count2 += 1

						if count2 <= 3 then
							local v10 = (math.pow)(2, count2 - 1) * 2
							task.delay(v10, poll)
						else
							callback2(p2)
						end
					end)
				end

				poll()
			end)
		end,
		getOperation = v8.getCachedItem,
		fetchOperation = v8.fetchItem,
		getAndFetchOperation = function(p2)
			return v8.getAndFetchItem(p2, ALWAYS_REFRESH)
		end,
		refreshOperation = function(p2)
			return fetchAssetUserAuth.fetchOperation(p2, v6):andThen(function(p3)
				v7.updateItem(p2, p3)
				return p3
			end)
		end,
		updateOperation = v7.updateItem,
		clear = v8.clear,
		dispose = v8.dispose
	}
end

return createAssetUserAuthStore
