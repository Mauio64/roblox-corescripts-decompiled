local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/Localization").Hooks.useLocalization

local getRecommendationContextualInfoDisplay = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SocialCommon/Utils/getRecommendationContextualInfoDisplay")
local FFlagShowClassmatesOnPYMK = require("@game/CorePackages/Workspace/Packages/_Workspace/SocialCommon/SharedFlags/FFlagShowClassmatesOnPYMK")

return function(p2)
	return getRecommendationContextualInfoDisplay({
		recommendation = p2,
		localized = useLocalization({
			singularMutualConnection = "Feature.Friends.Label.MutualFriendTitle",
			mutualConnections = {
				"Feature.Friends.Label.MutualFriendsTitle",
				numConnections = p2.mutualFriendsCount
			},
			frequents = "Feature.Friends.Label.Frequent",
			connectionRequests = "Feature.Friends.Label.FriendRequest",
			contacts = "Feature.Friends.Description.FromContacts",
			classmates = FFlagShowClassmatesOnPYMK and "Feature.Schools.Label.Classmates" or nil
		})
	})
end
