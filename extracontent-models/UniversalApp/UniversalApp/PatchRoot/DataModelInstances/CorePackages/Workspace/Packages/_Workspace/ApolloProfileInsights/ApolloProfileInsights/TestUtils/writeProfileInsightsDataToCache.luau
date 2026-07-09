local Parent = script:FindFirstAncestor("ApolloProfileInsights").Parent
local Cryo = require(Parent.Cryo)
local ApolloLocalState = require(Parent.ApolloLocalState)

require(Parent.ApolloClient)

local queries = ApolloLocalState.queries

return function(p1, t1: {[any]: any}, t2: {[any]: any}?) -- line: 27
	-- upvalues: queries (copy), Cryo (copy)
	local v8 = if not t2 or not t2.query then queries.profilesInsightsByUserIds else t2.query

	for v9, v10 in t1 do
		local t3 = {}

		for v12, v13 in v10.mutualFriends or {} do
			table.insert(t3, Cryo.Dictionary.join({
				__typename = "MutualFriend",
				id = v13.id or tostring(v12),
				username = v13.username or "",
				displayName = v13.displayName or ""
			}, v13))
		end

		p1:writeQuery({
			variables = {
				userIds = v9
			},
			query = v8,
			data = {
				profilesInsightsByUserIds = {{
					__typename = "ProfileInsights",
					targetUserId = v10.targetUserId or tostring(v9),
					isOfflineFrequents = v10.isOfflineFrequents or false,
					mutualFriends = t3,
					friendshipAgeUnixSeconds = v10.friendshipAgeUnixSeconds or 0,
					friendRequestOriginSource = v10.friendRequestOriginSource or 0,
					accountCreationDateUnixSeconds = v10.accountCreationDateUnixSeconds or 0,
					localizedCountryName = v10.localizedCountryName or "",
					userAgeVerifiedBracket = v10.userAgeVerifiedBracket or ""
				}}
			}
		})
	end
end
