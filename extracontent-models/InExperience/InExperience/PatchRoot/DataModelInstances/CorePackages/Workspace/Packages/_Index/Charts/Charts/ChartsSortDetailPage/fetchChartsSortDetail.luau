local Charts = script:FindFirstAncestor("Charts")
local parent = Charts.Parent

local SduiSharedUtilities = require(parent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSduiTemplateStore = SduiSharedUtilities.getSduiTemplateStore
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local SduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
local SduiCapabilities = SduiSharedUtilities.SduiCapabilities

local ChartsConstants = require(Charts.ChartsPage.ChartsConstants)
local ChartsPageScopeFields = require(Charts.ChartsPage.ChartsPageScopeFields)
local ChartsPageSession = require(Charts.ChartsPage.ChartsPageSession)
local ChartsSortDetailScopeFields = require(Charts.ChartsSortDetailPage.ChartsSortDetailScopeFields)
local getChartsSortDetailPostUrl = require(Charts.ChartsSortDetailPage.getChartsSortDetailPostUrl)
local getChartsSortDetailPageKey = require(Charts.ChartsSortDetailPage.getChartsSortDetailPageKey)
local buildChartsSortDetailRequest = require(Charts.ChartsSortDetailPage.buildChartsSortDetailRequest)

local SharedFlags = require(parent.SharedFlags)
local FFlagSduiChartsSortDetailGenreFilter = SharedFlags.FFlagSduiChartsSortDetailGenreFilter
local FFlagSduiAdvertiseRuntimeSupportSets = SharedFlags.FFlagSduiAdvertiseRuntimeSupportSets

local function getInheritedFilterSelections() -- 3 equivalent calls inferred from this helper
	return getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)
end

local function extractNextContentPageToken(p) -- 2 equivalent calls inferred from this helper
	local next_content_page_token = p and p.next_content_page_token

	if next_content_page_token and next_content_page_token ~= "" then
		return next_content_page_token
	end

	return nil
end

local function getGenreForRequest(p: string)
	local sduiClientPageScope = getSduiClientPageScope(p)
	local v = sduiClientPageScope.get(ChartsSortDetailScopeFields.DesiredGenre)
	local v2 = sduiClientPageScope.get(ChartsSortDetailScopeFields.SafeGenre)
	local v3

	if typeof(v) == "string" then
		v3 = v ~= ""
	else
		v3 = false
	end

	local v4

	if typeof(v2) == "string" then
		v4 = v2 ~= ""
	else
		v4 = false
	end

	if v3 and v ~= v2 then
		return v
	end

	return if v4 then v2 else nil
end

local function getFilterSelectionsWithGenre(chartsSortDetailPageKey: string)
	local inheritedFilterSelections = getInheritedFilterSelections() -- inferred equivalent call
	local genreForRequest = getGenreForRequest(chartsSortDetailPageKey)

	if genreForRequest == nil then
		return inheritedFilterSelections
	end

	local selected = not inheritedFilterSelections and {} or table.clone(inheritedFilterSelections)
	selected.selectedGenre = genreForRequest
	return selected
end

local function resetStickyGenreIfStale(chartsSortDetailPageKey: string) -- 1 equivalent call inferred from this helper
	local _, v = getSduiApiStore().getData(chartsSortDetailPageKey)

	if v then
		local sduiClientPageScope = getSduiClientPageScope(chartsSortDetailPageKey)
		sduiClientPageScope.set(ChartsSortDetailScopeFields.DesiredGenre, nil)
		sduiClientPageScope.set(ChartsSortDetailScopeFields.SafeGenre, nil)
	end
end

local function fetchChartsSortDetail(sortId: string, loadTimer)
	local chartsSortDetailPageKey = getChartsSortDetailPageKey(sortId, nil, (getInheritedFilterSelections())) -- inferred equivalent call

	if FFlagSduiChartsSortDetailGenreFilter then
		resetStickyGenreIfStale(chartsSortDetailPageKey) -- inferred equivalent call
	end

	local chartsSortDetailPostUrl = getChartsSortDetailPostUrl()

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

	local function buildBody(contentPageToken: string?)
		local v = {
			sortId = sortId,
			contentPageToken = contentPageToken,
			sessionId = ChartsPageSession:Get(),
			filterSelections = 0,
			cachedRobloxComponentToTemplateId = 0,
			clientCapabilities = 0
		}
		local filterSelections

		if FFlagSduiChartsSortDetailGenreFilter then
			filterSelections = getFilterSelectionsWithGenre(chartsSortDetailPageKey)
		else
			filterSelections = getInheritedFilterSelections() -- inferred equivalent call
		end

		v.filterSelections = filterSelections

		v.cachedRobloxComponentToTemplateId = getSduiTemplateStore().getCachedRobloxComponentToTemplateId("ChartsSortDetail")

		v.clientCapabilities = clientCapabilities2
		return buildChartsSortDetailRequest(charts_page, v)
	end

	getSduiApiStore().fetchIfNeeded({
		responseType = SduiResponseType.Protobuf,
		url = chartsSortDetailPostUrl,
		surfaceKey = "ChartsSortDetail",
		configKey = chartsSortDetailPageKey,
		loadTimer = loadTimer,
		apiProto = charts_page.GetChartsSortDetailResponse,
		postConfig = {
			contentType = SduiApiStorePostConfigContentType.Proto,
			protoMessage = charts_page.GetChartsSortDetailRequest,
			body = buildBody(nil)
		},
		enableTemplateCache = true,
		buildNextPageUrl = function(p)
			if extractNextContentPageToken(p) then -- inferred equivalent call
				return chartsSortDetailPostUrl
			end

			return nil
		end,
		buildNextPagePostBody = function(p)
			local contentPageToken = extractNextContentPageToken(p) -- inferred equivalent call

			if contentPageToken then
				return buildBody(contentPageToken)
			end

			return nil
		end,
		buildRefreshUrl = function()
			return chartsSortDetailPostUrl
		end,
		buildRefreshPostBody = function()
			return buildBody(nil)
		end
	})

	return chartsSortDetailPageKey
end

return fetchChartsSortDetail
