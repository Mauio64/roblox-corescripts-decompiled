local module = require("@luauforge/bundled/hNw")
local module2 = require("@luauforge/bundled/hNF")

local module3 = require("@luauforge/bundled/hNA")

local useLocalization = require("@luauforge/bundled/hNC").Hooks.useLocalization
local useDesignTokens = require("@luauforge/bundled/hND").useDesignTokens

local interactiveAlert = module3.App.Dialog.Alert.InteractiveAlert
local buttonType = module3.App.Button.Enum.ButtonType

return function(p2)
	local v5 = useLocalization({
		passkeyErrorTitle = "Authentication.SignUp.Header.PleaseTryAgain",
		passkeyErrorDescription = "Authentication.SignUp.Description.PasskeyTryAgain",
		passkeyErrorButtonText = "Authentication.SignUp.Action.StartOver"
	})

	local v6 = useDesignTokens()

	return module.createElement(
		module2.View,
		{
			tag = "auto-y size-full-0 anchor-center-center position-center-center gui-object-defaults",
			ZIndex = 10
		},
		{ module.createElement(interactiveAlert, {
				title = v5.passkeyErrorTitle,
				bodyText = v5.passkeyErrorDescription,
				buttonStackInfo = {
					buttons = {
						{
							buttonType = buttonType.PrimaryContextual,
							props = {
								onActivated = p2.onActivated,
								text = v5.passkeyErrorButtonText
							}
						}
					},
					buttonHeight = v6.Size.Size_1200
				},
				position = UDim2.fromScale(0.5, 0.5),
				screenSize = Vector2.new(400, nil)
			}) }
	)
end
