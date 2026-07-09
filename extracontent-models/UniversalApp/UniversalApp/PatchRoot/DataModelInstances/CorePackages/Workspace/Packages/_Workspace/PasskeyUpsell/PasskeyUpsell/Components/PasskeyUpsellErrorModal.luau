local Parent = script:FindFirstAncestor("PasskeyUpsell").Parent
local React = require(Parent.React)
local UIBlox = require(Parent.UIBlox)
local useLocalization = require(Parent.Localization).Hooks.useLocalization
local AuthAnalytics = require(Parent.AuthAnalytics)
local authModalShown = AuthAnalytics.Events.authModalShown
local EventStreamConstants = AuthAnalytics.EventStreamConstants
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local useStyle = UIBlox.Core.Style.useStyle
local useSelector = require(Parent.RoactUtils).Hooks.RoactRodux.useSelector

return function(t1: {[any]: any}) -- line: 26
	-- upvalues: useLocalization (copy), useStyle (copy), useSelector (copy), authModalShown (copy), EventStreamConstants (copy), React (copy), InteractiveAlert (copy), ButtonType (copy)
	local v13 = useLocalization({
		passkeyErrorTitle = "Authentication.Passkey.Label.UpsellErrorTitle",
		passkeyErrorDescription = "Authentication.Passkey.Description.Error",
		passkeyTryAgainLaterText = "Authentication.Passkey.Action.TryAgainLaterAcknowledgement",
		passkeyTryAgainNowText = "Authentication.Passkey.Action.TryAgainNowAcknowledgement"
	})
	local v14 = useStyle()
	local v15 = useSelector(function(p1) -- line: 35
		return p1.GlobalGuiInset.top
	end)
	local v16 = useSelector(function(p2) -- line: 39
		return p2.ScreenSize
	end)

	authModalShown(EventStreamConstants.Context.PasskeyUpsellErrorModalShown, EventStreamConstants.State.Success)

	return React.createElement("Frame", {
		BackgroundTransparency = 0.5,
		Size = UDim2.new(1, 0, 0, v16.Y - v15),
		BackgroundColor3 = v14.Theme.Overlay.Color
	}, { React.createElement(InteractiveAlert, {
		title = v13.passkeyErrorTitle,
		bodyText = v13.passkeyErrorDescription,
		buttonStackInfo = {
			buttonHeight = 40,
			buttons = {
				{
					props = {
						buttonType = ButtonType.Secondary,
						onActivated = t1.onCancel,
						text = v13.passkeyTryAgainLaterText
					}
				},
				{
					buttonType = ButtonType.PrimaryContextual,
					props = {
						onActivated = t1.onTryAgain,
						text = v13.passkeyTryAgainNowText
					}
				}
			}
		},
		anchorPoint = Vector2.new(0.5, 0.5),
		position = UDim2.new(0.5, 0, 0.5, 0),
		screenSize = v16
	}) })
end
