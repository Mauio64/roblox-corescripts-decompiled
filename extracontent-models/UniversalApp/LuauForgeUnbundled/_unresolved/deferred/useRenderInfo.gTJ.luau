local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local tutils = require(CorePackages.Packages.tutils)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
require("@game/CorePackages/Workspace/Packages/AppCommonLib")
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local AvatarExperienceCatalog = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCatalog")
local useWidgetListInfoViewModel = AvatarExperienceCatalog.Components.ResultsList.useWidgetListInfoViewModel
local widgetListBreakPointEnum = AvatarExperienceCatalog.Components.ResultsList.WidgetListBreakPointEnum
local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")
local module5 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local module6 = require("@luauforge/deferred/gTK")
local module7 = require("@luauforge/deferred/gTL")
local module8 = require("@luauforge/deferred/gPM")
local module9 = require("@luauforge/deferred/gTM")

local module10 = require("@luauforge/deferred/gTU")
local module11 = require("@luauforge/bundled/gOc")
local module12 = require("@luauforge/bundled/dRQ")
require("@luauforge/deferred/gTG")

local module13 = require("@luauforge/deferred/gTV")
local module14 = require("@luauforge/deferred/gTX")

local module15 = require("@luauforge/deferred/gTY")
local widgetConstants = AvatarExperienceCatalog.WidgetConstants
require("@luauforge/bundled/dTN")

local module16 = require("@luauforge/deferred/gTZ")
local module17 = require("@luauforge/deferred/gUa")
local module18 = require("@luauforge/deferred/gUb")

local module19 = require("@luauforge/deferred/gUc")
local module20 = require("@luauforge/bundled/dMx")
local module21 = require("@luauforge/deferred/gUd")

local module22 = require("@luauforge/deferred/gPo")
local module23 = require("@luauforge/deferred/gUe")
local module24 = require("@luauforge/bundled/dMB")
local module25 = require("@luauforge/bundled/dSW")

local axRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest

local module26 = require("@luauforge/deferred/gQf")
local module27 = require("@luauforge/deferred/gQg")
local utils = AvatarExperienceCatalog.Utils
local getUseSelectorDeepEquals = module5.Utils.getUseSelectorDeepEquals
local module28 = require("@luauforge/deferred/gPp")

local fFlagAXCatalogCategoriesStoreImprovePerf = AvatarExperienceFlags.FFlagAXCatalogCategoriesStoreImprovePerf
local module29 = require("@luauforge/bundled/dPG")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local fFlagAXPassScreenSizeToWidgetApi = AvatarExperienceFlags.FFlagAXPassScreenSizeToWidgetApi
local fFlagAXMoveAllTabToWidgetOnly = AvatarExperienceFlags.FFlagAXMoveAllTabToWidgetOnly
local widgetsPercievedTTIManager = require("@luauforge/bundled/ggZ").WidgetsPercievedTTIManager
local fFlagAXFixCatalogTileThumbnailFlash = AvatarExperienceFlags.FFlagAXFixCatalogTileThumbnailFlash
local fFlagAXCatalogRowFromListIndex = AvatarExperienceFlags.FFlagAXCatalogRowFromListIndex

local function getBreakpointFromRowWidth(rowWidth, value)
	local v5 = value or 1

	if not rowWidth then
		return widgetListBreakPointEnum.Default
	end

	if rowWidth <= 330 * v5 then
		return widgetListBreakPointEnum.XSmall
	end

	if rowWidth <= 570 * v5 then
		return widgetListBreakPointEnum.Small
	end

	if rowWidth <= 654 * v5 then
		return widgetListBreakPointEnum.Medium
	end

	if rowWidth <= 884 * v5 then
		return widgetListBreakPointEnum.Large
	end

	if rowWidth <= 1116 * v5 then
		return widgetListBreakPointEnum.XLarge
	end

	return widgetListBreakPointEnum.X2Large
end

local function getUIScaleFromTokens(p2)
	if p2 and p2.Config and p2.Config.UI and p2.Config.UI.Scale then
		return p2.Config.UI.Scale
	end

	return 1
end

local function getRowInfoToInsertWidgets(items, result, p2, focusedWidget, p3, p4)
	local fieldCount = tutils.fieldCount(result)
	local rowInfoToInsertWidgets = {}

	for k, item in items do
		local v5 = p2[tostring(item)]

		if not ((not focusedWidget or v5.id == focusedWidget) and (item <= p3 or not p4)) then
			continue
		end

		local v6 = fieldCount + #rowInfoToInsertWidgets

		if v6 < item then
			item = v6 + 1
		end

		table.insert(rowInfoToInsertWidgets, { rowNum = item, widgetInfo = v5 })
	end

	return rowInfoToInsertWidgets
end

local function separateOrganicContentTemplatesFromWidgets(widgets)
	local result = {}
	local result2 = {}

	for k, item in widgets do
		if item.type == widgetConstants.Types.OrganicContent then
			result[k] = item
		else
			result2[k] = item
		end
	end

	return result, result2
end

local function selectSearchesParameters(p2)
	return p2.SearchesParameters
end

local function constructWidgetAnalyticsInfo(widgetInfo, widgetPosition, searchParameters, organicResultIds, previewColumns, handleThumbnailsLoaded)
	local v6 = if widgetInfo then widgetInfo.requestId else nil

	local v7 = if widgetInfo then widgetInfo.id else nil
	local v8 = if widgetInfo then widgetInfo.type else nil
	local v5 = {
		requestId = v6,
		widgetPosition = widgetPosition,
		widgetId = v7,
		widgetType = v8,
		widgetAbsPosition = (widgetPosition - 1) * previewColumns,
		query = 0,
		organicResultIds = 0,
		widgetItemIds = 0,
		handleThumbnailsLoaded = 0
	}
	local v9 = if searchParameters then searchParameters.searchKeyword else nil
	v5.query = v9
	v5.organicResultIds = organicResultIds
	v5.widgetItemIds = module19(widgetInfo, previewColumns)
	v5.handleThumbnailsLoaded = handleThumbnailsLoaded
	return v5
end

local function constructWidgetRenderInfo(data)
	local function fn()
		if data.onWidgetFocusAcquired then
			data.onWidgetFocusAcquired(data.widgetInfo)
		end
	end

	local v5 = data.focusedWidget and data.widgetInfo.id == data.focusedWidget
	local previewColumns = data.widgetInfo.template.previewColumns
	local previewRows = data.widgetInfo.template.previewRows

	local v6 = constructWidgetAnalyticsInfo(
		data.widgetInfo,
		data.rowIndex,
		data.searchParameters,
		data.organicResultIds,
		previewColumns
	)

	local v7 = nil
	local v8 = nil

	return {
		key = data.key,
		render = function(p2)
			local v9, v10

			if fFlagAXCatalogRowFromListIndex then
				v9 = data.rowIndex
				v10 = v6

				if data.getListRow then
					local getListRow = data.getListRow
					local v11 = if p2 then p2.index else nil
					v9 = getListRow(v11, data.rowIndex)

					if v9 ~= data.rowIndex then
						if v9 ~= v8 then
							v8 = v9
							v7 = constructWidgetAnalyticsInfo(
								data.widgetInfo,
								v9,
								data.searchParameters,
								data.organicResultIds,
								previewColumns
							)
						end

						v10 = v7
					end
				end
			end

			local createElement = React.createElement

			if not fFlagAXCatalogRowFromListIndex then
				v9 = data.rowIndex
			end

			local v12 = {
				widgetRow = v9,
				widgetInfo = data.widgetInfo,
				itemsPerRow = previewColumns,
				rowCount = previewRows,
				rowHeight = data.itemSize.Y,
				itemSize = data.itemSize,
				ref = data.ref,
				NextSelectionUp = data.nextSelectionUp,
				NextSelectionDown = data.nextSelectionDown,
				widgetAnalyticsInfo = 0,
				widgetFocused = 0,
				requestWidgetAcquireFocus = 0,
				requestWidgetReleaseFocus = 0,
				itemDetailsPeekViewRefs = 0,
				gridRef = 0,
				gamepadNavigationFocusPos = 0,
				setGamepadNavigationFocusPos = 0,
				includeBottomDivider = 0,
				widgetConfiguration = 0,
				rowWidth = 0,
				onThumbnailLoaded = 0,
				selectedCategory = 0,
				selectedSubcategory = 0,
				selectedCategoryInfo = 0
			}

			if not fFlagAXCatalogRowFromListIndex then
				v10 = v6
			end

			v12.widgetAnalyticsInfo = v10

			v12.widgetFocused = v5
			v12.requestWidgetAcquireFocus = fn
			v12.requestWidgetReleaseFocus = data.onWidgetFocusReleased

			v12.itemDetailsPeekViewRefs = data.itemDetailsPeekViewRefs
			v12.gridRef = data.gridRef
			v12.gamepadNavigationFocusPos = data.gamepadNavigationFocusPos
			v12.setGamepadNavigationFocusPos = data.setGamepadNavigationFocusPos
			v12.includeBottomDivider = data.includeBottomDivider
			v12.widgetConfiguration = data.widgetConfiguration
			v12.rowWidth = data.rowWidth
			v12.onThumbnailLoaded = data.onThumbnailLoaded

			local v13 = if fFlagAXCatalogCategoriesStoreImprovePerf then data.selectedCategory else nil
			v12.selectedCategory = v13

			local v14 = if fFlagAXCatalogCategoriesStoreImprovePerf then data.selectedSubcategory else nil
			v12.selectedSubcategory = v14

			local v15 = if fFlagAXCatalogCategoriesStoreImprovePerf then data.selectedCategoryInfo else nil
			v12.selectedCategoryInfo = v15
			return createElement(module8, v12)
		end
	}
end

local function selectHydratedWidgetData(p2)
	return p2.AvatarExperience.Common.Widgets.HydratedWidgetData
end

local function useRenderInfo(itemSize, itemsPerRow, widgetsPerRow, searchUuid, p2, p3, p4, fromSearch, value, p5, focusedWidget, onWidgetFocusAcquired, onWidgetFocusReleased, p6, itemDetailsPeekViewRefs, widgetRefCache, gridRef, onFocusGained, requestImpressionsSignal, callback, thumbnailAspectRatio, thumbnailScaleType, thumbnailSize, onActivated, rowWidth, p7)
	local v5, v6 = React.useBinding(1)
	local v7, v8 = React.useBinding(Vector2.new(1, 1))
	local v9 = useTokens()
	local v10

	if fFlagAXPassScreenSizeToWidgetApi then
		v10 = utils.getUIScaleFromTokens(v9)
	else
		v10 = not (v9 and v9.Config and v9.Config.UI and v9.Config.UI.Scale) and 1 or v9.Config.UI.Scale
	end

	local v11 = useAvatarRoute()
	local v12 = if axRecentlyViewedSearchItemsIXPTest.isEnabled() then useNavigation() else nil

	local catalogSelectionStore = module29.getCatalogSelectionStore()
	local v13 = useSignalState(catalogSelectionStore.selectedCategoryId)
	local v14 = useSignalState(catalogSelectionStore.selectedSubcategoryId)
	local v15, v16, v17

	if fFlagAXCatalogCategoriesStoreImprovePerf then
		v15 = useSignalState(catalogSelectionStore.selectedCategory)
		v16 = useSignalState(catalogSelectionStore.selectedSubcategory)
		v17 = useSignalState(catalogSelectionStore.selectedCategoryInfo)
	else
		v15 = nil
		v16 = nil
		v17 = nil
	end

	local v18 = nil

	if v11 and v11.opaque and v11.opaque.name == avatarScreen.MySharedAvatars then
		v18 = widgetConstants.ContextWidgets.MySharedAvatars.Context
	elseif
		axRecentlyViewedSearchItemsIXPTest.isEnabled()
		and v11
		and v11.opaque
		and v11.opaque.name == avatarScreen.SearchLandingFocusedWidgetPage
	then
		local param = v12.getParam("widgetType")
		v18 = (widgetConstants.ContextWidgets[param] or {}).Context
	elseif v13 then
		v18 = module12.getContextForWidgetsById(v11.opaque.name, v13, v14)
	end

	local v19 = useSelector(selectSearchesParameters, getUseSelectorDeepEquals())[searchUuid]
	local v20 = v19 and v19.searchKeyword ~= nil
	local v21

	if fFlagAXPassScreenSizeToWidgetApi then
		v21 = useWidgetListInfoViewModel(searchUuid, v18, utils.getBreakpointFromRowWidth(rowWidth, v10))
	else
		v21 = useWidgetListInfoViewModel(searchUuid, v18, getBreakpointFromRowWidth(rowWidth, v10))
	end

	local widgets = v21.widgets
	local v22 = v21.configuration
	local v23, v24

	if fFlagAXFixCatalogTileThumbnailFlash then
		local v25 = React.useMemo(function()
			local v26, v27 = separateOrganicContentTemplatesFromWidgets(widgets)
			return { organicContentTemplates = v26, widgets = v27 }
		end, { widgets })
		v23 = v25.organicContentTemplates
		v24 = v25.widgets
	else
		v23, v24 = separateOrganicContentTemplatesFromWidgets(widgets)
	end

	local v25 = module23({
		hydratedWidgetData = useSelector(selectHydratedWidgetData, getUseSelectorDeepEquals()),
		widgetInfoDetails = widgets,
		selectedWidgetIndex = 1
	})

	local ref = React.useRef(false)
	React.useEffect(function()
		if ref.current or (not v25 or next(v25) == nil) then
			return
		end

		ref.current = true
		widgetsPercievedTTIManager.L2.primaryDataReady()
		widgetsPercievedTTIManager.L3.responseReceived()
		widgetsPercievedTTIManager.L3.requestFetchHydratedWidgets()
	end, { v25 })

	local v26 = module28()

	module21(searchUuid, p2, v25 and next(v25) ~= nil)
	local v27 = useSelector(module11, getUseSelectorDeepEquals())
	local v28 = module9(searchUuid, p3, fromSearch)
	local v29 = if module25.isEnabled() then module24.readTestVariable(module25.EnabledForUser) else nil

	local v30 = if module25.isEnabled() then module10() elseif v29 then module10() else nil

	local ref2 = React.useRef(false)
	local v31 = module22(searchUuid)
	local current = if ref2 then ref2.current else nil
	local ref3, ref4

	if fFlagAXFixCatalogTileThumbnailFlash then
		ref3 = React.useRef(v25)
		ref3.current = v25
		ref4 = React.useRef(v31)
		ref4.current = v31
	else
		ref3 = nil
		ref4 = nil
	end

	local v32 = React.useCallback(function(p8)
		local v33 = if fFlagAXFixCatalogTileThumbnailFlash then ref3.current else v25

		local v34 = if fFlagAXFixCatalogTileThumbnailFlash then ref4.current else v31

		local v35 = ref2
			and not ref2.current
			and v33
			and next(v33) ~= nil
			and next(v33)
			and select(2, next(v33))

		if v35 then
			for k, v36 in v35 do
				if tostring(v36.id) == p8 then
					ref2.current = true
					v34.fireTileLoadingLatencyTracker(v34, true, true)
					return
				end
			end
		end
	end, fFlagAXFixCatalogTileThumbnailFlash and {} or { v25, v31 })

	local useMemo = React.useMemo
	local function fn()
		local v33 = {}

		for i = 1, p4 do
			table.insert(v33, {})
		end

		itemsPerRow = v22
			and v22.defaultItemGroupTemplate
			and v22.defaultItemGroupTemplate.previewColumns
			or 1

		local v34 = p2 or v33
		local v35 = math.ceil(tutils.fieldCount(v34) / itemsPerRow)
		local v36 = module17(v34, v35, itemsPerRow)

		local v37 = module16(v34)

		local categoryInfo = v19 and v19.categoryInfo or {}
		local showWidgets = not Cryo.isEmpty(categoryInfo) and categoryInfo.ShowWidgets or v20
		local v38 = v18 and not v20 and true or showWidgets

		if v27 > 0 then
			v38 = false
		end

		if v20 then
			v38 = Cryo.isEmpty(categoryInfo) or categoryInfo.ShowWidgets
		end

		local result = {}

		local v39 = 1
		local v40 = 1

		local v41 = module6(v28)

		local count = 0

		local fn2 = fFlagAXCatalogRowFromListIndex and function(p8, p9)
			return module18(p8, count, p9)
		end or nil

		local function maybeReserveWidgetRefCacheIndex()
			while v38 and v24 and v24[tostring(v40)] do
				v40 += 1
			end
		end

		local v42 = v41.getNext()

		if not focusedWidget then
			for k, v43 in v36 do
				while v42 and v42.row == v39 do
					local component = v42.component
					local v44 = v40
					local v45 = widgetRefCache[v44 - 1]

					if v44 <= 1 then
						v45 = nil
					end

					while v38 and v24 and v24[tostring(v40)] do
						v40 += 1
					end

					result[v39] = {
						key = "localWidget_" .. v44,
						render = function(p8)
							local createElement = React.createElement
							local v48

							if fFlagAXCatalogRowFromListIndex and fn2 then
								local v50 = if p8 then p8.index else nil
								v48 = fn2(v50, v44)
							end

							return createElement(component, {
								listRowIndex = v48,
								searchUuid = searchUuid,
								fromSearch = fromSearch,
								itemsPerRow = itemsPerRow,
								itemDetailsPeekViewRefs = itemDetailsPeekViewRefs,
								gridRef = gridRef,
								scrollingFrameRef = callback(),
								requestImpressionsSignal = requestImpressionsSignal,
								onFocusGained = onFocusGained,
								NextSelectionUp = v45,
								NextSelectionDown = widgetRefCache[v44 + 1],
								ref = widgetRefCache[v44],
								rowIndex = v44,
								gamepadNavigationColumn = v5,
								setGamepadNavigationColumn = v6,
								gamepadNavigationFocusPos = v7,
								setGamepadNavigationFocusPos = v8,
								widgetConfiguration = v22
							})
						end
					}

					v39 += 1
					v40 += 1
					v42 = v41.getNext()
				end

				while v38 and v24 and v24[tostring(v40)] do
					v40 += 1
				end

				local v44 = v40

				local v45 = v23[tostring(v40)] or {
					template = not v22 and {} or v22.defaultItemGroupTemplate
				}

				if not v38 then
					v45 = nil
				end

				local v46

				if fFlagAXMoveAllTabToWidgetOnly then
					v46 = nil
				else
					v46 = v45 and widgets and widgets[tostring(v40 + 1)] == nil
				end

				local v47

				if module26() then
					local v48 = {
						[32] = v9.Size.Size_800,
						[24] = v9.Size.Size_600,
						[20] = v9.Size.Size_500,
						[16] = v9.Size.Size_400
					}

					v47 = if v48[module27()] == nil then v9.Size.Size_800 else v48[module27()]
				else
					v47 = nil
				end

				if fromSearch and v26 and v26.catalogSearchCategory == "Avatars" then
					local v48
					v48, v45 = module12.removeItemFootersFromConfigs(v22, v45, false, true, false)
					v22 = v48
				end

				result[v39] = {
					key = "organicContentRow_" .. v44,
					render = function(p8)
						local createElement = React.createElement

						local v51 = if v45 then v45.template else not v22 and {} or v22.defaultItemGroupTemplate
						local v52 = if v45 then v45.template.title else nil
						local v53 = if v45 then v45.template.localizedTitle else nil
						local v54 = if v45 then v45.template.description else nil

						local v55 = if v45 then v45.template.localizedDescription else nil

						local v56 = if v45 then v45.template.cardStyle else nil
						local v50 = {
							template = v51,
							titleKey = v52,
							titleText = v53,
							descriptionKey = v54,
							descriptionText = v55,
							cardStyle = v56,
							searchUuid = searchUuid,
							entryRowIndex = k,
							catalogRowIndex = 0,
							padding = 0,
							row = 0,
							itemsPerRow = 0,
							itemSize = 0,
							fromSearch = 0,
							itemDetailsPeekViewRefs = 0,
							gridRef = 0,
							onFocusGained = 0,
							gamepadNavigationColumn = 0,
							setGamepadNavigationColumn = 0,
							gamepadNavigationFocusPos = 0,
							setGamepadNavigationFocusPos = 0,
							NextSelectionUp = 0,
							NextSelectionDown = 0,
							ref = 0,
							thumbnailAspectRatio = 0,
							thumbnailScaleType = 0,
							thumbnailSize = 0,
							widgetConfiguration = 0,
							onThumbnailLoaded = 0,
							selectedCategory = 0,
							selectedSubcategory = 0,
							selectedCategoryInfo = 0
						}
						local v57

						if fFlagAXCatalogRowFromListIndex and fn2 and p8 and p8.index then
							v57 = fn2(p8.index, p8.index - 1)
						elseif p8 and p8.index then
							v57 = p8.index - 1
						end

						v50.catalogRowIndex = v57
						local v58

						if v45 and not v46 then
							v58 = { bottom = 0 }
							local newUDim = UDim.new

							local v60 = if module26() then v47 else v9.Size.Size_800
							v58.bottom = newUDim(0, v60)
						else
							v58 = { bottom = UDim.new(0, v9.Size.Size_400) }
						end

						v50.padding = v58

						v50.row = v43
						v50.itemsPerRow = itemsPerRow
						v50.itemSize = itemSize
						v50.fromSearch = fromSearch
						v50.itemDetailsPeekViewRefs = itemDetailsPeekViewRefs
						v50.gridRef = gridRef
						v50.onFocusGained = onFocusGained
						v50.gamepadNavigationColumn = v5
						v50.setGamepadNavigationColumn = v6
						v50.gamepadNavigationFocusPos = v7
						v50.setGamepadNavigationFocusPos = v8
						v50.NextSelectionUp = widgetRefCache[v44 - 1]
						v50.NextSelectionDown = widgetRefCache[v44 + 1]
						v50.ref = widgetRefCache[v44]
						v50.thumbnailAspectRatio = thumbnailAspectRatio
						v50.thumbnailScaleType = thumbnailScaleType
						v50.thumbnailSize = thumbnailSize
						v50.widgetConfiguration = v22
						v50.onThumbnailLoaded = if v29 then v30 else nil

						v50.selectedCategory = if fFlagAXCatalogCategoriesStoreImprovePerf then v15 else nil

						v50.selectedSubcategory = if fFlagAXCatalogCategoriesStoreImprovePerf then v16 else nil

						v50.selectedCategoryInfo = if fFlagAXCatalogCategoriesStoreImprovePerf then v17 else nil
						return createElement(module7, v50)
					end
				}

				v39 += 1
				v40 += 1
			end
		end

		if v38 and v24 then
			local v43 = {}

			if v18 and v24[v18] and focusedWidget == v24[v18].id then
				local v44 = v24[v18]
				local v46 = {
					key = "widget_" .. v18,
					ref = widgetRefCache[v18],
					searchParameters = v19,
					organicResultIds = v37,
					rowIndex = 1,
					getListRow = if fFlagAXCatalogRowFromListIndex then fn2 else nil,
					widgetInfo = v44,
					widgetsPerRow = widgetsPerRow,
					itemSize = itemSize,
					widgetRefCache = widgetRefCache,
					focusedWidget = focusedWidget,
					onWidgetFocusAcquired = onWidgetFocusAcquired,
					onWidgetFocusReleased = onWidgetFocusReleased,
					itemDetailsPeekViewRefs = itemDetailsPeekViewRefs,
					gridRef = gridRef,
					gamepadNavigationFocusPos = v7,
					setGamepadNavigationFocusPos = v8,
					includeBottomDivider = false,
					widgetConfiguration = v22,
					rowWidth = rowWidth,
					onThumbnailLoaded = if not current then v32 else nil,
					selectedCategory = if fFlagAXCatalogCategoriesStoreImprovePerf then v15 else nil,
					selectedSubcategory = if fFlagAXCatalogCategoriesStoreImprovePerf then v16 else nil,
					selectedCategoryInfo = if fFlagAXCatalogCategoriesStoreImprovePerf then v17 else nil
				}
				table.insert(result, 1, constructWidgetRenderInfo(v46))
			end

			for k, v44 in v24 do
				if tonumber(k) ~= nil then
					table.insert(v43, (tonumber(k)))
				end
			end

			table.sort(v43)

			local rowInfoToInsertWidgets = getRowInfoToInsertWidgets(
				v43,
				result,
				v24,
				focusedWidget,
				v35,
				p6
			)

			for k, rowInfoToInsertWidget in rowInfoToInsertWidgets do
				local rowNum = rowInfoToInsertWidget.rowNum
				local widgetInfo = rowInfoToInsertWidget.widgetInfo

				local v44 = k < #rowInfoToInsertWidgets
					and rowInfoToInsertWidgets[k + 1].rowNum ~= rowNum + 1
				local v45 = k == #rowInfoToInsertWidgets and rowNum < #result

				local v47 = {
					key = "widget_" .. rowNum,
					ref = widgetRefCache[rowNum],
					nextSelectionUp = widgetRefCache[rowNum - 1],
					nextSelectionDown = widgetRefCache[rowNum + 1],
					organicResultIds = v37,
					searchParameters = v19,
					rowIndex = rowNum,
					getListRow = if fFlagAXCatalogRowFromListIndex then fn2 else nil,
					widgetInfo = widgetInfo,
					widgetsPerRow = widgetsPerRow,
					itemSize = itemSize,
					widgetRefCache = widgetRefCache,
					focusedWidget = focusedWidget,
					onWidgetFocusAcquired = onWidgetFocusAcquired,
					onWidgetFocusReleased = onWidgetFocusReleased,
					itemDetailsPeekViewRefs = itemDetailsPeekViewRefs,
					gridRef = gridRef,
					gamepadNavigationFocusPos = v7,
					setGamepadNavigationFocusPos = v8,
					includeBottomDivider = v44 or v45,
					widgetConfiguration = v22,
					rowWidth = rowWidth,
					onThumbnailLoaded = if not current then v32 else nil,
					selectedCategory = if fFlagAXCatalogCategoriesStoreImprovePerf then v15 else nil,
					selectedSubcategory = if fFlagAXCatalogCategoriesStoreImprovePerf then v16 else nil,
					selectedCategoryInfo = if fFlagAXCatalogCategoriesStoreImprovePerf then v17 else nil
				}
				table.insert(result, rowNum, constructWidgetRenderInfo(v47))
			end

			if fFlagAXMoveAllTabToWidgetOnly and v42 and #result >= 11 then
				local component = v42.component

				table.insert(result, 11, {
					key = "localWidget_sponsored",
					render = function(p8)
						local createElement = React.createElement
						local v46

						if fFlagAXCatalogRowFromListIndex and fn2 then
							local v48 = if p8 then p8.index else nil
							v46 = fn2(v48, 10)
						end

						return createElement(component, {
							listRowIndex = v46,
							searchUuid = searchUuid,
							fromSearch = fromSearch,
							itemsPerRow = itemsPerRow,
							itemDetailsPeekViewRefs = itemDetailsPeekViewRefs,
							gridRef = gridRef,
							scrollingFrameRef = callback(),
							requestImpressionsSignal = requestImpressionsSignal,
							onFocusGained = onFocusGained,
							NextSelectionUp = widgetRefCache[9],
							NextSelectionDown = widgetRefCache[11],
							ref = widgetRefCache[10],
							rowIndex = 10,
							gamepadNavigationColumn = v5,
							setGamepadNavigationColumn = v6,
							gamepadNavigationFocusPos = v7,
							setGamepadNavigationFocusPos = v8,
							widgetConfiguration = v22
						})
					end
				})

				v41.getNext()
			end
		end

		if fromSearch and p3 then
			local v43 = focusedWidget ~= nil
			table.insert(result, 1, {
				key = "header",
				render = function()
					return React.createElement(module13, {
						searchUuid = searchUuid,
						hideResultsHeader = v43,
						pillBarVisible = p7
					})
				end
			})

			if fFlagAXCatalogRowFromListIndex then
				count += 1
			end
		else
			value = (value or 0) + module20.WidgetListVerticalMargin
		end

		if onActivated then
			local v43 = v40
			table.insert(result, {
				key = "loadMoreButton_" .. v43,
				render = function()
					return React.createElement(module15, {
						onActivated = onActivated,
						ref = widgetRefCache[v43],
						NextSelectionUp = widgetRefCache[v43 - 1]
					})
				end
			})
		end

		if value then
			table.insert(result, 1, {
				key = "topSpacer",
				render = function()
					return React.createElement(module14, { height = value })
				end
			})

			if fFlagAXCatalogRowFromListIndex then
				count += 1
			end
		end

		if p5 then
			table.insert(result, {
				key = "bottomSpacer",
				render = function()
					return React.createElement(module14, { height = p5 })
				end
			})
		end

		return result
	end

	local v33 = {
		itemSize,
		itemsPerRow,
		widgetsPerRow,
		searchUuid,
		p2,
		p3,
		p4,
		fromSearch,
		value,
		p5,
		focusedWidget,
		onWidgetFocusAcquired,
		onWidgetFocusReleased,
		p6,
		itemDetailsPeekViewRefs,
		widgetRefCache,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil,
		nil
	}

	local v34 = if module25.isEnabled() or v29 then v30 else nil

	v33[17], v33[18], v33[19], v33[20], v33[21], v33[22], v33[23], v33[24], v33[25], v33[26], v33[27], v33[28], v33[29], v33[30], v33[31] = gridRef, onFocusGained, requestImpressionsSignal, callback, v24, v19, v20, thumbnailAspectRatio, thumbnailScaleType, thumbnailSize, v18, onActivated, v9, v34, rowWidth
	return (useMemo(fn, v33))
end

return useRenderInfo
