local appPage = require("@luauforge/bundled/foN").AppPage
local module = require("@luauforge/bundled/foM")
local sduiResponseType = module.SduiResponseType
local getSduiApiStore = module.getSduiApiStore
local getSduiTemplateStore = module.getSduiTemplateStore

local addSystemInfoToArgs = require("@luauforge/bundled/foR").AddSystemInfoToArgs
local getSearchViewportSize = require("@luauforge/bundled/foR").getSearchViewportSize
local module2 = require("@luauforge/bundled/foS")
local module3 = require("@luauforge/bundled/foV")

local module4 = require("@luauforge/bundled/foW")

local v5 = nil

local function getViewportSnapshot(p2)
	if v5 == nil then
		v5 = setmetatable({}, { __mode = "k" })
	end

	local searchViewportSizesByData = v5
	local data = getSduiApiStore().getData(p2)
	local v6 = searchViewportSizesByData[data]

	if v6 ~= nil then
		return v6
	end

	local searchViewportSize = getSearchViewportSize()

	if searchViewportSize ~= nil then
		searchViewportSizesByData[data] = searchViewportSize
	end

	return searchViewportSize
end

local module5 = require("@luauforge/bundled/foP")
local fFlagLuaAppEnableSearchStreamingEndpoint = module5.FFlagLuaAppEnableSearchStreamingEndpoint
local fFlagSduiExtendedCapabilitiesDiscovery = module5.FFlagSduiExtendedCapabilitiesDiscovery
local fFlagSduiSearchResultsForwardDeviceSignals = module5.FFlagSduiSearchResultsForwardDeviceSignals
local fFlagSduiSearchClientTemplateCache = module5.FFlagSduiSearchClientTemplateCache

local function buildPostBody(p2, p3, p4, cachedRobloxComponentToTemplateId, p5)
	local postBody = {
		searchQuery = p2,
		sessionId = p3,
		globalSessionId = p4,
		clientCapabilities = module.SduiCapabilities.buildClientCapabilities():jsonEncode()
	}

	if fFlagSduiSearchResultsForwardDeviceSignals then
		addSystemInfoToArgs(postBody)
	end

	if module4 and p5 ~= nil then
		postBody.viewportWidth = p5.X
		postBody.viewportHeight = p5.Y
	end

	if
		fFlagSduiSearchClientTemplateCache
		and cachedRobloxComponentToTemplateId ~= nil
		and next(cachedRobloxComponentToTemplateId) ~= nil
	then
		postBody.cachedRobloxComponentToTemplateId = cachedRobloxComponentToTemplateId
	end

	return postBody
end

local function fetchSearchResultsPageIfNeeded(p2, p3, p4, p5, p6)
	local v6

	if fFlagSduiSearchClientTemplateCache then
		v6 = getSduiTemplateStore().getCachedRobloxComponentToTemplateId(appPage.SearchPage)
	end

	local v7 = module2(p2, p3, p4)
	local v8 = module3(p3)
	local v9

	if module4 then
		v9 = getViewportSnapshot(v8)

		if
			v9 ~= nil
			and not (fFlagSduiExtendedCapabilitiesDiscovery and fFlagLuaAppEnableSearchStreamingEndpoint)
		then
			v7 = `{v7}&viewportWidth={v9.X}&viewportHeight={v9.Y}`
		end
	end

	local search_results_page = require("@luauforge/bundled/foX").apppageplatform.search.search_results_page

	local fetchIfNeeded = getSduiApiStore().fetchIfNeeded
	local v10 = {
		responseType = sduiResponseType.Protobuf,
		url = v7,
		surfaceKey = appPage.SearchPage,
		configKey = v8,
		loadTimer = p5,
		apiProto = search_results_page.GetSearchResultsPageResponse,
		enableTemplateCache = fFlagSduiSearchClientTemplateCache and true or nil,
		enableStreaming = fFlagLuaAppEnableSearchStreamingEndpoint and true or nil,
		mergeStrategy = 0,
		postConfig = 0
	}

	local v11 = if fFlagLuaAppEnableSearchStreamingEndpoint then module.streamingFeedMergeStrategy else nil
	v10.mergeStrategy = v11
	local v12

	if fFlagSduiExtendedCapabilitiesDiscovery and fFlagLuaAppEnableSearchStreamingEndpoint then
		v12 = { contentType = module.SduiApiStorePostConfigContentType.Json, body = 0 }

		if not fFlagSduiSearchClientTemplateCache then
			v6 = nil
		end

		v12.body = buildPostBody(p2, p3, p4, v6, v9)
	end

	v10.postConfig = v12
	fetchIfNeeded(v10, p6)
end

return fetchSearchResultsPageIfNeeded
