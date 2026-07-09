local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local EmptyState = UIBlox.App.Indicator.EmptyState
local LoadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local RetrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local t = require(CorePackages.Packages.t)
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local React = require(CorePackages.Packages.React)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local usePrevious = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.usePrevious
local useScreenSize = require(CorePackages.Workspace.Packages.RobloxAppHooks).useScreenSize
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local DiscoveryUtils = require(CorePackages.Workspace.Packages.DiscoveryUtils)
local validateProps = DiscoveryUtils.validateProps
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local Modules = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local SetSearchInGamesStatus = Modules.LuaApp.Actions.SetSearchInGamesStatus
local SearchRetrievalStatus = Modules.LuaApp.Enum.SearchRetrievalStatus
local ApiFetchGameSearchResults = Modules.LuaApp.Thunks.Search.ApiFetchGameSearchResults
local RemoveTextSearchResults = Modules.LuaApp.Actions.RemoveTextSearchResults
local Modules2 = game:GetService("CoreGui").RobloxGui.Modules
local GamesSearchOmniFeed = require(Modules2.LuaApp.Components.Search.GamesSearchOmniFeed)
local getAutoFetchingStatus = require(Modules2.LuaApp.Thunks.Search.getAutoFetchingStatus)
local RemoveSearchInGames = require(Modules2.LuaApp.Actions.RemoveSearchInGames)
local FFlagAppIaScrollAway = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAppIaScrollAway
local v29 = game:DefineFastFlag("LuaAppSearchNoResultsIconAlignment", false)
local v30 = t.strictInterface({
	searchUuid = t.string,
	omniSearchUuid = t.optional(t.string),
	searchParameters = t.table,
	onScrollDirectionChanged = t.optional(t.callback),
	isRoutedFromAutoSearch = t.optional(t.boolean),
	canvasTopPadding = if not FFlagAppIaScrollAway then nil else t.optional(t.number)
})

return function(t1: {[any]: any}) -- line: 54
	-- upvalues: validateProps (copy), v30 (copy), React (copy), useRoactService (copy), RoactNetworking (copy), useDispatch (copy), useScreenSize (copy), useLocalization (copy), v29 (copy), useSelector (copy), getAutoFetchingStatus (copy), SearchRetrievalStatus (copy), AppPage (copy), ApiFetchGameSearchResults (copy), RemoveSearchInGames (copy), SetSearchInGamesStatus (copy), RemoveTextSearchResults (copy), usePrevious (copy), EmptyState (copy), DiscoveryUtils (copy), DiscoveryTypes (copy), GamesSearchOmniFeed (copy), FFlagAppIaScrollAway (copy), LoadingStateContainer (copy), RetrievalStatus (copy)
	validateProps(v30, t1)

	local searchUuid = t1.searchUuid
	local omniSearchUuid = t1.omniSearchUuid
	local searchParameters = t1.searchParameters
	local v35, v36 = React.useState(false)
	local v37 = useRoactService(RoactNetworking)
	local v38 = useDispatch()
	local v39 = useScreenSize()
	local v40 = useLocalization({
		failedMessage = "Feature.EmptyStatePage.Message.NoInternet",
		noResultsText = not v29 and "Feature.GamePage.LabelNoSearchResults" or "CommonUI.Controls.NoResultsFound"
	})
	local v41 = useSelector(function(p1) -- line: 74
		-- upvalues: t1 (copy), getAutoFetchingStatus (copy), searchParameters (copy), searchUuid (copy), SearchRetrievalStatus (copy)
		local v52 = if not t1.isRoutedFromAutoSearch then p1.RequestsStatus.SearchesInGamesStatus[searchUuid] or SearchRetrievalStatus.NotStarted else getAutoFetchingStatus(p1, searchParameters.searchKeyword)

		if v52 == SearchRetrievalStatus.Removed then
			v52 = SearchRetrievalStatus.NotStarted
		end

		return v52
	end)
	local v42 = useSelector(function(p2) -- line: 90
		-- upvalues: searchUuid (copy)
		return p2.Search.SearchesInGames[searchUuid]
	end)
	local v43 = useSelector(function(p3) -- line: 94
		-- upvalues: AppPage (copy), searchUuid (copy)
		return p3.Personalization.OrderedOmniItems[AppPage.SearchPage] and (not not p3.Personalization.OrderedOmniItems[AppPage.SearchPage][searchUuid] and p3.Personalization.OrderedOmniItems[AppPage.SearchPage][searchUuid].allItems) or nil
	end)
	local v44 = v42 and v42.paginationMethod
	local v45 = React.useCallback(function() -- line: 104
		-- upvalues: t1 (copy), v41 (copy), SearchRetrievalStatus (copy), v36 (copy), v38 (copy), ApiFetchGameSearchResults (copy), v37 (copy), searchParameters (copy), searchUuid (copy), omniSearchUuid (copy)
		if t1.isRoutedFromAutoSearch then
			if v41 == SearchRetrievalStatus.Done then
				v36(true)
			end

			return
		end

		v38(ApiFetchGameSearchResults(v37, {
			isAppend = false,
			searchKeyword = searchParameters.searchKeyword,
			searchUuid = searchUuid,
			omniSearchUuid = omniSearchUuid
		})):catch(function(p4) -- line: 117
			warn(`Error fetching game search results: { p4 }`)
		end)
	end, {
		t1.isRoutedFromAutoSearch,
		v41,
		searchUuid,
		omniSearchUuid,
		searchParameters.searchKeyword,
		v37
	})

	React.useEffect(function() -- line: 131
		-- upvalues: v45 (copy)
		v45()
	end, {})
	React.useEffect(function() -- line: 135
		-- upvalues: v38 (copy), RemoveSearchInGames (copy), searchUuid (copy), SetSearchInGamesStatus (copy), SearchRetrievalStatus (copy), RemoveTextSearchResults (copy)
		return function() -- line: 136
			-- upvalues: v38 (copy), RemoveSearchInGames (copy), searchUuid (copy), SetSearchInGamesStatus (copy), SearchRetrievalStatus (copy), RemoveTextSearchResults (copy)
			v38(RemoveSearchInGames(searchUuid))
			v38(SetSearchInGamesStatus(searchUuid, SearchRetrievalStatus.Removed))
			v38(RemoveTextSearchResults(searchUuid))
		end
	end, { searchUuid })

	local v46 = usePrevious(v41)

	React.useEffect(function() -- line: 144
		-- upvalues: v41 (copy), v46 (copy), SearchRetrievalStatus (copy), v36 (copy)
		if v41 ~= v46 then
			if v41 == SearchRetrievalStatus.Done then
				v36(true)

				return
			end

			if v41 == SearchRetrievalStatus.NotStarted or v41 == SearchRetrievalStatus.Failed then
				v36(false)
			end
		end
	end, {
		v41,
		v46
	})

	local noResultsText = v40.noResultsText
	local v48 = React.useCallback(function() -- line: 159
		-- upvalues: v43 (copy), v29 (copy), React (copy), EmptyState (copy), noResultsText (copy), DiscoveryUtils (copy), v39 (copy), DiscoveryTypes (copy), GamesSearchOmniFeed (copy), searchUuid (copy), omniSearchUuid (copy), v42 (copy), t1 (copy), v44 (copy), FFlagAppIaScrollAway (copy)
		if not v43 or #v43 == 0 then
			if v29 then
				return React.createElement(EmptyState, {
					text = noResultsText
				})
			end

			local v55 = DiscoveryUtils.getPageSideMargin(v39.X)

			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				Padding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, DiscoveryTypes.Constants.GAME_GRID_PADDING),
					PaddingLeft = UDim.new(0, v55),
					PaddingRight = UDim.new(0, v55)
				}),
				NoResultsView = React.createElement(EmptyState, {
					text = noResultsText
				})
			})
		end

		return (React.createElement(GamesSearchOmniFeed, {
			searchUuid = searchUuid,
			omniSearchUuid = omniSearchUuid,
			createEndOfScrollElement = not v42.hasMoreRows,
			onScrollDirectionChanged = t1.onScrollDirectionChanged,
			paginationMethod = v44,
			canvasTopPadding = if not FFlagAppIaScrollAway then nil else t1.canvasTopPadding
		}))
	end, {
		v42,
		searchUuid,
		omniSearchUuid,
		t1.onScrollDirectionChanged,
		v39,
		noResultsText,
		v44,
		v43
	})
	local failedMessage = v40.failedMessage
	local v50 = React.useCallback(function() -- line: 205
		-- upvalues: React (copy), EmptyState (copy), v45 (copy), failedMessage (copy)
		return React.createElement(EmptyState, {
			onActivated = v45,
			text = failedMessage
		})
	end, {
		v45,
		failedMessage
	})

	return React.createElement(LoadingStateContainer, {
		dataStatus = RetrievalStatus.fromRawValue(v41),
		renderOnLoading = v35 and v48 or nil,
		renderOnFailed = v50,
		renderOnLoaded = v48
	})
end
