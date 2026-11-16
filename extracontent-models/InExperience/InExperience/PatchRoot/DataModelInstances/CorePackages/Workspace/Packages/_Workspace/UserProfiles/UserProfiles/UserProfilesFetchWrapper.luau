local parent = script:FindFirstAncestor("UserProfiles").Parent

require(parent.ApolloClient)
require(parent.React)

local Hooks = require(script.Parent.Hooks)
local useUserProfilesFetch = Hooks.useUserProfilesFetch

return function(data)
	local v = useUserProfilesFetch({ userIds = data.userIds, query = data.query })

	return data.renderComponent(v)
end
