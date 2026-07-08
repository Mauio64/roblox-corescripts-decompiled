local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local StreamNotificationsParent = StreamNotifications.Parent
local constants = require(StreamNotifications.constants)
local useLocalization = require(StreamNotificationsParent.Localization).Hooks.useLocalization
local React = require(StreamNotificationsParent.React)
local UIBlox = require(StreamNotificationsParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local UserInputService = game:GetService("UserInputService")
local EventStream = require(StreamNotifications.analytics.analyticsService).EventStream
local NotificationHelper = require(StreamNotificationsParent.NotificationsCommon).NotificationHelper
local analyticsConstants = require(StreamNotifications.analytics.analyticsConstants)
local StreamNotificationDropdownExperimentation = require(StreamNotifications.StreamNotificationDropdownExperimentation)

return function(t1: {[any]: any}) -- line: 25
	-- upvalues: useStyle (copy), UserInputService (copy), useLocalization (copy), constants (copy), StreamNotificationDropdownExperimentation (copy), React (copy), IconButton (copy), IconSize (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy)
	local v16 = useStyle()
	local Font = v16.Font
	local Header1Font = Font.Header1.Font
	local v19 = Font.BaseSize * Font.Header1.RelativeSize
	local v20 = (not UserInputService.StatusBarSize or not t1.isSmallScreen) and 0 or UserInputService.StatusBarSize.Y
	local v21 = useLocalization({
		headerText = constants.Text.HeaderKey
	})

	if StreamNotificationDropdownExperimentation.getDropdownEnabled() then
		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, constants.Dropdown.HeaderMinHeight)
		}, {
			HeaderText = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Text = v21 and v21.headerText,
				Font = Header1Font,
				TextSize = v19,
				TextColor3 = v16.Theme.TextEmphasis.Color,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				Size = UDim2.new(1, 0, 1, 0)
			})
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, constants.Modal.HeaderHeight + v20)
	}, {
		HeaderFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, constants.Modal.HeaderHeight),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1)
		}, {
			CloseModal = React.createElement(IconButton, {
				layoutOrder = 1,
				anchorPoint = Vector2.new(0, 0),
				iconSize = IconSize.Medium,
				icon = if not t1.isSmallScreen then constants.Modal.CloseIcon else constants.Modal.BackIcon,
				size = UDim2.new(0, constants.Modal.HeaderHeight - constants.Modal.Padding * 2, 0, constants.Modal.HeaderHeight - constants.Modal.Padding * 2),
				position = UDim2.fromOffset(constants.Modal.Padding, constants.Modal.Padding),
				onActivated = function() -- line: 81
					-- upvalues: t1 (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy)
					t1.displayStream(false)
					NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.click, analyticsConstants.EventNames.closeContent, {
						closeMethod = analyticsConstants.CloseMethod.closeIcon
					})
				end
			}),
			HeaderText = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Text = v21 and v21.headerText,
				Font = Header1Font,
				TextSize = v19,
				TextColor3 = v16.Theme.TextEmphasis.Color,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(1, 0, 0, constants.Modal.HeaderHeight)
			})
		})
	})
end
