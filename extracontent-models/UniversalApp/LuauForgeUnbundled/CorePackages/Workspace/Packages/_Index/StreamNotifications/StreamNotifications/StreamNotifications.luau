local CoreGui = game:GetService("CoreGui")

local currentCamera = workspace.CurrentCamera
local constants = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/constants")

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/React")
local ReactRoblox = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/ReactRoblox")
local useStyle = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/UIBlox").Core.Style.useStyle
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/FocusNavigationUtils")
local focusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/ReactFocusNavigation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/InputHandlers")

local StreamNotificationsHeader = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/components/StreamNotificationsHeader")
local module7 = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/components/StreamNotificationsContent")

local eventStream = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/analytics/analyticsService").EventStream
local notificationHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/NotificationsCommon").NotificationHelper
local analyticsConstants = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/analytics/analyticsConstants")

local fFlagLuaAppSupportDeviceSafeInsets = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/SharedFlags").FFlagLuaAppSupportDeviceSafeInsets

local StreamNotificationDropdownExperimentation = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/StreamNotificationDropdownExperimentation")

local function calculateDropdownHeight(p2)
	return (math.min(
		constants.Dropdown.MaxHeight,
		(math.max(p2 - constants.Dropdown.VerticalMargin, constants.Dropdown.MinHeight))
	))
end

return function(p2)
	local v5 = useStyle()
	local dropdownEnabled = StreamNotificationDropdownExperimentation.getDropdownEnabled()

	local useState = React.useState
	local v6

	if dropdownEnabled then
		local y = currentCamera.ViewportSize.Y
		v6 = math.min(
			constants.Dropdown.MaxHeight,
			(math.max(y - constants.Dropdown.VerticalMargin, constants.Dropdown.MinHeight))
		)
	else
		v6 = 0
	end

	local state, setState = useState(v6)

	local state2, setState2 = React.useState(currentCamera.ViewportSize.X < constants.Modal.WidthLimit)

	React.useEffect(function()
		if dropdownEnabled then
			local y = currentCamera.ViewportSize.Y
			setState((math.min(
				constants.Dropdown.MaxHeight,
				(math.max(y - constants.Dropdown.VerticalMargin, constants.Dropdown.MinHeight))
			)))
		end

		local viewportSizeChangedConnection = currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			if dropdownEnabled then
				local y = currentCamera.ViewportSize.Y
				setState((math.min(
					constants.Dropdown.MaxHeight,
					(math.max(y - constants.Dropdown.VerticalMargin, constants.Dropdown.MinHeight))
				)))
			end

			if currentCamera.ViewportSize.X < constants.Modal.WidthLimit then
				setState2(true)
			else
				setState2(false)
			end
		end)
		return function()
			viewportSizeChangedConnection:Disconnect()
		end
	end, { dropdownEnabled })

	local state3, setState3 = React.useState(true)
	local v7 = React.useCallback(function(p3)
		setState3(p3)
	end)

	local state4, setState4 = React.useState(true)

	local ref = React.useRef(nil)
	local v8 = React.useMemo(function()
		return InputHandlers.onRelease(function(object)
			p2.displayStream(false)
			notificationHelper.fireEvent(
				eventStream,
				analyticsConstants.Context.click,
				analyticsConstants.EventNames.closeContent,
				{ closeMethod = analyticsConstants.CloseMethod.focusNavigationBack }
			)

			object:cancel()
		end)
	end, { p2.displayStream })

	if dropdownEnabled then
		return React.createElement(
			"Frame",
			{
				Size = UDim2.new(0, constants.Dropdown.Width, 0, state),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = true
			},
			{
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, constants.Dropdown.PaddingTop),
					PaddingBottom = UDim.new(0, constants.Dropdown.PaddingBottom),
					PaddingLeft = UDim.new(0, constants.Dropdown.HorizontalPadding),
					PaddingRight = UDim.new(
						0,
						constants.Dropdown.HorizontalPadding - constants.Dropdown.ScrollBarThickness
					)
				}),
				UIListLayout = React.createElement("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					FillDirection = Enum.FillDirection.Vertical,
					Padding = UDim.new(0, constants.Dropdown.HeaderBodyGap)
				}),
				Header = React.createElement(StreamNotificationsHeader, {
					isSmallScreen = false,
					displayStream = p2.displayStream
				}),
				StreamNotificationsContent = React.createElement(module7, {
					showOverlay = function() end,
					isSmallScreen = false,
					displayStream = p2.displayStream,
					setDisplayScreenGuiEnabled = function() end,
					dropdownHeight = state
				})
			}
		)
	end

	local createElement = React.createElement
	local v11 = {
		ref = ref,
		Selectable = false,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = not state3 and 1 or v5.Theme.Overlay.Transparency,
		BackgroundColor3 = v5.Theme.Overlay.Color,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		Text = "",
		[React.Event.Activated] = function()
			p2.displayStream(false)
			notificationHelper.fireEvent(
				eventStream,
				analyticsConstants.Context.click,
				analyticsConstants.EventNames.closeContent,
				{ closeMethod = analyticsConstants.CloseMethod.backgroundOverlay }
			)
		end
	}

	local createElement2 = React.createElement

	local v15 = if state2 then UDim2.new(1, 0, 1, 0) else UDim2.new(0, constants.Modal.Width, 0, constants.Modal.Height)
	local v14 = {
		Size = v15,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = v5.Theme.BackgroundDefault.Color,
		BackgroundTransparency = v5.Theme.BackgroundDefault.Transparency,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		Text = "",
		Selectable = false
	}

	local createElement3 = React.createElement

	local v18 = if state2 then UDim.new(0, 0) else UDim.new(0, constants.Modal.CornerRadius)
	local v9 = {
		TextButtonOverlayBackground = createElement("TextButton", v11, {
			StreamNotificationsFrame = createElement2("TextButton", v14, {
				UICorner = createElement3("UICorner", { CornerRadius = v18 }),
				Header = React.createElement(StreamNotificationsHeader, {
					isSmallScreen = state2,
					displayStream = p2.displayStream
				}),
				StreamNotificationsContent = React.createElement(module7, {
					showOverlay = v7,
					isSmallScreen = state2,
					displayStream = p2.displayStream,
					setDisplayScreenGuiEnabled = setState4
				})
			})
		})
	}

	local createPortal = ReactRoblox.createPortal
	local createElement4 = React.createElement
	local v21 = {
		Enabled = state4,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 10,
		ScreenInsets = 0,
		IgnoreGuiInset = true
	}

	local v22 = if fFlagLuaAppSupportDeviceSafeInsets then Enum.ScreenInsets.None else nil
	v21.ScreenInsets = v22
	return createPortal({
		ScreenGui = createElement4("ScreenGui", v21, { React.createElement(focusNavigableSurfaceWrapper, {
				surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.PopUp,
				isIsolated = true,
				frameProps = { ref = ref },
				customEventHandlers = {
					[focusNavigationEventNameEnum.NavigateBack] = { handler = v8 }
				}
			}, v9) })
	}, CoreGui)
end
