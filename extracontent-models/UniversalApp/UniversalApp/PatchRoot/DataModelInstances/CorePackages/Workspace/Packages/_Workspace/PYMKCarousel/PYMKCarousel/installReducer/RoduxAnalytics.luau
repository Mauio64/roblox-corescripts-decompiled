local PYMKCarousel = script:FindFirstAncestor("PYMKCarousel")
local dependencies = require(PYMKCarousel.dependencies)

require(PYMKCarousel.Common.OmniTypes)

local transformOmniRecommendationsToActions = require(script.Parent.transformOmniRecommendationsToActions)
local RECOMMENDATION_SESSION_ID_KEY = require(PYMKCarousel.Common.Constants).RECOMMENDATION_SESSION_ID_KEY
local convertActions = dependencies.convertActions
local RoduxAnalytics = dependencies.RoduxAnalytics
local v7 = RoduxAnalytics.installReducer()

local function v8(p1, _) -- line: 12
	-- upvalues: RoduxAnalytics (copy), RECOMMENDATION_SESSION_ID_KEY (copy)
	local v11 = nil

	if p1 and (p1.recommendations and #p1.recommendations > 0 and p1.recommendations[1] and p1.recommendations[1].contentMetadata) then
		local contentMetadata = p1.recommendations[1].contentMetadata

		v11 = if not contentMetadata then nil else contentMetadata.recommendationRequestId
	end

	return RoduxAnalytics.Actions.SessionIdUpdated({
		sessionKey = RECOMMENDATION_SESSION_ID_KEY,
		sessionId = v11
	})
end

return function(p3) -- line: 42
	-- upvalues: convertActions (copy), v7 (copy), transformOmniRecommendationsToActions (copy), v8 (copy)
	return convertActions(v7, {
		AddOmniRecommendations = function(p4) -- line: 36
			-- upvalues: transformOmniRecommendationsToActions (copy), p3 (copy), v8 (copy)
			return transformOmniRecommendationsToActions(p4.recommendations or {}, p3, nil, v8)
		end
	}, {})
end
