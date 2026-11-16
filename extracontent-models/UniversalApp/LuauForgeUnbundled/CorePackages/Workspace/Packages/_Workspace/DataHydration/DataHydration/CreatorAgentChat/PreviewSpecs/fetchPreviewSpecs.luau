local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBase

local resolveAcpUrl = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/Env/resolveAcpUrl")
local decodePreviewSpecs = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/PreviewSpecs/decodePreviewSpecs")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAgentChat/PreviewSpecs/PreviewSpecsTypes")

local function getDefaultBaseUrl()
	local sitetestNumber = resolveAcpUrl.resolveCreatorAgentAcp().sitetestNumber

	if sitetestNumber == nil then
		return urlBase.APIS
	end

	return `https://apis.sitetest{sitetestNumber}.robloxlabs.com`
end

local function fetchPreviewSpecs(options)
	local v5 = options or {}
	local fetch = HttpClient.fetch
	local v6 = {
		network = v5.network,
		method = "GET",
		url = 0,
		analyticsKey = "build-preview-specs.get",
		retry = false,
		decode = 0
	}

	local v7 = v5.baseUrl

	if not v7 then
		local sitetestNumber = resolveAcpUrl.resolveCreatorAgentAcp().sitetestNumber

		if sitetestNumber == nil then
			v7 = urlBase.APIS
		else
			v7 = `https://apis.sitetest{sitetestNumber}.robloxlabs.com`
		end
	end

	v6.url = v7 .. "/build-internal-dashboard-api/v1/preview-specs"

	v6.decode = decodePreviewSpecs
	local fetched = fetch(v6)

	return HttpClient.asPromise(fetched)
end

return fetchPreviewSpecs
