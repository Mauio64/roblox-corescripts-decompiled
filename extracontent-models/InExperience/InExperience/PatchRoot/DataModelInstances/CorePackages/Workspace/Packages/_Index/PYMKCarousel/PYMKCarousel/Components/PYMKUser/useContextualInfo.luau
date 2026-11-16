local parent = script.Parent.Parent.Parent
local dependencies = require(parent.dependencies)
local parent2 = parent.Parent

local react = dependencies.React
local Localization = require(parent2.Localization)
local useLocalization = Localization.Hooks.useLocalization
local SocialCommon = require(parent2.SocialCommon)
local getRecommendationContextualInfoDisplay = SocialCommon.Utils.getRecommendationContextualInfoDisplay
local FFlagShowClassmatesOnPYMK = require(parent2.SharedFlags.FFlagShowClassmatesOnPYMK)

require(parent2.UserList)

local function useContextualInfo(p)
	local localized = useLocalization({
		singularMutualConnection = "Feature.Friends.Label.OneMutual",
		mutualConnections = {
			"Feature.Friends.Label.MultipleMutuals",
			numConnections = p.recommendation.mutualFriendsCount
		},
		frequents = "Feature.Friends.Label.Frequent",
		connectionRequests = "Feature.Friends.Label.Request",
		contacts = "Feature.Friends.Description.FromContacts",
		classmates = FFlagShowClassmatesOnPYMK and "Feature.Schools.Label.Classmates" or nil
	})

	return react.useMemo(function()
		return getRecommendationContextualInfoDisplay({
			recommendation = {
				contextType = p.recommendation.contextType,
				mutualFriendsList = p.recommendation.mutualFriendsList,
				mutualFriendsCount = p.recommendation.mutualFriendsCount,
				hasIncomingFriendRequest = p.hasIncomingFriendRequest
			},
			localized = localized
		})
	end, {
		localized,
		p.recommendation.contextType,
		p.recommendation.mutualFriendsList,
		p.recommendation.mutualFriendsCount,
		p.hasIncomingFriendRequest
	})
end

return useContextualInfo
