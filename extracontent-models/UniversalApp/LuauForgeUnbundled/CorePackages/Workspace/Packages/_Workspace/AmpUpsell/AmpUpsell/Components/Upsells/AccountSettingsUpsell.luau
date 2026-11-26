local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/UIBlox")
local React = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/React")
local RoactRodux = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/RoactRodux")
local useLocalization = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/Localization").Hooks.useLocalization
local AnalyticsService = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Analytics/AnalyticsService")
local sendButtonClickEvent = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Analytics/sendButtonClickEvent")
local AppScreens = require("@game/CorePackages/Workspace/Packages/_Workspace/AmpUpsell/AmpUpsell/Common/AppScreens")
local partialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local styledTextLabel = UIBlox.App.Text.StyledTextLabel
local buttonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle

function LUAUFORGE_MODULE_GLOBALS_bwd_AccountSettingsUpsell(props)
	local onCloseModal = props.onCloseModal
	local onCloseModal2 = props.onCloseModal
	local localizationStrings = props.localizationStrings
	local featureName = props.featureName
	local v5 = useLocalization(localizationStrings)
	local v6 = useStyle()
	local v7 = if props.analyticsService then props.analyticsService else AnalyticsService.EventStream

	local element = React.createElement(partialPageModal, {
		title = v5.title,
		screenSize = props.screenSize,
		onCloseClicked = function()
			sendButtonClickEvent(v7, AppScreens.AccountSettingsUpsell, featureName, "CloseModal")
			onCloseModal()
		end,
		buttonStackProps = {
			forcedFillDirection = Enum.FillDirection.Horizontal,
			buttonHeight = 48,
			buttons = {
				{
					buttonType = buttonType.Secondary,
					props = {
						isDisabled = false,
						onActivated = function()
							sendButtonClickEvent(v7, AppScreens.AccountSettingsUpsell, featureName, "Cancelled")

							onCloseModal2()
						end,
						text = v5.buttonCancel
					}
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = {
						isDisabled = false,
						onActivated = function()
							sendButtonClickEvent(v7, AppScreens.AccountSettingsUpsell, featureName, "OpenAccountSettings")

							props.openAccountSettings(v5.buttonSettings)
						end,
						text = v5.buttonSettings
					}
				}
			}
		}
	}, {
		ViewFrame = React.createElement(
			"Frame",
			{ AutomaticSize = Enum.AutomaticSize.XY, BackgroundTransparency = 1 },
			{
				UIPadding = React.createElement("UIPadding", {
					PaddingTop = UDim.new(0, 24),
					PaddingBottom = UDim.new(0, 24)
				}),
				Text = React.createElement(styledTextLabel, {
					fontStyle = v6.Font.Body,
					colorStyle = v6.Theme.TextEmphasis,
					size = UDim2.new(1, 0, 0, 0),
					fluidSizing = false,
					textXAlignment = Enum.TextXAlignment.Left,
					textYAlignment = Enum.TextYAlignment.Center,
					automaticSize = Enum.AutomaticSize.Y,
					text = v5.message
				})
			}
		)
	})

	return React.createElement("ImageButton", {
		AutoButtonColor = false,
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 1,
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0
	}, {
		Overlay = React.createElement(
			"Frame",
			{
				Size = UDim2.new(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundTransparency = 1
			},
			{ Content = element }
		)
	})
end

LUAUFORGE_MODULE_GLOBALS_bwd_AccountSettingsUpsell = RoactRodux.connect(function(p2, p3)
	return { screenSize = p2.ScreenSize }
end)(LUAUFORGE_MODULE_GLOBALS_bwd_AccountSettingsUpsell)

return LUAUFORGE_MODULE_GLOBALS_bwd_AccountSettingsUpsell
