local parent = script:FindFirstAncestor("DataHydration").Parent

local HttpClient = require(parent.HttpClient)
local UrlBuilder = require(parent.UrlBuilder)
local UrlBase = UrlBuilder.UrlBase

local FStringBuildAnalyticsGoalMilestonesFeatureName = require(script.Parent.FStringBuildAnalyticsGoalMilestonesFeatureName)
require(script.Parent.GoalMilestonesTypes)

local function toMilestones(p, p2: string)
	local milestones = {}

	for _, v in p.features or {} do
		if v.name ~= p2 then
			continue
		end

		for k, v2 in v.values or {} do
			milestones[k] = string.lower(v2) == "true"
		end
	end

	return milestones
end

local function fetchGoalMilestones(p: number, options)
	local v = options or {}
	local baseUrl = v.baseUrl or UrlBase.APIS
	local v2 = FStringBuildAnalyticsGoalMilestonesFeatureName

	local fetched = HttpClient.fetch({
		method = "GET",
		url = `{baseUrl}/analytics-features/v1/universes/{p}/features?featureNames={v2}`,
		analyticsKey = "analytics-features.goal-milestones.get",
		network = v.network,
		decode = function(p2)
			return toMilestones(p2, v2)
		end
	})

	return HttpClient.asPromise(fetched)
end

return fetchGoalMilestones
