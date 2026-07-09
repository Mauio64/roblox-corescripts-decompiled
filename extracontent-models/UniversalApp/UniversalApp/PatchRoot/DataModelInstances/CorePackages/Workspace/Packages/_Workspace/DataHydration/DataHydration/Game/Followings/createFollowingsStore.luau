local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Signals = require(DataHydrationParent.Signals)
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)

local DiscoveryUtils = require(DataHydrationParent.DiscoveryUtils)

require(DataHydrationParent.LuauPolyfill)

local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local fetchFollowing = require(script.Parent.fetchFollowing)
local requestUpdateFollowing = require(script.Parent.requestUpdateFollowing)
local FollowingsStoreTypes = require(script.Parent.FollowingsStoreTypes)
local FollowingsUrlBuilder = require(script.Parent.FollowingsUrlBuilder)
local FFlagLuaAppDataHydrationUpdateItem = require(DataHydrationParent.SharedFlags).FFlagLuaAppDataHydrationUpdateItem

local function createFollowingsStore() -- line: 22
	-- upvalues: createDataCache (copy), createDataResolver (copy), logResponseError (copy), FollowingsUrlBuilder (copy), fetchFollowing (copy), FollowingsStoreTypes (copy), DiscoveryEventErrorLogger (copy), Signals (copy), requestUpdateFollowing (copy), FFlagLuaAppDataHydrationUpdateItem (copy)
	local v15 = createDataCache()
	local u16 = nil
	local v17 = createDataResolver({
		supportsMultiGet = false,
		cache = v15,
		logError = function(p1) -- line: 30
			-- upvalues: logResponseError (copy), FollowingsUrlBuilder (copy)
			logResponseError(FollowingsUrlBuilder.FOLLOWING_STATUS_URL, p1)
		end,
		onClear = function() -- line: 34
			-- upvalues: u16 (ref)
			u16 = nil
		end,
		fetchFn = function(s1: string, _) -- line: 38
			-- upvalues: fetchFollowing (copy), FollowingsStoreTypes (copy), DiscoveryEventErrorLogger (copy), u16 (ref)
			return fetchFollowing(s1):andThen(function(p3) -- line: 43
				-- upvalues: FollowingsStoreTypes (copy), DiscoveryEventErrorLogger (copy), u16 (ref)
				local responseBody = p3.responseBody

				if not FollowingsStoreTypes.followingResponseValidator(responseBody) then
					DiscoveryEventErrorLogger.reportError("createFollowingsStore", "Invalid following response", {
						universeId = responseBody.UniverseId,
						isFollowing = responseBody.IsFollowing,
						userId = responseBody.UserId,
						canFollow = responseBody.CanFollow
					})
					error({
						StatusCode = p3.responseCode
					})
				end

				if responseBody.FollowingCountByType and responseBody.FollowingLimitByType then
					u16 = {
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
			end):catch(function(p4) -- line: 74
				-- upvalues: DiscoveryEventErrorLogger (copy), s1 (copy)
				if type(p4) == "table" and p4.ClientError ~= nil then
					local v34 = p4.message or p4.ClientError

					DiscoveryEventErrorLogger.reportError("createFollowingsStore", "Client validation error fetching following", {
						universeId = s1,
						clientError = v34
					})

					return
				end

				error(p4)
			end)
		end
	})

	return {
		fetchFollowing = v17.fetchItem,
		fetchFollowings = v17.fetchItems,
		getFollowing = v17.getCachedItem,
		getFollowings = v17.getCachedItems,
		getAndFetchFollowing = v17.getAndFetchItem,
		getAndFetchFollowings = v17.getAndFetchItems,
		updateFollowing = function(s2: string, b1: boolean) -- line: 95
			-- upvalues: Signals (copy), v15 (copy), u16 (ref), requestUpdateFollowing (copy), DiscoveryEventErrorLogger (copy), logResponseError (copy), FollowingsUrlBuilder (copy)
			local v23, v24 = Signals.createSignal(nil)
			local v25 = v15.getItem(s2)
			local v26 = v25 and v25.data(false)
			local v27 = if not v26 then nil else v26.isFollowing
			local v28 = u16

			if b1 and (v28 and v28.followingCountByType >= v28.followingLimitByType) then
				v24({
					type = "error",
					errorType = "LimitReached",
					statusCode = nil,
					statusMessage = nil
				})

				return v23
			end

			v15.updateItem(s2, {
				isFollowing = b1
			})

			if v28 then
				local v29 = not b1 and -1 or 1

				u16 = {
					followingCountByType = (v28 and v28.followingCountByType or 0) + v29,
					followingLimitByType = v28.followingLimitByType
				}
			end

			requestUpdateFollowing(s2, b1):andThen(function() -- line: 143
				-- upvalues: v24 (copy), b1 (copy)
				v24({
					type = "success",
					isFollowing = b1
				})
			end):catch(function(p5) -- line: 149
				-- upvalues: v15 (copy), s2 (copy), v27 (copy), v28 (copy), u16 (ref), v24 (copy), DiscoveryEventErrorLogger (copy), b1 (copy), logResponseError (copy), FollowingsUrlBuilder (copy)
				v15.updateItem(s2, {
					isFollowing = v27
				})

				if v28 then
					u16 = v28
				end

				local v36 = type(p5) == "table" and p5.ClientError ~= nil
				local v37 = if not v36 then nil else p5.message or p5.ClientError
				local v38 = if type(p5) ~= "table" or not p5.StatusCode then nil else p5.StatusCode
				local v39 = if type(p5) ~= "table" or not p5.StatusMessage then nil else p5.StatusMessage
				local v40 = if not v36 then v38 ~= 400 and "NetworkError" or "LimitReached" else "ClientError"

				v24({
					type = "error",
					errorType = v40,
					statusCode = v38,
					statusMessage = v37 or v39
				})

				if v36 then
					DiscoveryEventErrorLogger.reportError("updateFollowing", "Client validation error updating following", {
						universeId = s2,
						method = not b1 and "DELETE" or "POST",
						clientError = v37
					})

					return
				end

				logResponseError(FollowingsUrlBuilder.FOLLOWING_UPDATE_URL, {
					StatusCode = v38
				})
				DiscoveryEventErrorLogger.reportError("updateFollowing", "Error updating following", {
					universeId = s2,
					statusCode = v38,
					method = not b1 and "DELETE" or "POST",
					statusMessage = v39
				})
			end)

			return v23
		end,
		updateItem = if not FFlagLuaAppDataHydrationUpdateItem then nil else v15.updateItem,
		updateUserFollowingLimits = if not FFlagLuaAppDataHydrationUpdateItem then nil else function(p6) -- line: 234
			-- upvalues: u16 (ref)
			u16 = p6
		end,
		clear = function() -- line: 212
			-- upvalues: u16 (ref), v17 (copy)
			u16 = nil
			v17.clear()
		end,
		dispose = function() -- line: 217
			-- upvalues: v17 (copy)
			v17.dispose()
		end
	}
end

return createFollowingsStore
