local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/RobloxAppEnums").AppPage
local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/SduiSharedUtilities")
local sduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSduiTemplateStore = SduiSharedUtilities.getSduiTemplateStore
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local sduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
local sduiCapabilities = SduiSharedUtilities.SduiCapabilities

local ChartsPageSession = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsPage/ChartsPageSession")
local getChartsPagePostUrl = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsPage/getChartsPagePostUrl")
local getChartsPageStreamUrl = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsPage/getChartsPageStreamUrl")
local ChartsConstants = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsPage/ChartsConstants")
local ChartsPageScopeFields = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsPage/ChartsPageScopeFields")
local chartsMergeStrategy = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsPage/chartsMergeStrategy")
local buildChartsPageRequest = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsPage/buildChartsPageRequest")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/SharedFlags")
local fFlagEnableTopSongsSort = SharedFlags.FFlagEnableTopSongsSort
local getFStringTopSongsSortExploreApiPageType = SharedFlags.GetFStringTopSongsSortExploreApiPageType
local fFlagSduiChartsRequestPlaceholders = SharedFlags.FFlagSduiChartsRequestPlaceholders
local fFlagSduiChartsPlaceholderMergeStrategySupport = SharedFlags.FFlagSduiChartsPlaceholderMergeStrategySupport
local fFlagChartsHydrationStreaming = SharedFlags.FFlagChartsHydrationStreaming
local fFlagSduiAdvertiseRuntimeSupportSets = SharedFlags.FFlagSduiAdvertiseRuntimeSupportSets

local function getCurrentFilterSelections()
	return getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)
end

local function getCurrentPageType()
	if fFlagEnableTopSongsSort then
		return (getFStringTopSongsSortExploreApiPageType())
	end

	return nil
end

local function extractNextFeedPageToken(p2)
	local page_entries = p2 and p2.page_entries

	if not page_entries then
		return nil
	end

	for k, page_entry in page_entries do
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

local function fetchChartsPage(p2, p3)
	local configKey = ChartsConstants.ConfigKey
	local sduiApiStore = getSduiApiStore()

	local data, v5 = sduiApiStore.getData(configKey)

	if p3 or v5 then
		v5 = not sduiApiStore.isInFlight(configKey)
	end

	if v5 then
		ChartsPageSession:Refresh()
	end

	local refreshUrl = if fFlagChartsHydrationStreaming then getChartsPageStreamUrl() else getChartsPagePostUrl()

	local ServiceContractsProto = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/ServiceContractsProto")
	local charts_page = ServiceContractsProto.apppageplatform.charts.charts_page
	local clientCapabilities = ServiceContractsProto.apppageplatform.shared.client_capabilities.ClientCapabilities
	local v6

	if fFlagSduiAdvertiseRuntimeSupportSets then
		v6 = sduiCapabilities.buildClientCapabilities()
	else
		v6 = clientCapabilities.new({
			enabled_capabilities = sduiCapabilities.getEnabledCapabilityNumbers({ "CAPABILITY_SUPPORTS_HYDRATION_CLIENT_HINTS" })
		})
	end

	local function buildBody(p4)
		local v9 = {
			feedPageToken = p4,
			sessionId = ChartsPageSession:Get(),
			filterSelections = getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections),
			pageType = 0,
			includePlaceholders = 0,
			hydrationStreamEnabled = 0,
			cachedRobloxComponentToTemplateId = 0,
			clientCapabilities = 0
		}
		local v10 = if fFlagEnableTopSongsSort then getFStringTopSongsSortExploreApiPageType() else nil

		v9.pageType = v10
		v9.includePlaceholders = fFlagSduiChartsRequestPlaceholders and true or nil
		v9.hydrationStreamEnabled = fFlagChartsHydrationStreaming and true or nil
		v9.cachedRobloxComponentToTemplateId = getSduiTemplateStore().getCachedRobloxComponentToTemplateId(appPage.Games)

		v9.clientCapabilities = v6
		return buildChartsPageRequest(charts_page, v9)
	end

	return sduiApiStore.fetchIfNeeded({
		responseType = sduiResponseType.Protobuf,
		url = refreshUrl,
		surfaceKey = appPage.Games,
		configKey = configKey,
		loadTimer = p2,
		apiProto = charts_page.GetChartsPageResponse,
		mergeStrategy = if fFlagSduiChartsPlaceholderMergeStrategySupport then chartsMergeStrategy else nil,
		postConfig = {
			contentType = sduiApiStorePostConfigContentType.Proto,
			protoMessage = charts_page.GetChartsPageRequest,
			body = buildBody(nil)
		},
		enableTemplateCache = true,
		enableStreaming = fFlagChartsHydrationStreaming and true or nil,
		allowNoConfigsBuilt = fFlagChartsHydrationStreaming and true or nil,
		buildNextPageUrl = function(p4)
			if extractNextFeedPageToken(p4) then
				return refreshUrl
			end

			return nil
		end,
		buildNextPagePostBody = function(p4)
			local v9 = extractNextFeedPageToken(p4)

			if v9 then
				return buildBody(v9)
			end

			return nil
		end,
		buildRefreshUrl = function()
			if not sduiApiStore.isInFlight(configKey) then
				ChartsPageSession:Refresh()
			end

			return refreshUrl
		end,
		buildRefreshPostBody = function()
			return buildBody(nil)
		end
	}, p3), configKey
end

return fetchChartsPage
