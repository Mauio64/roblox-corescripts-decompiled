local parent = script.Parent
local parent2 = parent.Parent
local parent3 = parent2.Parent

local Roact = require(parent3.Roact)

local UIBlox = require(parent3.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType

local MultiTextLocalizer = require(parent2.Locale.MultiTextLocalizer)

local U13ConfirmType = require(parent.U13ConfirmType)

local extended = Roact.Component:extend(script.Name)

extended.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function extended:getMessage(data, p)
	if p == U13ConfirmType.U13PaymentModal then
		return data.u13PaymentModal
	end

	if p == U13ConfirmType.U13MonthlyThreshold1Modal then
		return data.u13MonthlyThreshold1Modal
	end

	if p == U13ConfirmType.U13MonthlyThreshold2Modal then
		return data.u13MonthlyThreshold2Modal
	end

	if p == U13ConfirmType.ParentalConsentWarningPaymentModal13To17 then
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
		render = function(p)
			return self:renderAlert(p)
		end
	})
end

function extended:renderAlert(props)
	local props2 = self.props

	return Roact.createElement(InteractiveAlert, {
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
					buttonType = ButtonType.PrimarySystem,
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
