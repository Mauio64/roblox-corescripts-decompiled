local parent = script:FindFirstAncestor("ApolloProfileInsights").Parent

local Cryo = require(parent.Cryo)

local ApolloLocalState = require(parent.ApolloLocalState)
require(parent.ApolloClient)
local queries = ApolloLocalState.queries

return function(object, items, p)
	local query

	if p and p.query then
		query = p.query
	else
		query = queries.profilesInsightsByUserIds
	end

	for k, item in items do
		local values = {}

		for k2, v in item.mutualFriends or {} do
			table.insert(values, Cryo.Dictionary.join({
				__typename = "MutualFriend",
				id = v.id or tostring(k2),
				username = v.username or "",
				displayName = v.displayName or ""
			}, v))
		end

		object:writeQuery({
			variables = { userIds = k },
			query = query,
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
