local Roact = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/Roact")

local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/IAPExperience/UIBlox")
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local buttonType = UIBlox.App.Button.Enum.ButtonType

local MultiTextLocalizer = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Locale/MultiTextLocalizer")

local U13ConfirmType = require("@game/CorePackages/Workspace/Packages/_Index/IAPExperience/IAPExperience/Generic/U13ConfirmType")

local extended = Roact.Component:extend("U13ConfirmPrompt")

extended.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function extended.getMessage(p2, data, p3)
	if p3 == U13ConfirmType.U13PaymentModal then
		return data.u13PaymentModal
	end

	if p3 == U13ConfirmType.U13MonthlyThreshold1Modal then
		return data.u13MonthlyThreshold1Modal
	end

	if p3 == U13ConfirmType.U13MonthlyThreshold2Modal then
		return data.u13MonthlyThreshold2Modal
	end

	if p3 == U13ConfirmType.ParentalConsentWarningPaymentModal13To17 then
		return data.parentalConsentWarningPaymentModal13To17
	end
end

function extended:render()
	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			title = { key = "IAPExperience.U13Confirm.Title.Warning" },
			u13PaymentModal = { key = "IAPExperience.U13Confirm.Text.U13PaymentModal" },
			u13MonthlyThreshold1Modal = {
				key = "IAPExperience.U13Confirm.Text.U13MonthlyThreshold1Modal"
			},
			u13MonthlyThreshold2Modal = {
				key = "IAPExperience.U13Confirm.Text.U13MonthlyThreshold2Modal"
			},
			parentalConsentWarningPaymentModal13To17 = {
				key = "IAPExperience.U13Confirm.Text.ParentalConsentWarningPaymentModal13To17"
			},
			confirm = { key = "IAPExperience.U13Confirm.Action.Confirm" },
			cancel = { key = "IAPExperience.U13Confirm.Action.Cancel" }
		},
		render = function(p2)
			return self:renderAlert(p2)
		end
	})
end

function extended:renderAlert(props)
	local props2 = self.props

	return Roact.createElement(interactiveAlert, {
		anchorPoint = props2.anchorPoint,
		position = props2.position,
		screenSize = props2.screenSize,
		title = props.title,
		bodyText = self:getMessage(props, props2.modalType),
		buttonStackInfo = {
			buttons = {
				{
					props = {
						onActivated = props2.cancelActivated,
						text = props.cancel,
						inputIcon = props2.cancelControllerIcon
					}
				},
				{
					buttonType = buttonType.PrimarySystem,
					props = {
						onActivated = props2.doneActivated,
						text = props.confirm,
						inputIcon = props2.doneControllerIcon
					}
				}
			}
		}
	})
end

return extended
