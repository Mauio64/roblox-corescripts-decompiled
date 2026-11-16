local constants = require("@game/CorePackages/Workspace/Packages/_Index/StreamNotifications/StreamNotifications/constants")

local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Localization").Hooks.useLocalization

local React = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/React")
local useDispatch = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/RoactUtils").Hooks.RoactRodux.useDispatch
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/UIBlox")
local Foundation = require("@game/CorePackages/Workspace/Packages/_Workspace/StreamNotifications/Foundation")
local useStyle = UIBlox.Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local foundationFontFaceMigration = Foundation.Utility.Flags.FoundationFontFaceMigration
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
	local v6 = if foundationFontFaceMigration then useTokens() else nil
	local font = v5.Font
	local font2 = if not foundationFontFaceMigration then font.Header1.Font else nil
	local v7

	if foundationFontFaceMigration then
		v7 = normalizeFontFace(v6.Typography.HeadingSmall.Font)
	end

	local v8

	if foundationFontFaceMigration then
		v8 = v6.Typography.HeadingSmall.FontSize
	else
		v8 = font.BaseSize * font.Header1.RelativeSize
	end

	local v9 = not (UserInputService.StatusBarSize and p2.isSmallScreen) and 0
		or UserInputService.StatusBarSize.Y

	local v10 = useLocalization({ headerText = constants.Text.HeaderKey })

	local dropdownEnabled = StreamNotificationDropdownExperimentation.getDropdownEnabled()
	local v11, onActivated

	if fFlagStreamNotificationUXSettingsHeader then
		local v12 = useDispatch()
		v11 = StreamNotificationSettingsExperimentation.getSettingsGearEnabled()
		onActivated = StreamNotificationSettingsActivation.createOnSettingsActivated(v11, dropdownEnabled, p2.displayStream, v12)
	else
		v11 = false

		onActivated = function() end
	end

	if dropdownEnabled then
		local headerMinHeight = constants.Dropdown.HeaderMinHeight
		local v12 = headerMinHeight - constants.DefaultPadding * 2

		local createElement = React.createElement
		local v14 = {
			Size = UDim2.new(1, 0, 0, headerMinHeight),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}

		local v15 = {
			HeaderText = React.createElement("TextLabel", {
				Text = v10 and v10.headerText,
				Font = font2,
				FontFace = v7,
				TextSize = v8,
				TextColor3 = v5.Theme.TextEmphasis.Color,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				Size = UDim2.new(1, -(not v11 and 0 or v12), 1, 0),
				BackgroundTransparency = 1
			}),
			SettingsButton = 0
		}

		local v16 = if fFlagStreamNotificationUXSettingsHeader and v11 then React.createElement(iconButton, {
			anchorPoint = Vector2.new(1, 0.5),
			iconSize = iconSize.Medium,
			icon = constants.Modal.SettingsIcon,
			position = UDim2.new(1, 0, 0.5, 0),
			size = UDim2.fromOffset(v12, v12),
			onActivated = onActivated
		}) else nil
		v15.SettingsButton = v16
		return createElement("Frame", v14, v15)
	else
		local createElement = React.createElement
		local v13 = {
			Size = UDim2.new(1, 0, 0, constants.Modal.HeaderHeight + v9),
			BackgroundTransparency = 1
		}

		local createElement2 = React.createElement
		local v16 = {
			Size = UDim2.new(1, 0, 0, constants.Modal.HeaderHeight),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1)
		}

		local createElement3 = React.createElement
		local v18 = {
			anchorPoint = Vector2.new(0, 0),
			iconSize = iconSize.Medium,
			icon = 0,
			layoutOrder = 1,
			size = 0,
			position = 0,
			onActivated = 0
		}
		local v19 = if p2.isSmallScreen then constants.Modal.BackIcon else constants.Modal.CloseIcon
		v18.icon = v19
		v18.size = UDim2.new(
			0,
			constants.Modal.HeaderHeight - constants.Modal.Padding * 2,
			0,
			constants.Modal.HeaderHeight - constants.Modal.Padding * 2
		)

		v18.position = UDim2.fromOffset(constants.Modal.Padding, constants.Modal.Padding)
		function v18.onActivated()
			p2.displayStream(false)
			notificationHelper.fireEvent(
				eventStream,
				analyticsConstants.Context.click,
				analyticsConstants.EventNames.closeContent,
				{ closeMethod = analyticsConstants.CloseMethod.closeIcon }
			)
		end

		local children = {
			CloseModal = createElement3(iconButton, v18),
			HeaderText = React.createElement("TextLabel", {
				Text = v10 and v10.headerText,
				Font = font2,
				FontFace = v7,
				TextSize = v8,
				TextColor3 = v5.Theme.TextEmphasis.Color,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(1, 0, 0, constants.Modal.HeaderHeight),
				BackgroundTransparency = 1
			}),
			SettingsButton = 0
		}
		local v20 = if fFlagStreamNotificationUXSettingsHeader and v11 then React.createElement(iconButton, {
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
		children.SettingsButton = v20
		return createElement("Frame", v13, {
			HeaderFrame = createElement2("Frame", v16, children)
		})
	end
end
