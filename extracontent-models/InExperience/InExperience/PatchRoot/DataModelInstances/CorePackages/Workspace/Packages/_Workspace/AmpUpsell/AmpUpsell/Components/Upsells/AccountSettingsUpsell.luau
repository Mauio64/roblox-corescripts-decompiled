local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local parent = AmpUpsell.Parent
local UIBlox = require(parent.UIBlox)
local React = require(parent.React)
local RoactRodux = require(parent.RoactRodux)
local Localization = require(parent.Localization)
local useLocalization = Localization.Hooks.useLocalization
local AnalyticsService = require(AmpUpsell.Analytics.AnalyticsService)
local sendButtonClickEvent = require(AmpUpsell.Analytics.sendButtonClickEvent)
local AppScreens = require(AmpUpsell.Common.AppScreens)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle

function AccountSettingsUpsell(props)
	local onCloseModal = props.onCloseModal
	local onCloseModal2 = props.onCloseModal
	local localizationStrings = props.localizationStrings
	local featureName = props.featureName
	local v = useLocalization(localizationStrings)
	local v2 = useStyle()
	local v3

	if props.analyticsService then
		v3 = props.analyticsService
	else
		v3 = AnalyticsService.EventStream
	end

	local element = React.createElement(PartialPageModal, {
		title = v.title,
		screenSize = props.screenSize,
		onCloseClicked = function()
			sendButtonClickEvent(v3, AppScreens.AccountSettingsUpsell, featureName, "CloseModal")
			onCloseModal()
		end,
		buttonStackProps = {
			forcedFillDirection = Enum.FillDirection.Horizontal,
			buttonHeight = 48,
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = {
						isDisabled = false,
						onActivated = function()
							sendButtonClickEvent(v3, AppScreens.AccountSettingsUpsell, featureName, "Cancelled")

							onCloseModal2()
						end,
						text = v.buttonCancel
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						isDisabled = false,
						onActivated = function()
							sendButtonClickEvent(
								v3,
								AppScreens.AccountSettingsUpsell,
								featureName,
								"OpenAccountSettings"
							)

							props.openAccountSettings(v.buttonSettings)
						end,
						text = v.buttonSettings
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
				Text = React.createElement(StyledTextLabel, {
					fontStyle = v2.Font.Body,
					colorStyle = v2.Theme.TextEmphasis,
					size = UDim2.new(1, 0, 0, 0),
					fluidSizing = false,
					textXAlignment = Enum.TextXAlignment.Left,
					textYAlignment = Enum.TextYAlignment.Center,
					automaticSize = Enum.AutomaticSize.Y,
					text = v.message
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
			{ Size = UDim2.new(1, 0, 1, 0), BorderSizePixel = 0, BackgroundTransparency = 1 },
			{ Content = element }
		)
	})
end

AccountSettingsUpsell = RoactRodux.connect(function(p, _)
	return { screenSize = p.ScreenSize }
end)(AccountSettingsUpsell)

return AccountSettingsUpsell
