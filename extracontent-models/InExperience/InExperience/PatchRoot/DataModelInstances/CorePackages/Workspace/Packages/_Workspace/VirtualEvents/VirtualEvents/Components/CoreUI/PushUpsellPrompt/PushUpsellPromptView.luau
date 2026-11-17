local parent = script:FindFirstAncestor("VirtualEvents").Parent
local React = require(parent.React)
local UIBlox = require(parent.UIBlox)

local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

local function PushUpsellPromptView(props)
	return React.createElement(InteractiveAlert, {
		title = props.title,
		bodyText = props.bodyText,
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = props.screenSize,
		buttonStackInfo = {
			buttons = {
				{
					props = { onActivated = props.onCancel, text = props.cancelText },
					isDefaultChild = true
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = { onActivated = props.onConfirm, text = props.confirmText },
					isDefaultChild = false
				}
			}
		}
	})
end

return PushUpsellPromptView
