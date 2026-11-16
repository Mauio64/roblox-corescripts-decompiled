return function(p2)
	return {
		isFriendsWith = require("@game/CorePackages/Packages/_Index/RoduxFriends/RoduxFriends/Selectors/isFriendsWith")(p2),
		getSortedByRankRecommendations = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Selectors/getSortedByRankRecommendations")(p2),
		selectFriendshipStatusesByUserIds = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Selectors/selectFriendshipStatusesByUserIds")(p2),
		getRecommendationIdsBySource = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Selectors/getRecommendationIdsBySource")(p2),
		selectRecommendationsForUserId = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Selectors/selectRecommendationsForUserId")(p2),
		getSortedByRankRecommendationIds = require("@game/CorePackages/Workspace/Packages/_Index/FriendsRodux/FriendsRodux/Selectors/getSortedByRankRecommendationIds")(p2)
	}
end
