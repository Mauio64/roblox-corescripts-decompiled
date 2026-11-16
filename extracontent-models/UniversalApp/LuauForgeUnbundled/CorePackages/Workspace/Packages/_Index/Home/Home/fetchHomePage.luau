local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/RobloxAppEnums").AppPage
local DiscoveryAvailability = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/DiscoveryAvailability")
local retrievalStatus = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/Http").Enum.RetrievalStatus
local Promise = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/Promise")
local setPageSessionTimestamp = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/PageSessionRodux").SetPageSessionTimestamp
local SduiCoreSystem = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SduiCoreSystem")
local getSduiServiceDependenciesStore = SduiCoreSystem.getSduiServiceDependenciesStore
local sduiPoolStore = SduiCoreSystem.SduiPoolStore
local sduiLogger = SduiCoreSystem.SduiLogger
local sduiErrors = SduiCoreSystem.SduiErrors
local sduiParseHelpers = SduiCoreSystem.SduiParseHelpers
local oneByTwoTileTelemetry = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SponsoredTilesTelemetry").OneByTwoTileTelemetry
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SduiSharedUtilities")
local sduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSduiTemplateStore = SduiSharedUtilities.getSduiTemplateStore
local sduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
local sduiCapabilities = SduiSharedUtilities.SduiCapabilities
local getStartupStore = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/StartupStore").GetStartupStore

local HomeConstants = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomeConstants")
local HomePageFocusedFetchUtils = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomePageFocusedFetchUtils")
local HomePageSession = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/HomePageSession")
local homeOmniFeedCache = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/DiscoveryUtils").HomeOmniFeedCache
local SduiHomePageCachePayload = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/SduiHomePageCachePayload")
local getHomePageUrl = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/getHomePageUrl")
local buildHomePageRequest = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/buildHomePageRequest")
local buildHomeFeedStats = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/buildHomeFeedStats")
local measureHomeCollectionLayout = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/measureHomeCollectionLayout")
local writeHomePageSduiPrefetchDescriptor = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/writeHomePageSduiPrefetchDescriptor")
local writeHomePageSduiPrefetchClientCapabilities = require("@game/CorePackages/Workspace/Packages/_Index/Home/Home/writeHomePageSduiPrefetchClientCapabilities")
local prefetchProtocol = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/PrefetchProtocol").PrefetchProtocol
local friendRecommendations = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/RecommendationsStore").FriendRecommendations

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/SharedFlags")
local fFlagEnableHomePageSduiPrefetch = SharedFlags.FFlagEnableHomePageSduiPrefetch
local fFlagUseSignalsForStartup = SharedFlags.FFlagUseSignalsForStartup
local fFlagHomeSduiOfflineCache = SharedFlags.FFlagHomeSduiOfflineCache
local fFlagSduiAdvertiseRuntimeSupportSets = SharedFlags.FFlagSduiAdvertiseRuntimeSupportSets

local fFlagHomePageSduiPrefetchExtendedClientCapabilities = SharedFlags.FFlagHomePageSduiPrefetchExtendedClientCapabilities
local fFlagLuaAppSduiHomePageSupport = SharedFlags.FFlagLuaAppSduiHomePageSupport
local fFlagLuaAppSduiHomeFeedStats = SharedFlags.FFlagLuaAppSduiHomeFeedStats
local fFlagLuaAppAddHasOneByTwoFieldSdui = SharedFlags.FFlagLuaAppAddHasOneByTwoFieldSdui
local fFlagSduiPerSectionPoolSizing = SharedFlags.FFlagSduiPerSectionPoolSizing
local fFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui = SharedFlags.FFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui
local fFlagLuaAppHomeMomentVideoFallback = SharedFlags.FFlagLuaAppHomeMomentVideoFallback

local function resolveRequestIntent(value, p2)
	if typeof(value) == "string" and value ~= "" then
		return value
	end

	if p2 then
		return HomeConstants.RequestIntent.ManualRefresh
	end

	return HomeConstants.RequestIntent.LogIn
end

local function createHomePageRequestConfig(data, data2)
	local homeApi = data.homeApi
	return {
		responseType = sduiResponseType.Protobuf,
		url = getHomePageUrl(),
		surfaceKey = appPage.Home,
		configKey = data2.configKey,
		loadTimer = data.pageTimer,
		apiProto = homeApi.HomePageResponse,
		postConfig = {
			contentType = sduiApiStorePostConfigContentType.Proto,
			protoMessage = homeApi.HomePageRequest,
			body = buildHomePageRequest(homeApi, {
				sessionId = data2.sessionId,
				topicIds = data2.topicIds,
				requestIntent = data.requestIntent,
				contextualFeatures = data.contextualFeatures,
				cachedRobloxComponentToTemplateId = getSduiTemplateStore().getCachedRobloxComponentToTemplateId(appPage.Home),
				clientCapabilities = data.clientCapabilities,
				collectionLayout = data.collectionLayout
			})
		},
		enableTemplateCache = true,
		enableStreaming = false,
		allowNoConfigsBuilt = true
	}
end

local function readRequestId(p2)
	local request_id = if type(p2) == "table" then p2.request_id else nil

	if request_id == nil or request_id == "" then
		return nil
	end

	return request_id
end

local function hasOneByTwoInResponse(p2): boolean
	if type(p2) ~= "table" then
		return false
	end

	for k, v5 in p2.page_entries or {} do
		local input_data = v5.input_data
		local value = if input_data and input_data.kind then input_data.kind.value else nil
		local content_pools = if value then value.content_pools else nil

		if not content_pools then
			continue
		end

		for k2, content_pool in content_pools do
			for k3, v6 in content_pool.items or {} do
				local layout = v6.layout
				local col_span = layout and (layout.col_span or 1) or nil

				if layout and layout.row_span == 2 and col_span == 1 then
					return true
				end
			end
		end
	end

	return false
end

local function readFriendRecommendations(p2)
	local hydration_data = if type(p2) == "table" then p2.hydration_data else nil
	local friend_recommendation = if type(hydration_data) == "table" then hydration_data.friend_recommendation else nil

	if type(friend_recommendation) == "table" then
		return (friendRecommendations.mapFromProto(friend_recommendation))
	end

	return {}
end

local v5 = nil

local function registerOneByTwoTileFunnelListener()
	v5 = sduiPoolStore.getSduiPoolStore(HomeConstants.ConfigKey)
	v5.setOneByTwoTileFunnelListener({
		onPlaced = oneByTwoTileTelemetry.logOneByTwoTilePlaced,
		onSkipped = oneByTwoTileTelemetry.logOneByTwoTileSkipped
	})
end

local function logOneByTwoTileResponseReceivedFromDecodedResponse(p2)
	if type(p2) ~= "table" then
		return
	end

	for k, v6 in p2.page_entries or {} do
		local value = v6.input_data and v6.input_data.kind and v6.input_data.kind.value
		local content_pools = value and value.content_pools

		if not content_pools then
			continue
		end

		for k2, v7 in SduiCoreSystem.getOneByTwoTileFlowIdsFromPools(content_pools) do
			oneByTwoTileTelemetry.logOneByTwoTileResponseReceived({
				oneByTwoTileFlowId = v7.oneByTwoTileFlowId,
				contentType = v7.contentType,
				adId = v7.adId,
				alignmentType = v7.alignmentType,
				componentType = "OneByTwoTile",
				isSdui = true
			})
		end
	end
end

local function commitHomeSession(p2, p3)
	local request_id = if type(p3) == "table" then p3.request_id else nil

	if request_id == nil or request_id == "" then
		request_id = nil
	end

	if not HomePageSession:Commit(request_id) then
		return
	end

	local dependencies = getSduiServiceDependenciesStore().getDependencies(appPage.Home)
	assert(dependencies, "dependencies is nil")
	dependencies.dispatch(setPageSessionTimestamp(appPage.Home))
end

local function setHomePageDataSource(p2)
	DiscoveryAvailability.Signals.getCacheStore().setHomePageDataSource(p2)
end

local function isServingCachedHomePage(): boolean
	return DiscoveryAvailability.Signals.getCacheStore().getHomePageDataSource(false) == "Cache"
end

local function setHomePageDataStatuses(p2)
	if fFlagUseSignalsForStartup then
		getStartupStore(false).setHomePageDataStatus(p2)
		getStartupStore(false).setFetchHomePageDataStatusAll(p2)
	else
		local dependencies = getSduiServiceDependenciesStore().getDependencies(appPage.Home)

		if dependencies == nil then
			return
		end

		dependencies.dispatch({ type = "SetHomePageDataStatus", status = p2 })
		dependencies.dispatch({ type = "SetFetchHomePageDataStatusAll", status = p2 })
	end
end

local function fetchHomePage(p2, data)
	if fFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui then
		v5 = sduiPoolStore.getSduiPoolStore(HomeConstants.ConfigKey)
		v5.setOneByTwoTileFunnelListener({
			onPlaced = oneByTwoTileTelemetry.logOneByTwoTilePlaced,
			onSkipped = oneByTwoTileTelemetry.logOneByTwoTileSkipped
		})
	end

	local configKey = HomeConstants.ConfigKey
	local sduiApiStore = getSduiApiStore()

	local forceRefresh = if data then data.forceRefresh else nil
	local contextualFeatures = if data then data.contextualFeatures else nil
	local v6 = if data then data.requestIntent else nil

	if typeof(v6) ~= "string" or v6 == "" then
		v6 = if forceRefresh then HomeConstants.RequestIntent.ManualRefresh else HomeConstants.RequestIntent.LogIn
	end

	local focusedRefresh = if data then data.focusedRefresh else nil

	local data2, v7 = sduiApiStore.getData(configKey)

	if (forceRefresh or v7) and not (sduiApiStore.isInFlight(configKey) or focusedRefresh) then
		setHomePageDataStatuses(retrievalStatus.Fetching)

		local v8 = false

		if fFlagEnableHomePageSduiPrefetch and HomePageSession:GetCommitted() == nil then
			local v9 = prefetchProtocol.default:popPendingPrefetchGuid()

			if v9 ~= nil then
				v8 = HomePageSession:Adopt(v9)
			end
		end

		if not v8 then
			HomePageSession:Refresh()
		end
	end

	local ServiceContractsProto = require("@game/CorePackages/Workspace/Packages/_Workspace/Home/ServiceContractsProto")
	local home_page = ServiceContractsProto.apppageplatform.home.home_page
	local clientCapabilities = ServiceContractsProto.apppageplatform.shared.client_capabilities.ClientCapabilities
	local v8, v9

	if fFlagSduiAdvertiseRuntimeSupportSets then
		v8 = sduiCapabilities.getEnabledCapabilityNumbersWithoutExtendedMarker()
		v9 = sduiCapabilities.buildClientCapabilities()
	else
		v8 = sduiCapabilities.getEnabledCapabilityNumbers({
			"CAPABILITY_SUPPORTS_HYDRATION_CLIENT_HINTS",
			fFlagSduiPerSectionPoolSizing and "CAPABILITY_SUPPORTS_MULTI_SIZE_POOL" or nil,
			fFlagLuaAppHomeMomentVideoFallback and "CAPABILITY_SUPPORTS_VIDEO_PLAYER_ACCESS_CONTEXT" or nil
		})

		v9 = clientCapabilities.new({ enabled_capabilities = v8 })
	end

	local v10 = if fFlagEnableHomePageSduiPrefetch then measureHomeCollectionLayout() else nil

	local v12 = if focusedRefresh then HomePageFocusedFetchUtils.register(focusedRefresh) else nil

	if focusedRefresh and v12 == nil then
		return Promise.resolve(false), configKey
	end

	local homePageRequestConfig = createHomePageRequestConfig({
		pageTimer = p2,
		homeApi = home_page,
		requestIntent = v6,
		contextualFeatures = contextualFeatures,
		clientCapabilities = v9,
		collectionLayout = v10
	}, {
		configKey = configKey,
		sessionId = HomePageSession:Get(),
		topicIds = focusedRefresh and { focusedRefresh.topicId } or nil
	})

	homePageRequestConfig.mergeStrategy = SduiSharedUtilities.streamingFeedMergeStrategy

	if v12 then
		HomePageFocusedFetchUtils.applyToRequestConfig(homePageRequestConfig, v12)
	end

	if v12 == nil then
		function homePageRequestConfig.onSuccess(p3, p4)
			if fFlagLuaAppSduiHomePageSupport then
				friendRecommendations.getStore().replaceFriendRecommendations(readFriendRecommendations(p4))
			end

			commitHomeSession(p3, p4)

			if fFlagLuaAppSduiHomeFeedStats then
				local reportSduiV2FeedStats = sduiLogger.reportSduiV2FeedStats
				local v13 = buildHomeFeedStats(p4)
				local home = appPage.Home
				local request_id = if type(p4) == "table" then p4.request_id else nil

				if request_id == nil or request_id == "" then
					request_id = nil
				end

				local v15 = if fFlagLuaAppAddHasOneByTwoFieldSdui then hasOneByTwoInResponse(p4) else nil
				reportSduiV2FeedStats(v13, home, request_id, nil, v15)
			end

			if fFlagLuaAppEnableOneByTwoTileFunnelTelemetrySdui then
				local success, result = pcall(function(): nil
					logOneByTwoTileResponseReceivedFromDecodedResponse(p4)
					return nil
				end)

				if not success then
					sduiLogger.reportError(
						sduiErrors.SduiErrorType.CodeError,
						{
							name = "OneByTwoTileResponseReceived",
							message = sduiParseHelpers.stringifyValue(result)
						},
						appPage.Home
					)
				end
			end

			setHomePageDataStatuses(retrievalStatus.Done)

			if fFlagHomeSduiOfflineCache and p4 then
				task.defer(function()
					local sduiHomePageCachePayload = SduiHomePageCachePayload.buildSduiHomePageCachePayload(p4)

					if sduiHomePageCachePayload then
						homeOmniFeedCache.cacheSduiHomePageData(SduiHomePageCachePayload.serializeSduiHomePageCache(sduiHomePageCachePayload))
					end
				end)
				DiscoveryAvailability.Signals.getCacheStore().setHomePageDataSource("API")
			end

			if fFlagEnableHomePageSduiPrefetch then
				if fFlagHomePageSduiPrefetchExtendedClientCapabilities then
					writeHomePageSduiPrefetchClientCapabilities(v9)
				else
					writeHomePageSduiPrefetchDescriptor(v8)
				end
			end
		end
		homePageRequestConfig.recoverFromError = fFlagHomeSduiOfflineCache and {
			getDecodedResponse = function()
				return SduiHomePageCachePayload.deserializeSduiHomePageCache(homeOmniFeedCache.getCachedSduiHomePageData())
			end,
			onApplied = function()
				DiscoveryAvailability.Signals.getCacheStore().setHomePageDataSource("Cache")

				setHomePageDataStatuses(retrievalStatus.Done)
			end
		} or nil

		function homePageRequestConfig.refresh(p3)
			return (fetchHomePage(p3, {
				forceRefresh = true,
				contextualFeatures = contextualFeatures
			}))
		end
	end

	local ifNeeded = sduiApiStore.fetchIfNeeded(homePageRequestConfig, v12 and true or forceRefresh)

	if v12 then
		return HomePageFocusedFetchUtils.resolve(ifNeeded, v12), configKey
	end

	return ifNeeded and ifNeeded:catch(function(p3)
		if
			not fFlagHomeSduiOfflineCache
			or DiscoveryAvailability.Signals.getCacheStore().getHomePageDataSource(false) ~= "Cache"
		then
			setHomePageDataStatuses(retrievalStatus.Failed)
		end
	end), configKey
end

return fetchHomePage
