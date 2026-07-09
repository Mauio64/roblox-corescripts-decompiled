local ParentParent = script.Parent.Parent.Parent
local dependencies = require(ParentParent.dependencies)
local ParentParentParent = ParentParent.Parent
local React = dependencies.React
local useLocalization = require(ParentParentParent.Localization).Hooks.useLocalization
local getRecommendationContextualInfoDisplay = require(ParentParentParent.SocialCommon).Utils.getRecommendationContextualInfoDisplay

require(ParentParentParent.UserList)

local function useContextualInfo(t1: {[any]: any}) -- line: 29
	-- upvalues: useLocalization (copy), React (copy), getRecommendationContextualInfoDisplay (copy)
	local v9 = useLocalization({
		singularMutualConnection = "Feature.Friends.Label.OneMutual",
		frequents = "Feature.Friends.Label.Frequent",
		connectionRequests = "Feature.Friends.Label.Request",
		contacts = "Feature.Friends.Description.FromContacts",
		mutualConnections = {
			"Feature.Friends.Label.MultipleMutuals",
			numConnections = t1.recommendation.mutualFriendsCount
		}
	})

	return React.useMemo(function() -- line: 40
		-- upvalues: t1 (copy), getRecommendationContextualInfoDisplay (copy), v9 (copy)
		local t2 = {
			contextType = t1.recommendation.contextType,
			mutualFriendsList = t1.recommendation.mutualFriendsList,
			mutualFriendsCount = t1.recommendation.mutualFriendsCount,
			hasIncomingFriendRequest = t1.hasIncomingFriendRequest
		}

		return getRecommendationContextualInfoDisplay({
			recommendation = t2,
			localized = v9
		})
	end, {
		v9,
		t1.recommendation.contextType,
		t1.recommendation.mutualFriendsList,
		t1.recommendation.mutualFriendsCount,
		t1.hasIncomingFriendRequest
	})
end

return useContextualInfo
