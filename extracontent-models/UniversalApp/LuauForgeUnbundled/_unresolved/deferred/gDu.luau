local RunService = game:GetService("RunService")

local promiseUtilities = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Utils.PromiseUtilities
local module = require("@luauforge/bundled/dCS")
local setNextDataExpirationTime = module.SetNextDataExpirationTime
local nextDataExpirationTimeReducer = module.NextDataExpirationTimeReducer
local expirationTimeNamespace = module.ExpirationTimeNamespace
local apiFetchVoiceChatOptInStatus = require("@luauforge/bundled/dBN").OptInStatus.ApiFetchVoiceChatOptInStatus
local fetchGamePlayButtonData = require("@luauforge/bundled/fIC").FetchGamePlayButtonData

local module2 = require("@luauforge/bundled/gCs")
local module3 = require("@luauforge/bundled/gCC")
local module4 = require("@luauforge/deferred/gDv")
local module5 = require("@luauforge/deferred/gBI")
local module6 = require("@luauforge/deferred/gBM")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")
local module8 = require("@luauforge/deferred/gBN")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local fVariable = tonumber(settings():GetFVariable("LuaAppGameDetailsRefreshIntervalInSeconds"))

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local fFlagLuaAppEdpBackendV2SduiInterleaveDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveDefault

local fFlagLuaAppEdpBackendV2SduiInterleaveIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveIxp
local fFlagLuaAppEdpFetchLatencyTracking = SharedFlags.FFlagLuaAppEdpFetchLatencyTracking

local defineFastInt = game:DefineFastInt("EdpFetchLatencyTrackingThrottlingHundredthsPercent", 1000)

local fFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure

local fFlagLuaAppEdpBackendV2LogUniverseIdForEvents = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2LogUniverseIdForEvents
local v5, v6

if fFlagLuaAppEdpFetchLatencyTracking then
	v5 = {
		eventName = "experienceDetailsFetchLatency",
		backends = { LoggingProtocol.TelemetryBackends.Points, LoggingProtocol.TelemetryBackends.EventIngest },
		throttlingPercentage = defineFastInt,
		description = "\"Latency measurement for EDP first class promise fetch batch\"",
		lastUpdated = { 25, 8, 20 },
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
	}

	v6 = {
		eventName = "experienceDetailsFetchLatencyMissingStartTime",
		backends = { LoggingProtocol.TelemetryBackends.Points, LoggingProtocol.TelemetryBackends.EventIngest },
		throttlingPercentage = defineFastInt,
		description = "\"Missing start time for EDP first class promise fetch batch\"",
		lastUpdated = { 25, 8, 20 },
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w"
	}
else
	v5 = nil
	v6 = nil
end

local function logMissingDataMetrics(state, p2)
	if state.GameDetailsV2[p2] == nil then
		module6.logFetchMissingData("gameDetails")
	end

	if state.GameMedia[p2] == nil then
		module6.logFetchMissingData("gameMedia")
	end

	if state.AgeRecommendations[p2] == nil then
		module6.logFetchMissingData("ageRecommendations")
	end

	if state.GameVotes[p2] == nil then
		module6.logFetchMissingData("gameVotes")
	end

	if state.GameFavorites[p2] == nil then
		module6.logFetchMissingData("gameFavorites")
	end

	if state.GameFollowings[p2] == nil then
		module6.logFetchMissingData("gameFollowings")
	end

	if state.AssetTextFilterSettings[p2] == nil then
		module6.logFetchMissingData("assetTextFilterSettings")
	end

	if state.GamePrivateServersEnabled[p2] == nil then
		module6.logFetchMissingData("gamePrivateServersEnabled")
	end
end

local function startFirstClassFetchPromises(p2, object, p3, p4, p5, p6, p7, p8)
	local v7 = {}

	if not fFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure then
		module6.logFetchRequest("initial")

		if p5 then
			module6.logFetchRequest("forceRefresh")
		end
	end

	local state = object:getState()
	local v8 = state.GameDetailsV2[p3] == nil
		or state.GameMedia[p3] == nil
		or state.AgeRecommendations[p3] == nil
		or state.GameVotes[p3] == nil
		or state.GameFavorites[p3] == nil
		or state.GameFollowings[p3] == nil
		or state.AssetTextFilterSettings[p3] == nil
		or state.GamePrivateServersEnabled[p3] == nil

	if v8 and not p5 then
		logMissingDataMetrics(state, p3)
	end

	local v9

	if fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and p7 then
		v9 = module8.checkEdpDataStaleness(p8, fVariable)

		if v9 then
			module6.logFetchRequest("sduiStale")
		else
			module6.logFetchRequest("sduiFresh")
		end
	end

	if
		p5
		or v8
		or (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and p7)
		and v9
	then
		if fFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure then
			if p5 then
				module6.logFetchRequest(
					"forceRefresh",
					if fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then p3 else nil
				)
			else
				module6.logFetchRequest(
					"initial",
					if fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then p3 else nil
				)
			end
		end

		local fetch = module5.Fetch

		if not fFlagLuaAppEdpBackendV2HydrateLegacyIxp then
			p6 = nil
		end

		if not fFlagLuaAppEdpBackendV2SduiInterleaveIxp then
			p7 = nil
		end

		table.insert(v7, object:dispatch(fetch(p2, p3, p6, p7)))
	end

	if p5 or object:getState().VoiceChatOptInStatus == nil then
		object:dispatch(apiFetchVoiceChatOptInStatus.Fetch(p2))
	end

	return v7
end

local function startSecondClassFetchPromises(p2, object, p3, p4, p5)
	if p4 or object:getState().GamePrivateServersEnabled[p3] == nil then
		object:dispatch(module4(p2, p3))
	end

	if p4 or object:getState().GameSubscriptionProducts[p3] == nil then
		object:dispatch(module3(p2, p3))
	end

	if p4 or object:getState().GameDeveloperProducts[p3] == nil then
		local state = object:getState()
		local v7 = state.GameDetailsV2[p3]

		if v7 and v7.rootPlaceId and state.LocalUserId then
			object:dispatch(module2(p2, p3, v7.rootPlaceId, state.LocalUserId))
		end
	end
end

return function(p2, value, p3, p4, p5, p6)
	if type(value) ~= "string" then
		error(string.format(
			"FetchGameDetailsPageData thunk expects universeId to be a string. Got type: '%s', value: '%s'",
			type(value),
			(tostring(value))
		))
	end

	return function(object)
		local now = tick()

		local v8 = object:getState().Personalization[nextDataExpirationTimeReducer.key][expirationTimeNamespace.GameDetailPage]

		local v9 = if v8 then v8[value] else nil

		local v10 = v9 == nil or v9 < now or false

		object:dispatch(fetchGamePlayButtonData.Fetch(p2, value))
		local v16 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then p4 else nil
		local v17 = if fFlagLuaAppEdpBackendV2SduiInterleaveIxp then p5 else nil
		local v18

		if
			fFlagLuaAppEdpBackendV2SduiInterleaveDefault
			or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and p5
		then
			v18 = p6
		end

		local v19 = startFirstClassFetchPromises(p2, object, value, p3, v10, v16, v17, v18)

		if #v19 > 0 then
			local Warn = if _G.__TESTEZ_RUNNING_TEST__ or RunService:IsStudio() then warn else nil
			local lastTime, v20

			if fFlagLuaAppEdpFetchLatencyTracking then
				lastTime = tick()
				v20 = 2
			else
				lastTime = nil
				v20 = nil
			end

			return promiseUtilities.Batch(v19, Warn):andThen(function(p7)
				promiseUtilities.CountResults(p7)

				if object:getState().GameDetailsV2[value] ~= nil then
					now = tick()
					v9 = math.floor(now + fVariable)
					object:dispatch(setNextDataExpirationTime(
						value,
						v9,
						expirationTimeNamespace.GameDetailPage
					))
				end

				startSecondClassFetchPromises(
					p2,
					object,
					value,
					v10,
					if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then p4 else nil
				)
			end):finally(function()
				if fFlagLuaAppEdpFetchLatencyTracking and v5 and lastTime then
					local v21 = (tick() - lastTime) * 1000
					LoggingProtocol.default:logRobloxTelemetryEvent(v5, nil, {
						latencyMs = v21,
						backendVersion = v20,
						universeId = value
					})
				elseif fFlagLuaAppEdpFetchLatencyTracking and v6 then
					LoggingProtocol.default:logRobloxTelemetryEvent(v6, nil, {
						universeId = value
					})
				end
			end)
		end

		startSecondClassFetchPromises(
			p2,
			object,
			value,
			v10,
			if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then p4 else nil
		)
	end
end
