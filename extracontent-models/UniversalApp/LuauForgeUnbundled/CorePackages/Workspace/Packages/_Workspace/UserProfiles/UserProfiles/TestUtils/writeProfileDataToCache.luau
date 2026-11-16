local Queries = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/UserProfiles/Common/Queries")
local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/Cryo")
require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/ApolloClient")

return function(object, items, p2)
	local v5 = if p2 and p2.query then p2.query else Queries.userProfilesAllNamesByUserIds

	for k, item in items do
		object:writeQuery({
			variables = { userIds = k },
			query = v5,
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
