local GuiService = game:GetService("GuiService")

local module = require("@luauforge/bundled/dva")
local module2 = require("@luauforge/bundled/dyB")
local module3 = require("@luauforge/bundled/dtf")
local useSelector = require("@luauforge/bundled/dvx").Hooks.RoactRodux.useSelector
local formFactor = require("@luauforge/bundled/dvq").Enums.FormFactor
local appPage = require("@luauforge/bundled/dup").AppPage
local parseBooleanString = require("@luauforge/bundled/dtM").parseBooleanString
require("@luauforge/bundled/dvA")
local gameCollectionGrid = require("@luauforge/bundled/dvA").GameCollectionGrid
local gameCollectionItemBuilder = require("@luauforge/bundled/dvA").GameCollectionItemBuilder
local gameCollectionItemTypes = require("@luauforge/bundled/dvA").GameCollectionItemTypes
local placeholderGameGrid = require("@luauforge/bundled/dvA").PlaceholderGameGrid
local module4 = require("@luauforge/bundled/dvt")
local module5 = require("@luauforge/bundled/dtp")
local omniFeedConstants = module5.OmniFeedConstants
local omniFeedTypes = module5.OmniFeedTypes
require("@luauforge/bundled/dun")
local getGameTileCollectionItemSize = require("@luauforge/bundled/dun").getGameTileCollectionItemSize
local topicContentsReducer = require("@luauforge/bundled/dtu").TopicContentsReducer
local getSduiFeedStore = require("@luauforge/bundled/duv").getSduiFeedStore
local module6 = require("@luauforge/bundled/dyC")
local module7 = require("@luauforge/bundled/dyD")
local module8 = require("@luauforge/bundled/dts")
local default = module8.default
local discoveryEventErrorLogger = require("@luauforge/bundled/dtM").DiscoveryEventErrorLogger
local apportioningDiagnosticTelemetry = require("@luauforge/bundled/dtM").ApportioningDiagnosticTelemetry
local showMoreClickEvent = require("@luauforge/bundled/dtq").Events.showMoreClickEvent

local module9 = require("@luauforge/bundled/dyu")

local module10 = require("@luauforge/bundled/dyE")
local module11 = require("@luauforge/bundled/dyw")
local module12 = require("@luauforge/bundled/dvi")
local chipSize = module12.Enums.ChipSize
local chipVariant = module12.Enums.ChipVariant
local iconName = module12.Enums.IconName
local useLocalization = require("@luauforge/bundled/duR").Hooks.useLocalization
local useAppPolicy = require("@luauforge/bundled/duP").useAppPolicy

local module13 = require("@luauforge/bundled/dtD")
local fIntGameGridFlexFeedItemTileNumPerFeed = module13.FIntGameGridFlexFeedItemTileNumPerFeed
local fIntLuaAppDelayImpressionsMaxUpdates = module13.FIntLuaAppDelayImpressionsMaxUpdates
local fFlagLuaAppRfySignalApportioning = require("@luauforge/bundled/dtD").FFlagLuaAppRfySignalApportioning
local fFlagLuaAppRfySignalApportioningIxp = require("@luauforge/bundled/dtD").FFlagLuaAppRfySignalApportioningIxp

local fFlagLuaAppFixHomeGridPlaceholderFlowIssues = require("@luauforge/bundled/dtD").FFlagLuaAppFixHomeGridPlaceholderFlowIssues
local defineFastFlag = game:DefineFastFlag("LuaAppAddPlaceholderRecoveryCounter", false)
local fFlagLuaAppEnableReportExperience = require("@luauforge/bundled/dtD").FFlagLuaAppEnableReportExperience

local fFlagLuaAppAddRequestIdToRfySignalApportioning = require("@luauforge/bundled/dtD").FFlagLuaAppAddRequestIdToRfySignalApportioning
local fFlagLuaAppCompositionAlways = require("@luauforge/bundled/dtD").FFlagLuaAppCompositionAlways
local fFlagLuaAppRfyRevealRows = require("@luauforge/bundled/dtD").FFlagLuaAppRfyRevealRows
local fFlagLuaAppEnableNxMRoduxApportioning = require("@luauforge/bundled/dtD").FFlagLuaAppEnableNxMRoduxApportioning

local fFlagLuaAppEnableOneByTwoTileFunnelTelemetry = require("@luauforge/bundled/dtD").FFlagLuaAppEnableOneByTwoTileFunnelTelemetry

local fFlagLuaAppEnableNxMApportioningExtraLogging = require("@luauforge/bundled/dtD").FFlagLuaAppEnableNxMApportioningExtraLogging
local fFlagLuaAppSortHeaderAnchorTag = module13.FFlagLuaAppSortHeaderAnchorTag
local fIntLuaAppGameGridRevealMoreButtonGapPx = module13.FIntLuaAppGameGridRevealMoreButtonGapPx

local GAME_CAROUSEL_SIDE_COMPACT_PADDING = module5.Constants.GAME_CAROUSEL_SIDE_COMPACT_PADDING
local GAME_CAROUSEL_SIDE_WIDE_PADDING = module5.Constants.GAME_CAROUSEL_SIDE_WIDE_PADDING

local v5 = {}
local v6 = if fFlagLuaAppRfySignalApportioning then false else nil
local v7 = if fFlagLuaAppRfySignalApportioning then false else nil
local fn, fn2, fn3

if fFlagLuaAppRfyRevealRows or fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
	fn = function(value)
		if type(value) ~= "number" then
			value = tonumber(value)
		end

		if not value then
			return nil
		end

		local v8 = math.floor(value)

		if v8 == value and not (v8 <= 0) then
			return v8
		end

		return nil
	end

	fn2 = function(p2, p3)
		if not (p2 and p3) then
			return nil, false
		end

		local v8 = p2 - p3 + 1

		if v8 <= 0 then
			return nil, true
		end

		return v8, false
	end

	fn3 = function(items, p2, p3): boolean
		local v8 = nil

		for k, item in items do
			if item.treatmentType == omniFeedTypes.HomeGameGrid and item.topicId == p3 then
				v8 = k
			end
		end

		return v8 == p2
	end
else
	fn = nil
	fn2 = nil
	fn3 = nil
end

return function(data)
	local verticalScrollingFrameRef = data[module11.key].verticalScrollingFrameRef
	local v8

	if fFlagLuaAppEnableReportExperience then
		v8 = useAppPolicy(function(p2)
			return p2.getGameReportingDisabled()
		end)
	end

	local v9 = nil

	local v10 = "Narrow"

	local v11 = nil
	local v12 = nil
	local v13 = nil
	local v14, v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, v26

	if data.topicLayoutData then
		v14 = data.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.ComponentType]

		if v14 then
			v10 = v14 == omniFeedConstants.ComponentTypeDataKeys.EventTile and "Event"
				or v14 == omniFeedConstants.ComponentTypeDataKeys.GridTile and "Wide"
				or v10

			v9 = v10 == "Wide" or v10 == "Event"
		end

		v15 = data.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.PlayerCountStyle]

		v16 = data.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.PlayButtonStyle]

		v17 = parseBooleanString(data.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.HideTileMetadata])

		v18 = parseBooleanString(data.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.HideTileTitle])

		v19 = parseBooleanString(data.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.ContainedTile])
		v20 = parseBooleanString(data.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.EnableExplicitFeedback])

		if fFlagLuaAppRfySignalApportioningIxp then
			v21 = parseBooleanString(data.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.EnableSignalApportioning])
		end

		v22 = data.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.SponsoredUserCohort]
		v23 = parseBooleanString(data.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.EnableSponsoredFeedback])

		v24 = parseBooleanString(data.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.EnableReportAd])

		if fFlagLuaAppEnableReportExperience then
			v25 = parseBooleanString(data.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.EnableReportExperience])
		end

		v26 = parseBooleanString(data.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.IsSponsoredRatingFooterAllowed])

		if fFlagLuaAppRfyRevealRows then
			v11 = fn(data.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.InitialFeedVisibleRows])

			v12 = fn(data.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.VisibleRowsPerReveal])
		end

		if fFlagLuaAppSortHeaderAnchorTag then
			v13 = data.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.SortHeaderAnchorTag]
		end
	end

	local v27 = if fFlagLuaAppEnableReportExperience then v25 and not v8 else nil
	local v28

	if data.topicLayoutData then
		local v29 = data.topicLayoutData[omniFeedConstants.TopicLayoutDataKeys.IsSponsoredFooterAllowed]
		v28 = not (v29 == nil) and v29 == "true"
	end

	local v29 = fFlagLuaAppRfySignalApportioning and (not fFlagLuaAppRfySignalApportioningIxp or v21)
	local appPage2 = data[module11.key].appPage

	local v30 = fFlagLuaAppCompositionAlways and true or data[module11.key].appCompositionEnabled
	assert(appPage2 == appPage.Home, "component only supports the Home Page")
	local feedItemStartRow = data[module11.key].feedItemStartRow
	local topicId = data.topicId
	local feedItemPosition = data[module11.key].feedItemPosition
	local sortIndex = data.sortIndex
	local topicName = data.topicName or ""
	local v31 = data.numberOfRows

	local sduiContext = if fFlagLuaAppRfySignalApportioning then data[module11.key].sduiContext else nil

	local gameTileCollectionItemSize = getGameTileCollectionItemSize(v10)
	local v32 = module4.useCollectionLayout(gameTileCollectionItemSize)

	local v33 = if fFlagLuaAppRfySignalApportioning then getSduiFeedStore(appPage2) else nil

	local setState = nil
	local state

	if fFlagLuaAppCompositionAlways then
		state = nil
	elseif fFlagLuaAppRfySignalApportioning then
		local v34 = module.useCallback(function(p2)
			return sduiContext.getPageLayoutConfig(gameTileCollectionItemSize)(p2).numColumns
		end, { gameTileCollectionItemSize, sduiContext.getPageLayoutConfig })
		state = module7.useSignalState(v34)
	else
		state, setState = module.useState(1)
	end

	if v30 then
		state = v32.itemsPerRow
	end

	local v34, v35

	if fFlagLuaAppRfyRevealRows then
		v34, v35 = fn2(v11, feedItemStartRow)
	else
		v34 = nil
		v35 = nil
	end

	local state2, v36, ref, v37, v38, v39

	if fFlagLuaAppRfyRevealRows then
		local setState2
		state2, setState2 = module.useState(v34)
		v36 = setState2
		ref = module.useRef(nil)

		v37 = module2.useMostRecentFocusBehavior(ref)
		v38 = module2.useFocusGuiObject()

		module.useEffect(function()
			v36(v34)
		end, { v34, data.topicId, data.sortIndex, data.recommendationsRequestId })

		v39 = useLocalization({
			showMoreButtonText = "CommonUI.Controls.Action.ShowMore"
		})
	else
		state2 = nil
		ref = nil
		v38 = nil
		v36 = nil
	end

	local v40 = useSelector(function(p2)
		return p2.FormFactor
	end)

	local v41 = useSelector(function(p2)
		return p2.Personalization[topicContentsReducer.key]
	end)

	local v42 = useSelector(function(p2)
		local omniRecommendation = p2.OmniRecommendations[appPage2]

		if omniRecommendation then
			return omniRecommendation.sorts
		end

		return {}
	end)
	local v43, v44

	if fFlagLuaAppRfyRevealRows then
		v43 = v34 ~= nil and v12 ~= nil

		v44 = if v43 then fn3(v42, data.sortIndex, data.topicId) else nil

		module.useEffect(function()
			if v43 and not v44 then
				discoveryEventErrorLogger.reportError(
					"HomeGameGridRevealRowsConfiguredBeforeLastGrid",
					"Reveal row fields are only supported on the last HomeGameGrid sort for the topic",
					{ topicId = data.topicId, sortIndex = data.sortIndex }
				)
			end
		end, { v43, v44, data.topicId, data.sortIndex })

		module.useEffect(function()
			if v35 then
				discoveryEventErrorLogger.reportError(
					"HomeGameGridRevealRowsInvalidFeedThreshold",
					"Unable to apply the feed row reveal threshold because its value or grid start row was invalid",
					{
						topicId = data.topicId,
						sortIndex = data.sortIndex,
						startRow = feedItemStartRow,
						initialFeedVisibleRows = v11
					}
				)
			end
		end, { v35, v11, feedItemStartRow, data.topicId, data.sortIndex })
	else
		v43 = nil
		v44 = nil
	end

	local v45

	if v31 and v31 > 0 then
		v45 = v31
	else
		v45 = math.floor(fIntGameGridFlexFeedItemTileNumPerFeed / state)
	end

	local v46

	if fFlagLuaAppRfySignalApportioning and not fFlagLuaAppRfySignalApportioningIxp then
		v46 = nil
	else
		local topicId2 = data.topicId

		local entries = v41 and v41[topicId] and v41[topicId].entries or v5
		local v49

		if fFlagLuaAppEnableOneByTwoTileFunnelTelemetry then
			v49 = fn3(v42, data.sortIndex, data.topicId)
		end

		v46 = module10(topicId2, feedItemPosition, state, v45, entries, v49)
	end

	local v47

	if fFlagLuaAppRfySignalApportioning then
		local v48 = v45 or 99999
		local v49 = v48 == -1 and 99999 or v48

		local useEffect = module.useEffect
		local function fn4()
			local v50 = state * v49
			local updateApportioningCapacity = v33.updateApportioningCapacity
			local topicId2 = data.topicId
			local sortIndex2 = data.sortIndex

			local v51 = if fFlagLuaAppAddRequestIdToRfySignalApportioning then data.recommendationsRequestId else nil
			updateApportioningCapacity(topicId2, sortIndex2, v50, v51)
		end

		local topicId2 = data.topicId
		local sortIndex2 = data.sortIndex

		local v53 = if fFlagLuaAppAddRequestIdToRfySignalApportioning then data.recommendationsRequestId else nil
		useEffect(fn4, { state, v49, topicId2, sortIndex2, v33, v53 })

		local useMemo = module.useMemo
		local function fn5()
			return module6.createComputed(function(p2)
				local getApportionedItems = v33.getApportionedItems
				local topicId3 = data.topicId
				local sortIndex3 = data.sortIndex
				local v54

				if fFlagLuaAppAddRequestIdToRfySignalApportioning then
					v54 = data.recommendationsRequestId
				end

				local v55 = getApportionedItems(topicId3, sortIndex3, v54)(p2)

				if not v55 then
					return nil
				end

				local getSingleGridApportioningMetadata = v33.getSingleGridApportioningMetadata
				local topicId4 = data.topicId
				local sortIndex4 = data.sortIndex
				local v56

				if fFlagLuaAppAddRequestIdToRfySignalApportioning then
					v56 = data.recommendationsRequestId
				end

				local v57 = getSingleGridApportioningMetadata(topicId4, sortIndex4, v56)(p2)

				local startingItemIndex = v57 and v57.startingItemIndex

				if not startingItemIndex and #v55 > 0 then
					discoveryEventErrorLogger.reportError(
						"HomeGameGridRenderingWithMissingStartingItemIndex",
						"Starting item index not found in apportioning data for topicId {props.topicId} and sortIndex {props.sortIndex}, defaulting to 1",
						{ topicId = data.topicId, sortIndex = data.sortIndex }
					)
				end

				local result = {}

				for k, v58 in v55 do
					table.insert(result, (module3.Dictionary.join(v58, {
						topicContentsIndex = (startingItemIndex or 1) + k - 1
					})))
				end

				return result
			end)
		end

		local topicId3 = data.topicId
		local sortIndex3 = data.sortIndex
		local v55 = if fFlagLuaAppAddRequestIdToRfySignalApportioning then data.recommendationsRequestId else nil
		local v56 = useMemo(fn5, { v33, topicId3, sortIndex3, v55 })

		v47 = module7.useSignalState(v56)
	end

	local v48

	if fFlagLuaAppRfySignalApportioning and not fFlagLuaAppRfySignalApportioningIxp then
		v48 = nil
	else
		local function fn4()
			local v49 = if topicId then v41 and v41[topicId] or nil else nil

			local entries = v49 and v49.entries or {}

			if v49 and v49.hasMoreRows then
				warn(`HomeGameGridFlexFeedItem may need to fetch more metadata for topicId {topicId}`)
			end

			if fFlagLuaAppEnableNxMRoduxApportioning then
				local layout = v46 and v46.layout

				if not layout then
					return {}
				end

				local firstIndex = v46 and v46.firstIndex or 1
				local count = 0
				local result = {}

				for i = 1, #layout do
					local v50 = layout[i]

					if not v50 then
						continue
					end

					for j = 1, state do
						local v51 = v50[j]

						if not (v51 and v51 > 0) then
							continue
						end

						local entry = entries[v51]

						if entry then
							result[v51] = module3.Dictionary.join(entry, {
								topicContentsIndex = firstIndex + count
							})
						end

						count += 1
					end
				end

				return result
			else
				local result = {}
				local firstIndex = v46 and v46.firstIndex or 1
				local entryIndices = v46 and v46.entryIndices

				if not entryIndices then
					return result
				end

				for i, entryIndice in ipairs(entryIndices) do
					local entry = entries[entryIndice]

					if entry then
						table.insert(result, module3.Dictionary.join(entry, {
							topicContentsIndex = firstIndex + i - 1
						}))
					end
				end

				return result
			end
		end

		v48 = module.useMemo(fn4, {
			topicId,
			v41,
			v42,
			v46,
			if fFlagLuaAppEnableNxMRoduxApportioning then state else nil
		})
	end

	if v29 then
		v48 = v47
	end

	local useMemo = module.useMemo
	local function fn4()
		if not v48 then
			return v48
		end

		local v49 = {}
		local twoByOneTiles = {}

		if not fFlagLuaAppEnableNxMRoduxApportioning then
			for k, v50 in v48 do
				if v50.componentType ~= gameCollectionItemTypes.GameCollectionItemType.TwoByOneTile then
					continue
				end

				v49[k] = {
					colSpan = 2,
					rowSpan = 1,
					alignmentType = v50.alignmentType,
					minRowPadding = tonumber(v50.minRowPadding) or 0
				}

				twoByOneTiles[k] = gameCollectionItemTypes.GameCollectionItemType.TwoByOneTile
			end
		end

		local buildCollectionEntries = gameCollectionItemBuilder.BuildCollectionEntries

		if fFlagLuaAppEnableNxMRoduxApportioning then
			v49 = nil
		end

		if fFlagLuaAppEnableNxMRoduxApportioning then
			twoByOneTiles = nil
		end

		local v56 = if fFlagLuaAppEnableNxMRoduxApportioning and not v29 then v46 and v46.layout or nil else nil
		return buildCollectionEntries(
			v48,
			state,
			v49,
			twoByOneTiles,
			nil,
			appPage2,
			sortIndex,
			topicId,
			v56
		)
	end

	local v51 = if fFlagLuaAppEnableNxMRoduxApportioning then v29 else nil
	local v52 = if fFlagLuaAppEnableNxMRoduxApportioning and not v29 then v46 else nil
	local v53 = useMemo(fn4, { v48, state, appPage2, sortIndex, topicId, v51, v52 })
	local v54

	if v29 and v53 or not v29 and v46 then
		if fFlagLuaAppEnableNxMRoduxApportioning and not v29 and v46 and v46.layout then
			v54 = #v46.layout
		else
			v54 = math.ceil(#v53 / state)
		end
	else
		v54 = nil
	end

	if fFlagLuaAppEnableNxMApportioningExtraLogging then
		module.useMemo(function(): nil
			if not (v29 and v53) and (v29 or not v46) then
				return nil
			end

			local v55 = v46 and v46.layout and #v46.layout or -1
			local v56 = v53 and #v53 or -1

			local v57 = not (state and state > 0 and v53) and -1 or math.ceil(v56 / state)

			local log = apportioningDiagnosticTelemetry.log
			local v59 = {
				layoutRowCount = v55,
				newContentCount = v56,
				ceilFormula = v57,
				itemsPerRow = state,
				usedLayoutBranch = 0,
				isSignalApportioningEnabled = 0,
				topicId = 0,
				sortIndex = 0,
				nxmApportioningFlagValue = 0
			}

			local v60 = fFlagLuaAppEnableNxMRoduxApportioning and not v29

			if v60 then
				v60 = not (v46 == nil) and v46.layout ~= nil
			end

			v59.usedLayoutBranch = v60

			v59.isSignalApportioningEnabled = v29
			v59.topicId = topicId
			v59.sortIndex = sortIndex
			v59.nxmApportioningFlagValue = fFlagLuaAppEnableNxMRoduxApportioning
			log("ActualNumberOfRowsComputed", v59)

			return nil
		end, { v53, v46, state, v29, topicId, sortIndex })
	end

	local v55, v56, v57, v58

	if fFlagLuaAppRfyRevealRows then
		v55 = v43 and v44

		if v55 then
			v55 = not (v54 == nil) and state2 ~= nil
		end

		v56 = if v55 then math.min(state2, v54) else v54

		v57 = v55 and v56 < v54

		v58 = module.useCallback(function()
			if state2 == nil or v54 == nil or v12 == nil then
				discoveryEventErrorLogger.reportError(
					"HomeGameGridRevealMoreMissingRowData",
					"Unable to reveal more HomeGameGrid rows because row data was missing",
					{
						topicId = data.topicId,
						sortIndex = data.sortIndex,
						hasVisibleRows = state2 ~= nil,
						hasActualNumberOfRows = v54 ~= nil,
						hasVisibleRowsPerReveal = v12 ~= nil
					}
				)

				return
			end

			local v60 = math.min(state2 + v12, v54)

			if GuiService.SelectedCoreObject ~= nil then
				local current = ref.current

				if current and v38 then
					v38(current)
				end
			end

			v36(v60)

			showMoreClickEvent(appPage2, {
				topicId = data.topicId,
				sortIndex = data.sortIndex,
				previousVisibleRows = state2,
				newVisibleRows = v60,
				totalNumberOfRows = v54,
				visibleRowsPerReveal = v12
			})
		end, { state2, v54, v12, data.topicId, data.sortIndex, appPage2, v38 })
	end

	local v61

	if fFlagLuaAppFixHomeGridPlaceholderFlowIssues then
		v61 = (if fFlagLuaAppRfyRevealRows then v56 else v54) or -1
	else
		v61 = if fFlagLuaAppRfyRevealRows then v56 else v54
	end

	module9(appPage2, nil, feedItemPosition, v61)

	if v29 and not v53 or not (#v53 > 0) then
		if v29 and v53 == nil or not v29 and v46 == nil then
			if fFlagLuaAppRfySignalApportioning and not v7 then
				default:logRobloxTelemetryCounter({
					eventName = "HomeGameGridReturnedPlaceholder",
					backends = { module8.TelemetryBackends.Counter }
				}, 1, {
					experimentTreatment = v21 == true and "signal_apportioning_treatment" or v21 == false and "control" or "not_in_experiment"
				})

				v7 = true
			end

			local createElement = module.createElement

			if v30 then
				setState = nil
			end

			local v64

			if not v30 then
				if v40 == formFactor.COMPACT then
					v64 = GAME_CAROUSEL_SIDE_COMPACT_PADDING
				else
					v64 = GAME_CAROUSEL_SIDE_WIDE_PADDING
				end
			end

			return createElement(placeholderGameGrid, {
				title = topicName,
				onItemsPerRowChanged = setState,
				appCompositionEnabled = v30,
				useGridTiles = v9,
				componentType = v14,
				gameTileLayoutType = v10,
				gridSupportAllowed = true,
				isHoverSupportEnabled = true,
				numRows = v45,
				sideMargin = v64,
				verticalScrollingFrameRef = verticalScrollingFrameRef,
				shouldHideTileMetadata = v17,
				shouldHideTileTitle = v18,
				containedTile = v19
			})
		end

		if fFlagLuaAppRfySignalApportioning and not v6 then
			default:logRobloxTelemetryCounter({
				eventName = "HomeGameGridReturnedNil",
				backends = { module8.TelemetryBackends.Counter }
			}, 1, {
				experimentTreatment = v21 == true and "signal_apportioning_treatment" or v21 == false and "control" or "not_in_experiment"
			})

			v6 = true
		end

		return nil
	else
		if fFlagLuaAppRfySignalApportioning and v6 then
			default:logRobloxTelemetryCounter({
				eventName = "HomeGameGridReturnedGridAfterNil",
				backends = { module8.TelemetryBackends.Counter }
			}, 1, {
				experimentTreatment = v21 == true and "signal_apportioning_treatment" or v21 == false and "control" or "not_in_experiment"
			})

			v6 = false
		end

		if defineFastFlag and v7 then
			default:logRobloxTelemetryCounter({
				eventName = "HomeGameGridReturnedGridAfterPlaceholder",
				backends = { module8.TelemetryBackends.Counter }
			}, 1, {
				experimentTreatment = v21 == true and "signal_apportioning_treatment" or v21 == false and "control" or "not_in_experiment"
			})

			v7 = false
		end

		local createElement = module.createElement
		local v63 = {}
		v63.entries = v53
		v63.title = topicName
		v63.friendFooterEnabled = true
		v63.sortIndex = sortIndex
		v63.gameSortId = topicId
		v63.pageContext = appPage2
		v63.scrollViewPositionChangedSignal = data[module11.key].scrollViewPositionChangedSignal

		if v30 then
			setState = nil
		end

		v63.onItemsPerRowChanged = setState
		v63.useGridTiles = v9
		v63.playerCountStyle = v15
		v63.isSponsoredFooterAllowed = v28
		v63.componentType = v14
		v63.gameTileLayoutType = v10
		v63.gridSupportAllowed = true
		v63.isHoverSupportEnabled = true
		v63.verticalScrollingFrameRef = verticalScrollingFrameRef
		v63.gridContainerRef = v37
		v63.startRow = feedItemStartRow
		v63.LayoutOrder = fFlagLuaAppRfyRevealRows and v55 and 1 or nil
		v63.ZIndex = fFlagLuaAppRfyRevealRows and v55 and 2 or nil

		if fFlagLuaAppRfyRevealRows and v55 then
			v31 = v56
		elseif not (v31 and v31 > 0) then
			v31 = nil
		end

		v63.maxNumRows = v31

		v63.playButtonStyle = v16
		local v64

		if not v30 then
			if v40 == formFactor.COMPACT then
				v64 = GAME_CAROUSEL_SIDE_COMPACT_PADDING
			else
				v64 = GAME_CAROUSEL_SIDE_WIDE_PADDING
			end
		end

		v63.sideMargin = v64

		v63.appCompositionEnabled = v30
		v63.shouldHideTileMetadata = v17
		v63.shouldHideTileTitle = v18
		v63.containedTile = v19
		v63.numUpdatesToDelayImpressions = fIntLuaAppDelayImpressionsMaxUpdates
		v63.selectionOrderBase = data[module11.key].selectionOrderBase
		v63.enableExplicitFeedback = v20
		v63.sponsoredUserCohort = v22
		v63.enableSponsoredFeedback = v23
		v63.enableReportAd = v24

		if not fFlagLuaAppEnableReportExperience then
			v27 = nil
		end

		v63.enableReportExperience = v27
		v63.isSponsoredRatingFooterAllowed = v26
		v63.videoPlaybackContext = data[module11.key].videoPlaybackContext

		if not fFlagLuaAppSortHeaderAnchorTag then
			v13 = nil
		end

		v63.headerTag = v13
		local element = createElement(gameCollectionGrid, v63)

		if not (fFlagLuaAppRfyRevealRows and v55) then
			return element
		end

		local createElement2 = module.createElement
		local v66 = {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1
		}

		local v67 = {
			UIListLayout = module.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, fIntLuaAppGameGridRevealMoreButtonGapPx)
			}),
			GameGrid = element,
			RevealMoreButton = 0
		}

		local v68 = if v57 then module.createElement(
			module12.View,
			{
				tag = "row align-y-center gap-xsmall size-full-0 auto-y",
				LayoutOrder = 2,
				ZIndex = 1
			},
			{
				LeadingLine = module.createElement(module12.View, {
					tag = "grow",
					LayoutOrder = 1
				}, {
					Divider = module.createElement(module12.Divider)
				}),
				ButtonOutline = module.createElement(
					module12.View,
					{ tag = "auto-xy stroke-default radius-circle", LayoutOrder = 2 },
					{
						Chip = module.createElement(module12.Chip, {
							text = v39.showMoreButtonText,
							trailing = iconName.ChevronLargeDown,
							size = chipSize.Large,
							variant = chipVariant.Utility,
							onActivated = v58
						})
					}
				),
				TrailingLine = module.createElement(module12.View, {
					tag = "grow",
					LayoutOrder = 3
				}, {
					Divider = module.createElement(module12.Divider)
				})
			}
		) else nil
		v67.RevealMoreButton = v68
		return createElement2("Frame", v66, v67)
	end
end
