local dependencies = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies")

require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/OmniTypes")
local transformOmniRecommendationsToActions = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/installReducer/transformOmniRecommendationsToActions")
local RECOMMENDATION_SESSION_ID_KEY = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/Common/Constants").RECOMMENDATION_SESSION_ID_KEY
local convertActions = dependencies.convertActions
local roduxAnalytics = dependencies.RoduxAnalytics

local v5 = roduxAnalytics.installReducer()

local function fn(p2, p3)
	local recommendationRequestId

	if
		p2
		and p2.recommendations
		and #p2.recommendations > 0
		and p2.recommendations[1]
		and p2.recommendations[1].contentMetadata
	then
		local contentMetadata = p2.recommendations[1].contentMetadata

		if contentMetadata then
			recommendationRequestId = contentMetadata.recommendationRequestId
		end
	end

	return roduxAnalytics.Actions.SessionIdUpdated({
		sessionKey = RECOMMENDATION_SESSION_ID_KEY,
		sessionId = recommendationRequestId
	})
end

return function(p2)
	return convertActions(v5, {
		AddOmniRecommendations = function(p3)
			return transformOmniRecommendationsToActions(p3.recommendations or {}, p2, nil, fn)
		end
	}, {})
end
