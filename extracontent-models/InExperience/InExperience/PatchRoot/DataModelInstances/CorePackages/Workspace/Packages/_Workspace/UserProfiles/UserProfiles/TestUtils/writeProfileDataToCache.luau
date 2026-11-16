local UserProfiles = script:FindFirstAncestor("UserProfiles")
local parent = UserProfiles.Parent
local Queries = require(UserProfiles.Common.Queries)
local Cryo = require(parent.Cryo)
require(parent.ApolloClient)

return function(object, items, p)
	local query

	if p and p.query then
		query = p.query
	else
		query = Queries.userProfilesAllNamesByUserIds
	end

	for k, item in items do
		object:writeQuery({
			variables = { userIds = k },
			query = query,
			data = {
				userProfiles = {
					{
						__typename = "UserProfile",
						id = k,
						platformProfileId = "",
						names = Cryo.Dictionary.join({
							__typename = "Names",
							alias = "",
							contactName = "",
							displayName = "",
							username = "",
							platformName = ""
						}, item)
					}
				}
			}
		})
	end
end
