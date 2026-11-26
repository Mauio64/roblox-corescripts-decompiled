local React = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/React")
local UIBlox = require("@game/CorePackages/Workspace/Packages/_Workspace/VirtualEvents/UIBlox")

local buttonType = UIBlox.App.Button.Enum.ButtonType
local interactiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert

local function PushUpsellPromptView(props)
	return React.createElement(interactiveAlert, {
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
					buttonType = buttonType.PrimarySystem,
					props = { onActivated = props.onConfirm, text = props.confirmText },
					isDefaultChild = false
				}
			}
		}
	})
end

return PushUpsellPromptView
