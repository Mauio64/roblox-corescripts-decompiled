local ParentParent = script.Parent.Parent
local ParentParentParent = ParentParent.Parent
local Roact = require(ParentParentParent.Roact)
local UIBlox = require(ParentParentParent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local Images = UIBlox.App.ImageSet.Images
local MultiTextLocalizer = require(ParentParent.Locale.MultiTextLocalizer)
local v9 = Roact.Component:extend(script.Name)

v9.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function v9.render(p1) -- line: 35
	-- upvalues: Roact (copy), MultiTextLocalizer (copy)
	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			title = {
				key = "Authentication.TwoStepVerification.Title.VerificationRequired"
			},
			message = {
				key = "Authentication.TwoStepVerification.Label.TwoStepRequired"
			},
			cancel = {
				key = "Authentication.TwoStepVerification.Action.Cancel"
			},
			backToGame = {
				key = "IAPExperience.PurchaseSuccess.Action.BackToGame"
			},
			gotoSecurity = {
				key = "Authentication.TwoStepVerification.Action.GoToSecurity"
			}
		},
		render = function(t1: {[any]: any}) -- line: 54
			-- upvalues: p1 (copy)
			return p1:renderAlert(t1)
		end
	})
end
function v9.renderAlert(t2: {[any]: any}, t3: {[any]: any}) -- line: 60
	-- upvalues: ButtonType (copy), Roact (copy), InteractiveAlert (copy), Images (copy)
	local props = t2.props
	local v14 = if not props.openSecuritySettings then {
		buttons = {{
			buttonType = ButtonType.PrimarySystem,
			props = {
				onActivated = props.closePrompt,
				text = t3.backToGame,
				inputIcon = props.doneControllerIcon
			}
		}}
	} else {
		buttons = {
			{
				props = {
					onActivated = props.closePrompt,
					text = t3.cancel,
					inputIcon = props.cancelControllerIcon
				}
			},
			{
				buttonType = ButtonType.PrimarySystem,
				props = {
					onActivated = props.openSecuritySettings,
					text = t3.gotoSecurity,
					inputIcon = props.doneControllerIcon
				}
			}
		}
	}

	return Roact.createElement(InteractiveAlert, {
		anchorPoint = props.anchorPoint,
		position = props.position,
		screenSize = props.screenSize,
		title = t3.title,
		titleIcon = Images["icons/status/error_large"],
		bodyText = t3.message,
		buttonStackInfo = v14
	})
end

return v9
