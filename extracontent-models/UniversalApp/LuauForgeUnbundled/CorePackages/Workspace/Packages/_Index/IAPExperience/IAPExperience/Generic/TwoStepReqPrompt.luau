local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType
local images = UIBlox.App.ImageSet.Images

local MultiTextLocalizer = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Locale/MultiTextLocalizer")

local extended = Roact.Component:extend("TwoStepReqPrompt")

extended.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function extended:render()
	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			title = {
				key = "Authentication.TwoStepVerification.Title.VerificationRequired"
			},
			message = {
				key = "Authentication.TwoStepVerification.Label.TwoStepRequired"
			},
			cancel = { key = "Authentication.TwoStepVerification.Action.Cancel" },
			backToGame = { key = "IAPExperience.PurchaseSuccess.Action.BackToGame" },
			gotoSecurity = {
				key = "Authentication.TwoStepVerification.Action.GoToSecurity"
			}
		},
		render = function(p2)
			return self:renderAlert(p2)
		end
	})
end

function extended:renderAlert(props)
	local props2 = self.props

	local v5 = if props2.openSecuritySettings then {
		buttons = {
			{
				props = {
					onActivated = props2.closePrompt,
					text = props.cancel,
					inputIcon = props2.cancelControllerIcon
				}
			},
			{
				buttonType = buttonType.PrimarySystem,
				props = {
					onActivated = props2.openSecuritySettings,
					text = props.gotoSecurity,
					inputIcon = props2.doneControllerIcon
				}
			}
		}
	} else {
		buttons = {
			{
				buttonType = buttonType.PrimarySystem,
				props = {
					onActivated = props2.closePrompt,
					text = props.backToGame,
					inputIcon = props2.doneControllerIcon
				}
			}
		}
	}

	return Roact.createElement(interactiveAlert, {
		anchorPoint = props2.anchorPoint,
		position = props2.position,
		screenSize = props2.screenSize,
		title = props.title,
		titleIcon = images["icons/status/error_large"],
		bodyText = props.message,
		buttonStackInfo = v5
	})
end

return extended
