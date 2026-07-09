local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local Signals = require(DiscoveryMonolithParent.DiscoveryAvailability).Signals
local GameSortLoadSource = require(DiscoveryMonolithParent.DiscoveryAvailability).GameSortLoadSource
local TopicInfosRodux = require(DiscoveryMonolithParent.TopicInfosRodux)
local TopicInfoModel = TopicInfosRodux.TopicInfoModel
local AddTopicInfos = TopicInfosRodux.AddTopicInfos
local AppPage = require(DiscoveryMonolithParent.RobloxAppEnums).AppPage
local RetrievalStatus = require(DiscoveryMonolithParent.Http).Enum.RetrievalStatus
local MakeOmniRecommendationsRequest = require(DiscoveryMonolithParent.GraphQlShared).MakeOmniRecommendationsRequest
local Promise = require(DiscoveryMonolithParent.Promise)
local DiscoveryTypes = require(DiscoveryMonolithParent.DiscoveryTypes)
local OmniFeedTypes = DiscoveryTypes.OmniFeedTypes
local _ = DiscoveryTypes.OmniFeedConstants
local DiscoveryUtils = require(DiscoveryMonolithParent.DiscoveryUtils)
local OmniRecommendationsPageType = DiscoveryUtils.OmniRecommendationsPageType
local DiscoveryClientAppStorage = DiscoveryUtils.DiscoveryClientAppStorage
local HomeOmniFeedCache = DiscoveryUtils.HomeOmniFeedCache
local makeDiscoveryNetworkCallWithCacheFallback = DiscoveryUtils.makeDiscoveryNetworkCallWithCacheFallback
local FetchStatusRodux = require(DiscoveryMonolithParent.FetchStatusRodux)
local FetchStatusReducer = FetchStatusRodux.FetchStatusReducer
local FetchStatusNamespace = FetchStatusRodux.FetchStatusNamespace
local SetFetchStatus = FetchStatusRodux.SetFetchStatus
local ServerDrivenUi = require(DiscoveryMonolithParent.ServerDrivenUi)
local AddSduiRootConfig = ServerDrivenUi.AddSduiRootConfig
local SduiErrors = ServerDrivenUi.SduiErrors
local SduiLogger = ServerDrivenUi.SduiLogger
local seedHomeOmniSduiV2Payload = ServerDrivenUi.seedHomeOmniSduiV2Payload
local mutedError = require(DiscoveryMonolithParent.Loggers).mutedError
local Modules = DiscoveryMonolith.Modules
local GenerateTopicContents = require(Modules.Personalization.Games.DataStore.GenerateTopicContents)
local AddOmniRecommendations = require(Modules.LuaApp.Actions.Games.AddOmniRecommendations)
local parseAndAddContentMetadata = require(Modules.LuaApp.Thunks.Omni.parseAndAddContentMetadata)
local processOmniSduiV2Response = require(Modules.LuaApp.Thunks.Omni.processOmniSduiV2Response)
local OmniRecommendations = require(Modules.LuaApp.Models.DiscoveryApi.OmniRecommendations)
local SetOmniRecommendationsRefreshTime = require(Modules.LuaApp.Actions.Games.SetOmniRecommendationsRefreshTime)
local SetPageSessionTimestamp = require(Modules.Personalization.Sessions.DataStore.SetPageSessionTimestamp)
local GetFFlagFixFetchNextOmniWithoutPageToken = require(Modules.LuaApp.Flags.GetFFlagFixFetchNextOmniWithoutPageToken)
local FFlagEnableContextFeaturesForOmniRecommendations = require(DiscoveryMonolithParent.SharedFlags).FFlagEnableContextFeaturesForOmniRecommendations
local FFlagEnableSduiV2HomeInterleave = require(DiscoveryMonolithParent.SharedFlags).FFlagEnableSduiV2HomeInterleave
local FStringLuaEnabledSduiTreatmentTypes = require(DiscoveryMonolithParent.SharedFlags).FStringLuaEnabledSduiTreatmentTypes
local HomePageDataSourceType = Signals.HomePageDataSourceType
local GameSortLoadSourceType = GameSortLoadSource.GameSortLoadSourceType

local function v46(p1, p2) -- line: 52
	-- upvalues: SetFetchStatus (copy), FetchStatusNamespace (copy)
	return SetFetchStatus(FetchStatusNamespace.OmniRecommendations, p1, p2)
end
local function getSupportedSduiTreatmentTypes() -- line: 56
	-- upvalues: RunService (copy), FStringLuaEnabledSduiTreatmentTypes (copy)
	local RobloxVersion = RunService:GetRobloxVersion()
	local num = tonumber(string.match(RobloxVersion, ".(%d+)."))
	local t1 = {}
	local parts = string.split(FStringLuaEnabledSduiTreatmentTypes, ",")

	for _, v in ipairs(parts) do
		if v ~= "" then
			local v58, v59 = string.match(v, "(.*):(.*)")
			local num2 = tonumber(v59)

			if v58 and num2 and num2 <= num then
				table.insert(t1, v58)
			end
		end
	end

	return t1
end
local function v48(p3) -- line: 74
	local v62 = p3:getState()
	local v63 = v62.Squad and (v62.Squad.Squad and v62.Squad.Squad.currentSquad)

	if v63 and v63.members then
		return {
			party_size = #v63.members
		}
	end

	return nil
end
local function fetchOmni(p4, p5, _, s1: string, b1: boolean?, s2: string?, s3: string, p7, b2: boolean?, t2: {[any]: any}?) -- line: 85
	-- upvalues: FetchStatusReducer (copy), FetchStatusNamespace (copy), RetrievalStatus (copy), Promise (copy), v46 (copy), HttpService (copy), GetFFlagFixFetchNextOmniWithoutPageToken (copy), OmniFeedTypes (copy), getSupportedSduiTreatmentTypes (copy), mutedError (copy), FFlagEnableContextFeaturesForOmniRecommendations (copy), v48 (copy), MakeOmniRecommendationsRequest (copy), makeDiscoveryNetworkCallWithCacheFallback (copy), DiscoveryUtils (copy), DiscoveryClientAppStorage (copy), HomeOmniFeedCache (copy), OmniRecommendationsPageType (copy), SduiLogger (copy), Signals (copy), HomePageDataSourceType (copy), parseAndAddContentMetadata (copy), DiscoveryTypes (copy), OmniRecommendations (copy), FFlagEnableSduiV2HomeInterleave (copy), processOmniSduiV2Response (copy), seedHomeOmniSduiV2Payload (copy), AddOmniRecommendations (copy), SduiErrors (copy), TopicInfoModel (copy), GameSortLoadSource (copy), GameSortLoadSourceType (copy), AddTopicInfos (copy), GenerateTopicContents (copy), SetOmniRecommendationsRefreshTime (copy), AppPage (copy), SetPageSessionTimestamp (copy), AddSduiRootConfig (copy)
	if p4:getState().Personalization[FetchStatusReducer.key][FetchStatusNamespace.OmniRecommendations][s1] == RetrievalStatus.Fetching then
		return Promise.resolve("Data is fetching")
	end

	p4:dispatch(v46(s1, RetrievalStatus.Fetching))

	local u74 = s2 or HttpService:GenerateGUID(false):lower()
	local nextPageToken = nil

	if b1 then
		local v76 = p4:getState().OmniRecommendations[s1]

		if v76 then
			nextPageToken = v76.nextPageToken
			u74 = v76.omniSessionId
		end

		if GetFFlagFixFetchNextOmniWithoutPageToken() and (nextPageToken == nil or nextPageToken == "") then
			p4:dispatch(v46(s1, RetrievalStatus.Done))

			return Promise.resolve("nextPageToken is empty")
		end
	end

	local t3 = {}

	for _, v in pairs(OmniFeedTypes) do
		table.insert(t3, v)
	end

	if t2 == nil then
		local ok, result = pcall(getSupportedSduiTreatmentTypes)

		if ok then
			t2 = result
		else
			mutedError("Failed to get supported SDUI treatment types: ")
		end
	end

	local v82 = nil

	if FFlagEnableContextFeaturesForOmniRecommendations then
		v82 = v48(p4)
	end

	local v83 = MakeOmniRecommendationsRequest(p5, s1, u74, nextPageToken, t3, s3, nil, t2, v82)

	return ((if not b2 then v83 else makeDiscoveryNetworkCallWithCacheFallback(v83:catch(function(p8) -- line: 164
		-- upvalues: DiscoveryUtils (copy), p7 (copy), Promise (copy)
		DiscoveryUtils.logResponseError("discovery-api/omni-recommendation", p8, p7)

		return Promise.reject(p8)
	end), DiscoveryClientAppStorage.CacheKey.HomeOmniFeedCache, HomeOmniFeedCache.HOME_OMNI_FEED_CACHE_VERSION))):andThen(function(p9) -- line: 176
		-- upvalues: DiscoveryUtils (copy), p7 (copy), p4 (copy), v46 (copy), s1 (copy), RetrievalStatus (copy), Promise (copy), OmniRecommendationsPageType (copy), SduiLogger (copy), HomeOmniFeedCache (copy), Signals (copy), HomePageDataSourceType (copy), u74 (ref), HttpService (copy), parseAndAddContentMetadata (copy), p5 (copy), DiscoveryTypes (copy), OmniRecommendations (copy), b1 (copy), FFlagEnableSduiV2HomeInterleave (copy), processOmniSduiV2Response (copy), seedHomeOmniSduiV2Payload (copy), AddOmniRecommendations (copy), OmniFeedTypes (copy), SduiErrors (copy), TopicInfoModel (copy), GameSortLoadSource (copy), GameSortLoadSourceType (copy), AddTopicInfos (copy), GenerateTopicContents (copy), SetOmniRecommendationsRefreshTime (copy), AppPage (copy), SetPageSessionTimestamp (copy), AddSduiRootConfig (copy)
		if not p9.isFromCache then
			DiscoveryUtils.logResponseTelemetry("discovery-api/omni-recommendation", p9, p7)
		end

		local responseBody = p9.responseBody

		if responseBody == nil or responseBody.sorts == nil or #responseBody.sorts == 0 then
			p4:dispatch(v46(s1, RetrievalStatus.Failed))

			return Promise.reject("No sort data found in response.")
		end

		if OmniRecommendationsPageType.toAppPage(responseBody.pageType) ~= s1 then
			p4:dispatch(v46(s1, RetrievalStatus.Failed))

			return Promise.reject("Wrong sort data found in response.")
		end

		SduiLogger.reportOmniFeedStats(responseBody.sorts, responseBody.sdui, s1)

		if not p9.isFromCache then
			HomeOmniFeedCache.cacheOmniRecommendationsData(responseBody)
		end

		Signals.getCacheStore().setHomePageDataSource(if not p9.isFromCache then HomePageDataSourceType.API else HomePageDataSourceType.Cache)

		if p9.isFromCache then
			u74 = HttpService:GenerateGUID(false):lower()
		end

		local v95 = parseAndAddContentMetadata(p5, p4, responseBody)

		v95[DiscoveryTypes.OmniRecommendationsContentType.Game] = nil
		OmniRecommendations.fromJsonData(responseBody, u74):match(function(p10) -- line: 219
			-- upvalues: b1 (copy), v95 (copy), FFlagEnableSduiV2HomeInterleave (copy), processOmniSduiV2Response (copy), s1 (copy), seedHomeOmniSduiV2Payload (copy), p4 (copy), AddOmniRecommendations (copy), OmniFeedTypes (copy), SduiLogger (copy), SduiErrors (copy), TopicInfoModel (copy), GameSortLoadSource (copy), p9 (copy), GameSortLoadSourceType (copy), AddTopicInfos (copy), GenerateTopicContents (copy), SetOmniRecommendationsRefreshTime (copy), v46 (copy), RetrievalStatus (copy), AppPage (copy), SetPageSessionTimestamp (copy), AddSduiRootConfig (copy)
			local timestamp = nil

			if not b1 then
				timestamp = tick()
			end

			p10.metadata = v95

			if FFlagEnableSduiV2HomeInterleave then
				processOmniSduiV2Response(p10, s1, {
					seedSduiV2Payload = seedHomeOmniSduiV2Payload
				})
			end

			p4:dispatch(AddOmniRecommendations(p10, b1))

			local t4 = {}
			local t5 = {}

			if p10.sorts then
				for v102, v103 in p10.sorts do
					local v104 = v103.treatmentType == OmniFeedTypes.ServerDrivenUi
					local v105 = FFlagEnableSduiV2HomeInterleave and v103.treatmentType == OmniFeedTypes.ServerDrivenUiV2
					local v106 = v103.feedItemKey ~= nil and v103.feedItemKey ~= ""

					if v104 and v106 then
						table.insert(t4, {
							feedItemKey = v103.feedItemKey,
							topicId = v103.topicId,
							sortIndex = v102
						})
					elseif not FFlagEnableSduiV2HomeInterleave or not v105 or not v106 then
						if v104 or FFlagEnableSduiV2HomeInterleave and v105 then
							SduiLogger.reportError(SduiErrors.SduiErrorType.NilFeedItemKeyForSduiSort, {
								name = `{ v103.topicId }`,
								message = if not FFlagEnableSduiV2HomeInterleave then `Sdui treatmentType but no feedItemKey for topicId { v103.topicId } at index { v102 }` else `SDUI v{ not v105 and 1 or 2 } treatmentType { v103.treatmentType } but no feedItemKey for topicId { v103.topicId } at index { v102 }`
							}, s1)
						elseif v106 then
							SduiLogger.reportError(SduiErrors.SduiErrorType.InvalidTreatmentTypeWithFeedItemKey, {
								name = `{ v103.topicId }`,
								message = `Has sdui feedItemKey { v103.feedItemKey } but treatmentType { v103.treatmentType } for topicId { v103.topicId } at index { v102 }`
							}, s1)
						end
					end

					local v107 = TopicInfoModel.fromOmniApi(v103)

					t5[#t5 + 1] = v107
					GameSortLoadSource.setSortLoadSource(v103.topicId, if not p9.isFromCache then GameSortLoadSourceType.API else GameSortLoadSourceType.ClientFallbackCache)
				end
			end

			p4:dispatch(AddTopicInfos(t5))
			p4:dispatch(GenerateTopicContents(s1, nil, timestamp))
			p4:dispatch(SetOmniRecommendationsRefreshTime(s1, p10.sortsExpirationTime))
			p4:dispatch(v46(s1, RetrievalStatus.Done))

			if s1 == AppPage.Home and not b1 then
				p4:dispatch(SetPageSessionTimestamp(AppPage.Home))
			end

			if p10.sdui then
				local ok, result = pcall(function() -- line: 304
					-- upvalues: p4 (copy), AddSduiRootConfig (copy), s1 (copy), p10 (copy), t4 (copy)
					p4:dispatch(AddSduiRootConfig(s1, p10.sdui, tick(), t4))
				end)

				if not ok then
					local s4 = ""

					if #t4 > 0 then
						for _, v112 in t4 do
							s4 = `{ s4 } { v112.topicId }`
						end
					end

					SduiLogger.reportError(SduiErrors.SduiErrorType.ErrorStoringOmniData, {
						name = "discovery-api/omni-recommendation",
						message = `Error storing omni response: { result } topicIds: { s4 }`
					}, s1)

					return
				end
			elseif #t4 > 0 then
				local s5 = ""

				for _, v115 in t4 do
					s5 = `{ s5 } { v115.topicId }`
				end

				SduiLogger.reportError(SduiErrors.SduiErrorType.NilSduiTreeInResponse, {
					name = "discovery-api/omni-recommendation",
					message = `Has sdui sorts, but no sdui tree in response. topicIds: { s5 }`
				}, s1)
			end
		end):matchError(function(p11) -- line: 330
			-- upvalues: p4 (copy), v46 (copy), s1 (copy), RetrievalStatus (copy)
			p4:dispatch(v46(s1, RetrievalStatus.Failed))
			warn(p11)
		end)

		return Promise.resolve()
	end, function(p12) -- line: 335
		-- upvalues: b2 (copy), DiscoveryUtils (copy), p7 (copy), p4 (copy), v46 (copy), s1 (copy), RetrievalStatus (copy), Promise (copy)
		if not b2 then
			DiscoveryUtils.logResponseError("discovery-api/omni-recommendation", p12, p7)
		end

		p4:dispatch(v46(s1, RetrievalStatus.Failed))

		return Promise.reject(p12)
	end)
end

return function(p13, p14, s6: string, b3: boolean?, s7: string?, s8: string, p15, b4: boolean?) -- line: 345
	-- upvalues: fetchOmni (copy)
	return function(p16) -- line: 355
		-- upvalues: fetchOmni (copy), p13 (copy), p14 (copy), s6 (copy), b3 (copy), s7 (copy), s8 (copy), p15 (copy), b4 (copy)
		return fetchOmni(p16, p13, p14, s6, b3, s7, s8, p15, b4)
	end
end
