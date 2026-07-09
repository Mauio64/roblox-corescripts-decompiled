local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local React = require(CorePackages.Packages.React)
local useNavigation = require(CorePackages.Workspace.Packages.Navigation).useNavigation
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local Focusable = RoactGamepad.Focusable
local UIBlox = require(CorePackages.Packages.UIBlox)
local useFullView = require(Modules.AvatarExperience.Common.Hooks.useFullView)
local AvatarExperienceCommon = require(CorePackages.Workspace.Packages.AvatarExperienceCommon)
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
local AvatarScreen = require(CorePackages.Workspace.Packages.AvatarExperienceNavigation).Enums.AvatarScreen
local withStackVisibilityWrapper = require(Modules.AvatarExperience.Common.Components.RoactNavigation.withStackVisibilityWrapper)
local NamedRefsContext = require(Modules.AvatarExperience.Common.Context.NamedRefsContext)

require(CorePackages.Workspace.Packages.AppCommonLib)

local Responsive = require(CorePackages.Workspace.Packages.Responsive)
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals
local PeekViewState = require(CorePackages.Workspace.Packages.PeekView).PeekViewState
local useStyle = UIBlox.Core.Style.useStyle
local useIsGamepad = require(CorePackages.Workspace.Packages.RoactUtils).Hooks.useIsGamepad
local FocusNavigationUtils = require(CorePackages.Workspace.Packages.FocusNavigationUtils)
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require(CorePackages.Workspace.Packages.AvatarExperienceCommon).Utils.RoactGamepadMigration.useTableWrappedCallbackRef
local selectIsPortrait = require(Modules.AvatarExperience.Common.Selectors.selectIsPortrait)
local useAvatarExperienceFocusNavigationBindings = require(Modules.AvatarExperience.Common.Hooks.useAvatarExperienceFocusNavigationBindings)
local useOverlayClosedCallback = require(Modules.AvatarExperience.Common.Hooks.useOverlayClosedCallback)
local FFlagAXMigrateFormPeekViewToFocusNavigation = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateFormPeekViewToFocusNavigation
local FFlagAXMigrateAXToGlobalAutofocus = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXMigrateAXToGlobalAutofocus
local FFlagAXCloseFilterOnBackgroundTap = require(CorePackages.Workspace.Packages.SharedFlags).FFlagAXCloseFilterOnBackgroundTap
local t1 = {
	[Enum.KeyCode.ButtonB] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = FocusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonX] = FocusNavigationEventNameEnum.FormPeekViewApply,
	[Enum.KeyCode.ButtonY] = FocusNavigationEventNameEnum.FormPeekViewReset
}

local function useFocusNavigationBindings(p1, p2: ((...any) -> ...any), p3: ((...any) -> ...any)?, p4: ((...any) -> ...any)?) -- line: 86
	-- upvalues: ReactFocusNavigation (copy), t1 (copy), React (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v48 = ReactFocusNavigation.useEventMap(t1, p1)
	local v49 = React.useMemo(function() -- line: 93
		-- upvalues: FocusNavigationEventNameEnum (copy), InputHandlers (copy), p2 (copy), p3 (copy), p4 (copy)
		return {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p5) -- line: 96
					-- upvalues: p2 (copy)
					p5.cancelled = true
					p2()
				end)
			},
			[FocusNavigationEventNameEnum.FormPeekViewApply] = if not p3 then nil else {
				handler = InputHandlers.onRelease(p3)
			},
			[FocusNavigationEventNameEnum.FormPeekViewReset] = if not p4 then nil else {
				handler = InputHandlers.onRelease(p4)
			}
		}
	end, {
		p2,
		p3,
		p4
	})

	return ReactFocusNavigation.useEventHandlerMap(v49, v48)
end
local function FormPeekView(t2: {[any]: any}) -- line: 116
	-- upvalues: useFullView (copy), FullView (copy), useSelector (copy), selectIsPortrait (copy), getUseSelectorDeepEquals (copy), FFlagAXMigrateAXToGlobalAutofocus (copy), RoactGamepad (copy), React (copy), NamedRefsContext (copy), useNavigation (copy), Constants (copy), TopBar (copy), useStyle (copy), useIsGamepad (copy), Responsive (copy), Constants2 (copy), FFlagAXCloseFilterOnBackgroundTap (copy), FFlagAXMigrateFormPeekViewToFocusNavigation (copy), useFocusNavigationBindings (copy), useTableWrappedCallbackRef (copy), Focusable (copy), AvatarScreen (copy), NavigationUtils (copy), GamepadFocusHandlerForPage (copy), NavigationEventsLogger (copy), BoundInputsUpdater (copy), FiltersTopBar (copy), PeekView (copy), PeekViewState (copy), ResetApplyBar (copy), useOverlayClosedCallback (copy), useAvatarExperienceFocusNavigationBindings (copy)
	local v51 = useFullView() == FullView.SceneFullView
	local v52 = useSelector(selectIsPortrait, getUseSelectorDeepEquals())
	local v53 = if not FFlagAXMigrateAXToGlobalAutofocus then RoactGamepad.useRootFocusController() else nil
	local v54 = React.useContext(NamedRefsContext)
	local v55 = RoactGamepad.useRefCache()
	local v56 = useNavigation()
	local uDim2, uDim2_2

	if v52 then
		uDim2 = UDim2.fromScale(0, 0)
		uDim2_2 = UDim2.fromScale(1, 1)
	else
		uDim2 = UDim2.fromScale(Constants.LandscapeNavWidth, 0)
		uDim2_2 = UDim2.fromScale(Constants.LandscapeSceneWidth, 1)
	end

	local v59 = useSelector(TopBar.selectTopBarHeight, getUseSelectorDeepEquals())
	local Theme = useStyle().Theme
	local v61 = React.useRef(nil)
	local v62 = useIsGamepad()
	local n1 = 80
	local v64 = Responsive.usePreferredInput() == Responsive.Input.Directional

	if v62 and v64 then
		n1 += Constants2.GAMEPAD_BOTTOM_BAR_SIZE
	end

	local function updatePeekViewContentFrameSize(p6) -- line: 146
		-- upvalues: v61 (copy)
		local current = v61.current

		if p6 and current then
			local AbsoluteSizeY = p6.AbsoluteSize.Y

			current.AutomaticSize = Enum.AutomaticSize.None
			current.Size = UDim2.new(1, 0, 0, AbsoluteSizeY)
		end
	end

	local v66 = nil

	if FFlagAXCloseFilterOnBackgroundTap then
		v66 = React.useCallback(function() -- line: 157
			-- upvalues: t2 (copy)
			t2.closePeekViewSignal:fire()
		end, { t2.closePeekViewSignal })
	end

	local v67 = nil
	local v68 = nil
	local v69 = nil

	if FFlagAXMigrateFormPeekViewToFocusNavigation then
		local v70 = React.useCallback(function() -- line: 166
			-- upvalues: t2 (copy)
			t2.closePeekViewSignal:fire()
		end, { t2.closePeekViewSignal })
		local v71 = useFocusNavigationBindings(v55.SortAndFiltersContent, v70, if not t2.canApply then nil else t2.onApply, if not t2.canReset then nil else t2.onReset)
		local v72 = useFocusNavigationBindings(v55.FiltersTopBar, v70, if not t2.canApply then nil else t2.onApply, if not t2.canReset then nil else t2.onReset)
		local v73 = useFocusNavigationBindings(v55.BottomBar, v70, if not t2.canApply then nil else t2.onApply, if not t2.canReset then nil else t2.onReset)

		v67 = useTableWrappedCallbackRef(v71)
		v68 = useTableWrappedCallbackRef(v72)
		v69 = useTableWrappedCallbackRef(v73)
	end

	local v74 = React.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Visible = not v51,
		restorePreviousChildFocus = not FFlagAXMigrateAXToGlobalAutofocus or nil,
		focusController = if not FFlagAXMigrateAXToGlobalAutofocus then v53 else nil,
		defaultChild = if not FFlagAXMigrateAXToGlobalAutofocus then v55.SortAndFiltersContent else nil,
		ref = v54[AvatarScreen.SortAndFilters],
		NextSelectionLeft = if not FFlagAXMigrateAXToGlobalAutofocus then v54[AvatarScreen.Catalog] else nil,
		inputBindings = if not FFlagAXMigrateFormPeekViewToFocusNavigation then {
			NavigateBack = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, function() -- line: 206
				-- upvalues: NavigationUtils (copy), v56 (copy)
				NavigationUtils.closeFocusedScreen(v56)
			end)
		} else nil
	}, {
		GamepadFocusHandlerForPage = if not FFlagAXMigrateAXToGlobalAutofocus then React.createElement(GamepadFocusHandlerForPage, {
			captureFocusOnMount = true,
			focusController = v53
		}) else nil,
		NavigationEventsLogger = React.createElement(NavigationEventsLogger),
		BoundInputsUpdater = if not FFlagAXMigrateAXToGlobalAutofocus then React.createElement(BoundInputsUpdater) else nil,
		Content = React.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = uDim2_2,
			Position = uDim2,
			restorePreviousChildFocus = not FFlagAXMigrateAXToGlobalAutofocus or nil,
			inputBindings = if not FFlagAXMigrateAXToGlobalAutofocus and not FFlagAXMigrateFormPeekViewToFocusNavigation then {
				Close = RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonB, function() -- line: 232
					-- upvalues: t2 (copy)
					t2.closePeekViewSignal:fire()
				end, {
					key = "CommonUI.Controls.Action.Back"
				}),
				Apply = if not t2.canApply then nil else RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonX, t2.onApply, {
					key = "CommonUI.Messages.Action.Apply"
				}),
				Reset = if not t2.canReset then nil else RoactGamepad.Input.onBegin(Enum.KeyCode.ButtonY, t2.onReset, {
					key = "CommonUI.Messages.Action.Reset"
				})
			} else nil
		}, {
			Background = React.createElement("TextButton", {
				BackgroundTransparency = v52 and Theme.Overlay.Transparency or 1,
				BackgroundColor3 = Theme.Overlay.Color,
				Size = UDim2.new(1, 0, 1, v59),
				Position = UDim2.fromOffset(0, -v59),
				ZIndex = 1,
				Text = "",
				AutoButtonColor = false,
				[React.Event.Activated] = if not FFlagAXCloseFilterOnBackgroundTap then nil else v66
			}),
			FiltersTopBar = React.createElement(FiltersTopBar, {
				buttonRef = if not FFlagAXMigrateFormPeekViewToFocusNavigation then v55.FiltersTopBar else v68,
				NextSelectionDown = v55.SortAndFiltersContent,
				closePeekViewSignal = t2.closePeekViewSignal
			}),
			PeekViewContainer = React.createElement("Frame", {
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				ZIndex = 2,
				Position = UDim2.fromOffset(0, v59),
				Size = UDim2.new(1, 0, 1, -v59)
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
					contentFrameRef = v61,
					closeSignal = t2.closePeekViewSignal,
					viewStateChanged = function(p7, _) -- line: 288
						-- upvalues: PeekViewState (copy), v56 (copy)
						if p7 == PeekViewState.Closed then
							v56.goBack()
						end
					end,
					bottomDockedContainerHeight = n1,
					bottomDockedContainerContent = React.createElement(ResetApplyBar, {
						height = n1,
						canReset = t2.canReset,
						canApply = t2.canApply,
						onReset = t2.onReset,
						onApply = t2.onApply,
						frameRef = if not FFlagAXMigrateFormPeekViewToFocusNavigation then v55.BottomBar else v69,
						NextSelectionUp = v55.SortAndFiltersContent
					}),
					backgroundColor3 = Theme.BackgroundDefault.Color,
					backgroundTransparency = Theme.BackgroundUIDefault.Transparency
				}, {
					SortAndFiltersContent = React.createElement(if not FFlagAXMigrateAXToGlobalAutofocus then Focusable.Frame else "Frame", {
						Size = t2.totalSize,
						AutomaticSize = if not t2.useAutomaticSize then nil else Enum.AutomaticSize.Y,
						BorderSizePixel = 0,
						BackgroundTransparency = 1,
						ref = if not FFlagAXMigrateFormPeekViewToFocusNavigation then v55.SortAndFiltersContent else v67,
						NextSelectionUp = if not FFlagAXMigrateAXToGlobalAutofocus then if not FFlagAXMigrateFormPeekViewToFocusNavigation then v55.FiltersTopBar else v68 else nil,
						NextSelectionDown = if not FFlagAXMigrateAXToGlobalAutofocus then v55.BottomBar else nil,
						[React.Change.AbsoluteSize] = updatePeekViewContentFrameSize,
						defaultChild = if not FFlagAXMigrateAXToGlobalAutofocus then v55.Filters else nil,
						restorePreviousChildFocus = not FFlagAXMigrateAXToGlobalAutofocus or nil
					}, {
						Layout = React.createElement("UIListLayout", {
							SortOrder = Enum.SortOrder.LayoutOrder,
							FillDirection = Enum.FillDirection.Vertical
						}),
						Children = React.createElement(React.Fragment, {}, t2.children)
					})
				})
			})
		})
	})
	local v75 = useOverlayClosedCallback(if not FFlagAXMigrateAXToGlobalAutofocus then v53 else nil)
	local v76 = useAvatarExperienceFocusNavigationBindings({
		overlayClosedCallback = v75
	})

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ref = v76,
		Size = UDim2.fromScale(1, 1),
		Visible = not v51
	}, v74)
end

return withStackVisibilityWrapper(FormPeekView)
