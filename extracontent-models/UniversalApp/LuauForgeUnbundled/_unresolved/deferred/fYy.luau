local RunService = game:GetService("RunService")

local module = require("@luauforge/bundled/cyO")
local promiseUtilities = require("@game/CorePackages/Workspace/Packages/AppCommonLib").Utils.PromiseUtilities
local uiMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").UiMode
local getAppFeaturePolicies = require("@game/CorePackages/Workspace/Packages/UniversalAppPolicy").getAppFeaturePolicies
local module2 = require("@luauforge/bundled/dzN")
local setNextDataExpirationTime = module2.SetNextDataExpirationTime
local nextDataExpirationTimeReducer = module2.NextDataExpirationTimeReducer
local expirationTimeNamespace = module2.ExpirationTimeNamespace
local apiFetchGameDetails = require("@luauforge/bundled/dyi").GameDetails.ApiFetchGameDetails

local apiFetchAgeRecommendations = require("@luauforge/bundled/dyi").AgeRecommendations.ApiFetchAgeRecommendations
local apiFetchVoiceChatOptInStatus = require("@luauforge/bundled/dyK").OptInStatus.ApiFetchVoiceChatOptInStatus
local fetchGameVotes = require("@luauforge/bundled/dyO").GameVotes.FetchGameVotes

local apiFetchExperienceCommunityLink = require("@luauforge/bundled/dBe").Thunks.ApiFetchExperienceCommunityLink
local fetchGamePlayButtonData = require("@luauforge/bundled/fWH").FetchGamePlayButtonData
local module3 = require("@luauforge/bundled/dPI")
local dataStatus = require("@luauforge/bundled/dPI").DataStatus

local apiFetchGameMedia = require("@luauforge/bundled/dpZ").Modules.LuaApp.Thunks.Games.ApiFetchGameMedia

local module4 = require("@luauforge/bundled/fYz")
local module5 = require("@luauforge/bundled/fYB")
local module6 = require("@luauforge/deferred/fYD")
local module7 = require("@luauforge/bundled/fXj")
local module8 = require("@luauforge/bundled/fXw")
local module9 = require("@luauforge/bundled/fXG")
local module10 = require("@luauforge/deferred/fYF")
local module11 = require("@luauforge/deferred/fYH")
local module12 = require("@luauforge/deferred/fYJ")
local module13 = require("@luauforge/deferred/fYL")
local module14 = require("@luauforge/deferred/fWL")
local module15 = require("@luauforge/deferred/fWP")
local LoggingProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/CoreScriptsErrorBoundary/LoggingProtocol")
local module17 = require("@luauforge/deferred/fWQ")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")

local fVariable = tonumber(settings():GetFVariable("LuaAppGameDetailsRefreshIntervalInSeconds"))
local module19 = require("@luauforge/deferred/fYN")
local module20 = require("@luauforge/deferred/fYO")

local fFlagLuaAppEdpBackendV2HydrateLegacyDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyDefault

local fFlagLuaAppEdpBackendV2HydrateLegacyIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2HydrateLegacyIxp

local fFlagLuaAppEdpBackendV2SduiInterleaveDefault = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveDefault

local fFlagLuaAppEdpBackendV2SduiInterleaveIxp = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2SduiInterleaveIxp
local fFlagLuaAppEdpFetchLatencyTracking = SharedFlags.FFlagLuaAppEdpFetchLatencyTracking

local defineFastInt = game:DefineFastInt("EdpFetchLatencyTrackingThrottlingHundredthsPercent", 1000)

local fFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure

local fFlagLuaAppEdpBackendV2LogUniverseIdForEvents = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppEdpBackendV2LogUniverseIdForEvents

local fFlagLuaAppGamePassesDataHydrationMigrationEnabled = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppGamePassesDataHydrationMigrationEnabled
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
		module15.logFetchMissingData("gameDetails")
	end

	if state.GameMedia[p2] == nil then
		module15.logFetchMissingData("gameMedia")
	end

	if state.AgeRecommendations[p2] == nil then
		module15.logFetchMissingData("ageRecommendations")
	end

	if state.GameVotes[p2] == nil then
		module15.logFetchMissingData("gameVotes")
	end

	if state.GameFavorites[p2] == nil then
		module15.logFetchMissingData("gameFavorites")
	end

	if state.GameFollowings[p2] == nil then
		module15.logFetchMissingData("gameFollowings")
	end

	if state.AssetTextFilterSettings[p2] == nil then
		module15.logFetchMissingData("assetTextFilterSettings")
	end

	if state.GamePrivateServersEnabled[p2] == nil then
		module15.logFetchMissingData("gamePrivateServersEnabled")
	end
end

local function startFirstClassFetchPromises(p2, object, p3, p4, p5, p6, p7, p8)
	local v7 = {}

	if
		fFlagLuaAppEdpBackendV2HydrateLegacyDefault
		or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p6
		or fFlagLuaAppEdpBackendV2SduiInterleaveDefault
		or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and p7
	then
		if not fFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure then
			module15.logFetchRequest("initial")

			if p5 then
				module15.logFetchRequest("forceRefresh")
			end
		end

		local v8

		if
			fFlagLuaAppEdpBackendV2HydrateLegacyDefault
			or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p6
		then
			local state = object:getState()
			v8 = state.GameDetailsV2[p3] == nil
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
		end

		local v9

		if
			fFlagLuaAppEdpBackendV2SduiInterleaveDefault
			or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and p7
		then
			v9 = module17.checkEdpDataStaleness(p8, fVariable)

			if v9 then
				module15.logFetchRequest("sduiStale")
			else
				module15.logFetchRequest("sduiFresh")
			end
		end

		if
			p5
			or (fFlagLuaAppEdpBackendV2HydrateLegacyDefault or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p6)
			and v8
			or (fFlagLuaAppEdpBackendV2SduiInterleaveDefault or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and p7)
			and v9
		then
			if fFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure then
				if p5 then
					module15.logFetchRequest(
						"forceRefresh",
						if fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then p3 else nil
					)
				else
					module15.logFetchRequest(
						"initial",
						if fFlagLuaAppEdpBackendV2LogUniverseIdForEvents then p3 else nil
					)
				end
			end

			local fetch = module14.Fetch
			local v10 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then p6 else nil

			if not fFlagLuaAppEdpBackendV2SduiInterleaveIxp then
				p7 = nil
			end

			table.insert(v7, object:dispatch(fetch(p2, p3, v10, p7)))
		end

		if
			fFlagLuaAppEdpBackendV2HydrateLegacyDefault
			or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p6
		then
			if p5 or object:getState().VoiceChatOptInStatus == nil then
				object:dispatch(apiFetchVoiceChatOptInStatus.Fetch(p2))
			end

			return v7
		end
	end

	if p5 or object:getState().GameDetails[p3] == nil then
		table.insert(v7, object:dispatch(apiFetchGameDetails.Fetch(p2, { p3 })))
	end

	if p5 or object:getState().VoiceChatOptInStatus == nil then
		object:dispatch(apiFetchVoiceChatOptInStatus.Fetch(p2))
	end

	if p5 or object:getState().GameMedia[p3] == nil then
		table.insert(v7, object:dispatch(apiFetchGameMedia.Fetch(p2, p3)))
	end

	if p5 or object:getState().AgeRecommendations[p3] == nil then
		table.insert(v7, object:dispatch(apiFetchAgeRecommendations.Fetch(p2, p3)))
	end

	if module20() and module19() and p4 and p4.uiMode == uiMode.TenFoot then
		module3.Game.getGameIconStore(false).getAndFetchGameIcons(
			{ p3 },
			module3.Game.GameIconSize.Large,
			p5 and function(): boolean
				return true
			end or nil
		)
	end

	module3.Game.getGameIconStore(false).getAndFetchGameIcons({ p3 })

	return v7
end

local function startSecondClassFetchPromises(p2, object, p3, p4, p5)
	if fFlagLuaAppEdpBackendV2HydrateLegacyDefault or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p5 then
		if p4 or object:getState().GamePrivateServersEnabled[p3] == nil then
			object:dispatch(module13(p2, p3))
		end

		if p4 or object:getState().GameSubscriptionProducts[p3] == nil then
			object:dispatch(module9(p2, p3))
		end

		if p4 or object:getState().GameDeveloperProducts[p3] == nil then
			local state = object:getState()
			local v7 = state.GameDetailsV2[p3]

			if v7 and v7.rootPlaceId and state.LocalUserId then
				object:dispatch(module8(p2, p3, v7.rootPlaceId, state.LocalUserId))
			end
		end
	else
		if p4 or object:getState().GameVotes[p3] == nil then
			object:dispatch(fetchGameVotes.Fetch(p2, p3))
		end

		if p4 or object:getState().GameFavorites[p3] == nil then
			object:dispatch(module4(p2, p3))
		end

		if p4 or object:getState().GameFollowings[p3] == nil then
			object:dispatch(module5(p2, p3))
		end

		if p4 or object:getState().GameSocialLinks[p3] == nil then
			object:dispatch(module6(p2, p3))
		end

		if p4 or object:getState().RecommendedGameEntries[p3] == nil then
			object:dispatch(module11.Fetch(p2, p3, {
				maxRows = module.Constants.MAX_RECOMMENDED_GAMES_FETCH_COUNT
			}))
		end

		if fFlagLuaAppGamePassesDataHydrationMigrationEnabled then
			local status = module3.Game.getGamePassStore(false).getPassesForUniverse(p3).status(false)

			if p4 or status == dataStatus.NotReady or status == dataStatus.Failed then
				module3.Game.getGamePassStore(false).fetchPassesForUniverse(p3)
			end
		elseif p4 or object:getState().GamePasses[p3] == nil then
			object:dispatch(module7(p2, p3))
		end

		if p4 or object:getState().GameSubscriptionProducts[p3] == nil then
			object:dispatch(module9(p2, p3))
		end

		if p4 or object:getState().GameDeveloperProducts[p3] == nil then
			local state = object:getState()
			local gameDetail = state.GameDetails[p3]

			if gameDetail and gameDetail.rootPlaceId and state.LocalUserId then
				object:dispatch(module8(p2, p3, gameDetail.rootPlaceId, state.LocalUserId))
			end
		end

		if p4 or object:getState().GameBadges[p3] == nil then
			object:dispatch(module10(p2, p3))
		end

		if p4 or object:getState().AssetTextFilterSettings[p3] == nil then
			object:dispatch(module12.Fetch(p2, p3))
		end

		if p4 or object:getState().GamePrivateServersEnabled[p3] == nil then
			object:dispatch(module13(p2, p3))
		end

		if
			getAppFeaturePolicies().getCommunityLinksEnabled()
			and (p4 or object:getState().CommunityLinks.ExperienceCommunityLinks[p3] == nil)
		then
			object:dispatch(apiFetchExperienceCommunityLink(p2, p3))
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
		local v15 = if fFlagLuaAppEdpBackendV2HydrateLegacyIxp then p4 else nil
		local v16 = if fFlagLuaAppEdpBackendV2SduiInterleaveIxp then p5 else nil
		local v17

		if
			fFlagLuaAppEdpBackendV2SduiInterleaveDefault
			or fFlagLuaAppEdpBackendV2SduiInterleaveIxp and p5
		then
			v17 = p6
		end

		local v18 = startFirstClassFetchPromises(p2, object, value, p3, v10, v15, v16, v17)

		if #v18 > 0 then
			local Warn = if _G.__TESTEZ_RUNNING_TEST__ or RunService:IsStudio() then warn else nil
			local v19, lastTime

			if fFlagLuaAppEdpFetchLatencyTracking then
				v19 = (fFlagLuaAppEdpBackendV2HydrateLegacyDefault or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p4)
					and 2
					or 1
				lastTime = tick()
			else
				lastTime = nil
				v19 = nil
			end

			return promiseUtilities.Batch(v18, Warn):andThen(function(p7)
				promiseUtilities.CountResults(p7)
				local v20

				if
					fFlagLuaAppEdpBackendV2HydrateLegacyDefault
					or fFlagLuaAppEdpBackendV2HydrateLegacyIxp and p4
				then
					v20 = object:getState().GameDetailsV2[value]
				else
					v20 = object:getState().GameDetails[value]
				end

				if v20 ~= nil then
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
					local v20 = (tick() - lastTime) * 1000
					LoggingProtocol.default:logRobloxTelemetryEvent(v5, nil, {
						latencyMs = v20,
						backendVersion = v19,
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
