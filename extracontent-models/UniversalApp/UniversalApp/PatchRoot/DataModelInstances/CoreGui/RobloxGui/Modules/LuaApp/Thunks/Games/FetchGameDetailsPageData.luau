local RunService = game:GetService("RunService")
local CorePackages = game:GetService("CorePackages")
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local PromiseUtilities = require(CorePackages.Workspace.Packages.AppCommonLib).Utils.PromiseUtilities
local UiMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).UiMode
local getAppFeaturePolicies = require(CorePackages.Workspace.Packages.UniversalAppPolicy).getAppFeaturePolicies
local NextDataExpirationTimeRodux = require(CorePackages.Workspace.Packages.NextDataExpirationTimeRodux)
local SetNextDataExpirationTime = NextDataExpirationTimeRodux.SetNextDataExpirationTime
local NextDataExpirationTimeReducer = NextDataExpirationTimeRodux.NextDataExpirationTimeReducer
local ExpirationTimeNamespace = NextDataExpirationTimeRodux.ExpirationTimeNamespace
local ApiFetchGameDetails = require(CorePackages.Workspace.Packages.GameDetailRodux).GameDetails.ApiFetchGameDetails
local ApiFetchAgeRecommendations = require(CorePackages.Workspace.Packages.GameDetailRodux).AgeRecommendations.ApiFetchAgeRecommendations
local ApiFetchVoiceChatOptInStatus = require(CorePackages.Workspace.Packages.VoiceChat).OptInStatus.ApiFetchVoiceChatOptInStatus
local FetchGameVotes = require(CorePackages.Workspace.Packages.GameVotesRodux).GameVotes.FetchGameVotes
local ApiFetchExperienceCommunityLink = require(CorePackages.Workspace.Packages.CommunityLinks).Thunks.ApiFetchExperienceCommunityLink
local FetchGamePlayButtonData = require(CorePackages.Workspace.Packages.GamePlayButton).FetchGamePlayButtonData
local GameIconRodux = require(CorePackages.Workspace.Packages.GameIconRodux)
local BigGameIconReducer = GameIconRodux.BigGameIcons.BigGameIconReducer
local GameIconReducer = GameIconRodux.GameIcons.GameIconReducer
local ApiFetchBigGameIcons = GameIconRodux.BigGameIcons.ApiFetchBigGameIcons
local ApiFetchGameIcons = GameIconRodux.GameIcons.ApiFetchGameIcons
local DataHydration = require(CorePackages.Workspace.Packages.DataHydration)
local DataStatus = require(CorePackages.Workspace.Packages.DataHydration).DataStatus
local ApiFetchGameMedia = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Thunks.Games.ApiFetchGameMedia
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local ApiFetchGameIsFavorite = require(Modules.LuaApp.Thunks.Games.ApiFetchGameIsFavorite)
local ApiFetchGameFollowingStatus = require(Modules.LuaApp.Thunks.ApiFetchGameFollowingStatus)
local ApiFetchGameSocialLinks = require(Modules.LuaApp.Thunks.Games.ApiFetchGameSocialLinks)
local ApiFetchGamePasses = require(Modules.LuaApp.Thunks.Games.ApiFetchGamePasses)
local ApiFetchGameDeveloperProducts = require(Modules.LuaApp.Thunks.DeveloperProduct.ApiFetchGameDeveloperProducts)
local ApiFetchGameSubscriptionProducts = require(Modules.LuaApp.Thunks.Subscription.ApiFetchGameSubscriptionProducts)
local ApiFetchGameBadges = require(Modules.LuaApp.Thunks.ApiFetchGameBadges)
local RecommendedGames = require(Modules.LuaApp.Thunks.Games.RecommendedGames)
local ApiFetchAssetTextFilterSettings = require(Modules.LuaApp.Thunks.ApiFetchAssetTextFilterSettings)
local ApiFetchPrivateServersEnabled = require(Modules.LuaApp.Thunks.Games.ApiFetchPrivateServersEnabled)
local ApiFetchExperienceDetailsPage = require(Modules.LuaApp.Thunks.Games.ApiFetchExperienceDetailsPage)
local ApiFetchExperienceDetailsPageCounters = require(Modules.LuaApp.Thunks.ApiFetchExperienceDetailsPageCounters)
local LoggingProtocol = require(CorePackages.Workspace.Packages.LoggingProtocol)
local EdpSduiUtils = require(script.Parent.Parent.Parent.Components.ExperienceDetails.EdpSduiUtils)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local num = tonumber(settings():GetFVariable("LuaAppGameDetailsRefreshIntervalInSeconds"))
local GetFFlagLuaAppLaunchConnectorFix = require(Modules.LuaApp.Flags.GetFFlagLuaAppLaunchConnectorFix)
local GetFFlagEnableBigGameIconInDetailsPage = require(Modules.LuaApp.Flags.GetFFlagEnableBigGameIconInDetailsPage)
local FFlagLuaAppEdpBackendV2HydrateLegacyDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyDefault
local FFlagLuaAppEdpBackendV2HydrateLegacyIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2HydrateLegacyIxp
local FFlagLuaAppEdpBackendV2SduiInterleaveDefault = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveDefault
local FFlagLuaAppEdpBackendV2SduiInterleaveIxp = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2SduiInterleaveIxp
local FFlagLuaAppEdpFetchLatencyTracking = SharedFlags.FFlagLuaAppEdpFetchLatencyTracking
local v49 = game:DefineFastInt("EdpFetchLatencyTrackingThrottlingHundredthsPercent", 1000)
local FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure
local FFlagLuaAppEdpBackendV2LogUniverseIdForEvents = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppEdpBackendV2LogUniverseIdForEvents
local FFlagLuaAppGamePassesDataHydrationMigrationEnabled = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppGamePassesDataHydrationMigrationEnabled
local t1 = nil
local t2 = nil

if FFlagLuaAppEdpFetchLatencyTracking then
	t1 = {
		eventName = "experienceDetailsFetchLatency",
		description = "\"Latency measurement for EDP first class promise fetch batch\"",
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w",
		backends = {
			LoggingProtocol.TelemetryBackends.Points,
			LoggingProtocol.TelemetryBackends.EventIngest
		},
		throttlingPercentage = v49,
		lastUpdated = {
			25,
			8,
			20
		}
	}
	t2 = {
		eventName = "experienceDetailsFetchLatencyMissingStartTime",
		description = "\"Missing start time for EDP first class promise fetch batch\"",
		links = "https://roblox.atlassian.net/wiki/x/q4Ji4w",
		backends = {
			LoggingProtocol.TelemetryBackends.Points,
			LoggingProtocol.TelemetryBackends.EventIngest
		},
		throttlingPercentage = v49,
		lastUpdated = {
			25,
			8,
			20
		}
	}
end

local function logMissingDataMetrics(p1, p2) -- line: 100
	-- upvalues: ApiFetchExperienceDetailsPageCounters (copy)
	if p1.GameDetailsV2[p2] == nil then
		ApiFetchExperienceDetailsPageCounters.logFetchMissingData("gameDetails")
	end

	if p1.GameMedia[p2] == nil then
		ApiFetchExperienceDetailsPageCounters.logFetchMissingData("gameMedia")
	end

	if p1.AgeRecommendations[p2] == nil then
		ApiFetchExperienceDetailsPageCounters.logFetchMissingData("ageRecommendations")
	end

	if p1.GameVotes[p2] == nil then
		ApiFetchExperienceDetailsPageCounters.logFetchMissingData("gameVotes")
	end

	if p1.GameFavorites[p2] == nil then
		ApiFetchExperienceDetailsPageCounters.logFetchMissingData("gameFavorites")
	end

	if p1.GameFollowings[p2] == nil then
		ApiFetchExperienceDetailsPageCounters.logFetchMissingData("gameFollowings")
	end

	if p1.AssetTextFilterSettings[p2] == nil then
		ApiFetchExperienceDetailsPageCounters.logFetchMissingData("assetTextFilterSettings")
	end

	if p1.GamePrivateServersEnabled[p2] == nil then
		ApiFetchExperienceDetailsPageCounters.logFetchMissingData("gamePrivateServersEnabled")
	end
end
local function startFirstClassFetchPromises(p3, p4, p5, p6, p7, p8, p9, p10) -- line: 134
	-- upvalues: FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure (copy), ApiFetchExperienceDetailsPageCounters (copy), logMissingDataMetrics (copy), EdpSduiUtils (copy), num (copy), FFlagLuaAppEdpBackendV2LogUniverseIdForEvents (copy), ApiFetchExperienceDetailsPage (copy), ApiFetchVoiceChatOptInStatus (copy), ApiFetchGameDetails (copy), ApiFetchGameMedia (copy), ApiFetchAgeRecommendations (copy), GetFFlagEnableBigGameIconInDetailsPage (copy), GetFFlagLuaAppLaunchConnectorFix (copy), UiMode (copy), BigGameIconReducer (copy), ApiFetchBigGameIcons (copy), GameIconReducer (copy), ApiFetchGameIcons (copy)
	local t3 = {}

	if FFlagLuaAppEdpBackendV2HydrateLegacyDefault or (FFlagLuaAppEdpBackendV2HydrateLegacyIxp and p8 or FFlagLuaAppEdpBackendV2SduiInterleaveDefault) or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and p9 then
		if not FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure then
			ApiFetchExperienceDetailsPageCounters.logFetchRequest("initial")

			if p7 then
				ApiFetchExperienceDetailsPageCounters.logFetchRequest("forceRefresh")
			end
		end

		local v69 = nil

		if FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp and p8 then
			local v70 = p4:getState()

			v69 = v70.GameDetailsV2[p5] == nil or (v70.GameMedia[p5] == nil or (v70.AgeRecommendations[p5] == nil or (v70.GameVotes[p5] == nil or (v70.GameFavorites[p5] == nil or (v70.GameFollowings[p5] == nil or (v70.AssetTextFilterSettings[p5] == nil or v70.GamePrivateServersEnabled[p5] == nil))))))

			if v69 and not p7 then
				logMissingDataMetrics(v70, p5)
			end
		end

		local v71 = nil

		if FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and p9 then
			v71 = EdpSduiUtils.checkEdpDataStaleness(p10, num)

			if v71 then
				ApiFetchExperienceDetailsPageCounters.logFetchRequest("sduiStale")
			else
				ApiFetchExperienceDetailsPageCounters.logFetchRequest("sduiFresh")
			end
		end

		if p7 or (FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp and p8) and v69 or (FFlagLuaAppEdpBackendV2SduiInterleaveDefault or FFlagLuaAppEdpBackendV2SduiInterleaveIxp and p9) and v71 then
			if FFlagLuaAppEdpBackendV2LogFetchSuccessAndFailure then
				if p7 then
					ApiFetchExperienceDetailsPageCounters.logFetchRequest("forceRefresh", if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else p5)
				else
					ApiFetchExperienceDetailsPageCounters.logFetchRequest("initial", if not FFlagLuaAppEdpBackendV2LogUniverseIdForEvents then nil else p5)
				end
			end

			table.insert(t3, p4:dispatch(ApiFetchExperienceDetailsPage.Fetch(p3, p5, if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p8, if not FFlagLuaAppEdpBackendV2SduiInterleaveIxp then nil else p9)))
		end

		if FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp and p8 then
			if p7 or p4:getState().VoiceChatOptInStatus == nil then
				p4:dispatch(ApiFetchVoiceChatOptInStatus.Fetch(p3))
			end

			return t3
		end
	end

	if p7 or p4:getState().GameDetails[p5] == nil then
		table.insert(t3, p4:dispatch(ApiFetchGameDetails.Fetch(p3, { p5 })))
	end

	if p7 or p4:getState().VoiceChatOptInStatus == nil then
		p4:dispatch(ApiFetchVoiceChatOptInStatus.Fetch(p3))
	end

	if p7 or p4:getState().GameMedia[p5] == nil then
		table.insert(t3, p4:dispatch(ApiFetchGameMedia.Fetch(p3, p5)))
	end

	if p7 or p4:getState().AgeRecommendations[p5] == nil then
		table.insert(t3, p4:dispatch(ApiFetchAgeRecommendations.Fetch(p3, p5)))
	end

	if GetFFlagEnableBigGameIconInDetailsPage() and GetFFlagLuaAppLaunchConnectorFix() and (p6 and p6.uiMode == UiMode.TenFoot) and (p7 or p4:getState()[BigGameIconReducer.key][p5] == nil) then
		p4:dispatch(ApiFetchBigGameIcons(p3, { p5 }))
	end

	if p4:getState()[GameIconReducer.key][p5] == nil then
		p4:dispatch(ApiFetchGameIcons(p3, { p5 }))
	end

	return t3
end
local function startSecondClassFetchPromises(p11, p12, p13, p14, p15) -- line: 282
	-- upvalues: FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), ApiFetchPrivateServersEnabled (copy), ApiFetchGameSubscriptionProducts (copy), ApiFetchGameDeveloperProducts (copy), FetchGameVotes (copy), ApiFetchGameIsFavorite (copy), ApiFetchGameFollowingStatus (copy), ApiFetchGameSocialLinks (copy), RecommendedGames (copy), DiscoveryTypes (copy), FFlagLuaAppGamePassesDataHydrationMigrationEnabled (copy), DataHydration (copy), DataStatus (copy), ApiFetchGamePasses (copy), ApiFetchGameBadges (copy), ApiFetchAssetTextFilterSettings (copy), getAppFeaturePolicies (copy), ApiFetchExperienceCommunityLink (copy)
	if FFlagLuaAppEdpBackendV2HydrateLegacyDefault or FFlagLuaAppEdpBackendV2HydrateLegacyIxp and p15 then
		if p14 or p12:getState().GamePrivateServersEnabled[p13] == nil then
			p12:dispatch(ApiFetchPrivateServersEnabled(p11, p13))
		end

		if p14 or p12:getState().GameSubscriptionProducts[p13] == nil then
			p12:dispatch(ApiFetchGameSubscriptionProducts(p11, p13))
		end

		if p14 or p12:getState().GameDeveloperProducts[p13] == nil then
			local v77 = p12:getState()
			local v78 = v77.GameDetailsV2[p13]

			if v78 and v78.rootPlaceId and v77.LocalUserId then
				p12:dispatch(ApiFetchGameDeveloperProducts(p11, p13, v78.rootPlaceId, v77.LocalUserId))
			end
		end

		return
	end

	if p14 or p12:getState().GameVotes[p13] == nil then
		p12:dispatch(FetchGameVotes.Fetch(p11, p13))
	end

	if p14 or p12:getState().GameFavorites[p13] == nil then
		p12:dispatch(ApiFetchGameIsFavorite(p11, p13))
	end

	if p14 or p12:getState().GameFollowings[p13] == nil then
		p12:dispatch(ApiFetchGameFollowingStatus(p11, p13))
	end

	if p14 or p12:getState().GameSocialLinks[p13] == nil then
		p12:dispatch(ApiFetchGameSocialLinks(p11, p13))
	end

	if p14 or p12:getState().RecommendedGameEntries[p13] == nil then
		p12:dispatch(RecommendedGames.Fetch(p11, p13, {
			maxRows = DiscoveryTypes.Constants.MAX_RECOMMENDED_GAMES_FETCH_COUNT
		}))
	end

	if FFlagLuaAppGamePassesDataHydrationMigrationEnabled then
		local v79 = DataHydration.Game.getGamePassStore(false).getPassesForUniverse(p13).status(false)

		if p14 or v79 == DataStatus.NotReady or v79 == DataStatus.Failed then
			DataHydration.Game.getGamePassStore(false).fetchPassesForUniverse(p13)
		end
	elseif p14 or p12:getState().GamePasses[p13] == nil then
		p12:dispatch(ApiFetchGamePasses(p11, p13))
	end

	if p14 or p12:getState().GameSubscriptionProducts[p13] == nil then
		p12:dispatch(ApiFetchGameSubscriptionProducts(p11, p13))
	end

	if p14 or p12:getState().GameDeveloperProducts[p13] == nil then
		local v80 = p12:getState()
		local v81 = v80.GameDetails[p13]

		if v81 and v81.rootPlaceId and v80.LocalUserId then
			p12:dispatch(ApiFetchGameDeveloperProducts(p11, p13, v81.rootPlaceId, v80.LocalUserId))
		end
	end

	if p14 or p12:getState().GameBadges[p13] == nil then
		p12:dispatch(ApiFetchGameBadges(p11, p13))
	end

	if p14 or p12:getState().AssetTextFilterSettings[p13] == nil then
		p12:dispatch(ApiFetchAssetTextFilterSettings.Fetch(p11, p13))
	end

	if p14 or p12:getState().GamePrivateServersEnabled[p13] == nil then
		p12:dispatch(ApiFetchPrivateServersEnabled(p11, p13))
	end

	if getAppFeaturePolicies().getCommunityLinksEnabled() and (p14 or p12:getState().CommunityLinks.ExperienceCommunityLinks[p13] == nil) then
		p12:dispatch(ApiFetchExperienceCommunityLink(p11, p13))
	end
end

return function(p16, p17, p18, p19, p20, p21) -- line: 374
	-- upvalues: NextDataExpirationTimeReducer (copy), ExpirationTimeNamespace (copy), FetchGamePlayButtonData (copy), startFirstClassFetchPromises (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), RunService (copy), FFlagLuaAppEdpFetchLatencyTracking (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), PromiseUtilities (copy), num (copy), SetNextDataExpirationTime (copy), startSecondClassFetchPromises (copy), t1 (ref), LoggingProtocol (copy), t2 (ref)
	if type(p17) ~= "string" then
		error(string.format("FetchGameDetailsPageData thunk expects universeId to be a string. Got type: '%s', value: '%s'", type(p17), (tostring(p17))))
	end

	return function(p22) -- line: 392
		-- upvalues: NextDataExpirationTimeReducer (copy), ExpirationTimeNamespace (copy), p17 (copy), FetchGamePlayButtonData (copy), p16 (copy), startFirstClassFetchPromises (copy), p18 (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), p19 (copy), FFlagLuaAppEdpBackendV2SduiInterleaveIxp (copy), p20 (copy), FFlagLuaAppEdpBackendV2SduiInterleaveDefault (copy), p21 (copy), RunService (copy), FFlagLuaAppEdpFetchLatencyTracking (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), PromiseUtilities (copy), num (copy), SetNextDataExpirationTime (copy), startSecondClassFetchPromises (copy), t1 (ref), LoggingProtocol (copy), t2 (ref)
		local u89 = false
		local timestamp = tick()
		local u91 = nil
		local v92 = p22:getState().Personalization[NextDataExpirationTimeReducer.key][ExpirationTimeNamespace.GameDetailPage]

		if v92 then
			u91 = v92[p17]
		end

		if u91 == nil or u91 < timestamp then
			u89 = true
		end

		p22:dispatch(FetchGamePlayButtonData.Fetch(p16, p17))

		local v93 = startFirstClassFetchPromises(p16, p22, p17, p18, u89, if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p19, if not FFlagLuaAppEdpBackendV2SduiInterleaveIxp then nil else p20, if not FFlagLuaAppEdpBackendV2SduiInterleaveDefault and (not FFlagLuaAppEdpBackendV2SduiInterleaveIxp or not p20) then nil else p21)

		if #v93 > 0 then
			local _warn = nil

			if _G.__TESTEZ_RUNNING_TEST__ or RunService:IsStudio() then
				_warn = warn
			end

			local u95 = nil
			local timestamp2 = nil

			if FFlagLuaAppEdpFetchLatencyTracking then
				u95 = not FFlagLuaAppEdpBackendV2HydrateLegacyDefault and (not FFlagLuaAppEdpBackendV2HydrateLegacyIxp or not p19) and 1 or 2
				timestamp2 = tick()
			end

			return PromiseUtilities.Batch(v93, _warn):andThen(function(p23) -- line: 441
				-- upvalues: PromiseUtilities (copy), FFlagLuaAppEdpBackendV2HydrateLegacyDefault (copy), FFlagLuaAppEdpBackendV2HydrateLegacyIxp (copy), p19 (copy), p22 (copy), p17 (copy), timestamp (ref), u91 (ref), num (copy), SetNextDataExpirationTime (copy), ExpirationTimeNamespace (copy), startSecondClassFetchPromises (copy), p16 (copy), u89 (ref)
				PromiseUtilities.CountResults(p23)

				if ((if not FFlagLuaAppEdpBackendV2HydrateLegacyDefault and (not FFlagLuaAppEdpBackendV2HydrateLegacyIxp or not p19) then p22:getState().GameDetails[p17] else p22:getState().GameDetailsV2[p17])) ~= nil then
					timestamp = tick()
					u91 = math.floor(timestamp + num)
					p22:dispatch(SetNextDataExpirationTime(p17, u91, ExpirationTimeNamespace.GameDetailPage))
				end

				startSecondClassFetchPromises(p16, p22, p17, u89, if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p19)
			end):finally(function() -- line: 476
				-- upvalues: FFlagLuaAppEdpFetchLatencyTracking (copy), t1 (ref), timestamp2 (ref), LoggingProtocol (copy), u95 (ref), p17 (copy), t2 (ref)
				if FFlagLuaAppEdpFetchLatencyTracking and (t1 and timestamp2) then
					local v98 = (tick() - timestamp2) * 1000

					LoggingProtocol.default:logRobloxTelemetryEvent(t1, nil, {
						latencyMs = v98,
						backendVersion = u95,
						universeId = p17
					})

					return
				end

				if FFlagLuaAppEdpFetchLatencyTracking and t2 then
					LoggingProtocol.default:logRobloxTelemetryEvent(t2, nil, {
						universeId = p17
					})
				end
			end)
		end

		startSecondClassFetchPromises(p16, p22, p17, u89, if not FFlagLuaAppEdpBackendV2HydrateLegacyIxp then nil else p19)
	end
end
