local CorePackages = game:GetService("CorePackages")
local Rodux = require(CorePackages.Packages.Rodux)
local makeActionCreator = Rodux.makeActionCreator

require("@luauforge/bundled/dFh")

return makeActionCreator("AddUsersSearchResults", function(data)
	return {
		keyword = data.keyword,
		searchUuid = data.searchUuid,
		nextPageCursor = data.nextPageCursor,
		entries = data.entries,
		curPageCursor = data.curPageCursor,
		paginationMethod = data.paginationMethod
	}
end)
