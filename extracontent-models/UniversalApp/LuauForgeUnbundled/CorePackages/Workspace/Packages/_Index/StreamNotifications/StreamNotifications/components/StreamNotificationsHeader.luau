local constants = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/constants")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Localization").Hooks.useLocalization

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/RoactUtils").Hooks.RoactRodux.useDispatch
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Foundation")
local useStyle = UIBlox.Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local iconButton = UIBlox.App.Button.IconButton
local iconSize = UIBlox.App.ImageSet.Enum.IconSize
local UserInputService = game:GetService("UserInputService")

local eventStream = require("@game/CorePackages/Workspace/Packages/_Workspace/ToastNotification/ToastNotification/analytics/analyticsService").EventStream
local notificationHelper = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/NotificationsCommon").NotificationHelper
local analyticsConstants = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/analytics/analyticsConstants")

local StreamNotificationDropdownExperimentation = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/StreamNotificationDropdownExperimentation")
local StreamNotificationSettingsExperimentation = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/StreamNotificationSettingsExperimentation")
local StreamNotificationSettingsActivation = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/StreamNotificationSettingsActivation")
local fFlagStreamNotificationUXSettingsHeader = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/SharedFlags").FFlagStreamNotificationUXSettingsHeader

local function getSettingsButtonSize(p2, p3)
	return p2 - p3 * 2
end

return function(p2)
	local v5 = useStyle()
	local v6 = useTokens()
	local fontFace = normalizeFontFace(v6.Typography.HeadingSmall.Font)
	local fontSize = v6.Typography.HeadingSmall.FontSize
	local v7 = not (UserInputService.StatusBarSize and p2.isSmallScreen) and 0
		or UserInputService.StatusBarSize.Y

	local v8 = useLocalization({ headerText = constants.Text.HeaderKey })

	local dropdownEnabled = StreamNotificationDropdownExperimentation.getDropdownEnabled()
	local v9, onActivated

	if fFlagStreamNotificationUXSettingsHeader then
		local v10 = useDispatch()
		v9 = StreamNotificationSettingsExperimentation.getSettingsGearEnabled()
		onActivated = StreamNotificationSettingsActivation.createOnSettingsActivated(v9, dropdownEnabled, p2.displayStream, v10)
	else
		v9 = false

		onActivated = function() end
	end

	if dropdownEnabled then
		local headerMinHeight = constants.Dropdown.HeaderMinHeight
		local v10 = headerMinHeight - constants.DefaultPadding * 2

		local createElement = React.createElement
		local v12 = {
			Size = UDim2.new(1, 0, 0, headerMinHeight),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}

		local v13 = {
			HeaderText = React.createElement("TextLabel", {
				Text = v8 and v8.headerText,
				FontFace = fontFace,
				TextSize = fontSize,
				TextColor3 = v5.Theme.TextEmphasis.Color,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				Size = UDim2.new(1, -(not v9 and 0 or v10), 1, 0),
				BackgroundTransparency = 1
			}),
			SettingsButton = 0
		}

		local v14 = if fFlagStreamNotificationUXSettingsHeader and v9 then React.createElement(iconButton, {
			anchorPoint = Vector2.new(1, 0.5),
			iconSize = iconSize.Medium,
			icon = constants.Modal.SettingsIcon,
			position = UDim2.new(1, 0, 0.5, 0),
			size = UDim2.fromOffset(v10, v10),
			onActivated = onActivated
		}) else nil
		v13.SettingsButton = v14
		return createElement("Frame", v12, v13)
	else
		local createElement = React.createElement
		local v11 = {
			Size = UDim2.new(1, 0, 0, constants.Modal.HeaderHeight + v7),
			BackgroundTransparency = 1
		}

		local createElement2 = React.createElement
		local v14 = {
			Size = UDim2.new(1, 0, 0, constants.Modal.HeaderHeight),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1)
		}

		local createElement3 = React.createElement
		local v16 = {
			anchorPoint = Vector2.new(0, 0),
			iconSize = iconSize.Medium,
			icon = 0,
			layoutOrder = 1,
			size = 0,
			position = 0,
			onActivated = 0
		}
		local v17 = if p2.isSmallScreen then constants.Modal.BackIcon else constants.Modal.CloseIcon
		v16.icon = v17
		v16.size = UDim2.new(
			0,
			constants.Modal.HeaderHeight - constants.Modal.Padding * 2,
			0,
			constants.Modal.HeaderHeight - constants.Modal.Padding * 2
		)

		v16.position = UDim2.fromOffset(constants.Modal.Padding, constants.Modal.Padding)
		function v16.onActivated()
			p2.displayStream(false)
			notificationHelper.fireEvent(
				eventStream,
				analyticsConstants.Context.click,
				analyticsConstants.EventNames.closeContent,
				{ closeMethod = analyticsConstants.CloseMethod.closeIcon }
			)
		end

		local children = {
			CloseModal = createElement3(iconButton, v16),
			HeaderText = React.createElement("TextLabel", {
				Text = v8 and v8.headerText,
				FontFace = fontFace,
				TextSize = fontSize,
				TextColor3 = v5.Theme.TextEmphasis.Color,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(1, 0, 0, constants.Modal.HeaderHeight),
				BackgroundTransparency = 1
			}),
			SettingsButton = 0
		}
		local v18 = if fFlagStreamNotificationUXSettingsHeader and v9 then React.createElement(iconButton, {
			anchorPoint = Vector2.new(1, 0),
			iconSize = iconSize.Medium,
			icon = constants.Modal.SettingsIcon,
			position = UDim2.new(1, -constants.Modal.Padding, 0, constants.Modal.Padding),
			size = UDim2.fromOffset(
				constants.Modal.HeaderHeight - constants.Modal.Padding * 2,
				constants.Modal.HeaderHeight - constants.Modal.Padding * 2
			),
			onActivated = onActivated
		}) else nil
		children.SettingsButton = v18
		return createElement("Frame", v11, {
			HeaderFrame = createElement2("Frame", v14, children)
		})
	end
end
