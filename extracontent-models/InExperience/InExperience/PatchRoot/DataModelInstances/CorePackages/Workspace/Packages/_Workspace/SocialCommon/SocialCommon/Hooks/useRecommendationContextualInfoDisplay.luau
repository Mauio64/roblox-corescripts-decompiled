local SocialCommon = script:FindFirstAncestor("SocialCommon")
local parent = SocialCommon.Parent

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local getRecommendationContextualInfoDisplay = require(SocialCommon.Utils.getRecommendationContextualInfoDisplay)
local FFlagShowClassmatesOnPYMK = require(parent.SharedFlags.FFlagShowClassmatesOnPYMK)

return function(recommendation)
	return getRecommendationContextualInfoDisplay({
		recommendation = recommendation,
		localized = useLocalization({
			singularMutualConnection = "Feature.Friends.Label.MutualFriendTitle",
			mutualConnections = {
				"Feature.Friends.Label.MutualFriendsTitle",
				numConnections = recommendation.mutualFriendsCount
			},
			frequents = "Feature.Friends.Label.Frequent",
			connectionRequests = "Feature.Friends.Label.FriendRequest",
			contacts = "Feature.Friends.Description.FromContacts",
			classmates = FFlagShowClassmatesOnPYMK and "Feature.Schools.Label.Classmates" or nil
		})
	})
end
