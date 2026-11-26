local module = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/constants")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/React")
local NotificationsCommon = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/NotificationsCommon")
local notificationCardProvider = NotificationsCommon.NotificationCardProvider
local notificationCard = NotificationsCommon.NotificationCard
local notificationHelper = NotificationsCommon.NotificationHelper
local constants = NotificationsCommon.constants
local FocusNavigationUtils = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/FocusNavigationUtils")
local focusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local focusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local focusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum
require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/ReactFocusNavigation")
local InputHandlers = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/InputHandlers")

local marshalStreamNotificationData = notificationHelper.marshalStreamNotificationData
local EnumStreamNotificationsDisplayState = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/EnumStreamNotificationsDisplayState")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/UIBlox")
local useStyle = UIBlox.Core.Style.useStyle
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local baseMenu = UIBlox.App.Menu.BaseMenu
local imageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

return function(props)
	local v5 = useStyle()
	local activeNotification = props.activeNotification
	local displayState = props.displayState
	local isSmallScreen = props.isSmallScreen
	local handleActions = props.handleActions
	local closeNotificationDisplay = props.closeNotificationDisplay

	local ref = React.useRef(nil)

	if displayState ~= EnumStreamNotificationsDisplayState.MetaActions then
		return nil
	end

	local v6 = marshalStreamNotificationData(activeNotification)
	local v7 = {}

	if v6 then
		for i, v8 in ipairs(v6.state.visualItems.metaAction) do
			table.insert(v7, {
				icon = module.MetaActions.ActionIcons[v8.actionIcon] or module.MetaActions.ActionIcons.default,
				text = v8.label.text,
				onActivated = function()
					if handleActions then
						handleActions(v8, activeNotification)
					end
				end
			})
		end
	end

	local createElement = React.createElement
	local v10 = if isSmallScreen then UDim.new(0, 0) else UDim.new(0, module.Modal.CornerRadius)
	local children = {
		UICorner = createElement("UICorner", { CornerRadius = v10 }),
		MetaActions = React.createElement("Frame", {
			ref = ref,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, module.Modal.Padding),
				PaddingLeft = UDim.new(0, module.Modal.Padding),
				PaddingRight = UDim.new(0, module.Modal.Padding),
				PaddingBottom = UDim.new(0, module.Modal.Padding)
			}),
			React.createElement("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, module.DefaultPadding)
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
					ActiveCard = React.createElement(notificationCardProvider, {
						notificationPayload = activeNotification,
						state = v6 and v6.state,
						isCompact = false,
						readOnly = false,
						openMetaActions = nil,
						handleActions = handleActions
					}, {
						NotificationCard = React.createElement(notificationCard, {
							isHover = false,
							layoutOrder = 1
						})
					}),
					CloseButtonFrame = React.createElement("Frame", {
						Size = UDim2.fromOffset(
							module.MetaActions.CloseButtonFrameSize,
							module.MetaActions.CloseButtonFrameSize
						),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						AnchorPoint = Vector2.new(1, 0),
						Position = UDim2.new(
							1,
							-constants.Padding.DefaultCardPadding,
							0,
							constants.Padding.DefaultCardPadding
						)
					}, {
						CloseIcon = React.createElement(imageSetLabel, {
							LayoutOrder = 2,
							AnchorPoint = Vector2.new(0.5, 0.5),
							Position = UDim2.fromScale(0.5, 0.5),
							Size = UDim2.fromOffset(
								module.MetaActions.CloseIconSize,
								module.MetaActions.CloseIconSize
							),
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Image = module.Modal.CloseIcon,
							ImageColor3 = v5.Theme.UIEmphasis.Color
						}),
						CloseButton = React.createElement(iconButton, {
							iconSize = iconSize.Small,
							size = UDim2.fromOffset(
								module.MetaActions.CloseButtonSize,
								module.MetaActions.CloseButtonSize
							),
							layoutOrder = 1,
							anchorPoint = Vector2.new(0.5, 0.5),
							position = UDim2.new(0.5, 0, 0.5, 0),
							onActivated = closeNotificationDisplay
						})
					})
				}
			),
			Menu = React.createElement(baseMenu, {
				buttonProps = v7,
				width = UDim.new(1, 0),
				layoutOrder = 2
			})
		})
	}

	return React.createElement(focusNavigableSurfaceWrapper, {
		surfaceIdentifier = focusNavigableSurfaceIdentifierEnum.ContextualMenu,
		isIsolated = true,
		frameProps = { ref = ref },
		customEventHandlers = {
			[focusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(object)
					closeNotificationDisplay()
					object:cancel()
				end)
			}
		}
	}, children)
end
