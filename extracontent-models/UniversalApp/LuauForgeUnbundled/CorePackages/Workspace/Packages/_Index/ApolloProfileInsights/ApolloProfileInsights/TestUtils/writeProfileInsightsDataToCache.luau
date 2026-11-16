local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloProfileInsights/Cryo")

local ApolloLocalState = require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloProfileInsights/ApolloLocalState")
require("@game/CorePackages/Workspace/Packages/_Workspace/ApolloProfileInsights/ApolloClient")
local queries = ApolloLocalState.queries

return function(object, items, p2)
	local v5 = if p2 and p2.query then p2.query else queries.profilesInsightsByUserIds

	for k, item in items do
		local values = {}

		for k2, v6 in item.mutualFriends or {} do
			table.insert(values, Cryo.Dictionary.join({
				__typename = "MutualFriend",
				id = v6.id or tostring(k2),
				username = v6.username or "",
				displayName = v6.displayName or ""
			}, v6))
		end

		object:writeQuery({
			variables = { userIds = k },
			query = v5,
			data = {
				profilesInsightsByUserIds = {
					{
						__typename = "ProfileInsights",
						targetUserId = item.targetUserId or tostring(k),
						isOfflineFrequents = item.isOfflineFrequents or false,
						mutualFriends = values,
						friendshipAgeUnixSeconds = item.friendshipAgeUnixSeconds or 0,
						friendRequestOriginSource = item.friendRequestOriginSource or 0,
						accountCreationDateUnixSeconds = item.accountCreationDateUnixSeconds or 0,
						localizedCountryName = item.localizedCountryName or "",
						userAgeVerifiedBracket = item.userAgeVerifiedBracket or ""
					}
				}
			}
		})
	end
end
