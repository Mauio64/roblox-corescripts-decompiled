local react = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/PYMKCarousel/dependencies").React
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/Localization").Hooks.useLocalization
local getRecommendationContextualInfoDisplay = require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/SocialCommon").Utils.getRecommendationContextualInfoDisplay
local FFlagShowClassmatesOnPYMK = require("@game/CorePackages/Workspace/Packages/_Index/PYMKCarousel/SharedFlags/FFlagShowClassmatesOnPYMK")

require("@game/CorePackages/Workspace/Packages/_Workspace/PYMKCarousel/UserList")

local function useContextualInfo(p2)
	local v5 = useLocalization({
		singularMutualConnection = "Feature.Friends.Label.OneMutual",
		mutualConnections = {
			"Feature.Friends.Label.MultipleMutuals",
			numConnections = p2.recommendation.mutualFriendsCount
		},
		frequents = "Feature.Friends.Label.Frequent",
		connectionRequests = "Feature.Friends.Label.Request",
		contacts = "Feature.Friends.Description.FromContacts",
		classmates = FFlagShowClassmatesOnPYMK and "Feature.Schools.Label.Classmates" or nil
	})

	return react.useMemo(function()
		return getRecommendationContextualInfoDisplay({
			recommendation = {
				contextType = p2.recommendation.contextType,
				mutualFriendsList = p2.recommendation.mutualFriendsList,
				mutualFriendsCount = p2.recommendation.mutualFriendsCount,
				hasIncomingFriendRequest = p2.hasIncomingFriendRequest
			},
			localized = v5
		})
	end, {
		v5,
		p2.recommendation.contextType,
		p2.recommendation.mutualFriendsList,
		p2.recommendation.mutualFriendsCount,
		p2.hasIncomingFriendRequest
	})
end

return useContextualInfo
