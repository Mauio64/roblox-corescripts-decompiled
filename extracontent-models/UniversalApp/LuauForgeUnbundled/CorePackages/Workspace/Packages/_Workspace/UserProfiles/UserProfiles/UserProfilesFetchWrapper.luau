require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/ApolloClient")
require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/React")

local useUserProfilesFetch = require("@game/CorePackages/Workspace/Packages/_Workspace/UserProfiles/UserProfiles/Hooks").useUserProfilesFetch

return function(data)
	local v5 = useUserProfilesFetch({ userIds = data.userIds, query = data.query })

	return data.renderComponent(v5)
end
