local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpClient = require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

local resolveAcpUrl = require(script.Parent.Parent.Env.resolveAcpUrl)
local decodePreviewSpecs = require(script.Parent.decodePreviewSpecs)
require(script.Parent.PreviewSpecsTypes)

local function getDefaultBaseUrl() -- 1 equivalent call inferred from this helper
	local sitetestNumber = resolveAcpUrl.resolveCreatorAgentAcp().sitetestNumber

	if sitetestNumber == nil then
		return UrlBase.APIS
	end

	return `https://apis.sitetest{sitetestNumber}.robloxlabs.com`
end

local function fetchPreviewSpecs(options)
	local v = options or {}
	local fetched = HttpClient.fetch({
		network = v.network,
		method = "GET",
		url = (v.baseUrl or getDefaultBaseUrl()) .. "/build-internal-dashboard-api/v1/preview-specs", -- inferred equivalent call
		analyticsKey = "build-preview-specs.get",
		retry = false,
		decode = decodePreviewSpecs
	})

	return HttpClient.asPromise(fetched)
end

return fetchPreviewSpecs
