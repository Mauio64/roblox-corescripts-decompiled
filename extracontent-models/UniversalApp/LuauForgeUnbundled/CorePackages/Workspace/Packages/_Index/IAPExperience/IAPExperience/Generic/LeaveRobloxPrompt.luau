local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local MultiTextLocalizer = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Locale/MultiTextLocalizer")

local extended = Roact.Component:extend("LeaveRobloxPrompt")

extended.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function extended:render()
	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			TitleText = { key = "IAPExperience.LeaveRoblox.Title.LeavingRoblox" },
			BodyText = { key = "IAPExperience.LeaveRoblox.Text.ExternalWebsiteWarning" },
			ButtonCancel = { key = "IAPExperience.LeaveRoblox.Action.Cancel" },
			ButtonContinue = { key = "IAPExperience.LeaveRoblox.Action.Continue" }
		},
		render = function(p2)
			return self:renderAlert(p2)
		end
	})
end

function extended:renderAlert(props)
	return (Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundColor3 = Color3.fromRGB(0, 0, 0),
		BackgroundTransparency = 1,
		Active = true,
		Selectable = false
	}, {
		AlertWindow = Roact.createElement(interactiveAlert, {
			title = props.TitleText,
			bodyText = props.BodyText,
			buttonStackInfo = {
				buttons = {
					{
						buttonType = buttonType.Secondary,
						props = {
							onActivated = self.props.cancelActivated,
							text = props.ButtonCancel
						}
					},
					{
						buttonType = buttonType.PrimarySystem,
						props = {
							onActivated = self.props.continueActivated,
							text = props.ButtonContinue
						}
					}
				}
			},
			screenSize = self.props.screenSize
		})
	}))
end

return extended
