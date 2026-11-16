local module = require("@luauforge/bundled/fEA")
local module2 = require("@luauforge/bundled/fEE")
local useLocalization = require("@luauforge/bundled/fEG").Hooks.useLocalization
local module3 = require("@luauforge/bundled/fEI")
local authModalShown = module3.Events.authModalShown
local eventStreamConstants = module3.EventStreamConstants

local interactiveAlert = module2.App.Dialog.Alert.InteractiveAlert
local buttonType = module2.App.Button.Enum.ButtonType
local useStyle = module2.Core.Style.useStyle
local useSelector = require("@luauforge/bundled/fEB").Hooks.RoactRodux.useSelector

return function(p2)
	local v5 = useLocalization({
		passkeyErrorTitle = "Authentication.Passkey.Label.UpsellErrorTitle",
		passkeyErrorDescription = "Authentication.Passkey.Description.Error",
		passkeyTryAgainLaterText = "Authentication.Passkey.Action.TryAgainLaterAcknowledgement",
		passkeyTryAgainNowText = "Authentication.Passkey.Action.TryAgainNowAcknowledgement"
	})

	local v6 = useStyle()

	local v7 = useSelector(function(p3)
		return p3.GlobalGuiInset.top
	end)

	local v8 = useSelector(function(p3)
		return p3.ScreenSize
	end)

	authModalShown(
		eventStreamConstants.Context.PasskeyUpsellErrorModalShown,
		eventStreamConstants.State.Success
	)
	return module.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, v8.Y - v7),
		BackgroundColor3 = v6.Theme.Overlay.Color,
		BackgroundTransparency = 0.5
	}, { module.createElement(interactiveAlert, {
			title = v5.passkeyErrorTitle,
			bodyText = v5.passkeyErrorDescription,
			buttonStackInfo = {
				buttons = {
					{
						props = {
							buttonType = buttonType.Secondary,
							onActivated = p2.onCancel,
							text = v5.passkeyTryAgainLaterText
						}
					},
					{
						buttonType = buttonType.PrimaryContextual,
						props = {
							onActivated = p2.onTryAgain,
							text = v5.passkeyTryAgainNowText
						}
					}
				},
				buttonHeight = 40
			},
			anchorPoint = Vector2.new(0.5, 0.5),
			position = UDim2.new(0.5, 0, 0.5, 0),
			screenSize = v8
		}) })
end
