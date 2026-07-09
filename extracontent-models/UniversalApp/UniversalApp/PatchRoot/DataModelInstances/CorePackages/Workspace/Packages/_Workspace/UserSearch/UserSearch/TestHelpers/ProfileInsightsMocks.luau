local UserSearch = script:FindFirstAncestor("UserSearch")
local UserSearchParent = UserSearch.Parent
local ProfilesInsightsQuery = require(UserSearch.Apollo.ProfilesInsightsQuery)

require(UserSearch.Common.LocalTypes)
require(UserSearchParent.ApolloClient)
require(UserSearchParent.GraphQLServer)

local FFlagPlayerSearchEnableOnlineFrequentsForAll = require(UserSearchParent.SharedFlags).FFlagPlayerSearchEnableOnlineFrequentsForAll
local v5 = ProfilesInsightsQuery.createPageId("test")
local t1 = {
	variables = {
		userIds = {
			"111",
			"222"
		},
		pageId = v5,
		rankingStrategy = if not FFlagPlayerSearchEnableOnlineFrequentsForAll then nil else "profile_info_boost"
	},
	query = ProfilesInsightsQuery.query,
	data = {
		profilesInsights = {
			__typename = "ProfileInsightsPages",
			id = v5,
			profileInsights = {
				{
					__typename = "ProfileInsights",
					targetUserId = "111",
					isOfflineFrequents = true,
					mutualFriends = {}
				},
				{
					__typename = "ProfileInsights",
					targetUserId = "222",
					isOfflineFrequents = true,
					mutualFriends = {}
				}
			}
		}
	}
}
local t2 = {
	variables = {
		userIds = {
			"333",
			"444"
		},
		pageId = v5,
		rankingStrategy = if not FFlagPlayerSearchEnableOnlineFrequentsForAll then nil else "profile_info_boost"
	},
	query = ProfilesInsightsQuery.query,
	data = {
		profilesInsights = {
			__typename = "ProfileInsightsPages",
			id = v5,
			profileInsights = {
				{
					__typename = "ProfileInsights",
					targetUserId = "333",
					isOfflineFrequents = true,
					mutualFriends = {}
				},
				{
					__typename = "ProfileInsights",
					targetUserId = "444",
					isOfflineFrequents = true,
					mutualFriends = {}
				}
			}
		}
	}
}
local t3 = {
	userInsights = {
		{
			targetUser = "111",
			profileInsights = {{
				mutualFriendInsight = {},
				offlineFrequentsInsight = {
					havePlayedTogether = true
				}
			}}
		},
		{
			targetUser = "222",
			profileInsights = {{
				mutualFriendInsight = {},
				offlineFrequentsInsight = {
					havePlayedTogether = true
				}
			}}
		}
	}
}
local t4 = {
	{
		id = "111"
	},
	{
		id = "222"
	}
}
local t5 = {
	{
		id = "111"
	},
	{
		id = "222"
	},
	{
		id = "333"
	},
	{
		id = "444"
	}
}

return {
	mockProfileInsight = function(p1) -- line: 16
		return {
			__typename = "ProfileInsights",
			isOfflineFrequents = true,
			targetUserId = p1,
			mutualFriends = {}
		}
	end,
	mockProfileInsightWithMutualFriends = function(p2) -- line: 25
		return {
			__typename = "ProfileInsights",
			isOfflineFrequents = true,
			friendshipAgeUnixSeconds = 0,
			friendRequestOriginSource = 0,
			accountCreationDateUnixSeconds = 0,
			localizedCountryName = "test",
			userAgeVerifiedBracket = "",
			targetUserId = p2,
			mutualFriends = {{
				__typename = "MutualFriend",
				id = "234",
				username = "mockedUsername",
				displayName = "mockedDisplayName"
			}}
		}
	end,
	twoEntries = {
		searchKeyword = "test",
		users = t4,
		userIds = {
			"111",
			"222"
		},
		pageId = v5,
		response = t3,
		query = t1,
		usersMore = t5,
		queryMore = t2,
		userIdsMore = {
			"333",
			"444"
		}
	}
}
