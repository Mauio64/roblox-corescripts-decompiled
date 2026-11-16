local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpClient = require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

require(script.Parent.CreatorGroupsStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

local function fetchCreatorGroups(p, options)
	local v = options or {}
	local baseUrl = v.baseUrl or UrlBase.APIS
	return asPromise((fetch({
		network = v.network,
		method = "GET",
		url = ("%s/creator-home-api/v1/groups?surface=%s"):format(baseUrl, p),
		analyticsKey = "creator-home.groups",
		decode = function(p2)
			return p2
		end
	})))
end

return fetchCreatorGroups
