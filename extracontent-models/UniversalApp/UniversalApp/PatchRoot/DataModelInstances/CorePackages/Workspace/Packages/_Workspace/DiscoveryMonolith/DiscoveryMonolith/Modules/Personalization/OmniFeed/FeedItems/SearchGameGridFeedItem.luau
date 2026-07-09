local DiscoveryMonolith = script:FindFirstAncestor("DiscoveryMonolith")
local DiscoveryMonolithParent = DiscoveryMonolith.Parent
local React = require(DiscoveryMonolithParent.React)
local RoactServiceTags = require(DiscoveryMonolithParent.RoactServiceTags)
local RoactAnalyticsCommonGameEvents = RoactServiceTags.RoactAnalyticsCommonGameEvents
local RoactAnalytics = RoactServiceTags.RoactAnalytics
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local ArgCheck = require(DiscoveryMonolithParent.ArgCheck)
local Cryo = require(DiscoveryMonolithParent.Cryo)

require(DiscoveryMonolithParent.AppCommonLib)

local useSelector = require(DiscoveryMonolithParent.RoactUtils).Hooks.RoactRodux.useSelector
local GameSortImpressionsDetector = require(DiscoveryMonolithParent.GameCollections).GameSortImpressionsDetector
local SendGameImpressions = require(DiscoveryMonolithParent.GameCollections).SendGameImpressions
local WaitForPropWrapper = require(DiscoveryMonolithParent.GameCollections).WaitForPropWrapper
local useRoactService = require(DiscoveryMonolithParent.RobloxAppHooks).useRoactService
local AppPage = require(DiscoveryMonolithParent.RobloxAppEnums).AppPage
local SearchTypes = require(DiscoveryMonolithParent.RobloxAppEnums).SearchTypes
local DiscoveryAnalytics = require(DiscoveryMonolithParent.DiscoveryAnalytics)
local gamePlayIntent = DiscoveryAnalytics.Events.gamePlayIntent
local Context = DiscoveryAnalytics.Constants.Context
local GameTileConstants = require(DiscoveryMonolithParent.GameTile).GameTileConstants
local LayoutConfig = require(DiscoveryMonolithParent.RobloxAppEnums).LayoutConfig
local useResponsiveLayout = require(DiscoveryMonolithParent.UIBlox).Core.Layout.Responsive.useResponsiveLayout
local SignalsReact = require(DiscoveryMonolithParent.SignalsReact)
local OmniFeedConstants = require(DiscoveryMonolithParent.DiscoveryTypes).OmniFeedConstants
local useTokens = require(DiscoveryMonolithParent.Foundation).Hooks.useTokens
local useAppPolicy = require(DiscoveryMonolithParent.UniversalAppPolicy).useAppPolicy
local Modules = DiscoveryMonolith.Modules
local useGridFlexFeedItemBounds = require(Modules.Personalization.OmniFeed.useGridFlexFeedItemBounds)
local OmniFeedProps = require(Modules.Personalization.OmniFeed.OmniFeedProps)
local GameGridSelector = require(Modules.LuaApp.Components.Games.GameGridSelector)
local getCurrentPage = require(Modules.LuaApp.getCurrentPage)
local getEntitiesForPartialFeedItem = require(Modules.Personalization.OmniFeed.getEntitiesForPartialFeedItem)
local SearchSelectionTypeHeader = require(Modules.LuaApp.Components.Search.SearchTypeSelection.SearchSelectionTypeHeader)
local useUpdateFeedItemRenderedRows = require(Modules.Personalization.OmniFeed.DataStore.useUpdateFeedItemRenderedRows)
local CollectionViews = require(DiscoveryMonolithParent.CollectionViews)
local CollectionItemSize = CollectionViews.CollectionViewTypes.CollectionItemSize
local usePageSideMargin = CollectionViews.usePageSideMargin
local GameCollections = require(DiscoveryMonolithParent.GameCollections)
local GameCollectionGrid = GameCollections.GameCollectionGrid
local GameCollectionItemBuilder = GameCollections.GameCollectionItemBuilder
local GameCollectionItemTypes = GameCollections.GameCollectionItemTypes
local PlaceholderGameGrid = GameCollections.PlaceholderGameGrid
local FIntGameGridFlexFeedItemTileNumPerFeed = require(DiscoveryMonolithParent.SharedFlags).FIntGameGridFlexFeedItemTileNumPerFeed
local FIntLuaAppDelayImpressionsMaxUpdates = require(DiscoveryMonolithParent.SharedFlags).FIntLuaAppDelayImpressionsMaxUpdates
local FFlagLuaAppLayoutParamsInContext = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppLayoutParamsInContext
local FFlagLuaAppCompositionAlways = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppCompositionAlways
local FFlagLuaAppSearchPlaceholderGrid = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppSearchPlaceholderGrid
local FFlagSignalsNavP3hMisc = require(DiscoveryMonolithParent.SharedFlags).FFlagSignalsNavP3hMisc
local v49 = if not FFlagSignalsNavP3hMisc then nil else require(DiscoveryMonolithParent.NavigationRodux).GetLegacyNavigationStore
local v50 = game:DefineFastFlag("LuaAppDefaultInitialItemsPerRowForSearch", false)
local FFlagLuaAppEnableNxMRoduxApportioning = require(DiscoveryMonolithParent.SharedFlags).FFlagLuaAppEnableNxMRoduxApportioning
local t1 = {}
local t2 = {}

return function(t3: {[any]: any}) -- line: 88
	-- upvalues: OmniFeedProps (copy), FFlagLuaAppCompositionAlways (copy), t1 (copy), OmniFeedConstants (copy), useTokens (copy), useAppPolicy (copy), React (copy), useRoactService (copy), RoactAnalyticsCommonGameEvents (copy), RoactAnalytics (copy), AppEventIngestService (copy), useSelector (copy), FFlagSignalsNavP3hMisc (copy), v49 (copy), SignalsReact (copy), getCurrentPage (copy), FFlagLuaAppLayoutParamsInContext (copy), CollectionItemSize (copy), usePageSideMargin (copy), t2 (copy), LayoutConfig (copy), useResponsiveLayout (copy), v50 (copy), FFlagLuaAppSearchPlaceholderGrid (copy), FIntGameGridFlexFeedItemTileNumPerFeed (copy), FFlagLuaAppEnableNxMRoduxApportioning (copy), useGridFlexFeedItemBounds (copy), GameCollectionItemTypes (copy), ArgCheck (copy), getEntitiesForPartialFeedItem (copy), Cryo (copy), GameCollectionItemBuilder (copy), AppPage (copy), useUpdateFeedItemRenderedRows (copy), gamePlayIntent (copy), Context (copy), SendGameImpressions (copy), GameTileConstants (copy), PlaceholderGameGrid (copy), SearchSelectionTypeHeader (copy), SearchTypes (copy), GameCollectionGrid (copy), FIntLuaAppDelayImpressionsMaxUpdates (copy), GameSortImpressionsDetector (copy), GameGridSelector (copy), WaitForPropWrapper (copy)
	local searchUuid = t3.searchUuid
	local feedItemPosition = t3[OmniFeedProps.key].feedItemPosition
	local v57 = not not FFlagLuaAppCompositionAlways or t3[OmniFeedProps.key].appCompositionEnabled
	local v58 = t3.topicLayoutData or t1
	local v59 = v58[OmniFeedConstants.TopicLayoutDataKeys.ContainedTile]
	local v60 = v58[OmniFeedConstants.TopicLayoutDataKeys.ComponentType]
	local v61 = v60 == OmniFeedConstants.ComponentTypeDataKeys.GridTile
	local v62 = v58[OmniFeedConstants.TopicLayoutDataKeys.EnableCollectionGrid] or v61
	local v63 = useTokens()
	local v64 = useAppPolicy(function(p1) -- line: 103
		return p1.useGridPageLayout()
	end)
	local v65 = if not v61 or (v59 or not v64) then nil else v63.Padding.XXLarge
	local v66 = React.useMemo(function() -- line: 115
		-- upvalues: v65 (copy)
		return {
			verticalPadding = v65
		}
	end, { v65 })
	local v67 = useRoactService(RoactAnalyticsCommonGameEvents)
	local v68 = useRoactService(RoactAnalytics)
	local v69 = useRoactService(AppEventIngestService)
	local v70 = React.useRef(nil)
	local v71 = if not v62 then `SearchResults_{ searchUuid }_{ t3.topicId }_{ feedItemPosition }` else nil
	local v72 = useSelector(function(p2) -- line: 128
		-- upvalues: searchUuid (copy)
		return p2.Search.SearchesInGames[searchUuid]
	end)
	local name

	if FFlagSignalsNavP3hMisc then
		local v73 = v49(false)

		name = SignalsReact.useSignalState(v73.getCurrentPage).name
	else
		name = useSelector(function(p3) -- line: 136
			-- upvalues: getCurrentPage (copy)
			return getCurrentPage(p3)
		end)
	end

	local v75 = useSelector(function(p4) -- line: 140
		return p4.ScreenSize
	end)
	local v76

	if FFlagLuaAppCompositionAlways then
		v76 = nil
	elseif FFlagLuaAppLayoutParamsInContext then
		local sduiContext = t3[OmniFeedProps.key].sduiContext
		local Small = CollectionItemSize.Small
		local v79 = React.useCallback(function(p5) -- line: 153
			-- upvalues: sduiContext (copy), Small (copy)
			return sduiContext.getPageLayoutConfig(Small)(p5).sideMargin
		end, {
			Small,
			sduiContext.getPageLayoutConfig
		})

		v76 = SignalsReact.useSignalState(v79)
	else
		v76 = usePageSideMargin(t3[OmniFeedProps.key].verticalScrollingFrameRef.current)
	end

	local v80, v81 = React.useState(v75)
	local v82, v83 = React.useState(if not v57 then Vector2.new(v75.X - 2 * v76, v75.Y) else v75)

	local function v84(p6) -- line: 167
		-- upvalues: t3 (copy)
		local t4 = {}

		for _, v in ipairs(p6) do
			if v.topicId == t3.topicId then
				table.insert(t4, v)
			end
		end

		return t4
	end

	local v85 = React.useMemo(function() -- line: 177
		-- upvalues: v72 (copy), v84 (copy), t2 (copy)
		return v72 and v84(v72.entries) or t2
	end, { v72 })
	local v86, v87 = React.useState(v85)

	React.useEffect(function() -- line: 183
		-- upvalues: v87 (copy), v85 (copy)
		v87(v85)
	end, { v85 })

	local WithFooter = LayoutConfig.Kind.Experiences.WithFooter
	local v89 = useResponsiveLayout("columns", WithFooter)
	local v90, v91 = React.useState(if not v50 then v89 else v89 or 2)

	local function v92(p7) -- line: 212
		-- upvalues: v91 (copy)
		v91(p7)
	end

	local v93 = (not v58.numOfRows or not (v58.numOfRows >= 0)) and 1e999 or v58.numOfRows
	local v94 = nil

	if FFlagLuaAppSearchPlaceholderGrid then
		v94 = if not v93 or (not (v93 > 0) or v93 == 1e999) then math.floor(FIntGameGridFlexFeedItemTileNumPerFeed / v90) else v93
	end

	local v95 = `{ t3.topicId }_{ searchUuid }`
	local v96 = nil
	local u97 = nil
	local u98 = nil

	if not FFlagLuaAppEnableNxMRoduxApportioning then
		v96 = useGridFlexFeedItemBounds(v95, feedItemPosition, v90, v93, v86)
		u97 = v96 or {}
	end

	local v99 = not not v72 and (v72.emphasis or false)

	if FFlagLuaAppEnableNxMRoduxApportioning then
		u98 = React.useMemo(function() -- line: 242
			-- upvalues: v99 (copy), v86 (copy), GameCollectionItemTypes (copy)
			if v99 and #v86 > 0 then
				local v127 = table.clone(v86)
				local v128 = table.clone(v86[1])

				v128.componentType = GameCollectionItemTypes.GameCollectionItemType.EmphasisTile
				v127[1] = v128

				return v127
			end

			return v86
		end, {
			v86,
			v99
		})
		v96 = useGridFlexFeedItemBounds(v95, feedItemPosition, v90, v93, u98)
		u97 = v96 or {}
	end

	local v100 = u97.firstIndex == 1 and v99

	if v100 then
		ArgCheck.assert(v93 >= 2, "feed item with emphasis takes at least 2 rows")
	end

	local v101 = React.useMemo(function() -- line: 268
		-- upvalues: FFlagLuaAppEnableNxMRoduxApportioning (copy), u97 (ref), u98 (ref), v90 (copy), getEntitiesForPartialFeedItem (copy), v86 (copy), v99 (copy), v93 (copy), v62 (copy), v100 (copy), GameCollectionItemTypes (copy)
		local t5

		if FFlagLuaAppEnableNxMRoduxApportioning then
			t5 = {}

			local layout = u97.layout
			local v131 = u97.firstIndex or 1

			if layout and u98 then
				local n1 = 0

				for i = 1, #layout do
					local v134 = layout[i]

					if v134 then
						for j = 1, v90 do
							local v136 = v134[j]

							if v136 and v136 > 0 then
								local v137 = u98[v136]

								if v137 then
									local v138 = table.clone(v137)

									v138.uiIndex = v131 + n1
									v138.topicContentsIndex = v136
									table.insert(t5, v138)
									n1 += 1
								end
							end
						end
					end
				end
			end
		else
			t5 = getEntitiesForPartialFeedItem(v86, u97, v99, v90, v93)
		end

		if not v62 then
			for v139, v140 in t5 do
				v140.tileType = if not v100 or v139 ~= 1 then GameCollectionItemTypes.GameCollectionItemType.GameTile else GameCollectionItemTypes.GameCollectionItemType.EmphasisTile
			end
		end

		return t5
	end, {
		if not FFlagLuaAppEnableNxMRoduxApportioning then v86 else u98,
		u97,
		if not FFlagLuaAppEnableNxMRoduxApportioning then v99 else nil,
		if not FFlagLuaAppEnableNxMRoduxApportioning then v90 else nil,
		if not FFlagLuaAppEnableNxMRoduxApportioning then v93 else nil,
		v62,
		v100
	})
	local v102 = React.useMemo(function() -- line: 324
		-- upvalues: v62 (copy), FFlagLuaAppEnableNxMRoduxApportioning (copy), u97 (ref), u98 (ref), v90 (copy), Cryo (copy), GameCollectionItemBuilder (copy), v64 (copy), AppPage (copy), v100 (copy), GameCollectionItemTypes (copy), v101 (copy)
		if not v62 then
			return nil
		end

		if FFlagLuaAppEnableNxMRoduxApportioning then
			if not u97.layout then
				return {}
			end

			local v141 = u98

			if u98 then
				v141 = {}

				for i = 1, #u97.layout do
					local v143 = u97.layout[i]

					if v143 then
						for j = 1, v90 do
							local v145 = v143[j]

							if v145 and v145 > 0 then
								local v146 = u98[v145]

								if v146 then
									v141[v145] = Cryo.Dictionary.join(v146, {
										topicContentsIndex = v145
									})
								end
							end
						end
					end
				end
			end

			return GameCollectionItemBuilder.BuildCollectionEntries(v141, v90, nil, nil, not v64, AppPage.SearchPage, nil, nil, u97.layout)
		end

		local v147 = if not v100 then nil else {
			[1] = {
				colSpan = 2,
				rowSpan = 2
			}
		}
		local v148 = if not v100 then nil else {
			[1] = GameCollectionItemTypes.GameCollectionItemType.EmphasisTile
		}

		return GameCollectionItemBuilder.BuildCollectionEntries(v101, v90, v147, v148, not v64, AppPage.SearchPage, nil, nil)
	end, {
		if not FFlagLuaAppEnableNxMRoduxApportioning then v100 else nil,
		if not FFlagLuaAppEnableNxMRoduxApportioning then v101 else u98,
		v90,
		v64,
		v62,
		if not FFlagLuaAppEnableNxMRoduxApportioning then nil else u97
	})
	local showHeader = v58.showHeader
	local v104 = React.useMemo(function() -- line: 406
		-- upvalues: u97 (ref), FFlagLuaAppEnableNxMRoduxApportioning (copy), v90 (copy), v101 (copy), v93 (copy)
		if next(u97) == nil then
			return nil
		end

		if FFlagLuaAppEnableNxMRoduxApportioning then
			local v149 = if not u97.layout then nil else #u97.layout

			if not v149 then
				if v90 and v90 > 0 then
					return (math.ceil(#v101 / v90))
				end

				v149 = 0
			end

			return v149
		end

		local v150 = not (#v101 > 0) and 0 or v101[#v101].uiIndex
		local v151 = (not v150 or (not v90 or not (v90 > 0))) and 0 or math.ceil(v150 / v90)

		if not v93 or v93 < 0 or v151 < v93 then
			return v151
		end

		return v93
	end, {
		u97,
		v101,
		v90,
		if not FFlagLuaAppEnableNxMRoduxApportioning then v93 else nil
	})
	local feedItemStartRow = t3[OmniFeedProps.key].feedItemStartRow

	useUpdateFeedItemRenderedRows(AppPage.SearchPage, t3.searchUuid, feedItemPosition, v104)

	local v106 = React.useCallback(function(n2: number?) -- line: 442
		-- upvalues: feedItemStartRow (copy), v90 (copy)
		if not n2 or (not feedItemStartRow or not v90 or not (v90 > 0)) then
			return nil
		end

		local v153 = math.ceil(n2 / v90)

		return feedItemStartRow + v153 - 1
	end, {
		v90,
		feedItemStartRow
	})
	local v107 = not v62 and function(p8) -- line: 453
		-- upvalues: v101 (copy), v106 (copy), v67 (copy), name (ref), feedItemPosition (copy), t3 (copy), GameCollectionItemTypes (copy)
		local v155 = v101[p8]
		local v156 = v106(v155.uiIndex or p8)

		if v155 ~= nil then
			local v157 = v155.placeIdOverride or v155.placeId
			local isSponsored = v155.isSponsored
			local adId = v155.adId
			local v160 = #v101
			local universeId = v155.universeId
			local v162 = v155.topicContentsIndex or p8

			v67.reportOpenGameDetailFromSearch(v157, p8, v160, isSponsored, adId, universeId, name, feedItemPosition, t3.topicId, v156, v162, v155.tileType or GameCollectionItemTypes.GameCollectionItemType.GameTile)
		end
	end or nil
	local v108 = not v62 and function(p9) -- line: 485
		-- upvalues: v106 (copy), gamePlayIntent (copy), v69 (copy), Context (copy), feedItemPosition (copy), t3 (copy), name (ref), GameCollectionItemTypes (copy)
		local v164 = v106(p9.uiIndex or p9.index)
		local v165 = p9.topicContentsIndex or p9.index

		gamePlayIntent(v69, Context.SearchExperienceTile, {
			placeId = p9.placeIdOverride or p9.placeId,
			rootPlaceId = tonumber(p9.placeId),
			sortEntryIndex = tostring(p9.index),
			sortIndex = feedItemPosition,
			gameSetTypeId = t3.topicId,
			rowOnPage = v164,
			topicDataPosition = v165,
			universeId = p9.universeId,
			nativeAdData = p9.adId,
			pageName = name,
			launchData = p9.launchDataOverride,
			tileType = p9.tileType or GameCollectionItemTypes.GameCollectionItemType.GameTile
		})
	end or nil
	local v109 = not v62 and function(p10) -- line: 507
		-- upvalues: v72 (copy), searchUuid (copy), v100 (copy), feedItemPosition (copy), t3 (copy), SendGameImpressions (copy), v69 (copy), v68 (copy), v101 (copy), AppPage (copy), v90 (copy), feedItemStartRow (copy)
		if not v72 then
			return
		end

		local t6 = {
			seeAllFlag = 1,
			searchUuid = searchUuid,
			emphasisFlag = not v100 and 0 or 1,
			sortPos = feedItemPosition,
			gameSetTypeId = t3.topicId
		}

		SendGameImpressions.sendFromSearch(v69, v68, p10, v101, AppPage.SearchPage, t6, v90, feedItemStartRow)
	end or nil
	local Footer = GameTileConstants.PlayerCountStyleValues.Footer
	local v111 = React.useMemo(function() -- line: 533
		-- upvalues: searchUuid (copy), v100 (copy)
		return {
			searchUuid = searchUuid,
			hasEmphasizedTile = v100
		}
	end, {
		searchUuid,
		v100
	})

	if FFlagLuaAppSearchPlaceholderGrid and v96 == nil and #v86 > 0 then
		return React.createElement(PlaceholderGameGrid, {
			gridSupportAllowed = true,
			isHoverSupportEnabled = true,
			shouldHideTileMetadata = false,
			shouldHideTileTitle = false,
			onItemsPerRowChanged = if not v57 then v92 else nil,
			appCompositionEnabled = v57,
			useGridTiles = v61,
			componentType = v60,
			gameTileLayoutType = not v61 and "Narrow" or "Wide",
			numRows = v94,
			sideMargin = if not v57 then v76 else nil,
			verticalScrollingFrameRef = t3[OmniFeedProps.key].verticalScrollingFrameRef,
			containedTile = v59,
			headerComponent = if not showHeader then nil else React.createElement(SearchSelectionTypeHeader, {
				LayoutOrder = 1,
				selectionType = SearchTypes.Games
			})
		})
	end

	local v112 = if not v62 then nil else React.createElement(GameCollectionGrid, {
		friendFooterEnabled = false,
		isSponsoredFooterAllowed = true,
		gridSupportAllowed = true,
		isHoverSupportEnabled = true,
		playButtonStyle = "Default",
		shouldHideTileMetadata = false,
		shouldHideTileTitle = false,
		entries = v102,
		headerComponent = if not showHeader then nil else React.createElement(SearchSelectionTypeHeader, {
			LayoutOrder = 1,
			selectionType = SearchTypes.Games
		}),
		verticalScrollingFrameRef = t3[OmniFeedProps.key].verticalScrollingFrameRef,
		maxNumRows = v93,
		useGridTiles = v61,
		gameSortId = t3.topicId,
		sortIndex = feedItemPosition,
		pageContext = AppPage.SearchPage,
		scrollViewPositionChangedSignal = t3[OmniFeedProps.key].scrollViewPositionChangedSignal,
		playerCountStyle = Footer,
		componentType = v60,
		gameTileLayoutType = not v61 and "Narrow" or "Wide",
		onItemsPerRowChanged = v92,
		startRow = feedItemStartRow,
		sideMargin = if not v57 then v76 else nil,
		appCompositionEnabled = v57,
		numUpdatesToDelayImpressions = FIntLuaAppDelayImpressionsMaxUpdates,
		selectionOrderBase = t3[OmniFeedProps.key].selectionOrderBase,
		searchParams = v111,
		containedTile = v59,
		layoutOverrides = if not v57 then v66 else nil,
		launchExperienceEventContextOverride = Context.SearchExperienceTile
	})
	local v113 = if not v62 then React.createElement(GameSortImpressionsDetector, {
		parentRef = v70,
		pageContext = AppPage.SearchPage,
		impressionsTag = v71,
		scrollViewPositionChangedSignal = t3[OmniFeedProps.key].scrollViewPositionChangedSignal,
		sendGameImpressions = v109
	}) else nil

	return if not v62 then React.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		Position = UDim2.new(0, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		[React.Change.AbsoluteSize] = function(p11) -- line: 200
			-- upvalues: v81 (copy)
			if p11 then
				v81(p11.AbsoluteSize)
			end
		end,
		ref = v70
	}, {
		Layout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 16),
			[React.Change.AbsoluteContentSize] = function(p12) -- line: 187
				-- upvalues: v82 (copy), v83 (copy)
				if p12 then
					local AbsoluteContentSize = p12.AbsoluteContentSize

					if v82.X == AbsoluteContentSize.X and v82.Y == AbsoluteContentSize.Y then
						return
					end

					if AbsoluteContentSize.X > 0 and AbsoluteContentSize.Y > 0 then
						v83(AbsoluteContentSize)
					end
				end
			end
		}),
		Padding = if #v101 ~= 0 and not v57 then React.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v76),
			PaddingRight = UDim.new(0, v76)
		}) else nil,
		Header = if #v101 ~= 0 then if not showHeader then nil else React.createElement(SearchSelectionTypeHeader, {
			LayoutOrder = 1,
			selectionType = SearchTypes.Games
		}) else nil,
		GameGrid = React.createElement(GameGridSelector, {
			LayoutOrder = 2,
			source = "SearchResults",
			searchResultGrid = true,
			entries = v101,
			reportGameDetailOpened = v107,
			horizontalAlignment = Enum.HorizontalAlignment.Left,
			windowSize = Vector2.new(v82.X, v80.Y),
			screenSize = v75,
			gameEmphasis = v100,
			currentSidePadding = v76,
			scrollViewPositionChangedSignal = t3[OmniFeedProps.key].scrollViewPositionChangedSignal,
			impressionsTag = v71,
			reportExperienceLaunched = v108,
			launchExperienceEventContext = Context.SearchExperienceTile,
			onItemsPerRowChanged = v92,
			playerCountStyle = Footer,
			enableCollectionLayout = v58.enableCollectionLayout
		}),
		GameSortImpressionsDetector = React.createElement(WaitForPropWrapper, {
			waitForProp = feedItemStartRow,
			maxUpdatesToDelay = FIntLuaAppDelayImpressionsMaxUpdates,
			wrappedComponent = v113
		})
	}) else v112
end
