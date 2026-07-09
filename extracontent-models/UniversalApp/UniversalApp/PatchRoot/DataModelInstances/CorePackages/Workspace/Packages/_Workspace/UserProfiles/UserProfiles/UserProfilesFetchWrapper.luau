local Parent = script:FindFirstAncestor("UserProfiles").Parent

require(Parent.ApolloClient)
require(Parent.React)

local useUserProfilesFetch = require(script.Parent.Hooks).useUserProfilesFetch

return function(t1: {[any]: any}) -- line: 15
	-- upvalues: useUserProfilesFetch (copy)
	local v4 = useUserProfilesFetch({
		userIds = t1.userIds,
		query = t1.query
	})

	return t1.renderComponent(v4)
end
