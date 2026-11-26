return function(data)
	local v5 = {
		absolutePosition = data.position,
		requestedId = data.playerId,
		isRecommendation = not data.isFriendRequest,
		recommendationRank = 0,
		isContact = 0,
		contextualInfoType = 0
	}
	local v6 = if not data.isFriendRequest then data.rank else nil
	v5.recommendationRank = v6

	v5.isContact = data.isContact
	v5.contextualInfoType = data.contextualInfoType
	return v5
end
