local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local Cryo = require(CorePackages.Packages.Cryo)
local tutils = require(CorePackages.Packages.tutils)
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector

require(CorePackages.Workspace.Packages.AppCommonLib)

local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local useTokens = require(CorePackages.Packages.Foundation).Hooks.useTokens
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local AvatarExperienceCatalog = require(CorePackages.Workspace.Packages.AvatarExperienceCatalog)
local useWidgetListInfoViewModel = AvatarExperienceCatalog.Components.ResultsList.useWidgetListInfoViewModel
local WidgetListBreakPointEnum = AvatarExperienceCatalog.Components.ResultsList.WidgetListBreakPointEnum
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local FFlagAXLookAndFeelBackgrounds = AvatarExperienceFlags.FFlagAXLookAndFeelBackgrounds
local AvatarExperienceCommon2 = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local getIterator = require(Modules.AvatarExperience.Common.Util.getIterator)
local OrganicContentRow = require(Modules.AvatarExperience.Common.Components.OrganicContentRow)
local CatalogGridWidget = require(Modules.AvatarExperience.Common.Components.Widgets.CatalogGridWidget)
local useLocalWidgets = require(Modules.AvatarExperience.Common.Hooks.useLocalWidgets)
local useHandleThumbnailsLoaded = require(Modules.AvatarExperience.Common.Components.WidgetList.Hooks.useHandleThumbnailsLoaded)
local selectFilterCount = require(Modules.AvatarExperience.Catalog.Selectors.selectFilterCount)
local CatalogUtils = require(Modules.AvatarExperience.Catalog.CatalogUtils)

require(Modules.AvatarExperience.Common.Components.WidgetList.Types)

local WidgetListResultsHeader = require(Modules.AvatarExperience.Common.Components.WidgetList.Components.WidgetListResultsHeader)
local WidgetListSpacer = require(Modules.AvatarExperience.Common.Components.WidgetList.Components.WidgetListSpacer)
local WidgetListLoadMoreButton = require(Modules.AvatarExperience.Common.Components.WidgetList.Components.WidgetListLoadMoreButton)
local WidgetConstants = AvatarExperienceCatalog.WidgetConstants

require(Modules.AvatarExperience.Catalog.SearchTypes)

local getOrganicResultIdsFromEntries = require(Modules.AvatarExperience.Common.Components.WidgetList.Utils.getOrganicResultIdsFromEntries)
local getEntriesAsRows = require(Modules.AvatarExperience.Common.Components.WidgetList.Utils.getEntriesAsRows)
local getWidgetItemIdsFromWidgetInfo = require(Modules.AvatarExperience.Common.Components.WidgetList.Utils.getWidgetItemIdsFromWidgetInfo)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local useTileLatencyTracker = require(Modules.AvatarExperience.Common.Hooks.TileLatency.useTileLatencyTracker)
local useTileLoadingLatencyInitializer = require(Modules.AvatarExperience.Common.Hooks.TileLatency.useTileLoadingLatencyInitializer)
local useGetHydratedWidgets = require(Modules.AvatarExperience.Common.Components.WidgetList.Hooks.useGetHydratedWidgets)
local GetFFlagEnableCatalogTileLoadingLatency = require(Modules.AvatarExperience.Flags.GetFFlagEnableCatalogTileLoadingLatency)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local AXCatalogPerfReduxReductionIXP = require(Modules.AvatarExperience.Experiments.AXCatalogPerfReduxReductionIXP)
local AXRecentlyViewedSearchItemsIXPTest = AvatarExperienceCommon.Experiments.AXRecentlyViewedSearchItemsIXPTest
local v41 = game:DefineFastFlag("AXUseRendererInfoConditionalHookBacktraceError", false)
local GetFFlagEnableDecreaseWidgetPaddingSizing = require(Modules.AvatarExperience.Flags.GetFFlagEnableDecreaseWidgetPaddingSizing)
local GetFIntWidgetPaddingSizing = require(Modules.AvatarExperience.Flags.GetFIntWidgetPaddingSizing)
local Utils = AvatarExperienceCatalog.Utils
local getUseSelectorDeepEquals = AvatarExperienceCommon2.Utils.getUseSelectorDeepEquals
local useGetCurrentCategoryNames = require(Modules.AvatarExperience.Catalog.Hooks.useGetCurrentCategoryNames)
local FFlagAXCatalogCategoriesStoreImprovePerf = AvatarExperienceFlags.FFlagAXCatalogCategoriesStoreImprovePerf
local GetCatalogCategoriesStore = require(Modules.AvatarExperience.Catalog.Stores.GetCatalogCategoriesStore)
local useSignalState = require(CorePackages.Packages.SignalsReact).useSignalState
local FFlagAXPassScreenSizeToWidgetApi = AvatarExperienceFlags.FFlagAXPassScreenSizeToWidgetApi
local FFlagAXMoveAllTabToWidgetOnly = AvatarExperienceFlags.FFlagAXMoveAllTabToWidgetOnly
local WidgetsPercievedTTIManager = require(CorePackages.Workspace.Packages.AvatarExperienceTTIPerformance).WidgetsPercievedTTIManager
local FFlagAXFixCatalogTileThumbnailFlash = AvatarExperienceFlags.FFlagAXFixCatalogTileThumbnailFlash

local function getBreakpointFromRowWidth(n1: number?, n2: number?) -- line: 144
	-- upvalues: WidgetListBreakPointEnum (copy)
	local v65 = n2 or 1

	if not n1 then
		return WidgetListBreakPointEnum.Default
	end

	if n1 <= 330 * v65 then
		return WidgetListBreakPointEnum.XSmall
	end

	if n1 <= 570 * v65 then
		return WidgetListBreakPointEnum.Small
	end

	if n1 <= 654 * v65 then
		return WidgetListBreakPointEnum.Medium
	end

	if n1 <= 884 * v65 then
		return WidgetListBreakPointEnum.Large
	end

	if n1 <= 1116 * v65 then
		return WidgetListBreakPointEnum.XLarge
	end

	return WidgetListBreakPointEnum.X2Large
end
local function getUIScaleFromTokens(p1) -- line: 156
	if p1 and (p1.Config and p1.Config.UI and p1.Config.UI.Scale) then
		return p1.Config.UI.Scale
	end

	return 1
end
local function getRowInfoToInsertWidgets(t1: {[any]: any}, p2, t2: {[any]: any}, s1: string?, n3: number, b1: boolean) -- line: 163
	-- upvalues: tutils (copy)
	local t3 = {}
	local v74 = tutils.fieldCount(p2)

	for _, v76 in t1 do
		local v77 = v76
		local v78 = t2[tostring(v77)]

		if (not s1 or s1 == v78.id) and (v77 <= n3 or not b1) then
			local v79 = v74 + #t3

			if v79 < v77 then
				v77 = v79 + 1
			end

			table.insert(t3, {
				rowNum = v77,
				widgetInfo = v78
			})
		end
	end

	return t3
end
local function separateOrganicContentTemplatesFromWidgets(p3) -- line: 202
	-- upvalues: WidgetConstants (copy)
	local t4 = {}
	local t5 = {}

	for v83, v84 in p3 do
		if v84.type == WidgetConstants.Types.OrganicContent then
			t4[v83] = v84
		else
			t5[v83] = v84
		end
	end

	return t4, t5
end
local function selectSearchesParameters(p4) -- line: 218
	return p4.SearchesParameters
end
local function constructWidgetAnalyticsInfo(p5, n4: number, p6, t6: {[any]: any}, n5: number, p7: ((...any) -> ...any)?) -- line: 222
	-- upvalues: getWidgetItemIdsFromWidgetInfo (copy)
	return {
		requestId = if not p5 then nil else p5.requestId,
		widgetPosition = n4,
		widgetId = if not p5 then nil else p5.id,
		widgetType = if not p5 then nil else p5.type,
		widgetAbsPosition = (n4 - 1) * n5,
		query = if not p6 then nil else p6.searchKeyword,
		organicResultIds = t6,
		widgetItemIds = getWidgetItemIdsFromWidgetInfo(p5, n5),
		handleThumbnailsLoaded = p7
	}
end
local function constructWidgetRenderInfo(t7: {[any]: any}) -- line: 243
	-- upvalues: constructWidgetAnalyticsInfo (copy), React (copy), CatalogGridWidget (copy), FFlagAXCatalogCategoriesStoreImprovePerf (copy)
	local function u93() -- line: 245
		-- upvalues: t7 (copy)
		if t7.onWidgetFocusAcquired then
			t7.onWidgetFocusAcquired(t7.widgetInfo)
		end
	end

	local u94 = t7.focusedWidget and t7.widgetInfo.id == t7.focusedWidget
	local previewColumns = t7.widgetInfo.template.previewColumns
	local previewRows = t7.widgetInfo.template.previewRows
	local u97 = constructWidgetAnalyticsInfo(t7.widgetInfo, t7.rowIndex, t7.searchParameters, t7.organicResultIds, previewColumns)

	return {
		key = t7.key,
		render = function(_) -- line: 265
			-- upvalues: React (copy), CatalogGridWidget (copy), t7 (copy), previewColumns (ref), previewRows (ref), u97 (ref), u94 (ref), u93 (ref), FFlagAXCatalogCategoriesStoreImprovePerf (copy)
			return React.createElement(CatalogGridWidget, {
				widgetRow = t7.rowIndex,
				widgetInfo = t7.widgetInfo,
				itemsPerRow = previewColumns,
				rowCount = previewRows,
				rowHeight = t7.itemSize.Y,
				itemSize = t7.itemSize,
				ref = t7.ref,
				NextSelectionUp = t7.nextSelectionUp,
				NextSelectionDown = t7.nextSelectionDown,
				widgetAnalyticsInfo = u97,
				widgetFocused = u94,
				requestWidgetAcquireFocus = u93,
				requestWidgetReleaseFocus = t7.onWidgetFocusReleased,
				itemDetailsPeekViewRefs = t7.itemDetailsPeekViewRefs,
				gridRef = t7.gridRef,
				gamepadNavigationFocusPos = t7.gamepadNavigationFocusPos,
				setGamepadNavigationFocusPos = t7.setGamepadNavigationFocusPos,
				includeBottomDivider = t7.includeBottomDivider,
				widgetConfiguration = t7.widgetConfiguration,
				rowWidth = t7.rowWidth,
				onThumbnailLoaded = t7.onThumbnailLoaded,
				selectedCategory = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else t7.selectedCategory,
				selectedSubcategory = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else t7.selectedSubcategory,
				selectedCategoryInfo = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else t7.selectedCategoryInfo
			})
		end
	}
end
local function selectHydratedWidgetData(p9) -- line: 307
	return p9.AvatarExperience.Common.Widgets.HydratedWidgetData
end
local function useRenderInfo(vector2: Vector2, n6: number, n7: number, s2: string, t8: {[any]: any}?, b2: boolean?, n8: number, b3: boolean?, n9: number?, n10: number?, s3: string?, p10: ((...any) -> ...any)?, p11: ((...any) -> ...any)?, b4: boolean, t9: {[any]: any}, t10: {[any]: any}, p12, p13: ((...any) -> ...any)?, p14, p15: ((...any) -> ...any), n11: number?, p16, s4: string?, p17: ((...any) -> ...any)?, n12: number?, b5: boolean?) -- line: 317
	-- upvalues: React (copy), useTokens (copy), FFlagAXPassScreenSizeToWidgetApi (copy), Utils (copy), useAvatarRoute (copy), AXRecentlyViewedSearchItemsIXPTest (copy), useNavigation (copy), GetCatalogCategoriesStore (copy), useSignalState (copy), FFlagAXCatalogCategoriesStoreImprovePerf (copy), AvatarScreen (copy), WidgetConstants (copy), CatalogUtils (copy), useSelector (copy), selectSearchesParameters (copy), getUseSelectorDeepEquals (copy), useWidgetListInfoViewModel (copy), getBreakpointFromRowWidth (copy), FFlagAXFixCatalogTileThumbnailFlash (copy), separateOrganicContentTemplatesFromWidgets (copy), selectHydratedWidgetData (copy), useGetHydratedWidgets (copy), WidgetsPercievedTTIManager (copy), useGetCurrentCategoryNames (copy), GetFFlagEnableCatalogTileLoadingLatency (copy), useTileLatencyTracker (copy), selectFilterCount (copy), useLocalWidgets (copy), AXCatalogPerfReduxReductionIXP (copy), IxpUtils (copy), v41 (copy), useHandleThumbnailsLoaded (copy), useTileLoadingLatencyInitializer (copy), tutils (copy), getEntriesAsRows (copy), getOrganicResultIdsFromEntries (copy), Cryo (copy), getIterator (copy), FFlagAXLookAndFeelBackgrounds (copy), FFlagAXMoveAllTabToWidgetOnly (copy), GetFFlagEnableDecreaseWidgetPaddingSizing (copy), GetFIntWidgetPaddingSizing (copy), OrganicContentRow (copy), constructWidgetRenderInfo (copy), getRowInfoToInsertWidgets (copy), WidgetListResultsHeader (copy), Constants (copy), WidgetListLoadMoreButton (copy), WidgetListSpacer (copy)
	local v127, v128 = React.useBinding(1)
	local v129, v130 = React.useBinding(Vector2.new(1, 1))
	local v131 = useTokens()
	local v132 = if not FFlagAXPassScreenSizeToWidgetApi then (not v131 or (not v131.Config or (not v131.Config.UI or not v131.Config.UI.Scale))) and 1 or v131.Config.UI.Scale else Utils.getUIScaleFromTokens(v131)
	local v133 = useAvatarRoute()
	local v134 = if not AXRecentlyViewedSearchItemsIXPTest.isEnabled() then nil else useNavigation()
	local v135 = GetCatalogCategoriesStore.getCatalogSelectionStore()
	local v136 = useSignalState(v135.selectedCategoryId)
	local v137 = useSignalState(v135.selectedSubcategoryId)
	local u138 = nil
	local u139 = nil
	local u140 = nil

	if FFlagAXCatalogCategoriesStoreImprovePerf then
		u138 = useSignalState(v135.selectedCategory)
		u139 = useSignalState(v135.selectedSubcategory)
		u140 = useSignalState(v135.selectedCategoryInfo)
	end

	local Context = nil

	if v133 and v133.opaque and v133.opaque.name == AvatarScreen.MySharedAvatars then
		Context = WidgetConstants.ContextWidgets.MySharedAvatars.Context
	elseif AXRecentlyViewedSearchItemsIXPTest.isEnabled() and v133 and v133.opaque and v133.opaque.name == AvatarScreen.SearchLandingFocusedWidgetPage then
		local v142 = v134.getParam("widgetType")

		Context = (WidgetConstants.ContextWidgets[v142] or {}).Context
	elseif v136 then
		Context = CatalogUtils.getContextForWidgetsById(v133.opaque.name, v136, v137)
	end

	local v143 = useSelector(selectSearchesParameters, getUseSelectorDeepEquals())[s2]
	local v144 = v143 and v143.searchKeyword ~= nil
	local v145 = if not FFlagAXPassScreenSizeToWidgetApi then useWidgetListInfoViewModel(s2, Context, (getBreakpointFromRowWidth(n12, v132))) else useWidgetListInfoViewModel(s2, Context, Utils.getBreakpointFromRowWidth(n12, v132))
	local widgets = v145.widgets
	local configuration = v145.configuration
	local organicContentTemplates, widgets2

	if FFlagAXFixCatalogTileThumbnailFlash then
		local v148 = React.useMemo(function() -- line: 407
			-- upvalues: separateOrganicContentTemplatesFromWidgets (copy), widgets (copy)
			local v167, v168 = separateOrganicContentTemplatesFromWidgets(widgets)

			return {
				organicContentTemplates = v167,
				widgets = v168
			}
		end, { widgets })

		organicContentTemplates = v148.organicContentTemplates
		widgets2 = v148.widgets
	else
		local v151, v152 = separateOrganicContentTemplatesFromWidgets(widgets)

		organicContentTemplates = v151
		widgets2 = v152
	end

	local v153 = useSelector(selectHydratedWidgetData, getUseSelectorDeepEquals())
	local v154 = useGetHydratedWidgets({
		selectedWidgetIndex = 1,
		hydratedWidgetData = v153,
		widgetInfoDetails = widgets
	})
	local v155 = React.useRef(false)

	React.useEffect(function() -- line: 424
		-- upvalues: v155 (copy), v154 (copy), WidgetsPercievedTTIManager (copy)
		if v155.current then
			return
		end

		if not v154 or next(v154) == nil then
			return
		end

		v155.current = true
		WidgetsPercievedTTIManager.L2.primaryDataReady()
		WidgetsPercievedTTIManager.L3.responseReceived()
		WidgetsPercievedTTIManager.L3.requestFetchHydratedWidgets()
	end, { v154 })

	local v156 = useGetCurrentCategoryNames()

	if GetFFlagEnableCatalogTileLoadingLatency() then
		local v157 = v154 and next(v154) ~= nil

		useTileLatencyTracker(s2, t8, v157)
	end

	local v158 = useSelector(selectFilterCount, getUseSelectorDeepEquals())
	local v159 = useLocalWidgets(s2, b2, b3)
	local v160 = if not AXCatalogPerfReduxReductionIXP.isEnabled() then nil else IxpUtils.readTestVariable(AXCatalogPerfReduxReductionIXP.EnabledForUser)
	local u161 = if not v41 or not AXCatalogPerfReduxReductionIXP.isEnabled() then if not v160 then nil else useHandleThumbnailsLoaded() else useHandleThumbnailsLoaded()
	local v162 = React.useRef(false)
	local v163 = useTileLoadingLatencyInitializer(s2)
	local v164 = if not v162 then nil else v162.current
	local v165 = React.useCallback(function(p18) -- line: 464
		-- upvalues: v162 (copy), v154 (copy), v163 (copy)
		if v162 and (not v162.current and v154 and next(v154) ~= nil) then
			local v170 = next(v154) and select(2, next(v154))

			if v170 then
				for _, v172 in v170 do
					if p18 == tostring(v172.id) then
						v162.current = true
						v163.fireTileLoadingLatencyTracker(v163, true, true)

						return
					end
				end
			end
		end
	end, {
		v154,
		v163
	})

	return (React.useMemo(function() -- line: 486
		-- upvalues: n8 (copy), n6 (ref), configuration (ref), t8 (copy), tutils (copy), getEntriesAsRows (copy), getOrganicResultIdsFromEntries (copy), v143 (copy), Cryo (copy), v144 (copy), Context (ref), v158 (copy), getIterator (copy), v159 (copy), widgets2 (ref), s3 (copy), t10 (copy), React (copy), s2 (copy), b3 (copy), t9 (copy), p12 (copy), p15 (copy), p14 (copy), p13 (copy), v127 (copy), v128 (copy), v129 (copy), v130 (copy), organicContentTemplates (ref), FFlagAXLookAndFeelBackgrounds (copy), FFlagAXMoveAllTabToWidgetOnly (copy), widgets (copy), GetFFlagEnableDecreaseWidgetPaddingSizing (copy), v131 (copy), GetFIntWidgetPaddingSizing (copy), v156 (copy), CatalogUtils (copy), OrganicContentRow (copy), vector2 (copy), n11 (copy), p16 (copy), s4 (copy), v160 (copy), u161 (ref), FFlagAXCatalogCategoriesStoreImprovePerf (copy), u138 (ref), u139 (ref), u140 (ref), constructWidgetRenderInfo (copy), n7 (copy), p10 (copy), p11 (copy), n12 (copy), v164 (copy), v165 (copy), getRowInfoToInsertWidgets (copy), b4 (copy), b2 (copy), WidgetListResultsHeader (copy), b5 (copy), n9 (ref), Constants (copy), p17 (copy), WidgetListLoadMoreButton (copy), WidgetListSpacer (copy), n10 (copy)
		local t11 = {}

		for _ = 1, n8 do
			table.insert(t11, {})
		end

		n6 = (not configuration or not configuration.defaultItemGroupTemplate) and 1 or (configuration.defaultItemGroupTemplate.previewColumns or 1)

		local v175 = t8 or t11
		local v176 = math.ceil(tutils.fieldCount(v175) / n6)
		local v177 = getEntriesAsRows(v175, v176, n6)
		local v178 = getOrganicResultIdsFromEntries(v175)
		local v179 = v143 and v143.categoryInfo or {}
		local u180 = not Cryo.isEmpty(v179) and v179.ShowWidgets or v144

		if Context and not v144 then
			u180 = true
		end

		if v158 > 0 then
			u180 = false
		end

		if v144 then
			u180 = Cryo.isEmpty(v179) or v179.ShowWidgets
		end

		local t12 = {}
		local n13 = 1
		local n14 = 1
		local v184 = getIterator(v159)

		local function maybeReserveWidgetRefCacheIndex() -- line: 545
			-- upvalues: u180 (ref), widgets2 (ref), n14 (ref)
			while u180 and widgets2 and widgets2[tostring(n14)] do
				n14 += 1
			end
		end

		local v186 = v184.getNext()

		if not s3 then
			for v187, v188 in v177 do
				while v186 and n13 == v186.row do
					local component = v186.component
					local v190 = n14
					local u191 = t10[v190 - 1]

					if v190 <= 1 then
						u191 = nil
					end

					while u180 and widgets2 and widgets2[tostring(n14)] do
						n14 += 1
					end

					t12[n13] = {
						key = "localWidget_" .. v190,
						render = function() -- line: 569
							-- upvalues: React (copy), component (copy), s2 (copy), b3 (copy), n6 (ref), t9 (copy), p12 (copy), p15 (copy), p14 (copy), p13 (copy), u191 (ref), t10 (copy), v190 (copy), v127 (copy), v128 (copy), v129 (copy), v130 (copy), configuration (ref)
							return React.createElement(component, {
								searchUuid = s2,
								fromSearch = b3,
								itemsPerRow = n6,
								itemDetailsPeekViewRefs = t9,
								gridRef = p12,
								scrollingFrameRef = p15(),
								requestImpressionsSignal = p14,
								onFocusGained = p13,
								NextSelectionUp = u191,
								NextSelectionDown = t10[v190 + 1],
								ref = t10[v190],
								rowIndex = v190,
								gamepadNavigationColumn = v127,
								setGamepadNavigationColumn = v128,
								gamepadNavigationFocusPos = v129,
								setGamepadNavigationFocusPos = v130,
								widgetConfiguration = configuration
							})
						end
					}
					n13 += 1
					n14 += 1
					v186 = v184.getNext()
				end

				while u180 and widgets2 and widgets2[tostring(n14)] do
					n14 += 1
				end

				local v192 = n14
				local u193 = organicContentTemplates[tostring(n14)]

				if FFlagAXLookAndFeelBackgrounds and not u193 then
					u193 = {
						template = if not configuration then {} else configuration.defaultItemGroupTemplate
					}
				end

				if not u180 then
					u193 = nil
				end

				local v194 = if FFlagAXMoveAllTabToWidgetOnly then nil else u193 and (widgets and widgets[tostring(n14 + 1)] == nil)
				local u195 = nil

				if GetFFlagEnableDecreaseWidgetPaddingSizing() then
					local t13 = {
						[32] = v131.Size.Size_800,
						[24] = v131.Size.Size_600,
						[20] = v131.Size.Size_500,
						[16] = v131.Size.Size_400
					}

					u195 = if t13[GetFIntWidgetPaddingSizing()] ~= nil then t13[GetFIntWidgetPaddingSizing()] else v131.Size.Size_800
				end

				if b3 and v156 and v156.catalogSearchCategory == "Avatars" then
					local v197, v198 = CatalogUtils.removeItemFootersFromConfigs(configuration, u193, false, true, false)

					configuration = v197
					u193 = v198
				end

				t12[n13] = {
					key = "organicContentRow_" .. v192,
					render = function(t14: {[any]: any}?) -- line: 645
						-- upvalues: React (copy), OrganicContentRow (copy), u193 (ref), configuration (ref), FFlagAXLookAndFeelBackgrounds (copy), s2 (copy), v187 (copy), v194 (copy), GetFFlagEnableDecreaseWidgetPaddingSizing (copy), u195 (ref), v131 (copy), v188 (copy), n6 (ref), vector2 (copy), b3 (copy), t9 (copy), p12 (copy), p13 (copy), v127 (copy), v128 (copy), v129 (copy), v130 (copy), t10 (copy), v192 (copy), n11 (copy), p16 (copy), s4 (copy), v160 (copy), u161 (ref), FFlagAXCatalogCategoriesStoreImprovePerf (copy), u138 (ref), u139 (ref), u140 (ref)
						return React.createElement(OrganicContentRow, {
							template = if not u193 then if not configuration then {} else configuration.defaultItemGroupTemplate else u193.template,
							titleKey = if not u193 then nil else u193.template.title,
							titleText = if not u193 then nil else u193.template.localizedTitle,
							descriptionKey = if not u193 then nil else u193.template.description,
							descriptionText = if not u193 then nil else u193.template.localizedDescription,
							cardStyle = if not FFlagAXLookAndFeelBackgrounds or not u193 then nil else u193.template.cardStyle,
							searchUuid = s2,
							entryRowIndex = v187,
							catalogRowIndex = if not t14 or not t14.index then nil else t14.index - 1,
							padding = if not u193 or v194 then {
								bottom = UDim.new(0, v131.Size.Size_400)
							} else {
								bottom = UDim.new(0, if not GetFFlagEnableDecreaseWidgetPaddingSizing() then v131.Size.Size_800 else u195)
							},
							row = v188,
							itemsPerRow = n6,
							itemSize = vector2,
							fromSearch = b3,
							itemDetailsPeekViewRefs = t9,
							gridRef = p12,
							onFocusGained = p13,
							gamepadNavigationColumn = v127,
							setGamepadNavigationColumn = v128,
							gamepadNavigationFocusPos = v129,
							setGamepadNavigationFocusPos = v130,
							NextSelectionUp = t10[v192 - 1],
							NextSelectionDown = t10[v192 + 1],
							ref = t10[v192],
							thumbnailAspectRatio = n11,
							thumbnailScaleType = p16,
							thumbnailSize = s4,
							widgetConfiguration = configuration,
							onThumbnailLoaded = if not v160 then nil else u161,
							selectedCategory = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else u138,
							selectedSubcategory = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else u139,
							selectedCategoryInfo = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else u140
						})
					end
				}
				n13 += 1
				n14 += 1
			end
		end

		if u180 and widgets2 then
			local t15 = {}

			if Context and widgets2[Context] and s3 == widgets2[Context].id then
				local v200 = widgets2[Context]

				table.insert(t12, 1, (constructWidgetRenderInfo({
					rowIndex = 1,
					includeBottomDivider = false,
					key = "widget_" .. Context,
					ref = t10[Context],
					searchParameters = v143,
					organicResultIds = v178,
					widgetInfo = v200,
					widgetsPerRow = n7,
					itemSize = vector2,
					widgetRefCache = t10,
					focusedWidget = s3,
					onWidgetFocusAcquired = p10,
					onWidgetFocusReleased = p11,
					itemDetailsPeekViewRefs = t9,
					gridRef = p12,
					gamepadNavigationFocusPos = v129,
					setGamepadNavigationFocusPos = v130,
					widgetConfiguration = configuration,
					rowWidth = n12,
					onThumbnailLoaded = if v164 then nil else v165,
					selectedCategory = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else u138,
					selectedSubcategory = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else u139,
					selectedCategoryInfo = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else u140
				})))
			end

			for v201, _ in widgets2 do
				if tonumber(v201) ~= nil then
					table.insert(t15, (tonumber(v201)))
				end
			end

			table.sort(t15)

			local v203 = getRowInfoToInsertWidgets(t15, t12, widgets2, s3, v176, b4)

			for v204, v205 in v203 do
				local rowNum = v205.rowNum
				local widgetInfo = v205.widgetInfo
				local v208 = v204 < #v203 and v203[v204 + 1].rowNum ~= rowNum + 1
				local v209 = v204 == #v203 and rowNum < #t12

				table.insert(t12, rowNum, (constructWidgetRenderInfo({
					key = "widget_" .. rowNum,
					ref = t10[rowNum],
					nextSelectionUp = t10[rowNum - 1],
					nextSelectionDown = t10[rowNum + 1],
					organicResultIds = v178,
					searchParameters = v143,
					rowIndex = rowNum,
					widgetInfo = widgetInfo,
					widgetsPerRow = n7,
					itemSize = vector2,
					widgetRefCache = t10,
					focusedWidget = s3,
					onWidgetFocusAcquired = p10,
					onWidgetFocusReleased = p11,
					itemDetailsPeekViewRefs = t9,
					gridRef = p12,
					gamepadNavigationFocusPos = v129,
					setGamepadNavigationFocusPos = v130,
					includeBottomDivider = v208 or v209,
					widgetConfiguration = configuration,
					rowWidth = n12,
					onThumbnailLoaded = if v164 then nil else v165,
					selectedCategory = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else u138,
					selectedSubcategory = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else u139,
					selectedCategoryInfo = if not FFlagAXCatalogCategoriesStoreImprovePerf then nil else u140
				})))
			end

			if FFlagAXMoveAllTabToWidgetOnly and v186 and #t12 >= 11 then
				local component = v186.component

				table.insert(t12, 11, {
					key = "localWidget_sponsored",
					render = function() -- line: 833
						-- upvalues: React (copy), component (copy), s2 (copy), b3 (copy), n6 (ref), t9 (copy), p12 (copy), p15 (copy), p14 (copy), p13 (copy), t10 (copy), v127 (copy), v128 (copy), v129 (copy), v130 (copy), configuration (ref)
						return React.createElement(component, {
							rowIndex = 10,
							searchUuid = s2,
							fromSearch = b3,
							itemsPerRow = n6,
							itemDetailsPeekViewRefs = t9,
							gridRef = p12,
							scrollingFrameRef = p15(),
							requestImpressionsSignal = p14,
							onFocusGained = p13,
							NextSelectionUp = t10[9],
							NextSelectionDown = t10[11],
							ref = t10[10],
							gamepadNavigationColumn = v127,
							setGamepadNavigationColumn = v128,
							gamepadNavigationFocusPos = v129,
							setGamepadNavigationFocusPos = v130,
							widgetConfiguration = configuration
						})
					end
				})
				v184.getNext()
			end
		end

		if b3 and b2 then
			local v211 = s3 ~= nil

			table.insert(t12, 1, {
				key = "header",
				render = function() -- line: 865
					-- upvalues: React (copy), WidgetListResultsHeader (copy), s2 (copy), v211 (copy), b5 (copy)
					return React.createElement(WidgetListResultsHeader, {
						searchUuid = s2,
						hideResultsHeader = v211,
						pillBarVisible = b5
					})
				end
			})
		else
			n9 = (n9 or 0) + Constants.WidgetListVerticalMargin
		end

		if p17 then
			local v212 = n14

			table.insert(t12, {
				key = "loadMoreButton_" .. v212,
				render = function() -- line: 884
					-- upvalues: React (copy), WidgetListLoadMoreButton (copy), p17 (copy), t10 (copy), v212 (copy)
					return React.createElement(WidgetListLoadMoreButton, {
						onActivated = p17,
						ref = t10[v212],
						NextSelectionUp = t10[v212 - 1]
					})
				end
			})
		end

		if n9 then
			table.insert(t12, 1, {
				key = "topSpacer",
				render = function() -- line: 901
					-- upvalues: React (copy), WidgetListSpacer (copy), n9 (ref)
					return React.createElement(WidgetListSpacer, {
						height = n9
					})
				end
			})
		end

		if n10 then
			table.insert(t12, {
				key = "bottomSpacer",
				render = function() -- line: 910
					-- upvalues: React (copy), WidgetListSpacer (copy), n10 (copy)
					return React.createElement(WidgetListSpacer, {
						height = n10
					})
				end
			})
		end

		return t12
	end, {
		vector2,
		n6,
		n7,
		s2,
		t8,
		b2,
		n8,
		b3,
		n9,
		n10,
		s3,
		p10,
		p11,
		b4,
		t9,
		t10,
		p12,
		p13,
		p14,
		p15,
		widgets2,
		v143,
		v144,
		n11,
		p16,
		s4,
		Context,
		p17,
		v131,
		if not (not not v41 and AXCatalogPerfReduxReductionIXP.isEnabled()) and not v160 then nil else u161,
		n12
	}))
end

return useRenderInfo
