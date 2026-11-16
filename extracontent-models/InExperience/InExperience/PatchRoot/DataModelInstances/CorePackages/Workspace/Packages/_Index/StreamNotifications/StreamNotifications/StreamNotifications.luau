local CoreGui = game:GetService("CoreGui")

local streamNotifications = script:FindFirstAncestor("StreamNotifications")
local parent = streamNotifications.Parent
local CurrentCamera = workspace.CurrentCamera
local constants = require(streamNotifications.constants)

local React = require(parent.React)
local ReactRoblox = require(parent.ReactRoblox)
local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
require(parent.ReactFocusNavigation)
local InputHandlers = require(parent.InputHandlers)

local components = streamNotifications.components
local StreamNotificationsHeader = require(components.StreamNotificationsHeader)
local StreamNotificationsContent = require(components.StreamNotificationsContent)

local analyticsService = require(streamNotifications.analytics.analyticsService)
local eventStream = analyticsService.EventStream
local NotificationsCommon = require(parent.NotificationsCommon)
local NotificationHelper = NotificationsCommon.NotificationHelper
local analyticsConstants = require(streamNotifications.analytics.analyticsConstants)

local SharedFlags = require(parent.SharedFlags)
local FFlagLuaAppSupportDeviceSafeInsets = SharedFlags.FFlagLuaAppSupportDeviceSafeInsets

local StreamNotificationDropdownExperimentation = require(streamNotifications.StreamNotificationDropdownExperimentation)

local function calculateDropdownHeight(y: number) -- 3 equivalent calls inferred from this helper
	return (math.min(
		constants.Dropdown.MaxHeight,
		(math.max(y - constants.Dropdown.VerticalMargin, constants.Dropdown.MinHeight))
	))
end

return function(p)
	local v = useStyle()
	local dropdownEnabled = StreamNotificationDropdownExperimentation.getDropdownEnabled()

	local useState = React.useState
	local v2

	if dropdownEnabled then
		v2 = calculateDropdownHeight(CurrentCamera.ViewportSize.Y) -- inferred equivalent call
	else
		v2 = 0
	end

	local state, setState = useState(v2)

	local state2, setState2 = React.useState(CurrentCamera.ViewportSize.X < constants.Modal.WidthLimit)

	React.useEffect(function()
		if dropdownEnabled then
			setState(calculateDropdownHeight(CurrentCamera.ViewportSize.Y)) -- inferred equivalent call
		end

		local viewportSizeChangedConnection = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			if dropdownEnabled then
				setState(calculateDropdownHeight(CurrentCamera.ViewportSize.Y)) -- inferred equivalent call
			end

			if CurrentCamera.ViewportSize.X < constants.Modal.WidthLimit then
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
	local showOverlay = React.useCallback(function(p2)
		setState3(p2)
	end)

	local state4, setState4 = React.useState(true)

	local ref = React.useRef(nil)
	local handler = React.useMemo(function()
		return InputHandlers.onRelease(function(object)
			p.displayStream(false)
			NotificationHelper.fireEvent(
				eventStream,
				analyticsConstants.Context.click,
				analyticsConstants.EventNames.closeContent,
				{ closeMethod = analyticsConstants.CloseMethod.focusNavigationBack }
			)

			object:cancel()
		end)
	end, { p.displayStream })

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
					displayStream = p.displayStream
				}),
				StreamNotificationsContent = React.createElement(StreamNotificationsContent, {
					showOverlay = function() end,
					isSmallScreen = false,
					displayStream = p.displayStream,
					setDisplayScreenGuiEnabled = function() end,
					dropdownHeight = state
				})
			}
		)
	end

	local createElement = React.createElement
	local v3 = {
		ref = ref,
		Selectable = false,
		Size = UDim2.new(1, 0, 1, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = not state3 and 1 or v.Theme.Overlay.Transparency,
		BackgroundColor3 = v.Theme.Overlay.Color,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		Text = "",
		[React.Event.Activated] = function()
			p.displayStream(false)
			NotificationHelper.fireEvent(
				eventStream,
				analyticsConstants.Context.click,
				analyticsConstants.EventNames.closeContent,
				{ closeMethod = analyticsConstants.CloseMethod.backgroundOverlay }
			)
		end
	}

	local createElement2 = React.createElement
	local size

	if state2 then
		size = UDim2.new(1, 0, 1, 0)
	else
		size = UDim2.new(0, constants.Modal.Width, 0, constants.Modal.Height)
	end

	local v4 = {
		Size = size,
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = v.Theme.BackgroundDefault.Color,
		BackgroundTransparency = v.Theme.BackgroundDefault.Transparency,
		AutoButtonColor = false,
		BorderSizePixel = 0,
		Text = "",
		Selectable = false
	}

	local createElement3 = React.createElement
	local cornerRadius

	if state2 then
		cornerRadius = UDim.new(0, 0)
	else
		cornerRadius = UDim.new(0, constants.Modal.CornerRadius)
	end

	local v5 = {
		TextButtonOverlayBackground = createElement("TextButton", v3, {
			StreamNotificationsFrame = createElement2("TextButton", v4, {
				UICorner = createElement3("UICorner", { CornerRadius = cornerRadius }),
				Header = React.createElement(StreamNotificationsHeader, {
					isSmallScreen = state2,
					displayStream = p.displayStream
				}),
				StreamNotificationsContent = React.createElement(StreamNotificationsContent, {
					showOverlay = showOverlay,
					isSmallScreen = state2,
					displayStream = p.displayStream,
					setDisplayScreenGuiEnabled = setState4
				})
			})
		})
	}

	local createPortal = ReactRoblox.createPortal
	local createElement4 = React.createElement
	local v6 = {
		Enabled = state4,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 10,
		ScreenInsets = 0,
		IgnoreGuiInset = true
	}
	local screenInsets

	if FFlagLuaAppSupportDeviceSafeInsets then
		screenInsets = Enum.ScreenInsets.None
	end

	v6.ScreenInsets = screenInsets
	return createPortal({
		ScreenGui = createElement4("ScreenGui", v6, { React.createElement(FocusNavigableSurfaceWrapper, {
				surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
				isIsolated = true,
				frameProps = { ref = ref },
				customEventHandlers = {
					[FocusNavigationEventNameEnum.NavigateBack] = { handler = handler }
				}
			}, v5) })
	}, CoreGui)
end
