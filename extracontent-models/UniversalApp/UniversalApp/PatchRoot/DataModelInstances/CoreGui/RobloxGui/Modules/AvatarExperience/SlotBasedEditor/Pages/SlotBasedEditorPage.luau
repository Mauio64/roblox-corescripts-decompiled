local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local DeviceOrientationMode = require(CorePackages.Workspace.Packages.RobloxAppEnums).DeviceOrientationMode
local Cryo = require(CorePackages.Packages.Cryo)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarExperienceControlBar = require(CorePackages.Workspace.Packages.AvatarExperienceControlBar)
local AvatarExperienceSave = require(CorePackages.Workspace.Packages.AvatarExperienceSave)
local AvatarExperienceSlotBasedEditor = require(CorePackages.Workspace.Packages.AvatarExperienceSlotBasedEditor)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local IxpUtils = require(CorePackages.Workspace.Packages.IxpUtils)
local AppUserLayers = require(CorePackages.Workspace.Packages.ExperimentLayers).AppUserLayers
local NavigateToSearch = require(Modules.AvatarExperience.Catalog.Thunks.NavigateToSearch)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusOnMount = require(CorePackages.Workspace.Packages.FocusNavigationUtils).useFocusOnMount

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local FullView = AvatarExperienceCommon.Enums.FullView
local selectIsFullView = require(Modules.AvatarExperience.Common.Selectors.selectIsFullView)
local GetAvatarEditorCategories = require(Modules.AvatarExperience.AvatarEditor.GetAvatarEditorCategories)
local SetCategoryAndSubcategory = require(Modules.AvatarExperience.AvatarEditor.Thunks.SetCategoryAndSubcategory)
local SetCategoryAndSubcategory2 = require(Modules.AvatarExperience.AvatarEditor.Actions.SetCategoryAndSubcategory)
local Exit3DFullView = require(Modules.AvatarExperience.Common.Thunks.Exit3DFullView)
local NormalizeAvatar = require(Modules.AvatarExperience.AvatarEditor.Actions.NormalizeAvatar)
local SetFullView = require(Modules.AvatarExperience.Common.Thunks.SetFullView)
local Analytics = require(Modules.AvatarExperience.Common.Services.Analytics)
local Analytics2 = require(Modules.AvatarExperience.AvatarEditor.Services.Analytics)
local createInventoryStoresFromCategories = require(Modules.AvatarExperience.SlotBasedEditor.Utils.createInventoryStoresFromCategories)
local createSortAndFiltersStore = AvatarExperienceSlotBasedEditor.Stores.createSortAndFiltersStore
local sendAXCounterV2 = require(CorePackages.Workspace.Packages.AvatarExperienceAnalytics).sendAXCounterV2
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local useTokens = Foundation.Hooks.useTokens
local useSlotBasedEditorContextValue = require(script.Parent.useSlotBasedEditorContextValue)
local AvatarEditorTopBar = require(Modules.AvatarExperience.AvatarEditor.Components.AvatarEditorTopBar)
local AvatarExperienceView = require(Modules.AvatarExperience.Common.Components.AvatarExperienceView)
local AvatarNavigationItemsView = require(Modules.AvatarExperience.AvatarEditor.Components.AvatarNavigationItemsView)
local SlotsContainer = require(Modules.AvatarExperience.SlotBasedEditor.Components.Slots.SlotsContainer)
local UndoRedoBar = AvatarExperienceControlBar.UndoRedoBar
local SaveButton = AvatarExperienceSave.Components.SaveButton
local OnFocusExperimentExposureLogger = require(Modules.AvatarExperience.Catalog.Components.OnFocusExperimentExposureLogger)
local SlotBasedEditorContext = AvatarExperienceSlotBasedEditor.Context.SlotBasedEditorContext
local ScreenLayout = AvatarExperienceSlotBasedEditor.Enums.ScreenLayout
local ItemView = AvatarExperienceSlotBasedEditor.Enums.ItemView
local AvatarEditorCategories = AvatarExperienceSlotBasedEditor.Enums.AvatarEditorCategories
local NavigationParams = AvatarExperienceSlotBasedEditor.Enums.NavigationParams
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local Constants = require(Modules.AvatarExperience.Common.Constants)
local CatalogConstants = require(Modules.AvatarExperience.Catalog.CatalogConstants)
local AvatarExperienceFlags = require(CorePackages.Workspace.Packages.AvatarExperienceFlags)
local GetFFlagAXEnableNewInventoryItemsList = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableNewInventoryItemsList)
local GetFFlagAXEnableInventorySortsAndFilters = require(Modules.AvatarExperience.Flags.GetFFlagAXEnableInventorySortsAndFilters)
local GetFlagAXEnableInitialTopLevelPageCounter = require(Modules.AvatarExperience.Flags.GetFlagAXEnableInitialTopLevelPageCounter)
local FFlagAXCustomizeOverhaulEditorExposure = require(Modules.AvatarExperience.Flags.FFlagAXCustomizeOverhaulEditorExposure)
local FFlagAXModerationFeatureExposure = require(Modules.AvatarExperience.Flags.FFlagAXModerationFeatureExposure)
local GetFStringAXCatalogAndEditorExposureLayerName = require(Modules.AvatarExperience.Flags.GetFStringAXCatalogAndEditorExposureLayerName)
local FFlagAXCatalogAndEditorExposureUseFStringLayer = require(Modules.AvatarExperience.Flags.FFlagAXCatalogAndEditorExposureUseFStringLayer)
local FFlagAXAvatarEditorStoresContext = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXAvatarEditorStoresContext
local FFlagAXFixCatalogSearchRedirect = require(Modules.AvatarExperience.Flags.FFlagAXFixCatalogSearchRedirect)
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXSlotsPeekViewScrollFix = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXSlotsPeekViewScrollFix
local FFlagAXResetAvatarButton = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXResetAvatarButton
local FFlagAXRootSlotBasedEditorFlag = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXRootSlotBasedEditorFlag
local FFlagAXSlotsDesktopRedesign = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXSlotsDesktopRedesign
local FFlagAXEnableEnhancedAvatarHeadsFtux = AvatarExperienceFlags.FFlagAXEnableEnhancedAvatarHeadsFtux
local v74 = game:DefineFastString("AXModerationFeatureLayer", "AvatarExperience.UA.CustomizeView")
local FFlagAXCustomizeMakeupSupport = AvatarExperienceFlags.FFlagAXCustomizeMakeupSupport
local FFlagAXEnableEditorCategoryDeepLink = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXEnableEditorCategoryDeepLink
local FFlagAXFixEditorCategoryRenavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXFixEditorCategoryRenavigation
local FFlagAXMigrateSlotsSignals = require(CorePackages.Workspace.Packages.AvatarExperienceFlags).FFlagAXMigrateSlotsSignals
local FFlagAXSlotsDesignUpdatesExposureLogging = AvatarExperienceFlags.FFlagAXSlotsDesignUpdatesExposureLogging
local FStringAXSlotsDesignUpdatesExposureLayer = AvatarExperienceFlags.FStringAXSlotsDesignUpdatesExposureLayer
local v81 = game:DefineFastFlag("AXEditorBackendLayerExposure", false)
local v82 = game:DefineFastString("AXEditorBackendLayerName", "AvatarMarketplace.Editor")
local FFlagLuaAppsDefaultSelection = require(CorePackages.Workspace.Packages.SharedFlags).FFlagLuaAppsDefaultSelection
local useEnhancedAvatarHeadsFtux = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Hooks.useEnhancedAvatarHeadsFtux

local function getCategoryTitle(s1: string, p1) -- line: 130
	-- upvalues: ItemView (copy), GetAvatarEditorCategories (copy)
	if p1 == ItemView.SlotItems then
		for _, v95 in (GetAvatarEditorCategories()) do
			if s1 == v95.NavigationKey then
				return v95.Title or "Feature.Avatar.Label.Title.MyInventory"
			end
		end
	end

	return "Feature.Avatar.Label.Title.MyInventory"
end
local function getScreenLayout(t1: {[any]: any}) -- line: 143
	-- upvalues: ItemView (copy), ScreenLayout (copy)
	local isPortrait = t1.isPortrait
	local itemView = t1.itemView

	if isPortrait then
		if itemView ~= ItemView.Off then
			return ScreenLayout.PortraitItems
		end

		return ScreenLayout.PortraitSlots
	end

	return ScreenLayout.LandscapeSplit
end
local function v87(p2) -- line: 162
	-- upvalues: Cryo (copy)
	return not Cryo.isEmpty(p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems)
end
local function getSubcategoryNavKey(p3, n1: number?) -- line: 166
	if n1 and (p3.Subcategories and p3.Subcategories[n1]) then
		return p3.Subcategories[n1].NavigationKey
	end

	return nil
end
local function getSlotIndexForSubcategoryKey(p4, s2: string) -- line: 173
	for v104, v105 in p4 do
		if s2 == v105.editorSubcategory then
			return v104
		end
	end

	return nil
end

local v90 = if not FFlagAXCustomizeMakeupSupport then nil else function(p5) -- line: 183
	return p5.AvatarExperience.AvatarEditor.Categories.category
end

local function SlotBasedEditorPage() -- line: 188
	-- upvalues: useTokens (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), React (copy), RoactGamepad (copy), useAvatarRoute (copy), useNavigation (copy), useDispatch (copy), FFlagAXMigrateSlotsSignals (copy), useRoactService (copy), Analytics (copy), Analytics2 (copy), GetFFlagAXEnableNewInventoryItemsList (copy), createInventoryStoresFromCategories (copy), GetFFlagAXEnableInventorySortsAndFilters (copy), createSortAndFiltersStore (copy), FFlagAXSlotsPeekViewScrollFix (copy), useSelector (copy), v87 (copy), selectIsFullView (copy), DeviceOrientationMode (copy), FullView (copy), NavigationParams (copy), ItemView (copy), FFlagAXFixCatalogSearchRedirect (copy), useSlotBasedEditorContextValue (copy), SignalsReact (copy), FFlagAXSlotsDesktopRedesign (copy), AvatarExperienceSlotBasedEditor (copy), useLocalization (copy), GetAvatarEditorCategories (copy), ScreenLayout (copy), FFlagAXCustomizeMakeupSupport (copy), v90 (copy), FFlagAXEnableEditorCategoryDeepLink (copy), FFlagAXRootSlotBasedEditorFlag (copy), SetCategoryAndSubcategory2 (copy), SetCategoryAndSubcategory (copy), FFlagAXFixEditorCategoryRenavigation (copy), RoactNavigation (copy), AvatarEditorCategories (copy), Exit3DFullView (copy), AvatarScreen (copy), NavigateToSearch (copy), SetFullView (copy), AvatarEditorTopBar (copy), FFlagAXResetAvatarButton (copy), CatalogConstants (copy), Foundation (copy), UndoRedoBar (copy), SaveButton (copy), SlotsContainer (copy), GetFlagAXEnableInitialTopLevelPageCounter (copy), sendAXCounterV2 (copy), Constants (copy), FFlagAXEnableEnhancedAvatarHeadsFtux (copy), useEnhancedAvatarHeadsFtux (copy), FFlagAXCustomizeOverhaulEditorExposure (copy), IxpUtils (copy), FFlagAXCatalogAndEditorExposureUseFStringLayer (copy), GetFStringAXCatalogAndEditorExposureLayerName (copy), AppUserLayers (copy), FFlagAXModerationFeatureExposure (copy), v74 (copy), v81 (copy), v82 (copy), NormalizeAvatar (copy), FFlagLuaAppsDefaultSelection (copy), ReactFocusNavigation (copy), useFocusOnMount (copy), Focusable (copy), SlotBasedEditorContext (copy), FFlagAXAvatarEditorStoresContext (copy), AvatarExperienceView (copy), AvatarNavigationItemsView (copy), FFlagAXSlotsDesignUpdatesExposureLogging (copy), OnFocusExperimentExposureLogger (copy), FStringAXSlotsDesignUpdatesExposureLayer (copy)
	local v107 = useTokens()
	local v108 = if not FFlagAXMigrateAXToGlobalAutofocus then React.useRef(RoactGamepad.createFocusController()).current else nil
	local v109 = React.useRef(nil)
	local v110 = useAvatarRoute()
	local v111 = useNavigation()
	local v112 = useDispatch()
	local v113 = if not FFlagAXMigrateSlotsSignals then useRoactService(Analytics) else nil
	local v114 = useRoactService(Analytics2)
	local v115 = if FFlagAXMigrateSlotsSignals or not GetFFlagAXEnableNewInventoryItemsList() then nil else React.useMemo(createInventoryStoresFromCategories, {})
	local v116 = if FFlagAXMigrateSlotsSignals or not GetFFlagAXEnableInventorySortsAndFilters() then nil else React.useMemo(createSortAndFiltersStore, {})
	local v117 = nil
	local v118 = nil
	local g141 = nil
	local v140 = nil

	if FFlagAXSlotsPeekViewScrollFix then
		v117, v118 = React.useBinding(false)
	end

	local v119 = useSelector(v87)
	local v120 = useSelector(function(p6) -- line: 215
		-- upvalues: selectIsFullView (copy), v110 (copy)
		return selectIsFullView(p6, v110.opaque.name)
	end)
	local v121 = useSelector(function(p7) -- line: 218
		-- upvalues: DeviceOrientationMode (copy)
		return p7.DeviceOrientation == DeviceOrientationMode.Portrait
	end)
	local v122 = v120 == FullView.SceneFullView
	local v123 = v120 == FullView.UIFullView
	local v124 = v111.getParam(NavigationParams.itemView) or (v121 and ItemView.SlotItems or not v121 and ItemView.Off)
	local v125 = if not FFlagAXMigrateSlotsSignals then v111.getParam(NavigationParams.fromScreen) else nil
	local v126 = if FFlagAXMigrateSlotsSignals or not FFlagAXFixCatalogSearchRedirect then nil else v111.getParam(NavigationParams.params)
	local v127 = nil
	local v128 = if not FFlagAXMigrateSlotsSignals then nil else useSlotBasedEditorContextValue()
	local u129, setSlotCategory, setSlotIndex

	if FFlagAXMigrateSlotsSignals then
		u129 = SignalsReact.useSignalState(v128.signalStore.getSlotCategory)
		setSlotCategory = v128.signalStore.setSlotCategory
		setSlotIndex = v128.signalStore.setSlotIndex
	else
		local v132, v133 = React.useState(if not FFlagAXSlotsDesktopRedesign then if not v121 then AvatarExperienceSlotBasedEditor.Enums.Categories.Body else AvatarExperienceSlotBasedEditor.Enums.Categories.Avatars else if not v121 then AvatarExperienceSlotBasedEditor.Enums.Categories.All else AvatarExperienceSlotBasedEditor.Enums.Categories.Avatars)

		u129 = v132
		setSlotCategory = v133

		local v134

		v127, v134 = React.useState(1)
		setSlotIndex = v134
	end

	local v135 = useLocalization
	local t2 = {}
	local v137 = u129

	if v124 == ItemView.SlotItems then
		for _, v139 in (GetAvatarEditorCategories()) do
			if v137 == v139.NavigationKey then
				v140 = v139.Title or "Feature.Avatar.Label.Title.MyInventory"
				g141 = true
			end

			if g141 then
				break
			end
		end
	end

	if not g141 then
		v140 = "Feature.Avatar.Label.Title.MyInventory"
	end

	g141 = false
	t2.itemScreenTitle = v140

	local v142 = v135(t2)
	local screenLayout

	if FFlagAXMigrateSlotsSignals then
		screenLayout = v128.screenLayout
	else
		local t3 = {
			isPortrait = v121,
			itemView = v124
		}
		local isPortrait = t3.isPortrait
		local itemView = t3.itemView

		screenLayout = if not isPortrait then ScreenLayout.LandscapeSplit else if itemView == ItemView.Off then ScreenLayout.PortraitSlots else ScreenLayout.PortraitItems
	end

	local v147 = if not FFlagAXCustomizeMakeupSupport then nil else useSelector(v90)

	React.useEffect(function() -- line: 274
		-- upvalues: FFlagAXEnableEditorCategoryDeepLink (copy), v111 (copy), NavigationParams (copy), FFlagAXRootSlotBasedEditorFlag (copy), v121 (copy), FFlagAXCustomizeMakeupSupport (copy), u129 (ref), AvatarExperienceSlotBasedEditor (copy), v147 (copy), setSlotCategory (ref), v112 (copy), SetCategoryAndSubcategory2 (copy)
		if FFlagAXEnableEditorCategoryDeepLink and v111.getParam(NavigationParams.category) ~= nil then
			return
		end

		if FFlagAXRootSlotBasedEditorFlag and v121 and (not FFlagAXCustomizeMakeupSupport or u129 == AvatarExperienceSlotBasedEditor.Enums.Categories.All or v147 == 1) then
			if FFlagAXCustomizeMakeupSupport then
				setSlotCategory(AvatarExperienceSlotBasedEditor.Enums.Categories.Avatars)
			end

			v112(SetCategoryAndSubcategory2(2, nil))
		end
	end, if not FFlagAXCustomizeMakeupSupport then { v121 } else {
		v121,
		u129,
		v147
	})

	if FFlagAXEnableEditorCategoryDeepLink then
		local v148 = React.useCallback(function(p8, p9) -- line: 304
			-- upvalues: GetAvatarEditorCategories (copy), setSlotCategory (ref), v112 (copy), SetCategoryAndSubcategory (copy), v114 (copy), AvatarExperienceSlotBasedEditor (copy), setSlotIndex (ref)
			local v162 = p8 and GetAvatarEditorCategories()[p8]

			if not v162 or not v162.NavigationKey then
				return
			end

			setSlotCategory(v162.NavigationKey)
			v112(SetCategoryAndSubcategory(p8, p9, v114))

			local v163 = if not p9 or (not v162.Subcategories or not v162.Subcategories[p9]) then nil else v162.Subcategories[p9].NavigationKey

			if v163 then
				local v164 = AvatarExperienceSlotBasedEditor.Constants.SlotEditorCategories[v162.NavigationKey]

				if v164 and v164.slots then
					local g168 = nil
					local v167 = nil

					for v165, v166 in v164.slots do
						if v163 == v166.editorSubcategory then
							v167 = v165
							g168 = true
						end

						if g168 then
							break
						end
					end

					if not g168 then
						v167 = nil
					end

					g168 = false

					if v167 then
						setSlotIndex(v167)
					end
				end
			end
		end, {
			v112,
			v114
		})
		local v149 = v111.getParam(NavigationParams.category)
		local v150 = v111.getParam(NavigationParams.subcategory)

		React.useEffect(function() -- line: 330
			-- upvalues: v149 (copy), v148 (copy), v150 (copy), FFlagAXFixEditorCategoryRenavigation (copy), v111 (copy), NavigationParams (copy), RoactNavigation (copy)
			if v149 == nil then
				return
			end

			v148(v149, v150)

			if FFlagAXFixEditorCategoryRenavigation then
				v111.setParams({
					[NavigationParams.category] = RoactNavigation.None,
					[NavigationParams.subcategory] = RoactNavigation.None
				})
			end
		end, {
			v149,
			v150,
			v148
		})
	end

	local v151 = if not FFlagAXMigrateSlotsSignals then React.useCallback(function() -- line: 346
		-- upvalues: GetAvatarEditorCategories (copy), AvatarEditorCategories (copy), v112 (copy), SetCategoryAndSubcategory (copy), v114 (copy), Exit3DFullView (copy), v113 (copy), v111 (copy)
		for _, v170 in (GetAvatarEditorCategories()) do
			if v170.NavigationKey == AvatarEditorCategories.All then
				v112(SetCategoryAndSubcategory(v170.Category, nil, v114))

				break
			end
		end

		v112(Exit3DFullView(v113, v111.state.routeName))
	end, {
		v112,
		v113,
		v111.state.routeName,
		v114
	}) else nil
	local v152 = if not FFlagAXMigrateSlotsSignals then React.useCallback(function() -- line: 360
		-- upvalues: v110 (copy), AvatarScreen (copy), v111 (copy), NavigationParams (copy), ItemView (copy), v151 (copy), FFlagAXFixCatalogSearchRedirect (copy), v125 (copy), v126 (copy), v112 (copy), NavigateToSearch (copy), SetFullView (copy), v113 (copy), FullView (copy)
		local v171 = v110.current.name == AvatarScreen.LookDetails

		v111.navigate(AvatarScreen.AvatarEditor, {
			[NavigationParams.itemView] = ItemView.Off
		})

		if v171 then
			v111.navigate(AvatarScreen.LookDetails)
		end

		v151()

		if FFlagAXFixCatalogSearchRedirect and v125 == AvatarScreen.CatalogSearch and v125 ~= v110.opaque.name then
			if v126 and v126.searchParams then
				local t4 = {
					isKeywordSuggestionEnabled = true,
					searchKeyword = v126.searchParams.searchKeyword
				}

				v112(NavigateToSearch(v111, t4))
			end
		elseif v125 and v125 ~= v110.opaque.name then
			v111.navigate(v125)
		end

		v112(SetFullView(v113, v111.state.routeName, FullView.None))
	end, {
		v151,
		v111,
		v125
	}) else nil
	local v153 = React.useMemo(function() -- line: 391
		-- upvalues: React (copy), AvatarEditorTopBar (copy), v111 (copy), v110 (copy)
		return React.createElement(AvatarEditorTopBar, {
			navigation = v111,
			avatarRoute = v110
		})
	end, {
		v111,
		v110,
		screenLayout,
		u129,
		v142,
		v124
	})
	local v154 = React.useCallback(function(t5: {[any]: any}) -- line: 398
		-- upvalues: FFlagAXResetAvatarButton (copy), v119 (copy), CatalogConstants (copy), React (copy), Foundation (copy), v107 (copy), UndoRedoBar (copy), SaveButton (copy), SlotsContainer (copy)
		local v174 = not FFlagAXResetAvatarButton and (t5.showUndoRedo == nil or t5.showUndoRedo)
		local v175 = t5.showSaveButton ~= nil and t5.showSaveButton
		local v176 = not v119 and 0 or CatalogConstants.ActionBar.ActionBarHeight + CatalogConstants.ActionBar.ActionBarPadding

		return React.createElement(Foundation.View, {
			tag = "col anchor-bottom-left auto-xy size-full-0",
			ZIndex = 2,
			Position = UDim2.new(0, 0, 1, v107.Radius.Medium),
			padding = {
				bottom = UDim.new(0, v176)
			}
		}, {
			SceneButtons = React.createElement(Foundation.View, {
				tag = "auto-xy size-full-0",
				padding = {
					left = UDim.new(0, v107.Size.Size_500),
					bottom = UDim.new(0, v107.Size.Size_400),
					right = UDim.new(0, v107.Size.Size_500)
				}
			}, {
				BottomLeftButtons = React.createElement(Foundation.View, {
					tag = "auto-xy",
					Position = UDim2.fromScale(0, 0)
				}, {
					UndoRedoBar = v174 and React.createElement(UndoRedoBar)
				}),
				BottomRightButtons = React.createElement(Foundation.View, {
					tag = "auto-xy anchor-top-right",
					Position = UDim2.fromScale(1, 0)
				}, {
					SaveButton = v175 and React.createElement(SaveButton)
				})
			}),
			SlotsContainer = React.createElement(SlotsContainer)
		})
	end, { v119 })

	if GetFlagAXEnableInitialTopLevelPageCounter() then
		React.useEffect(function() -- line: 447
			-- upvalues: sendAXCounterV2 (copy), Constants (copy)
			sendAXCounterV2(Constants.Counter.TopLevelPageInitialView.SlotBasedEditor)
		end, {})
	end

	if FFlagAXEnableEnhancedAvatarHeadsFtux then
		useEnhancedAvatarHeadsFtux()
	end

	if FFlagAXCustomizeOverhaulEditorExposure then
		React.useEffect(function() -- line: 458
			-- upvalues: IxpUtils (copy), FFlagAXCatalogAndEditorExposureUseFStringLayer (copy), GetFStringAXCatalogAndEditorExposureLayerName (copy), AppUserLayers (copy)
			IxpUtils.logLayerExposure(if not FFlagAXCatalogAndEditorExposureUseFStringLayer then AppUserLayers.AvatarExperienceUAAllViews else GetFStringAXCatalogAndEditorExposureLayerName())
		end, {})
	end

	if FFlagAXModerationFeatureExposure then
		React.useEffect(function() -- line: 468
			-- upvalues: IxpUtils (copy), v74 (copy)
			IxpUtils.logLayerExposure(v74)
		end, {})
	end

	if v81 then
		React.useEffect(function() -- line: 475
			-- upvalues: IxpUtils (copy), v82 (copy)
			IxpUtils.logLayerExposure(v82)
		end, {})
	end

	if FFlagAXCustomizeMakeupSupport then
		React.useEffect(function() -- line: 483
			-- upvalues: v110 (copy), AvatarScreen (copy), v112 (copy), NormalizeAvatar (copy)
			if v110.opaque.name == AvatarScreen.AvatarEditor then
				v112(NormalizeAvatar())
			end
		end, { v110.opaque.name })
	end

	local v155 = nil
	local v156 = nil

	if FFlagLuaAppsDefaultSelection then
		local v157

		v157, v156 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior()
		v155 = useFocusOnMount(v157)
	end

	return React.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v108 else nil,
		ref = if not FFlagLuaAppsDefaultSelection then nil else v156
	}, {
		SlotBasedEditorContext = React.createElement(SlotBasedEditorContext.Provider, {
			value = if not FFlagAXMigrateSlotsSignals then {
				handleExitPortraitItems = v152,
				itemView = v124,
				slotCategory = u129,
				setSlotCategory = setSlotCategory,
				screenLayout = screenLayout,
				slotIndex = v127,
				setSlotIndex = setSlotIndex,
				categoryInventoryStores = if not GetFFlagAXEnableNewInventoryItemsList() or FFlagAXAvatarEditorStoresContext then nil else v115,
				sortAndFiltersStore = if not GetFFlagAXEnableInventorySortsAndFilters() or FFlagAXAvatarEditorStoresContext then nil else v116
			} else v128
		}, {
			AvatarExperienceView = React.createElement(AvatarExperienceView, {
				bottomBarEnabled = false,
				showControlBar = true,
				showRobuxBalance = true,
				showUndoRedo = screenLayout == ScreenLayout.PortraitItems or screenLayout == ScreenLayout.LandscapeSplit,
				showSaveButton = screenLayout == ScreenLayout.PortraitItems,
				allowAdaptiveScrolling = screenLayout ~= ScreenLayout.PortraitSlots,
				isSceneFullView = v122,
				isUIFullView = v123,
				topBar = v153,
				multiTryOnBottomBarRef = v109,
				disableScrollViewBindings = if not FFlagAXSlotsPeekViewScrollFix then nil else v117,
				sceneUi = if FFlagAXSlotsDesktopRedesign or (screenLayout ~= ScreenLayout.LandscapeSplit or v122) then nil else v154({
					showUndoRedo = false
				})
			}, {
				Inventory = (screenLayout == ScreenLayout.LandscapeSplit or screenLayout == ScreenLayout.PortraitItems) and React.createElement(AvatarNavigationItemsView, {
					updateDisableScrollView = if not FFlagAXSlotsPeekViewScrollFix then nil else v118,
					defaultFocusRef = if not FFlagLuaAppsDefaultSelection then nil else v155
				}),
				SlotsContainer = if screenLayout ~= ScreenLayout.PortraitSlots or v122 then nil else v154({})
			})
		}),
		OnFocusExperimentExposureLogger = if not FFlagAXSlotsDesignUpdatesExposureLogging then nil else React.createElement(OnFocusExperimentExposureLogger, {
			ixpTests = {},
			flagIXPTestLayers = if not FFlagAXSlotsDesignUpdatesExposureLogging then nil else { if not FFlagAXSlotsDesignUpdatesExposureLogging then nil else FStringAXSlotsDesignUpdatesExposureLayer }
		})
	})
end

return (withStackVisibilityWrapper(SlotBasedEditorPage))
