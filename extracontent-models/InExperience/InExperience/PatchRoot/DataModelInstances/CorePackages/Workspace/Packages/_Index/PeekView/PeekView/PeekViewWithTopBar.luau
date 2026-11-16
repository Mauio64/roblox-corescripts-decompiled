local parent = script:FindFirstAncestor("PeekView").Parent
local Cryo = require(parent.Cryo)
local React = require(parent.React)
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useRoactService = RobloxAppHooks.useRoactService
local Navigation = require(parent.Navigation)
local useRouteName = Navigation.useRouteName
local RoactServiceTags = require(parent.RoactServiceTags)
local AppEventIngestService = RoactServiceTags.AppEventIngestService
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local PeekView = require(script.Parent.PeekView)
local PeekViewState = require(script.Parent.PeekViewState)
local peekViewDismissedEvent = require(script.Parent.analytics.peekViewDismissedEvent)

local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader

local SharedFlags2 = require(parent.SharedFlags)
local FFlagFixOverlayTopInsetForDeviceSafeInsets = SharedFlags2.FFlagFixOverlayTopInsetForDeviceSafeInsets
local Display = require(parent.Display)
local shouldUseDeviceSafeInsets = Display.shouldUseDeviceSafeInsets
local Responsive = require(parent.Responsive)
local useDeviceInsets = Responsive.useDeviceInsets

local function PeekViewWithTopBar(props)
	local v = useRoactService(AppEventIngestService)
	local page = useRouteName()

	local v2 = useStyle()
	local onClosed = props.onClosed
	local onViewStateChanged = props.onViewStateChanged
	local viewStateChanged = React.useCallback(function(p, p2, p3)
		if p == PeekViewState.Closed then
			if onClosed then
				onClosed()
			end

			if p3.dismissMethod and v then
				local viewChangedEventMeta = props.viewChangedEventMeta or {}

				peekViewDismissedEvent.logEvent(
					v,
					"PeekView",
					Cryo.Dictionary.join(viewChangedEventMeta, p3, { page = page })
				)
			end
		end

		if onViewStateChanged then
			onViewStateChanged(p, p2)
		end
	end, { onClosed, onViewStateChanged, props.viewChangedEventMeta, v, page })

	local v3 = not (FFlagFixOverlayTopInsetForDeviceSafeInsets and shouldUseDeviceSafeInsets) and 0
		or useDeviceInsets().top

	local v4, v5 = React.useBinding(0)
	local function fn(p)
		v5(p)

		if props.transitionPercentCallback then
			props.transitionPercentCallback(p)
		end
	end

	local createElement = React.createElement
	local v6 = {
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.new(props.viewWidth or UDim.new(1, 0), UDim.new(1, 0)),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}

	local createElement2 = React.createElement
	local v7 = {
		Position = UDim2.new(0, 0, 0, -v3),
		Size = UDim2.new(1, 0, 0, props.topBarHeight + v3),
		BackgroundColor3 = v2.Theme.BackgroundDefault.Color,
		Active = false,
		BackgroundTransparency = 0,
		BorderColor3 = v2.Tokens.Color.Common.Shimmer.Color3,
		BorderSizePixel = 0,
		GroupTransparency = v4:map(function(p)
			return 1 - p
		end),
		ZIndex = 2
	}
	local peekViewTopBarInner

	if v3 > 0 then
		peekViewTopBarInner = React.createElement(
			"Frame",
			{
				Position = UDim2.new(0, 0, 0, v3),
				Size = UDim2.new(1, 0, 0, props.topBarHeight),
				BackgroundTransparency = 1
			},
			{ TopBarSlot = props.topBarSlot }
		)
	else
		peekViewTopBarInner = props.topBarSlot
	end

	local children = {
		PeekViewTopBar = createElement2("CanvasGroup", v7, {
			PeekViewTopBarInner = peekViewTopBarInner
		}),
		PeekViewContainer = 0
	}

	local createElement3 = React.createElement
	local v8 = {
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		ClipsDescendants = true
	}

	local createElement4 = React.createElement
	local v9 = {
		hasScrim = true,
		fullViewContentHeight = props.fullViewContentHeight,
		briefViewContentHeight = props.briefViewContentHeight,
		bottomDockedContainerHeight = props.bottomDockedContainerHeight,
		bottomDockedContainerContent = { PeekViewBottomBar = props.bottomBarSlot },
		mountAsFullView = props.mountAsFullView,
		mountAnimation = props.mountAnimation,
		viewStateChanged = viewStateChanged,
		briefToFullTransitionPercent = fn,
		hasSolidDragger = 0,
		scrollingFrameRef = 0
	}
	local hasSolidDragger

	if FFlagProfilePlatformNewProfileHeader then
		hasSolidDragger = props.hasSolidDragger
	end

	v9.hasSolidDragger = hasSolidDragger
	v9.scrollingFrameRef = props.scrollingFrameRef
	children.PeekViewContainer = createElement3("Frame", v8, {
		PeekView = createElement4(PeekView, v9, {
			UIListLayout = React.createElement("UIListLayout", {
				Padding = UDim.new(0, 0),
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalAlignment = Enum.HorizontalAlignment.Left,
				VerticalAlignment = Enum.VerticalAlignment.Top
			}),
			Content = props.contentSlot
		})
	})
	return createElement("Frame", v6, children)
end

return PeekViewWithTopBar
