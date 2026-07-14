local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local StreamNotificationsParent = StreamNotifications.Parent
local constants = require(StreamNotifications.constants)
local useLocalization = require(StreamNotificationsParent.Localization).Hooks.useLocalization
local React = require(StreamNotificationsParent.React)
local useDispatch = require(StreamNotificationsParent.RoactUtils).Hooks.RoactRodux.useDispatch
local UIBlox = require(StreamNotificationsParent.UIBlox)
local useStyle = UIBlox.Core.Style.useStyle
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local UserInputService = game:GetService("UserInputService")
local EventStream = require(StreamNotifications.analytics.analyticsService).EventStream
local NotificationHelper = require(StreamNotificationsParent.NotificationsCommon).NotificationHelper
local analyticsConstants = require(StreamNotifications.analytics.analyticsConstants)
local StreamNotificationDropdownExperimentation = require(StreamNotifications.StreamNotificationDropdownExperimentation)
local StreamNotificationSettingsExperimentation = require(StreamNotifications.StreamNotificationSettingsExperimentation)
local StreamNotificationSettingsActivation = require(StreamNotifications.StreamNotificationSettingsActivation)
local FFlagStreamNotificationUXSettingsHeader = require(StreamNotificationsParent.SharedFlags).FFlagStreamNotificationUXSettingsHeader

local function getSettingsButtonSize(n1: number, n2: number) -- line: 30
	return n1 - n2 * 2
end

return function(t1: {[any]: any}) -- line: 34
	-- upvalues: useStyle (copy), UserInputService (copy), useLocalization (copy), constants (copy), StreamNotificationDropdownExperimentation (copy), FFlagStreamNotificationUXSettingsHeader (copy), useDispatch (copy), StreamNotificationSettingsExperimentation (copy), StreamNotificationSettingsActivation (copy), React (copy), IconButton (copy), IconSize (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy)
	local v23 = useStyle()
	local Font = v23.Font
	local Header1Font = Font.Header1.Font
	local v26 = Font.BaseSize * Font.Header1.RelativeSize
	local v27 = (not UserInputService.StatusBarSize or not t1.isSmallScreen) and 0 or UserInputService.StatusBarSize.Y
	local v28 = useLocalization({
		headerText = constants.Text.HeaderKey
	})
	local v29 = StreamNotificationDropdownExperimentation.getDropdownEnabled()
	local v30 = false

	local function v31() -- line: 51
	end

	if FFlagStreamNotificationUXSettingsHeader then
		local v32 = useDispatch()

		v30 = StreamNotificationSettingsExperimentation.getSettingsGearEnabled()
		v31 = StreamNotificationSettingsActivation.createOnSettingsActivated(v30, v29, t1.displayStream, v32)
	end

	if v29 then
		local HeaderMinHeight = constants.Dropdown.HeaderMinHeight
		local v34 = HeaderMinHeight - constants.DefaultPadding * 2
		local v35 = not v30 and 0 or v34

		return React.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Size = UDim2.new(1, 0, 0, HeaderMinHeight)
		}, {
			HeaderText = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Text = v28 and v28.headerText,
				Font = Header1Font,
				TextSize = v26,
				TextColor3 = v23.Theme.TextEmphasis.Color,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				Size = UDim2.new(1, -v35, 1, 0)
			}),
			SettingsButton = if not FFlagStreamNotificationUXSettingsHeader or not v30 then nil else React.createElement(IconButton, {
				anchorPoint = Vector2.new(1, 0.5),
				iconSize = IconSize.Medium,
				icon = constants.Modal.SettingsIcon,
				position = UDim2.new(1, 0, 0.5, 0),
				size = UDim2.fromOffset(v34, v34),
				onActivated = v31
			})
		})
	end

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, constants.Modal.HeaderHeight + v27)
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
				onActivated = function() -- line: 121
					-- upvalues: t1 (copy), NotificationHelper (copy), EventStream (copy), analyticsConstants (copy)
					t1.displayStream(false)
					NotificationHelper.fireEvent(EventStream, analyticsConstants.Context.click, analyticsConstants.EventNames.closeContent, {
						closeMethod = analyticsConstants.CloseMethod.closeIcon
					})
				end
			}),
			HeaderText = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				Text = v28 and v28.headerText,
				Font = Header1Font,
				TextSize = v26,
				TextColor3 = v23.Theme.TextEmphasis.Color,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(1, 0, 0, constants.Modal.HeaderHeight)
			}),
			SettingsButton = if not FFlagStreamNotificationUXSettingsHeader or not v30 then nil else React.createElement(IconButton, {
				anchorPoint = Vector2.new(1, 0),
				iconSize = IconSize.Medium,
				icon = constants.Modal.SettingsIcon,
				position = UDim2.new(1, -constants.Modal.Padding, 0, constants.Modal.Padding),
				size = UDim2.fromOffset(constants.Modal.HeaderHeight - constants.Modal.Padding * 2, constants.Modal.HeaderHeight - constants.Modal.Padding * 2),
				onActivated = v31
			})
		})
	})
end
