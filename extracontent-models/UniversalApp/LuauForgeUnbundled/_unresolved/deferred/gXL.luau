local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local useNavigation = require("@game/CorePackages/Workspace/Packages/Navigation").useNavigation
local RoactGamepad = require(CorePackages.Packages.RoactGamepad)
local UIBlox = require(CorePackages.Packages.UIBlox)
local module = require("@luauforge/deferred/gpj")
local AvatarExperienceCommon = require("@game/CorePackages/Workspace/Packages/AvatarExperienceCommon")
local fullView = AvatarExperienceCommon.Enums.FullView
require("@luauforge/bundled/dHK")

local module3 = require("@luauforge/bundled/fox")
local peekView = require("@luauforge/bundled/dzD").PeekView
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector

local module4 = require("@luauforge/deferred/gfe")
local module5 = require("@luauforge/bundled/dMx")
local fFlagEnableSplitPane = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPane

local v5 = if fFlagEnableSplitPane then require("@luauforge/bundled/fuN") else nil

local module6 = require("@luauforge/bundled/dwA")
local module7 = require("@luauforge/deferred/gXM")
local module8 = require("@luauforge/deferred/gXN")
local avatarScreen = require("@game/CorePackages/Workspace/Packages/AvatarExperienceNavigation").Enums.AvatarScreen

local module9 = require("@luauforge/deferred/gmV")
local module10 = require("@luauforge/deferred/ggG")
require("@game/CorePackages/Workspace/Packages/AppCommonLib")
local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local getUseSelectorDeepEquals = AvatarExperienceCommon.Utils.getUseSelectorDeepEquals

local peekViewState = require("@luauforge/bundled/dzD").PeekViewState
local useStyle = UIBlox.Core.Style.useStyle
local useIsGamepad = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useIsGamepad
local module12 = require("@luauforge/bundled/eeo")
local ReactFocusNavigation = require(CorePackages.Packages.ReactFocusNavigation)
local InputHandlers = require(CorePackages.Packages.InputHandlers)
local focusNavigationEventNameEnum = module12.FocusNavigationEventNameEnum
local useTableWrappedCallbackRef = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.useTableWrappedCallbackRef

local module13 = require("@luauforge/bundled/gfm")

local module14 = require("@luauforge/deferred/gmi")
local module15 = require("@luauforge/deferred/gml")

local fFlagAXCloseFilterOnBackgroundTap = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagAXCloseFilterOnBackgroundTap

local v6 = {
	[Enum.KeyCode.ButtonB] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.Escape] = focusNavigationEventNameEnum.NavigateBack,
	[Enum.KeyCode.ButtonX] = focusNavigationEventNameEnum.FormPeekViewApply,
	[Enum.KeyCode.ButtonY] = focusNavigationEventNameEnum.FormPeekViewReset
}

local function useFocusNavigationBindings(p2, callback, p3, p4)
	local v7 = ReactFocusNavigation.useEventMap(v6, p2)
	local v8 = React.useMemo(function()
		return {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p5)
					p5.cancelled = true
					callback()
				end)
			},
			[focusNavigationEventNameEnum.FormPeekViewApply] = p3 and {
				handler = InputHandlers.onRelease(p3)
			} or nil,
			[focusNavigationEventNameEnum.FormPeekViewReset] = p4 and {
				handler = InputHandlers.onRelease(p4)
			} or nil
		}
	end, { callback, p3, p4 })
	return ReactFocusNavigation.useEventHandlerMap(v8, v7)
end

local function FormPeekView(props)
	local v7 = module() == fullView.SceneFullView
	local v8 = useSelector(module13, getUseSelectorDeepEquals())
	local v9 = React.useContext(module10)
	local v10 = RoactGamepad.useRefCache()
	local v11 = useNavigation()
	local udim, udim2

	if v8 then
		udim = UDim2.fromScale(0, 0)
		udim2 = UDim2.fromScale(1, 1)
	else
		local fromScale = UDim2.fromScale
		local v12 = if fFlagEnableSplitPane then v5.getLandscapeNavWidth() else module5.LandscapeNavWidth
		udim = fromScale(v12, 0)

		local fromScale2 = UDim2.fromScale
		local v13 = if fFlagEnableSplitPane then v5.getLandscapeSceneWidth() else module5.LandscapeSceneWidth
		udim2 = fromScale2(v13, 1)
	end

	local v12 = useSelector(module3.selectTopBarHeight, getUseSelectorDeepEquals())
	local theme = useStyle().Theme

	local ref = React.useRef(nil)

	local v13 = useIsGamepad()
	local total = 80
	local v14 = Responsive.usePreferredInput() == Responsive.Input.Directional

	if v13 and v14 then
		total += module6.GAMEPAD_BOTTOM_BAR_SIZE
	end

	local function updatePeekViewContentFrameSize(p2)
		local current = ref.current

		if p2 and current then
			local y = p2.AbsoluteSize.Y
			current.AutomaticSize = Enum.AutomaticSize.None
			current.Size = UDim2.new(1, 0, 0, y)
		end
	end

	local v15

	if fFlagAXCloseFilterOnBackgroundTap then
		v15 = React.useCallback(function()
			props.closePeekViewSignal:fire()
		end, { props.closePeekViewSignal })
	end

	local v16 = React.useCallback(function()
		props.closePeekViewSignal:fire()
	end, { props.closePeekViewSignal })

	local sortAndFiltersContent = v10.SortAndFiltersContent

	local onApply = if props.canApply then props.onApply else nil
	local v18 = if props.canReset then props.onReset else nil
	local v19 = useFocusNavigationBindings(sortAndFiltersContent, v16, onApply, v18)

	local filtersTopBar = v10.FiltersTopBar

	local onApply2 = if props.canApply then props.onApply else nil
	local v21 = if props.canReset then props.onReset else nil
	local v22 = useFocusNavigationBindings(filtersTopBar, v16, onApply2, v21)

	local bottomBar = v10.BottomBar

	local onApply3 = if props.canApply then props.onApply else nil
	local v24 = if props.canReset then props.onReset else nil
	local v25 = useFocusNavigationBindings(bottomBar, v16, onApply3, v24)

	local v26 = useTableWrappedCallbackRef(v19)
	local v27 = useTableWrappedCallbackRef(v22)
	local v28 = useTableWrappedCallbackRef(v25)

	local createElement = React.createElement
	local v30 = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		Visible = not v7,
		ref = v9[avatarScreen.SortAndFilters]
	}
	local v31 = { NavigationEventsLogger = React.createElement(module4), Content = 0 }
	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v35 = {
		["BackgroundTransparency"] = v8 and theme.Overlay.Transparency or 1,
		BackgroundColor3 = theme.Overlay.Color,
		Size = UDim2.new(1, 0, 1, v12),
		Position = UDim2.fromOffset(0, -v12),
		ZIndex = 1,
		Text = "",
		AutoButtonColor = false
	}

	local activated = React.Event.Activated

	if not fFlagAXCloseFilterOnBackgroundTap then
		v15 = nil
	end

	v35[activated] = v15
	local children = {
		Background = createElement3("TextButton", v35),
		FiltersTopBar = React.createElement(module7, {
			buttonRef = v27,
			NextSelectionDown = v10.SortAndFiltersContent,
			closePeekViewSignal = props.closePeekViewSignal
		}),
		PeekViewContainer = 0
	}

	local createElement4 = React.createElement
	local v37 = {
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Position = UDim2.fromOffset(0, v12),
		Size = UDim2.new(1, 0, 1, -v12),
		ZIndex = 2
	}

	local createElement5 = React.createElement
	local v40 = {
		briefViewContentHeight = UDim.new(0, 0),
		mountAnimation = true,
		mountAsFullView = true,
		canDragFullViewToBrief = false,
		showDraggerInClosedState = false,
		returnToFullView = true,
		thumbstickScrollEnabled = true,
		contentFrameRef = ref,
		closeSignal = props.closePeekViewSignal,
		viewStateChanged = function(p2, p3)
			if p2 == peekViewState.Closed then
				v11.goBack()
			end
		end,
		bottomDockedContainerHeight = total,
		bottomDockedContainerContent = React.createElement(module8, {
			height = total,
			canReset = props.canReset,
			canApply = props.canApply,
			onReset = props.onReset,
			onApply = props.onApply,
			frameRef = v28,
			NextSelectionUp = v10.SortAndFiltersContent
		}),
		backgroundColor3 = theme.BackgroundDefault.Color,
		backgroundTransparency = theme.BackgroundUIDefault.Transparency,
		peekHeaderClose = true,
		isScrollingEnabled = true
	}

	local createElement6 = React.createElement
	local updatePeekViewContentFrameSizesByAbsoluteSize = {}
	updatePeekViewContentFrameSizesByAbsoluteSize.Size = props.totalSize
	local v43 = if props.useAutomaticSize then Enum.AutomaticSize.Y else nil
	updatePeekViewContentFrameSizesByAbsoluteSize.AutomaticSize = v43
	updatePeekViewContentFrameSizesByAbsoluteSize.BorderSizePixel = 0
	updatePeekViewContentFrameSizesByAbsoluteSize.BackgroundTransparency = 1
	updatePeekViewContentFrameSizesByAbsoluteSize.ref = v26
	updatePeekViewContentFrameSizesByAbsoluteSize[React.Change.AbsoluteSize] = updatePeekViewContentFrameSize
	children.PeekViewContainer = createElement4("Frame", v37, {
		PeekView = createElement5(peekView, v40, {
			SortAndFiltersContent = createElement6("Frame", updatePeekViewContentFrameSizesByAbsoluteSize, {
				Layout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical
				}),
				Children = React.createElement(React.Fragment, {}, props.children)
			})
		})
	})
	v31.Content = createElement2(
		"Frame",
		{
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = udim2,
			Position = udim
		},
		children
	)
	local element = createElement("Frame", v30, v31)

	local v44 = module14({ overlayClosedCallback = module15() })

	return React.createElement("Frame", {
		ref = v44,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
		Visible = not v7
	}, element)
end

return module9(FormPeekView)
