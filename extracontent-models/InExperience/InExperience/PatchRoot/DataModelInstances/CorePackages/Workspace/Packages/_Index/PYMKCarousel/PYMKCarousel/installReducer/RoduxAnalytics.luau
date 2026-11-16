local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)

require(PYMKCarousel.Common.OmniTypes)
local transformOmniRecommendationsToActions = require(script.Parent.transformOmniRecommendationsToActions)
local Constants = require(PYMKCarousel.Common.Constants)
local RECOMMENDATION_SESSION_ID_KEY = Constants.RECOMMENDATION_SESSION_ID_KEY
local convertActions = dependencies.convertActions
local roduxAnalytics = dependencies.RoduxAnalytics

local v = roduxAnalytics.installReducer()

local function fn(p, _)
	local recommendationRequestId

	if
		p
		and p.recommendations
		and #p.recommendations > 0
		and p.recommendations[1]
		and p.recommendations[1].contentMetadata
	then
		local contentMetadata = p.recommendations[1].contentMetadata

		if contentMetadata then
			recommendationRequestId = contentMetadata.recommendationRequestId
		end
	end

	return roduxAnalytics.Actions.SessionIdUpdated({
		sessionKey = RECOMMENDATION_SESSION_ID_KEY,
		sessionId = recommendationRequestId
	})
end

local function fn2(p) -- 1 equivalent call inferred from this helper
	return {
		AddOmniRecommendations = function(p2)
			return transformOmniRecommendationsToActions(p2.recommendations or {}, p, nil, fn)
		end
	}
end

return function(p)
	return convertActions(v, fn2(p), {}) -- inferred equivalent call
end
