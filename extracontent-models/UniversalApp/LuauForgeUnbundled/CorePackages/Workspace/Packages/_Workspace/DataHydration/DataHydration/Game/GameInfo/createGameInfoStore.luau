local Dash = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Dash")
local DiscoveryUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DiscoveryUtils")
local logResponseError = DiscoveryUtils.logResponseError
local discoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local createDataCache = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataCache")
local createDataResolver = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/createDataResolver")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/DataHydrationTypes")

local fetchGameDetails = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameInfo/fetchGameDetails")
local GameInfoStoreTypes = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/Game/GameInfo/GameInfoStoreTypes")

local trim = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/LuauPolyfill").String.trim

local fFlagLuaAppInExperienceDetailsPrompt = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagLuaAppInExperienceDetailsPrompt

local fFlagLuaAppDataHydrationPlayerCountGameInfoStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagLuaAppDataHydrationPlayerCountGameInfoStore

local getFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").GetFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds
local fFlagLuaAppDataHydrationUpdateItem = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagLuaAppDataHydrationUpdateItem
local fFlagMigrateGameInfoToStore = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/SharedFlags").FFlagMigrateGameInfoToStore
local v5

if fFlagLuaAppInExperienceDetailsPrompt then
	v5 = getFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds()
else
	v5 = nil
end

local function sanitizeGameInfo(p2)
	if p2.name then
		p2.name = trim(p2.name)
	end

	return p2
end

local function createGameInfoStore()
	local v6 = {}

	local function indexPlaceId(p2, p3)
		if p3 and p3.rootPlaceId then
			v6[tostring(p3.rootPlaceId)] = p2
		end
	end

	local v7

	if fFlagLuaAppInExperienceDetailsPrompt then
		v7 = createDataCache(v5, nil, { sanitizeItem = sanitizeGameInfo })
	else
		v7 = createDataCache(nil, nil, { sanitizeItem = sanitizeGameInfo })
	end

	local v8 = createDataResolver({
		cache = v7,
		logError = fFlagLuaAppInExperienceDetailsPrompt and function(data)
			if type(data) == "table" then
				if data.responseCode then
					logResponseError("v1/games/universeIds", {
						StatusCode = tonumber(data.responseCode)
					})
				end

				if data.errorType and data.errorMessage then
					discoveryEventErrorLogger.reportError(
						data.errorType,
						data.errorMessage,
						data.customFields
					)
				end
			else
				discoveryEventErrorLogger.reportError("FetchGameDetailsError", (tostring(data)))
			end
		end or nil,
		fetchFn = function(p2)
			local keys = Dash.keys(p2)
			return fetchGameDetails(keys):andThen(function(data)
				if fFlagLuaAppInExperienceDetailsPrompt then
					if not (data and data.responseBody) then
						error({
							responseCode = data and data.responseCode,
							errorType = "FetchGameDetailsResponseError",
							errorMessage = data and "Missing response body" or "No response",
							customFields = { universeIds = keys }
						})
					end
				else
					if not data then
						error("No response")
					end

					if not (data.responseBody and data.responseBody.data) then
						error(`Response Code: {data.reponseCode}`)
					end
				end

				if fFlagLuaAppInExperienceDetailsPrompt then
					local gameInfoResponseValidator, v9 = GameInfoStoreTypes.gameInfoResponseValidator(data.responseBody)

					if not gameInfoResponseValidator then
						error({
							responseCode = data.responseCode,
							errorType = "FetchGameDetailsResponseInvalidInterface",
							errorMessage = v9,
							customFields = { universeIds = keys }
						})
					end
				end

				local result = {}
				local data2 = data.responseBody.data

				if fFlagLuaAppInExperienceDetailsPrompt then
					for k, v9 in data2 do
						if not v9 then
							continue
						end

						local id = tostring(v9.id)
						local v10 = {
							name = v9.name,
							rootPlaceId = tostring(v9.rootPlaceId),
							universeId = tostring(v9.id),
							description = v9.description,
							creator = v9.creator and {
								id = tostring(v9.creator.id),
								name = v9.creator.name,
								hasVerifiedBadge = v9.creator.hasVerifiedBadge
							} or nil,
							playerCount = 0,
							totalVisits = 0
						}

						local v11 = if fFlagLuaAppDataHydrationPlayerCountGameInfoStore then v9.playing else nil
						v10.playerCount = v11

						v10.totalVisits = v9.visits
						result[id] = v10
					end

					for k, key in keys do
						if not result[tostring(key)] then
							result[tostring(key)] = { isUnavailable = true }
						end
					end
				else
					Dash.forEach(data2, function(data3)
						local v9 = result
						local id = tostring(data3.id)
						local v10 = {
							name = data3.name,
							rootPlaceId = tostring(data3.rootPlaceId),
							universeId = tostring(data3.id),
							playerCount = 0,
							totalVisits = 0
						}

						local v11 = if fFlagLuaAppDataHydrationPlayerCountGameInfoStore then data3.playing else nil
						v10.playerCount = v11

						v10.totalVisits = data3.visits
						v9[id] = v10
					end)
				end

				if fFlagMigrateGameInfoToStore then
					for k, v9 in result do
						if v9 and v9.rootPlaceId then
							v6[tostring(v9.rootPlaceId)] = k
						end
					end
				end

				return result
			end):catch(function(message)
				error(message)
			end)
		end
	})

	local function updateGameInfo(p2, p3, p4)
		if p3 and p3.rootPlaceId then
			v6[tostring(p3.rootPlaceId)] = p2
		end

		if fFlagMigrateGameInfoToStore then
			v7.updateItem(p2, p3, p4)
		else
			v7.updateItem(p2, p3)
		end
	end

	local function updateGameInfos(items, p2)
		for k, item in items do
			if item and item.rootPlaceId then
				v6[tostring(item.rootPlaceId)] = k
			end
		end

		if fFlagMigrateGameInfoToStore then
			v7.updateItems(items, p2)
		else
			v7.updateItems(items)
		end
	end

	local function getUniverseIdForPlaceId(p2)
		return v6[tostring(p2)]
	end

	local function clear()
		if not fFlagLuaAppInExperienceDetailsPrompt then
			v7.clear()
			v8.clear()
		end
	end

	local function dispose()
		if not fFlagLuaAppInExperienceDetailsPrompt then
			v7.dispose()
			v8.dispose()
		end
	end

	local gameInfoStore = {
		fetchGameInfo = v8.fetchItem,
		fetchGameInfos = v8.fetchItems,
		getGameInfo = v8.getCachedItem,
		getGameInfos = v8.getCachedItems,
		getAndFetchGameInfo = v8.getAndFetchItem,
		getAndFetchGameInfos = v8.getAndFetchItems,
		updateGameInfo = 0,
		updateGameInfos = 0,
		getUniverseIdForPlaceId = 0,
		applyVoteChange = 0,
		clear = 0,
		dispose = 0
	}

	if fFlagLuaAppDataHydrationUpdateItem then
		if not fFlagMigrateGameInfoToStore then
			updateGameInfo = v7.updateItem
		end
	else
		updateGameInfo = nil
	end

	gameInfoStore.updateGameInfo = updateGameInfo

	if not fFlagMigrateGameInfoToStore then
		updateGameInfos = v7.updateItems
	end

	gameInfoStore.updateGameInfos = updateGameInfos

	if not fFlagMigrateGameInfoToStore then
		getUniverseIdForPlaceId = nil
	end

	gameInfoStore.getUniverseIdForPlaceId = getUniverseIdForPlaceId

	function gameInfoStore.applyVoteChange(p2, p3, p4)
		local cachedItem = v8.getCachedItem(p2)
		local v9 = cachedItem and cachedItem.data(false)

		if not v9 or v9.totalUpVotes == nil then
			return nil
		end

		local totalUpVotes = tonumber(v9.totalUpVotes) or 0
		local totalDownVotes = tonumber(v9.totalDownVotes) or 0
		local v10 = {
			totalUpVotes = v9.totalUpVotes,
			totalDownVotes = v9.totalDownVotes
		}

		local v11 = (p4 == true and 1 or 0) - (p3 == true and 1 or 0)
		local v12 = (p4 == false and 1 or 0) - (p3 == false and 1 or 0)

		if fFlagMigrateGameInfoToStore then
			v7.updateItem(p2, {
				totalUpVotes = tostring((math.max(0, totalUpVotes + v11))),
				totalDownVotes = tostring((math.max(0, totalDownVotes + v12)))
			}, false)
			return v10
		end

		v7.updateItem(p2, {
			totalUpVotes = tostring((math.max(0, totalUpVotes + v11))),
			totalDownVotes = tostring((math.max(0, totalDownVotes + v12)))
		})

		return v10
	end

	if fFlagLuaAppInExperienceDetailsPrompt then
		clear = v8.clear
	end

	gameInfoStore.clear = clear

	if fFlagLuaAppInExperienceDetailsPrompt then
		dispose = v8.dispose
	end

	gameInfoStore.dispose = dispose
	return gameInfoStore
end

return createGameInfoStore
