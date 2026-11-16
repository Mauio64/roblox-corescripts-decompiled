local ProfileInsightsModel = require(script["data-hydration"].ProfileInsightsModel)

local ProfileInsights = {
	["ProfileInsightsStore"] = nil,
	ProfileInsightsStore = require(script["data-hydration"].ProfileInsightsStore),
	ProfileInsightsModel = ProfileInsightsModel,
	useSignalProfileInsightsByUserId = require(script.Hooks.useSignalProfileInsightsByUserId),
	["jest.config"] = script["jest.config"]
}

local datahydration = require(script["data-hydration"])
ProfileInsights["data-hydration"] = datahydration
return ProfileInsights
