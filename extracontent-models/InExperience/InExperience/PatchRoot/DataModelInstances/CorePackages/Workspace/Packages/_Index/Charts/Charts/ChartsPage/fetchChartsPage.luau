local Charts = script:FindFirstAncestor("Charts")
local parent = Charts.Parent

local RobloxAppEnums = require(parent.RobloxAppEnums)
local AppPage = RobloxAppEnums.AppPage
local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSduiTemplateStore = SduiSharedUtilities.getSduiTemplateStore
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local SduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
local SduiCapabilities = SduiSharedUtilities.SduiCapabilities

local ChartsPageSession = require(Charts.ChartsPage.ChartsPageSession)
local getChartsPagePostUrl = require(Charts.ChartsPage.getChartsPagePostUrl)
local getChartsPageStreamUrl = require(Charts.ChartsPage.getChartsPageStreamUrl)
local ChartsConstants = require(Charts.ChartsPage.ChartsConstants)
local ChartsPageScopeFields = require(Charts.ChartsPage.ChartsPageScopeFields)
local chartsMergeStrategy = require(Charts.ChartsPage.chartsMergeStrategy)
local buildChartsPageRequest = require(Charts.ChartsPage.buildChartsPageRequest)

local SharedFlags = require(parent.SharedFlags)
local FFlagEnableTopSongsSort = SharedFlags.FFlagEnableTopSongsSort
local GetFStringTopSongsSortExploreApiPageType = SharedFlags.GetFStringTopSongsSortExploreApiPageType
local FFlagSduiChartsRequestPlaceholders = SharedFlags.FFlagSduiChartsRequestPlaceholders
local FFlagSduiChartsPlaceholderMergeStrategySupport = SharedFlags.FFlagSduiChartsPlaceholderMergeStrategySupport
local FFlagChartsHydrationStreaming = SharedFlags.FFlagChartsHydrationStreaming
local FFlagSduiAdvertiseRuntimeSupportSets = SharedFlags.FFlagSduiAdvertiseRuntimeSupportSets

local function getCurrentFilterSelections() -- 1 equivalent call inferred from this helper
	return getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)
end

local function getCurrentPageType() -- 1 equivalent call inferred from this helper
	if FFlagEnableTopSongsSort then
		return (GetFStringTopSongsSortExploreApiPageType())
	end

	return nil
end

local function extractNextFeedPageToken(p)
	local page_entries = p and p.page_entries

	if not page_entries then
		return nil
	end

	for _, page_entry in page_entries do
		local page_entry2 = page_entry.page_entry

		if not (page_entry2 and page_entry2.identifier == "charts_feed") then
			continue
		end

		local input_data = page_entry.input_data
		local kind = input_data and input_data.kind
		local value = kind and kind.value
		local next_page_token = value and value.next_page_token

		if next_page_token and next_page_token ~= "" then
			return next_page_token
		end
	end

	return nil
end

local function fetchChartsPage(loadTimer, flag: boolean?)
	local configKey = ChartsConstants.ConfigKey
	local sduiApiStore = getSduiApiStore()

	local _, v = sduiApiStore.getData(configKey)

	if flag or v then
		v = not sduiApiStore.isInFlight(configKey)
	end

	if v then
		ChartsPageSession:Refresh()
	end

	local refreshUrl

	if FFlagChartsHydrationStreaming then
		refreshUrl = getChartsPageStreamUrl()
	else
		refreshUrl = getChartsPagePostUrl()
	end

	local ServiceContractsProto = require(parent.ServiceContractsProto)
	local charts_page = ServiceContractsProto.apppageplatform.charts.charts_page
	local clientCapabilities = ServiceContractsProto.apppageplatform.shared.client_capabilities.ClientCapabilities
	local clientCapabilities2

	if FFlagSduiAdvertiseRuntimeSupportSets then
		clientCapabilities2 = SduiCapabilities.buildClientCapabilities()
	else
		clientCapabilities2 = clientCapabilities.new({
			enabled_capabilities = SduiCapabilities.getEnabledCapabilityNumbers({ "CAPABILITY_SUPPORTS_HYDRATION_CLIENT_HINTS" })
		})
	end

	local function buildBody(feedPageToken: string?)
		return buildChartsPageRequest(charts_page, {
			feedPageToken = feedPageToken,
			sessionId = ChartsPageSession:Get(),
			filterSelections = getCurrentFilterSelections(), -- inferred equivalent call
			pageType = getCurrentPageType(), -- inferred equivalent call
			includePlaceholders = FFlagSduiChartsRequestPlaceholders and true or nil,
			hydrationStreamEnabled = FFlagChartsHydrationStreaming and true or nil,
			cachedRobloxComponentToTemplateId = getSduiTemplateStore().getCachedRobloxComponentToTemplateId(AppPage.Games),
			clientCapabilities = clientCapabilities2
		})
	end

	local fetchIfNeeded = sduiApiStore.fetchIfNeeded
	local v2 = {
		responseType = SduiResponseType.Protobuf,
		url = refreshUrl,
		surfaceKey = AppPage.Games,
		configKey = configKey,
		loadTimer = loadTimer,
		apiProto = charts_page.GetChartsPageResponse,
		mergeStrategy = 0,
		postConfig = 0,
		enableTemplateCache = true,
		enableStreaming = 0,
		allowNoConfigsBuilt = 0,
		buildNextPageUrl = 0,
		buildNextPagePostBody = 0,
		buildRefreshUrl = 0,
		buildRefreshPostBody = 0
	}
	local mergeStrategy

	if FFlagSduiChartsPlaceholderMergeStrategySupport then
		mergeStrategy = chartsMergeStrategy
	end

	v2.mergeStrategy = mergeStrategy
	v2.postConfig = {
		contentType = SduiApiStorePostConfigContentType.Proto,
		protoMessage = charts_page.GetChartsPageRequest,
		body = buildBody(nil)
	}

	v2.enableStreaming = FFlagChartsHydrationStreaming and true or nil

	v2.allowNoConfigsBuilt = FFlagChartsHydrationStreaming and true or nil

	function v2.buildNextPageUrl(p)
		return if extractNextFeedPageToken(p) then refreshUrl else nil
	end

	function v2.buildNextPagePostBody(p)
		local feedPageToken = extractNextFeedPageToken(p)

		if feedPageToken then
			return buildBody(feedPageToken)
		end

		return nil
	end

	function v2.buildRefreshUrl()
		if not sduiApiStore.isInFlight(configKey) then
			ChartsPageSession:Refresh()
		end

		return refreshUrl
	end

	function v2.buildRefreshPostBody()
		return buildBody(nil)
	end

	return fetchIfNeeded(v2, flag), configKey
end

return fetchChartsPage
