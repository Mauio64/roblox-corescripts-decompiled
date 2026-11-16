local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent
local Dash = require(parent.Dash)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger

local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)
require(DataHydration.DataHydrationTypes)

local fetchGameDetails = require(script.Parent.fetchGameDetails)
local GameInfoStoreTypes = require(script.Parent.GameInfoStoreTypes)

local LuauPolyfill = require(parent.LuauPolyfill)
local trim = LuauPolyfill.String.trim

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppInExperienceDetailsPrompt = SharedFlags.FFlagLuaAppInExperienceDetailsPrompt

local SharedFlags2 = require(parent.SharedFlags)
local FFlagLuaAppDataHydrationPlayerCountGameInfoStore = SharedFlags2.FFlagLuaAppDataHydrationPlayerCountGameInfoStore

local SharedFlags3 = require(parent.SharedFlags)
local GetFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds = SharedFlags3.GetFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds
local SharedFlags4 = require(parent.SharedFlags)
local FFlagLuaAppDataHydrationUpdateItem = SharedFlags4.FFlagLuaAppDataHydrationUpdateItem
local SharedFlags5 = require(parent.SharedFlags)
local FFlagMigrateGameInfoToStore = SharedFlags5.FFlagMigrateGameInfoToStore
local v

if FFlagLuaAppInExperienceDetailsPrompt then
	v = GetFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds()
else
	v = nil
end

local function sanitizeGameInfo(p)
	if p.name then
		p.name = trim(p.name)
	end

	return p
end

local function createGameInfoStore()
	local v2 = {}

	local function indexPlaceId(p: string, p2) -- 3 equivalent calls inferred from this helper
		if p2 and p2.rootPlaceId then
			v2[tostring(p2.rootPlaceId)] = p
		end
	end

	local cache

	if FFlagLuaAppInExperienceDetailsPrompt then
		cache = createDataCache(v, nil, { sanitizeItem = sanitizeGameInfo })
	else
		cache = createDataCache(nil, nil, { sanitizeItem = sanitizeGameInfo })
	end

	local dataResolver = createDataResolver({
		cache = cache,
		logError = FFlagLuaAppInExperienceDetailsPrompt and function(data)
			if type(data) == "table" then
				if data.responseCode then
					logResponseError("v1/games/universeIds", {
						StatusCode = tonumber(data.responseCode)
					})
				end

				if data.errorType and data.errorMessage then
					DiscoveryEventErrorLogger.reportError(data.errorType, data.errorMessage, data.customFields)
				end
			else
				DiscoveryEventErrorLogger.reportError("FetchGameDetailsError", (tostring(data)))
			end
		end or nil,
		fetchFn = function(p)
			local keys = Dash.keys(p)
			return fetchGameDetails(keys):andThen(function(data)
				if FFlagLuaAppInExperienceDetailsPrompt then
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

				if FFlagLuaAppInExperienceDetailsPrompt then
					local gameInfoResponseValidator, errorMessage = GameInfoStoreTypes.gameInfoResponseValidator(data.responseBody)

					if not gameInfoResponseValidator then
						error({
							responseCode = data.responseCode,
							errorType = "FetchGameDetailsResponseInvalidInterface",
							errorMessage = errorMessage,
							customFields = { universeIds = keys }
						})
					end
				end

				local result = {}
				local data2 = data.responseBody.data

				if FFlagLuaAppInExperienceDetailsPrompt then
					for _, v3 in data2 do
						if not v3 then
							continue
						end

						local id = tostring(v3.id)
						local v4 = {
							name = v3.name,
							rootPlaceId = tostring(v3.rootPlaceId),
							universeId = tostring(v3.id),
							description = v3.description,
							creator = v3.creator and {
								id = tostring(v3.creator.id),
								name = v3.creator.name,
								hasVerifiedBadge = v3.creator.hasVerifiedBadge
							} or nil,
							playerCount = 0,
							totalVisits = 0
						}
						local playerCount

						if FFlagLuaAppDataHydrationPlayerCountGameInfoStore then
							playerCount = v3.playing
						end

						v4.playerCount = playerCount

						v4.totalVisits = v3.visits
						result[id] = v4
					end

					for _, key in keys do
						if not result[tostring(key)] then
							result[tostring(key)] = { isUnavailable = true }
						end
					end
				else
					Dash.forEach(data2, function(data3)
						local id = tostring(data3.id)
						local v3 = {
							name = data3.name,
							rootPlaceId = tostring(data3.rootPlaceId),
							universeId = tostring(data3.id),
							playerCount = 0,
							totalVisits = 0
						}
						local playerCount

						if FFlagLuaAppDataHydrationPlayerCountGameInfoStore then
							playerCount = data3.playing
						end

						v3.playerCount = playerCount

						v3.totalVisits = data3.visits
						result[id] = v3
					end)
				end

				if FFlagMigrateGameInfoToStore then
					for k, v3 in result do
						indexPlaceId(k, v3) -- inferred equivalent call
					end
				end

				return result
			end):catch(function(message)
				error(message)
			end)
		end
	})

	local function updateGameInfo(p: string, p2, flag: boolean?)
		indexPlaceId(p, p2) -- inferred equivalent call

		if FFlagMigrateGameInfoToStore then
			cache.updateItem(p, p2, flag)
		else
			cache.updateItem(p, p2)
		end
	end

	local function updateGameInfos(items, flag: boolean?)
		for k, item in items do
			indexPlaceId(k, item) -- inferred equivalent call
		end

		if FFlagMigrateGameInfoToStore then
			cache.updateItems(items, flag)
		else
			cache.updateItems(items)
		end
	end

	local function getUniverseIdForPlaceId(p)
		return v2[tostring(p)]
	end

	local function clear()
		if not FFlagLuaAppInExperienceDetailsPrompt then
			cache.clear()
			dataResolver.clear()
		end
	end

	local function dispose()
		if not FFlagLuaAppInExperienceDetailsPrompt then
			cache.dispose()
			dataResolver.dispose()
		end
	end

	local gameInfoStore = {
		fetchGameInfo = dataResolver.fetchItem,
		fetchGameInfos = dataResolver.fetchItems,
		getGameInfo = dataResolver.getCachedItem,
		getGameInfos = dataResolver.getCachedItems,
		getAndFetchGameInfo = dataResolver.getAndFetchItem,
		getAndFetchGameInfos = dataResolver.getAndFetchItems,
		updateGameInfo = 0,
		updateGameInfos = 0,
		getUniverseIdForPlaceId = 0,
		applyVoteChange = 0,
		clear = 0,
		dispose = 0
	}

	if FFlagLuaAppDataHydrationUpdateItem then
		if not FFlagMigrateGameInfoToStore then
			updateGameInfo = cache.updateItem
		end
	else
		updateGameInfo = nil
	end

	gameInfoStore.updateGameInfo = updateGameInfo

	if not FFlagMigrateGameInfoToStore then
		updateGameInfos = cache.updateItems
	end

	gameInfoStore.updateGameInfos = updateGameInfos

	if not FFlagMigrateGameInfoToStore then
		getUniverseIdForPlaceId = nil
	end

	gameInfoStore.getUniverseIdForPlaceId = getUniverseIdForPlaceId

	function gameInfoStore.applyVoteChange(p: string, flag: boolean?, flag2: boolean?)
		local cachedItem = dataResolver.getCachedItem(p)
		local v3 = cachedItem and cachedItem.data(false)

		if not v3 or v3.totalUpVotes == nil then
			return nil
		end

		local totalUpVotes = tonumber(v3.totalUpVotes) or 0
		local totalDownVotes = tonumber(v3.totalDownVotes) or 0
		local v4 = { totalUpVotes = v3.totalUpVotes, totalDownVotes = v3.totalDownVotes }

		local v5 = (flag2 == true and 1 or 0) - (flag == true and 1 or 0)
		local v6 = (flag2 == false and 1 or 0) - (flag == false and 1 or 0)

		if FFlagMigrateGameInfoToStore then
			cache.updateItem(p, {
				totalUpVotes = tostring((math.max(0, totalUpVotes + v5))),
				totalDownVotes = tostring((math.max(0, totalDownVotes + v6)))
			}, false)
			return v4
		end

		cache.updateItem(p, {
			totalUpVotes = tostring((math.max(0, totalUpVotes + v5))),
			totalDownVotes = tostring((math.max(0, totalDownVotes + v6)))
		})

		return v4
	end

	if FFlagLuaAppInExperienceDetailsPrompt then
		clear = dataResolver.clear
	end

	gameInfoStore.clear = clear

	if FFlagLuaAppInExperienceDetailsPrompt then
		dispose = dataResolver.dispose
	end

	gameInfoStore.dispose = dispose
	return gameInfoStore
end

return createGameInfoStore
