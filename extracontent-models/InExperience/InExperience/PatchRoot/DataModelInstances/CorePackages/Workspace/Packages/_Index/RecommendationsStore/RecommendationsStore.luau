require(script.FriendRecommendationTypes)
require(script.createFriendRecommendationsStore)
return {
	FriendRecommendations = require(script.FriendRecommendations),
	["jest.config"] = script["jest.config"]
}
