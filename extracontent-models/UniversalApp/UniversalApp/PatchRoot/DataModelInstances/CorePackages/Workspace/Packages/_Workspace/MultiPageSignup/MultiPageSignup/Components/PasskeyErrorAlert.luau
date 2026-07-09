local Parent = script:FindFirstAncestor("MultiPageSignup").Parent
local React = require(Parent.React)
local Foundation = require(Parent.Foundation)
local UIBlox = require(Parent.UIBlox)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local useDesignTokens = require(Parent.Style).useDesignTokens
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType

return function(t1: {[any]: any}) -- line: 18
	-- upvalues: useLocalization (copy), useDesignTokens (copy), React (copy), Foundation (copy), InteractiveAlert (copy), ButtonType (copy)
	local v10 = useLocalization({
		passkeyErrorTitle = "Authentication.SignUp.Header.PleaseTryAgain",
		passkeyErrorDescription = "Authentication.SignUp.Description.PasskeyTryAgain",
		passkeyErrorButtonText = "Authentication.SignUp.Action.StartOver"
	})
	local v11 = useDesignTokens()

	return React.createElement(Foundation.View, {
		tag = "auto-y size-full-0 anchor-center-center position-center-center gui-object-defaults",
		ZIndex = 10
	}, { React.createElement(InteractiveAlert, {
		title = v10.passkeyErrorTitle,
		bodyText = v10.passkeyErrorDescription,
		buttonStackInfo = {
			buttons = {{
				buttonType = ButtonType.PrimaryContextual,
				props = {
					onActivated = t1.onActivated,
					text = v10.passkeyErrorButtonText
				}
			}},
			buttonHeight = v11.Size.Size_1200
		},
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = Vector2.new(400, nil)
	}) })
end
