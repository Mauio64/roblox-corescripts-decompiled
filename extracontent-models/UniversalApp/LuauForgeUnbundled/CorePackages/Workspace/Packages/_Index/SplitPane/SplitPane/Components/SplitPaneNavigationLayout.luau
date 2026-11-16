local React = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/React")
local AppSplitView = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/AppSplitView")
local constants = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/NavigationRodux").Constants
local RobloxAppEnums = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/RobloxAppEnums")
local SharedFlags = require("@game/CorePackages/Workspace/Packages/_Workspace/SplitPane/SharedFlags")

local splitView = AppSplitView.SplitView
local enums = AppSplitView.Enums

local useSplitPaneRender = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Hooks/useSplitPaneRender")

local useSplitPaneFocusNavBridge = require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Hooks/useSplitPaneFocusNavBridge")
local fFlagSplitPaneEducationalTour = SharedFlags.FFlagSplitPaneEducationalTour
local fFlagNavigationCommandHandle = SharedFlags.FFlagNavigationCommandHandle

local v5 = if fFlagSplitPaneEducationalTour then require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/SplitPaneEducationalTour") else nil

local v6 = if fFlagNavigationCommandHandle then require("@game/CorePackages/Workspace/Packages/_Index/SplitPane/SplitPane/Components/SupportPaneTopRoutePublisher") else nil

local set = { [constants.TempRnSwitchNavigatorName] = true }

if constants.HomeContainerName ~= nil then
	set[constants.HomeContainerName] = true
end

local function getActiveRouteName(data)
	while data ~= nil and set[data.routeName] and data.routes ~= nil and data.index ~= nil do
		data = data.routes[data.index]
	end

	if data == nil then
		return nil
	end

	return data.routeName
end

local function isHomeActive(screens): boolean
	local item = screens[1]
	local v7 = if not (item == nil or item.descriptor == nil) then item.descriptor.state else nil

	if getActiveRouteName(v7) ~= RobloxAppEnums.AppPage.Home then
		return false
	end

	for i = 2, #screens do
		local options = if screens[i].descriptor ~= nil then screens[i].descriptor.options else nil

		if options == nil or options.splitPaneEligibility ~= enums.SplitPaneSlot.Support then
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
	local v7 = useSplitPaneRender(props.screens, props.cards, props.paneIndices, props.isRouteActiveOnPane)
	local ref = React.useRef(nil)

	useSplitPaneFocusNavBridge(ref)
	local isRootAppStack = fFlagSplitPaneEducationalTour and v7.isRootAppStack
	local v8, v9

	if fFlagSplitPaneEducationalTour then
		v8, v9 = useSupportPaneAnchorRef()
	end

	if v7.isBreakpointEnabled then
		local state

		if fFlagNavigationCommandHandle and props.isRouteActiveOnPane and #props.paneIndices > 0 then
			local screen = props.screens[props.paneIndices[#props.paneIndices]]

			if screen ~= nil then
				state = screen.descriptor.state
			end
		end

		local supportPaneMode = v7.supportPaneMode
		local v10

		if isRootAppStack then
			if v7.supportContentProps.paneCount == 0 then
				v10 = not v7.supportContentProps.hasDetailOnTop and isHomeActive(props.screens)
			else
				v10 = false
			end
		else
			v10 = isRootAppStack
		end

		local v11

		if v7.renderSupportContent == nil then
			v11 = React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1)
				},
				v7.supportSlotChildren
			)
		else
			v11 = v7.renderSupportContent(v7.supportContentProps, v7.supportSlotChildren)
		end

		if isRootAppStack and v9 ~= nil then
			v11 = React.createElement(
				"Frame",
				{
					ref = v9,
					Size = UDim2.fromScale(1, 1),
					BackgroundTransparency = 1,
					BorderSizePixel = 0
				},
				{ SupportContent = v11 }
			)
		end

		local v12 = {
			width = v7.supportWidth,
			minWidth = v7.supportMinWidth,
			maxWidth = v7.supportMaxWidth,
			resizable = 0,
			element = 0
		}
		local v13 = if supportPaneMode == enums.SupportPaneMode.Normal and v7.supportPaneResizable then enums.PaneResizable.Horizontal else enums.PaneResizable.None
		v12.resizable = v13

		v12.element = v11

		local v14 = next(v7.overlaySlotChildren) ~= nil

		local v15 = {
			ContentPaneSurface = React.createElement(
				"Frame",
				{
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.fromScale(1, 1),
					ref = ref
				},
				v7.primarySlotChildren
			)
		}

		local createElement = React.createElement
		local fragment = React.Fragment
		local v17 = {
			SplitView = React.createElement(splitView, {
				supportPane = v12,
				supportPaneMode = supportPaneMode,
				supportResizerAbovePane = v7.supportResizerAbovePane,
				onSupportPaneWidthChanged = v7.onSupportPaneWidthChanged,
				onContentRegionRectChanged = v7.onContentRegionRectChanged
			}, v15),
			TopRoutePublisher = 0,
			EducationalTour = 0,
			Overlay = 0
		}

		local v18 = if state ~= nil then React.createElement(v6, { routeState = state }) else nil
		v17.TopRoutePublisher = v18

		local v19 = if isRootAppStack then React.createElement(v5, {
			supportPaneRef = v8,
			supportPaneMode = supportPaneMode,
			isSupportSurfaceEligible = v10
		}) else nil
		v17.EducationalTour = v19

		local v20 = if v14 then React.createElement(
			"Frame",
			{
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 10
			},
			v7.overlaySlotChildren
		) else nil
		v17.Overlay = v20
		return createElement(fragment, nil, v17)
	else
		local clone = table.clone(v7.primarySlotChildren)

		for k, v10 in v7.overlaySlotChildren do
			clone[k] = v10
		end

		return React.createElement(React.Fragment, nil, clone)
	end
end

return SplitPaneNavigationLayout
