require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/ApolloClient")

return function(data)
	local client = data.client
	local query = data.query
	local userId = data.userId
	local names = data.names
	local v5

	if names.alias == "" then
		if names.contactName == "" then
			v5 = if names.displayName == "" then names.username else names.displayName
		else
			v5 = names.contactName
		end
	else
		v5 = names.alias
	end

	client:writeQuery({
		variables = {
			userIds = { userId }
		},
		query = query,
		data = {
			userProfiles = {
				{
					__typename = "UserProfile",
					id = userId,
					names = {
						__typename = "Names",
						combinedName = v5,
						alias = names.alias,
						contactName = names.contactName,
						displayName = names.displayName,
						username = names.username
					}
				}
			}
		}
	})
end
