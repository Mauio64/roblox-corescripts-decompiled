local Charts = script:FindFirstAncestor("Charts")
local ChartsParent = Charts.Parent
local AppPage = require(ChartsParent.RobloxAppEnums).AppPage
local SharedFlags = require(ChartsParent.SharedFlags)
local FFlagEnableTopSongsSort = SharedFlags.FFlagEnableTopSongsSort
local GetFStringTopSongsSortExploreApiPageType = SharedFlags.GetFStringTopSongsSortExploreApiPageType
local FFlagSduiChartsRequestPlaceholders = SharedFlags.FFlagSduiChartsRequestPlaceholders
local FFlagSduiChartsPlaceholderMergeStrategySupport = SharedFlags.FFlagSduiChartsPlaceholderMergeStrategySupport
local FFlagSduiChartsDedupSessionRotation = SharedFlags.FFlagSduiChartsDedupSessionRotation
local SduiSharedUtilities = require(ChartsParent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local ChartsPageSession = require(Charts.ChartsPage.ChartsPageSession)
local getChartsPageUrl = require(Charts.ChartsPage.getChartsPageUrl)
local ChartsConstants = require(Charts.ChartsPage.ChartsConstants)
local ChartsPageScopeFields = require(Charts.ChartsPage.ChartsPageScopeFields)
local chartsMergeStrategy = require(Charts.ChartsPage.chartsMergeStrategy)

local function getCurrentFilterSelections() -- line: 24
	-- upvalues: getSduiClientPageScope (copy), ChartsConstants (copy), ChartsPageScopeFields (copy)
	return getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)
end
local function getCurrentPageType() -- line: 28
	-- upvalues: FFlagEnableTopSongsSort (copy), GetFStringTopSongsSortExploreApiPageType (copy)
	if FFlagEnableTopSongsSort then
		return (GetFStringTopSongsSortExploreApiPageType())
	end

	return nil
end
local function fetchChartsPage(p1, b1: boolean?) -- line: 32
	-- upvalues: ChartsConstants (copy), getSduiApiStore (copy), FFlagSduiChartsDedupSessionRotation (copy), ChartsPageSession (copy), getChartsPageUrl (copy), getSduiClientPageScope (copy), ChartsPageScopeFields (copy), FFlagEnableTopSongsSort (copy), GetFStringTopSongsSortExploreApiPageType (copy), FFlagSduiChartsRequestPlaceholders (copy), ChartsParent (copy), SduiResponseType (copy), AppPage (copy), FFlagSduiChartsPlaceholderMergeStrategySupport (copy), chartsMergeStrategy (copy)
	local ConfigKey = ChartsConstants.ConfigKey
	local v25 = getSduiApiStore()
	local _, v27 = v25.getData(ConfigKey)

	if if not FFlagSduiChartsDedupSessionRotation then b1 or v27 else (b1 or v27) and not v25.isInFlight(ConfigKey) then
		ChartsPageSession:Refresh()
	end

	local v28 = getChartsPageUrl({
		sessionId = ChartsPageSession:Get(),
		filterSelections = getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections),
		pageType = if not FFlagEnableTopSongsSort then nil else GetFStringTopSongsSortExploreApiPageType(),
		includePlaceholders = not not FFlagSduiChartsRequestPlaceholders or nil
	})
	local charts_page = require(ChartsParent.ServiceContractsProto).apppageplatform.charts.charts_page

	return v25.fetchIfNeeded({
		responseType = SduiResponseType.Protobuf,
		url = v28,
		surfaceKey = AppPage.Games,
		configKey = ConfigKey,
		loadTimer = p1,
		apiProto = charts_page.GetChartsPageResponse,
		mergeStrategy = if not FFlagSduiChartsPlaceholderMergeStrategySupport then nil else chartsMergeStrategy,
		buildNextPageUrl = function(p2) -- line: 70
			-- upvalues: getChartsPageUrl (copy), ChartsPageSession (copy), getSduiClientPageScope (copy), ChartsConstants (copy), ChartsPageScopeFields (copy), FFlagEnableTopSongsSort (copy), GetFStringTopSongsSortExploreApiPageType (copy), FFlagSduiChartsRequestPlaceholders (copy)
			local v31 = p2 and p2.page_entries

			if not v31 then
				return nil
			end

			for _, v33 in v31 do
				local page_entry = v33.page_entry

				if not page_entry or page_entry.identifier ~= "charts_feed" then
					continue
				end

				local input_data = v33.input_data
				local v36 = input_data and input_data.kind
				local v37 = v36 and v36.value
				local v38 = v37 and v37.next_page_token

				if v38 and v38 ~= "" then
					return getChartsPageUrl({
						feedPageToken = v38,
						sessionId = ChartsPageSession:Get(),
						filterSelections = getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections),
						pageType = if not FFlagEnableTopSongsSort then nil else GetFStringTopSongsSortExploreApiPageType(),
						includePlaceholders = not not FFlagSduiChartsRequestPlaceholders or nil
					})
				end
			end

			return nil
		end,
		buildRefreshUrl = function() -- line: 95
			-- upvalues: FFlagSduiChartsDedupSessionRotation (copy), v25 (copy), ConfigKey (copy), ChartsPageSession (copy), getChartsPageUrl (copy), getSduiClientPageScope (copy), ChartsConstants (copy), ChartsPageScopeFields (copy), FFlagEnableTopSongsSort (copy), GetFStringTopSongsSortExploreApiPageType (copy), FFlagSduiChartsRequestPlaceholders (copy)
			if not FFlagSduiChartsDedupSessionRotation or not v25.isInFlight(ConfigKey) then
				ChartsPageSession:Refresh()
			end

			return getChartsPageUrl({
				sessionId = ChartsPageSession:Get(),
				filterSelections = getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections),
				pageType = if not FFlagEnableTopSongsSort then nil else GetFStringTopSongsSortExploreApiPageType(),
				includePlaceholders = not not FFlagSduiChartsRequestPlaceholders or nil
			})
		end
	}, b1), ConfigKey
end

return fetchChartsPage
