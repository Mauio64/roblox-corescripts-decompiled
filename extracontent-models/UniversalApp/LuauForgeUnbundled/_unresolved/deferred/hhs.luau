local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local deviceOrientationMode = require("@game/CorePackages/Workspace/Packages/_Workspace/PurchasePromptLite/RobloxAppEnums").DeviceOrientationMode
local Cryo = require(CorePackages.Packages.Cryo)
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local Foundation = require(CorePackages.Packages.Foundation)
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local module2 = require("@luauforge/deferred/gTu")
local module3 = require("@luauforge/bundled/gKz")
local module4 = require("@luauforge/bundled/fCn")
local module5 = require("@luauforge/bundled/dPt")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local module7 = require("@luauforge/bundled/dPR")
local appUserLayers = require("@luauforge/bundled/dPQ").AppUserLayers
local module8 = require("@luauforge/deferred/fDP")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusOnMount = require("@luauforge/bundled/ehL").useFocusOnMount

require("@luauforge/bundled/dKT")

local fullView = AvatarExperienceCommon.Enums.FullView
local module9 = require("@luauforge/bundled/gSI")
local module10 = require("@luauforge/bundled/fCe")
local module11 = require("@luauforge/bundled/dRz")
local module12 = require("@luauforge/deferred/gJZ")
local module13 = require("@luauforge/bundled/dSf")
local module14 = require("@luauforge/deferred/heG")
local module15 = require("@luauforge/bundled/dRS")
local module16 = require("@luauforge/bundled/gSD")
local avatarExperienceAnalyticsService = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").AvatarExperienceAnalyticsService
local module17 = require("@luauforge/bundled/gJz")

local module18 = require("@luauforge/deferred/hht")
local createSortAndFiltersStore = module4.Stores.createSortAndFiltersStore
local sendAXCounterV2 = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendAXCounterV2

local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local module19 = require("@luauforge/bundled/eie")
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local module20 = require("@luauforge/deferred/gRz")
local useTokens = Foundation.Hooks.useTokens
local module21 = require("@luauforge/deferred/hhu")
local module22 = require("@luauforge/deferred/hhx")

local module23 = require("@luauforge/deferred/hfo")
local module24 = require("@luauforge/deferred/gTt")
local module25 = require("@luauforge/deferred/hax")
local module26 = require("@luauforge/deferred/heZ")
local undoRedoBar = module2.UndoRedoBar
local saveButton = module3.Components.SaveButton

local module27 = require("@luauforge/deferred/gUI")

local slotBasedEditorContext = module4.Context.SlotBasedEditorContext
local screenLayout = module4.Enums.ScreenLayout
local itemView = module4.Enums.ItemView
local avatarEditorCategories = module5.Enums.AvatarEditorCategories
local navigationParams = module4.Enums.NavigationParams
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local module28 = require("@luauforge/bundled/dPN")
local module29 = require("@luauforge/bundled/dPU")

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local module31 = require("@luauforge/bundled/dRr")

local module32 = require("@luauforge/deferred/haU")

local module33 = require("@luauforge/deferred/hfA")
local module34 = require("@luauforge/deferred/hhy")

local module35 = require("@luauforge/deferred/hfC")

local module36 = require("@luauforge/deferred/hfB")

local fFlagAXAvatarEditorStoresContext = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXAvatarEditorStoresContext
local module37 = require("@luauforge/deferred/hhw")

local fFlagAXSlotsPeekViewScrollFix = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXSlotsPeekViewScrollFix
local fFlagAXResetAvatarButton = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXResetAvatarButton

local fFlagAXSlotsDesktopRedesign = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXSlotsDesktopRedesign

local defineFastString = game:DefineFastString(
	"AXModerationFeatureLayer",
	"AvatarExperience.UA.CustomizeView"
)

local fFlagAXEnableEditorCategoryDeepLink = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXEnableEditorCategoryDeepLink
local fFlagAXCustomizeTabDeepLink = AvatarExperienceFlags.FFlagAXCustomizeTabDeepLink

local fFlagAXFixEditorCategoryRenavigation = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXFixEditorCategoryRenavigation

local fFlagAXMigrateSlotsSignals = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXMigrateSlotsSignals
local fFlagAXSlotsDesignUpdatesExposureLogging = AvatarExperienceFlags.FFlagAXSlotsDesignUpdatesExposureLogging
local fFlagAXTimeoutAcknowledgementGating = AvatarExperienceFlags.FFlagAXTimeoutAcknowledgementGating
local fStringAXSlotsDesignUpdatesExposureLayer = AvatarExperienceFlags.FStringAXSlotsDesignUpdatesExposureLayer
local defineFastFlag = game:DefineFastFlag("AXEditorBackendLayerExposure", false)
local defineFastString2 = game:DefineFastString("AXEditorBackendLayerName", "AvatarMarketplace.Editor")
local module38 = require("@luauforge/deferred/hhz")

local defineFastFlag2 = game:DefineFastFlag("AXCustomizeViewDefaultExposureLogging", false)

local useEnhancedAvatarHeadsFtux = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon").Hooks.useEnhancedAvatarHeadsFtux

local function getCategoryTitle(p2, p3)
	if p3 ~= itemView.SlotItems then
		return "Feature.Avatar.Label.Title.MyInventory"
	end

	local v5 = module11()

	for k, v6 in v5 do
		if v6.NavigationKey == p2 then
			return v6.Title or "Feature.Avatar.Label.Title.MyInventory"
		end
	end

	return "Feature.Avatar.Label.Title.MyInventory"
end

local function getScreenLayout(p2)
	local isPortrait = p2.isPortrait
	local itemView2 = p2.itemView

	if not isPortrait then
		return screenLayout.LandscapeSplit
	end

	if itemView2 == itemView.Off then
		return screenLayout.PortraitSlots
	end

	return screenLayout.PortraitItems
end

local function fn(p2): boolean
	return not Cryo.isEmpty(p2.AvatarExperience.AvatarScene.OutfitTryOn.TryOnItems)
end

local function getSubcategoryNavKey(p2, p3)
	if p3 and p2.Subcategories and p2.Subcategories[p3] then
		return p2.Subcategories[p3].NavigationKey
	end

	return nil
end

local function getSlotIndexForSubcategoryKey(items, p2)
	for k, item in items do
		if item.editorSubcategory == p2 then
			return k
		end
	end

	return nil
end

local function fn2(p2)
	return p2.AvatarExperience.AvatarEditor.Categories.category
end

local function SlotBasedEditorPage()
	local v5 = useTokens()
	local ref = React.useRef(nil)

	local v6 = useAvatarRoute()
	local v7 = useNavigation()
	local v8 = useDispatch()

	if fFlagAXTimeoutAcknowledgementGating then
		AvatarExperienceCommon.Hooks.useAvatarChangeAcknowledgementPrompt(v6.isVisible and module10.isRouteInAvatarEditor(v6))
	end

	local v9 = if not fFlagAXMigrateSlotsSignals then module19(avatarExperienceAnalyticsService) else nil
	local v10 = module19(module17)
	local v11

	if not (fFlagAXMigrateSlotsSignals or not module31()) then
		v11 = React.useMemo(module18, {})
	end

	local v12

	if not (fFlagAXMigrateSlotsSignals or not module32()) then
		v12 = React.useMemo(createSortAndFiltersStore, {})
	end

	local v13, v14

	if fFlagAXSlotsPeekViewScrollFix then
		v13, v14 = React.useBinding(false)
	end

	local v15 = useSelector(fn)

	local v16 = useSelector(function(p2)
		return module9(p2, v6.opaque.name)
	end)

	local v17 = useSelector(function(p2): boolean
		return p2.DeviceOrientation == deviceOrientationMode.Portrait
	end)

	local v18 = v16 == fullView.SceneFullView
	local v19 = v16 == fullView.UIFullView

	local v20 = if module38 then module22() else nil

	local v21 = v7.getParam(navigationParams.itemView)
		or v17 and itemView.SlotItems
		or not v17 and itemView.Off

	local v22 = if not fFlagAXMigrateSlotsSignals then v7.getParam(navigationParams.fromScreen) else nil
	local v23

	if fFlagAXMigrateSlotsSignals or not module37 then
		v23 = nil
	else
		v23 = v7.getParam(navigationParams.params)
	end

	local state = nil

	local v24 = if fFlagAXMigrateSlotsSignals then module21() else nil
	local state2, setState, setState2

	if fFlagAXMigrateSlotsSignals then
		state2 = SignalsReact.useSignalState(v24.signalStore.getSlotCategory)
		setState = v24.signalStore.setSlotCategory
		setState2 = v24.signalStore.setSlotIndex
	else
		local useState = React.useState
		local v25

		if fFlagAXSlotsDesktopRedesign then
			v25 = if v17 then module4.Enums.Categories.Avatars else module4.Enums.Categories.All
		else
			v25 = if v17 then module4.Enums.Categories.Avatars else module4.Enums.Categories.Body
		end

		state2, setState = useState(v25)

		state, setState2 = React.useState(1)
	end

	local v26 = { itemScreenTitle = 0 }
	local v27 = state2
	local v28

	if v21 == itemView.SlotItems then
		local v29 = module11()
		local flag = true

		for k, v30 in v29 do
			if v30.NavigationKey == v27 then
				v28 = v30.Title or "Feature.Avatar.Label.Title.MyInventory"
				flag = false
				break
			end
		end

		if flag then
			v28 = "Feature.Avatar.Label.Title.MyInventory"
		end
	else
		v28 = "Feature.Avatar.Label.Title.MyInventory"
	end

	v26.itemScreenTitle = v28
	local v29 = useLocalization(v26)
	local v30

	if fFlagAXMigrateSlotsSignals then
		v30 = v24.screenLayout
	else
		local v31 = { isPortrait = v17, itemView = v21 }
		local isPortrait = v31.isPortrait
		local itemView2 = v31.itemView

		if isPortrait then
			if itemView2 == itemView.Off then
				v30 = screenLayout.PortraitSlots
			else
				v30 = screenLayout.PortraitItems
			end
		else
			v30 = screenLayout.LandscapeSplit
		end
	end

	local v31 = useSelector(fn2)

	React.useEffect(function()
		if fFlagAXEnableEditorCategoryDeepLink and v7.getParam(navigationParams.category) ~= nil then
			return
		end

		if
			fFlagAXCustomizeTabDeepLink
			and v7.getParam(navigationParams.customizeTab) ~= nil
			and v7.getParam(navigationParams.category) ~= nil
		then
			return
		end

		if v17 and (state2 == module4.Enums.Categories.All or v31 == 1) then
			setState(module4.Enums.Categories.Avatars)

			v8(module13(2, nil))
		end
	end, { v17, state2, v31 })

	if fFlagAXEnableEditorCategoryDeepLink or fFlagAXCustomizeTabDeepLink then
		local v32 = React.useCallback(function(p2, p3)
			local v33 = p2 and module11()[p2]

			if not (v33 and v33.NavigationKey) then
				return
			end

			setState(v33.NavigationKey)
			v8(module12(p2, p3, v10))
			local navigationKey

			if p3 and v33.Subcategories and v33.Subcategories[p3] then
				navigationKey = v33.Subcategories[p3].NavigationKey
			end

			if navigationKey then
				local slotEditorCategory = module4.Constants.SlotEditorCategories[v33.NavigationKey]

				if slotEditorCategory and slotEditorCategory.slots then
					local v34 = nil

					for k, slot in slotEditorCategory.slots do
						if slot.editorSubcategory == navigationKey then
							v34 = k
							break
						end
					end

					if v34 then
						setState2(v34)
					end
				end
			end
		end, { v8, v10 })

		local param = v7.getParam(navigationParams.category)
		local param2 = v7.getParam(navigationParams.subcategory)

		React.useEffect(function()
			if param == nil then
				return
			end

			v32(param, param2)

			if fFlagAXFixEditorCategoryRenavigation then
				if fFlagAXCustomizeTabDeepLink then
					v7.setParams({
						[navigationParams.category] = RoactNavigation.None,
						[navigationParams.subcategory] = RoactNavigation.None,
						[navigationParams.customizeTab] = RoactNavigation.None
					})
				else
					v7.setParams({
						[navigationParams.category] = RoactNavigation.None,
						[navigationParams.subcategory] = RoactNavigation.None
					})
				end
			end
		end, { param, param2, v32 })
	end

	local v32

	if fFlagAXMigrateSlotsSignals then
		v32 = nil
	else
		v32 = React.useCallback(function()
			local v33 = module11()

			for k, v34 in v33 do
				if v34.NavigationKey == avatarEditorCategories.All then
					v8(module12(v34.Category, nil, v10))
					break
				end
			end

			v8(module14(v9, v7.state.routeName))
		end, { v8, v9, v7.state.routeName, v10 })
	end

	local v33

	if not fFlagAXMigrateSlotsSignals then
		v33 = React.useCallback(function()
			local v34 = v6.current.name == avatarScreen.LookDetails
			v7.navigate(avatarScreen.AvatarEditor, {
				[navigationParams.itemView] = itemView.Off
			})

			if v34 then
				v7.navigate(avatarScreen.LookDetails)
			end

			v32()

			if module37 and v22 == avatarScreen.CatalogSearch and v22 ~= v6.opaque.name then
				if v23 and v23.searchParams then
					v8(module8(v7, {
						searchKeyword = v23.searchParams.searchKeyword,
						isKeywordSuggestionEnabled = true
					}))
				end
			elseif v22 and v22 ~= v6.opaque.name then
				v7.navigate(v22)
			end

			v8(module16(v9, v7.state.routeName, fullView.None))
		end, { v32, v7, v22 })
	end

	local v34 = React.useMemo(function()
		return React.createElement(module23, { navigation = v7, avatarRoute = v6 })
	end, { v7, v6, v30, state2, v29, v21 })

	local v35 = React.useCallback(function(p2)
		local v36 = not fFlagAXResetAvatarButton and (p2.showUndoRedo == nil or p2.showUndoRedo)
		local v37 = not (p2.showSaveButton == nil) and p2.showSaveButton

		local v38 = not v15 and 0
			or module29.ActionBar.ActionBarHeight + module29.ActionBar.ActionBarPadding

		return React.createElement(Foundation.View, {
			tag = "col anchor-bottom-left auto-xy size-full-0",
			Position = UDim2.new(0, 0, 1, v5.Radius.Medium),
			padding = { bottom = UDim.new(0, v38) },
			ZIndex = 2
		}, {
			SceneButtons = React.createElement(Foundation.View, {
				tag = "auto-xy size-full-0",
				padding = {
					left = UDim.new(0, v5.Size.Size_500),
					bottom = UDim.new(0, v5.Size.Size_400),
					right = UDim.new(0, v5.Size.Size_500)
				}
			}, {
				BottomLeftButtons = React.createElement(
					Foundation.View,
					{ tag = "auto-xy", Position = UDim2.fromScale(0, 0) },
					{
						UndoRedoBar = v36 and React.createElement(undoRedoBar)
					}
				),
				BottomRightButtons = React.createElement(
					Foundation.View,
					{
						tag = "auto-xy anchor-top-right",
						Position = UDim2.fromScale(1, 0)
					},
					{
						SaveButton = v37 and React.createElement(saveButton)
					}
				)
			}),
			SlotsContainer = React.createElement(module26)
		})
	end, { v15 })

	React.useEffect(function()
		sendAXCounterV2(module28.Counter.TopLevelPageInitialView.SlotBasedEditor)
	end, {})

	useEnhancedAvatarHeadsFtux()

	if module33 then
		React.useEffect(function()
			local logLayerExposure = module7.logLayerExposure

			local v36 = if module36 then module35() else appUserLayers.AvatarExperienceUAAllViews
			logLayerExposure(v36)
		end, {})
	end

	if module34 then
		React.useEffect(function()
			module7.logLayerExposure(defineFastString)
		end, {})
	end

	if defineFastFlag then
		React.useEffect(function()
			module7.logLayerExposure(defineFastString2)
		end, {})
	end

	React.useEffect(function()
		if v6.opaque.name == avatarScreen.AvatarEditor then
			v8(module15())
		end
	end, { v6.opaque.name })

	local v36, v37 = ReactFocusNavigation.useMostRecentOrDefaultFocusBehavior()
	local v38 = useFocusOnMount(v36)

	local createElement = React.createElement
	local frame = focusable.Frame
	local v39 = { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ref = v37 }

	local createElement2 = React.createElement
	local provider = slotBasedEditorContext.Provider

	if not fFlagAXMigrateSlotsSignals then
		v24 = {
			handleExitPortraitItems = v33,
			itemView = v21,
			slotCategory = state2,
			setSlotCategory = setState,
			screenLayout = v30,
			slotIndex = state,
			setSlotIndex = setState2,
			categoryInventoryStores = 0,
			sortAndFiltersStore = 0
		}

		if not module31() or fFlagAXAvatarEditorStoresContext then
			v11 = nil
		end

		v24.categoryInventoryStores = v11

		if not module32() or fFlagAXAvatarEditorStoresContext then
			v12 = nil
		end

		v24.sortAndFiltersStore = v12
	end

	local createElement3 = React.createElement
	local v44 = {
		bottomBarEnabled = false,
		showControlBar = true,
		showRobuxBalance = true,
		showUndoRedo = v30 == screenLayout.PortraitItems or v30 == screenLayout.LandscapeSplit,
		showSaveButton = v30 == screenLayout.PortraitItems,
		allowAdaptiveScrolling = v30 ~= screenLayout.PortraitSlots,
		isSceneFullView = v18,
		isUIFullView = v19,
		changeViewFunction = v20,
		topBar = v34,
		multiTryOnBottomBarRef = ref,
		disableScrollViewBindings = 0,
		sceneUi = 0
	}

	if not fFlagAXSlotsPeekViewScrollFix then
		v13 = nil
	end

	v44.disableScrollViewBindings = v13

	local v45 = if not fFlagAXSlotsDesktopRedesign and v30 == screenLayout.LandscapeSplit and not v18 then v35({
		showUndoRedo = false
	}) else nil
	v44.sceneUi = v45
	local v47

	if v30 == screenLayout.LandscapeSplit or v30 == screenLayout.PortraitItems then
		local createElement4 = React.createElement

		if not fFlagAXSlotsPeekViewScrollFix then
			v14 = nil
		end

		v47 = createElement4(module25, {
			updateDisableScrollView = v14,
			defaultFocusRef = v38
		})
	else
		v47 = false
	end

	local v48 = if v30 == screenLayout.PortraitSlots and not v18 then v35({}) else nil
	local v40 = {
		SlotBasedEditorContext = createElement2(provider, { value = v24 }, {
			AvatarExperienceView = createElement3(module24, v44, {
				Inventory = v47,
				SlotsContainer = v48
			})
		}),
		OnFocusExperimentExposureLogger = 0
	}
	local v49

	if defineFastFlag2 or fFlagAXSlotsDesignUpdatesExposureLogging then
		local createElement4 = React.createElement

		local avatarExperienceUACustomizeView = if defineFastFlag2 then appUserLayers.AvatarExperienceUACustomizeView else nil
		v49 = createElement4(module27, {
			ixpTests = {},
			flagIXPTestLayers = {
				avatarExperienceUACustomizeView,
				if fFlagAXSlotsDesignUpdatesExposureLogging then fStringAXSlotsDesignUpdatesExposureLayer else nil
			}
		})
	end

	v40.OnFocusExperimentExposureLogger = v49
	return createElement(frame, v39, v40)
end

return (module20(SlotBasedEditorPage))
