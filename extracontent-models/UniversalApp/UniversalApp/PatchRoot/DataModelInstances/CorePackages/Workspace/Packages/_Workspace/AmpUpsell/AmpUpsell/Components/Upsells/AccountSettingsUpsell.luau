local AmpUpsell = script:FindFirstAncestor("AmpUpsell")
local AmpUpsellParent = AmpUpsell.Parent
local UIBlox = require(AmpUpsellParent.UIBlox)
local React = require(AmpUpsellParent.React)
local RoactRodux = require(AmpUpsellParent.RoactRodux)
local useLocalization = require(AmpUpsellParent.Localization).Hooks.useLocalization
local AnalyticsService = require(AmpUpsell.Analytics.AnalyticsService)
local sendButtonClickEvent = require(AmpUpsell.Analytics.sendButtonClickEvent)
local AppScreens = require(AmpUpsell.Common.AppScreens)
local PartialPageModal = UIBlox.App.Dialog.Modal.PartialPageModal
local StyledTextLabel = UIBlox.App.Text.StyledTextLabel
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle

function AccountSettingsUpsell(t1: {[any]: any}) -- line: 27
	-- upvalues: useLocalization (copy), useStyle (copy), AnalyticsService (copy), React (copy), PartialPageModal (copy), sendButtonClickEvent (copy), AppScreens (copy), ButtonType (copy), StyledTextLabel (copy)
	local onCloseModal = t1.onCloseModal
	local onCloseModal2 = t1.onCloseModal
	local localizationStrings = t1.localizationStrings
	local featureName = t1.featureName
	local v19 = useLocalization(localizationStrings)
	local v20 = useStyle()
	local v21 = if not t1.analyticsService then AnalyticsService.EventStream else t1.analyticsService
	local v22 = React.createElement(PartialPageModal, {
		title = v19.title,
		screenSize = t1.screenSize,
		onCloseClicked = function() -- line: 39
			-- upvalues: sendButtonClickEvent (copy), v21 (copy), AppScreens (copy), featureName (copy), onCloseModal (copy)
			sendButtonClickEvent(v21, AppScreens.AccountSettingsUpsell, featureName, "CloseModal")
			onCloseModal()
		end,
		buttonStackProps = {
			buttonHeight = 48,
			forcedFillDirection = Enum.FillDirection.Horizontal,
			buttons = {
				{
					buttonType = ButtonType.Secondary,
					props = {
						isDisabled = false,
						onActivated = function() -- line: 51
							-- upvalues: sendButtonClickEvent (copy), v21 (copy), AppScreens (copy), featureName (copy), onCloseModal2 (copy)
							sendButtonClickEvent(v21, AppScreens.AccountSettingsUpsell, featureName, "Cancelled")
							onCloseModal2()
						end,
						text = v19.buttonCancel
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						isDisabled = false,
						onActivated = function() -- line: 67
							-- upvalues: sendButtonClickEvent (copy), v21 (copy), AppScreens (copy), featureName (copy), t1 (copy), v19 (copy)
							sendButtonClickEvent(v21, AppScreens.AccountSettingsUpsell, featureName, "OpenAccountSettings")
							t1.openAccountSettings(v19.buttonSettings)
						end,
						text = v19.buttonSettings
					}
				}
			}
		}
	}, {
		ViewFrame = React.createElement("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = Enum.AutomaticSize.XY
		}, {
			UIPadding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 24),
				PaddingBottom = UDim.new(0, 24)
			}),
			Text = React.createElement(StyledTextLabel, {
				fluidSizing = false,
				fontStyle = v20.Font.Body,
				colorStyle = v20.Theme.TextEmphasis,
				size = UDim2.new(1, 0, 0, 0),
				textXAlignment = Enum.TextXAlignment.Left,
				textYAlignment = Enum.TextYAlignment.Center,
				automaticSize = Enum.AutomaticSize.Y,
				text = v19.message
			})
		})
	})

	return React.createElement("ImageButton", {
		AutoButtonColor = false,
		ImageTransparency = 1,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.new(0, 0, 0)
	}, {
		Overlay = React.createElement("Frame", {
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0)
		}, {
			Content = v22
		})
	})
end

AccountSettingsUpsell = RoactRodux.connect(function(p1, _) -- line: 121
	return {
		screenSize = p1.ScreenSize
	}
end)(AccountSettingsUpsell)

return AccountSettingsUpsell
