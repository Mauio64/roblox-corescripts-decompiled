local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local parent = StreamNotifications.Parent
local constants = require(StreamNotifications.constants)
local React = require(parent.React)
local NotificationsCommon = require(parent.NotificationsCommon)
local NotificationCardProvider = NotificationsCommon.NotificationCardProvider
local NotificationCard = NotificationsCommon.NotificationCard
local NotificationHelper = NotificationsCommon.NotificationHelper
local constants2 = NotificationsCommon.constants
local FocusNavigationUtils = require(parent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
require(parent.ReactFocusNavigation)
local InputHandlers = require(parent.InputHandlers)

local marshalStreamNotificationData = NotificationHelper.marshalStreamNotificationData
local EnumStreamNotificationsDisplayState = require(StreamNotifications.EnumStreamNotificationsDisplayState)

local UIBlox = require(parent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local BaseMenu = UIBlox.App.Menu.BaseMenu
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

return function(props)
	local v = useStyle()
	local activeNotification = props.activeNotification
	local displayState = props.displayState
	local isSmallScreen = props.isSmallScreen
	local handleActions = props.handleActions
	local closeNotificationDisplay = props.closeNotificationDisplay

	local ref = React.useRef(nil)

	if displayState ~= EnumStreamNotificationsDisplayState.MetaActions then
		return nil
	end

	local v2 = marshalStreamNotificationData(activeNotification)
	local buttonProps = {}

	if v2 then
		for _, v3 in ipairs(v2.state.visualItems.metaAction) do
			table.insert(buttonProps, {
				icon = constants.MetaActions.ActionIcons[v3.actionIcon] or constants.MetaActions.ActionIcons.default,
				text = v3.label.text,
				onActivated = function()
					if handleActions then
						handleActions(v3, activeNotification)
					end
				end
			})
		end
	end

	local createElement = React.createElement
	local cornerRadius

	if isSmallScreen then
		cornerRadius = UDim.new(0, 0)
	else
		cornerRadius = UDim.new(0, constants.Modal.CornerRadius)
	end

	local children = {
		UICorner = createElement("UICorner", { CornerRadius = cornerRadius }),
		MetaActions = React.createElement("Frame", {
			ref = ref,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, constants.Modal.Padding),
				PaddingLeft = UDim.new(0, constants.Modal.Padding),
				PaddingRight = UDim.new(0, constants.Modal.Padding),
				PaddingBottom = UDim.new(0, constants.Modal.Padding)
			}),
			React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, constants.DefaultPadding)
			}),
			CardAndClose = React.createElement(
				"Frame",
				{
					AutomaticSize = Enum.AutomaticSize.Y,
					Size = UDim2.fromScale(1, 0),
					BackgroundTransparency = 1,
					LayoutOrder = 1
				},
				{
					ActiveCard = React.createElement(NotificationCardProvider, {
						notificationPayload = activeNotification,
						state = v2 and v2.state,
						isCompact = false,
						readOnly = false,
						openMetaActions = nil,
						handleActions = handleActions
					}, {
						NotificationCard = React.createElement(NotificationCard, {
							isHover = false,
							layoutOrder = 1
						})
					}),
					CloseButtonFrame = React.createElement("Frame", {
						Size = UDim2.fromOffset(
							constants.MetaActions.CloseButtonFrameSize,
							constants.MetaActions.CloseButtonFrameSize
						),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						AnchorPoint = Vector2.new(1, 0),
						Position = UDim2.new(
							1,
							-constants2.Padding.DefaultCardPadding,
							0,
							constants2.Padding.DefaultCardPadding
						)
					}, {
						CloseIcon = React.createElement(ImageSetLabel, {
							LayoutOrder = 2,
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.fromScale(0.5, 0.5),
							Size = UDim2.fromOffset(
								constants.MetaActions.CloseIconSize,
								constants.MetaActions.CloseIconSize
							),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Image = constants.Modal.CloseIcon,
							ImageColor3 = v.Theme.UIEmphasis.Color
						}),
						CloseButton = React.createElement(IconButton, {
							iconSize = IconSize.Small,
							size = UDim2.fromOffset(
								constants.MetaActions.CloseButtonSize,
								constants.MetaActions.CloseButtonSize
							),
							layoutOrder = 1,
							anchorPoint = Vector2.new(0.5, 0.5),
							position = UDim2.new(0.5, 0, 0.5, 0),
							onActivated = closeNotificationDisplay
						})
					})
				}
			),
			Menu = React.createElement(BaseMenu, {
				buttonProps = buttonProps,
				width = UDim.new(1, 0),
				layoutOrder = 2
			})
		})
	}

	return React.createElement(FocusNavigableSurfaceWrapper, {
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ContextualMenu,
		isIsolated = true,
		frameProps = { ref = ref },
		customEventHandlers = {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					closeNotificationDisplay()
					object:cancel()
				end)
			}
		}
	}, children)
end
