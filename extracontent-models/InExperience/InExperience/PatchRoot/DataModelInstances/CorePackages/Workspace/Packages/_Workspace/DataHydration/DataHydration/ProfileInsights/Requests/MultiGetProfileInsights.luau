local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpClient = require(parent.HttpClient)
local Http = require(parent.Http)

require(script.Parent.Parent.ProfileInsightsStoreTypes)

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

return function(data, network)
	return asPromise((fetch({
		method = "POST",
		url = `{Http.Url.APIS_URL}profile-insights-api/v1/multiProfileInsights`,
		body = {
			userIds = data.userIds,
			count = data.count,
			rankingStrategy = data.rankingStrategy
		},
		network = network,
		analyticsKey = "profile-insights.multi-profile-insights",
		decode = function(p)
			return p
		end
	})))
end
