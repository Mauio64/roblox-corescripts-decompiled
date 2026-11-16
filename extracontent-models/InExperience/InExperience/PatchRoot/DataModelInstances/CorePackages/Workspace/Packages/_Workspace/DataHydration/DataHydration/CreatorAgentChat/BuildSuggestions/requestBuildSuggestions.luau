local DataHydration = script:FindFirstAncestor("DataHydration")
local parent = DataHydration.Parent

local HttpClient = require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

local decodeBuildSuggestionsResponse = require(script.Parent.decodeBuildSuggestionsResponse)
local getDefaultAuthHeaders = require(script.Parent.Parent.Acp.getDefaultAuthHeaders)
local resolveAcpUrl = require(script.Parent.Parent.Env.resolveAcpUrl)
local withCsrfRetry = require(DataHydration.withCsrfRetry)

local function resolveBuildSuggestionsUrl() -- 1 equivalent call inferred from this helper
	local sitetestNumber = resolveAcpUrl.resolveCreatorAgentAcp().sitetestNumber

	if sitetestNumber == nil then
		return UrlBase.APIS .. "/creator-agents-service/v1/build/suggestions"
	end

	return `https://apis.sitetest{sitetestNumber}.robloxlabs.com/creator-agents-service/v1/build/suggestions`
end

local function requestBuildSuggestions(data)
	local getAuthHeaders = data.getAuthHeaders or getDefaultAuthHeaders
	local selected_chip = data.selectedChip ~= nil and { value = data.selectedChip } or nil

	local v = {
		method = "POST",
		url = data.url or resolveBuildSuggestionsUrl(), -- inferred equivalent call
		headers = getAuthHeaders(),
		body = { prompt = data.prompt, selected_chip = selected_chip },
		network = data.network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
		analyticsKey = "cas.build-suggestions",
		decode = decodeBuildSuggestionsResponse
	}

	return HttpClient.fetch(v)
end

return requestBuildSuggestions
