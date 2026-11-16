local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local emptyState = UIBlox.App.Indicator.EmptyState
local loadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local retrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local t = require(CorePackages.Packages.t)
local roactNetworking = require("@game/CorePackages/Workspace/Packages/RoactServiceTags").RoactNetworking
local React = require(CorePackages.Packages.React)
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch
local usePrevious = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.usePrevious
local useScreenSize = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useScreenSize
local useRoactService = require("@game/CorePackages/Workspace/Packages/RobloxAppHooks").useRoactService
local validateProps = require("@luauforge/bundled/edc").validateProps
local appPage = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").AppPage

local modules = require("@luauforge/bundled/dpZ").Modules
local setSearchInGamesStatus = modules.LuaApp.Actions.SetSearchInGamesStatus
local searchRetrievalStatus = modules.LuaApp.Enum.SearchRetrievalStatus
local apiFetchGameSearchResults = modules.LuaApp.Thunks.Search.ApiFetchGameSearchResults
local removeTextSearchResults = modules.LuaApp.Actions.RemoveTextSearchResults

local module = require("@luauforge/deferred/hEU")
local module2 = require("@luauforge/deferred/ecS")
local module3 = require("@luauforge/bundled/hFd")

local fFlagAppIaScrollAway = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAppIaScrollAway

local strictInterface = t.strictInterface
local v5 = {
	searchUuid = t.string,
	omniSearchUuid = t.optional(t.string),
	searchParameters = t.table,
	onScrollDirectionChanged = t.optional(t.callback),
	isRoutedFromAutoSearch = t.optional(t.boolean),
	canvasTopPadding = 0
}
local v6 = if fFlagAppIaScrollAway then t.optional(t.number) else nil
v5.canvasTopPadding = v6
local v7 = strictInterface(v5)

return function(props)
	validateProps(v7, props)

	local searchUuid = props.searchUuid
	local omniSearchUuid = props.omniSearchUuid
	local searchParameters = props.searchParameters

	local state, setState = React.useState(false)
	local v8 = useRoactService(roactNetworking)
	local v9 = useDispatch()

	local v10 = useScreenSize()

	local v11 = useLocalization({
		noResultsText = "CommonUI.Controls.NoResultsFound",
		failedMessage = "Feature.EmptyStatePage.Message.NoInternet"
	})

	local v12 = useSelector(function(p2)
		local v13

		if props.isRoutedFromAutoSearch then
			v13 = module2(p2, searchParameters.searchKeyword)
		else
			v13 = p2.RequestsStatus.SearchesInGamesStatus[searchUuid] or searchRetrievalStatus.NotStarted
		end

		if v13 == searchRetrievalStatus.Removed then
			v13 = searchRetrievalStatus.NotStarted
		end

		return v13
	end)

	local v13 = useSelector(function(p2)
		return p2.Search.SearchesInGames[searchUuid]
	end)

	local v14 = useSelector(function(p2)
		return p2.Personalization.OrderedOmniItems[appPage.SearchPage]
			and p2.Personalization.OrderedOmniItems[appPage.SearchPage][searchUuid]
			and p2.Personalization.OrderedOmniItems[appPage.SearchPage][searchUuid].allItems
			or nil
	end)

	local paginationMethod = v13 and v13.paginationMethod

	local v15 = React.useCallback(function()
		if not props.isRoutedFromAutoSearch then
			v9(apiFetchGameSearchResults(v8, {
				searchKeyword = searchParameters.searchKeyword,
				searchUuid = searchUuid,
				omniSearchUuid = omniSearchUuid,
				isAppend = false
			})):catch(function(p2)
				warn(`Error fetching game search results: {p2}`)
			end)
		elseif v12 == searchRetrievalStatus.Done then
			setState(true)
		end
	end, {
		props.isRoutedFromAutoSearch,
		v12,
		searchUuid,
		omniSearchUuid,
		searchParameters.searchKeyword,
		v8
	})

	React.useEffect(function()
		v15()
	end, {})

	React.useEffect(function()
		return function()
			v9(module3(searchUuid))
			v9(setSearchInGamesStatus(searchUuid, searchRetrievalStatus.Removed))
			v9(removeTextSearchResults(searchUuid))
		end
	end, { searchUuid })

	local v16 = usePrevious(v12)
	React.useEffect(function()
		if v12 ~= v16 then
			if v12 == searchRetrievalStatus.Done then
				setState(true)
			elseif v12 == searchRetrievalStatus.NotStarted or v12 == searchRetrievalStatus.Failed then
				setState(false)
			end
		end
	end, { v12, v16 })

	local noResultsText = v11.noResultsText
	local v17 = React.useCallback(function()
		if not v14 or #v14 == 0 then
			return React.createElement(emptyState, { text = noResultsText })
		end

		local createElement = React.createElement
		local v19 = {
			searchUuid = searchUuid,
			omniSearchUuid = omniSearchUuid,
			createEndOfScrollElement = not v13.hasMoreRows,
			onScrollDirectionChanged = props.onScrollDirectionChanged,
			paginationMethod = paginationMethod,
			canvasTopPadding = 0
		}

		local v20 = if fFlagAppIaScrollAway then props.canvasTopPadding else nil
		v19.canvasTopPadding = v20
		return createElement(module, v19)
	end, {
		v13,
		searchUuid,
		omniSearchUuid,
		props.onScrollDirectionChanged,
		v10,
		noResultsText,
		paginationMethod,
		v14
	})

	local failedMessage = v11.failedMessage
	local v18 = React.useCallback(function()
		return React.createElement(emptyState, {
			onActivated = v15,
			text = failedMessage
		})
	end, { v15, failedMessage })

	return React.createElement(loadingStateContainer, {
		dataStatus = retrievalStatus.fromRawValue(v12),
		renderOnLoading = state and v17 or nil,
		renderOnFailed = v18,
		renderOnLoaded = v17
	})
end
