local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local signals = require("@luauforge/bundled/dur").Signals
local gameSortLoadSource = require("@luauforge/bundled/dur").GameSortLoadSource
local module = require("@luauforge/bundled/dtt")
local topicInfoModel = module.TopicInfoModel
local addTopicInfos = module.AddTopicInfos
local appPage = require("@luauforge/bundled/dup").AppPage
local retrievalStatus = require("@luauforge/bundled/dus").Enum.RetrievalStatus
local makeOmniRecommendationsRequest = require("@luauforge/bundled/dut").MakeOmniRecommendationsRequest
local module2 = require("@luauforge/bundled/dtg")
local module3 = require("@luauforge/bundled/dtp")
local omniFeedTypes = module3.OmniFeedTypes
local omniFeedConstants = module3.OmniFeedConstants
local module4 = require("@luauforge/bundled/dtM")
local omniRecommendationsPageType = module4.OmniRecommendationsPageType
local discoveryClientAppStorage = module4.DiscoveryClientAppStorage
local homeOmniFeedCache = module4.HomeOmniFeedCache
local makeDiscoveryNetworkCallWithCacheFallback = module4.makeDiscoveryNetworkCallWithCacheFallback
local module5 = require("@luauforge/bundled/duu")
local fetchStatusReducer = module5.FetchStatusReducer
local fetchStatusNamespace = module5.FetchStatusNamespace
local setFetchStatus = module5.SetFetchStatus
local module6 = require("@luauforge/bundled/duv")
local addSduiRootConfig = module6.AddSduiRootConfig
local sduiErrors = module6.SduiErrors
local sduiLogger = module6.SduiLogger
local seedHomeOmniSduiV2Payload = module6.seedHomeOmniSduiV2Payload
local mutedError = require("@luauforge/bundled/duw").mutedError

local module7 = require("@luauforge/bundled/dux")
local module8 = require("@luauforge/bundled/dtQ")
local module9 = require("@luauforge/bundled/duA")
local module10 = require("@luauforge/bundled/duI")
local module11 = require("@luauforge/bundled/duJ")

local module12 = require("@luauforge/bundled/dtV")
local setPageSessionTimestamp = require("@luauforge/bundled/dtd").SetPageSessionTimestamp

local module13 = require("@luauforge/bundled/duK")

local fFlagEnableContextFeaturesForOmniRecommendations = require("@luauforge/bundled/dtD").FFlagEnableContextFeaturesForOmniRecommendations
local getFFlagHomePYMKUseProfileFrameThumbnail = require("@luauforge/bundled/dtD").GetFFlagHomePYMKUseProfileFrameThumbnail
local fFlagLuaAppHomeThumbnailPrefetch = require("@luauforge/bundled/dtD").FFlagLuaAppHomeThumbnailPrefetch

local v5 = if fFlagLuaAppHomeThumbnailPrefetch then require("@luauforge/bundled/duL") else nil

local fStringLuaEnabledSduiTreatmentTypes = require("@luauforge/bundled/dtD").FStringLuaEnabledSduiTreatmentTypes
local fFlagLuaAppAddHasOneByTwoField = require("@luauforge/bundled/dtD").FFlagLuaAppAddHasOneByTwoField
local homePageDataSourceType = signals.HomePageDataSourceType
local gameSortLoadSourceType = gameSortLoadSource.GameSortLoadSourceType

local function fn(p2, p3)
	return setFetchStatus(fetchStatusNamespace.OmniRecommendations, p2, p3)
end

local function getSupportedSduiTreatmentTypes()
	local robloxVersion = RunService:GetRobloxVersion()
	local v6 = tonumber(string.match(robloxVersion, ".(%d+)."))

	local v7 = string.split(fStringLuaEnabledSduiTreatmentTypes, ",")
	local supportedSduiTreatmentTypes = {}

	for i, v8 in ipairs(v7) do
		if v8 == "" then
			continue
		end

		local v9, v10 = string.match(v8, "(.*):(.*)")
		local v11 = tonumber(v10)

		if v9 and v11 and v11 <= v6 then
			table.insert(supportedSduiTreatmentTypes, v9)
		end
	end

	return supportedSduiTreatmentTypes
end

local function fn2(object)
	local state = object:getState()
	local currentSquad = state.Squad and state.Squad.Squad and state.Squad.Squad.currentSquad

	if currentSquad and currentSquad.members then
		return {
			party_size = #currentSquad.members
		}
	end

	return nil
end

local function fetchOmni(object, p2, p3, p4, p5, p6, p7, p8, p9, p10)
	if object:getState().Personalization[fetchStatusReducer.key][fetchStatusNamespace.OmniRecommendations][p4] == retrievalStatus.Fetching then
		return module2.resolve("Data is fetching")
	end

	object:dispatch(fn(p4, retrievalStatus.Fetching))

	local v6 = p6 or HttpService:GenerateGUID(false):lower()

	local nextPageToken = nil

	if p5 then
		local omniRecommendation = object:getState().OmniRecommendations[p4]

		if omniRecommendation then
			nextPageToken = omniRecommendation.nextPageToken
			v6 = omniRecommendation.omniSessionId
		end

		if module13() and (nextPageToken == nil or nextPageToken == "") then
			object:dispatch(fn(p4, retrievalStatus.Done))
			return module2.resolve("nextPageToken is empty")
		end
	end

	local omniFeedTypes2 = {}

	for k, omniFeedType in pairs(omniFeedTypes) do
		table.insert(omniFeedTypes2, omniFeedType)
	end

	if p10 == nil then
		local success, result = pcall(getSupportedSduiTreatmentTypes)

		if success then
			p10 = result
		else
			mutedError("Failed to get supported SDUI treatment types: ")
		end
	end

	local v7 = if fFlagEnableContextFeaturesForOmniRecommendations then fn2(object) else nil

	local v8 = getFFlagHomePYMKUseProfileFrameThumbnail() and p4 == appPage.Home

	local v9 = makeOmniRecommendationsRequest(
		p2,
		p4,
		v6,
		nextPageToken,
		omniFeedTypes2,
		p7,
		nil,
		p10,
		v7,
		v8
	)

	if p9 then
		v9 = makeDiscoveryNetworkCallWithCacheFallback(v9:catch(function(p11)
			module4.logResponseError("discovery-api/omni-recommendation", p11, p8)
			return module2.reject(p11)
		end), discoveryClientAppStorage.CacheKey.HomeOmniFeedCache, homeOmniFeedCache.HOME_OMNI_FEED_CACHE_VERSION)
	end

	return v9:andThen(function(p11)
		if not p11.isFromCache then
			module4.logResponseTelemetry("discovery-api/omni-recommendation", p11, p8)
		end

		local responseBody = p11.responseBody

		if responseBody == nil or responseBody.sorts == nil or #responseBody.sorts == 0 then
			object:dispatch(fn(p4, retrievalStatus.Failed))
			return module2.reject("No sort data found in response.")
		end

		if p4 ~= omniRecommendationsPageType.toAppPage(responseBody.pageType) then
			object:dispatch(fn(p4, retrievalStatus.Failed))
			return module2.reject("Wrong sort data found in response.")
		end

		if fFlagLuaAppAddHasOneByTwoField then
			local flag = false

			for k, sort in responseBody.sorts do
				local recommendationList = sort.recommendationList or sort.recommendations

				if recommendationList then
					for k2, recommendation in recommendationList do
						local contentMetadata = recommendation.contentMetadata

						if contentMetadata and contentMetadata.ComponentType == "OneByTwoTile" then
							flag = true
							break
						end
					end
				end

				if flag then
					break
				end
			end

			sduiLogger.reportOmniFeedStats(responseBody.sorts, responseBody.sdui, p4, nil, p8, flag)
		else
			sduiLogger.reportOmniFeedStats(responseBody.sorts, responseBody.sdui, p4)
		end

		if not p11.isFromCache then
			homeOmniFeedCache.cacheOmniRecommendationsData(responseBody)
		end

		local setHomePageDataSource = signals.getCacheStore().setHomePageDataSource
		local v10 = if p11.isFromCache then homePageDataSourceType.Cache else homePageDataSourceType.API
		setHomePageDataSource(v10)

		if p11.isFromCache then
			v6 = HttpService:GenerateGUID(false):lower()
		end

		local v11 = module9(p2, object, responseBody)

		if fFlagLuaAppHomeThumbnailPrefetch and p4 == appPage.Home and not p5 then
			v5(responseBody, v11[module3.OmniRecommendationsContentType.Game])
		end

		v11[module3.OmniRecommendationsContentType.Game] = nil

		module11.fromJsonData(responseBody, v6):match(function(state)
			local now = if not p5 then tick() else nil

			state.metadata = v11

			module10(state, p4, { seedSduiV2Payload = seedHomeOmniSduiV2Payload })

			object:dispatch(module8(state, p5))

			local feedItemEntries = {}

			local v12 = {}

			if state.sorts then
				for k, sort in state.sorts do
					local v13 = sort.treatmentType == omniFeedTypes.ServerDrivenUi
					local v14 = sort.treatmentType == omniFeedTypes.ServerDrivenUiV2
					local v15 = not (sort.feedItemKey == nil) and sort.feedItemKey ~= ""

					if v13 and v15 then
						table.insert(feedItemEntries, {
							feedItemKey = sort.feedItemKey,
							topicId = sort.topicId,
							sortIndex = k
						})
					elseif not (v14 and v15) then
						if v13 or v14 then
							sduiLogger.reportError(sduiErrors.SduiErrorType.NilFeedItemKeyForSduiSort, {
								name = `{sort.topicId}`,
								message = `SDUI v{v14 and 2 or 1} treatmentType {sort.treatmentType} but no feedItemKey for topicId {sort.topicId} at index {k}`
							}, p4)
						elseif v15 then
							sduiLogger.reportError(
								sduiErrors.SduiErrorType.InvalidTreatmentTypeWithFeedItemKey,
								{
									name = `{sort.topicId}`,
									message = `Has sdui feedItemKey {sort.feedItemKey} but treatmentType {sort.treatmentType} for topicId {sort.topicId} at index {k}`
								},
								p4
							)
						end
					end

					local v16 = topicInfoModel.fromOmniApi(sort)
					v12[#v12 + 1] = v16

					local setSortLoadSource = gameSortLoadSource.setSortLoadSource
					local topicId = sort.topicId
					local v17 = if p11.isFromCache then gameSortLoadSourceType.ClientFallbackCache else gameSortLoadSourceType.API
					setSortLoadSource(topicId, v17)
				end
			end

			object:dispatch(addTopicInfos(v12))

			object:dispatch(module7(p4, nil, now))

			object:dispatch(module12(p4, state.sortsExpirationTime))
			object:dispatch(fn(p4, retrievalStatus.Done))

			if p4 == appPage.Home and not p5 then
				object:dispatch(setPageSessionTimestamp(appPage.Home))
			end

			if state.sdui then
				local success, result = pcall(function()
					object:dispatch(addSduiRootConfig(p4, state.sdui, tick(), feedItemEntries))
				end)

				if not success then
					local v13 = ""

					if #feedItemEntries > 0 then
						for k, v14 in feedItemEntries do
							v13 = `{v13} {v14.topicId}`
						end
					end

					sduiLogger.reportError(
						sduiErrors.SduiErrorType.ErrorStoringOmniData,
						{
							name = "discovery-api/omni-recommendation",
							message = `Error storing omni response: {result} topicIds: {v13}`
						},
						p4
					)
				end
			elseif #feedItemEntries > 0 then
				local v13 = ""

				for k, v14 in feedItemEntries do
					v13 = `{v13} {v14.topicId}`
				end

				sduiLogger.reportError(
					sduiErrors.SduiErrorType.NilSduiTreeInResponse,
					{
						name = "discovery-api/omni-recommendation",
						message = `Has sdui sorts, but no sdui tree in response. topicIds: {v13}`
					},
					p4
				)
			end
		end):matchError(function(p12)
			object:dispatch(fn(p4, retrievalStatus.Failed))
			warn(p12)
		end)
		return module2.resolve()
	end, function(p11)
		if not p9 then
			module4.logResponseError("discovery-api/omni-recommendation", p11, p8)
		end

		object:dispatch(fn(p4, retrievalStatus.Failed))
		return module2.reject(p11)
	end)
end

return function(p2, p3, p4, p5, p6, p7, p8, p9)
	return function(p10)
		return fetchOmni(p10, p2, p3, p4, p5, p6, p7, p8, p9)
	end
end
