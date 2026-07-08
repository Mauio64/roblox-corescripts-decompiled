local scriptParent = script.Parent
local scriptParentParent = scriptParent.Parent
local scriptParentParentParent = scriptParentParent.Parent
local Roact = require(scriptParentParentParent.Roact)
local UIBlox = require(scriptParentParentParent.UIBlox)
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local MultiTextLocalizer = require(scriptParentParent.Locale.MultiTextLocalizer)
local U13ConfirmType = require(scriptParent.U13ConfirmType)
local v10 = Roact.Component:extend(script.Name)

v10.defaultProps = {
	anchorPoint = Vector2.new(0.5, 0.5),
	position = UDim2.new(0.5, 0, 0.5, 0)
}

function v10.getMessage(_: {[any]: any}, t2: {[any]: any}, p1) -- line: 36
	-- upvalues: U13ConfirmType (copy)
	if p1 == U13ConfirmType.U13PaymentModal then
		return t2.u13PaymentModal
	end

	if p1 == U13ConfirmType.U13MonthlyThreshold1Modal then
		return t2.u13MonthlyThreshold1Modal
	end

	if p1 == U13ConfirmType.U13MonthlyThreshold2Modal then
		return t2.u13MonthlyThreshold2Modal
	end

	if p1 == U13ConfirmType.ParentalConsentWarningPaymentModal13To17 then
		return t2.parentalConsentWarningPaymentModal13To17
	end
end
function v10.render(p2) -- line: 48
	-- upvalues: Roact (copy), MultiTextLocalizer (copy)
	return Roact.createElement(MultiTextLocalizer, {
		keys = {
			title = {
				key = "IAPExperience.U13Confirm.Title.Warning"
			},
			u13PaymentModal = {
				key = "IAPExperience.U13Confirm.Text.U13PaymentModal"
			},
			u13MonthlyThreshold1Modal = {
				key = "IAPExperience.U13Confirm.Text.U13MonthlyThreshold1Modal"
			},
			u13MonthlyThreshold2Modal = {
				key = "IAPExperience.U13Confirm.Text.U13MonthlyThreshold2Modal"
			},
			parentalConsentWarningPaymentModal13To17 = {
				key = "IAPExperience.U13Confirm.Text.ParentalConsentWarningPaymentModal13To17"
			},
			confirm = {
				key = "IAPExperience.U13Confirm.Action.Confirm"
			},
			cancel = {
				key = "IAPExperience.U13Confirm.Action.Cancel"
			}
		},
		render = function(t3: {[any]: any}) -- line: 73
			-- upvalues: p2 (copy)
			return p2:renderAlert(t3)
		end
	})
end
function v10.renderAlert(t4: {[any]: any}, t5: {[any]: any}) -- line: 79
	-- upvalues: Roact (copy), InteractiveAlert (copy), ButtonType (copy)
	local props = t4.props

	return Roact.createElement(InteractiveAlert, {
		anchorPoint = props.anchorPoint,
		position = props.position,
		screenSize = props.screenSize,
		title = t5.title,
		bodyText = t4:getMessage(t5, props.modalType),
		buttonStackInfo = {
			buttons = {
				{
					props = {
						onActivated = props.cancelActivated,
						text = t5.cancel,
						inputIcon = props.cancelControllerIcon
					}
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = props.doneActivated,
						text = t5.confirm,
						inputIcon = props.doneControllerIcon
					}
				}
			}
		}
	})
end

return v10
