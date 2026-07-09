local Parent = script:FindFirstAncestor("VerifiedParentalConsentDialog").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local function AlertPrompt(t1: {[any]: any}) -- line: 21
	-- upvalues: useLocalization (copy), React (copy), InteractiveAlert (copy), ButtonType (copy)
	local v9 = useLocalization({
		GoToSettings = "Common.VerifiedParentalConsent.Action.GoToSettings",
		Cancel = "Common.VerifiedParentalConsent.Action.Cancel",
		Close = "Common.VerifiedParentalConsent.Action.Close"
	})

	return React.createElement(InteractiveAlert, {
		title = t1.title,
		titleIcon = t1.titleIcon,
		bodyText = t1.bodyText,
		buttonStackInfo = {
			buttons = (function() -- line: 33
				-- upvalues: t1 (copy), ButtonType (copy), v9 (copy)
				if t1.isActionable then
					return {
						{
							buttonType = ButtonType.PrimarySystem,
							props = {
								onActivated = if not t1.onAction then t1.onDismiss else t1.onAction,
								text = v9.GoToSettings
							}
						},
						{
							props = {
								onActivated = t1.onDismiss,
								text = v9.Cancel
							}
						}
					}
				end

				return {{
					props = {
						onActivated = t1.onDismiss,
						text = v9.Close
					}
				}}
			end)()
		},
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = t1.screenSize,
		middleContent = t1.middleContent
	})
end

return AlertPrompt
