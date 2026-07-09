local Modules = game:GetService("CoreGui").RobloxGui.Modules
local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)
local UIBlox = require(CorePackages.Packages.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local withStyle = UIBlox.Style.withStyle
local withLocalization = require(Modules.LuaApp.withLocalization)

return function(t1: {[any]: any}) -- line: 16
	-- upvalues: withStyle (copy), withLocalization (copy), React (copy), InteractiveAlert (copy), ButtonType (copy)
	return withStyle(function(p1) -- line: 17
		-- upvalues: withLocalization (copy), React (copy), t1 (copy), InteractiveAlert (copy), ButtonType (copy)
		return withLocalization({
			cannotSignUpText = "Authentication.SignUp.Heading.CannotSignUp",
			underAgeText = "Authentication.SignUp.Description.UnderAgeAlert",
			understandText = "Authentication.SignUp.Action.IUnderstand"
		})(function(p2) -- line: 22
			-- upvalues: React (copy), p1 (copy), t1 (copy), InteractiveAlert (copy), ButtonType (copy)
			return React.createElement("TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				BackgroundColor3 = p1.Theme.Overlay.Color,
				AutoButtonColor = false,
				BackgroundTransparency = p1.Theme.Overlay.Transparency,
				ZIndex = t1.ZIndex,
				Text = "",
				Visible = true,
				[React.Event.Activated] = function() -- line: 32
					-- upvalues: t1 (copy)
					t1.onDismiss()
				end
			}, {
				Alert = React.createElement(InteractiveAlert, {
					title = p2.cannotSignUpText,
					bodyText = p2.underAgeText,
					buttonStackInfo = {
						buttons = {{
							buttonType = ButtonType.PrimarySystem,
							props = {
								text = p2.understandText,
								onActivated = function() -- line: 45
									-- upvalues: t1 (copy)
									t1.onDismiss()
								end
							}
						}}
					},
					position = UDim2.fromScale(0.5, 0.5),
					screenSize = Vector2.new(100, 100),
					ZIndex = t1.ZIndex + 1
				})
			})
		end)
	end)
end
