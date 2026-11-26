local HttpClient = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/HttpClient")
local urlBase = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/UrlBuilder").UrlBase

local FStringBuildAnalyticsGoalMilestonesFeatureName = require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/FStringBuildAnalyticsGoalMilestonesFeatureName")
require("@game/CorePackages/Workspace/Packages/_Workspace/DataHydration/DataHydration/CreatorAnalytics/GoalMilestonesTypes")

local function toMilestones(p2, p3)
	local milestones = {}

	for k, v5 in p2.features or {} do
		if v5.name ~= p3 then
			continue
		end

		for k2, v6 in v5.values or {} do
			milestones[k2] = string.lower(v6) == "true"
		end
	end

	return milestones
end

local function fetchGoalMilestones(p2, options)
	local v5 = options or {}
	local baseUrl = v5.baseUrl or urlBase.APIS
	local v6 = FStringBuildAnalyticsGoalMilestonesFeatureName

	local fetched = HttpClient.fetch({
		method = "GET",
		url = `{baseUrl}/analytics-features/v1/universes/{p2}/features?featureNames={v6}`,
		analyticsKey = "analytics-features.goal-milestones.get",
		network = v5.network,
		decode = function(p3)
			return toMilestones(p3, v6)
		end
	})

	return HttpClient.asPromise(fetched)
end

return fetchGoalMilestones
