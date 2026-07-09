local Parent = script:FindFirstAncestor("SearchResults").Parent
local AppPage = require(Parent.RobloxAppEnums).AppPage
local SduiLoadTimer = require(Parent.SduiSharedUtilities).SduiLoadTimer
local fetchSearchResultsPageIfNeeded = require(script.Parent.fetchSearchResultsPageIfNeeded)

local function navigateToSearchResults(s1: string, s2: string, s3: string, p1: ((...any) -> ...any)) -- line: 25
	-- upvalues: SduiLoadTimer (copy), AppPage (copy), fetchSearchResultsPageIfNeeded (copy)
	if s1 ~= nil and s1 ~= "" then
		local v10 = SduiLoadTimer.createLoadTimer(AppPage.SearchPage)

		v10.start("navigate")
		fetchSearchResultsPageIfNeeded(s1, s2, s3, v10)
	end

	p1()
end

return navigateToSearchResults
