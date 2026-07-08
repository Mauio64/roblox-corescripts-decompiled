local SocialCommon = script:FindFirstAncestor("SocialCommon")
local SocialCommonParent = SocialCommon.Parent
local useLocalization = require(SocialCommonParent.Localization).Hooks.useLocalization
local getRecommendationContextualInfoDisplay = require(SocialCommon.Utils.getRecommendationContextualInfoDisplay)
local FFlagConnectionsToFriendsRename = require(SocialCommonParent.SharedFlags).FFlagConnectionsToFriendsRename

return function(t1: {[any]: any}) -- line: 31
	-- upvalues: useLocalization (copy), FFlagConnectionsToFriendsRename (copy), getRecommendationContextualInfoDisplay (copy)
	local v7 = useLocalization({
		frequents = "Feature.Friends.Label.Frequent",
		contacts = "Feature.Friends.Description.FromContacts",
		singularMutualConnection = not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.MutualConnection" or "Feature.Friends.Label.MutualFriendTitle",
		mutualConnections = {
			not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.MutualConnections" or "Feature.Friends.Label.MutualFriendsTitle",
			numConnections = t1.mutualFriendsCount
		},
		connectionRequests = not FFlagConnectionsToFriendsRename and "Feature.Friends.Label.ConnectionRequest" or "Feature.Friends.Label.FriendRequest"
	})

	return getRecommendationContextualInfoDisplay({
		recommendation = t1,
		localized = v7
	})
end
