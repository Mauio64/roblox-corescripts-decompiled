local React = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/React")
local GroupsAnalyticsContext = require("@game/CorePackages/Workspace/Packages/_Workspace/Groups/Groups/Analytics/GroupsAnalyticsContext")

local function useGroupsAnalytics()
	return React.useContext(GroupsAnalyticsContext)
end

return useGroupsAnalytics
