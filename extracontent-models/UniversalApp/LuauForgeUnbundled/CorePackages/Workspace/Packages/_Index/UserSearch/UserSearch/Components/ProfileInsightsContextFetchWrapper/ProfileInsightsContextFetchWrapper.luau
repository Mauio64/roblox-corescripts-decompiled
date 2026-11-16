require("@game/CorePackages/Workspace/Packages/_Workspace/UserSearch/React")
local usePaginatedProfileInsightsFetch = require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Components/ProfileInsightsContextFetchWrapper/usePaginatedProfileInsightsFetch")
require("@game/CorePackages/Workspace/Packages/_Index/UserSearch/UserSearch/Common/LocalTypes")

return function(data)
	local v5 = usePaginatedProfileInsightsFetch({
		users = data.users or {},
		searchKeyword = data.searchParameters.searchKeyword
	}) or {}

	return data.renderComponent(v5)
end
