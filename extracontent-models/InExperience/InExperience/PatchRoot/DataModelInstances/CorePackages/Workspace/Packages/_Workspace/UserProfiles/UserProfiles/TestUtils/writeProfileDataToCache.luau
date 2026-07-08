local UserProfiles = script:FindFirstAncestor("UserProfiles")
local UserProfilesParent = UserProfiles.Parent
local Queries = require(UserProfiles.Common.Queries)
local Cryo = require(UserProfilesParent.Cryo)

require(UserProfilesParent.ApolloClient)

return function(p1, t1: {[any]: any}, t2: {[any]: any}?) -- line: 15
	-- upvalues: Queries (copy), Cryo (copy)
	local v8 = if not t2 or not t2.query then Queries.userProfilesAllNamesByUserIds else t2.query

	for v9, v10 in t1 do
		p1:writeQuery({
			variables = {
				userIds = v9
			},
			query = v8,
			data = {
				userProfiles = {{
					__typename = "UserProfile",
					id = v9,
					names = Cryo.Dictionary.join({
						__typename = "Names",
						alias = "",
						contactName = "",
						displayName = "",
						username = "",
						platformName = ""
					}, v10)
				}}
			}
		})
	end
end
