local UserSearch = script:FindFirstAncestor("UserSearch")
local parent = UserSearch.Parent

require(parent.React)
local usePaginatedProfileInsightsFetch = require(script.Parent.usePaginatedProfileInsightsFetch)
require(UserSearch.Common.LocalTypes)

return function(data)
	local v = usePaginatedProfileInsightsFetch({
		users = data.users or {},
		searchKeyword = data.searchParameters.searchKeyword
	}) or {}

	return data.renderComponent(v)
end
