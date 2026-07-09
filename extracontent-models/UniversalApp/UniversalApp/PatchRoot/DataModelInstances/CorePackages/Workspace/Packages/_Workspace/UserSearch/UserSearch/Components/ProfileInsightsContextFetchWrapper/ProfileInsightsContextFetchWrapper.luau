local UserSearch = script:FindFirstAncestor("UserSearch")
local UserSearchParent = UserSearch.Parent

require(UserSearchParent.React)

local usePaginatedProfileInsightsFetch = require(script.Parent.usePaginatedProfileInsightsFetch)

require(UserSearch.Common.LocalTypes)

return function(t1: {[any]: any}) -- line: 17
	-- upvalues: usePaginatedProfileInsightsFetch (copy)
	local v5 = usePaginatedProfileInsightsFetch({
		users = t1.users or {},
		searchKeyword = t1.searchParameters.searchKeyword
	}) or {}

	return t1.renderComponent(v5)
end
