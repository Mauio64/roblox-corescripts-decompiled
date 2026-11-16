local Signals = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Signals")

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

local DiscoveryUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DiscoveryUtils")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/LuauPolyfill")
local logResponseError = DiscoveryUtils.logResponseError
local discoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local module5 = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Followings/fetchFollowing")
local requestUpdateFollowing = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Followings/requestUpdateFollowing")
local FollowingsStoreTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Followings/FollowingsStoreTypes")
local FollowingsUrlBuilder = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/Followings/FollowingsUrlBuilder")

local fFlagLuaAppDataHydrationUpdateItem = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagLuaAppDataHydrationUpdateItem

local function createFollowingsStore()
	local v5 = createDataCache()
	local v6 = nil

	local v7 = createDataResolver({
		cache = v5,
		supportsMultiGet = false,
		logError = function(p2)
			logResponseError(FollowingsUrlBuilder.FOLLOWING_STATUS_URL, p2)
		end,
		onClear = function()
			v6 = nil
		end,
		fetchFn = function(p2, p3)
			return module5(p2):andThen(function(p4)
				local responseBody = p4.responseBody

				if not FollowingsStoreTypes.followingResponseValidator(responseBody) then
					discoveryEventErrorLogger.reportError(
						"createFollowingsStore",
						"Invalid following response",
						{
							universeId = responseBody.UniverseId,
							isFollowing = responseBody.IsFollowing,
							userId = responseBody.UserId,
							canFollow = responseBody.CanFollow
						}
					)

					error({ StatusCode = p4.responseCode })
				end

				if responseBody.FollowingCountByType and responseBody.FollowingLimitByType then
					v6 = {
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
				local v8 = type(message) == "table" and message.ClientError ~= nil

				if not v8 then
					error(message)
					return
				end

				local message2 = message.message or message.ClientError
				discoveryEventErrorLogger.reportError(
					"createFollowingsStore",
					"Client validation error fetching following",
					{ universeId = p2, clientError = message2 }
				)
			end)
		end
	})

	local function updateFollowing(p2, p3)
		local signal, v8 = Signals.createSignal(nil)

		local item = v5.getItem(p2)

		local v9 = item and item.data(false)
		local isFollowing = if v9 then v9.isFollowing else nil
		local v10 = v6

		if p3 and v10 and v10.followingCountByType >= v10.followingLimitByType then
			v8({
				type = "error",
				errorType = "LimitReached",
				statusCode = nil,
				statusMessage = nil
			})

			return signal
		end

		v5.updateItem(p2, { isFollowing = p3 })

		if v10 then
			v6 = {
				followingCountByType = (v10 and v10.followingCountByType or 0) + (p3 and 1 or -1),
				followingLimitByType = v10.followingLimitByType
			}
		end

		requestUpdateFollowing(p2, p3):andThen(function()
			v8({ type = "success", isFollowing = p3 })
		end):catch(function(data)
			v5.updateItem(p2, { isFollowing = isFollowing })

			if v10 then
				v6 = v10
			end

			local v11 = type(data) == "table" and data.ClientError ~= nil
			local message = if v11 then data.message or data.ClientError else nil

			local statusCode = if type(data) == "table" and data.StatusCode then data.StatusCode else nil
			local statusMessage = if type(data) == "table" and data.StatusMessage then data.StatusMessage else nil

			v8({
				type = "error",
				errorType = v11 and "ClientError" or statusCode == 400 and "LimitReached" or "NetworkError",
				statusCode = statusCode,
				statusMessage = message or statusMessage
			})

			if v11 then
				discoveryEventErrorLogger.reportError(
					"updateFollowing",
					"Client validation error updating following",
					{
						universeId = p2,
						method = p3 and "POST" or "DELETE",
						clientError = message
					}
				)
				return
			end

			logResponseError(FollowingsUrlBuilder.FOLLOWING_UPDATE_URL, { StatusCode = statusCode })

			discoveryEventErrorLogger.reportError("updateFollowing", "Error updating following", {
				universeId = p2,
				statusCode = statusCode,
				method = p3 and "POST" or "DELETE",
				statusMessage = statusMessage
			})
		end)

		return signal
	end

	local function clear()
		v6 = nil
		v7.clear()
	end

	local followingsStore = {
		fetchFollowing = v7.fetchItem,
		fetchFollowings = v7.fetchItems,
		getFollowing = v7.getCachedItem,
		getFollowings = v7.getCachedItems,
		getAndFetchFollowing = v7.getAndFetchItem,
		getAndFetchFollowings = v7.getAndFetchItems,
		updateFollowing = updateFollowing,
		updateItem = 0,
		updateUserFollowingLimits = 0,
		clear = 0,
		dispose = 0
	}

	local v8 = if fFlagLuaAppDataHydrationUpdateItem then v5.updateItem else nil
	followingsStore.updateItem = v8

	followingsStore.updateUserFollowingLimits = fFlagLuaAppDataHydrationUpdateItem and function(p2)
		v6 = p2
	end or nil

	followingsStore.clear = clear

	function followingsStore.dispose()
		v7.dispose()
	end
	return followingsStore
end

return createFollowingsStore
