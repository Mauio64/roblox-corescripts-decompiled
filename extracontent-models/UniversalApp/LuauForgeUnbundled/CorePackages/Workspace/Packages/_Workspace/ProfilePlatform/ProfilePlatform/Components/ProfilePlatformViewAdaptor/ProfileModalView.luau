local React = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/React")
local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/UIBlox").Core.Style.useStyle
local useStatusBarHeight = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/RobloxAppHooks").useStatusBarHeight
local FFlagProfileModalViewStatusBarOffset = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileModalViewStatusBarOffset")
local FFlagProfileModalViewBottomSafeArea = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagProfileModalViewBottomSafeArea")

local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/FocusNavigationUtils")
local focusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum

local Enums = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Common/Enums")
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/InputHandlers")
local Display = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Display")
local useSignalState = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/SignalsReact").useSignalState
local useProfileJsonComponent = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Hooks/useProfileJsonComponent")
local useProfileWrapperContext = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Contexts/useProfileWrapperContext")
local FFlagFixCommunityProfileWideCoverLayout = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/ProfilePlatform/Flags/FFlagFixCommunityProfileWideCoverLayout")

local view = require("@game/CorePackages/Workspace/Packages/_Workspace/ProfilePlatform/Foundation").View

return function(props)
	local v5 = useStyle()

	local v6 = useSignalState(Display.GetDisplayStore().getDeviceSafePadding)

	local v7 = {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.fromScale(1, 0),
		Size = 0,
		BackgroundTransparency = 0,
		BackgroundColor3 = 0,
		BorderSizePixel = 0
	}
	local v8 = if props.fillPane then UDim2.fromScale(1, 1) else UDim2.new(0, props.viewWidth, 1, 0)
	v7.Size = v8
	v7.BackgroundTransparency = v5.Theme.BackgroundDefault.Transparency
	v7.BackgroundColor3 = v5.Theme.BackgroundDefault.Color

	local v9 = if FFlagProfileModalViewStatusBarOffset then useStatusBarHeight() else nil

	local v11 = not FFlagProfileModalViewStatusBarOffset and 0 or -(v9 + (not FFlagProfileModalViewBottomSafeArea and 0 or v6.bottom))

	local v12 = if FFlagFixCommunityProfileWideCoverLayout then useProfileWrapperContext() else nil

	local v13 = if FFlagFixCommunityProfileWideCoverLayout then useProfileJsonComponent(Enums.Components.CoverPhoto) else nil

	local v14 = FFlagFixCommunityProfileWideCoverLayout
		and v12 ~= nil
		and v12.profileType == Enums.ProfileTypes.Community
		and v13 ~= nil
		and v13.coverPhotoId == nil
		and 56
		or 0

	local v15 = React.useCallback(function(p2)
		return React.createElement("TextButton", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			Position = UDim2.fromScale(0, 0),
			Text = "",
			Selectable = false
		}, { p2 })
	end)

	local v16 = React.useMemo(function()
		return InputHandlers.onRelease(function(object)
			object:cancel()
			props.navigateBack()
		end)
	end, { props.navigateBack })

	local createElement = React.createElement
	local navigateBacksByActivated = {
		Position = UDim2.fromOffset(0, -v6.top),
		Size = UDim2.new(1, v6.right, 1, v6.top + v6.bottom),
		BackgroundTransparency = v5.Theme.Overlay.Transparency,
		BackgroundColor3 = v5.Theme.Overlay.Color,
		Active = true,
		AutoButtonColor = false,
		[React.Event.Activated] = props.navigateBack
	}

	local createElement2 = React.createElement
	local v20 = {
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
		isIsolated = true,
		frameProps = v7,
		customEventHandlers = {
			[focusNavigationEventNameEnum.NavigateBack] = { handler = v16 }
		}
	}

	local createElement3 = React.createElement
	local v24 = {
		tag = {
			["anchor-top-left"] = FFlagProfileModalViewStatusBarOffset,
			["position-top-left"] = not FFlagProfileModalViewStatusBarOffset
		},
		Position = 0,
		Size = 0,
		ZIndex = 100
	}

	local v25 = if FFlagProfileModalViewStatusBarOffset then UDim2.new(0, 0, 0, v9) else nil
	v24.Position = v25

	v24.Size = UDim2.new(1, 0, 0, 56)
	local children = {
		ProfileTopBarContainer = createElement3(view, v24, {
			ProfileTopBar = props.renderTopBar()
		}),
		PeekViewContainer = 0
	}

	local createElement4 = React.createElement
	local v27 = {
		ScrollingDirection = Enum.ScrollingDirection.Y,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 1, 1, v11),
		Position = UDim2.new(0, 0, 0, not FFlagProfileModalViewStatusBarOffset and 0 or v9),
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(1, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Selectable = false
	}

	local v29 = if FFlagFixCommunityProfileWideCoverLayout and v14 > 0 then React.createElement("UIPadding", {
		PaddingTop = UDim.new(0, v14)
	}) else nil
	children.PeekViewContainer = createElement4("ScrollingFrame", v27, {
		TopInset = v29,
		Content = props.renderContent()
	})
	return createElement("ImageButton", navigateBacksByActivated, {
		ProfileWindow = createElement2(focusNavigableSurfaceWrapper, v20, { v15(children) })
	})
end
