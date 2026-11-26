local CorePackages = game:GetService("CorePackages")
local isTenFootInterface = require("@game/CorePackages/Workspace/Packages/AppCommonLib").isTenFootInterface

local ReactUtils = require(CorePackages.Packages.ReactUtils)
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")

local React = require(CorePackages.Packages.React)
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local useInitializedValue = ReactUtils.useInitializedValue
local module2 = require("@luauforge/deferred/gTM")
local fullView = AvatarExperienceCommon.Enums.FullView
require("@luauforge/bundled/dKT")

local module3 = require("@luauforge/bundled/fvR")
local peekView = require("@luauforge/bundled/dCI").PeekView
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module4 = require("@luauforge/deferred/gJK")

local module5 = require("@luauforge/deferred/hkq")

local fFlagAXFilterAndSortViewExposureLogging = require("@game/CorePackages/Workspace/Packages/AvatarExperienceFlags").FFlagAXFilterAndSortViewExposureLogging
local module6 = require("@luauforge/bundled/dPN")
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane

local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fCo") else nil

local module7 = require("@luauforge/bundled/dzD")
local module8 = require("@luauforge/deferred/hjY")
local module9 = require("@luauforge/deferred/hjZ")
local module10 = require("@luauforge/bundled/ehL")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module10.FocusNavigationEventNameEnum
local AvatarExperienceNavigation = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation")
local avatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute

local module12 = require("@luauforge/deferred/gRz")
local module13 = require("@luauforge/deferred/hkd")
local module14 = require("@luauforge/deferred/hke")
local module15 = require("@luauforge/deferred/hkn")
local module16 = require("@luauforge/deferred/hkk")
local module17 = require("@luauforge/deferred/hko")
local useLocalization = require("@game/CorePackages/Workspace/Packages/Localization").Hooks.useLocalization
local module18 = require("@luauforge/bundled/fCm")
local module19 = require("@luauforge/deferred/gLm")
local module20 = require("@luauforge/deferred/heH")

local peekViewState = require("@luauforge/bundled/dCI").PeekViewState
local useStyle = UIBlox.Core.Style.useStyle
local useIsGamepad = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useIsGamepad
local useDispatch = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useDispatch

local module21 = require("@luauforge/deferred/hkr")
local module22 = require("@luauforge/bundled/eie")
local module23 = require("@luauforge/bundled/fDf")
require("@luauforge/bundled/dXi")
local module24 = require("@luauforge/deferred/fDP")

local module25 = require("@luauforge/bundled/gJS")

local module26 = require("@luauforge/deferred/gQN")
local module27 = require("@luauforge/deferred/gQQ")

local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals

local tenFootInterface = isTenFootInterface()

local v6 = {
	[Enum.KeyCode.ButtonX] = focusNavigationEventNameEnum.SortAndFiltersApply,
	[Enum.KeyCode.ButtonY] = focusNavigationEventNameEnum.SortAndFiltersReset
}

local function getTotalSectionHeight(p2)
	return p2 + 24 + 24
end

local function useSearchParameters()
	local v7 = useAvatarRoute()
	local detail = if v7.opaque.name == avatarScreen.CatalogSearch then v7.opaque.params.detail else nil

	return (useSelector(function(p2)
		if detail then
			return p2.SearchesParameters[detail]
		end

		return nil
	end, getUseSelectorDeepEquals()))
end

local function useSortAndFiltersScreenFocusNavigationBindings(p2, callback, callback2)
	local v7 = ReactFocusNavigation.useEventMap(v6, p2)
	local v8 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.SortAndFiltersApply] = callback and {
				handler = InputHandlers.onRelease(function(p3)
					callback()
				end)
			} or nil,
			[focusNavigationEventNameEnum.SortAndFiltersReset] = callback2 and {
				handler = InputHandlers.onRelease(function(p3)
					callback2()
				end)
			} or nil
		}
	end, { callback, callback2 })
	return ReactFocusNavigation.useEventHandlerMap(v8, v7)
end

local function SortAndFiltersScreen(p2)
	local v7 = module16()
	local v8 = module17()
	local v9 = useNavigation()

	local v10 = React.useContext(module19)
	local v11 = RoactGamepad.useRefCache()

	local canApply = v7.canApply or v8.canApply
	local canReset = v7.canReset or v8.canReset

	local v12 = useDispatch()
	local v13 = module22(module23)

	local v14 = module20()

	local v15 = useSearchParameters()

	local function apply()
		v7.apply()
		v8.apply()
		v14:fire()
		v12(module21(v13))

		if v15 then
			v12(module24(v9, v15))
		end
	end

	local function reset()
		v7.reset()
		v8.reset()
	end

	local v16 = module2() == fullView.SceneFullView

	local v17 = useSelector(module25, getUseSelectorDeepEquals())
	local udim, udim2

	if v17 then
		udim = UDim2.fromScale(0, 0)
		udim2 = UDim2.fromScale(1, 1)
	else
		local fromScale = UDim2.fromScale
		local v18 = if fFlagEnableSplitPane then v5.getLandscapeNavWidth() else module6.LandscapeNavWidth
		udim = fromScale(v18, 0)

		local fromScale2 = UDim2.fromScale
		local v19 = if fFlagEnableSplitPane then v5.getLandscapeSceneWidth() else module6.LandscapeSceneWidth
		udim2 = fromScale2(v19, 1)
	end

	local v18 = useIsGamepad()
	local v19 = useSelector(module3.selectTopBarHeight, getUseSelectorDeepEquals())
	local theme = useStyle().Theme

	local total = 80

	if v18 and tenFootInterface then
		total += module7.GAMEPAD_BOTTOM_BAR_SIZE
	end

	local v20 = useLocalization({
		sorts = "Feature.Catalog.Label.Filter.Sorts",
		filters = "Feature.Catalog.Label.Filter.Filters"
	})

	local v21 = React.useCallback(function()
		apply()
	end, { apply })
	local v22 = React.useCallback(function()
		v7.reset()
		v8.reset()
	end, { reset })

	local sortAndFiltersContent = v11.SortAndFiltersContent

	if not canApply then
		v21 = nil
	end

	if not canReset then
		v22 = nil
	end

	local v25 = useTableWrappedCallbackRef((useSortAndFiltersScreenFocusNavigationBindings(
		sortAndFiltersContent,
		v21,
		v22
	)))

	local v26, v27 = React.useBinding(0)
	local mapped = v26:map(module18.mapHeightToSize)

	local v28, v29 = React.useBinding(0)
	local mapped2 = v28:map(module18.mapHeightToSize)

	local ref = React.useRef(nil)

	local function updatePeekViewContentFrameSize(p3)
		local current = ref.current

		if p3 and current then
			local y = p3.AbsoluteSize.Y
			current.AutomaticSize = Enum.AutomaticSize.None
			current.Size = UDim2.new(1, 0, 0, y)
		end
	end

	local v30 = useInitializedValue(function()
		return React.joinBindings({ v26, v28 }):map(function(list)
			local item = list[1]
			local item2 = list[2]
			local v31 = item + 24 + 24 + (item2 + 24 + 24)

			return UDim2.new(1, 0, 0, v31)
		end)
	end)

	local createElement = React.createElement
	local frame = focusable.Frame
	local v31 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Visible = not v16,
		restorePreviousChildFocus = true,
		defaultChild = v11.SortAndFiltersContent,
		ref = v10[avatarScreen.SortAndFilters],
		NextSelectionLeft = v10[avatarScreen.Catalog]
	}
	local v32 = {
		NavigationEventsLogger = React.createElement(module4),
		FilterAndSortViewExposureLogger = 0,
		Content = 0
	}

	local v33 = if fFlagAXFilterAndSortViewExposureLogging then React.createElement(module5) else nil
	v32.FilterAndSortViewExposureLogger = v33

	v32.Content = React.createElement(focusable.Frame, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = udim2,
		Position = udim,
		restorePreviousChildFocus = true
	}, {
		Background = React.createElement("TextButton", {
			BackgroundTransparency = v17 and theme.Overlay.Transparency or 1,
			BackgroundColor3 = theme.Overlay.Color,
			Size = UDim2.new(1, 0, 1, v19),
			Position = UDim2.fromOffset(0, -v19),
			ZIndex = 1,
			Text = "",
			AutoButtonColor = false
		}),
		FiltersTopBar = React.createElement(module8, {
			buttonRef = v11.FiltersTopBar,
			NextSelectionDown = v11.SortAndFiltersContent,
			closePeekViewSignal = v14
		}),
		PeekViewContainer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			Position = UDim2.fromOffset(0, v19),
			Size = UDim2.new(1, 0, 1, -v19),
			ZIndex = 2
		}, {
			PeekView = React.createElement(peekView, {
				briefViewContentHeight = UDim.new(0, 0),
				mountAnimation = true,
				mountAsFullView = true,
				canDragFullViewToBrief = false,
				showDraggerInClosedState = false,
				returnToFullView = true,
				thumbstickScrollEnabled = true,
				contentFrameRef = ref,
				closeSignal = v14,
				viewStateChanged = function(p3, p4)
					if p3 == peekViewState.Closed then
						v9.goBack()
					end
				end,
				bottomDockedContainerHeight = total,
				bottomDockedContainerContent = React.createElement(module9, {
					height = total,
					canReset = canReset,
					canApply = canApply,
					onReset = reset,
					onApply = apply,
					frameRef = v11.BottomBar,
					NextSelectionUp = v11.SortAndFiltersContent
				}),
				backgroundColor3 = theme.BackgroundDefault.Color,
				backgroundTransparency = theme.BackgroundUIDefault.Transparency,
				peekHeaderClose = true,
				isScrollingEnabled = true,
				shouldCaptureFocus = false
			}, {
				SortAndFiltersContent = React.createElement(focusable.Frame, {
					Size = v30,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					ref = v25,
					NextSelectionUp = v11.FiltersTopBar,
					NextSelectionDown = v11.BottomBar,
					[React.Change.AbsoluteSize] = updatePeekViewContentFrameSize,
					defaultChild = v11.Filters,
					restorePreviousChildFocus = true
				}, {
					Layout = React.createElement("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						FillDirection = Enum.FillDirection.Vertical
					}),
					FiltersSection = React.createElement(module13, {
						title = v20.filters,
						Size = v26:map(function(p3)
							return UDim2.new(1, 0, 0, p3 + 24 + 24)
						end),
						contentSize = mapped
					}, {
						Filters = React.createElement(module14, {
							Size = mapped,
							filtersController = v7,
							frameRef = v11.Filters,
							NextSelectionDown = v11.Sorts,
							onHeightChanged = v27
						})
					}),
					SortsSection = React.createElement(module13, {
						title = v20.sorts,
						Size = v28:map(function(p3)
							return UDim2.new(1, 0, 0, p3 + 24 + 24)
						end),
						contentSize = mapped2
					}, {
						Sorts = React.createElement(module15, {
							Size = mapped2,
							sortsController = v8,
							frameRef = v11.Sorts,
							NextSelectionUp = v11.Filters,
							onHeightChanged = v29
						})
					})
				})
			})
		})
	})
	local element = createElement(frame, v31, v32)

	local v41 = module26({ overlayClosedCallback = module27() })

	return React.createElement("Frame", {
		ref = v41,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Visible = not v16
	}, element)
end

return module12(SortAndFiltersScreen)
