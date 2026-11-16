local SduiSharedUtilities = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/SduiSharedUtilities")
local sduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSduiTemplateStore = SduiSharedUtilities.getSduiTemplateStore
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local sduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
local sduiCapabilities = SduiSharedUtilities.SduiCapabilities

local ChartsConstants = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsPage/ChartsConstants")
local ChartsPageScopeFields = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsPage/ChartsPageScopeFields")
local ChartsPageSession = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsPage/ChartsPageSession")
local ChartsSortDetailScopeFields = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsSortDetailPage/ChartsSortDetailScopeFields")
local getChartsSortDetailPostUrl = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsSortDetailPage/getChartsSortDetailPostUrl")
local getChartsSortDetailPageKey = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsSortDetailPage/getChartsSortDetailPageKey")
local buildChartsSortDetailRequest = require("@game/CorePackages/Workspace/Packages/_Index/Charts/Charts/ChartsSortDetailPage/buildChartsSortDetailRequest")

local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/Charts/SharedFlags")
local fFlagSduiChartsSortDetailGenreFilter = SharedFlags.FFlagSduiChartsSortDetailGenreFilter
local fFlagSduiAdvertiseRuntimeSupportSets = SharedFlags.FFlagSduiAdvertiseRuntimeSupportSets

local function getInheritedFilterSelections()
	return getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)
end

local function extractNextContentPageToken(p2)
	local next_content_page_token = p2 and p2.next_content_page_token

	if next_content_page_token and next_content_page_token ~= "" then
		return next_content_page_token
	end

	return nil
end

local function getGenreForRequest(p2)
	local sduiClientPageScope = getSduiClientPageScope(p2)
	local v5 = sduiClientPageScope.get(ChartsSortDetailScopeFields.DesiredGenre)
	local v6 = sduiClientPageScope.get(ChartsSortDetailScopeFields.SafeGenre)

	local v7 = typeof(v5) == "string" and v5 ~= ""
	local v8 = typeof(v6) == "string" and v6 ~= ""

	if v7 and v5 ~= v6 then
		return v5
	end

	if v8 then
		return v6
	end

	return nil
end

local function getFilterSelectionsWithGenre(chartsSortDetail)
	local v5 = getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)

	local genreForRequest = getGenreForRequest(chartsSortDetail)

	if genreForRequest == nil then
		return v5
	end

	local v6 = not v5 and {} or table.clone(v5)
	v6.selectedGenre = genreForRequest
	return v6
end

local function resetStickyGenreIfStale(p2)
	local data, v5 = getSduiApiStore().getData(p2)

	if v5 then
		local sduiClientPageScope = getSduiClientPageScope(p2)
		sduiClientPageScope.set(ChartsSortDetailScopeFields.DesiredGenre, nil)
		sduiClientPageScope.set(ChartsSortDetailScopeFields.SafeGenre, nil)
	end
end

local function fetchChartsSortDetail(p2, p3)
	local chartsSortDetail = getChartsSortDetailPageKey(
		p2,
		nil,
		(getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections))
	)

	if fFlagSduiChartsSortDetailGenreFilter then
		local data, v6 = getSduiApiStore().getData(chartsSortDetail)

		if v6 then
			local sduiClientPageScope = getSduiClientPageScope(chartsSortDetail)
			sduiClientPageScope.set(ChartsSortDetailScopeFields.DesiredGenre, nil)
			sduiClientPageScope.set(ChartsSortDetailScopeFields.SafeGenre, nil)
		end
	end

	local refreshUrl = getChartsSortDetailPostUrl()

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
			sortId = p2,
			contentPageToken = p4,
			sessionId = ChartsPageSession:Get(),
			filterSelections = 0,
			cachedRobloxComponentToTemplateId = 0,
			clientCapabilities = 0
		}
		local v10 = if fFlagSduiChartsSortDetailGenreFilter then getFilterSelectionsWithGenre(chartsSortDetail) else getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)
		v9.filterSelections = v10

		v9.cachedRobloxComponentToTemplateId = getSduiTemplateStore().getCachedRobloxComponentToTemplateId("ChartsSortDetail")

		v9.clientCapabilities = v6
		return buildChartsSortDetailRequest(charts_page, v9)
	end

	getSduiApiStore().fetchIfNeeded({
		responseType = sduiResponseType.Protobuf,
		url = refreshUrl,
		surfaceKey = "ChartsSortDetail",
		configKey = chartsSortDetail,
		loadTimer = p3,
		apiProto = charts_page.GetChartsSortDetailResponse,
		postConfig = {
			contentType = sduiApiStorePostConfigContentType.Proto,
			protoMessage = charts_page.GetChartsSortDetailRequest,
			body = buildBody(nil)
		},
		enableTemplateCache = true,
		buildNextPageUrl = function(p4)
			local next_content_page_token = p4 and p4.next_content_page_token

			if not next_content_page_token or next_content_page_token == "" then
				next_content_page_token = nil
			end

			if next_content_page_token then
				return refreshUrl
			end

			return nil
		end,
		buildNextPagePostBody = function(p4)
			local next_content_page_token = p4 and p4.next_content_page_token

			if not next_content_page_token or next_content_page_token == "" then
				next_content_page_token = nil
			end

			if next_content_page_token then
				return buildBody(next_content_page_token)
			end

			return nil
		end,
		buildRefreshUrl = function()
			return refreshUrl
		end,
		buildRefreshPostBody = function()
			return buildBody(nil)
		end
	})

	return chartsSortDetail
end

return fetchChartsSortDetail
