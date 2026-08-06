local Charts = script:FindFirstAncestor("Charts")
local ChartsParent = Charts.Parent
local SduiSharedUtilities = require(ChartsParent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSduiTemplateStore = SduiSharedUtilities.getSduiTemplateStore
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local SduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
local SduiCapabilities = SduiSharedUtilities.SduiCapabilities
local ChartsConstants = require(Charts.ChartsPage.ChartsConstants)
local ChartsPageScopeFields = require(Charts.ChartsPage.ChartsPageScopeFields)
local ChartsPageSession = require(Charts.ChartsPage.ChartsPageSession)
local getChartsSortDetailUrl = require(Charts.ChartsSortDetailPage.getChartsSortDetailUrl)
local getChartsSortDetailPostUrl = require(Charts.ChartsSortDetailPage.getChartsSortDetailPostUrl)
local getChartsSortDetailPageKey = require(Charts.ChartsSortDetailPage.getChartsSortDetailPageKey)
local buildChartsSortDetailRequest = require(Charts.ChartsSortDetailPage.buildChartsSortDetailRequest)
local FFlagSduiChartsPostBody = require(ChartsParent.SharedFlags).FFlagSduiChartsPostBody

local function getInheritedFilterSelections() -- line: 29
	-- upvalues: getSduiClientPageScope (copy), ChartsConstants (copy), ChartsPageScopeFields (copy)
	return getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)
end
local function extractNextContentPageToken(p1) -- line: 34
	local v22 = p1 and p1.next_content_page_token

	if v22 and v22 ~= "" then
		return v22
	end

	return nil
end
local function fetchChartsSortDetail(s1: string, p2) -- line: 42
	-- upvalues: getSduiClientPageScope (copy), ChartsConstants (copy), ChartsPageScopeFields (copy), FFlagSduiChartsPostBody (copy), getChartsSortDetailPageKey (copy), getChartsSortDetailPostUrl (copy), ChartsParent (copy), SduiCapabilities (copy), buildChartsSortDetailRequest (copy), ChartsPageSession (copy), getSduiTemplateStore (copy), getSduiApiStore (copy), SduiResponseType (copy), SduiApiStorePostConfigContentType (copy), getChartsSortDetailUrl (copy)
	local v25 = getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)

	if FFlagSduiChartsPostBody then
		local v26 = getChartsSortDetailPageKey(s1, nil, v25)
		local v27 = getChartsSortDetailPostUrl()
		local ServiceContractsProto = require(ChartsParent.ServiceContractsProto)
		local charts_page = ServiceContractsProto.apppageplatform.charts.charts_page
		local v30 = ServiceContractsProto.apppageplatform.shared.client_capabilities.ClientCapabilities.new({
			enabled_capabilities = SduiCapabilities.getEnabledCapabilityNumbers({ "CAPABILITY_SUPPORTS_HYDRATION_CLIENT_HINTS" })
		})

		local function buildBody(s2: string?) -- line: 67
			-- upvalues: buildChartsSortDetailRequest (copy), charts_page (copy), s1 (copy), ChartsPageSession (copy), getSduiClientPageScope (copy), ChartsConstants (copy), ChartsPageScopeFields (copy), getSduiTemplateStore (copy), v30 (copy)
			return buildChartsSortDetailRequest(charts_page, {
				sortId = s1,
				contentPageToken = s2,
				sessionId = ChartsPageSession:Get(),
				filterSelections = getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections),
				cachedRobloxComponentToTemplateId = getSduiTemplateStore().getCachedRobloxComponentToTemplateId("ChartsSortDetail"),
				clientCapabilities = v30
			})
		end

		getSduiApiStore().fetchIfNeeded({
			surfaceKey = "ChartsSortDetail",
			enableTemplateCache = true,
			responseType = SduiResponseType.Protobuf,
			url = v27,
			configKey = v26,
			loadTimer = p2,
			apiProto = charts_page.GetChartsSortDetailResponse,
			postConfig = {
				contentType = SduiApiStorePostConfigContentType.Proto,
				protoMessage = charts_page.GetChartsSortDetailRequest,
				body = buildBody(nil)
			},
			buildNextPageUrl = function(p3) -- line: 94
				-- upvalues: v27 (copy)
				local v37 = p3 and p3.next_content_page_token

				if if not v37 or v37 == "" then nil else v37 then
					return v27
				end

				return nil
			end,
			buildNextPagePostBody = function(p4) -- line: 97
				-- upvalues: buildBody (copy)
				local v39 = p4 and p4.next_content_page_token
				local v40 = if not v39 or v39 == "" then nil else v39

				if not v40 then
					return nil
				end

				return buildBody(v40)
			end,
			buildRefreshUrl = function() -- line: 104
				-- upvalues: v27 (copy)
				return v27
			end,
			buildRefreshPostBody = function() -- line: 108
				-- upvalues: buildBody (copy)
				return buildBody(nil)
			end
		})

		return v26
	end

	local v32 = getChartsSortDetailUrl({
		sortId = s1,
		sessionId = ChartsPageSession:Get(),
		filterSelections = v25
	})
	local v33 = getChartsSortDetailPageKey(s1, nil, v25)
	local charts_page = require(ChartsParent.ServiceContractsProto).apppageplatform.charts.charts_page

	getSduiApiStore().fetchIfNeeded({
		surfaceKey = "ChartsSortDetail",
		responseType = SduiResponseType.Protobuf,
		url = v32,
		configKey = v33,
		loadTimer = p2,
		apiProto = charts_page.GetChartsSortDetailResponse,
		buildNextPageUrl = function(p5) -- line: 134
			-- upvalues: getChartsSortDetailUrl (copy), s1 (copy), ChartsPageSession (copy), getSduiClientPageScope (copy), ChartsConstants (copy), ChartsPageScopeFields (copy)
			local v42 = p5 and p5.next_content_page_token

			if v42 and v42 ~= "" then
				return getChartsSortDetailUrl({
					sortId = s1,
					contentPageToken = v42,
					sessionId = ChartsPageSession:Get(),
					filterSelections = getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)
				})
			end

			return nil
		end,
		buildRefreshUrl = function() -- line: 146
			-- upvalues: getChartsSortDetailUrl (copy), s1 (copy), ChartsPageSession (copy), getSduiClientPageScope (copy), ChartsConstants (copy), ChartsPageScopeFields (copy)
			return getChartsSortDetailUrl({
				sortId = s1,
				sessionId = ChartsPageSession:Get(),
				filterSelections = getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)
			})
		end
	})

	return v33
end

return fetchChartsSortDetail
