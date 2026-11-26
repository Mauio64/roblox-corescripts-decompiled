local React = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/React")

local module2 = require("@luauforge/bundled/fxw")
local deviceOrientationMode = require("@luauforge/bundled/fyo").DeviceOrientationMode
local wasLastInputGamepad = require("@luauforge/bundled/fxt").wasLastInputGamepad
local module3 = require("@luauforge/bundled/fxJ")
local module4 = require("@luauforge/bundled/fxu")

local module5 = require("@luauforge/bundled/fyp")
local module6 = require("@luauforge/bundled/fyq")
local module7 = require("@luauforge/bundled/fyr")

local module8 = require("@luauforge/bundled/fxV")
local module9 = require("@luauforge/bundled/fyv")
local module10 = require("@luauforge/bundled/fxF")
require("@luauforge/bundled/fxD")
require("@luauforge/bundled/fxE")
require("@luauforge/bundled/fxA")
require("@luauforge/bundled/fyw")

local module11 = require("@luauforge/bundled/fxT")

local useDesignTokens = require("@game/CorePackages/Workspace/Packages/_Workspace/BulkPurchaseApp/Style").useDesignTokens

local module12 = require("@luauforge/bundled/fyx")
local module13 = require("@luauforge/bundled/fxC")
local axRecentlyViewedSearchItemsIXPTest = module4.Experiments.AXRecentlyViewedSearchItemsIXPTest

local defineFastFlag = game:DefineFastFlag("AXMigrateSearchLandingPageToFocusNavigation", false)
local fFlagAXSearchAndCancelLogging = require("@luauforge/bundled/fxm").FFlagAXSearchAndCancelLogging
local fFlagAXUnifiedAutocompleteEndpoint = require("@luauforge/bundled/fxm").FFlagAXUnifiedAutocompleteEndpoint
local module14 = require("@luauforge/bundled/fys")
local module15 = require("@luauforge/bundled/fye")
local sendUnifiedEventLog = module15.sendUnifiedEventLog
local unifiedEventLogEnums = module15.UnifiedEventLogEnums
local unifiedLoggingElementNameEnums = module15.Enums.UnifiedLoggingElementNameEnums
local unifiedLoggingSurface = require("@luauforge/bundled/fxN").Enums.UnifiedLoggingSurface

local function getRecentSearchTerms(state)
	local termsForQuery = module7.findTermsForQuery(state)
	local recentSearchTerms = {}

	for k, v5 in termsForQuery do
		table.insert(recentSearchTerms, { text = v5, type = module10.Recent })
	end

	return recentSearchTerms
end

local function getAutocompleteTermsForQueryFromState(p2, p3)
	local v5 = if fFlagAXUnifiedAutocompleteEndpoint then module14(p2) or "" else module6(p2)
	local v6 = p3[v5]
	local searchQueries = {}

	if v6 and v6.entries then
		for k, entry in v6.entries do
			table.insert(searchQueries, entry.searchQuery)
		end
	end

	return searchQueries
end

local function getAutocompleteTerms(state, autocompleteState)
	local termsForQuery = module7.findTermsForQuery(state)
	local set = {}

	for k, v5 in termsForQuery do
		set[v5:lower()] = true
	end

	local autocompleteTermsForQueryFromState = getAutocompleteTermsForQueryFromState(
		state,
		autocompleteState
	)
	local autocompleteTerms = {}

	for k, v5 in autocompleteTermsForQueryFromState do
		if not set[v5:lower()] then
			table.insert(autocompleteTerms, { text = v5, type = module10.Autocomplete })
		end
	end

	return autocompleteTerms
end

local v5 = module5(function(p2, callback)
	if callback then
		callback(p2)
	end
end, 0.1)

local function useSearchLandingPageProps(data)
	local v6 = useDesignTokens()

	local state, setState = React.useState(module7.getTerms())
	local state2, setState2 = React.useState("")

	local ref = React.useRef(os.clock())
	local v7

	if axRecentlyViewedSearchItemsIXPTest.isEnabled() then
		v7 = module3.readTestVariable(axRecentlyViewedSearchItemsIXPTest.EnabledForUser)
	else
		v7 = nil
	end

	local v8 = React.useCallback(function(value): boolean
		if not fFlagAXUnifiedAutocompleteEndpoint then
			value = value:lower()
		end

		local v9 = data.autocompleteState and data.autocompleteState[value]

		if v9 and v9.expirationTime then
			return tick() < v9.expirationTime
		end

		return false
	end, { data.autocompleteState })

	local v9 = React.useCallback(function(p2)
		local searchUuid = data.createSearchUuid()
		local v10 = { searchKeyword = p2, isKeywordSuggestionEnabled = true }

		data.setSearchType(searchUuid)
		data.setSearchParameters(searchUuid, v10)

		if data.deviceOrientation == deviceOrientationMode.Portrait then
			data.setFullView()
		end

		data.navigateToSearch(searchUuid, v10)
	end, {
		data.createSearchUuid,
		data.setSearchType,
		data.setSearchParameters,
		data.setFullView,
		data.deviceOrientation,
		data.navigateToSearch
	})

	local function fn(p2, p3)
		if data.sendCounter then
			data.sendCounter(module8.SearchRecentTermRemoved)

			if p3 then
				local v10 = module8.SearchRecentTermRemovedPosPrefix .. p3
				data.sendCounter(v10)
			end
		end

		setState(module7.removeTerm(p2))

		if not defineFastFlag and wasLastInputGamepad() then
			data.focusController.moveFocusTo(data.searchBarRef)
		end
	end

	local v12 = React.useCallback(fn, {
		if not defineFastFlag then data.focusController else nil,
		data.searchBarRef,
		data.sendCounter
	})

	local v13 = React.useCallback(function(p2)
		setState2(p2)

		if data.searchTelemetry then
			data.searchTelemetry.updateQuery(p2)
		end

		local v14 = if fFlagAXUnifiedAutocompleteEndpoint then module14(p2) else module6(p2, true)

		if not v14 or v14 == "" or #v14 > module12() or v8(v14) then
			return
		end

		v5(v14, data.fetchAutocompleteSuggestions)
	end, {
		data.autocompleteState,
		data.fetchAutocompleteSuggestions,
		v8,
		data.searchTelemetry
	})

	local v14 = React.useCallback(function(p2)
		if p2 and module2.trim(p2) ~= "" then
			if data.sendCounter then
				data.sendCounter(module8.SearchSubmit)
				local v15 = (os.clock() - ref.current) * 1000

				if data.sendStats then
					data.sendStats(module9.SearchTimeToSearchMs, v15)
				end
			end

			module7.addTerm(p2)
			v9(p2)
		elseif data.sendCounter then
			data.sendCounter(module8.SearchSubmitNoQuery)
		end
	end, { v9, data.sendCounter })

	local v15 = React.useCallback(function()
		if fFlagAXSearchAndCancelLogging then
			sendUnifiedEventLog({
				action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
				elementName = unifiedLoggingElementNameEnums.SEARCH_LANDING_CANCEL_BUTTON,
				surface = unifiedLoggingSurface.SEARCH_LANDING_PAGE
			})

			if data.sendCounter then
				data.sendCounter(module8.SearchCancel)
			end

			if data.navigation then
				data.navigation.goBack()
			end
		else
			if data.sendCounter then
				data.sendCounter(module8.SearchCancel)
			end

			if data.navigation then
				data.navigation.goBack()
			end
		end
	end, { data.navigation, data.sendCounter })

	local v16 = React.useCallback(function(p2)
		setState2("")

		if data.searchTelemetry then
			data.searchTelemetry.sendClearEvent(p2)
		end

		if data.sendCounter then
			data.sendCounter(module8.SearchClear)
		end
	end, { data.sendCounter, data.searchTelemetry })

	local v17 = React.useCallback(function(p2, p3, p4)
		if data.sendCounter then
			local v18 = if p3 == module10.Recent then module8.SearchRecentTermSelected else module8.SearchAutocompleteTermSelected
			data.sendCounter(v18)

			if p3 == module10.Recent and state2 == "" or state2 == nil then
				data.sendCounter(module8.SearchRecentTermSelectedNoQuery)
			end

			local v19 = module8.SearchSuggestedTermSelectedPosPrefix .. p4
			data.sendCounter(v19)
		end

		if data.searchTelemetry and p3 == module10.Autocomplete then
			data.searchTelemetry.sendAutocompleteTermClickedEvent(state2, p2)
		end

		v14(p2)
	end, { v14, data.sendCounter, state2, data.searchTelemetry })

	local v18 = React.useMemo(function()
		local recentSearchTerms = getRecentSearchTerms(state2)
		local v19 = not data.autocompleteState and {}
			or getAutocompleteTerms(state2, data.autocompleteState)

		local result = {}

		for k, recentSearchTerm in recentSearchTerms do
			table.insert(result, recentSearchTerm)
		end

		for k, v20 in v19 do
			table.insert(result, v20)
		end

		for k, v20 in result do
			function v20.onActivate()
				v17(v20.text, v20.type, k)
			end

			if v20.type == module10.Recent then
				function v20.onRemove()
					v12(v20.text, k)
				end
			end
		end

		if axRecentlyViewedSearchItemsIXPTest.isEnabled() and v7 and state2 == "" then
			return module2.slice(result, 1, 5)
		end

		return result
	end, { state2, state, data.autocompleteState, v17, v12 })

	local v19 = #v18 == 0 and state2 == ""

	local v20 = nil

	if axRecentlyViewedSearchItemsIXPTest.isEnabled() then
		module3.logExperimentExposure(axRecentlyViewedSearchItemsIXPTest)

		if v7 then
			v20 = module11({
				fetchSearchRecentlyViewed = data.fetchSearchRecentlyViewed,
				toggleTryOn = data.toggleTryOn,
				catalogAnalytics = data.catalogAnalytics
			})

			v19 = v19 and #v20.items == 0
		end
	end

	local v21 = if axRecentlyViewedSearchItemsIXPTest.isEnabled() then state2 ~= "" else nil

	if module13 then
		v21 = state2 ~= ""
	end

	local v23 = {
		top = data.statusBarHeight or 0,
		left = 0,
		right = 0
	}
	local v24 = if not axRecentlyViewedSearchItemsIXPTest.isEnabled() then v6.Size.Size_300 else nil
	v23.left = v24
	local v25 = if not axRecentlyViewedSearchItemsIXPTest.isEnabled() then v6.Size.Size_300 else nil
	v23.right = v25
	local v22 = {
		padding = v23,
		onCancelSearch = v15,
		onChangeSearchQuery = v13,
		onSubmitSearch = v14,
		onClearSearch = v16,
		shouldShowEmptyState = v19,
		hasQuery = v21,
		searchBarRef = data.searchBarRef,
		firstSuggestedItemRef = data.firstSuggestedItemRef,
		suggestedSearchTerms = v18,
		recentlyViewedItems = 0
	}

	local v26 = if axRecentlyViewedSearchItemsIXPTest.isEnabled() and v20 then v20.items else nil
	v22.recentlyViewedItems = v26
	return v22
end

return useSearchLandingPageProps
