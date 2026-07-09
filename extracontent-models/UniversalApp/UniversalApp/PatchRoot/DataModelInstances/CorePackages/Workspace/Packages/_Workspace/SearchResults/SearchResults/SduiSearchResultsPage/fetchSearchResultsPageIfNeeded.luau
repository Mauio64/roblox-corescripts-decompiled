local Parent = script:FindFirstAncestor("SearchResults").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local SduiSharedUtilities = require(Parent.SduiSharedUtilities)
local SduiResponseType = SduiSharedUtilities.SduiResponseType
local getSduiApiStore = SduiSharedUtilities.getSduiApiStore
local getSearchResultsPageUrl = require(script.Parent.getSearchResultsPageUrl)
local getSearchResultsPageConfigKey = require(script.Parent.getSearchResultsPageConfigKey)
local FFlagLuaAppEnableSearchStreamingEndpoint = require(Parent.SharedFlags).FFlagLuaAppEnableSearchStreamingEndpoint

local function fetchSearchResultsPageIfNeeded(s1: string, s2: string, s3: string, p1, b1: boolean?) -- line: 16
	-- upvalues: getSearchResultsPageUrl (copy), getSearchResultsPageConfigKey (copy), Parent (copy), getSduiApiStore (copy), SduiResponseType (copy), AppPage (copy), FFlagLuaAppEnableSearchStreamingEndpoint (copy), SduiSharedUtilities (copy)
	local v15 = getSearchResultsPageUrl(s1, s2, s3)
	local v16 = getSearchResultsPageConfigKey(s2)
	local search_results_page = require(Parent.ServiceContractsProto).apppageplatform.search.search_results_page

	getSduiApiStore().fetchIfNeeded({
		responseType = SduiResponseType.Protobuf,
		url = v15,
		surfaceKey = AppPage.SearchPage,
		configKey = v16,
		loadTimer = p1,
		apiProto = search_results_page.GetSearchResultsPageResponse,
		enableStreaming = not not FFlagLuaAppEnableSearchStreamingEndpoint or nil,
		mergeStrategy = if not FFlagLuaAppEnableSearchStreamingEndpoint then nil else SduiSharedUtilities.streamingFeedMergeStrategy
	}, b1)
end

return fetchSearchResultsPageIfNeeded
