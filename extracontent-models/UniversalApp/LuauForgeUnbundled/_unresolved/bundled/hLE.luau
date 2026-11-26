local CorePackages = game:GetService("CorePackages")
local React = require(CorePackages.Packages.React)

local getTestId = require("@game/CorePackages/Workspace/Packages/RoactUtils").getTestId
local fFlagLuaAppAddTestIdsForArrow = require("@game/CorePackages/Workspace/Packages/SharedFlags").FFlagLuaAppAddTestIdsForArrow

local UIBlox = require(CorePackages.Packages.UIBlox)
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local withStyle = UIBlox.Style.withStyle
local module = require("@luauforge/bundled/egZ")

return function(p2)
	return withStyle(function(p3)
		return module({
			cannotSignUpText = "Authentication.SignUp.Heading.CannotSignUp",
			underAgeText = "Authentication.SignUp.Description.UnderAgeAlert",
			understandText = "Authentication.SignUp.Action.IUnderstand"
		})(function(props)
			local createElement = React.createElement
			local v6 = {
				["Size"] = nil,
				Size = UDim2.new(1, 0, 1, 0),
				Position = UDim2.new(0, 0, 0, 0),
				BackgroundColor3 = p3.Theme.Overlay.Color,
				AutoButtonColor = false,
				BackgroundTransparency = p3.Theme.Overlay.Transparency,
				ZIndex = p2.ZIndex,
				Text = "",
				Visible = true
			}

			local tag = React.Tag
			local v7 = if fFlagLuaAppAddTestIdsForArrow then getTestId("auth-signup-underage-alert-action") else nil
			v6[tag] = v7

			v6[React.Event.Activated] = function()
				p2.onDismiss()
			end

			return createElement("TextButton", v6, {
				Alert = React.createElement(interactiveAlert, {
					title = props.cannotSignUpText,
					bodyText = props.underAgeText,
					buttonStackInfo = {
						buttons = {
							{
								buttonType = buttonType.PrimarySystem,
								props = {
									text = props.understandText,
									onActivated = function()
										p2.onDismiss()
									end
								}
							}
						}
					},
					position = UDim2.fromScale(0.5, 0.5),
					screenSize = Vector2.new(100, 100),
					ZIndex = p2.ZIndex + 1
				})
			})
		end)
	end)
end
