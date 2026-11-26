local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBase

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorGroups/CreatorGroupsStoreTypes")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function fetchCreatorGroups(p2, options)
	local v5 = options or {}
	local baseUrl = v5.baseUrl or urlBase.APIS
	return asPromise((fetch({
		network = v5.network,
		method = "GET",
		url = ("%s/creator-home-api/v1/groups?surface=%s"):format(baseUrl, p2),
		analyticsKey = "creator-home.groups",
		decode = function(p3)
			return p3
		end
	})))
end

return fetchCreatorGroups
