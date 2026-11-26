local module = require("@luauforge/bundled/dva")
local module2 = require("@luauforge/bundled/dum")
local roactAnalyticsCommonGameEvents = module2.RoactAnalyticsCommonGameEvents
local roactAnalytics = module2.RoactAnalytics
local appEventIngestService = module2.AppEventIngestService
local module3 = require("@luauforge/bundled/dtG")
local module4 = require("@luauforge/bundled/dtf")
require("@luauforge/bundled/dua")
local useSelector = require("@luauforge/bundled/dvx").Hooks.RoactRodux.useSelector
local gameSortImpressionsDetector = require("@luauforge/bundled/dvA").GameSortImpressionsDetector
local sendGameImpressions = require("@luauforge/bundled/dvA").SendGameImpressions
local waitForPropWrapper = require("@luauforge/bundled/dvA").WaitForPropWrapper
local useRoactService = require("@luauforge/bundled/dvr").useRoactService
local appPage = require("@luauforge/bundled/dup").AppPage
local searchTypes = require("@luauforge/bundled/dup").SearchTypes
local module5 = require("@luauforge/bundled/dtq")
local gamePlayIntent = module5.Events.gamePlayIntent
local context = module5.Constants.Context
local module6 = require("@luauforge/bundled/dun")
local gameTileConstants = module6.GameTileConstants
local getGameTileCollectionItemSize = module6.getGameTileCollectionItemSize
local layoutConfig = require("@luauforge/bundled/dup").LayoutConfig
local useResponsiveLayout = require("@luauforge/bundled/duf").Core.Layout.Responsive.useResponsiveLayout
local module7 = require("@luauforge/bundled/dyD")
local omniFeedConstants = require("@luauforge/bundled/dtp").OmniFeedConstants
local useTokens = require("@luauforge/bundled/dvi").Hooks.useTokens
local useAppPolicy = require("@luauforge/bundled/duP").useAppPolicy

local module8 = require("@luauforge/bundled/dyE")
local module9 = require("@luauforge/bundled/dyw")
local module10 = require("@luauforge/bundled/dvo")
local module11 = require("@luauforge/bundled/dyG")
local module12 = require("@luauforge/bundled/dyI")

local module13 = require("@luauforge/bundled/dwg")

local module14 = require("@luauforge/bundled/dyu")
local module15 = require("@luauforge/bundled/dvt")
local collectionItemSize = module15.CollectionViewTypes.CollectionItemSize
local usePageSideMargin = module15.usePageSideMargin
local module16 = require("@luauforge/bundled/dvA")
local gameCollectionGrid = module16.GameCollectionGrid
local gameCollectionItemBuilder = module16.GameCollectionItemBuilder
local gameCollectionItemTypes = module16.GameCollectionItemTypes
local placeholderGameGrid = module16.PlaceholderGameGrid
local fIntGameGridFlexFeedItemTileNumPerFeed = require("@luauforge/bundled/dtD").FIntGameGridFlexFeedItemTileNumPerFeed
local fIntLuaAppDelayImpressionsMaxUpdates = require("@luauforge/bundled/dtD").FIntLuaAppDelayImpressionsMaxUpdates

local fFlagLuaAppLayoutParamsInContext = require("@luauforge/bundled/dtD").FFlagLuaAppLayoutParamsInContext
local fFlagLuaAppCompositionAlways = require("@luauforge/bundled/dtD").FFlagLuaAppCompositionAlways
local fFlagSignalsNavP3fGameDetails = require("@luauforge/bundled/dtD").FFlagSignalsNavP3fGameDetails
local fFlagLuaAppDemoModePlayButtonTelemetry = require("@luauforge/bundled/dtD").FFlagLuaAppDemoModePlayButtonTelemetry
local getLegacyNavigationStore

if fFlagSignalsNavP3fGameDetails then
	getLegacyNavigationStore = require("@luauforge/bundled/dyH").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local fFlagLuaAppEnableNxMRoduxApportioning = require("@luauforge/bundled/dtD").FFlagLuaAppEnableNxMRoduxApportioning

local fFlagLuaAppSearchResultsPageGameTileVideo = require("@luauforge/bundled/dtD").FFlagLuaAppSearchResultsPageGameTileVideo

local v5 = {}
local v6 = {}

return function(data)
	local searchUuid = data.searchUuid
	local feedItemPosition = data[module9.key].feedItemPosition

	local v7 = fFlagLuaAppCompositionAlways and true or data[module9.key].appCompositionEnabled

	local topicLayoutData = data.topicLayoutData or v5
	local v8 = topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.ContainedTile]
	local v9 = topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.ComponentType]
	local v10 = v9 == omniFeedConstants.ComponentTypeDataKeys.GridTile
	local v11 = topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.EnableCollectionGrid] or v10

	local v12 = useTokens()
	local v13 = useAppPolicy(function(p2)
		return p2.useGridPageLayout()
	end)

	local xxLarge = if v10 and not v8 and v13 then v12.Padding.XXLarge else nil

	local v14 = module.useMemo(function()
		return { verticalPadding = xxLarge }
	end, { xxLarge })

	local v15 = useRoactService(roactAnalyticsCommonGameEvents)
	local v16 = useRoactService(roactAnalytics)
	local v17 = useRoactService(appEventIngestService)
	local ref = module.useRef(nil)

	local v18 = if not v11 then `SearchResults_{searchUuid}_{data.topicId}_{feedItemPosition}` else nil
	local v19 = useSelector(function(p2)
		return p2.Search.SearchesInGames[searchUuid]
	end)
	local v20

	if fFlagSignalsNavP3fGameDetails then
		v20 = getLegacyNavigationStore(false).getCurrentPageName(false)
	else
		v20 = useSelector(function(p2)
			return module11(p2)
		end)
	end

	local v21 = useSelector(function(p2)
		return p2.ScreenSize
	end)
	local v22

	if not fFlagLuaAppCompositionAlways then
		if fFlagLuaAppLayoutParamsInContext then
			local sduiContext = data[module9.key].sduiContext

			local small = collectionItemSize.Small
			local v23 = module.useCallback(function(p2)
				return sduiContext.getPageLayoutConfig(small)(p2).sideMargin
			end, { small, sduiContext.getPageLayoutConfig })
			v22 = module7.useSignalState(v23)
		else
			v22 = usePageSideMargin(data[module9.key].verticalScrollingFrameRef.current)
		end
	end

	local state, setState = module.useState(v21)
	local useState = module.useState
	local v23 = if v7 then v21 else Vector2.new(v21.X - 2 * v22, v21.Y)
	local state2, setState2 = useState(v23)

	local function fn(entries)
		local result = {}

		for i, item in ipairs(entries) do
			if item.topicId == data.topicId then
				table.insert(result, item)
			end
		end

		return result
	end

	local v24 = module.useMemo(function()
		return v19 and fn(v19.entries) or v6
	end, { v19 })

	local state3, setState3 = module.useState(v24)

	module.useEffect(function()
		setState3(v24)
	end, { v24 })

	local function fn2(p2)
		if p2 then
			local absoluteContentSize = p2.AbsoluteContentSize

			if state2.X == absoluteContentSize.X and state2.Y == absoluteContentSize.Y then
				return
			end

			if absoluteContentSize.X > 0 and absoluteContentSize.Y > 0 then
				setState2(absoluteContentSize)
			end
		end
	end

	local function fn3(p2)
		if p2 then
			setState(p2.AbsoluteSize)
		end
	end

	local v25 = useResponsiveLayout("columns", layoutConfig.Kind.Experiences.WithFooter)

	local state4, setState4 = module.useState(v25 or 2)
	local function onItemsPerRowChanged(p2)
		setState4(p2)
	end

	local v27 = module15.useCollectionLayout(getGameTileCollectionItemSize(v10 and "Wide" or "Narrow"))

	if v7 then
		state4 = v27.itemsPerRow
	end

	local v28 = not (topicLayoutData.numOfRows and topicLayoutData.numOfRows >= 0) and 1e999
		or topicLayoutData.numOfRows
	local v29

	if v28 and v28 > 0 and v28 ~= 1e999 then
		v29 = v28
	else
		v29 = math.floor(fIntGameGridFlexFeedItemTileNumPerFeed / state4)
	end

	local formatted = `{data.topicId}_{searchUuid}`

	local v30 = nil
	local v31, v32

	if fFlagLuaAppEnableNxMRoduxApportioning then
		v31 = nil
	else
		v32 = module8(formatted, feedItemPosition, state4, v28, state3)
		v31 = v32 or {}
	end

	local v33 = if v19 then v19.emphasis or false else false

	if fFlagLuaAppEnableNxMRoduxApportioning then
		v30 = module.useMemo(function()
			if not (v33 and #state3 > 0) then
				return state3
			end

			local clone = table.clone(state3)
			local clone2 = table.clone(state3[1])
			clone2.componentType = gameCollectionItemTypes.GameCollectionItemType.EmphasisTile
			clone[1] = clone2
			return clone
		end, { state3, v33 })
		v32 = module8(formatted, feedItemPosition, state4, v28, v30)

		v31 = v32 or {}
	end

	local v34 = v31.firstIndex == 1 and v33

	if v34 then
		module3.assert(v28 >= 2, "feed item with emphasis takes at least 2 rows")
	end

	local useMemo = module.useMemo
	local function fn4()
		local clones

		if fFlagLuaAppEnableNxMRoduxApportioning then
			clones = {}
			local layout = v31.layout
			local firstIndex = v31.firstIndex or 1

			if layout and v30 then
				local count = 0

				for i = 1, #layout do
					local v35 = layout[i]

					if not v35 then
						continue
					end

					for j = 1, state4 do
						local v36 = v35[j]

						if not (v36 and v36 > 0) then
							continue
						end

						local v37 = v30[v36]

						if not v37 then
							continue
						end

						local clone = table.clone(v37)
						clone.uiIndex = firstIndex + count
						clone.topicContentsIndex = v36
						table.insert(clones, clone)
						count += 1
					end
				end
			end
		else
			clones = module12(state3, v31, v33, state4, v28)
		end

		if v11 then
			return clones
		end

		for k, v35 in clones do
			local v36 = if v34 and k == 1 then gameCollectionItemTypes.GameCollectionItemType.EmphasisTile else gameCollectionItemTypes.GameCollectionItemType.GameTile
			v35.tileType = v36
		end

		return clones
	end

	local v36 = if fFlagLuaAppEnableNxMRoduxApportioning then v30 else state3
	local v38 = if not fFlagLuaAppEnableNxMRoduxApportioning then v33 else nil
	local v39 = if not fFlagLuaAppEnableNxMRoduxApportioning then state4 else nil
	local v41 = useMemo(fn4, {
		v36,
		v31,
		v38,
		v39,
		if not fFlagLuaAppEnableNxMRoduxApportioning then v28 else nil,
		v11,
		v34
	})

	local useMemo2 = module.useMemo
	local function fn5()
		if not v11 then
			return nil
		end

		if fFlagLuaAppEnableNxMRoduxApportioning then
			if not v31.layout then
				return {}
			end

			local values = v30

			if v30 then
				values = {}

				for i = 1, #v31.layout do
					local v42 = v31.layout[i]

					if not v42 then
						continue
					end

					for j = 1, state4 do
						local v43 = v42[j]

						if not (v43 and v43 > 0) then
							continue
						end

						local v44 = v30[v43]

						if v44 then
							values[v43] = module4.Dictionary.join(v44, {
								topicContentsIndex = v43
							})
						end
					end
				end
			end

			return gameCollectionItemBuilder.BuildCollectionEntries(
				values,
				state4,
				nil,
				nil,
				not v13,
				appPage.SearchPage,
				nil,
				nil,
				v31.layout
			)
		else
			local v43 = v34 and { gameCollectionItemTypes.GameCollectionItemType.EmphasisTile } or nil
			return gameCollectionItemBuilder.BuildCollectionEntries(v41, state4, v34 and {
				{ colSpan = 2, rowSpan = 2 }
			} or nil, v43, not v13, appPage.SearchPage, nil, nil)
		end
	end

	local v43 = if not fFlagLuaAppEnableNxMRoduxApportioning then v34 else nil
	local v44 = if fFlagLuaAppEnableNxMRoduxApportioning then v30 else v41
	local v47 = useMemo2(fn5, {
		v43,
		v44,
		state4,
		v13,
		v11,
		if fFlagLuaAppEnableNxMRoduxApportioning then v31 else nil
	})

	local showHeader = topicLayoutData.showHeader

	local function fn6()
		if next(v31) == nil then
			return nil
		end

		if fFlagLuaAppEnableNxMRoduxApportioning then
			local v48 = v31.layout and #v31.layout or nil

			if v48 then
				return v48
			end

			if state4 and state4 > 0 then
				return (math.ceil(#v41 / state4))
			end

			v48 = 0
			return v48
		else
			local v48 = not (#v41 > 0) and 0 or v41[#v41].uiIndex

			local v49 = not (v48 and state4 and state4 > 0) and 0 or math.ceil(v48 / state4)

			if v28 and not (v28 < 0 or v49 < v28) then
				return v28
			end

			return v49
		end
	end

	local v52 = module.useMemo(fn6, {
		v31,
		v41,
		state4,
		if not fFlagLuaAppEnableNxMRoduxApportioning then v28 else nil
	})

	local feedItemStartRow = data[module9.key].feedItemStartRow
	module14(appPage.SearchPage, data.searchUuid, feedItemPosition, v52)

	local v53 = module.useCallback(function(p2)
		if p2 and feedItemStartRow and state4 and state4 > 0 then
			return feedItemStartRow + math.ceil(p2 / state4) - 1
		end

		return nil
	end, { state4, feedItemStartRow })

	local fn7 = not v11 and function(p2)
		local v54 = v41[p2]

		local v55 = v53(v54.uiIndex or p2)

		if v54 ~= nil then
			local placeIdOverride = v54.placeIdOverride or v54.placeId
			local isSponsored = v54.isSponsored
			local adId = v54.adId
			local v56 = #v41
			local universeId = v54.universeId
			local topicContentsIndex = v54.topicContentsIndex or p2

			v15.reportOpenGameDetailFromSearch(
				placeIdOverride,
				p2,
				v56,
				isSponsored,
				adId,
				universeId,
				v20,
				feedItemPosition,
				data.topicId,
				v55,
				topicContentsIndex,
				v54.tileType or gameCollectionItemTypes.GameCollectionItemType.GameTile
			)
		end
	end or nil

	local fn8 = not v11 and function(data2, p2, p3, p4, p5, actionType)
		local v54 = v53(data2.uiIndex or data2.index)
		local topicContentsIndex = data2.topicContentsIndex or data2.index

		local searchExperienceTile = context.SearchExperienceTile
		local v57 = {
			placeId = data2.placeIdOverride or data2.placeId,
			rootPlaceId = tonumber(data2.placeId),
			sortEntryIndex = tostring(data2.index),
			sortIndex = feedItemPosition,
			gameSetTypeId = data.topicId,
			rowOnPage = v54,
			topicDataPosition = topicContentsIndex,
			universeId = data2.universeId,
			nativeAdData = data2.adId,
			pageName = v20,
			launchData = data2.launchDataOverride,
			tileType = data2.tileType or gameCollectionItemTypes.GameCollectionItemType.GameTile,
			actionType = 0
		}

		if not fFlagLuaAppDemoModePlayButtonTelemetry then
			actionType = nil
		end

		v57.actionType = actionType
		gamePlayIntent(v17, searchExperienceTile, v57)
	end or nil

	local fn9 = not v11 and function(p2)
		if not v19 then
			return
		end

		local v54 = {
			searchUuid = searchUuid,
			emphasisFlag = v34 and 1 or 0,
			seeAllFlag = 1,
			sortPos = feedItemPosition,
			gameSetTypeId = data.topicId
		}

		sendGameImpressions.sendFromSearch(
			v17,
			v16,
			p2,
			v41,
			appPage.SearchPage,
			v54,
			state4,
			feedItemStartRow
		)
	end or nil

	local footer = gameTileConstants.PlayerCountStyleValues.Footer

	local v54 = module.useMemo(function()
		return { searchUuid = searchUuid, hasEmphasizedTile = v34 }
	end, { searchUuid, v34 })

	if v32 == nil and #state3 > 0 then
		local createElement = module.createElement

		if v7 then
			onItemsPerRowChanged = nil
		end

		local v56 = {
			onItemsPerRowChanged = onItemsPerRowChanged,
			appCompositionEnabled = v7,
			useGridTiles = v10,
			componentType = v9,
			gameTileLayoutType = v10 and "Wide" or "Narrow",
			gridSupportAllowed = true,
			isHoverSupportEnabled = true,
			numRows = v29,
			sideMargin = nil,
			verticalScrollingFrameRef = 0,
			shouldHideTileMetadata = false,
			shouldHideTileTitle = false,
			containedTile = 0,
			headerComponent = 0
		}

		if v7 then
			v22 = nil
		end

		v56.sideMargin = v22
		v56.verticalScrollingFrameRef = data[module9.key].verticalScrollingFrameRef

		v56.containedTile = v8

		local v57 = if showHeader then module.createElement(module13, {
			LayoutOrder = 1,
			selectionType = searchTypes.Games
		}) else nil
		v56.headerComponent = v57
		return createElement(placeholderGameGrid, v56)
	else
		local v55

		if v11 then
			local createElement = module.createElement

			local v58 = if showHeader then module.createElement(module13, {
				LayoutOrder = 1,
				selectionType = searchTypes.Games
			}) else nil
			local v57 = {
				entries = v47,
				headerComponent = v58,
				verticalScrollingFrameRef = data[module9.key].verticalScrollingFrameRef,
				maxNumRows = v28,
				useGridTiles = v10,
				gameSortId = data.topicId,
				sortIndex = feedItemPosition,
				pageContext = appPage.SearchPage,
				scrollViewPositionChangedSignal = data[module9.key].scrollViewPositionChangedSignal,
				friendFooterEnabled = false,
				playerCountStyle = footer,
				isSponsoredFooterAllowed = true,
				componentType = v9,
				gameTileLayoutType = v10 and "Wide" or "Narrow",
				gridSupportAllowed = true,
				isHoverSupportEnabled = true,
				onItemsPerRowChanged = onItemsPerRowChanged,
				startRow = feedItemStartRow,
				playButtonStyle = "Default",
				sideMargin = if not v7 then v22 else nil,
				appCompositionEnabled = v7,
				shouldHideTileMetadata = false,
				shouldHideTileTitle = false,
				numUpdatesToDelayImpressions = fIntLuaAppDelayImpressionsMaxUpdates,
				selectionOrderBase = data[module9.key].selectionOrderBase,
				searchParams = v54,
				containedTile = v8,
				layoutOverrides = 0,
				launchExperienceEventContextOverride = 0,
				videoPlaybackContext = 0
			}

			if v7 then
				v14 = nil
			end

			v57.layoutOverrides = v14
			v57.launchExperienceEventContextOverride = context.SearchExperienceTile

			local v60 = if fFlagLuaAppSearchResultsPageGameTileVideo then data[module9.key].videoPlaybackContext else nil
			v57.videoPlaybackContext = v60
			v55 = createElement(gameCollectionGrid, v57)
		end

		local v56

		if not v11 then
			v56 = module.createElement(gameSortImpressionsDetector, {
				parentRef = ref,
				pageContext = appPage.SearchPage,
				impressionsTag = v18,
				scrollViewPositionChangedSignal = data[module9.key].scrollViewPositionChangedSignal,
				sendGameImpressions = fn9
			})
		end

		if v11 then
			return v55
		end

		local createElement = module.createElement
		local v58 = {
			Size = UDim2.new(1, 0, 0, 0),
			Position = UDim2.new(0, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			[module.Change.AbsoluteSize] = fn3,
			ref = ref
		}

		local children = {
			Layout = module.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 16),
				[module.Change.AbsoluteContentSize] = fn2
			}),
			Padding = 0,
			Header = 0,
			GameGrid = 0,
			GameSortImpressionsDetector = 0
		}

		local v60 = if #v41 ~= 0 and not v7 then module.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v22),
			PaddingRight = UDim.new(0, v22)
		}) else nil
		children.Padding = v60

		local v61 = if #v41 ~= 0 and not not showHeader then module.createElement(module13, {
			LayoutOrder = 1,
			selectionType = searchTypes.Games
		}) else nil
		children.Header = v61

		children.GameGrid = module.createElement(module10, {
			LayoutOrder = 2,
			entries = v41,
			source = "SearchResults",
			reportGameDetailOpened = fn7,
			horizontalAlignment = Enum.HorizontalAlignment.Left,
			windowSize = Vector2.new(state2.X, state.Y),
			screenSize = v21,
			searchResultGrid = true,
			gameEmphasis = v34,
			currentSidePadding = v22,
			scrollViewPositionChangedSignal = data[module9.key].scrollViewPositionChangedSignal,
			impressionsTag = v18,
			reportExperienceLaunched = fn8,
			launchExperienceEventContext = context.SearchExperienceTile,
			onItemsPerRowChanged = onItemsPerRowChanged,
			playerCountStyle = footer,
			enableCollectionLayout = topicLayoutData.enableCollectionLayout
		})

		children.GameSortImpressionsDetector = module.createElement(waitForPropWrapper, {
			waitForProp = feedItemStartRow,
			maxUpdatesToDelay = fIntLuaAppDelayImpressionsMaxUpdates,
			wrappedComponent = v56
		})
		v55 = createElement("Frame", v58, children)
		return v55
	end
end
