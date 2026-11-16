local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local module2 = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/PeekView")
local peekView = module2.PeekView
local peekViewState = module2.PeekViewState
local RoactUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RoactUtils")
local view = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation").View
local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox").Core.Style.useStyle
local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local fFlagProfilePlatformNewProfileHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformNewProfileHeader
local fFlagProfilePlatformPeekDraggerContrast = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SharedFlags").FFlagProfilePlatformPeekDraggerContrast

local useSelector = RoactUtils.Hooks.RoactRodux.useSelector
local v5 = fFlagProfilePlatformNewProfileHeader and 0 or 25

local function ProfilePeekView(props)
	local statusBarHeight = props.statusBarHeight or useSelector(function(p2)
		return p2.TopBar.statusBarHeight
	end)

	local v6 = if fFlagProfilePlatformNewProfileHeader then useStyle() else nil

	local v7 = React.useCallback(function(p2, p3, p4)
		if p2 == peekViewState.Closed and props.onClosed then
			props.onClosed()
		end

		if props.onViewStateChanged then
			props.onViewStateChanged(p2, p3, p4)
		end
	end, { props.onClosed, props.onViewStateChanged })

	local v8, v9 = React.useBinding(0)
	local function fn(p2)
		v9(p2)

		if props.transitionPercentCallback then
			props.transitionPercentCallback(p2)
		end
	end

	local udim

	if fFlagProfilePlatformNewProfileHeader then
		udim = UDim2.new(1, 0, 1, -statusBarHeight)
	else
		udim = UDim2.new(1, 0, 1, -statusBarHeight + v5)
	end

	local udim2

	if fFlagProfilePlatformNewProfileHeader then
		udim2 = UDim2.new(0, 0, 0, statusBarHeight)
	else
		udim2 = UDim2.new(0, 0, 0, statusBarHeight - v5)
	end

	local contrast

	if
		fFlagProfilePlatformNewProfileHeader
		and fFlagProfilePlatformPeekDraggerContrast
		and props.profileType == Enums.ProfileTypes.User
	then
		contrast = v6.Tokens.Color.System.Contrast
	end

	local createElement = React.createElement
	local v11 = {
		tag = "position-top-left",
		Size = UDim2.new(props.viewWidth or UDim.new(1, 0), UDim.new(1, 0))
	}

	local v13 = if not fFlagProfilePlatformNewProfileHeader then React.createElement(view, {
		tag = "position-top-left bg-surface-0",
		Size = UDim2.new(1, 0, 0, statusBarHeight),
		BorderSizePixel = 0,
		ZIndex = 999
	}) else nil

	local createElement2 = React.createElement

	local createElement3 = React.createElement
	local v18 = {
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
	local v19 = if props.briefViewContentHeight then props.briefViewContentHeight else UDim.new(0.5, 0)
	v18.briefViewContentHeight = v19

	v18.bottomDockedContainerHeight = props.bottomDockedContainerHeight
	v18.bottomDockedContainerContent = { PeekViewBottomBar = props.bottomBarSlot }

	v18.mountAsFullView = props.mountAsFullView
	v18.mountAnimation = props.mountAnimation
	v18.viewStateChanged = v7
	v18.briefToFullTransitionPercent = fn

	local v20 = if fFlagProfilePlatformNewProfileHeader and props.profileType == Enums.ProfileTypes.User then false else nil
	v18.hasSolidDragger = v20

	v18.draggerImageStyle = contrast
	local v12 = {
		StatusBarSpace = v13,
		ProfileContent = createElement2(view, { Size = udim, Position = udim2 }, {
			PeekView = createElement3(peekView, v18, {
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
	local v21

	if fFlagProfilePlatformNewProfileHeader then
		v21 = React.createElement("CanvasGroup", {
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 0, statusBarHeight + 56),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			GroupTransparency = v8:map(function(p2)
				return 1 - p2
			end),
			ZIndex = 1000
		}, {
			StatusBarBackground = React.createElement("Frame", {
				Position = UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(1, 0, 0, statusBarHeight),
				BackgroundColor3 = v6.Theme.BackgroundDefault.Color,
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

	v12.PeekViewTopBar = v21
	local v22

	if not fFlagProfilePlatformNewProfileHeader then
		v22 = React.createElement("CanvasGroup", {
			Size = UDim2.new(1, 0, 0, 56),
			Position = UDim2.new(0, 0, 0, statusBarHeight),
			BackgroundTransparency = 1,
			ZIndex = 1000,
			GroupTransparency = v8:map(function(p2)
				return 1 - p2
			end)
		}, { TopBar = props.topBarSlot })
	end

	v12.TransparentTopBarOverlay = v22
	return createElement(view, v11, v12)
end

return ProfilePeekView
