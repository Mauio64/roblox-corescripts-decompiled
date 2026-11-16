local parent = script:FindFirstAncestor("UserProfiles").Parent

require(parent.ApolloClient)

return function(data)
	local client = data.client
	local query = data.query
	local userId = data.userId
	local names = data.names
	local combinedName

	if names.alias == "" then
		if names.contactName == "" then
			if names.displayName == "" then
				combinedName = names.username
			else
				combinedName = names.displayName
			end
		else
			combinedName = names.contactName
		end
	else
		combinedName = names.alias
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
						combinedName = combinedName,
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
