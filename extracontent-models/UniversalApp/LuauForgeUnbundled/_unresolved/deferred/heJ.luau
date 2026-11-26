local CorePackages = game:GetService("CorePackages")

local GuiService = game:GetService("GuiService")

local React = require(CorePackages.Packages.React)
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local AvatarExperienceDeps = require(CorePackages.Packages.AvatarExperienceDeps)
local fitFrameHorizontal = AvatarExperienceDeps.RoactFitComponents.FitFrameHorizontal
local useInputType = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useInputType
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local Foundation = require(CorePackages.Packages.Foundation)
local useTokens = Foundation.Hooks.useTokens
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local useFocusGuiObject = ReactFocusNavigation.useFocusGuiObject

local module = require("@game/CorePackages/Packages/_Index/UIBlox/UIBlox/App/Control/HorizontalNav/ScrollingListWithArrowsAndGradient")
local module2 = require("@luauforge/bundled/dzD")
local module3 = require("@luauforge/deferred/heQ")
local module4 = require("@luauforge/deferred/heR")
local module5 = require("@luauforge/bundled/dRz")
local module6 = require("@luauforge/bundled/dPN")
local module7 = require("@luauforge/bundled/dRg")
local module8 = require("@luauforge/bundled/fCI")

local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local findValueKeyInRefCache = AvatarExperienceCommon.Utils.RoactGamepadMigration.findValueKeyInRefCache
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local AvatarExperienceFlags = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags")

local module11 = require("@luauforge/bundled/dRs")

local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local unifiedLoggingSurface = AvatarExperienceNavigation.Enums.UnifiedLoggingSurface
local selectors = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").Selectors
local module13 = require("@luauforge/bundled/dVl")

local module14 = require("@luauforge/deferred/heU")

local fFlagAXEnableEditorCategoryDeepLink = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXEnableEditorCategoryDeepLink
local fFlagUseNavigationSelectors = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagUseNavigationSelectors

local fFlagSignalsNavP3gAvatarExperience = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagSignalsNavP3gAvatarExperience
local Signals = require(CorePackages.Packages.Signals)

local SignalsReact = require(CorePackages.Packages.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local getLegacyNavigationStore

if fFlagSignalsNavP3gAvatarExperience then
	getLegacyNavigationStore = require("@game/CorePackages/Workspace/Packages/_Workspace/RobloxAppToastsRodux/NavigationRodux").GetLegacyNavigationStore
else
	getLegacyNavigationStore = nil
end

local fFlagAXCategoryUnifiedLogging = AvatarExperienceFlags.FFlagAXCategoryUnifiedLogging
local fFlagAXUnifiedEventStrictPayloads = AvatarExperienceFlags.FFlagAXUnifiedEventStrictPayloads

local unifiedEventLogEnums = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").UnifiedEventLogEnums

local sendUnifiedEventLogForInstance = require("@game/CorePackages/Workspace/Packages/AvatarExperienceAnalytics").sendUnifiedEventLogForInstance

local avatarScreenProperties = AvatarExperienceNavigation.AvatarRoute.AvatarScreenProperties

local fFlagAXCatalogCategoriesSDUI = AvatarExperienceFlags.FFlagAXCatalogCategoriesSDUI
local fFlagAXMigrateCategoryTooltip = AvatarExperienceFlags.FFlagAXMigrateCategoryTooltip
local fFlagAXMoveCatalogFilterToL1Navigation = AvatarExperienceFlags.FFlagAXMoveCatalogFilterToL1Navigation

local forwardRef = React.forwardRef(function(props, p2)
	local state, setState = React.useState(nil)

	local v5 = RoactGamepad.useRefCache()
	local v6 = RoactGamepad.useRefCache()
	local ref = React.useRef(nil)

	local v7 = useTokens()
	local v8 = useInputType()
	local v9

	if fFlagSignalsNavP3gAvatarExperience then
		local legacyNavigationStore = getLegacyNavigationStore(false)
		v9 = useSignalState((React.useMemo(function()
			return Signals.createComputed(function(p3)
				if not fFlagAXCategoryUnifiedLogging then
					return nil
				end

				local currentRoute = legacyNavigationStore.getCurrentRoute(p3)
				local v11 = currentRoute and avatarScreenProperties[currentRoute.routeName]

				if v11 and v11.analyticsData then
					return v11.analyticsData.unifiedLoggingSurface
				end

				return nil
			end)
		end, {})))
	else
		v9 = useSelector(function(p3)
			if not fFlagAXCategoryUnifiedLogging then
				return nil
			end

			local v10

			if fFlagUseNavigationSelectors then
				v10 = selectors.selectCurrentRoactNavigationRoute(p3)
			else
				v10 = p3.Navigation and p3.Navigation.currentRoute
			end

			local v11 = v10 and avatarScreenProperties[v10.routeName]

			if v11 and v11.analyticsData then
				return v11.analyticsData.unifiedLoggingSurface
			end

			return nil
		end)
	end

	local v10 = useFocusGuiObject()

	local v15 = useTableWrappedCallbackRef((module14({
		onTabBackward = React.useCallback(function(p3)
			p3.cancelled = true
			local valueKeyInRefCache = findValueKeyInRefCache(GuiService.SelectedCoreObject, v5)

			if valueKeyInRefCache and valueKeyInRefCache > 1 and v10 then
				v10(v5[valueKeyInRefCache - 1].current)
			end
		end, { v10 }),
		onTabForward = React.useCallback(function(p3)
			p3.cancelled = true
			local valueKeyInRefCache = findValueKeyInRefCache(GuiService.SelectedCoreObject, v5)

			if valueKeyInRefCache and valueKeyInRefCache < #v5 and v10 then
				v10(v5[valueKeyInRefCache + 1].current)
			end
		end, { v10 }),
		onNavigateBack = React.useCallback(function(p3)
			p3.cancelled = true

			if v10 and props.NextSelectionUp and props.NextSelectionUp.current then
				v10(props.NextSelectionUp.current)
			end
		end, { v10, props.NextSelectionUp })
	}, ref)))

	local v16 = useSelector(function(p3)
		return p3.AvatarExperience.AvatarEditor.NewItemNotifications
	end, getUseSelectorDeepEquals())

	local v17 = React.useCallback(function(value, p3)
		local current = ref.current

		local v18 = (value or 0) - 50

		if current then
			local x = current.AbsoluteWindowSize.X

			if not x or x == 0 then
				return
			end

			local v19 = value + p3 > 0 and value + p3 < x
			local v20 = value > 0 and value < x

			if not (v20 or v19) then
				current.CanvasPosition = Vector2.new(v18, current.CanvasPosition.Y)
			end
		end
	end, {})

	local v18 = React.useCallback(function(): boolean
		local current

		if props.shouldUseCategoryId then
			if props.selectedCategoryId then
				current = v6[props.selectedCategoryId].current
			end
		elseif props.selectedCategoryIndex then
			current = v6[props.selectedCategoryIndex].current
		end

		if current == nil then
			return false
		end

		v17(current.AbsolutePosition.X, current.AbsoluteSize.X)
		setState(current)

		return true
	end, { props.selectedCategoryIndex, props.selectedCategoryId })

	if not fFlagAXEnableEditorCategoryDeepLink then
		React.useEffect(function()
			v18()

			if ref.current then
				ref.current:GetPropertyChangedSignal("AbsoluteWindowSize"):Once(function()
					v18()
				end)
			end
		end, {})
	end

	React.useEffect(function()
		v18()
	end, { v18 })

	local v19 = React.useCallback(function(p3)
		if props.categories ~= module5() then
			return false
		end

		local category = props.categories[p3]

		if module11() then
			return module8.shouldNotifyCategory(category, v16)
		end

		if category.Name == module7.CharacterKey or category.Name == "Body" then
			return v16[module6.NewOutfitNotificationKey]
		end

		if category.Name == module7.HeadAndBody and v16[module6.NewDHOutfitNotificationKey] then
			return true
		end

		local subcategories = category.Subcategories

		if subcategories then
			for k, subcategory in subcategories do
				local assetTypeIdStrings = subcategory.AssetTypeIdStrings

				if assetTypeIdStrings and module8.shouldNotifyAssetTypes(assetTypeIdStrings, v16) then
					return true
				end
			end
		else
			local assetTypeIdStrings = category.AssetTypeIdStrings

			if assetTypeIdStrings and module8.shouldNotifyAssetTypes(assetTypeIdStrings, v16) then
				return true
			end
		end

		return false
	end, { props.categories, v16 })

	local v20 = React.useCallback(function(layoutOrder, props2)
		local v21

		if props.shouldUseCategoryId then
			v21 = props.selectedCategoryId == props2.Id
		else
			v21 = props.selectedCategoryIndex == layoutOrder
		end

		local createElement = React.createElement
		local v22 = focusable[module4]
		local v23 = {
			categoryIndex = layoutOrder,
			categoryId = props2.Id,
			categoryTitle = props2.Title,
			localizedCategoryTitle = 0,
			layoutOrder = 0,
			isSelected = 0,
			hasNewItemNotification = 0,
			frameRef = 0,
			onActivate = 0,
			ref = 0,
			NextSelectionLeft = 0,
			NextSelectionRight = 0,
			navBarHeight = 0,
			avatarScreenOfOrigin = 0,
			categoryTooltipKey = 0,
			categoryTooltipLocalizationKey = 0,
			categoryLocalizedTooltipBody = 0
		}
		local v24 = if fFlagAXCatalogCategoriesSDUI then props2.LocalizedTitle else nil
		v23.localizedCategoryTitle = v24
		v23.layoutOrder = layoutOrder
		v23.isSelected = v21
		v23.hasNewItemNotification = v19(layoutOrder)
		local v26 = if props.shouldUseCategoryId then props2.Id else layoutOrder
		v23.frameRef = v6[v26]
		function v23.onActivate()
			if fFlagAXCategoryUnifiedLogging then
				local v27 = v5[layoutOrder]

				if v27 and v27.current then
					local current = v27.current
					local v29 = {
						action = unifiedEventLogEnums.MarketplaceUnifiedAction.UI_ELEMENT_CLICK,
						elementName = "SELECT_CATEGORY_" .. string.upper(props2.Name),
						surface = 0
					}

					local v30 = if fFlagAXUnifiedEventStrictPayloads then v9 or unifiedLoggingSurface.UNDEFINED_SURFACE else v9
					v29.surface = v30
					sendUnifiedEventLogForInstance(current, v29)
				end
			end

			if props.shouldUseCategoryId and props.selectCategoryId then
				props.selectCategoryId(props2.Id)
			else
				props.selectCategory(layoutOrder)
			end
		end

		v23.ref = v5[layoutOrder]
		local v27 = if layoutOrder > 1 then v5[layoutOrder - 1] else nil
		v23.NextSelectionLeft = v27
		local v28 = if layoutOrder < #props.categories then v5[layoutOrder + 1] else nil
		v23.NextSelectionRight = v28
		v23.navBarHeight = props.navHeight
		v23.avatarScreenOfOrigin = avatarScreen.Catalog
		v23.categoryTooltipKey = props2.TooltipKey

		local v29 = if fFlagAXMigrateCategoryTooltip then props2.TooltipLocalizationKey else nil
		v23.categoryTooltipLocalizationKey = v29

		local v30 = if fFlagAXCatalogCategoriesSDUI then props2.TooltipBody else nil
		v23.categoryLocalizedTooltipBody = v30
		return createElement(v22, v23)
	end, {
		props.selectedCategoryIndex,
		props.selectedCategoryId,
		v19,
		props.selectCategory,
		props.selectCategoryId,
		props.shouldUseCategoryId,
		props.categories
	})

	local v21 = React.useCallback(function(p3)
		if ref.current then
			ref.current.CanvasSize = UDim2.new(0, p3.AbsoluteSize.X, 1, 0)
		end
	end, {})
	local size_1300, size_600

	if fFlagAXMoveCatalogFilterToL1Navigation then
		size_1300 = v7.Size.Size_1300
		size_600 = v7.Size.Size_600
	else
		size_1300 = nil
		size_600 = nil
	end

	local v22 = React.useCallback(function()
		local v23 = v8 ~= module2.InputType.Gamepad or props.subcategorySelected
		local v24 = {}

		for k, category in props.categories do
			v24[category.Name] = v20(k, category)
		end

		if
			fFlagAXMoveCatalogFilterToL1Navigation
			and props.supportFilterButton
			and props.showFilterButton
		then
			v24.RightPadding = React.createElement(Foundation.View, {
				tag = "auto-xy",
				Size = UDim2.new(0, size_1300 + size_600, 1, 0),
				BackgroundTransparency = 1,
				LayoutOrder = #props.categories + 1,
				ref = v6.RightPadding
			})
		end

		return {
			NavFrame = React.createElement(
				focusable[fitFrameHorizontal],
				{
					height = UDim.new(1, 0),
					FillDirection = Enum.FillDirection.Horizontal,
					BackgroundTransparency = 1,
					[React.Change.AbsoluteSize] = v21
				},
				v24
			),
			Highlight = v23 and React.createElement(module3, {
				scrollingFrameRef = ref,
				useArrowHighlight = props.subcategorySelected,
				selectedCategoryButtonInstance = state
			})
		}
	end, {
		v8,
		props.subcategorySelected,
		v20,
		v21,
		state,
		props.categories,
		props.supportFilterButton,
		props.showFilterButton,
		fFlagAXMoveCatalogFilterToL1Navigation
	})

	local v23 = props.selectedCategoryIndex

	if props.shouldUseCategoryId then
		v23 = module13.findCategoryIndexById(props.categories, props.selectedCategoryId)
	end

	local createElement = React.createElement
	local frame = focusable.Frame
	local v24 = {
		ClipsDescendants = true,
		BackgroundColor3 = v7.Color.Surface.Surface_0.Color3,
		BackgroundTransparency = v7.Color.Surface.Surface_0.Transparency,
		BorderSizePixel = 0,
		LayoutOrder = props.layoutOrder,
		Size = UDim2.new(1, 0, 0, props.navHeight),
		ZIndex = props.zIndex,
		ref = p2,
		NextSelectionUp = props.NextSelectionUp,
		NextSelectionDown = props.NextSelectionDown,
		defaultChild = v5[v23]
	}

	local createElement2 = React.createElement
	local v27 = {
		getScollingListContent = v22,
		listHeight = props.navHeight,
		scrollingFrameRef = v15,
		buttonRefs = v6,
		buttonPadding = 0,
		onSizeChanged = if fFlagAXEnableEditorCategoryDeepLink then v18 else nil,
		backgroundColor = 0,
		supportFilterButton = 0,
		hideFilterButton = 0,
		filterButtonWidth = 0,
		filterButtonGradientWidth = 0
	}

	local v29 = if fFlagAXMoveCatalogFilterToL1Navigation then v7.Color.Surface.Surface_0.Color3 else nil
	v27.backgroundColor = v29

	local v30 = if fFlagAXMoveCatalogFilterToL1Navigation then props.supportFilterButton else nil
	v27.supportFilterButton = v30
	local v31 = if fFlagAXMoveCatalogFilterToL1Navigation then not props.showFilterButton else nil
	v27.hideFilterButton = v31
	v27.filterButtonWidth = if fFlagAXMoveCatalogFilterToL1Navigation then size_1300 else nil
	v27.filterButtonGradientWidth = if fFlagAXMoveCatalogFilterToL1Navigation then size_600 else nil
	return createElement(frame, v24, {
		ScrollingListWithArrowsAndGradient = createElement2(module, v27)
	})
end)

return React.memo(forwardRef)
