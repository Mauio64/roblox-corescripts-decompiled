local CoreGui = game:GetService("CoreGui")
local CorePackages = game:GetService("CorePackages")
local GuiService = game:GetService("GuiService")
local Modules = CoreGui.RobloxGui.Modules
local ReactUtils = require(CorePackages.Packages.ReactUtils)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
local React = require(CorePackages.Packages.React)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local useInitializedValue = ReactUtils.useInitializedValue
local useFullView = require(Modules.AvatarExperience.Common.Hooks.useFullView)
local FullView = AvatarExperienceCommon.Enums.FullView

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local TopBar = require(Modules.LuaApp.Components.TopBar.TopBar)
local PeekView = require(CorePackages.Workspace.Packages.PeekView).PeekView
local useSelector = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useSelector
local NavigationEventsLogger = require(Modules.AvatarExperience.Common.Components.RoactNavigation.Debug.NavigationEventsLogger)
local Constants = require(Modules.AvatarExperience.Common.Constants)
local BoundInputsUpdater = require(Modules.AvatarExperience.Common.Components.BoundInputsUpdater)
local Constants2 = require(Modules.LuaApp.Constants)
local FiltersTopBar = require(Modules.AvatarExperience.Catalog.Components.Filters.FiltersTopBar)
local ResetApplyBar = require(Modules.AvatarExperience.Catalog.Components.Filters.ResetApplyBar)
local GamepadFocusHandlerForPage = require(Modules.AvatarExperience.Common.Components.GamepadFocusHandlerForPage)
local NavigationUtils = require(Modules.AvatarExperience.Common.Components.RoactNavigation.NavigationUtils)
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local AvatarExperienceNavigation = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation)
local AvatarScreen = AvatarExperienceNavigation.Enums.AvatarScreen
local useAvatarRoute = AvatarExperienceNavigation.AvatarRoute.Hooks.useAvatarRoute
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local FilterSection = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterSection)
local Filters = require(Modules.AvatarExperience.Catalog.Components.Filters.Filters)
local Sorts = require(Modules.AvatarExperience.Catalog.Components.Filters.Sorts)
local useFiltersController = require(Modules.AvatarExperience.Catalog.Hooks.useFiltersController)
local useSortsController = require(Modules.AvatarExperience.Catalog.Hooks.useSortsController)
local useLocalization = require(CorePackages.Workspace.Packages.Localization).Hooks.useLocalization
local FilterUtils = require(Modules.AvatarExperience.Catalog.Components.Filters.FilterUtils)
local NamedRefsContext = require(Modules.AvatarExperience.Common.Context.NamedRefsContext)
local useCloseFiltersSignal = require(Modules.AvatarExperience.Catalog.Hooks.useCloseFiltersSignal)
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local useStyle = UIBlox.Core.Style.useStyle
local useIsGamepad = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.useIsGamepad
local useDispatch = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.RoactRodux.useDispatch
local SendApplySortAndFiltersAnalytics = require(Modules.AvatarExperience.Catalog.Thunks.SendApplySortAndFiltersAnalytics)
local useRoactService = require(Modules.LuaApp.Hooks.useRoactService)
local Analytics = require(Modules.AvatarExperience.Catalog.Services.Analytics)

require(Modules.AvatarExperience.Catalog.SearchTypes)

local NavigateToSearch = require(Modules.AvatarExperience.Catalog.Thunks.NavigateToSearch)
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local useAvatarExperienceFocusNavigationBindings = require(Modules.AvatarExperience.Common.Hooks.useAvatarExperienceFocusNavigationBindings)
local useOverlayClosedCallback = require(Modules.AvatarExperience.Common.Hooks.useOverlayClosedCallback)
local useTableWrappedCallbackRef = AvatarExperienceCommon.Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local FFlagAXMigrateSortAndFiltersScreenInputBindingsToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateSortAndFiltersScreenInputBindingsToFocusNavigation
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local v58 = GuiService:IsTenFootInterface()
local t1 = {
	[Enum.KeyCode.ButtonX] = FocusNavigationEventNameEnum.SortAndFiltersApply,
	[Enum.KeyCode.ButtonY] = FocusNavigationEventNameEnum.SortAndFiltersReset
}

local function getTotalSectionHeight(n1: number) -- line: 94
	return n1 + 24 + 24
end
local function useSearchParameters() -- line: 98
	-- upvalues: useAvatarRoute (copy), AvatarScreen (copy), useSelector (copy), getUseSelectorDeepEquals (copy)
	local v65 = useAvatarRoute()
	local v66 = if v65.opaque.name ~= AvatarScreen.CatalogSearch then nil else v65.opaque.params.detail

	return (useSelector(function(p1) -- line: 103
		-- upvalues: v66 (copy)
		if v66 then
			return p1.SearchesParameters[v66]
		end

		return nil
	end, getUseSelectorDeepEquals()))
end
local function useSortAndFiltersScreenFocusNavigationBindings(p2, p3: ((...any) -> ...any)?, p4: ((...any) -> ...any)?) -- line: 110
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v70 = ReactFocusNavigation.useEventMap(t1, p2)
	local v71 = React.useMemo(function() -- line: 116
		-- upvalues: FocusNavigationEventNameEnum (copy), p3 (copy), InputHandlers (copy), p4 (copy)
		return {
			[FocusNavigationEventNameEnum.SortAndFiltersApply] = if not p3 then nil else {
				handler = InputHandlers.onRelease(function(_) -- line: 120
					-- upvalues: p3 (copy)
					p3()
				end)
			},
			[FocusNavigationEventNameEnum.SortAndFiltersReset] = if not p4 then nil else {
				handler = InputHandlers.onRelease(function(_) -- line: 127
					-- upvalues: p4 (copy)
					p4()
				end)
			}
		}
	end, {
		p3,
		p4
	})

	return ReactFocusNavigation.useEventHandlerMap(v71, v70)
end
local function SortAndFiltersScreen(_: {[any]: any}) -- line: 139
	-- upvalues: useFiltersController (copy), useSortsController (copy), useNavigation (copy), React (copy), NamedRefsContext (copy), RoactGamepad (copy), useDispatch (copy), useRoactService (copy), Analytics (copy), useCloseFiltersSignal (copy), useSearchParameters (copy), SendApplySortAndFiltersAnalytics (copy), NavigateToSearch (copy), useFullView (copy), FullView (copy), useSelector (copy), selectIsPortrait (copy), getUseSelectorDeepEquals (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), Constants (copy), useIsGamepad (copy), TopBar (copy), useStyle (copy), v58 (copy), Constants2 (copy), useLocalization (copy), FFlagAXMigrateSortAndFiltersScreenInputBindingsToFocusNavigation (copy), useSortAndFiltersScreenFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), FilterUtils (copy), useInitializedValue (copy), Focusable (copy), AvatarScreen (copy), NavigationUtils (copy), GamepadFocusHandlerForPage (copy), NavigationEventsLogger (copy), BoundInputsUpdater (copy), FiltersTopBar (copy), PeekView (copy), PeekViewState (copy), ResetApplyBar (copy), FilterSection (copy), Filters (copy), Sorts (copy), useOverlayClosedCallback (copy), useAvatarExperienceFocusNavigationBindings (copy)
	local v73 = useFiltersController()
	local v74 = useSortsController()
	local v75 = useNavigation()
	local v76 = React.useContext(NamedRefsContext)
	local v77 = RoactGamepad.useRefCache()
	local v78 = v73.canApply or v74.canApply
	local v79 = v73.canReset or v74.canReset
	local v80 = useDispatch()
	local v81 = useRoactService(Analytics)
	local v82 = useCloseFiltersSignal()
	local v83 = useSearchParameters()

	local function apply() -- line: 157
		-- upvalues: v73 (copy), v74 (copy), v82 (copy), v80 (copy), SendApplySortAndFiltersAnalytics (copy), v81 (copy), v83 (copy), NavigateToSearch (copy), v75 (copy)
		v73.apply()
		v74.apply()
		v82:fire()
		v80(SendApplySortAndFiltersAnalytics(v81))

		if v83 then
			v80(NavigateToSearch(v75, v83))
		end
	end
	local function reset() -- line: 168
		-- upvalues: v73 (copy), v74 (copy)
		v73.reset()
		v74.reset()
	end

	local v86 = useFullView() == FullView.SceneFullView
	local v87 = useSelector(selectIsPortrait, getUseSelectorDeepEquals())
	local v88 = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.useRootFocusController() else nil
	local uDim2, uDim2_2

	if v87 then
		uDim2 = UDim2.fromScale(0, 0)
		uDim2_2 = UDim2.fromScale(1, 1)
	else
		uDim2 = UDim2.fromScale(Constants.LandscapeNavWidth, 0)
		uDim2_2 = UDim2.fromScale(Constants.LandscapeSceneWidth, 1)
	end

	local v91 = useIsGamepad()
	local v92 = useSelector(TopBar.selectTopBarHeight, getUseSelectorDeepEquals())
	local Theme = useStyle().Theme
	local n2 = 80

	if v91 and v58 then
		n2 += Constants2.GAMEPAD_BOTTOM_BAR_SIZE
	end

	local v95 = useLocalization({
		sorts = "Feature.Catalog.Label.Filter.Sorts",
		filters = "Feature.Catalog.Label.Filter.Filters"
	})
	local v96 = nil

	if FFlagAXMigrateSortAndFiltersScreenInputBindingsToFocusNavigation then
		local v97 = React.useCallback(function() -- line: 205
			-- upvalues: apply (copy)
			apply()
		end, { apply })
		local v98 = React.useCallback(function() -- line: 208
			-- upvalues: v73 (copy), v74 (copy)
			v73.reset()
			v74.reset()
		end, { reset })
		local v99 = useSortAndFiltersScreenFocusNavigationBindings(v77.SortAndFiltersContent, if not v78 then nil else v97, if not v79 then nil else v98)

		v96 = useTableWrappedCallbackRef(v99)
	end

	local v100, v101 = React.useBinding(0)
	local v102 = v100:map(FilterUtils.mapHeightToSize)
	local v103, v104 = React.useBinding(0)
	local v105 = v103:map(FilterUtils.mapHeightToSize)
	local v106 = React.useRef(nil)

	local function updatePeekViewContentFrameSize(p7) -- line: 227
		-- upvalues: v106 (copy)
		local current = v106.current

		if p7 and current then
			local AbsoluteSizeY = p7.AbsoluteSize.Y

			current.AutomaticSize = Enum.AutomaticSize.None
			current.Size = UDim2.new(1, 0, 0, AbsoluteSizeY)
		end
	end

	local v108 = useInitializedValue(function() -- line: 236
		-- upvalues: React (copy), v100 (copy), v103 (copy)
		return React.joinBindings({
			v100,
			v103
		}):map(function(t3: {[any]: any}) -- line: 240
			local v123 = t3[1]
			local v124 = t3[2]
			local v125 = v123 + 24 + 24 + (v124 + 24 + 24)

			return UDim2.new(1, 0, 0, v125)
		end)
	end)
	local v109 = React.createElement(Focusable.Frame, {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		restorePreviousChildFocus = true,
		Size = UDim2.new(1, 0, 1, 0),
		Visible = not v86,
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v88 else nil,
		defaultChild = v77.SortAndFiltersContent,
		ref = v76[AvatarScreen.SortAndFilters],
		NextSelectionLeft = v76[AvatarScreen.Catalog],
		inputBindings = if not FFlagAXMigrateSortAndFiltersScreenInputBindingsToFocusNavigation then {
			NavigateBack = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, function() -- line: 261
				-- upvalues: NavigationUtils (copy), v75 (copy)
				NavigationUtils.closeFocusedScreen(v75)
			end)
		} else nil
	}, {
		GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then React.createElement(GamepadFocusHandlerForPage, {
			captureFocusOnMount = true,
			focusController = v88
		}) else nil,
		NavigationEventsLogger = React.createElement(NavigationEventsLogger),
		BoundInputsUpdater = if not FFlagAXMigrateAXToGlobalAutofocus then React.createElement(BoundInputsUpdater) else nil,
		Content = React.createElement(Focusable.Frame, {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			restorePreviousChildFocus = true,
			Size = uDim2_2,
			Position = uDim2,
			inputBindings = if not FFlagAXMigrateSortAndFiltersScreenInputBindingsToFocusNavigation then {
				Close = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, function() -- line: 286
					-- upvalues: v82 (copy)
					v82:fire()
				end, {
					key = "CommonUI.Controls.Action.Back"
				}),
				Apply = if not v78 then nil else RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonX, apply, {
					key = "CommonUI.Messages.Action.Apply"
				}),
				Reset = if not v79 then nil else RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonY, reset, {
					key = "CommonUI.Messages.Action.Reset"
				})
			} else nil
		}, {
			Background = React.createElement("TextButton", {
				ZIndex = 1,
				Text = "",
				AutoButtonColor = false,
				BackgroundTransparency = v87 and Theme.Overlay.Transparency or 1,
				BackgroundColor3 = Theme.Overlay.Color,
				Size = UDim2.new(1, 0, 1, v92),
				Position = UDim2.fromOffset(0, -v92)
			}),
			FiltersTopBar = React.createElement(FiltersTopBar, {
				buttonRef = v77.FiltersTopBar,
				NextSelectionDown = v77.SortAndFiltersContent,
				closePeekViewSignal = v82
			}),
			PeekViewContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				ZIndex = 2,
				Position = UDim2.fromOffset(0, v92),
				Size = UDim2.new(1, 0, 1, -v92)
			}, {
				PeekView = React.createElement(PeekView, {
					mountAnimation = true,
					mountAsFullView = true,
					canDragFullViewToBrief = false,
					showDraggerInClosedState = false,
					returnToFullView = true,
					thumbstickScrollEnabled = true,
					peekHeaderClose = true,
					isScrollingEnabled = true,
					briefViewContentHeight = UDim.new(0, 0),
					contentFrameRef = v106,
					closeSignal = v82,
					viewStateChanged = function(p8, _) -- line: 339
						-- upvalues: PeekViewState (copy), v75 (copy)
						if p8 == PeekViewState.Closed then
							v75.goBack()
						end
					end,
					bottomDockedContainerHeight = n2,
					bottomDockedContainerContent = React.createElement(ResetApplyBar, {
						height = n2,
						canReset = v79,
						canApply = v78,
						onReset = reset,
						onApply = apply,
						frameRef = v77.BottomBar,
						NextSelectionUp = v77.SortAndFiltersContent
					}),
					backgroundColor3 = Theme.BackgroundDefault.Color,
					backgroundTransparency = Theme.BackgroundUIDefault.Transparency,
					shouldCaptureFocus = not FFlagAXMigrateAXToGlobalAutofocus and nil
				}, {
					SortAndFiltersContent = React.createElement(Focusable.Frame, {
						Size = v108,
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						ref = if not FFlagAXMigrateSortAndFiltersScreenInputBindingsToFocusNavigation then v77.SortAndFiltersContent else v96,
						NextSelectionUp = v77.FiltersTopBar,
						NextSelectionDown = v77.BottomBar,
						[React.Change.AbsoluteSize] = updatePeekViewContentFrameSize,
						defaultChild = v77.Filters,
						restorePreviousChildFocus = true
					}, {
						Layout = React.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical
						}),
						FiltersSection = React.createElement(FilterSection, {
							title = v95.filters,
							Size = v100:map(function(n3: number) -- line: 381
								return UDim2.new(1, 0, 0, n3 + 24 + 24)
							end),
							contentSize = v102
						}, {
							Filters = React.createElement(Filters, {
								Size = v102,
								filtersController = v73,
								frameRef = v77.Filters,
								NextSelectionDown = v77.Sorts,
								onHeightChanged = v101
							})
						}),
						SortsSection = React.createElement(FilterSection, {
							title = v95.sorts,
							Size = v103:map(function(n4: number) -- line: 396
								return UDim2.new(1, 0, 0, n4 + 24 + 24)
							end),
							contentSize = v105
						}, {
							Sorts = React.createElement(Sorts, {
								Size = v105,
								sortsController = v74,
								frameRef = v77.Sorts,
								NextSelectionUp = v77.Filters,
								onHeightChanged = v104
							})
						})
					})
				})
			})
		})
	})
	local v110 = useOverlayClosedCallback(if not FFlagAXMigrateAXToGlobalAutofocus then v88 else nil)
	local v111 = useAvatarExperienceFocusNavigationBindings({
		overlayClosedCallback = v110
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ref = v111,
		Size = UDim2.fromScale(1, 1),
		Visible = not v86
	}, v109)
end

return withStackVisibilityWrapper(SortAndFiltersScreen)
