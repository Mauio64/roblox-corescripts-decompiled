local module = require("@luauforge/bundled/drY")
local module2 = require("@luauforge/bundled/drk")
local roactAnalyticsCommonGameEvents = module2.RoactAnalyticsCommonGameEvents
local roactAnalytics = module2.RoactAnalytics
local appEventIngestService = module2.AppEventIngestService
local module3 = require("@luauforge/bundled/dqE")
local module4 = require("@luauforge/bundled/dqd")
require("@luauforge/bundled/dqY")
local useSelector = require("@luauforge/bundled/dsv").Hooks.RoactRodux.useSelector
local gameSortImpressionsDetector = require("@luauforge/bundled/dsy").GameSortImpressionsDetector
local sendGameImpressions = require("@luauforge/bundled/dsy").SendGameImpressions
local waitForPropWrapper = require("@luauforge/bundled/dsy").WaitForPropWrapper
local useRoactService = require("@luauforge/bundled/dsp").useRoactService
local appPage = require("@luauforge/bundled/drn").AppPage
local searchTypes = require("@luauforge/bundled/drn").SearchTypes
local module5 = require("@luauforge/bundled/dqo")
local gamePlayIntent = module5.Events.gamePlayIntent
local context = module5.Constants.Context
local module6 = require("@luauforge/bundled/drl")
local gameTileConstants = module6.GameTileConstants
local getGameTileCollectionItemSize = module6.getGameTileCollectionItemSize
local layoutConfig = require("@luauforge/bundled/drn").LayoutConfig
local useResponsiveLayout = require("@luauforge/bundled/drd").Core.Layout.Responsive.useResponsiveLayout
local module7 = require("@luauforge/bundled/dvA")
local omniFeedConstants = require("@luauforge/bundled/dqn").OmniFeedConstants
local useTokens = require("@luauforge/bundled/dsg").Hooks.useTokens
local useAppPolicy = require("@luauforge/bundled/drN").useAppPolicy

local module8 = require("@luauforge/bundled/dvB")
local module9 = require("@luauforge/bundled/dvt")
local module10 = require("@luauforge/bundled/dsm")
local module11 = require("@luauforge/bundled/dvD")
local module12 = require("@luauforge/bundled/dvF")

local module13 = require("@luauforge/bundled/dte")

local module14 = require("@luauforge/bundled/dvr")
local module15 = require("@luauforge/bundled/dsr")
local collectionItemSize = module15.CollectionViewTypes.CollectionItemSize
local usePageSideMargin = module15.usePageSideMargin
local module16 = require("@luauforge/bundled/dsy")
local gameCollectionGrid = module16.GameCollectionGrid
local gameCollectionItemBuilder = module16.GameCollectionItemBuilder
local gameCollectionItemTypes = module16.GameCollectionItemTypes
local placeholderGameGrid = module16.PlaceholderGameGrid
local fIntGameGridFlexFeedItemTileNumPerFeed = require("@luauforge/bundled/dqB").FIntGameGridFlexFeedItemTileNumPerFeed
local fIntLuaAppDelayImpressionsMaxUpdates = require("@luauforge/bundled/dqB").FIntLuaAppDelayImpressionsMaxUpdates

local fFlagLuaAppLayoutParamsInContext = require("@luauforge/bundled/dqB").FFlagLuaAppLayoutParamsInContext
local fFlagLuaAppCompositionAlways = require("@luauforge/bundled/dqB").FFlagLuaAppCompositionAlways
local fFlagSignalsNavP3fGameDetails = require("@luauforge/bundled/dqB").FFlagSignalsNavP3fGameDetails
local fFlagLuaAppDemoModePlayButtonTelemetry = require("@luauforge/bundled/dqB").FFlagLuaAppDemoModePlayButtonTelemetry
local getLegacyNavigationStore

if fFlagSignalsNavP3fGameDetails then
	getLegacyNavigationStore = require("@luauforge/bundled/dvE").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local defineFastFlag = game:DefineFastFlag("LuaAppDefaultInitialItemsPerRowForSearch", false)
local fFlagLuaAppEnableNxMRoduxApportioning = require("@luauforge/bundled/dqB").FFlagLuaAppEnableNxMRoduxApportioning

local fFlagLuaAppSearchResultsPageGameTileVideo = require("@luauforge/bundled/dqB").FFlagLuaAppSearchResultsPageGameTileVideo

local defineFastFlag2 = game:DefineFastFlag("LuaAppCompositionFixEmphasisApportioning", false)

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

	local state4, setState4 = module.useState(defineFastFlag and (v25 or 2) or v25)

	local function onItemsPerRowChanged(p2)
		setState4(p2)
	end

	if defineFastFlag2 then
		local v27 = module15.useCollectionLayout(getGameTileCollectionItemSize(v10 and "Wide" or "Narrow"))

		if v7 then
			state4 = v27.itemsPerRow
		end
	end

	local v27 = not (topicLayoutData.numOfRows and topicLayoutData.numOfRows >= 0) and 1e999
		or topicLayoutData.numOfRows
	local v28

	if v27 and v27 > 0 and v27 ~= 1e999 then
		v28 = v27
	else
		v28 = math.floor(fIntGameGridFlexFeedItemTileNumPerFeed / state4)
	end

	local formatted = `{data.topicId}_{searchUuid}`

	local v29 = nil
	local v30, v31

	if fFlagLuaAppEnableNxMRoduxApportioning then
		v30 = nil
	else
		v31 = module8(formatted, feedItemPosition, state4, v27, state3)
		v30 = v31 or {}
	end

	local v32 = if v19 then v19.emphasis or false else false

	if fFlagLuaAppEnableNxMRoduxApportioning then
		v29 = module.useMemo(function()
			if not (v32 and #state3 > 0) then
				return state3
			end

			local clone = table.clone(state3)
			local clone2 = table.clone(state3[1])
			clone2.componentType = gameCollectionItemTypes.GameCollectionItemType.EmphasisTile
			clone[1] = clone2
			return clone
		end, { state3, v32 })
		v31 = module8(formatted, feedItemPosition, state4, v27, v29)

		v30 = v31 or {}
	end

	local v33 = v30.firstIndex == 1 and v32

	if v33 then
		module3.assert(v27 >= 2, "feed item with emphasis takes at least 2 rows")
	end

	local useMemo = module.useMemo
	local function fn4()
		local clones

		if fFlagLuaAppEnableNxMRoduxApportioning then
			clones = {}
			local layout = v30.layout
			local firstIndex = v30.firstIndex or 1

			if layout and v29 then
				local count = 0

				for i = 1, #layout do
					local v34 = layout[i]

					if not v34 then
						continue
					end

					for j = 1, state4 do
						local v35 = v34[j]

						if not (v35 and v35 > 0) then
							continue
						end

						local v36 = v29[v35]

						if not v36 then
							continue
						end

						local clone = table.clone(v36)
						clone.uiIndex = firstIndex + count
						clone.topicContentsIndex = v35
						table.insert(clones, clone)
						count += 1
					end
				end
			end
		else
			clones = module12(state3, v30, v32, state4, v27)
		end

		if v11 then
			return clones
		end

		for k, v34 in clones do
			local v35 = if v33 and k == 1 then gameCollectionItemTypes.GameCollectionItemType.EmphasisTile else gameCollectionItemTypes.GameCollectionItemType.GameTile
			v34.tileType = v35
		end

		return clones
	end

	local v35 = if fFlagLuaAppEnableNxMRoduxApportioning then v29 else state3
	local v37 = if not fFlagLuaAppEnableNxMRoduxApportioning then v32 else nil
	local v38 = if not fFlagLuaAppEnableNxMRoduxApportioning then state4 else nil
	local v40 = useMemo(fn4, {
		v35,
		v30,
		v37,
		v38,
		if not fFlagLuaAppEnableNxMRoduxApportioning then v27 else nil,
		v11,
		v33
	})

	local useMemo2 = module.useMemo
	local function fn5()
		if not v11 then
			return nil
		end

		if fFlagLuaAppEnableNxMRoduxApportioning then
			if not v30.layout then
				return {}
			end

			local values = v29

			if v29 then
				values = {}

				for i = 1, #v30.layout do
					local v41 = v30.layout[i]

					if not v41 then
						continue
					end

					for j = 1, state4 do
						local v42 = v41[j]

						if not (v42 and v42 > 0) then
							continue
						end

						local v43 = v29[v42]

						if v43 then
							values[v42] = module4.Dictionary.join(v43, {
								topicContentsIndex = v42
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
				v30.layout
			)
		else
			local v42 = v33 and { gameCollectionItemTypes.GameCollectionItemType.EmphasisTile } or nil
			return gameCollectionItemBuilder.BuildCollectionEntries(v40, state4, v33 and {
				{ colSpan = 2, rowSpan = 2 }
			} or nil, v42, not v13, appPage.SearchPage, nil, nil)
		end
	end

	local v42 = if not fFlagLuaAppEnableNxMRoduxApportioning then v33 else nil
	local v43 = if fFlagLuaAppEnableNxMRoduxApportioning then v29 else v40
	local v46 = useMemo2(fn5, {
		v42,
		v43,
		state4,
		v13,
		v11,
		if fFlagLuaAppEnableNxMRoduxApportioning then v30 else nil
	})

	local showHeader = topicLayoutData.showHeader

	local function fn6()
		if next(v30) == nil then
			return nil
		end

		if fFlagLuaAppEnableNxMRoduxApportioning then
			local v47 = v30.layout and #v30.layout or nil

			if v47 then
				return v47
			end

			if state4 and state4 > 0 then
				return (math.ceil(#v40 / state4))
			end

			v47 = 0
			return v47
		else
			local v47 = not (#v40 > 0) and 0 or v40[#v40].uiIndex

			local v48 = not (v47 and state4 and state4 > 0) and 0 or math.ceil(v47 / state4)

			if v27 and not (v27 < 0 or v48 < v27) then
				return v27
			end

			return v48
		end
	end

	local v51 = module.useMemo(fn6, {
		v30,
		v40,
		state4,
		if not fFlagLuaAppEnableNxMRoduxApportioning then v27 else nil
	})

	local feedItemStartRow = data[module9.key].feedItemStartRow
	module14(appPage.SearchPage, data.searchUuid, feedItemPosition, v51)

	local v52 = module.useCallback(function(p2)
		if p2 and feedItemStartRow and state4 and state4 > 0 then
			return feedItemStartRow + math.ceil(p2 / state4) - 1
		end

		return nil
	end, { state4, feedItemStartRow })

	local fn7 = not v11 and function(p2)
		local v53 = v40[p2]

		local v54 = v52(v53.uiIndex or p2)

		if v53 ~= nil then
			local placeIdOverride = v53.placeIdOverride or v53.placeId
			local isSponsored = v53.isSponsored
			local adId = v53.adId
			local v55 = #v40
			local universeId = v53.universeId
			local topicContentsIndex = v53.topicContentsIndex or p2

			v15.reportOpenGameDetailFromSearch(
				placeIdOverride,
				p2,
				v55,
				isSponsored,
				adId,
				universeId,
				v20,
				feedItemPosition,
				data.topicId,
				v54,
				topicContentsIndex,
				v53.tileType or gameCollectionItemTypes.GameCollectionItemType.GameTile
			)
		end
	end or nil

	local fn8 = not v11 and function(data2, p2, p3, p4, p5, actionType)
		local v53 = v52(data2.uiIndex or data2.index)
		local topicContentsIndex = data2.topicContentsIndex or data2.index

		local searchExperienceTile = context.SearchExperienceTile
		local v56 = {
			placeId = data2.placeIdOverride or data2.placeId,
			rootPlaceId = tonumber(data2.placeId),
			sortEntryIndex = tostring(data2.index),
			sortIndex = feedItemPosition,
			gameSetTypeId = data.topicId,
			rowOnPage = v53,
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

		v56.actionType = actionType
		gamePlayIntent(v17, searchExperienceTile, v56)
	end or nil

	local fn9 = not v11 and function(p2)
		if not v19 then
			return
		end

		local v53 = {
			searchUuid = searchUuid,
			emphasisFlag = v33 and 1 or 0,
			seeAllFlag = 1,
			sortPos = feedItemPosition,
			gameSetTypeId = data.topicId
		}

		sendGameImpressions.sendFromSearch(
			v17,
			v16,
			p2,
			v40,
			appPage.SearchPage,
			v53,
			state4,
			feedItemStartRow
		)
	end or nil

	local footer = gameTileConstants.PlayerCountStyleValues.Footer

	local v53 = module.useMemo(function()
		return { searchUuid = searchUuid, hasEmphasizedTile = v33 }
	end, { searchUuid, v33 })

	if v31 == nil and #state3 > 0 then
		local createElement = module.createElement

		if v7 then
			onItemsPerRowChanged = nil
		end

		local v55 = {
			onItemsPerRowChanged = onItemsPerRowChanged,
			appCompositionEnabled = v7,
			useGridTiles = v10,
			componentType = v9,
			gameTileLayoutType = v10 and "Wide" or "Narrow",
			gridSupportAllowed = true,
			isHoverSupportEnabled = true,
			numRows = v28,
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

		v55.sideMargin = v22
		v55.verticalScrollingFrameRef = data[module9.key].verticalScrollingFrameRef

		v55.containedTile = v8

		local v56 = if showHeader then module.createElement(module13, {
			LayoutOrder = 1,
			selectionType = searchTypes.Games
		}) else nil
		v55.headerComponent = v56
		return createElement(placeholderGameGrid, v55)
	else
		local v54

		if v11 then
			local createElement = module.createElement

			local v57 = if showHeader then module.createElement(module13, {
				LayoutOrder = 1,
				selectionType = searchTypes.Games
			}) else nil
			local v56 = {
				entries = v46,
				headerComponent = v57,
				verticalScrollingFrameRef = data[module9.key].verticalScrollingFrameRef,
				maxNumRows = v27,
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
				searchParams = v53,
				containedTile = v8,
				layoutOverrides = 0,
				launchExperienceEventContextOverride = 0,
				videoPlaybackContext = 0
			}

			if v7 then
				v14 = nil
			end

			v56.layoutOverrides = v14
			v56.launchExperienceEventContextOverride = context.SearchExperienceTile

			local v59 = if fFlagLuaAppSearchResultsPageGameTileVideo then data[module9.key].videoPlaybackContext else nil
			v56.videoPlaybackContext = v59
			v54 = createElement(gameCollectionGrid, v56)
		end

		local v55

		if not v11 then
			v55 = module.createElement(gameSortImpressionsDetector, {
				parentRef = ref,
				pageContext = appPage.SearchPage,
				impressionsTag = v18,
				scrollViewPositionChangedSignal = data[module9.key].scrollViewPositionChangedSignal,
				sendGameImpressions = fn9
			})
		end

		if v11 then
			return v54
		end

		local createElement = module.createElement
		local v57 = {
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

		local v59 = if #v40 ~= 0 and not v7 then module.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, v22),
			PaddingRight = UDim.new(0, v22)
		}) else nil
		children.Padding = v59

		local v60 = if #v40 ~= 0 and not not showHeader then module.createElement(module13, {
			LayoutOrder = 1,
			selectionType = searchTypes.Games
		}) else nil
		children.Header = v60

		children.GameGrid = module.createElement(module10, {
			LayoutOrder = 2,
			entries = v40,
			source = "SearchResults",
			reportGameDetailOpened = fn7,
			horizontalAlignment = Enum.HorizontalAlignment.Left,
			windowSize = Vector2.new(state2.X, state.Y),
			screenSize = v21,
			searchResultGrid = true,
			gameEmphasis = v33,
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
			wrappedComponent = v55
		})
		v54 = createElement("Frame", v57, children)
		return v54
	end
end
