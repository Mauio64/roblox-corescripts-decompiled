local ProfilePlatform = script:FindFirstAncestor("ProfilePlatform")
local parent = ProfilePlatform.Parent

local React = require(parent.React)
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local RobloxAppHooks = require(parent.RobloxAppHooks)
local useStatusBarHeight = RobloxAppHooks.useStatusBarHeight
local FFlagProfileModalViewStatusBarOffset = require(ProfilePlatform.Flags.FFlagProfileModalViewStatusBarOffset)
local FFlagProfileModalViewBottomSafeArea = require(ProfilePlatform.Flags.FFlagProfileModalViewBottomSafeArea)

local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local Enums = require(ProfilePlatform.Common.Enums)
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require(parent.InputHandlers)
local Display = require(parent.Display)
local SignalsReact = require(parent.SignalsReact)
local useSignalState = SignalsReact.useSignalState
local useProfileJsonComponent = require(ProfilePlatform.Hooks.useProfileJsonComponent)
local useProfileWrapperContext = require(ProfilePlatform.Contexts.useProfileWrapperContext)
local FFlagFixCommunityProfileWideCoverLayout = require(ProfilePlatform.Flags.FFlagFixCommunityProfileWideCoverLayout)

local Foundation = require(parent.Foundation)
local View = Foundation.View

return function(props)
	local v = useStyle()

	local v2 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)

	local frameProps = {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.fromScale(1, 0),
		Size = 0,
		BackgroundTransparency = 0,
		BackgroundColor3 = 0,
		BorderSizePixel = 0
	}
	local size

	if props.fillPane then
		size = UDim2.fromScale(1, 1)
	else
		size = UDim2.new(0, props.viewWidth, 1, 0)
	end

	frameProps.Size = size
	frameProps.BackgroundTransparency = v.Theme.BackgroundDefault.Transparency
	frameProps.BackgroundColor3 = v.Theme.BackgroundDefault.Color
	local v3

	if FFlagProfileModalViewStatusBarOffset then
		v3 = useStatusBarHeight()
	end

	local v4 = not FFlagProfileModalViewStatusBarOffset and 0
		or -(v3 + (not FFlagProfileModalViewBottomSafeArea and 0 or v2.bottom))
	local v5

	if FFlagFixCommunityProfileWideCoverLayout then
		v5 = useProfileWrapperContext()
	end

	local v6

	if FFlagFixCommunityProfileWideCoverLayout then
		v6 = useProfileJsonComponent(Enums.Components.CoverPhoto)
	end

	local v7 = FFlagFixCommunityProfileWideCoverLayout
		and v5 ~= nil
		and v5.profileType == Enums.ProfileTypes.Community
		and v6 ~= nil
		and v6.coverPhotoId == nil
		and 56
		or 0

	local v8 = React.useCallback(function(p)
		return React.createElement("TextButton", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0, 0),
			Text = "",
			Selectable = false
		}, { p })
	end)

	local handler = React.useMemo(function()
		return InputHandlers.onRelease(function(object)
			object:cancel()
			props.navigateBack()
		end)
	end, { props.navigateBack })

	local createElement = React.createElement
	local navigateBacksByActivated = {
		Position = UDim2.fromOffset(0, -v2.top),
		Size = UDim2.new(1, v2.right, 1, v2.top + v2.bottom),
		BackgroundTransparency = v.Theme.Overlay.Transparency,
		BackgroundColor3 = v.Theme.Overlay.Color,
		Active = true,
		AutoButtonColor = false,
		[React.Event.Activated] = props.navigateBack
	}

	local createElement2 = React.createElement
	local v9 = {
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
		isIsolated = true,
		frameProps = frameProps,
		customEventHandlers = {
			[FocusNavigationEventNameEnum.NavigateBack] = { handler = handler }
		}
	}

	local createElement3 = React.createElement
	local v10 = {
		tag = {
			["anchor-top-left"] = FFlagProfileModalViewStatusBarOffset,
			["position-top-left"] = not FFlagProfileModalViewStatusBarOffset
		},
		Position = 0,
		Size = 0,
		ZIndex = 100
	}
	local position

	if FFlagProfileModalViewStatusBarOffset then
		position = UDim2.new(0, 0, 0, v3)
	end

	v10.Position = position

	v10.Size = UDim2.new(1, 0, 0, 56)
	local children = {
		ProfileTopBarContainer = createElement3(View, v10, { ProfileTopBar = props.renderTopBar() }),
		PeekViewContainer = 0
	}

	local createElement4 = React.createElement
	local v11 = {
		ScrollingDirection = Enum.ScrollingDirection.Y,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 1, 1, v4),
		Position = UDim2.new(0, 0, 0, not FFlagProfileModalViewStatusBarOffset and 0 or v3),
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(1, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Selectable = false
	}
	local topInset

	if FFlagFixCommunityProfileWideCoverLayout and v7 > 0 then
		topInset = React.createElement("UIPadding", { PaddingTop = UDim.new(0, v7) })
	end

	children.PeekViewContainer = createElement4("ScrollingFrame", v11, {
		TopInset = topInset,
		Content = props.renderContent()
	})
	return createElement("ImageButton", navigateBacksByActivated, {
		ProfileWindow = createElement2(FocusNavigableSurfaceWrapper, v9, { v8(children) })
	})
end
