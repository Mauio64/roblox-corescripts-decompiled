local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local StreamNotificationsParent = StreamNotifications.Parent
local constants = require(StreamNotifications.constants)
local React = require(StreamNotificationsParent.React)
local NotificationsCommon = require(StreamNotificationsParent.NotificationsCommon)
local NotificationCardProvider = NotificationsCommon.NotificationCardProvider
local NotificationCard = NotificationsCommon.NotificationCard
local NotificationHelper = NotificationsCommon.NotificationHelper
local constants2 = NotificationsCommon.constants
local FocusNavigationUtils = require(StreamNotificationsParent.FocusNavigationUtils)
local FocusNavigableSurfaceWrapper = FocusNavigationUtils.FocusNavigableSurfaceWrapper
local FocusNavigableSurfaceIdentifierEnum = FocusNavigationUtils.FocusNavigableSurfaceIdentifierEnum
local FocusNavigationEventNameEnum = FocusNavigationUtils.FocusNavigationEventNameEnum

require(StreamNotificationsParent.ReactFocusNavigation)

local InputHandlers = require(StreamNotificationsParent.InputHandlers)
local marshalStreamNotificationData = NotificationHelper.marshalStreamNotificationData
local EnumStreamNotificationsDisplayState = require(StreamNotifications.EnumStreamNotificationsDisplayState)
local UIBlox = require(StreamNotificationsParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local BaseMenu = UIBlox.App.Menu.BaseMenu
local ImageSetLabel = UIBlox.Core.ImageSet.ImageSetLabel

return function(t1: {[any]: any}) -- line: 35
	-- upvalues: useStyle (copy), React (copy), EnumStreamNotificationsDisplayState (copy), marshalStreamNotificationData (copy), constants (copy), NotificationCardProvider (copy), NotificationCard (copy), constants2 (copy), ImageSetLabel (copy), IconButton (copy), IconSize (copy), BaseMenu (copy), FocusNavigableSurfaceWrapper (copy), FocusNavigableSurfaceIdentifierEnum (copy), FocusNavigationEventNameEnum (copy), InputHandlers (copy)
	local v24 = useStyle()
	local activeNotification = t1.activeNotification
	local displayState = t1.displayState
	local isSmallScreen = t1.isSmallScreen
	local handleActions = t1.handleActions
	local closeNotificationDisplay = t1.closeNotificationDisplay
	local v30 = React.useRef(nil)

	if displayState ~= EnumStreamNotificationsDisplayState.MetaActions then
		return nil
	end

	local v31 = marshalStreamNotificationData(activeNotification)
	local t2 = {}

	if v31 then
		for _, v in ipairs(v31.state.visualItems.metaAction) do
			table.insert(t2, {
				icon = constants.MetaActions.ActionIcons[v.actionIcon] or constants.MetaActions.ActionIcons.default,
				text = v.label.text,
				onActivated = function() -- line: 57
					-- upvalues: handleActions (copy), v (copy), activeNotification (copy)
					if handleActions then
						handleActions(v, activeNotification)
					end
				end
			})
		end
	end

	local t3 = {
		UICorner = React.createElement("UICorner", {
			CornerRadius = if isSmallScreen then UDim.new(0, 0) else UDim.new(0, constants.Modal.CornerRadius)
		}),
		MetaActions = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ref = v30,
			AutomaticSize = Enum.AutomaticSize.Y,
			Size = UDim2.fromScale(1, 0),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5)
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
			CardAndClose = React.createElement("Frame", {
				BackgroundTransparency = 1,
				LayoutOrder = 1,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = UDim2.fromScale(1, 0)
			}, {
				ActiveCard = React.createElement(NotificationCardProvider, {
					isCompact = false,
					readOnly = false,
					openMetaActions = nil,
					notificationPayload = activeNotification,
					state = v31 and v31.state,
					handleActions = handleActions
				}, {
					NotificationCard = React.createElement(NotificationCard, {
						isHover = false,
						layoutOrder = 1
					})
				}),
				CloseButtonFrame = React.createElement("Frame", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = UDim2.fromOffset(constants.MetaActions.CloseButtonFrameSize, constants.MetaActions.CloseButtonFrameSize),
					AnchorPoint = Vector2.new(1, 0),
					Position = UDim2.new(1, -constants2.Padding.DefaultCardPadding, 0, constants2.Padding.DefaultCardPadding)
				}, {
					CloseIcon = React.createElement(ImageSetLabel, {
						LayoutOrder = 2,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.fromScale(0.5, 0.5),
						Size = UDim2.fromOffset(constants.MetaActions.CloseIconSize, constants.MetaActions.CloseIconSize),
						Image = constants.Modal.CloseIcon,
						ImageColor3 = v24.Theme.UIEmphasis.Color
					}),
					CloseButton = React.createElement(IconButton, {
						layoutOrder = 1,
						iconSize = IconSize.Small,
						size = UDim2.fromOffset(constants.MetaActions.CloseButtonSize, constants.MetaActions.CloseButtonSize),
						anchorPoint = Vector2.new(0.5, 0.5),
						position = UDim2.new(0.5, 0, 0.5, 0),
						onActivated = closeNotificationDisplay
					})
				})
			}),
			Menu = React.createElement(BaseMenu, {
				layoutOrder = 2,
				buttonProps = t2,
				width = UDim.new(1, 0)
			})
		})
	}

	return React.createElement(FocusNavigableSurfaceWrapper, {
		isIsolated = true,
		surfaceIdentifier = FocusNavigableSurfaceIdentifierEnum.ContextualMenu,
		frameProps = {
			ref = v30
		},
		customEventHandlers = {
			[FocusNavigationEventNameEnum.NavigateBack] = {
				handler = InputHandlers.onRelease(function(p1) -- line: 166
					-- upvalues: closeNotificationDisplay (copy)
					closeNotificationDisplay()
					p1:cancel()
				end)
			}
		}
	}, t3)
end
