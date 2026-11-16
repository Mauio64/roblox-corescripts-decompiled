local CorePackages = game:GetService("CorePackages")

local React = require(CorePackages.Packages.React)
local Foundation = require(CorePackages.Packages.Foundation)
local SignalsReact = require(CorePackages.Packages.SignalsReact)
local module = require("@luauforge/bundled/dDG")
local RoactNavigation = require(CorePackages.Packages.RoactNavigation)
local useSelector = require("@game/CorePackages/Workspace/Packages/RoactUtils").Hooks.RoactRodux.useSelector
local module2 = require("@luauforge/bundled/dFR")
local splitPaneStore = module2.SplitPaneStore
local splitPaneTelemetry = module2.SplitPaneTelemetry
local splitPaneVariant = module2.SplitPaneVariant

local fFlagEnableSplitPaneEDPFix = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagEnableSplitPaneEDPFix

local paneHostContext = if fFlagEnableSplitPaneEDPFix then require("@luauforge/bundled/dFR").PaneHostContext else nil

local Responsive = require("@game/CorePackages/Workspace/Packages/Responsive")
local usePreferredInput = Responsive.usePreferredInput

local module4 = require("@luauforge/bundled/ijf")

local supportRegionAvatarOverlayContainer = require("@luauforge/bundled/hRC").Components.SupportRegionAvatarOverlayContainer
local SharedFlags = require("@game/CorePackages/Workspace/Packages/SharedFlags")
local fFlagEnableSplitPaneTelemetry = SharedFlags.FFlagEnableSplitPaneTelemetry
local fFlagSplitPaneAvatarOnlyAlwaysExpanded = SharedFlags.FFlagSplitPaneAvatarOnlyAlwaysExpanded
local fFlagEnableSplitPaneAvatarOverlay = SharedFlags.FFlagEnableSplitPaneAvatarOverlay
local fFlagSplitPaneEducationalTour = SharedFlags.FFlagSplitPaneEducationalTour
local fFlagSplitPaneHostChromeYieldsInExpanded = SharedFlags.FFlagSplitPaneHostChromeYieldsInExpanded
local getSplitPaneEducationalTourStore

if fFlagSplitPaneEducationalTour then
	getSplitPaneEducationalTourStore = require("@luauforge/bundled/dFR").getSplitPaneEducationalTourStore
else
	getSplitPaneEducationalTourStore = nil
end

local v5 = if fFlagEnableSplitPaneAvatarOverlay then require("@luauforge/bundled/goB") else nil

local view = Foundation.View
local iconButton = Foundation.IconButton
local iconName = Foundation.Enums.IconName
local iconSize = Foundation.Enums.IconSize
local buttonVariant = Foundation.Enums.ButtonVariant
local supportPaneMode = module.Enums.SupportPaneMode

local function SplitSupportPaneHost(props)
	local store = splitPaneStore.getStore()
	local v6 = SignalsReact.useSignalState(store.getSupportPaneMode)
	local v7 = v6 == supportPaneMode.Expanded
	local v8 = v6 == supportPaneMode.Collapsed
	local v9 = Responsive.useDeviceInsets()
	local v10

	if fFlagSplitPaneEducationalTour then
		v10 = SignalsReact.useSignalState(getSplitPaneEducationalTourStore(false).getIsTourActive)
	else
		v10 = false
	end

	local v11 = usePreferredInput() == Responsive.Input.Directional

	local hasDetailOnTop = props.hasDetailOnTop == true
	local paneCount = props.paneCount or 0
	local v12 = props.splitPaneExpandable == nil or props.splitPaneExpandable == true
	local hostNavigation = props.hostNavigation
	local v13 = useSelector(function(p2)
		return p2.TopBar.statusBarHeight
	end)

	local v14 = fFlagEnableSplitPaneAvatarOverlay

	if v14 then
		v14 = paneCount == 0 and not v8
	end

	local ref = React.useRef(store)
	ref.current = store
	local ref2 = React.useRef(hostNavigation)
	ref2.current = hostNavigation
	local ref3 = React.useRef(props.supportRouteKeys)
	ref3.current = props.supportRouteKeys

	local v15 = React.useCallback(function()
		if fFlagEnableSplitPaneTelemetry then
			splitPaneTelemetry.logPaneControlPressed(splitPaneTelemetry.Control.Expand)
		end

		ref.current.toggleSupportPaneMode(supportPaneMode.Expanded)
	end, {})

	local v16 = React.useCallback(function()
		if fFlagEnableSplitPaneTelemetry then
			splitPaneTelemetry.logPaneControlPressed(splitPaneTelemetry.Control.Back)
		end

		local current = ref2.current

		if current == nil or current.state == nil then
			return
		end

		current.dispatch(RoactNavigation.Actions.back({
			key = current.state.key,
			immediate = true
		}))
	end, {})

	local v17 = React.useCallback(function()
		if fFlagEnableSplitPaneTelemetry then
			splitPaneTelemetry.logPaneControlPressed(splitPaneTelemetry.Control.Close)
		end

		local current = ref2.current
		local current2 = ref3.current

		if current == nil or current2 == nil then
			return
		end

		ref.current.setTemporarySupportPaneMode(nil)

		for k, v18 in current2 do
			current.dispatch(RoactNavigation.StackActions.pop({
				key = v18,
				prune = false,
				immediate = true
			}))
		end
	end, {})
	local v18

	if fFlagSplitPaneAvatarOnlyAlwaysExpanded and splitPaneVariant.isSupportPaneAlwaysExpanded() then
		v18 = false
	else
		v18 = v12 and (hasDetailOnTop or v7)
	end

	local v19 = hasDetailOnTop
	local v20 = hasDetailOnTop and paneCount > 1

	if fFlagSplitPaneHostChromeYieldsInExpanded then
		v20 = v20 and not v7
		v19 = v19 and not v7
	end

	local v23

	if fFlagEnableSplitPaneEDPFix then
		v23 = React.useMemo(function()
			return { isHostCloseVisible = v19, isFullScreen = v7 }
		end, { v19, v7 })
	end

	local v25 = if hasDetailOnTop then React.createElement(view, {
		tag = "bg-surface-0",
		Position = UDim2.fromOffset(0, -v9.top),
		Size = UDim2.new(1, v9.right, 1, v9.top + v9.bottom),
		ZIndex = -100
	}) else nil

	local v26 = if fFlagEnableSplitPaneEDPFix then React.createElement(
		paneHostContext.Provider,
		{ value = v23 },
		React.createElement(React.Fragment, nil, props.children)
	) else React.createElement(React.Fragment, nil, props.children)

	local v27 = if v14 and not v10 then React.createElement(
		"Frame",
		{
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = -100
		},
		{ Interaction = React.createElement(v5) }
	) else nil

	local v28 = if v14 and not v10 then React.createElement(module4, nil, {
		Overlay = React.createElement(supportRegionAvatarOverlayContainer)
	}) else nil
	local v29

	if (if v20 or v19 or v18 then not v11 else v18) and not v10 then
		local createElement = React.createElement
		local v31 = {
			tag = {
				["row align-y-center size-full-0 auto-y padding-medium"] = true,
				["flex-between"] = v20,
				["align-x-right"] = not v20
			},
			Position = UDim2.fromOffset(0, v13),
			ZIndex = 100
		}

		local v33 = if v20 then React.createElement(
			view,
			{
				tag = "col align-x-center align-y-center auto-xy radius-circle bg-over-media-0",
				LayoutOrder = 1
			},
			{
				Button = React.createElement(iconButton, {
					icon = iconName.ChevronLargeLeft,
					size = iconSize.Medium,
					variant = buttonVariant.Utility,
					isCircular = true,
					onActivated = v16
				})
			}
		) else nil

		local createElement2 = React.createElement
		local v37

		if v18 then
			local createElement3 = React.createElement

			local createElement4 = React.createElement
			local v43 = if v7 then iconName.TwoArrowsToCenter else iconName.TwoArrowsFromCenter
			v37 = createElement3(
				view,
				{
					tag = "col align-x-center align-y-center auto-xy radius-circle bg-over-media-0",
					LayoutOrder = 1
				},
				{
					Button = createElement4(iconButton, {
						icon = v43,
						size = iconSize.Medium,
						variant = buttonVariant.Utility,
						isCircular = true,
						onActivated = v15
					})
				}
			)
		end

		local v38 = if v19 then React.createElement(
			view,
			{
				tag = "col align-x-center align-y-center auto-xy radius-circle bg-over-media-0",
				LayoutOrder = 2
			},
			{
				Button = React.createElement(iconButton, {
					icon = iconName.X,
					size = iconSize.Medium,
					variant = buttonVariant.Utility,
					isCircular = true,
					onActivated = v17,
					testId = "support-pane-close-button"
				})
			}
		) else nil
		v29 = createElement(view, v31, {
			BackButton = v33,
			RightControls = createElement2(
				view,
				{ tag = "row align-y-center gap-small auto-xy", LayoutOrder = 2 },
				{ ExpandButton = v37, CloseButton = v38 }
			)
		})
	end

	return React.createElement("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		SelectionGroup = true,
		SelectionBehaviorLeft = Enum.SelectionBehavior.Escape
	}, {
		DetailBackground = v25,
		Content = v26,
		SceneInteractionFrame = v27,
		SupportRegionAvatarOverlay = v28,
		Controls = v29
	})
end

return React.memo(SplitSupportPaneHost)
