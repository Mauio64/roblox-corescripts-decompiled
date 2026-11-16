local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBase

local decodeBuildSuggestionsResponse = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/BuildSuggestions/decodeBuildSuggestionsResponse")
local getDefaultAuthHeaders = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Acp/getDefaultAuthHeaders")
local resolveAcpUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Env/resolveAcpUrl")
local withCsrfRetry = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/withCsrfRetry")

local function resolveBuildSuggestionsUrl()
	local sitetestNumber = resolveAcpUrl.resolveCreatorAgentAcp().sitetestNumber

	if sitetestNumber == nil then
		return urlBase.APIS .. "/creator-agents-service/v1/build/suggestions"
	end

	return `https://apis.sitetest{sitetestNumber}.robloxlabs.com/creator-agents-service/v1/build/suggestions`
end

local function requestBuildSuggestions(data)
	local getAuthHeaders = data.getAuthHeaders or getDefaultAuthHeaders
	local v5 = data.selectedChip ~= nil and { value = data.selectedChip } or nil

	local v7 = data.url

	if not v7 then
		local sitetestNumber = resolveAcpUrl.resolveCreatorAgentAcp().sitetestNumber

		if sitetestNumber == nil then
			v7 = urlBase.APIS .. "/creator-agents-service/v1/build/suggestions"
		else
			v7 = `https://apis.sitetest{sitetestNumber}.robloxlabs.com/creator-agents-service/v1/build/suggestions`
		end
	end

	local v6 = {
		method = "POST",
		url = v7,
		headers = getAuthHeaders(),
		body = { prompt = data.prompt, selected_chip = v5 },
		network = data.network or withCsrfRetry(HttpClient.createRequestInternalNetwork()),
		analyticsKey = "cas.build-suggestions",
		decode = decodeBuildSuggestionsResponse
	}

	return HttpClient.fetch(v6)
end

return requestBuildSuggestions
