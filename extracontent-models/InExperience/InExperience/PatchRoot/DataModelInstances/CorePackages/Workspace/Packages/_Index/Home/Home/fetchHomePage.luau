local Home = script:FindFirstAncestor("Home")
local parent = Home.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local DiscoveryAvailability = require(parent.DiscoveryAvailability)
local Http = require(parent.Http)
local RetrievalStatus = Http.Enum.RetrievalStatus
local Promise = require(parent.Promise)
local PageSessionRodux = require(parent.PageSessionRodux)
local SetPageSessionTimestamp = PageSessionRodux.SetPageSessionTimestamp
local SduiCoreSystem = require(parent.SduiCoreSystem)
local getSduiServiceDependenciesStore = SduiCoreSystem.getSduiServiceDependenciesStore
local SduiPoolStore = SduiCoreSystem.SduiPoolStore
local SduiLogger = SduiCoreSystem.SduiLogger
local SduiErrors = SduiCoreSystem.SduiErrors
local SduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local SponsoredTilesTelemetry = require(parent.SponsoredTilesTelemetry)
local OneByTwoTileTelemetry = SponsoredTilesTelemetry.OneByTwoTileTelemetry
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSduiTemplateStore = SduiSharedUtilities.getSduiTemplateStore
local SduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
local SduiCapabilities = SduiSharedUtilities.SduiCapabilities
local StartupStore = require(parent.StartupStore)
local GetStartupStore = StartupStore.GetStartupStore

local HomeConstants = require(Home.HomeConstants)
local HomePageFocusedFetchUtils = require(Home.HomePageFocusedFetchUtils)
local HomePageSession = require(Home.HomePageSession)
local DiscoveryUtils = require(parent.DiscoveryUtils)
local HomeOmniFeedCache = DiscoveryUtils.HomeOmniFeedCache
local SduiHomePageCachePayload = require(Home.SduiHomePageCachePayload)
local getHomePageUrl = require(Home.getHomePageUrl)
local buildHomePageRequest = require(Home.buildHomePageRequest)
local buildHomeFeedStats = require(Home.buildHomeFeedStats)
local measureHomeCollectionLayout = require(Home.measureHomeCollectionLayout)
local writeHomePageSduiPrefetchDescriptor = require(Home.writeHomePageSduiPrefetchDescriptor)
local writeHomePageSduiPrefetchClientCapabilities = require(Home.writeHomePageSduiPrefetchClientCapabilities)
local PrefetchProtocol = require(parent.PrefetchProtocol)
local prefetchProtocol = PrefetchProtocol.PrefetchProtocol
local RecommendationsStore = require(parent.RecommendationsStore)
local FriendRecommendations = RecommendationsStore.FriendRecommendations

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableHomePageSduiPrefetch = SharedFlags.FFlagEnableHomePageSduiPrefetch
local FFlagUseSignalsForStartup = SharedFlags.FFlagUseSignalsForStartup
local FFlagHomeSduiOfflineCache = SharedFlags.FFlagHomeSduiOfflineCache
local FFlagSduiAdvertiseRuntimeSupportSets = SharedFlags.FFlagSduiAdvertiseRuntimeSupportSets

local FFlagHomePageSduiPrefetchExtendedClientCapabilities = SharedFlags.FFlagHomePageSduiPrefetchExtendedClientCapabilities
local FFlagLuaAppSduiHomePageSupport = SharedFlags.FFlagLuaAppSduiHomePageSupport
local FFlagLuaAppSduiHomeFeedStats = SharedFlags.FFlagLuaAppSduiHomeFeedStats
local FFlagLuaAppAddHasOneByTwoFieldSdui = SharedFlags.FFlagLuaAppAddHasOneByTwoFieldSdui
local FFlagSduiPerSectionPoolSizing = SharedFlags.FFlagSduiPerSectionPoolSizing
local FFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui = SharedFlags.FFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui
local FFlagLuaAppHomeMomentVideoFallback = SharedFlags.FFlagLuaAppHomeMomentVideoFallback

local function resolveRequestIntent(requestIntent: string?, forceRefresh: boolean?) -- 1 equivalent call inferred from this helper
	if typeof(requestIntent) == "string" and requestIntent ~= "" then
		return requestIntent
	end

	if forceRefresh then
		return HomeConstants.RequestIntent.ManualRefresh
	end

	return HomeConstants.RequestIntent.LogIn
end

local function createHomePageRequestConfig(data, data2)
	local homeApi = data.homeApi
	return {
		responseType = SduiResponseType.Protobuf,
		url = getHomePageUrl(),
		surfaceKey = AppPage.Home,
		configKey = data2.configKey,
		loadTimer = data.pageTimer,
		apiProto = homeApi.HomePageResponse,
		postConfig = {
			contentType = SduiApiStorePostConfigContentType.Proto,
			protoMessage = homeApi.HomePageRequest,
			body = buildHomePageRequest(homeApi, {
				sessionId = data2.sessionId,
				topicIds = data2.topicIds,
				requestIntent = data.requestIntent,
				contextualFeatures = data.contextualFeatures,
				cachedRobloxComponentToTemplateId = getSduiTemplateStore().getCachedRobloxComponentToTemplateId(AppPage.Home),
				clientCapabilities = data.clientCapabilities,
				collectionLayout = data.collectionLayout
			})
		},
		enableTemplateCache = true,
		enableStreaming = false,
		allowNoConfigsBuilt = true
	}
end

local function readRequestId(p) -- 2 equivalent calls inferred from this helper
	local request_id

	if type(p) == "table" then
		request_id = p.request_id
	end

	if request_id == nil or request_id == "" then
		return nil
	end

	return request_id
end

local function hasOneByTwoInResponse(p): boolean
	if type(p) ~= "table" then
		return false
	end

	for _, v in p.page_entries or {} do
		local input_data = v.input_data
		local value

		if input_data and input_data.kind then
			value = input_data.kind.value
		end

		local content_pools

		if value then
			content_pools = value.content_pools
		end

		if not content_pools then
			continue
		end

		for _, content_pool in content_pools do
			for _, v2 in content_pool.items or {} do
				local layout = v2.layout
				local col_span = layout and (layout.col_span or 1) or nil

				if layout and layout.row_span == 2 and col_span == 1 then
					return true
				end
			end
		end
	end

	return false
end

local function readFriendRecommendations(p)
	local hydration_data

	if type(p) == "table" then
		hydration_data = p.hydration_data
	end

	local friend_recommendation

	if type(hydration_data) == "table" then
		friend_recommendation = hydration_data.friend_recommendation
	end

	if type(friend_recommendation) == "table" then
		return (FriendRecommendations.mapFromProto(friend_recommendation))
	end

	return {}
end

local v = nil

local function registerOneByTwoTileFunnelListener() -- 1 equivalent call inferred from this helper
	v = SduiPoolStore.getSduiPoolStore(HomeConstants.ConfigKey)
	v.setOneByTwoTileFunnelListener({
		onPlaced = OneByTwoTileTelemetry.logOneByTwoTilePlaced,
		onSkipped = OneByTwoTileTelemetry.logOneByTwoTileSkipped
	})
end

local function logOneByTwoTileResponseReceivedFromDecodedResponse(p)
	if type(p) ~= "table" then
		return
	end

	for _, v2 in p.page_entries or {} do
		local value = v2.input_data and v2.input_data.kind and v2.input_data.kind.value
		local content_pools = value and value.content_pools

		if not content_pools then
			continue
		end

		for _, v3 in SduiCoreSystem.getOneByTwoTileFlowIdsFromPools(content_pools) do
			OneByTwoTileTelemetry.logOneByTwoTileResponseReceived({
				oneByTwoTileFlowId = v3.oneByTwoTileFlowId,
				contentType = v3.contentType,
				adId = v3.adId,
				alignmentType = v3.alignmentType,
				componentType = "OneByTwoTile",
				isSdui = true
			})
		end
	end
end

local function commitHomeSession(_, p)
	if not HomePageSession:Commit(readRequestId(p)) then -- inferred equivalent call
		return
	end

	local dependencies = getSduiServiceDependenciesStore().getDependencies(AppPage.Home)
	assert(dependencies, "dependencies is nil")
	dependencies.dispatch(SetPageSessionTimestamp(AppPage.Home))
end

local function setHomePageDataSource(p: string) -- 2 equivalent calls inferred from this helper
	DiscoveryAvailability.Signals.getCacheStore().setHomePageDataSource(p)
end

local function isServingCachedHomePage(): boolean -- 1 equivalent call inferred from this helper
	return DiscoveryAvailability.Signals.getCacheStore().getHomePageDataSource(false) == "Cache"
end

local function setHomePageDataStatuses(status: string)
	if FFlagUseSignalsForStartup then
		GetStartupStore(false).setHomePageDataStatus(status)
		GetStartupStore(false).setFetchHomePageDataStatusAll(status)
	else
		local dependencies = getSduiServiceDependenciesStore().getDependencies(AppPage.Home)

		if dependencies == nil then
			return
		end

		dependencies.dispatch({ type = "SetHomePageDataStatus", status = status })
		dependencies.dispatch({ type = "SetFetchHomePageDataStatusAll", status = status })
	end
end

local function fetchHomePage(pageTimer, data)
	if FFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui then
		registerOneByTwoTileFunnelListener() -- inferred equivalent call
	end

	local configKey = HomeConstants.ConfigKey
	local sduiApiStore = getSduiApiStore()
	local forceRefresh

	if data then
		forceRefresh = data.forceRefresh
	end

	local contextualFeatures

	if data then
		contextualFeatures = data.contextualFeatures
	else
		contextualFeatures = nil
	end

	local requestIntent

	if data then
		requestIntent = data.requestIntent
	end

	requestIntent = resolveRequestIntent(requestIntent, forceRefresh) -- inferred equivalent call
	local focusedRefresh

	if data then
		focusedRefresh = data.focusedRefresh
	end

	local _, v2 = sduiApiStore.getData(configKey)

	if (forceRefresh or v2) and not (sduiApiStore.isInFlight(configKey) or focusedRefresh) then
		setHomePageDataStatuses(RetrievalStatus.Fetching)

		local v3 = false

		if FFlagEnableHomePageSduiPrefetch and HomePageSession:GetCommitted() == nil then
			local v4 = prefetchProtocol.default:popPendingPrefetchGuid()

			if v4 ~= nil then
				v3 = HomePageSession:Adopt(v4)
			end
		end

		if not v3 then
			HomePageSession:Refresh()
		end
	end

	local ServiceContractsProto = require(parent.ServiceContractsProto)
	local home_page = ServiceContractsProto.apppageplatform.home.home_page
	local clientCapabilities = ServiceContractsProto.apppageplatform.shared.client_capabilities.ClientCapabilities
	local enabled_capabilities, clientCapabilities2

	if FFlagSduiAdvertiseRuntimeSupportSets then
		enabled_capabilities = SduiCapabilities.getEnabledCapabilityNumbersWithoutExtendedMarker()
		clientCapabilities2 = SduiCapabilities.buildClientCapabilities()
	else
		enabled_capabilities = SduiCapabilities.getEnabledCapabilityNumbers({
			"CAPABILITY_SUPPORTS_HYDRATION_CLIENT_HINTS",
			FFlagSduiPerSectionPoolSizing and "CAPABILITY_SUPPORTS_MULTI_SIZE_POOL" or nil,
			FFlagLuaAppHomeMomentVideoFallback and "CAPABILITY_SUPPORTS_VIDEO_PLAYER_ACCESS_CONTEXT" or nil
		})

		clientCapabilities2 = clientCapabilities.new({ enabled_capabilities = enabled_capabilities })
	end

	local collectionLayout

	if FFlagEnableHomePageSduiPrefetch then
		collectionLayout = measureHomeCollectionLayout()
	end

	local v3

	if focusedRefresh then
		v3 = HomePageFocusedFetchUtils.register(focusedRefresh)
	end

	if focusedRefresh and v3 == nil then
		return Promise.resolve(false), configKey
	end

	local homePageRequestConfig = createHomePageRequestConfig({
		pageTimer = pageTimer,
		homeApi = home_page,
		requestIntent = requestIntent,
		contextualFeatures = contextualFeatures,
		clientCapabilities = clientCapabilities2,
		collectionLayout = collectionLayout
	}, {
		configKey = configKey,
		sessionId = HomePageSession:Get(),
		topicIds = focusedRefresh and { focusedRefresh.topicId } or nil
	})

	homePageRequestConfig.mergeStrategy = SduiSharedUtilities.streamingFeedMergeStrategy

	if v3 then
		HomePageFocusedFetchUtils.applyToRequestConfig(homePageRequestConfig, v3)
	end

	if v3 == nil then
		function homePageRequestConfig.onSuccess(p, p2)
			if FFlagLuaAppSduiHomePageSupport then
				FriendRecommendations.getStore().replaceFriendRecommendations(readFriendRecommendations(p2))
			end

			commitHomeSession(p, p2)

			if FFlagLuaAppSduiHomeFeedStats then
				local reportSduiV2FeedStats = SduiLogger.reportSduiV2FeedStats
				local homeFeedStats = buildHomeFeedStats(p2)
				local home = AppPage.Home
				local request_id = readRequestId(p2) -- inferred equivalent call
				local v4

				if FFlagLuaAppAddHasOneByTwoFieldSdui then
					v4 = hasOneByTwoInResponse(p2)
				end

				reportSduiV2FeedStats(homeFeedStats, home, request_id, nil, v4)
			end

			if FFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui then
				local success, result = pcall(function(): nil
					logOneByTwoTileResponseReceivedFromDecodedResponse(p2)
					return nil
				end)

				if not success then
					SduiLogger.reportError(
						SduiErrors.SduiErrorType.CodeError,
						{
							name = "OneByTwoTileResponseReceived",
							message = SduiParseHelpers.stringifyValue(result)
						},
						AppPage.Home
					)
				end
			end

			setHomePageDataStatuses(RetrievalStatus.Done)

			if FFlagHomeSduiOfflineCache and p2 then
				task.defer(function()
					local sduiHomePageCachePayload = SduiHomePageCachePayload.buildSduiHomePageCachePayload(p2)

					if sduiHomePageCachePayload then
						HomeOmniFeedCache.cacheSduiHomePageData(SduiHomePageCachePayload.serializeSduiHomePageCache(sduiHomePageCachePayload))
					end
				end)
				setHomePageDataSource("API") -- inferred equivalent call
			end

			if FFlagEnableHomePageSduiPrefetch then
				if FFlagHomePageSduiPrefetchExtendedClientCapabilities then
					writeHomePageSduiPrefetchClientCapabilities(clientCapabilities2)
				else
					writeHomePageSduiPrefetchDescriptor(enabled_capabilities)
				end
			end
		end
		homePageRequestConfig.recoverFromError = FFlagHomeSduiOfflineCache and {
			getDecodedResponse = function()
				return SduiHomePageCachePayload.deserializeSduiHomePageCache(HomeOmniFeedCache.getCachedSduiHomePageData())
			end,
			onApplied = function()
				setHomePageDataSource("Cache") -- inferred equivalent call
				setHomePageDataStatuses(RetrievalStatus.Done)
			end
		} or nil

		function homePageRequestConfig.refresh(p)
			return (fetchHomePage(p, {
				forceRefresh = true,
				contextualFeatures = contextualFeatures
			}))
		end
	end

	local ifNeeded = sduiApiStore.fetchIfNeeded(homePageRequestConfig, v3 and true or forceRefresh)

	if v3 then
		return HomePageFocusedFetchUtils.resolve(ifNeeded, v3), configKey
	end

	return ifNeeded and ifNeeded:catch(function(_)
		if not (FFlagHomeSduiOfflineCache and isServingCachedHomePage()) then -- inferred equivalent call
			setHomePageDataStatuses(RetrievalStatus.Failed)
		end
	end), configKey
end

return fetchHomePage
