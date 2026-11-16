local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local Http = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/Http")

require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/ProfileInsights/ProfileInsightsStoreTypes")

local fetch = HttpClient.fetch
local asPromise = HttpClient.asPromise

return function(data, p2)
	return asPromise((fetch({
		method = "POST",
		url = `{module2.Url.APIS_URL}profile-insights-api/v1/multiProfileInsights`,
		body = {
			userIds = data.userIds,
			count = data.count,
			rankingStrategy = data.rankingStrategy
		},
		network = p2,
		analyticsKey = "profile-insights.multi-profile-insights",
		decode = function(p3)
			return p3
		end
	})))
end
