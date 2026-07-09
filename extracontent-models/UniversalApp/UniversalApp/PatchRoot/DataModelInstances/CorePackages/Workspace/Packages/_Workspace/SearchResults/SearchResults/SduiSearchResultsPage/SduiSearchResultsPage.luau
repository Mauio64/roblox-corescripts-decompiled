local Parent = script:FindFirstAncestor("SearchResults").Parent
local React = require(Parent.React)
local SduiSharedUtilities = require(Parent.SduiSharedUtilities)
local SduiPageEntryPoint = SduiSharedUtilities.SduiPageEntryPoint
local SduiLoadTimer = SduiSharedUtilities.SduiLoadTimer
local AppPage = require(Parent.RobloxAppEnums).AppPage
local CompositionTags = require(Parent.AppComposition).CompositionTags
local fetchSearchResultsPageIfNeeded = require(script.Parent.fetchSearchResultsPageIfNeeded)
local getSearchResultsPageConfigKey = require(script.Parent.getSearchResultsPageConfigKey)
local SearchPage = AppPage.SearchPage

local function SduiSearchResultsPage(t1: {[any]: any}) -- line: 24
	-- upvalues: getSearchResultsPageConfigKey (copy), React (copy), SduiLoadTimer (copy), SearchPage (copy), fetchSearchResultsPageIfNeeded (copy), SduiPageEntryPoint (copy), CompositionTags (copy)
	local searchKeyword = t1.searchKeyword
	local searchUuid = t1.searchUuid
	local globalSessionId = t1.globalSessionId
	local pageTopPadding = t1.pageTopPadding
	local v17 = getSearchResultsPageConfigKey(searchUuid)
	local v18 = React.useMemo(function() -- line: 31
		-- upvalues: SduiLoadTimer (copy), SearchPage (copy)
		return SduiLoadTimer.createLoadTimer(SearchPage)
	end, { v17 })

	React.useEffect(function() -- line: 35
		-- upvalues: searchKeyword (copy), fetchSearchResultsPageIfNeeded (copy), searchUuid (copy), globalSessionId (copy), v18 (copy)
		if searchKeyword and searchKeyword ~= "" then
			fetchSearchResultsPageIfNeeded(searchKeyword, searchUuid, globalSessionId, v18)
		end
	end, {
		searchKeyword,
		searchUuid,
		globalSessionId,
		v18
	})

	local v19 = React.useCallback(function() -- line: 41
		-- upvalues: searchKeyword (copy), SduiLoadTimer (copy), SearchPage (copy), fetchSearchResultsPageIfNeeded (copy), searchUuid (copy), globalSessionId (copy)
		if searchKeyword and searchKeyword ~= "" then
			local v20 = SduiLoadTimer.createLoadTimer(SearchPage)

			v20.start("refresh")
			fetchSearchResultsPageIfNeeded(searchKeyword, searchUuid, globalSessionId, v20, true)
		end
	end, {
		searchKeyword,
		searchUuid,
		globalSessionId
	})

	if not searchKeyword or searchKeyword == "" then
		return nil
	end

	return React.createElement(SduiPageEntryPoint, {
		includeNavigationHeaderBar = false,
		appPage = SearchPage,
		configKey = v17,
		pageTimer = v18,
		refresh = v19,
		contentTag = CompositionTags.ContentRegion.Body,
		pageTopPadding = pageTopPadding
	})
end

return React.memo(SduiSearchResultsPage)
