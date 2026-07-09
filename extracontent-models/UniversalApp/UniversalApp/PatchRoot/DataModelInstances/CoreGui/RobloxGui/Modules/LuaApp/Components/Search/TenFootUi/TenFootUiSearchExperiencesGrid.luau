local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local Foundation = require(CorePackages.Packages.Foundation)
local FFlagRenameDeprecatedUIBloxTokens = require(CorePackages.Workspace.Packages.SharedFlags).FFlagRenameDeprecatedUIBloxTokens
local IconSize = Foundation.Enums.IconSize
local Loading = Foundation.Loading
local Signal = require(CorePackages.Workspace.Packages.AppCommonLib).Signal
local useDesignTokens = require(CorePackages.Workspace.Packages.Style).useDesignTokens
local EmptyState = UIBlox.App.Indicator.EmptyState
local LoadingStateContainer = UIBlox.App.Container.LoadingStateContainer
local RetrievalStatus = UIBlox.App.Loading.Enum.RetrievalStatus
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useRoactService = require(CorePackages.Workspace.Packages.RobloxAppHooks).useRoactService
local RoactServiceTags = require(CorePackages.Workspace.Packages.RoactServiceTags)
local RoactNetworking = RoactServiceTags.RoactNetworking
local RoactAnalyticsCommonGameEvents = RoactServiceTags.RoactAnalyticsCommonGameEvents
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local AppSessionService = RoactServiceTags.AppSessionService
local AppPage = require(CorePackages.Workspace.Packages.RobloxAppEnums).AppPage
local SearchTypes = require(CorePackages.Workspace.Packages.RobloxAppEnums).SearchTypes
local useAnimatedScrollToSelection = require(CorePackages.Workspace.Packages.RobloxAppHooks).useAnimatedScrollToSelection
local GameSortImpressionsDetector = require(CorePackages.Workspace.Packages.GameCollections).GameSortImpressionsDetector
local SendGameImpressions = require(CorePackages.Workspace.Packages.GameCollections).SendGameImpressions
local DiscoveryTypes = require(CorePackages.Workspace.Packages.DiscoveryTypes)
local GameTileConstants = require(CorePackages.Workspace.Packages.GameTile).GameTileConstants
local Modules = require(CorePackages.Workspace.Packages.DiscoveryMonolith).Modules
local SearchRetrievalStatus = Modules.LuaApp.Enum.SearchRetrievalStatus
local FetchDataWithErrorToasts = Modules.LuaApp.Thunks.FetchDataWithErrorToasts
local ApiFetchGameSearchResults = Modules.LuaApp.Thunks.Search.ApiFetchGameSearchResults
local GameGridTable = Modules.LuaApp.Components.Games.GameGridTable
local SearchTextBanner = Modules.Personalization.Search.SearchTextBanner
local RemoveTextSearchResults = Modules.LuaApp.Actions.RemoveTextSearchResults
local Modules2 = game:GetService("CoreGui").RobloxGui.Modules
local useLocalization = require(Modules2.LuaApp.Hooks.useLocalization)
local RefreshScrollingFrameWithLoadMore = require(Modules2.LuaApp.Components.RefreshScrollingFrameWithLoadMore)
local ConfirmSearch = require(Modules2.LuaApp.Thunks.ConfirmSearch)
local Constants = require(Modules2.LuaApp.Constants)
local FFlagLuaAppSearchStandardizeAssetCategorization = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppSearchStandardizeAssetCategorization

local function v43(p1) -- line: 61
	return p1.ScreenSize
end
local function TenFootUiSearchExperiencesGrid(t1: {[any]: any}) -- line: 65
	-- upvalues: React (copy), Signal (copy), SearchRetrievalStatus (copy), useSelector (copy), v43 (copy), useDispatch (copy), useDesignTokens (copy), DiscoveryTypes (copy), SearchTextBanner (copy), RemoveTextSearchResults (copy), useRoactService (copy), RoactNetworking (copy), AppEventIngestService (copy), RoactAnalyticsCommonGameEvents (copy), AppSessionService (copy), RoactAnalytics (copy), useNavigation (copy), useAnimatedScrollToSelection (copy), FetchDataWithErrorToasts (copy), ApiFetchGameSearchResults (copy), useLocalization (copy), FFlagLuaAppSearchStandardizeAssetCategorization (copy), SearchTypes (copy), ConfirmSearch (copy), AppPage (copy), SendGameImpressions (copy), EmptyState (copy), FFlagRenameDeprecatedUIBloxTokens (copy), GameTileConstants (copy), RefreshScrollingFrameWithLoadMore (copy), GameGridTable (copy), Constants (copy), GameSortImpressionsDetector (copy), Loading (copy), IconSize (copy), LoadingStateContainer (copy), RetrievalStatus (copy)
	local v47 = React.useRef(nil)
	local searchKeyword = t1.searchKeyword
	local layoutOrder = t1.layoutOrder
	local searchType = t1.searchType
	local searchUuid = t1.searchUuid
	local v52 = React.useMemo(function() -- line: 73
		-- upvalues: Signal (copy)
		return Signal.new()
	end, {})

	local function selectSearchInGamesStatus(p2) -- line: 77
		-- upvalues: searchUuid (copy), SearchRetrievalStatus (copy)
		local v93 = p2.RequestsStatus.SearchesInGamesStatus[searchUuid]

		if v93 == nil then
			v93 = SearchRetrievalStatus.NotStarted
		end

		return v93
	end

	local v54 = useSelector(v43)
	local v55 = useSelector(function(p3) -- line: 86
		-- upvalues: searchUuid (copy)
		return p3.Search.SearchesInGames[searchUuid] or {
			suggestedKeyword = nil,
			filteredKeyword = nil,
			correctedKeyword = nil,
			hasMoreRows = nil,
			emphasis = nil,
			algorithm = nil,
			suggestionAlgorithm = nil,
			entries = {}
		}
	end)
	local v56 = useSelector(selectSearchInGamesStatus)
	local v57, v58 = React.useState(v54)
	local v59, v60 = React.useState(v57.X)
	local v61, v62 = React.useState(false)
	local entries = v55.entries
	local v64 = "SearchPage" .. tostring(searchUuid)

	React.useEffect(function() -- line: 107
		-- upvalues: v56 (copy), SearchRetrievalStatus (copy), v62 (copy), v61 (copy)
		if v56 == SearchRetrievalStatus.Done then
			v62(true)

			return
		end

		if v56 == SearchRetrievalStatus.NotStarted and v61 then
			v62(false)
		end
	end, { v56 })

	local v65 = useDispatch()
	local v66 = useDesignTokens()
	local v67 = useSelector(function(p4) -- line: 123
		-- upvalues: t1 (copy), DiscoveryTypes (copy)
		return p4.TextSearchResults[t1.searchUuid] and p4.TextSearchResults[t1.searchUuid][DiscoveryTypes.SearchTextTopicIds.HotlineSearchText] or nil
	end)
	local v68 = React.useMemo(function() -- line: 130
		-- upvalues: v67 (copy), React (copy), SearchTextBanner (copy)
		if not v67 then
			return nil
		end

		return React.createElement(SearchTextBanner, {
			text = v67.text
		})
	end, { v67 })

	React.useEffect(function() -- line: 139
		-- upvalues: v65 (copy), RemoveTextSearchResults (copy), searchUuid (copy)
		return function() -- line: 140
			-- upvalues: v65 (copy), RemoveTextSearchResults (copy), searchUuid (copy)
			v65(RemoveTextSearchResults(searchUuid))
		end
	end, { searchUuid })

	local v69 = useRoactService(RoactNetworking)
	local v70 = useRoactService(AppEventIngestService)
	local v71 = useRoactService(RoactAnalyticsCommonGameEvents)
	local v72 = useRoactService(AppSessionService)
	local v73 = useRoactService(RoactAnalytics)
	local v74 = useNavigation()

	local function v75(p5) -- line: 151
		-- upvalues: v60 (copy)
		v60(p5.AbsoluteSize.X)
	end

	local v76 = React.useCallback(function(p6) -- line: 154
		-- upvalues: v58 (copy)
		if p6 then
			v58(p6.AbsoluteSize)
		end
	end, {})
	local v77 = v47.current and v47.current.AbsoluteSize.Y * 0.35 or 0
	local v78, v79 = React.useState(false)
	local v80, v81 = useAnimatedScrollToSelection(Enum.ScrollingDirection.Y, v77)
	local v82 = React.useCallback(function(p7, b1: boolean, p8, p9) -- line: 165
		-- upvalues: v79 (copy), v77 (copy), v81 (copy)
		v79(p7.CanvasPosition.Y > v77)
		v81(p7, b1, p8, p9)
	end, {
		v77,
		v81
	})
	local v83 = React.useCallback(function() -- line: 172
		-- upvalues: v65 (copy), FetchDataWithErrorToasts (copy), ApiFetchGameSearchResults (copy), v69 (copy), searchKeyword (copy), searchUuid (copy)
		return v65(FetchDataWithErrorToasts(ApiFetchGameSearchResults(v69, {
			isAppend = true,
			searchKeyword = searchKeyword,
			searchUuid = searchUuid
		})))
	end, {
		v65,
		v69,
		searchKeyword,
		searchUuid
	})
	local v84 = useLocalization({
		failedMessage = "Feature.EmptyStatePage.Message.NoInternet",
		noResultsText = "Feature.GamePage.LabelNoSearchResults",
		players = "CommonUI.Features.Label.Players",
		games = not FFlagLuaAppSearchStandardizeAssetCategorization and "CommonUI.Features.Label.Game" or "CommonUI.Features.Label.Games"
	})

	React.useEffect(function() -- line: 189
		-- upvalues: searchKeyword (copy), v74 (copy), v70 (copy), v72 (copy), SearchTypes (copy), v65 (copy), ConfirmSearch (copy), ApiFetchGameSearchResults (copy), v69 (copy), searchUuid (copy)
		if searchKeyword == "" then
			return
		end

		assert(v74, "Expected navigation, found none")
		assert(v70, "Expected eventIngest, found none")
		assert(v72, "Expected sessionService, found none")

		local t2 = {
			isAutocompleteSuggestion = false,
			allAutocompleteSuggestions = false,
			isAvatarAutocompleteEnabled = false,
			searchType = SearchTypes.Games,
			pageOwner = v74.state.routeName,
			sessionService = v72,
			eventIngest = v70
		}

		v65(ConfirmSearch(searchKeyword, t2))
		v65(ApiFetchGameSearchResults(v69, {
			isAppend = false,
			searchKeyword = searchKeyword,
			searchUuid = searchUuid
		}))
	end, {
		searchKeyword,
		searchUuid,
		v65,
		v70,
		v72,
		v69
	})

	local SearchBoxAndTypeOffset = v66.LuaApps.Search.SearchBoxAndTypeOffset

	local function v86(p10) -- line: 218
		-- upvalues: v55 (copy), v71 (copy), AppPage (copy)
		local v104 = v55.entries or {}
		local v105 = v104[p10]

		if v105 ~= nil then
			local placeId = v105.placeId
			local isSponsored = v105.isSponsored
			local adId = v105.adId
			local v109 = #v104
			local universeId = v105.universeId

			v71.reportOpenGameDetailFromSearch(placeId, p10, v109, isSponsored, adId, universeId, AppPage.SearchPage, nil, nil)
		end
	end
	local function v87(p11) -- line: 242
		-- upvalues: searchUuid (copy), v55 (copy), SendGameImpressions (copy), v70 (copy), v73 (copy), AppPage (copy)
		local t3 = {
			seeAllFlag = 1,
			searchUuid = searchUuid,
			emphasisFlag = not v55.emphasis and 0 or 1
		}

		SendGameImpressions.sendFromSearch(v70, v73, p11, v55.entries, AppPage.SearchPage, t3, nil, nil)
	end

	local v88 = searchType == SearchTypes.Games and (v55 ~= nil and (not v55.hasMoreRows and ((v55.entries == nil or #v55.entries == 0) and not v68)))
	local v89 = React.useCallback(function() -- line: 268
		-- upvalues: v88 (copy), React (copy), SearchBoxAndTypeOffset (copy), layoutOrder (copy), EmptyState (copy), v84 (copy), v54 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), v66 (copy), GameTileConstants (copy), v78 (copy), v75 (copy), v68 (copy), RefreshScrollingFrameWithLoadMore (copy), v47 (copy), v80 (copy), v76 (copy), v52 (copy), v55 (copy), v83 (copy), v82 (copy), DiscoveryTypes (copy), GameGridTable (copy), entries (copy), v59 (copy), v57 (copy), v86 (copy), v64 (copy), Constants (copy), GameSortImpressionsDetector (copy), AppPage (copy), v87 (copy)
		if v88 then
			return React.createElement("Frame", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 1, -SearchBoxAndTypeOffset),
				Position = UDim2.new(0, 0, 0, SearchBoxAndTypeOffset),
				LayoutOrder = layoutOrder
			}, {
				NoResultsView = React.createElement(EmptyState, {
					text = v84.noResultsText,
					maxSizeTextLabel = Vector2.new(v54.X - if not FFlagRenameDeprecatedUIBloxTokens then v66.Global.Size_500 else v66.Size.Size_1000, v54.Y)
				})
			})
		end

		local Footer = GameTileConstants.PlayerCountStyleValues.Footer

		return React.createElement("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0, 0, 0, 0),
			LayoutOrder = layoutOrder,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			SelectionGroup = true,
			SelectionBehaviorUp = if not v78 then nil else Enum.SelectionBehavior.Stop,
			[React.Change.AbsoluteSize] = v75
		}, {
			CanvasGroupMask = React.createElement("CanvasGroup", {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 1, 0)
			}, {
				TextComponent = if not v68 then nil else v68,
				ScrollingFrame = if not v68 then React.createElement(RefreshScrollingFrameWithLoadMore, {
					BackgroundTransparency = 1,
					Size = UDim2.new(1, 0, 1, 0),
					Position = UDim2.new(0, 0, 0, 0),
					CanvasSize = UDim2.new(1, 0, 1, 0),
					ref = v47,
					canvasPosition = v80,
					onAbsoluteSizeChangedCallback = v76,
					onCanvasPositionChangedCallback = function() -- line: 317
						-- upvalues: v52 (copy)
						v52:fire()
					end,
					onLoadMore = v55.hasMoreRows and v83 or nil,
					onSelectionChanged = v82
				}, {
					Layout = React.createElement("UIListLayout", {
						FillDirection = Enum.FillDirection.Vertical,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						SortOrder = Enum.SortOrder.LayoutOrder,
						Padding = UDim.new(0, if not FFlagRenameDeprecatedUIBloxTokens then v66.Global.Space_100 else v66.Size.Size_200)
					}),
					Padding = React.createElement("UIPadding", {
						PaddingLeft = UDim.new(0, 0),
						PaddingRight = UDim.new(0, 0),
						PaddingTop = UDim.new(0, DiscoveryTypes.Constants.GAME_GRID_PADDING),
						PaddingBottom = UDim.new(0, DiscoveryTypes.Constants.GAME_GRID_PADDING)
					}),
					GameGridWrapper = React.createElement("Frame", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 0),
						AutomaticSize = Enum.AutomaticSize.Y
					}, {
						Layout = React.createElement("UIListLayout", {
							HorizontalAlignment = Enum.HorizontalAlignment.Center
						}),
						Padding = React.createElement("UIPadding", {
							PaddingBottom = UDim.new(0, SearchBoxAndTypeOffset)
						}),
						GameGridTable = React.createElement(GameGridTable, {
							searchResultGrid = true,
							gameEmphasis = false,
							source = "SearchResults",
							useHoverTile = false,
							entries = entries,
							screenSize = v54,
							windowSize = Vector2.new(v59, v57.Y),
							reportGameDetailOpened = v86,
							horizontalAlignment = Enum.HorizontalAlignment.Left,
							impressionsTag = v64,
							launchExperienceEventContext = Constants.AnalyticsContext.SearchExperienceTile,
							playerCountStyle = Footer
						}),
						GameSortImpressionsDetector = React.createElement(GameSortImpressionsDetector, {
							parentRef = v47,
							pageContext = AppPage.SearchPage,
							impressionsTag = v64,
							scrollViewPositionChangedSignal = v52,
							sendGameImpressions = v87
						})
					})
				}) else nil
			})
		})
	end, {
		SearchBoxAndTypeOffset,
		layoutOrder,
		v66,
		v84,
		v75,
		v55,
		v88,
		v76,
		v52,
		entries,
		v83,
		v54,
		v57,
		v59,
		v86,
		v64,
		v87,
		v68
	})
	local v90 = React.useCallback(function() -- line: 402
		-- upvalues: v61 (copy), v89 (copy), React (copy), SearchBoxAndTypeOffset (copy), layoutOrder (copy), Loading (copy), IconSize (copy)
		if v61 and v89 ~= nil then
			return v89()
		end

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, -SearchBoxAndTypeOffset),
			Position = UDim2.new(0, 0, 0, 0),
			LayoutOrder = layoutOrder
		}, {
			LoadingSpinner = React.createElement(Loading, {
				size = IconSize.Small,
				Position = UDim2.fromScale(0.5, 0.5),
				AnchorPoint = Vector2.new(0.5, 0.5)
			})
		})
	end, {
		v61,
		v66,
		v89,
		SearchBoxAndTypeOffset,
		layoutOrder
	})
	local v91 = React.useCallback(function() -- line: 434
		-- upvalues: React (copy), SearchBoxAndTypeOffset (copy), layoutOrder (copy), EmptyState (copy), v84 (copy), v54 (copy), FFlagRenameDeprecatedUIBloxTokens (copy), v66 (copy)
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 1, -SearchBoxAndTypeOffset),
			Position = UDim2.new(0, 0, 0, SearchBoxAndTypeOffset),
			LayoutOrder = layoutOrder
		}, {
			NoResultsView = React.createElement(EmptyState, {
				text = v84.failedMessage,
				maxSizeTextLabel = Vector2.new(v54.X - if not FFlagRenameDeprecatedUIBloxTokens then v66.Global.Size_500 else v66.Size.Size_1000, v54.Y)
			})
		})
	end, {
		SearchBoxAndTypeOffset,
		layoutOrder,
		v54,
		v66,
		v84.failedMessage
	})

	if searchType ~= SearchTypes.Games then
		return React.createElement(React.Fragment, nil, {})
	end

	return React.createElement(LoadingStateContainer, {
		dataStatus = RetrievalStatus.fromRawValue(v56),
		renderOnEmpty = function() -- line: 471
			return nil
		end,
		renderOnFailed = v91,
		renderOnLoading = v90,
		renderOnLoaded = v89
	})
end

return TenFootUiSearchExperiencesGrid
