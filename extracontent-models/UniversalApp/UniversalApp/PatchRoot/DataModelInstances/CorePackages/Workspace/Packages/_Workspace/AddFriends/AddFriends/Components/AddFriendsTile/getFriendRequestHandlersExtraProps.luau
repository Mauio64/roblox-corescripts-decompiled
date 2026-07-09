return function(t1: {[any]: any}) -- line: 25
	return {
		absolutePosition = t1.position,
		requestedId = t1.playerId,
		isRecommendation = not t1.isFriendRequest,
		recommendationRank = if t1.isFriendRequest then nil else t1.rank,
		isContact = t1.isContact,
		contextualInfoType = t1.contextualInfoType
	}
end
