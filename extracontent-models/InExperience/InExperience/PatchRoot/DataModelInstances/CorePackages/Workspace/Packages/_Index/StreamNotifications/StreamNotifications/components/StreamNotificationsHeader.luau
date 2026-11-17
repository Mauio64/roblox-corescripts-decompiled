local StreamNotifications = script:FindFirstAncestor("StreamNotifications")
local parent = StreamNotifications.Parent
local constants = require(StreamNotifications.constants)

local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization

local React = require(parent.React)
local RoactUtils = require(parent.RoactUtils)
local useDispatch = RoactUtils.Hooks.RoactRodux.useDispatch
local UIBlox = require(parent.UIBlox)
local Foundation = require(parent.Foundation)
local useStyle = UIBlox.Core.Style.useStyle
local useTokens = Foundation.Hooks.useTokens
local normalizeFontFace = Foundation.Utility.normalizeFontFace
local IconButton = UIBlox.App.Button.IconButton
local IconSize = UIBlox.App.ImageSet.Enum.IconSize
local UserInputService = game:GetService("UserInputService")

local analyticsService = require(StreamNotifications.analytics.analyticsService)
local eventStream = analyticsService.EventStream
local NotificationsCommon = require(parent.NotificationsCommon)
local NotificationHelper = NotificationsCommon.NotificationHelper
local analyticsConstants = require(StreamNotifications.analytics.analyticsConstants)

local StreamNotificationDropdownExperimentation = require(StreamNotifications.StreamNotificationDropdownExperimentation)
local StreamNotificationSettingsExperimentation = require(StreamNotifications.StreamNotificationSettingsExperimentation)
local StreamNotificationSettingsActivation = require(StreamNotifications.StreamNotificationSettingsActivation)
local SharedFlags = require(parent.SharedFlags)
local FFlagStreamNotificationUXSettingsHeader = SharedFlags.FFlagStreamNotificationUXSettingsHeader

local function getSettingsButtonSize(p: number, p2: number) -- 5 equivalent calls inferred from this helper
	return p - p2 * 2
end

return function(p)
	local v = useStyle()
	local v2 = useTokens()
	local fontFace = normalizeFontFace(v2.Typography.HeadingSmall.Font)
	local fontSize = v2.Typography.HeadingSmall.FontSize
	local v3 = not (UserInputService.StatusBarSize and p.isSmallScreen) and 0 or UserInputService.StatusBarSize.Y

	local v4 = useLocalization({ headerText = constants.Text.HeaderKey })

	local dropdownEnabled = StreamNotificationDropdownExperimentation.getDropdownEnabled()
	local v5, onActivated

	if FFlagStreamNotificationUXSettingsHeader then
		local v6 = useDispatch()
		v5 = StreamNotificationSettingsExperimentation.getSettingsGearEnabled()
		onActivated = StreamNotificationSettingsActivation.createOnSettingsActivated(
			v5,
			dropdownEnabled,
			p.displayStream,
			v6
		)
	else
		v5 = false

		onActivated = function() end
	end

	if dropdownEnabled then
		local headerMinHeight = constants.Dropdown.HeaderMinHeight
		local settingsButtonSize = getSettingsButtonSize(headerMinHeight, constants.DefaultPadding) -- inferred equivalent call

		local createElement = React.createElement
		local v6 = {
			Size = UDim2.new(1, 0, 0, headerMinHeight),
			BackgroundTransparency = 1,
			LayoutOrder = 1
		}

		local v7 = {
			HeaderText = React.createElement("TextLabel", {
				Text = v4 and v4.headerText,
				FontFace = fontFace,
				TextSize = fontSize,
				TextColor3 = v.Theme.TextEmphasis.Color,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				Size = UDim2.new(1, -(not v5 and 0 or settingsButtonSize), 1, 0),
				BackgroundTransparency = 1
			}),
			SettingsButton = 0
		}
		local settingsButton

		if FFlagStreamNotificationUXSettingsHeader and v5 then
			settingsButton = React.createElement(IconButton, {
				anchorPoint = Vector2.new(1, 0.5),
				iconSize = IconSize.Medium,
				icon = constants.Modal.SettingsIcon,
				position = UDim2.new(1, 0, 0.5, 0),
				size = UDim2.fromOffset(settingsButtonSize, settingsButtonSize),
				onActivated = onActivated
			})
		end

		v7.SettingsButton = settingsButton
		return createElement("Frame", v6, v7)
	else
		local createElement = React.createElement
		local v6 = {
			Size = UDim2.new(1, 0, 0, constants.Modal.HeaderHeight + v3),
			BackgroundTransparency = 1
		}

		local createElement2 = React.createElement
		local v7 = {
			Size = UDim2.new(1, 0, 0, constants.Modal.HeaderHeight),
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1)
		}

		local createElement3 = React.createElement
		local v8 = {
			anchorPoint = Vector2.new(0, 0),
			iconSize = IconSize.Medium,
			icon = 0,
			layoutOrder = 1,
			size = 0,
			position = 0,
			onActivated = 0
		}
		local icon

		if p.isSmallScreen then
			icon = constants.Modal.BackIcon
		else
			icon = constants.Modal.CloseIcon
		end

		v8.icon = icon

		v8.size = UDim2.new(
			0,
			getSettingsButtonSize(constants.Modal.HeaderHeight, constants.Modal.Padding), -- inferred equivalent call
			0,
			getSettingsButtonSize(constants.Modal.HeaderHeight, constants.Modal.Padding) -- inferred equivalent call
		)

		v8.position = UDim2.fromOffset(constants.Modal.Padding, constants.Modal.Padding)
		function v8.onActivated()
			p.displayStream(false)
			NotificationHelper.fireEvent(
				eventStream,
				analyticsConstants.Context.click,
				analyticsConstants.EventNames.closeContent,
				{ closeMethod = analyticsConstants.CloseMethod.closeIcon }
			)
		end

		local children = {
			CloseModal = createElement3(IconButton, v8),
			HeaderText = React.createElement("TextLabel", {
				Text = v4 and v4.headerText,
				FontFace = fontFace,
				TextSize = fontSize,
				TextColor3 = v.Theme.TextEmphasis.Color,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(1, 0, 0, constants.Modal.HeaderHeight),
				BackgroundTransparency = 1
			}),
			SettingsButton = 0
		}
		local settingsButton

		if FFlagStreamNotificationUXSettingsHeader and v5 then
			settingsButton = React.createElement(IconButton, {
				anchorPoint = Vector2.new(1, 0),
				iconSize = IconSize.Medium,
				icon = constants.Modal.SettingsIcon,
				position = UDim2.new(1, -constants.Modal.Padding, 0, constants.Modal.Padding),
				size = UDim2.fromOffset(
					getSettingsButtonSize(constants.Modal.HeaderHeight, constants.Modal.Padding), -- inferred equivalent call
					getSettingsButtonSize(constants.Modal.HeaderHeight, constants.Modal.Padding) -- inferred equivalent call
				),
				onActivated = onActivated
			})
		end

		children.SettingsButton = settingsButton
		return createElement("Frame", v6, {
			HeaderFrame = createElement2("Frame", v7, children)
		})
	end
end
