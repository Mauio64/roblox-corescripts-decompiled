local parent = script.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)
local UIBlox = require(parent2.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local MultiTextLocalizer = require(parent.Locale.MultiTextLocalizer)

local extended = Roact.Component:extend(script.Name)

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
		render = function(p)
			return self:renderAlert(p)
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
		AlertWindow = Roact.createElement(InteractiveAlert, {
			title = props.TitleText,
			bodyText = props.BodyText,
			buttonStackInfo = {
				buttons = {
					{
						buttonType = ButtonType.Secondary,
						props = {
							onActivated = self.props.cancelActivated,
							text = props.ButtonCancel
						}
					},
					{
						buttonType = ButtonType.PrimarySystem,
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
