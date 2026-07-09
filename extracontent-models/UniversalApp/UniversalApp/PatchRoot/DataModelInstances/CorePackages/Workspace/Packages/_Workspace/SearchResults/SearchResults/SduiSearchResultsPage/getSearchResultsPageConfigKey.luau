local Parent = script:FindFirstAncestor("SearchResults").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage

local function getSearchResultsPageConfigKey(s1: string) -- line: 6
	-- upvalues: AppPage (copy)
	return AppPage.SearchPage .. "-" .. s1
end

return getSearchResultsPageConfigKey
