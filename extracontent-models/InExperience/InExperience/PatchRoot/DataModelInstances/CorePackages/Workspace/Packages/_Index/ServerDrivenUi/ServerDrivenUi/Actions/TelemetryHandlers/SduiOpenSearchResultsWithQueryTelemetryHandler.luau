local ServerDrivenUi = script:FindFirstAncestor("ServerDrivenUi")
local ServerDrivenUiParent = ServerDrivenUi.Parent
local openSearchResultsWithQueryDeeplink = require(ServerDrivenUiParent.DiscoveryAnalytics).Events.openSearchResultsWithQueryDeeplink

require(ServerDrivenUiParent.SduiCoreSystem)

local openSearchResultsWithQueryParams = require(ServerDrivenUi.Actions.openSearchResultsWithQueryParams)

return function(p1, _, p3) -- line: 18
	-- upvalues: openSearchResultsWithQueryParams (copy), openSearchResultsWithQueryDeeplink (copy)
	local v8 = openSearchResultsWithQueryParams.resolveSearchQuery(p1)
	local v9 = openSearchResultsWithQueryParams.resolveSearchType(p1)

	if v8 == nil or v9 == nil then
		return
	end

	openSearchResultsWithQueryDeeplink(p3.appPage, {
		kwd = v8,
		searchType = v9
	})
end
