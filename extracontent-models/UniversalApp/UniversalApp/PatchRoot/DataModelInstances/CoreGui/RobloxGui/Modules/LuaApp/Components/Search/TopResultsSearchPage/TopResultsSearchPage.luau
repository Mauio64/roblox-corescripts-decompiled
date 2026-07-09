local CorePackages = game:GetService("CorePackages")
local RoactNetworking = require(CorePackages.Workspace.Packages.RoactServiceTags).RoactNetworking
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local React = require(CorePackages.Packages.React)
local Promise = require(CorePackages.Packages.Promise)
local RoactUtils = require(CorePackages.Workspace.Packages.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local UIBlox = require(CorePackages.Packages.UIBlox)
local RetrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local LoadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local EmptyState = UIBlox.App.Indicator.EmptyState
local Images = UIBlox.App.ImageSet.Images
local ServerDrivenUi = require(CorePackages.Workspace.Packages.ServerDrivenUi)
local useCollectionLayoutConfig = require(CorePackages.Workspace.Packages.CollectionViews).useCollectionLayoutConfig
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local PerformFetch = require(CorePackages.Workspace.Packages.Http).PerformFetch
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local RemoveSduiRootConfig = require(CorePackages.Workspace.Packages.ServerDrivenUi).RemoveSduiRootConfig
local RemoveTextSearchResults = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules.LuaApp.Actions.RemoveTextSearchResults
local getTopSearchResultsFetchName = require(CorePackages.Workspace.Packages.DiscoveryUtils).getTopSearchResultsFetchName
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local OmniFeedViewLoadMore = require(Modules.Personalization.OmniFeed.FeedViews.OmniFeedViewLoadMore)
local ApiFetchTopSearchResults = require(Modules.LuaApp.Thunks.Search.ApiFetchTopSearchResults.ApiFetchTopSearchResults)
local RemoveSearchInGames = require(Modules.LuaApp.Actions.RemoveSearchInGames)
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local FFlagRenameDeprecatedUIBloxTokens = SharedFlags.FFlagRenameDeprecatedUIBloxTokens
local FFlagAppIaScrollAway = SharedFlags.FFlagAppIaScrollAway
local FFlagLuaAppLayoutParamsInContext = SharedFlags.FFlagLuaAppLayoutParamsInContext
local FFlagSduiSearchResultsPageEnabled = SharedFlags.FFlagSduiSearchResultsPageEnabled
local SearchPage = AppPage.SearchPage
local v33 = Images["icons/status/oof_xlarge"]

local function TopResultsSearchPage(t1: {[any]: any}) -- line: 65
	-- upvalues: FFlagSduiSearchResultsPageEnabled (copy), CorePackages (copy), useDesignTokens (copy), FFlagRenameDeprecatedUIBloxTokens (copy), FFlagAppIaScrollAway (copy), React (copy), useLocalization (copy), useRoactService (copy), RoactNetworking (copy), useDispatch (copy), ApiFetchTopSearchResults (copy), Promise (copy), RemoveSduiRootConfig (copy), SearchPage (copy), RemoveSearchInGames (copy), RemoveTextSearchResults (copy), useSelector (copy), PerformFetch (copy), getTopSearchResultsFetchName (copy), RetrievalStatus (copy), FFlagLuaAppLayoutParamsInContext (copy), useCollectionLayoutConfig (copy), ServerDrivenUi (copy), LoadingStateContainer (copy), EmptyState (copy), OmniFeedViewLoadMore (copy), v33 (copy)
	if FFlagSduiSearchResultsPageEnabled then
		local SduiSearchResultsPage = require(CorePackages.Workspace.Packages.SearchResults).SduiSearchResultsPage
		local v37 = useDesignTokens()
		local v38 = if not FFlagRenameDeprecatedUIBloxTokens then v37.Global.Size_300 else v37.Size.Size_600
		local v39 = if not FFlagAppIaScrollAway then nil else t1.canvasTopPadding

		return React.createElement(SduiSearchResultsPage, {
			searchKeyword = t1.searchParameters.searchKeyword,
			searchUuid = t1.searchUuid,
			globalSessionId = t1.omniSearchUuid,
			pageTopPadding = (v39 or 0) + v38
		})
	end

	local v40 = useLocalization({
		requestFailed = "Feature.Toast.NetworkingError.SomethingIsWrong",
		noResultsFound = "CommonUI.Controls.NoResultsFound"
	})
	local v41 = useRoactService(RoactNetworking)
	local v42 = useDispatch()
	local v43 = React.useCallback(function() -- line: 90
		-- upvalues: v42 (copy), ApiFetchTopSearchResults (copy), v41 (copy), t1 (copy), Promise (copy)
		return v42(ApiFetchTopSearchResults(v41, {
			searchVertical = "blended",
			keyword = t1.searchParameters.searchKeyword,
			searchUuid = t1.searchUuid,
			omniSearchUuid = t1.omniSearchUuid
		})):catch(function() -- line: 96
			-- upvalues: Promise (copy)
			return Promise.resolve()
		end)
	end, {
		t1.searchParameters.searchKeyword,
		t1.searchUuid,
		t1.omniSearchUuid
	})

	React.useEffect(function() -- line: 105
		-- upvalues: v43 (copy)
		v43()
	end, { v43 })
	React.useEffect(function() -- line: 109
		-- upvalues: v42 (copy), RemoveSduiRootConfig (copy), SearchPage (copy), t1 (copy), RemoveSearchInGames (copy), RemoveTextSearchResults (copy)
		return function() -- line: 110
			-- upvalues: v42 (copy), RemoveSduiRootConfig (copy), SearchPage (copy), t1 (copy), RemoveSearchInGames (copy), RemoveTextSearchResults (copy)
			v42(RemoveSduiRootConfig(`{ SearchPage }_{ t1.searchUuid }`))
			v42(RemoveSearchInGames(t1.searchUuid))
			v42(RemoveTextSearchResults(t1.searchUuid))
		end
	end, {
		t1.searchUuid,
		v42
	})

	local v44 = useSelector(function(p1) -- line: 117
		-- upvalues: PerformFetch (copy), getTopSearchResultsFetchName (copy), t1 (copy), RetrievalStatus (copy)
		local v58 = PerformFetch.GetStatus(p1, getTopSearchResultsFetchName("blended", t1.searchUuid))

		return RetrievalStatus.fromRawValue(v58)
	end)
	local v45 = v44 == RetrievalStatus.Done
	local v46, v47 = React.useState(v45)

	React.useEffect(function() -- line: 126
		-- upvalues: v46 (copy), v45 (copy), v47 (copy)
		if not v46 and v45 then
			v47(true)
		end
	end, {
		v46,
		v45
	})

	local v48 = useSelector(function(p2) -- line: 132
		-- upvalues: SearchPage (copy), t1 (copy)
		local v60 = p2.Personalization.OrderedOmniItems[SearchPage] and p2.Personalization.OrderedOmniItems[SearchPage][t1.searchUuid] or nil

		return v60 and v60.allItems or {}
	end)
	local v49 = useDesignTokens()
	local v50 = if not FFlagRenameDeprecatedUIBloxTokens then v49.Global.Size_300 else v49.Size.Size_600
	local v51 = nil
	local u52 = nil
	local u53 = nil

	if FFlagLuaAppLayoutParamsInContext then
		local v54

		v51, v54 = React.useState(nil)
		u52 = v54
	else
		u53 = React.useRef(nil)
	end

	local v55 = if not FFlagLuaAppLayoutParamsInContext then nil else useCollectionLayoutConfig(v51)
	local v56 = ServerDrivenUi.useSduiContextFromRoduxAndProcessConfigs(SearchPage, if not FFlagLuaAppLayoutParamsInContext then nil else v55, `{ SearchPage }_{ t1.searchUuid }`)

	return React.createElement(LoadingStateContainer, {
		dataStatus = if not v46 then v44 else RetrievalStatus.Done,
		renderOnFailed = function() -- line: 162
			-- upvalues: React (copy), EmptyState (copy), v43 (copy), v40 (copy)
			return React.createElement(EmptyState, {
				onActivated = v43,
				text = v40.requestFailed
			})
		end,
		renderOnLoaded = function() -- line: 168
			-- upvalues: v48 (copy), React (copy), OmniFeedViewLoadMore (copy), v50 (copy), SearchPage (copy), v43 (copy), t1 (copy), FFlagLuaAppLayoutParamsInContext (copy), u52 (ref), u53 (ref), FFlagAppIaScrollAway (copy), v56 (copy), EmptyState (copy), v33 (copy), v40 (copy)
			if v48 and #v48 > 0 then
				return (React.createElement(OmniFeedViewLoadMore, {
					createEndOfScrollElement = true,
					impressionsTag = "TOPSEARCHRESULTS_FEEDITEM_IMPRESSIONS",
					analyticsContext = "TOPSEARCH_OMNIFEED",
					topPadding = v50,
					pageContext = SearchPage,
					refresh = v43,
					omniFeedItems = v48,
					onScrollDirectionChanged = t1.onScrollDirectionChanged,
					scrollingFrameRef = if not FFlagLuaAppLayoutParamsInContext then u53 else u52,
					canvasTopPadding = if not FFlagAppIaScrollAway then nil else t1.canvasTopPadding,
					sduiContext = v56
				}))
			end

			return (React.createElement(EmptyState, {
				icon = v33,
				text = v40.noResultsFound
			}))
		end
	})
end

return TopResultsSearchPage
