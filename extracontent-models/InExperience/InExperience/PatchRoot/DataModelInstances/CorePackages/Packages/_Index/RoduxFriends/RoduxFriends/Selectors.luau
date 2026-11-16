return function(p)
	local isFriendsWith = require(script.isFriendsWith)
	local v = {
		isFriendsWith = isFriendsWith(p),
		getSortedByRankRecommendations = 0,
		selectFriendshipStatusesByUserIds = 0,
		getRecommendationIdsBySource = 0,
		selectRecommendationsForUserId = 0,
		getSortedByRankRecommendationIds = 0
	}
	local getSortedByRankRecommendations = require(script.getSortedByRankRecommendations)
	v.getSortedByRankRecommendations = getSortedByRankRecommendations(p)
	local selectFriendshipStatusesByUserIds = require(script.selectFriendshipStatusesByUserIds)
	v.selectFriendshipStatusesByUserIds = selectFriendshipStatusesByUserIds(p)
	local getRecommendationIdsBySource = require(script.getRecommendationIdsBySource)
	v.getRecommendationIdsBySource = getRecommendationIdsBySource(p)
	local selectRecommendationsForUserId = require(script.selectRecommendationsForUserId)
	v.selectRecommendationsForUserId = selectRecommendationsForUserId(p)
	local getSortedByRankRecommendationIds = require(script.getSortedByRankRecommendationIds)
	v.getSortedByRankRecommendationIds = getSortedByRankRecommendationIds(p)
	return v
end
