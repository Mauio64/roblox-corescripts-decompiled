local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpClient = require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

require(script.Parent.CreatorEligibilityStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise
local FetchCreatorEligibility = {}

function FetchCreatorEligibility.fetchEligibility(p: number, options)
	local v = options or {}
	local baseUrl = v.baseUrl or UrlBase.APIS
	return asPromise((fetch({
		network = v.network,
		method = "GET",
		url = ("%s/core-content/v1/creator-eligibility/%d"):format(baseUrl, p),
		analyticsKey = "creator-eligibility.get",
		decode = function(p2)
			return p2
		end
	})))
end

function FetchCreatorEligibility.isFlagPresent(p, p2): boolean
	return table.find(p.creatorEligibility, p2) ~= nil
end

return FetchCreatorEligibility
