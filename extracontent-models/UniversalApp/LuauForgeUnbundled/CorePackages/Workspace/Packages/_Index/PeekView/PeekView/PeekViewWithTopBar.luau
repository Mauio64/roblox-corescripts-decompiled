local Cryo = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/Cryo")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/React")
local useRoactService = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/RobloxAppHooks").useRoactService
local useRouteName = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/Navigation").useRouteName
local appEventIngestService = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/RoactServiceTags").AppEventIngestService
local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/UIBlox").Core.Style.useStyle
local module3 = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/PeekView")
local PeekViewState = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/PeekViewState")
local peekViewDismissedEvent = require("@game/CorePackages/Workspace/Packages/_Index/PeekView/PeekView/analytics/peekViewDismissedEvent")

local fFlagProfilePlatformNewProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/SharedFlags").FFlagProfilePlatformNewProfileHeader

local fFlagFixOverlayTopInsetForDeviceSafeInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/SharedFlags").FFlagFixOverlayTopInsetForDeviceSafeInsets
local shouldUseDeviceSafeInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/Display").shouldUseDeviceSafeInsets
local useDeviceInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/PeekView/Responsive").useDeviceInsets

local function PeekViewWithTopBar(props)
	local v5 = useRoactService(appEventIngestService)
	local v6 = useRouteName()

	local v7 = useStyle()
	local onClosed = props.onClosed
	local onViewStateChanged = props.onViewStateChanged
	local v8 = React.useCallback(function(p2, p3, p4)
		if p2 == PeekViewState.Closed then
			if onClosed then
				onClosed()
			end

			if p4.dismissMethod and v5 then
				local viewChangedEventMeta = props.viewChangedEventMeta or {}

				peekViewDismissedEvent.logEvent(
					v5,
					"PeekView",
					Cryo.Dictionary.join(viewChangedEventMeta, p4, { page = v6 })
				)
			end
		end

		if onViewStateChanged then
			onViewStateChanged(p2, p3)
		end
	end, { onClosed, onViewStateChanged, props.viewChangedEventMeta, v5, v6 })

	local v9 = not (fFlagFixOverlayTopInsetForDeviceSafeInsets and shouldUseDeviceSafeInsets) and 0
		or useDeviceInsets().top

	local v10, v11 = React.useBinding(0)
	local function fn(p2)
		v11(p2)

		if props.transitionPercentCallback then
			props.transitionPercentCallback(p2)
		end
	end

	local createElement = React.createElement
	local v13 = {
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(props.viewWidth or UDim.new(1, 0), UDim.new(1, 0)),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local createElement2 = React.createElement
	local v15 = {
		Position = UDim2.new(0, 0, 0, -v9),
		Size = UDim2.new(1, 0, 0, props.topBarHeight + v9),
		BackgroundColor3 = v7.Theme.BackgroundDefault.Color,
		Active = false,
		BackgroundTransparency = 0,
		BorderColor3 = v7.Tokens.Color.Common.Shimmer.Color3,
		BorderSizePixel = 0,
		GroupTransparency = v10:map(function(p2)
			return 1 - p2
		end),
		ZIndex = 2
	}

	local v17 = if v9 > 0 then React.createElement(
		"Frame",
		{
			Position = UDim2.new(0, 0, 0, v9),
			Size = UDim2.new(1, 0, 0, props.topBarHeight),
			BackgroundTransparency = 1
		},
		{ TopBarSlot = props.topBarSlot }
	) else props.topBarSlot
	local children = {
		PeekViewTopBar = createElement2("CanvasGroup", v15, {
			PeekViewTopBarInner = v17
		}),
		PeekViewContainer = 0
	}

	local createElement3 = React.createElement
	local v19 = {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = true
	}

	local createElement4 = React.createElement
	local v22 = {
		hasScrim = true,
		fullViewContentHeight = props.fullViewContentHeight,
		briefViewContentHeight = props.briefViewContentHeight,
		bottomDockedContainerHeight = props.bottomDockedContainerHeight,
		bottomDockedContainerContent = { PeekViewBottomBar = props.bottomBarSlot },
		mountAsFullView = props.mountAsFullView,
		mountAnimation = props.mountAnimation,
		viewStateChanged = v8,
		briefToFullTransitionPercent = fn,
		hasSolidDragger = 0,
		scrollingFrameRef = 0
	}

	local v23 = if fFlagProfilePlatformNewProfileHeader then props.hasSolidDragger else nil
	v22.hasSolidDragger = v23
	v22.scrollingFrameRef = props.scrollingFrameRef
	children.PeekViewContainer = createElement3("Frame", v19, {
		PeekView = createElement4(module3, v22, {
			UIListLayout = React.createElement("UIListLayout", {
				Padding = UDim.new(0, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top
			}),
			Content = props.contentSlot
		})
	})
	return createElement("Frame", v13, children)
end

return PeekViewWithTopBar
