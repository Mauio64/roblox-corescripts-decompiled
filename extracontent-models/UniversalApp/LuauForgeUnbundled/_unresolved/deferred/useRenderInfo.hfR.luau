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

local module6 = require("@luauforge/deferred/hfS")
local module7 = require("@luauforge/deferred/hfT")
local module8 = require("@luauforge/deferred/hbP")
local module9 = require("@luauforge/deferred/hfU")

local module10 = require("@luauforge/deferred/hgc")
local module11 = require("@luauforge/bundled/hah")
local module12 = require("@luauforge/bundled/dVl")
require("@luauforge/deferred/hfO")

local module13 = require("@luauforge/deferred/hgd")
local module14 = require("@luauforge/deferred/hgf")

local module15 = require("@luauforge/deferred/hgg")
local widgetConstants = AvatarExperienceCatalog.WidgetConstants
require("@luauforge/bundled/dXi")

local module16 = require("@luauforge/deferred/hgh")
local module17 = require("@luauforge/deferred/hgi")
local module18 = require("@luauforge/deferred/hgj")

local module19 = require("@luauforge/deferred/hgk")
local module20 = require("@luauforge/bundled/dPN")
local module21 = require("@luauforge/deferred/hgl")

local module22 = require("@luauforge/deferred/hbr")
local module23 = require("@luauforge/deferred/hgm")
local module24 = require("@luauforge/bundled/dPR")
local module25 = require("@luauforge/bundled/dWr")

local axRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest

local module26 = require("@luauforge/deferred/hcl")
local module27 = require("@luauforge/deferred/hcm")
local utils = AvatarExperienceCatalog.Utils
local getUseSelectorDeepEquals = module5.Utils.getUseSelectorDeepEquals
local module28 = require("@luauforge/deferred/hbs")

local fFlagAXCatalogCategoriesStoreImprovePerf = AvatarExperienceFlags.FFlagAXCatalogCategoriesStoreImprovePerf
local module29 = require("@luauforge/bundled/dSW")
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState

local fFlagAXPassScreenSizeToWidgetApi = AvatarExperienceFlags.FFlagAXPassScreenSizeToWidgetApi
local fFlagAXMoveAllTabToWidgetOnly = AvatarExperienceFlags.FFlagAXMoveAllTabToWidgetOnly
local widgetsPercievedTTIManager = require("@luauforge/bundled/gLF").WidgetsPercievedTTIManager
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

	local v26 = module23({
		hydratedWidgetData = useSelector(selectHydratedWidgetData, getUseSelectorDeepEquals()),
		widgetInfoDetails = widgets,
		selectedWidgetIndex = 1
	})

	local ref = React.useRef(false)
	React.useEffect(function()
		if ref.current or (not v26 or next(v26) == nil) then
			return
		end

		ref.current = true
		widgetsPercievedTTIManager.L2.primaryDataReady()
		widgetsPercievedTTIManager.L3.responseReceived()
		widgetsPercievedTTIManager.L3.requestFetchHydratedWidgets()
	end, { v26 })

	local v27 = module28()

	module21(searchUuid, p2, v26 and next(v26) ~= nil)
	local v29 = useSelector(module11, getUseSelectorDeepEquals())
	local v30 = module9(searchUuid, p3, fromSearch)
	local v31 = if module25.isEnabled() then module24.readTestVariable(module25.EnabledForUser) else nil

	local v32 = if module25.isEnabled() then module10() elseif v31 then module10() else nil

	local ref2 = React.useRef(false)
	local v33 = module22(searchUuid)
	local current = if ref2 then ref2.current else nil
	local ref3, ref4

	if fFlagAXFixCatalogTileThumbnailFlash then
		ref3 = React.useRef(v26)
		ref3.current = v26
		ref4 = React.useRef(v33)
		ref4.current = v33
	else
		ref3 = nil
		ref4 = nil
	end

	local v34 = React.useCallback(function(p8)
		local v35 = if fFlagAXFixCatalogTileThumbnailFlash then ref3.current else v26

		local v36 = if fFlagAXFixCatalogTileThumbnailFlash then ref4.current else v33

		local v37 = ref2
			and not ref2.current
			and v35
			and next(v35) ~= nil
			and next(v35)
			and select(2, next(v35))

		if v37 then
			for k, v38 in v37 do
				if tostring(v38.id) == p8 then
					ref2.current = true
					v36.fireTileLoadingLatencyTracker(v36, true, true)
					return
				end
			end
		end
	end, fFlagAXFixCatalogTileThumbnailFlash and {} or { v26, v33 })

	local useMemo = React.useMemo
	local function fn()
		local v35 = {}

		for i = 1, p4 do
			table.insert(v35, {})
		end

		itemsPerRow = v22
			and v22.defaultItemGroupTemplate
			and v22.defaultItemGroupTemplate.previewColumns
			or 1

		local v36 = p2 or v35
		local v37 = math.ceil(tutils.fieldCount(v36) / itemsPerRow)
		local v38 = module17(v36, v37, itemsPerRow)

		local v39 = module16(v36)

		local categoryInfo = v19 and v19.categoryInfo or {}
		local showWidgets = not Cryo.isEmpty(categoryInfo) and categoryInfo.ShowWidgets or v20
		local v40 = v18 and not v20 and true or showWidgets

		if v29 > 0 then
			v40 = false
		end

		if v20 then
			v40 = Cryo.isEmpty(categoryInfo) or categoryInfo.ShowWidgets
		end

		local result = {}

		local v41 = 1
		local v42 = 1

		local v43 = module6(v30)

		local count = 0

		local fn2 = fFlagAXCatalogRowFromListIndex and function(p8, p9)
			return module18(p8, count, p9)
		end or nil

		local function maybeReserveWidgetRefCacheIndex()
			while v40 and v24 and v24[tostring(v42)] do
				v42 += 1
			end
		end

		local v44 = v43.getNext()

		if not focusedWidget then
			for k, v45 in v38 do
				while v44 and v44.row == v41 do
					local component = v44.component
					local v46 = v42
					local v47 = widgetRefCache[v46 - 1]

					if v46 <= 1 then
						v47 = nil
					end

					while v40 and v24 and v24[tostring(v42)] do
						v42 += 1
					end

					result[v41] = {
						key = "localWidget_" .. v46,
						render = function(p8)
							local createElement = React.createElement
							local v50

							if fFlagAXCatalogRowFromListIndex and fn2 then
								local v52 = if p8 then p8.index else nil
								v50 = fn2(v52, v46)
							end

							return createElement(component, {
								listRowIndex = v50,
								searchUuid = searchUuid,
								fromSearch = fromSearch,
								itemsPerRow = itemsPerRow,
								itemDetailsPeekViewRefs = itemDetailsPeekViewRefs,
								gridRef = gridRef,
								scrollingFrameRef = callback(),
								requestImpressionsSignal = requestImpressionsSignal,
								onFocusGained = onFocusGained,
								NextSelectionUp = v47,
								NextSelectionDown = widgetRefCache[v46 + 1],
								ref = widgetRefCache[v46],
								rowIndex = v46,
								gamepadNavigationColumn = v5,
								setGamepadNavigationColumn = v6,
								gamepadNavigationFocusPos = v7,
								setGamepadNavigationFocusPos = v8,
								widgetConfiguration = v22
							})
						end
					}

					v41 += 1
					v42 += 1
					v44 = v43.getNext()
				end

				while v40 and v24 and v24[tostring(v42)] do
					v42 += 1
				end

				local v46 = v42

				local v47 = v23[tostring(v42)] or {
					template = not v22 and {} or v22.defaultItemGroupTemplate
				}

				if not v40 then
					v47 = nil
				end

				local v48

				if fFlagAXMoveAllTabToWidgetOnly then
					v48 = nil
				else
					v48 = v47 and widgets and widgets[tostring(v42 + 1)] == nil
				end

				local v49

				if module26() then
					local v50 = {
						[32] = v9.Size.Size_800,
						[24] = v9.Size.Size_600,
						[20] = v9.Size.Size_500,
						[16] = v9.Size.Size_400
					}

					v49 = if v50[module27()] == nil then v9.Size.Size_800 else v50[module27()]
				else
					v49 = nil
				end

				if fromSearch and v27 and v27.catalogSearchCategory == "Avatars" then
					local v50
					v50, v47 = module12.removeItemFootersFromConfigs(v22, v47, false, true, false)
					v22 = v50
				end

				result[v41] = {
					key = "organicContentRow_" .. v46,
					render = function(p8)
						local createElement = React.createElement

						local v53 = if v47 then v47.template else not v22 and {} or v22.defaultItemGroupTemplate
						local v54 = if v47 then v47.template.title else nil
						local v55 = if v47 then v47.template.localizedTitle else nil
						local v56 = if v47 then v47.template.description else nil

						local v57 = if v47 then v47.template.localizedDescription else nil

						local v58 = if v47 then v47.template.cardStyle else nil
						local v52 = {
							template = v53,
							titleKey = v54,
							titleText = v55,
							descriptionKey = v56,
							descriptionText = v57,
							cardStyle = v58,
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
						local v59

						if fFlagAXCatalogRowFromListIndex and fn2 and p8 and p8.index then
							v59 = fn2(p8.index, p8.index - 1)
						elseif p8 and p8.index then
							v59 = p8.index - 1
						end

						v52.catalogRowIndex = v59
						local v60

						if v47 and not v48 then
							v60 = { bottom = 0 }
							local newUDim = UDim.new

							local v62 = if module26() then v49 else v9.Size.Size_800
							v60.bottom = newUDim(0, v62)
						else
							v60 = { bottom = UDim.new(0, v9.Size.Size_400) }
						end

						v52.padding = v60

						v52.row = v45
						v52.itemsPerRow = itemsPerRow
						v52.itemSize = itemSize
						v52.fromSearch = fromSearch
						v52.itemDetailsPeekViewRefs = itemDetailsPeekViewRefs
						v52.gridRef = gridRef
						v52.onFocusGained = onFocusGained
						v52.gamepadNavigationColumn = v5
						v52.setGamepadNavigationColumn = v6
						v52.gamepadNavigationFocusPos = v7
						v52.setGamepadNavigationFocusPos = v8
						v52.NextSelectionUp = widgetRefCache[v46 - 1]
						v52.NextSelectionDown = widgetRefCache[v46 + 1]
						v52.ref = widgetRefCache[v46]
						v52.thumbnailAspectRatio = thumbnailAspectRatio
						v52.thumbnailScaleType = thumbnailScaleType
						v52.thumbnailSize = thumbnailSize
						v52.widgetConfiguration = v22
						v52.onThumbnailLoaded = if v31 then v32 else nil

						v52.selectedCategory = if fFlagAXCatalogCategoriesStoreImprovePerf then v15 else nil

						v52.selectedSubcategory = if fFlagAXCatalogCategoriesStoreImprovePerf then v16 else nil

						v52.selectedCategoryInfo = if fFlagAXCatalogCategoriesStoreImprovePerf then v17 else nil
						return createElement(module7, v52)
					end
				}

				v41 += 1
				v42 += 1
			end
		end

		if v40 and v24 then
			local v45 = {}

			if v18 and v24[v18] and focusedWidget == v24[v18].id then
				local v46 = v24[v18]
				local v48 = {
					key = "widget_" .. v18,
					ref = widgetRefCache[v18],
					searchParameters = v19,
					organicResultIds = v39,
					rowIndex = 1,
					getListRow = if fFlagAXCatalogRowFromListIndex then fn2 else nil,
					widgetInfo = v46,
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
					onThumbnailLoaded = if not current then v34 else nil,
					selectedCategory = if fFlagAXCatalogCategoriesStoreImprovePerf then v15 else nil,
					selectedSubcategory = if fFlagAXCatalogCategoriesStoreImprovePerf then v16 else nil,
					selectedCategoryInfo = if fFlagAXCatalogCategoriesStoreImprovePerf then v17 else nil
				}
				table.insert(result, 1, constructWidgetRenderInfo(v48))
			end

			for k, v46 in v24 do
				if tonumber(k) ~= nil then
					table.insert(v45, (tonumber(k)))
				end
			end

			table.sort(v45)

			local rowInfoToInsertWidgets = getRowInfoToInsertWidgets(
				v45,
				result,
				v24,
				focusedWidget,
				v37,
				p6
			)

			for k, rowInfoToInsertWidget in rowInfoToInsertWidgets do
				local rowNum = rowInfoToInsertWidget.rowNum
				local widgetInfo = rowInfoToInsertWidget.widgetInfo

				local v46 = k < #rowInfoToInsertWidgets
					and rowInfoToInsertWidgets[k + 1].rowNum ~= rowNum + 1
				local v47 = k == #rowInfoToInsertWidgets and rowNum < #result

				local v49 = {
					key = "widget_" .. rowNum,
					ref = widgetRefCache[rowNum],
					nextSelectionUp = widgetRefCache[rowNum - 1],
					nextSelectionDown = widgetRefCache[rowNum + 1],
					organicResultIds = v39,
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
					includeBottomDivider = v46 or v47,
					widgetConfiguration = v22,
					rowWidth = rowWidth,
					onThumbnailLoaded = if not current then v34 else nil,
					selectedCategory = if fFlagAXCatalogCategoriesStoreImprovePerf then v15 else nil,
					selectedSubcategory = if fFlagAXCatalogCategoriesStoreImprovePerf then v16 else nil,
					selectedCategoryInfo = if fFlagAXCatalogCategoriesStoreImprovePerf then v17 else nil
				}
				table.insert(result, rowNum, constructWidgetRenderInfo(v49))
			end

			if fFlagAXMoveAllTabToWidgetOnly and v44 and #result >= 11 then
				local component = v44.component

				table.insert(result, 11, {
					key = "localWidget_sponsored",
					render = function(p8)
						local createElement = React.createElement
						local v48

						if fFlagAXCatalogRowFromListIndex and fn2 then
							local v50 = if p8 then p8.index else nil
							v48 = fn2(v50, 10)
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

				v43.getNext()
			end
		end

		if fromSearch and p3 then
			local v45 = focusedWidget ~= nil
			table.insert(result, 1, {
				key = "header",
				render = function()
					return React.createElement(module13, {
						searchUuid = searchUuid,
						hideResultsHeader = v45,
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
			local v45 = v42
			table.insert(result, {
				key = "loadMoreButton_" .. v45,
				render = function()
					return React.createElement(module15, {
						onActivated = onActivated,
						ref = widgetRefCache[v45],
						NextSelectionUp = widgetRefCache[v45 - 1]
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

	local v35 = {
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

	local v38 = if module25.isEnabled() or v31 then v32 else nil

	v35[17], v35[18], v35[19], v35[20], v35[21], v35[22], v35[23], v35[24], v35[25], v35[26], v35[27], v35[28], v35[29], v35[30], v35[31] = gridRef, onFocusGained, requestImpressionsSignal, callback, v24, v19, v20, thumbnailAspectRatio, thumbnailScaleType, thumbnailSize, v18, onActivated, v9, v38, rowWidth
	return (useMemo(fn, v35))
end

return useRenderInfo
