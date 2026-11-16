local parent = script.Parent.Parent
local parent2 = parent.Parent

local Roact = require(parent2.Roact)

local UIBlox = require(parent2.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images

local MultiTextLocalizer = require(parent.Locale.MultiTextLocalizer)

local extended = Roact.Component:extend(script.Name)

extended.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function extended:render()
	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			title = { key = "Authentication.TwoStepVerification.Title.VerificationRequired" },
			message = { key = "Authentication.TwoStepVerification.Label.TwoStepRequired" },
			cancel = { key = "Authentication.TwoStepVerification.Action.Cancel" },
			backToGame = { key = "IAPExperience.PurchaseSuccess.Action.BackToGame" },
			gotoSecurity = { key = "Authentication.TwoStepVerification.Action.GoToSecurity" }
		},
		render = function(p)
			return self:renderAlert(p)
		end
	})
end

function extended:renderAlert(props)
	local props2 = self.props
	local buttonStackInfo

	if props2.openSecuritySettings then
		buttonStackInfo = {
			buttons = {
				{
					props = {
						onActivated = props2.closePrompt,
						text = props.cancel,
						inputIcon = props2.cancelControllerIcon
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = props2.openSecuritySettings,
						text = props.gotoSecurity,
						inputIcon = props2.doneControllerIcon
					}
				}
			}
		}
	else
		buttonStackInfo = {
			buttons = {
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = props2.closePrompt,
						text = props.backToGame,
						inputIcon = props2.doneControllerIcon
					}
				}
			}
		}
	end

	return Roact.createElement(InteractiveAlert, {
		anchorPoint = props2.anchorPoint,
		position = props2.position,
		screenSize = props2.screenSize,
		title = props.title,
		titleIcon = Images["icons/status/error_large"],
		bodyText = props.message,
		buttonStackInfo = buttonStackInfo
	})
end

return extended
