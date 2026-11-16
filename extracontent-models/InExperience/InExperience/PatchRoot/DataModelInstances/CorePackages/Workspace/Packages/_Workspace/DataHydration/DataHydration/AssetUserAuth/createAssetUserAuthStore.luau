local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

require(parent.HttpClient)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)

local Promise = require(parent.Promise)

local fetchAssetUserAuth = require(script.Parent.fetchAssetUserAuth)
require(script.Parent.AssetUserAuthStoreTypes)

local function ALWAYS_REFRESH(): boolean
	return true
end

local function createAssetUserAuthStore(options)
	local v = options or {}
	local v2 = { network = v.network, baseUrl = v.baseUrl }

	local dataCache = createDataCache()
	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		fetchFn = function(p: string, _)
			return fetchAssetUserAuth.fetchOperation(p, v2)
		end
	})

	local function refreshOperation(value: string) -- 1 equivalent call inferred from this helper
		return fetchAssetUserAuth.fetchOperation(value, v2):andThen(function(p)
			dataCache.updateItem(value, p)
			return p
		end)
	end

	local function seedAndReturn(p)
		local path = p.path

		if typeof(path) == "string" and #path > 0 then
			local v3 = string.match(path, "operations/(.+)$") or path
			dataCache.updateItem(v3, p)
		end

		return p
	end

	return {
		patchAssetIcon = function(p: string, p2)
			return fetchAssetUserAuth.patchAssetIcon(p, p2, v2):andThen(function(p3)
				local path = p3.path

				if typeof(path) == "string" and #path > 0 then
					local v3 = string.match(path, "operations/(.+)$") or path
					dataCache.updateItem(v3, p3)
				end

				return p3
			end)
		end,
		updateIcon = function(p: string, p2: string)
			return fetchAssetUserAuth.updateIcon(p, p2, v2):andThen(seedAndReturn)
		end,
		getPreviews = function(p: string)
			return fetchAssetUserAuth.getPreviews(p, v2)
		end,
		updatePreviews = function(p: string, p2)
			return fetchAssetUserAuth.updatePreviews(p, p2, v2):andThen(seedAndReturn)
		end,
		createImageAsset = function(p: string, p2: string, p3)
			return fetchAssetUserAuth.createImageAsset(p, p2, p3, v2):andThen(seedAndReturn)
		end,
		pollUntilDone = function(operationId)
			if typeof(operationId) ~= "string" then
				local path = operationId.path or ""
				operationId = string.match(path, "operations/(.+)$") or operationId.operationId or path
			end

			return Promise.new(function(callback, callback2)
				local count = 0
				local count2 = 0
				local function poll()
					count += 1

					refreshOperation(operationId):andThen(function(operation) -- inferred equivalent call
						count2 = 0

						if operation.done then
							if operation.error then
								callback2(operation.error.message or "Operation failed")
							else
								callback({ status = "done", operation = operation })
							end
						elseif count >= 30 then
							callback({ status = "timed_out", operationId = operationId })
						else
							task.delay(2, poll)
						end
					end):catch(function(p)
						count2 += 1

						if count2 <= 3 then
							local v3 = math.pow(2, count2 - 1) * 2
							task.delay(v3, poll)
						else
							callback2(p)
						end
					end)
				end

				poll()
			end)
		end,
		getOperation = dataResolver.getCachedItem,
		fetchOperation = dataResolver.fetchItem,
		getAndFetchOperation = function(p: string)
			return dataResolver.getAndFetchItem(p, ALWAYS_REFRESH)
		end,
		refreshOperation = refreshOperation,
		updateOperation = dataCache.updateItem,
		clear = dataResolver.clear,
		dispose = dataResolver.dispose
	}
end

return createAssetUserAuthStore
