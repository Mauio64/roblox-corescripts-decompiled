require(script.FriendsRecommendationsStoreTypes)
require(script.SduiFriendRecommendationTypes)
require(script.createSduiFriendRecommendationsStore)

return {
	FriendsRecommendationsStore = require(script.FriendsRecommendationsStore),
	Enums = require(script.Enums),
	FriendRecommendations = require(script.SduiFriendRecommendations)
}
