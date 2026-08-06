local Charts = script:FindFirstAncestor("Charts")
local ChartsParent = Charts.Parent
local AppPage = require(ChartsParent.RobloxAppEnums).AppPage
local SduiSharedUtilities = require(ChartsParent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSduiTemplateStore = SduiSharedUtilities.getSduiTemplateStore
local getSduiClientPageScope = SduiSharedUtilities.getSduiClientPageScope
local SduiApiStorePostConfigContentType = SduiSharedUtilities.SduiApiStorePostConfigContentType
local SduiCapabilities = SduiSharedUtilities.SduiCapabilities
local ChartsPageSession = require(Charts.ChartsPage.ChartsPageSession)
local getChartsPageUrl = require(Charts.ChartsPage.getChartsPageUrl)
local getChartsPagePostUrl = require(Charts.ChartsPage.getChartsPagePostUrl)
local getChartsPageStreamUrl = require(Charts.ChartsPage.getChartsPageStreamUrl)
local ChartsConstants = require(Charts.ChartsPage.ChartsConstants)
local ChartsPageScopeFields = require(Charts.ChartsPage.ChartsPageScopeFields)
local chartsMergeStrategy = require(Charts.ChartsPage.chartsMergeStrategy)
local buildChartsPageRequest = require(Charts.ChartsPage.buildChartsPageRequest)
local SharedFlags = require(ChartsParent.SharedFlags)
local FFlagEnableTopSongsSort = SharedFlags.FFlagEnableTopSongsSort
local GetFStringTopSongsSortExploreApiPageType = SharedFlags.GetFStringTopSongsSortExploreApiPageType
local FFlagSduiChartsRequestPlaceholders = SharedFlags.FFlagSduiChartsRequestPlaceholders
local FFlagSduiChartsPlaceholderMergeStrategySupport = SharedFlags.FFlagSduiChartsPlaceholderMergeStrategySupport
local FFlagSduiChartsDedupSessionRotation = SharedFlags.FFlagSduiChartsDedupSessionRotation
local FFlagChartsHydrationStreaming = SharedFlags.FFlagChartsHydrationStreaming
local FFlagSduiChartsPostBody = SharedFlags.FFlagSduiChartsPostBody
local FFlagSduiClientTemplateCache = SharedFlags.FFlagSduiClientTemplateCache

local function getCurrentFilterSelections() -- line: 34
	-- upvalues: getSduiClientPageScope (copy), ChartsConstants (copy), ChartsPageScopeFields (copy)
	return getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections)
end
local function getCurrentPageType() -- line: 38
	-- upvalues: FFlagEnableTopSongsSort (copy), GetFStringTopSongsSortExploreApiPageType (copy)
	if FFlagEnableTopSongsSort then
		return (GetFStringTopSongsSortExploreApiPageType())
	end

	return nil
end
local function extractNextFeedPageToken(p1) -- line: 43
	local v33 = p1 and p1.page_entries

	if not v33 then
		return nil
	end

	for _, v35 in v33 do
		local page_entry = v35.page_entry

		if not page_entry or page_entry.identifier ~= "charts_feed" then
			continue
		end

		local input_data = v35.input_data
		local v38 = input_data and input_data.kind
		local v39 = v38 and v38.value
		local v40 = v39 and v39.next_page_token

		if v40 and v40 ~= "" then
			return v40
		end
	end

	return nil
end
local function fetchChartsPage(p2, b1: boolean?) -- line: 63
	-- upvalues: ChartsConstants (copy), getSduiApiStore (copy), FFlagSduiChartsDedupSessionRotation (copy), ChartsPageSession (copy), FFlagChartsHydrationStreaming (copy), FFlagSduiChartsPostBody (copy), getChartsPageStreamUrl (copy), getChartsPagePostUrl (copy), ChartsParent (copy), SduiCapabilities (copy), buildChartsPageRequest (copy), getSduiClientPageScope (copy), ChartsPageScopeFields (copy), FFlagEnableTopSongsSort (copy), GetFStringTopSongsSortExploreApiPageType (copy), FFlagSduiChartsRequestPlaceholders (copy), getSduiTemplateStore (copy), AppPage (copy), SduiResponseType (copy), FFlagSduiChartsPlaceholderMergeStrategySupport (copy), chartsMergeStrategy (copy), SduiApiStorePostConfigContentType (copy), FFlagSduiClientTemplateCache (copy), extractNextFeedPageToken (copy), getChartsPageUrl (copy)
	local ConfigKey = ChartsConstants.ConfigKey
	local v44 = getSduiApiStore()
	local _, v46 = v44.getData(ConfigKey)

	if if not FFlagSduiChartsDedupSessionRotation then b1 or v46 else (b1 or v46) and not v44.isInFlight(ConfigKey) then
		ChartsPageSession:Refresh()
	end

	local v52

	if FFlagChartsHydrationStreaming or FFlagSduiChartsPostBody then
		local v47 = if not FFlagChartsHydrationStreaming then getChartsPagePostUrl() else getChartsPageStreamUrl()
		local ServiceContractsProto = require(ChartsParent.ServiceContractsProto)
		local charts_page = ServiceContractsProto.apppageplatform.charts.charts_page
		local v50 = ServiceContractsProto.apppageplatform.shared.client_capabilities.ClientCapabilities.new({
			enabled_capabilities = SduiCapabilities.getEnabledCapabilityNumbers({ "CAPABILITY_SUPPORTS_HYDRATION_CLIENT_HINTS" })
		})

		local function buildBody(s1: string?) -- line: 106
			-- upvalues: buildChartsPageRequest (copy), charts_page (copy), ChartsPageSession (copy), getSduiClientPageScope (copy), ChartsConstants (copy), ChartsPageScopeFields (copy), FFlagEnableTopSongsSort (copy), GetFStringTopSongsSortExploreApiPageType (copy), FFlagSduiChartsRequestPlaceholders (copy), FFlagChartsHydrationStreaming (copy), getSduiTemplateStore (copy), AppPage (copy), v50 (copy)
			return buildChartsPageRequest(charts_page, {
				feedPageToken = s1,
				sessionId = ChartsPageSession:Get(),
				filterSelections = getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections),
				pageType = if not FFlagEnableTopSongsSort then nil else GetFStringTopSongsSortExploreApiPageType(),
				includePlaceholders = not not FFlagSduiChartsRequestPlaceholders or nil,
				hydrationStreamEnabled = not not FFlagChartsHydrationStreaming or nil,
				cachedRobloxComponentToTemplateId = getSduiTemplateStore().getCachedRobloxComponentToTemplateId(AppPage.Games),
				clientCapabilities = v50
			})
		end

		v52 = v44.fetchIfNeeded({
			responseType = SduiResponseType.Protobuf,
			url = v47,
			surfaceKey = AppPage.Games,
			configKey = ConfigKey,
			loadTimer = p2,
			apiProto = charts_page.GetChartsPageResponse,
			mergeStrategy = if not FFlagSduiChartsPlaceholderMergeStrategySupport then nil else chartsMergeStrategy,
			postConfig = {
				contentType = SduiApiStorePostConfigContentType.Proto,
				protoMessage = charts_page.GetChartsPageRequest,
				body = buildBody(nil)
			},
			enableTemplateCache = not not FFlagSduiClientTemplateCache or nil,
			enableStreaming = not not FFlagChartsHydrationStreaming or nil,
			allowNoConfigsBuilt = not not FFlagChartsHydrationStreaming or nil,
			buildNextPageUrl = function(p3) -- line: 140
				-- upvalues: extractNextFeedPageToken (copy), v47 (copy)
				if extractNextFeedPageToken(p3) then
					return v47
				end

				return nil
			end,
			buildNextPagePostBody = function(p4) -- line: 143
				-- upvalues: extractNextFeedPageToken (copy), buildBody (copy)
				local v58 = extractNextFeedPageToken(p4)

				if not v58 then
					return nil
				end

				return buildBody(v58)
			end,
			buildRefreshUrl = function() -- line: 153
				-- upvalues: FFlagSduiChartsDedupSessionRotation (copy), v44 (copy), ConfigKey (copy), ChartsPageSession (copy), v47 (copy)
				if not FFlagSduiChartsDedupSessionRotation or not v44.isInFlight(ConfigKey) then
					ChartsPageSession:Refresh()
				end

				return v47
			end,
			buildRefreshPostBody = function() -- line: 160
				-- upvalues: buildBody (copy)
				return buildBody(nil)
			end
		}, b1)
	else
		local v53 = getChartsPageUrl({
			sessionId = ChartsPageSession:Get(),
			filterSelections = getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections),
			pageType = if not FFlagEnableTopSongsSort then nil else GetFStringTopSongsSortExploreApiPageType(),
			includePlaceholders = not not FFlagSduiChartsRequestPlaceholders or nil
		})
		local charts_page = require(ChartsParent.ServiceContractsProto).apppageplatform.charts.charts_page

		v52 = v44.fetchIfNeeded({
			responseType = SduiResponseType.Protobuf,
			url = v53,
			surfaceKey = AppPage.Games,
			configKey = ConfigKey,
			loadTimer = p2,
			apiProto = charts_page.GetChartsPageResponse,
			mergeStrategy = if not FFlagSduiChartsPlaceholderMergeStrategySupport then nil else chartsMergeStrategy,
			buildNextPageUrl = function(p5) -- line: 183
				-- upvalues: extractNextFeedPageToken (copy), getChartsPageUrl (copy), ChartsPageSession (copy), getSduiClientPageScope (copy), ChartsConstants (copy), ChartsPageScopeFields (copy), FFlagEnableTopSongsSort (copy), GetFStringTopSongsSortExploreApiPageType (copy), FFlagSduiChartsRequestPlaceholders (copy)
				local v60 = extractNextFeedPageToken(p5)

				if not v60 then
					return nil
				end

				return getChartsPageUrl({
					feedPageToken = v60,
					sessionId = ChartsPageSession:Get(),
					filterSelections = getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections),
					pageType = if not FFlagEnableTopSongsSort then nil else GetFStringTopSongsSortExploreApiPageType(),
					includePlaceholders = not not FFlagSduiChartsRequestPlaceholders or nil
				})
			end,
			buildRefreshUrl = function() -- line: 198
				-- upvalues: FFlagSduiChartsDedupSessionRotation (copy), v44 (copy), ConfigKey (copy), ChartsPageSession (copy), getChartsPageUrl (copy), getSduiClientPageScope (copy), ChartsConstants (copy), ChartsPageScopeFields (copy), FFlagEnableTopSongsSort (copy), GetFStringTopSongsSortExploreApiPageType (copy), FFlagSduiChartsRequestPlaceholders (copy)
				if not FFlagSduiChartsDedupSessionRotation or not v44.isInFlight(ConfigKey) then
					ChartsPageSession:Refresh()
				end

				return getChartsPageUrl({
					sessionId = ChartsPageSession:Get(),
					filterSelections = getSduiClientPageScope(ChartsConstants.ConfigKey).get(ChartsPageScopeFields.FilterSelections),
					pageType = if not FFlagEnableTopSongsSort then nil else GetFStringTopSongsSortExploreApiPageType(),
					includePlaceholders = not not FFlagSduiChartsRequestPlaceholders or nil
				})
			end
		}, b1)
	end

	return v52, ConfigKey
end

return fetchChartsPage
