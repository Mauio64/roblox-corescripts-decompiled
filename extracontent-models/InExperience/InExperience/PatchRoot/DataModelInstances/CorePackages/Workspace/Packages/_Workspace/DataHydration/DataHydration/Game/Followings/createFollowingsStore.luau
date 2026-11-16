local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local Signals = require(parent.Signals)

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)

local DiscoveryUtils = require(parent.DiscoveryUtils)
require(parent.LuauPolyfill)
local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local fetchFollowing = require(script.Parent.fetchFollowing)
local requestUpdateFollowing = require(script.Parent.requestUpdateFollowing)
local FollowingsStoreTypes = require(script.Parent.FollowingsStoreTypes)
local FollowingsUrlBuilder = require(script.Parent.FollowingsUrlBuilder)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppDataHydrationUpdateItem = SharedFlags.FFlagLuaAppDataHydrationUpdateItem

local function createFollowingsStore()
	local dataCache = createDataCache()
	local v = nil

	local dataResolver = createDataResolver({
		cache = dataCache,
		supportsMultiGet = false,
		logError = function(p)
			logResponseError(FollowingsUrlBuilder.FOLLOWING_STATUS_URL, p)
		end,
		onClear = function()
			v = nil
		end,
		fetchFn = function(universeId: string, _)
			return fetchFollowing(universeId):andThen(function(p)
				local responseBody = p.responseBody

				if not FollowingsStoreTypes.followingResponseValidator(responseBody) then
					DiscoveryEventErrorLogger.reportError("createFollowingsStore", "Invalid following response", {
						universeId = responseBody.UniverseId,
						isFollowing = responseBody.IsFollowing,
						userId = responseBody.UserId,
						canFollow = responseBody.CanFollow
					})

					error({ StatusCode = p.responseCode })
				end

				if responseBody.FollowingCountByType and responseBody.FollowingLimitByType then
					v = {
						followingCountByType = responseBody.FollowingCountByType,
						followingLimitByType = responseBody.FollowingLimitByType
					}
				end

				return {
					universeId = tostring(responseBody.UniverseId),
					userId = tostring(responseBody.UserId),
					canFollow = responseBody.CanFollow,
					isFollowing = responseBody.IsFollowing
				}
			end):catch(function(message)
				local v2

				if type(message) == "table" then
					v2 = message.ClientError ~= nil
				else
					v2 = false
				end

				if not v2 then
					error(message)
					return
				end

				local message2 = message.message or message.ClientError
				DiscoveryEventErrorLogger.reportError(
					"createFollowingsStore",
					"Client validation error fetching following",
					{ universeId = universeId, clientError = message2 }
				)
			end)
		end
	})

	local function updateFollowing(universeId: string, isFollowing2: boolean)
		local signal, v2 = Signals.createSignal(nil)

		local item = dataCache.getItem(universeId)

		local v3 = item and item.data(false)
		local isFollowing

		if v3 then
			isFollowing = v3.isFollowing
		else
			isFollowing = nil
		end

		local v4 = v

		if isFollowing2 and v4 and v4.followingCountByType >= v4.followingLimitByType then
			v2({ type = "error", errorType = "LimitReached", statusCode = nil, statusMessage = nil })

			return signal
		end

		dataCache.updateItem(universeId, { isFollowing = isFollowing2 })

		if v4 then
			v = {
				followingCountByType = (v4 and v4.followingCountByType or 0) + (isFollowing2 and 1 or -1),
				followingLimitByType = v4.followingLimitByType
			}
		end

		requestUpdateFollowing(universeId, isFollowing2):andThen(function()
			v2({ type = "success", isFollowing = isFollowing2 })
		end):catch(function(data)
			dataCache.updateItem(universeId, { isFollowing = isFollowing })

			if v4 then
				v = v4
			end

			local v5

			if type(data) == "table" then
				v5 = data.ClientError ~= nil
			else
				v5 = false
			end

			local message

			if v5 then
				message = data.message or data.ClientError
			end

			local statusCode

			if type(data) == "table" and data.StatusCode then
				statusCode = data.StatusCode
			end

			local statusMessage

			if type(data) == "table" and data.StatusMessage then
				statusMessage = data.StatusMessage
			end

			v2({
				type = "error",
				errorType = v5 and "ClientError" or statusCode == 400 and "LimitReached" or "NetworkError",
				statusCode = statusCode,
				statusMessage = message or statusMessage
			})

			if v5 then
				DiscoveryEventErrorLogger.reportError("updateFollowing", "Client validation error updating following", {
					universeId = universeId,
					method = isFollowing2 and "POST" or "DELETE",
					clientError = message
				})
				return
			end

			logResponseError(FollowingsUrlBuilder.FOLLOWING_UPDATE_URL, { StatusCode = statusCode })

			DiscoveryEventErrorLogger.reportError("updateFollowing", "Error updating following", {
				universeId = universeId,
				statusCode = statusCode,
				method = isFollowing2 and "POST" or "DELETE",
				statusMessage = statusMessage
			})
		end)

		return signal
	end

	local function clear()
		v = nil
		dataResolver.clear()
	end

	local followingsStore = {
		fetchFollowing = dataResolver.fetchItem,
		fetchFollowings = dataResolver.fetchItems,
		getFollowing = dataResolver.getCachedItem,
		getFollowings = dataResolver.getCachedItems,
		getAndFetchFollowing = dataResolver.getAndFetchItem,
		getAndFetchFollowings = dataResolver.getAndFetchItems,
		updateFollowing = updateFollowing,
		updateItem = 0,
		updateUserFollowingLimits = 0,
		clear = 0,
		dispose = 0
	}
	local updateItem

	if FFlagLuaAppDataHydrationUpdateItem then
		updateItem = dataCache.updateItem
	end

	followingsStore.updateItem = updateItem

	followingsStore.updateUserFollowingLimits = FFlagLuaAppDataHydrationUpdateItem and function(p)
		v = p
	end or nil

	followingsStore.clear = clear

	function followingsStore.dispose()
		dataResolver.dispose()
	end
	return followingsStore
end

return createFollowingsStore
