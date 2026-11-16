local parent = script:FindFirstAncestor("SplitPane").Parent

local React = require(parent.React)
local AppSplitView = require(parent.AppSplitView)
local NavigationRodux = require(parent.NavigationRodux)
local Constants = NavigationRodux.Constants
local RobloxAppEnums = require(parent.RobloxAppEnums)
local SharedFlags = require(parent.SharedFlags)

local SplitView = AppSplitView.SplitView
local Enums = AppSplitView.Enums

local useSplitPaneRender = require(script.Parent.Parent.Hooks.useSplitPaneRender)

local useSplitPaneFocusNavBridge = require(script.Parent.Parent.Hooks.useSplitPaneFocusNavBridge)
local FFlagSplitPaneEducationalTour = SharedFlags.FFlagSplitPaneEducationalTour
local FFlagNavigationCommandHandle = SharedFlags.FFlagNavigationCommandHandle
local SplitPaneEducationalTour

if FFlagSplitPaneEducationalTour then
	SplitPaneEducationalTour = require(script.Parent.SplitPaneEducationalTour)
else
	SplitPaneEducationalTour = nil
end

local SupportPaneTopRoutePublisher

if FFlagNavigationCommandHandle then
	SupportPaneTopRoutePublisher = require(script.Parent.SupportPaneTopRoutePublisher)
else
	SupportPaneTopRoutePublisher = nil
end

local set = { [Constants.TempRnSwitchNavigatorName] = true }

if Constants.HomeContainerName ~= nil then
	set[Constants.HomeContainerName] = true
end

local function getActiveRouteName(data)
	while data ~= nil and set[data.routeName] and data.routes ~= nil and data.index ~= nil do
		data = data.routes[data.index]
	end

	return if data ~= nil then data.routeName else nil
end

local function isHomeActive(screens): boolean
	local item = screens[1]
	local v

	if not (item == nil or item.descriptor == nil) then
		v = item.descriptor.state
	end

	if getActiveRouteName(v) ~= RobloxAppEnums.AppPage.Home then
		return false
	end

	for i = 2, #screens do
		local options

		if screens[i].descriptor ~= nil then
			options = screens[i].descriptor.options
		end

		if options == nil or options.splitPaneEligibility ~= Enums.SplitPaneSlot.Support then
			return false
		end
	end

	return true
end

local function useSupportPaneAnchorRef()
	local ref = React.useRef(nil)

	return ref, (React.useCallback(function(current)
		ref.current = current
	end, {}))
end

local function SplitPaneNavigationLayout(props)
	local v = useSplitPaneRender(props.screens, props.cards, props.paneIndices, props.isRouteActiveOnPane)
	local ref = React.useRef(nil)

	useSplitPaneFocusNavBridge(ref)
	local isRootAppStack = FFlagSplitPaneEducationalTour and v.isRootAppStack
	local supportPaneRef, ref2

	if FFlagSplitPaneEducationalTour then
		supportPaneRef, ref2 = useSupportPaneAnchorRef()
	end

	if v.isBreakpointEnabled then
		local state

		if FFlagNavigationCommandHandle and props.isRouteActiveOnPane and #props.paneIndices > 0 then
			local screen = props.screens[props.paneIndices[#props.paneIndices]]

			if screen ~= nil then
				state = screen.descriptor.state
			end
		end

		local supportPaneMode = v.supportPaneMode
		local isSupportSurfaceEligible

		if isRootAppStack then
			if v.supportContentProps.paneCount == 0 then
				isSupportSurfaceEligible = not v.supportContentProps.hasDetailOnTop and isHomeActive(props.screens)
			else
				isSupportSurfaceEligible = false
			end
		else
			isSupportSurfaceEligible = isRootAppStack
		end

		local v2

		if v.renderSupportContent == nil then
			v2 = React.createElement(
				"Frame",
				{ BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1) },
				v.supportSlotChildren
			)
		else
			v2 = v.renderSupportContent(v.supportContentProps, v.supportSlotChildren)
		end

		if isRootAppStack and ref2 ~= nil then
			v2 = React.createElement(
				"Frame",
				{
					ref = ref2,
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					BorderSizePixel = 0
				},
				{ SupportContent = v2 }
			)
		end

		local supportPane = {
			width = v.supportWidth,
			minWidth = v.supportMinWidth,
			maxWidth = v.supportMaxWidth,
			resizable = 0,
			element = 0
		}
		local resizable

		if supportPaneMode == Enums.SupportPaneMode.Normal and v.supportPaneResizable then
			resizable = Enums.PaneResizable.Horizontal
		else
			resizable = Enums.PaneResizable.None
		end

		supportPane.resizable = resizable

		supportPane.element = v2

		local v3 = next(v.overlaySlotChildren) ~= nil

		local v4 = {
			ContentPaneSurface = React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
					ref = ref
				},
				v.primarySlotChildren
			)
		}

		local createElement = React.createElement
		local fragment = React.Fragment
		local v5 = {
			SplitView = React.createElement(SplitView, {
				supportPane = supportPane,
				supportPaneMode = supportPaneMode,
				supportResizerAbovePane = v.supportResizerAbovePane,
				onSupportPaneWidthChanged = v.onSupportPaneWidthChanged,
				onContentRegionRectChanged = v.onContentRegionRectChanged
			}, v4),
			TopRoutePublisher = 0,
			EducationalTour = 0,
			Overlay = 0
		}
		local topRoutePublisher

		if state ~= nil then
			topRoutePublisher = React.createElement(SupportPaneTopRoutePublisher, {
				routeState = state
			})
		end

		v5.TopRoutePublisher = topRoutePublisher
		local educationalTour

		if isRootAppStack then
			educationalTour = React.createElement(SplitPaneEducationalTour, {
				supportPaneRef = supportPaneRef,
				supportPaneMode = supportPaneMode,
				isSupportSurfaceEligible = isSupportSurfaceEligible
			})
		end

		v5.EducationalTour = educationalTour
		local overlay

		if v3 then
			overlay = React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
					ZIndex = 10
				},
				v.overlaySlotChildren
			)
		end

		v5.Overlay = overlay
		return createElement(fragment, nil, v5)
	else
		local clone = table.clone(v.primarySlotChildren)

		for k, v2 in v.overlaySlotChildren do
			clone[k] = v2
		end

		return React.createElement(React.Fragment, nil, clone)
	end
end

return SplitPaneNavigationLayout
