local DataHydration = script:FindFirstAncestor("DataHydration")
local DataHydrationParent = DataHydration.Parent
local Dash = require(DataHydrationParent.Dash)
local DiscoveryUtils = require(DataHydrationParent.DiscoveryUtils)
local logResponseError = DiscoveryUtils.logResponseError
local DiscoveryEventErrorLogger = DiscoveryUtils.DiscoveryEventErrorLogger
local createDataCache = require(DataHydration.createDataCache)
local createDataResolver = require(DataHydration.createDataResolver)

require(DataHydration.DataHydrationTypes)

local fetchGameDetails = require(script.Parent.fetchGameDetails)
local GameInfoStoreTypes = require(script.Parent.GameInfoStoreTypes)
local trim = require(DataHydrationParent.LuauPolyfill).String.trim
local FFlagLuaAppInExperienceDetailsPrompt = require(DataHydrationParent.SharedFlags).FFlagLuaAppInExperienceDetailsPrompt
local FFlagLuaAppDataHydrationPlayerCountGameInfoStore = require(DataHydrationParent.SharedFlags).FFlagLuaAppDataHydrationPlayerCountGameInfoStore
local GetFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds = require(DataHydrationParent.SharedFlags).GetFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds
local FFlagLuaAppDataHydrationUpdateItem = require(DataHydrationParent.SharedFlags).FFlagLuaAppDataHydrationUpdateItem
local FFlagSduiExperienceDetailsSupport = require(DataHydrationParent.SharedFlags).FFlagSduiExperienceDetailsSupport
local FFlagLuaAppDataHydrationSanitizeItem = require(DataHydrationParent.SharedFlags).FFlagLuaAppDataHydrationSanitizeItem
local v18 = if not FFlagLuaAppInExperienceDetailsPrompt then nil else GetFIntLuaAppThrottleRefreshPlayabilityIntervalSeconds()

local function sanitizeGameInfo(p1) -- line: 37
	-- upvalues: trim (copy)
	if p1.name then
		p1.name = trim(p1.name)
	end

	return p1
end
local function createGameInfoStore() -- line: 44
	-- upvalues: FFlagLuaAppInExperienceDetailsPrompt (copy), createDataCache (copy), v18 (copy), FFlagLuaAppDataHydrationSanitizeItem (copy), sanitizeGameInfo (copy), createDataResolver (copy), logResponseError (copy), DiscoveryEventErrorLogger (copy), Dash (copy), fetchGameDetails (copy), GameInfoStoreTypes (copy), FFlagLuaAppDataHydrationPlayerCountGameInfoStore (copy), FFlagLuaAppDataHydrationUpdateItem (copy), FFlagSduiExperienceDetailsSupport (copy)
	local v22 = if not FFlagLuaAppInExperienceDetailsPrompt then createDataCache(nil, nil, if not FFlagLuaAppDataHydrationSanitizeItem then nil else {
		sanitizeItem = sanitizeGameInfo
	}) else createDataCache(v18, nil, if not FFlagLuaAppDataHydrationSanitizeItem then nil else {
		sanitizeItem = sanitizeGameInfo
	})
	local v23 = createDataResolver({
		cache = v22,
		logError = if not FFlagLuaAppInExperienceDetailsPrompt then nil else function(p2) -- line: 59
			-- upvalues: logResponseError (copy), DiscoveryEventErrorLogger (copy)
			if type(p2) == "table" then
				if p2.responseCode then
					logResponseError("v1/games/universeIds", {
						StatusCode = tonumber(p2.responseCode)
					})
				end

				if p2.errorType and p2.errorMessage then
					DiscoveryEventErrorLogger.reportError(p2.errorType, p2.errorMessage, p2.customFields)

					return
				end
			else
				DiscoveryEventErrorLogger.reportError("FetchGameDetailsError", (tostring(p2)))
			end
		end,
		fetchFn = function(t1: {[any]: any}) -- line: 77
			-- upvalues: Dash (copy), fetchGameDetails (copy), FFlagLuaAppInExperienceDetailsPrompt (copy), GameInfoStoreTypes (copy), FFlagLuaAppDataHydrationPlayerCountGameInfoStore (copy)
			local v29 = Dash.keys(t1)

			return fetchGameDetails(v29):andThen(function(p3) -- line: 82
				-- upvalues: FFlagLuaAppInExperienceDetailsPrompt (copy), v29 (copy), GameInfoStoreTypes (copy), FFlagLuaAppDataHydrationPlayerCountGameInfoStore (copy), Dash (copy)
				if FFlagLuaAppInExperienceDetailsPrompt then
					if not p3 or not p3.responseBody then
						error({
							errorType = "FetchGameDetailsResponseError",
							responseCode = p3 and p3.responseCode,
							errorMessage = not p3 and "No response" or "Missing response body",
							customFields = {
								universeIds = v29
							}
						})
					end
				else
					if not p3 then
						error("No response")
					end

					if not p3.responseBody or not p3.responseBody.data then
						error(`Response Code: { p3.reponseCode }`)
					end
				end

				if FFlagLuaAppInExperienceDetailsPrompt then
					local v41, v42 = GameInfoStoreTypes.gameInfoResponseValidator(p3.responseBody)

					if not v41 then
						error({
							errorType = "FetchGameDetailsResponseInvalidInterface",
							responseCode = p3.responseCode,
							errorMessage = v42,
							customFields = {
								universeIds = v29
							}
						})
					end
				end

				local t2 = {}
				local data = p3.responseBody.data

				if FFlagLuaAppInExperienceDetailsPrompt then
					for _, v46 in data do
						if v46 then
							t2[tostring(v46.id)] = {
								name = v46.name,
								rootPlaceId = tostring(v46.rootPlaceId),
								universeId = tostring(v46.id),
								description = v46.description,
								creator = if not v46.creator then nil else {
									id = tostring(v46.creator.id),
									name = v46.creator.name,
									hasVerifiedBadge = v46.creator.hasVerifiedBadge
								},
								playerCount = if not FFlagLuaAppDataHydrationPlayerCountGameInfoStore then nil else v46.playing
							}
						end
					end

					for _, v48 in v29 do
						if not t2[tostring(v48)] then
							t2[tostring(v48)] = {
								isUnavailable = true
							}
						end
					end

					return t2
				end

				Dash.forEach(data, function(p4) -- line: 145
					-- upvalues: t2 (copy), FFlagLuaAppDataHydrationPlayerCountGameInfoStore (copy)
					t2[tostring(p4.id)] = {
						name = p4.name,
						rootPlaceId = tostring(p4.rootPlaceId),
						universeId = tostring(p4.id),
						playerCount = if not FFlagLuaAppDataHydrationPlayerCountGameInfoStore then nil else p4.playing
					}
				end)

				return t2
			end):catch(function(p5) -- line: 159
				error(p5)
			end)
		end
	})

	local function applyVoteChange(s1: string, b1: boolean?, b2: boolean?) -- line: 165
		-- upvalues: v23 (copy), v22 (copy)
		local v33 = v23.getCachedItem(s1)
		local v34 = v33 and v33.data(false)

		if not v34 or v34.totalUpVotes == nil then
			return nil
		end

		local v35 = tonumber(v34.totalUpVotes) or 0
		local v36 = tonumber(v34.totalDownVotes) or 0
		local t3 = {
			totalUpVotes = v34.totalUpVotes,
			totalDownVotes = v34.totalDownVotes
		}
		local v38 = (b2 ~= true and 0 or 1) - (b1 ~= true and 0 or 1)
		local v39 = (b2 ~= false and 0 or 1) - (b1 ~= false and 0 or 1)

		v22.updateItem(s1, {
			totalUpVotes = tostring((math.max(0, v35 + v38))),
			totalDownVotes = tostring((math.max(0, v36 + v39)))
		})

		return t3
	end
	local function clear() -- line: 191
		-- upvalues: FFlagLuaAppInExperienceDetailsPrompt (copy), v22 (copy), v23 (copy)
		if not FFlagLuaAppInExperienceDetailsPrompt then
			v22.clear()
			v23.clear()
		end
	end
	local function dispose() -- line: 198
		-- upvalues: FFlagLuaAppInExperienceDetailsPrompt (copy), v22 (copy), v23 (copy)
		if not FFlagLuaAppInExperienceDetailsPrompt then
			v22.dispose()
			v23.dispose()
		end
	end

	return {
		fetchGameInfo = v23.fetchItem,
		fetchGameInfos = v23.fetchItems,
		getGameInfo = v23.getCachedItem,
		getGameInfos = v23.getCachedItems,
		getAndFetchGameInfo = v23.getAndFetchItem,
		getAndFetchGameInfos = v23.getAndFetchItems,
		updateGameInfo = if not FFlagLuaAppDataHydrationUpdateItem then nil else v22.updateItem,
		updateGameInfos = v22.updateItems,
		applyVoteChange = if not FFlagSduiExperienceDetailsSupport then nil else applyVoteChange,
		clear = if not FFlagLuaAppInExperienceDetailsPrompt then clear else v23.clear,
		dispose = if not FFlagLuaAppInExperienceDetailsPrompt then dispose else v23.dispose
	}
end

return createGameInfoStore
