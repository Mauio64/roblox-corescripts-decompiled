local AvatarExperienceSearch = script:FindFirstAncestor("AvatarExperienceSearch")
local AvatarExperienceSearchParent = AvatarExperienceSearch.Parent
local React = require(AvatarExperienceSearchParent.React)
local FFlagRenameDeprecatedUIBloxTokens = require(AvatarExperienceSearchParent.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local Dash = require(AvatarExperienceSearchParent.Dash)
local DeviceOrientationMode = require(AvatarExperienceSearchParent.RobloxAppEnums).DeviceOrientationMode
local wasLastInputGamepad = require(AvatarExperienceSearchParent.RoactUtils).wasLastInputGamepad
local IxpUtils = require(AvatarExperienceSearchParent.IxpUtils)
local AXCommon = require(AvatarExperienceSearchParent.AXCommon)
local debounce = require(AvatarExperienceSearch.Utils.debounce)
local normalizeKeyword = require(AvatarExperienceSearch.Utils.normalizeKeyword)
local RecentSearchTermsAppStorage = require(AvatarExperienceSearch.Utils.RecentSearchTermsAppStorage)
local Counter = require(AvatarExperienceSearch.Enums.Counter)
local Stat = require(AvatarExperienceSearch.Enums.Stat)
local SuggestedItemTypeEnum = require(AvatarExperienceSearch.Enums.SuggestedItemTypeEnum)

require(AvatarExperienceSearch.Components.SuggestedItemList)
require(AvatarExperienceSearch.Components.SuggestedItem)
require(script.Parent.SearchLandingPage)
require(AvatarExperienceSearch.Store.Types)

local useRecentlyViewedSearchItemsWidgetProps = require(AvatarExperienceSearch.Features.RecentlyViewedSearchItemsWidget.useRecentlyViewedSearchItemsWidgetProps)
local useDesignTokens = require(AvatarExperienceSearchParent.Style).useDesignTokens
local GetFIntAXSearchAutocompleteDebounceMs = require(AvatarExperienceSearch.Flags.GetFIntAXSearchAutocompleteDebounceMs)
local GetFIntAXMaxAutocompleteSearchTextLen = require(AvatarExperienceSearch.Flags.GetFIntAXMaxAutocompleteSearchTextLen)
local AXRecentlyViewedSearchItemsIXPTest = AXCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest
local v21 = game:DefineFastFlag("AXMigrateSearchLandingPageToFocusNavigation", false)

local function getRecentSearchTerms(s1: string) -- line: 39
	-- upvalues: RecentSearchTermsAppStorage (copy), SuggestedItemTypeEnum (copy)
	local t1 = {}

	for _, v30 in (RecentSearchTermsAppStorage.findTermsForQuery(s1)) do
		table.insert(t1, {
			text = v30,
			type = SuggestedItemTypeEnum.Recent
		})
	end

	return t1
end
local function getAutocompleteTermsForQueryFromState(s2: string, p1) -- line: 54
	-- upvalues: normalizeKeyword (copy)
	local v33 = p1[normalizeKeyword(s2)]
	local t2 = {}

	if v33 and v33.entries then
		for _, v36 in v33.entries do
			table.insert(t2, v36.searchQuery)
		end
	end

	return t2
end
local function getAutocompleteTerms(s3: string, p2) -- line: 69
	-- upvalues: RecentSearchTermsAppStorage (copy), getAutocompleteTermsForQueryFromState (copy), SuggestedItemTypeEnum (copy)
	local t3 = {}

	for _, v41 in (RecentSearchTermsAppStorage.findTermsForQuery(s3)) do
		t3[v41:lower()] = true
	end

	local t4 = {}

	for _, v44 in (getAutocompleteTermsForQueryFromState(s3, p2)) do
		if not t3[v44:lower()] then
			table.insert(t4, {
				text = v44,
				type = SuggestedItemTypeEnum.Autocomplete
			})
		end
	end

	return t4
end

local v25 = debounce(function(s4: string, p3: ((...any) -> ...any)) -- line: 99
	if p3 then
		p3(s4)
	end
end, GetFIntAXSearchAutocompleteDebounceMs() / 1000)

local function useSearchLandingPageProps(p4) -- line: 134
	-- upvalues: useDesignTokens (copy), React (copy), RecentSearchTermsAppStorage (copy), AXRecentlyViewedSearchItemsIXPTest (copy), IxpUtils (copy), DeviceOrientationMode (copy), Counter (copy), v21 (copy), wasLastInputGamepad (copy), normalizeKeyword (copy), GetFIntAXMaxAutocompleteSearchTextLen (copy), v25 (copy), Dash (copy), Stat (copy), SuggestedItemTypeEnum (copy), getRecentSearchTerms (copy), getAutocompleteTerms (copy), useRecentlyViewedSearchItemsWidgetProps (copy), FFlagRenameDeprecatedUIBloxTokens (copy)
	local v48 = useDesignTokens()
	local v49, v50 = React.useState(RecentSearchTermsAppStorage.getTerms())
	local v51, v52 = React.useState("")
	local v53 = React.useRef(os.clock())
	local u54 = nil

	if AXRecentlyViewedSearchItemsIXPTest.isEnabled() then
		u54 = IxpUtils.readTestVariable(AXRecentlyViewedSearchItemsIXPTest.EnabledForUser)
	end

	local v55 = React.useCallback(function(s5: string) -- line: 152
		-- upvalues: p4 (copy)
		local v67 = s5:lower()
		local v68 = p4.autocompleteState and p4.autocompleteState[v67]

		if v68 and v68.expirationTime then
			return tick() < v68.expirationTime
		end

		return false
	end, { p4.autocompleteState })
	local v56 = React.useCallback(function(s6: string) -- line: 162
		-- upvalues: p4 (copy), DeviceOrientationMode (copy)
		local v70 = p4.createSearchUuid()
		local t5 = {
			isKeywordSuggestionEnabled = true,
			searchKeyword = s6
		}

		p4.setSearchType(v70)
		p4.setSearchParameters(v70, t5)

		if p4.deviceOrientation == DeviceOrientationMode.Portrait then
			p4.setFullView()
		end

		p4.navigateToSearch(v70, t5)
	end, {
		p4.createSearchUuid,
		p4.setSearchType,
		p4.setSearchParameters,
		p4.setFullView,
		p4.deviceOrientation,
		p4.navigateToSearch
	})
	local v57 = React.useCallback(function(s7: string, n1: number?) -- line: 188
		-- upvalues: p4 (copy), Counter (copy), v50 (copy), RecentSearchTermsAppStorage (copy), v21 (copy), wasLastInputGamepad (copy)
		if p4.sendCounter then
			p4.sendCounter(Counter.SearchRecentTermRemoved)

			if n1 then
				local v74 = Counter.SearchRecentTermRemovedPosPrefix .. n1

				p4.sendCounter(v74)
			end
		end

		v50(RecentSearchTermsAppStorage.removeTerm(s7))

		if not v21 and wasLastInputGamepad() then
			p4.focusController.moveFocusTo(p4.searchBarRef)
		end
	end, {
		if not v21 then p4.focusController else nil,
		p4.searchBarRef,
		p4.sendCounter
	})
	local v58 = React.useCallback(function(s8: string) -- line: 215
		-- upvalues: v52 (copy), p4 (copy), normalizeKeyword (copy), GetFIntAXMaxAutocompleteSearchTextLen (copy), v55 (copy), v25 (copy)
		v52(s8)

		if p4.searchTelemetry then
			p4.searchTelemetry.updateQuery(s8)
		end

		local v76 = normalizeKeyword(s8, true)

		if not v76 or v76 == "" or #v76 > GetFIntAXMaxAutocompleteSearchTextLen() or v55(v76) then
			return
		end

		v25(v76, p4.fetchAutocompleteSuggestions)
	end, {
		p4.autocompleteState,
		p4.fetchAutocompleteSuggestions,
		v55,
		p4.searchTelemetry
	})
	local v59 = React.useCallback(function(s9: string) -- line: 245
		-- upvalues: Dash (copy), p4 (copy), Counter (copy), v53 (copy), Stat (copy), RecentSearchTermsAppStorage (copy), v56 (copy)
		if not s9 or Dash.trim(s9) == "" then
			if p4.sendCounter then
				p4.sendCounter(Counter.SearchSubmitNoQuery)
			end

			return
		end

		if p4.sendCounter then
			p4.sendCounter(Counter.SearchSubmit)

			local v78 = (os.clock() - v53.current) * 1000

			if p4.sendStats then
				p4.sendStats(Stat.SearchTimeToSearchMs, v78)
			end
		end

		RecentSearchTermsAppStorage.addTerm(s9)
		v56(s9)
	end, {
		v56,
		p4.sendCounter
	})
	local v60 = React.useCallback(function() -- line: 267
		-- upvalues: p4 (copy), Counter (copy)
		if p4.sendCounter then
			p4.sendCounter(Counter.SearchCancel)
		end

		if p4.navigation then
			p4.navigation.goBack()
		end
	end, {
		p4.navigation,
		p4.sendCounter
	})
	local v61 = React.useCallback(function(s10: string) -- line: 278
		-- upvalues: v52 (copy), p4 (copy), Counter (copy)
		v52("")

		if p4.searchTelemetry then
			p4.searchTelemetry.sendClearEvent(s10)
		end

		if p4.sendCounter then
			p4.sendCounter(Counter.SearchClear)
		end
	end, {
		p4.sendCounter,
		p4.searchTelemetry
	})
	local v62 = React.useCallback(function(s11: string, p5, n2: number) -- line: 294
		-- upvalues: p4 (copy), SuggestedItemTypeEnum (copy), Counter (copy), v51 (copy), v59 (copy)
		if p4.sendCounter then
			local v83 = if p5 ~= SuggestedItemTypeEnum.Recent then Counter.SearchAutocompleteTermSelected else Counter.SearchRecentTermSelected

			p4.sendCounter(v83)

			if p5 == SuggestedItemTypeEnum.Recent and v51 == "" or v51 == nil then
				p4.sendCounter(Counter.SearchRecentTermSelectedNoQuery)
			end

			local v84 = Counter.SearchSuggestedTermSelectedPosPrefix .. n2

			p4.sendCounter(v84)
		end

		if p4.searchTelemetry and p5 == SuggestedItemTypeEnum.Autocomplete then
			p4.searchTelemetry.sendAutocompleteTermClickedEvent(v51, s11)
		end

		v59(s11)
	end, {
		v59,
		p4.sendCounter,
		v51,
		p4.searchTelemetry
	})
	local v63 = React.useMemo(function() -- line: 324
		-- upvalues: getRecentSearchTerms (copy), v51 (copy), p4 (copy), getAutocompleteTerms (copy), v62 (copy), SuggestedItemTypeEnum (copy), v57 (copy), AXRecentlyViewedSearchItemsIXPTest (copy), u54 (ref), Dash (copy)
		local v85 = getRecentSearchTerms(v51)
		local v86 = if not p4.autocompleteState then {} else getAutocompleteTerms(v51, p4.autocompleteState)
		local t6 = {}

		for _, v89 in v85 do
			table.insert(t6, v89)
		end

		for _, v91 in v86 do
			table.insert(t6, v91)
		end

		for v92, v93 in t6 do
			function v93.onActivate() -- line: 342
				-- upvalues: v62 (copy), v93 (copy), v92 (copy)
				v62(v93.text, v93.type, v92)
			end

			if v93.type == SuggestedItemTypeEnum.Recent then
				function v93.onRemove() -- line: 347
					-- upvalues: v57 (copy), v93 (copy), v92 (copy)
					v57(v93.text, v92)
				end
			end
		end

		if AXRecentlyViewedSearchItemsIXPTest.isEnabled() and u54 and v51 == "" then
			return Dash.slice(t6, 1, 5)
		end

		return t6
	end, {
		v51,
		v49,
		p4.autocompleteState,
		v62,
		v57
	})
	local v64 = #v63 == 0 and v51 == ""
	local v65 = nil

	if AXRecentlyViewedSearchItemsIXPTest.isEnabled() then
		IxpUtils.logExperimentExposure(AXRecentlyViewedSearchItemsIXPTest)

		if u54 then
			v65 = useRecentlyViewedSearchItemsWidgetProps({
				fetchSearchRecentlyViewed = p4.fetchSearchRecentlyViewed,
				toggleTryOn = p4.toggleTryOn,
				catalogAnalytics = p4.catalogAnalytics
			})
			v64 = v64 and #v65.items == 0
		end
	end

	return {
		padding = {
			top = p4.statusBarHeight or 0,
			left = if not AXRecentlyViewedSearchItemsIXPTest.isEnabled() then if not FFlagRenameDeprecatedUIBloxTokens then v48.Global.Space_150 else v48.Size.Size_300 else nil,
			right = if not AXRecentlyViewedSearchItemsIXPTest.isEnabled() then if not FFlagRenameDeprecatedUIBloxTokens then v48.Global.Space_150 else v48.Size.Size_300 else nil
		},
		onCancelSearch = v60,
		onChangeSearchQuery = v58,
		onSubmitSearch = v59,
		onClearSearch = v61,
		shouldShowEmptyState = v64,
		hasQuery = if not AXRecentlyViewedSearchItemsIXPTest.isEnabled() then nil else v51 ~= "",
		searchBarRef = p4.searchBarRef,
		firstSuggestedItemRef = p4.firstSuggestedItemRef,
		suggestedSearchTerms = v63,
		recentlyViewedItems = if not AXRecentlyViewedSearchItemsIXPTest.isEnabled() or not v65 then nil else v65.items
	}
end

return useSearchLandingPageProps
