local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local PeekView = require(parent.PeekView)
local peekView = PeekView.PeekView
local PeekViewState = PeekView.PeekViewState
local RoactUtils = require(parent.RoactUtils)
local Foundation = require(parent.Foundation)
local View = Foundation.View
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local Enums = require(ProfilePlatform.Common.Enums)
local SharedFlags = require(parent.SharedFlags)
local FFlagProfilePlatformNewProfileHeader = SharedFlags.FFlagProfilePlatformNewProfileHeader
local SharedFlags2 = require(parent.SharedFlags)
local FFlagProfilePlatformPeekDraggerContrast = SharedFlags2.FFlagProfilePlatformPeekDraggerContrast

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local v = FFlagProfilePlatformNewProfileHeader and 0 or 25

local function ProfilePeekView(props)
	local statusBarHeight = props.statusBarHeight or useSelector(function(p)
		return p.TopBar.statusBarHeight
	end)
	local v2

	if FFlagProfilePlatformNewProfileHeader then
		v2 = useStyle()
	end

	local viewStateChanged = React.useCallback(function(p, p2, p3)
		if p == PeekViewState.Closed and props.onClosed then
			props.onClosed()
		end

		if props.onViewStateChanged then
			props.onViewStateChanged(p, p2, p3)
		end
	end, { props.onClosed, props.onViewStateChanged })

	local v3, v4 = React.useBinding(0)
	local function fn(p)
		v4(p)

		if props.transitionPercentCallback then
			props.transitionPercentCallback(p)
		end
	end

	local udim

	if FFlagProfilePlatformNewProfileHeader then
		udim = UDim2.new(1, 0, 1, -statusBarHeight)
	else
		udim = UDim2.new(1, 0, 1, -statusBarHeight + v)
	end

	local udim2

	if FFlagProfilePlatformNewProfileHeader then
		udim2 = UDim2.new(0, 0, 0, statusBarHeight)
	else
		udim2 = UDim2.new(0, 0, 0, statusBarHeight - v)
	end

	local contrast

	if
		FFlagProfilePlatformNewProfileHeader
		and FFlagProfilePlatformPeekDraggerContrast
		and props.profileType == Enums.ProfileTypes.User
	then
		contrast = v2.Tokens.Color.System.Contrast
	end

	local createElement = React.createElement
	local v5 = {
		tag = "position-top-left",
		Size = UDim2.new(props.viewWidth or UDim.new(1, 0), UDim.new(1, 0))
	}
	local statusBarSpace

	if not FFlagProfilePlatformNewProfileHeader then
		statusBarSpace = React.createElement(View, {
			tag = "position-top-left bg-surface-0",
			Size = UDim2.new(1, 0, 0, statusBarHeight),
			BorderSizePixel = 0,
			ZIndex = 999
		})
	end

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v6 = {
		hasScrim = true,
		fullViewContentHeight = props.fullViewContentHeight,
		briefViewContentHeight = 0,
		bottomDockedContainerHeight = 0,
		bottomDockedContainerContent = 0,
		mountAsFullView = 0,
		mountAnimation = 0,
		viewStateChanged = 0,
		briefToFullTransitionPercent = 0,
		hasSolidDragger = 0,
		draggerImageStyle = 0
	}
	local briefViewContentHeight

	if props.briefViewContentHeight then
		briefViewContentHeight = props.briefViewContentHeight
	else
		briefViewContentHeight = UDim.new(0.5, 0)
	end

	v6.briefViewContentHeight = briefViewContentHeight

	v6.bottomDockedContainerHeight = props.bottomDockedContainerHeight
	v6.bottomDockedContainerContent = { PeekViewBottomBar = props.bottomBarSlot }

	v6.mountAsFullView = props.mountAsFullView
	v6.mountAnimation = props.mountAnimation
	v6.viewStateChanged = viewStateChanged
	v6.briefToFullTransitionPercent = fn
	v6.hasSolidDragger = (not FFlagProfilePlatformNewProfileHeader or props.profileType ~= Enums.ProfileTypes.User)
		and nil

	v6.draggerImageStyle = contrast
	local v7 = {
		StatusBarSpace = statusBarSpace,
		ProfileContent = createElement2(View, { Size = udim, Position = udim2 }, {
			PeekView = createElement3(peekView, v6, {
				UIListLayout = React.createElement("UIListLayout", {
					Padding = UDim.new(0, 0),
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Left,
					VerticalAlignment = Enum.VerticalAlignment.Top
				}),
				Content = props.contentSlot
			})
		}),
		PeekViewTopBar = 0,
		TransparentTopBarOverlay = 0
	}
	local peekViewTopBar

	if FFlagProfilePlatformNewProfileHeader then
		peekViewTopBar = React.createElement("CanvasGroup", {
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, statusBarHeight + 56),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			GroupTransparency = v3:map(function(p)
				return 1 - p
			end),
			ZIndex = 1000
		}, {
			StatusBarBackground = React.createElement("Frame", {
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, statusBarHeight),
				BackgroundColor3 = v2.Theme.BackgroundDefault.Color,
				BackgroundTransparency = 0,
				BorderSizePixel = 0
			}),
			TopBarSlotContainer = React.createElement(
				"Frame",
				{
					Position = UDim2.new(0, 0, 0, statusBarHeight),
					Size = UDim2.new(1, 0, 0, 56),
					BackgroundTransparency = 1,
					BorderSizePixel = 0
				},
				{ TopBar = props.topBarSlot }
			)
		})
	end

	v7.PeekViewTopBar = peekViewTopBar
	local transparentTopBarOverlay

	if not FFlagProfilePlatformNewProfileHeader then
		transparentTopBarOverlay = React.createElement("CanvasGroup", {
			Size = UDim2.new(1, 0, 0, 56),
			Position = UDim2.new(0, 0, 0, statusBarHeight),
			BackgroundTransparency = 1,
			ZIndex = 1000,
			GroupTransparency = v3:map(function(p)
				return 1 - p
			end)
		}, { TopBar = props.topBarSlot })
	end

	v7.TransparentTopBarOverlay = transparentTopBarOverlay
	return createElement(View, v5, v7)
end

return ProfilePeekView
