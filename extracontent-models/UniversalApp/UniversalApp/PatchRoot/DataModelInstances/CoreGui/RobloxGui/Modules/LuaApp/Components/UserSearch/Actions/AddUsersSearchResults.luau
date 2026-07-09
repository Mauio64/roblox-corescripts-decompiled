local CorePackages = game:GetService("CorePackages")
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator

require(script.Parent.Parent.Models.UserSearchEntry)

return makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 15
	return {
		keyword = t1.keyword,
		searchUuid = t1.searchUuid,
		nextPageCursor = t1.nextPageCursor,
		entries = t1.entries,
		curPageCursor = t1.curPageCursor,
		paginationMethod = t1.paginationMethod
	}
end)
