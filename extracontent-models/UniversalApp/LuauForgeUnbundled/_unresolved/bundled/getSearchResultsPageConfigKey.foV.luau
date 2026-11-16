local appPage = require("@luauforge/bundled/foN").AppPage

local function getSearchResultsPageConfigKey(p2)
	return appPage.SearchPage .. "-" .. p2
end

return getSearchResultsPageConfigKey
