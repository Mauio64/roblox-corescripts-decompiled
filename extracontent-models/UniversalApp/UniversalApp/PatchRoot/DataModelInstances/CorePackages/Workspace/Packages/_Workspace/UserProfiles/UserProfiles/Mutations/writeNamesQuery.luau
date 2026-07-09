local Parent = script:FindFirstAncestor("UserProfiles").Parent

require(Parent.ApolloClient)

return function(t1: {[any]: any}) -- line: 7
	local client = t1.client
	local query = t1.query
	local userId = t1.userId
	local names = t1.names
	local v7 = if names.alias == "" then if names.contactName == "" then if names.displayName == "" then names.username else names.displayName else names.contactName else names.alias

	client:writeQuery({
		variables = {
			userIds = { userId }
		},
		query = query,
		data = {
			userProfiles = {{
				__typename = "UserProfile",
				id = userId,
				names = {
					__typename = "Names",
					combinedName = v7,
					alias = names.alias,
					contactName = names.contactName,
					displayName = names.displayName,
					username = names.username
				}
			}}
		}
	})
end
