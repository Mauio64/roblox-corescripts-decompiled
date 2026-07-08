local Charts = script:FindFirstAncestor("Charts")
local ChartsParent = Charts.Parent
local SduiSharedUtilities = require(ChartsParent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local ChartsConstants = require(Charts.ChartsPage.ChartsConstants)
local ChartsPageScopeFields = require(Charts.ChartsPage.ChartsPageScopeFields)
local ChartsPageSession = require(Charts.ChartsPage.ChartsPageSession)
local getChartsSortDetailUrl = require(Charts.ChartsSortDetailPage.getChartsSortDetailUrl)
local getChartsSortDetailPageKey = require(Charts.ChartsSortDetailPage.getChartsSortDetailPageKey)

local function getInheritedFilterSelections() -- line: 22
	-- upvalues: getSduiClientPageScope (copy), ChartsConstants (copy), ChartsPageScopeFields (copy)
	return getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)
end
local function fetchChartsSortDetail(s1: string, p1) -- line: 26
	-- upvalues: getSduiClientPageScope (copy), ChartsConstants (copy), ChartsPageScopeFields (copy), getChartsSortDetailUrl (copy), ChartsPageSession (copy), getChartsSortDetailPageKey (copy), ChartsParent (copy), getSduiApiStore (copy), SduiResponseType (copy)
	local v16 = getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)
	local v17 = getChartsSortDetailUrl({
		sortId = s1,
		sessionId = ChartsPageSession:Get(),
		filterSelections = v16
	})
	local v18 = getChartsSortDetailPageKey(s1, nil, v16)
	local charts_page = require(ChartsParent.ServiceContractsProto).apppageplatform.charts.charts_page

	getSduiApiStore().fetchIfNeeded({
		surfaceKey = "ChartsSortDetail",
		responseType = SduiResponseType.Protobuf,
		url = v17,
		configKey = v18,
		loadTimer = p1,
		apiProto = charts_page.GetChartsSortDetailResponse,
		buildNextPageUrl = function(p2) -- line: 45
			-- upvalues: getChartsSortDetailUrl (copy), s1 (copy), ChartsPageSession (copy), getSduiClientPageScope (copy), ChartsConstants (copy), ChartsPageScopeFields (copy)
			local v21 = p2 and p2.next_content_page_token

			if v21 and v21 ~= "" then
				return getChartsSortDetailUrl({
					sortId = s1,
					contentPageToken = v21,
					sessionId = ChartsPageSession:Get(),
					filterSelections = getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)
				})
			end

			return nil
		end,
		buildRefreshUrl = function() -- line: 57
			-- upvalues: getChartsSortDetailUrl (copy), s1 (copy), ChartsPageSession (copy), getSduiClientPageScope (copy), ChartsConstants (copy), ChartsPageScopeFields (copy)
			return getChartsSortDetailUrl({
				sortId = s1,
				sessionId = ChartsPageSession:Get(),
				filterSelections = getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)
			})
		end
	})

	return v18
end

return fetchChartsSortDetail
