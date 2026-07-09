local CoreGui = game:GetService("CoreGui")
local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local StreamNotificationsParent = StreamNotifications.Parent
local CurrentCamera = workspace.CurrentCamera
local constants = require(StreamNotifications.constants)
local React = require(StreamNotificationsParent.React)
local ReactRoblox = require(StreamNotificationsParent.ReactRoblox)
local useStyle = require(StreamNotificationsParent.UIBlox).Core.Style.useStyle
local FocusNavigationUtils = require(StreamNotificationsParent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

require(StreamNotificationsParent.ReactFocusNavigation)

local InputHandlers = require(StreamNotificationsParent.InputHandlers)
local components = StreamNotifications.components
local StreamNotificationsHeader = require(components.StreamNotificationsHeader)
local StreamNotificationsContent = require(components.StreamNotificationsContent)
local EventStream = require(StreamNotifications.analytics.analyticsService).EventStream
local NotificationHelper = require(StreamNotificationsParent.NotificationsCommon).NotificationHelper
local analyticsConstants = require(StreamNotifications.analytics.analyticsConstants)
local FFlagLuaAppSupportDeviceSafeInsets = require(StreamNotificationsParent.SharedFlags).FFlagLuaAppSupportDeviceSafeInsets
local StreamNotificationDropdownExperimentation = require(StreamNotifications.StreamNotificationDropdownExperimentation)

local function calculateDropdownHeight(n1: number) -- line: 36
	-- upvalues: constants (copy)
	return (math.min(constants.Dropdown.MaxHeight, (math.max(n1 - constants.Dropdown.VerticalMargin, constants.Dropdown.MinHeight))))
end

return function(t1: {[any]: any}) -- line: 43
	-- upvalues: useStyle (copy), StreamNotificationDropdownExperimentation (copy), React (copy), CurrentCamera (copy), constants (copy), InputHandlers (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy), StreamNotificationsHeader (copy), StreamNotificationsContent (copy), ReactRoblox (copy), FFlagLuaAppSupportDeviceSafeInsets (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), FocusNavigationEventNameEnum (copy), CoreGui (copy)
	local v25 = useStyle()
	local v26 = StreamNotificationDropdownExperimentation.getDropdownEnabled()
	local useState = React.useState
	local v29

	if v26 then
		local ViewportSizeY = CurrentCamera.ViewportSize.Y

		v29 = math.min(constants.Dropdown.MaxHeight, (math.max(ViewportSizeY - constants.Dropdown.VerticalMargin, constants.Dropdown.MinHeight)))
	else
		v29 = 0
	end

	local v30, v31 = useState(v29)
	local v32, v33 = React.useState(CurrentCamera.ViewportSize.X < constants.Modal.WidthLimit)

	React.useEffect(function() -- line: 56
		-- upvalues: v26 (copy), v31 (copy), CurrentCamera (copy), constants (copy), v33 (copy)
		if v26 then
			local v42 = v31
			local ViewportSizeY = CurrentCamera.ViewportSize.Y

			v42((math.min(constants.Dropdown.MaxHeight, (math.max(ViewportSizeY - constants.Dropdown.VerticalMargin, constants.Dropdown.MinHeight)))))
		end

		local connection = CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function() -- line: 60
			-- upvalues: v26 (copy), v31 (copy), CurrentCamera (copy), constants (copy), v33 (copy)
			if v26 then
				local v46 = v31
				local ViewportSizeY = CurrentCamera.ViewportSize.Y

				v46((math.min(constants.Dropdown.MaxHeight, (math.max(ViewportSizeY - constants.Dropdown.VerticalMargin, constants.Dropdown.MinHeight)))))
			end

			if CurrentCamera.ViewportSize.X < constants.Modal.WidthLimit then
				v33(true)

				return
			end

			v33(false)
		end)

		return function() -- line: 70
			-- upvalues: connection (copy)
			connection:Disconnect()
		end
	end, { v26 })

	local v34, v35 = React.useState(true)
	local v36 = React.useCallback(function(p1) -- line: 76
		-- upvalues: v35 (copy)
		v35(p1)
	end)
	local v37, v38 = React.useState(true)
	local v39 = React.useRef(nil)
	local v40 = React.useMemo(function() -- line: 83
		-- upvalues: InputHandlers (copy), t1 (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy)
		return InputHandlers.onRelease(function(p2) -- line: 84
			-- upvalues: t1 (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy)
			t1.displayStream(false)
			NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.click, analyticsConstants.EventNames.closeContent, {
				closeMethod = analyticsConstants.CloseMethod.focusNavigationBack
			})
			p2:cancel()
		end)
	end, { t1.displayStream })

	if v26 then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ClipsDescendants = true,
			Size = UDim2.new(0, constants.Dropdown.Width, 0, v30)
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, constants.Dropdown.PaddingTop),
				PaddingBottom = UDim.new(0, constants.Dropdown.PaddingBottom),
				PaddingLeft = UDim.new(0, constants.Dropdown.HorizontalPadding),
				PaddingRight = UDim.new(0, constants.Dropdown.HorizontalPadding - constants.Dropdown.ScrollBarThickness)
			}),
			UIListLayout = React.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, constants.Dropdown.HeaderBodyGap)
			}),
			Header = React.createElement(StreamNotificationsHeader, {
				isSmallScreen = false,
				displayStream = t1.displayStream
			}),
			StreamNotificationsContent = React.createElement(StreamNotificationsContent, {
				isSmallScreen = false,
				showOverlay = function() -- line: 126
				end,
				displayStream = t1.displayStream,
				setDisplayScreenGuiEnabled = function() -- line: 129
				end,
				dropdownHeight = v30
			})
		})
	end

	local t2 = {
		TextButtonOverlayBackground = React.createElement("TextButton", {
			ref = v39,
			Selectable = false,
			Size = UDim2.new(1, 0, 1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = not v34 and 1 or v25.Theme.Overlay.Transparency,
			BackgroundColor3 = v25.Theme.Overlay.Color,
			AutoButtonColor = false,
			BorderSizePixel = 0,
			Text = "",
			[React.Event.Activated] = function() -- line: 147
				-- upvalues: t1 (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy)
				t1.displayStream(false)
				NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.click, analyticsConstants.EventNames.closeContent, {
					closeMethod = analyticsConstants.CloseMethod.backgroundOverlay
				})
			end
		}, {
			StreamNotificationsFrame = React.createElement("TextButton", {
				AutoButtonColor = false,
				BorderSizePixel = 0,
				Text = "",
				Selectable = false,
				Size = if not v32 then UDim2.new(0, constants.Modal.Width, 0, constants.Modal.Height) else UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundColor3 = v25.Theme.BackgroundDefault.Color,
				BackgroundTransparency = v25.Theme.BackgroundDefault.Transparency
			}, {
				UICorner = React.createElement("UICorner", {
					CornerRadius = if v32 then UDim.new(0, 0) else UDim.new(0, constants.Modal.CornerRadius)
				}),
				Header = React.createElement(StreamNotificationsHeader, {
					isSmallScreen = v32,
					displayStream = t1.displayStream
				}),
				StreamNotificationsContent = React.createElement(StreamNotificationsContent, {
					showOverlay = v36,
					isSmallScreen = v32,
					displayStream = t1.displayStream,
					setDisplayScreenGuiEnabled = v38
				})
			})
		})
	}

	return ReactRoblox.createPortal({
		ScreenGui = React.createElement("ScreenGui", {
			DisplayOrder = 10,
			IgnoreGuiInset = true,
			Enabled = v37,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
			ScreenInsets = if not FFlagLuaAppSupportDeviceSafeInsets then nil else Enum.ScreenInsets.None
		}, { React.createElement(FocusNavigableSurfaceWrapper, {
			isIsolated = true,
			surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.PopUp,
			frameProps = {
				ref = v39
			},
			customEventHandlers = {
				[FocusNavigationEventNameEnum.NavigateBack] = {
					handler = v40
				}
			}
		}, t2) })
	}, CoreGui)
end
