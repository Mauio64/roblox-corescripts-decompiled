local CorePackages = game:GetService("CorePackages")

local UIBlox = require(CorePackages.Packages.UIBlox)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local React = require(CorePackages.Packages.React)

local function LeaveCreationAlert(props)
	return React.createElement(InteractiveAlert, {
		title = RobloxTranslator:FormatByKey("CoreScripts.PublishAvatarPrompt.LeaveCreationTitle"),
		bodyText = RobloxTranslator:FormatByKey("CoreScripts.PublishCommon.UnsavedWarning"),
		buttonStackInfo = {
			buttons = {
				{
					props = {
						onActivated = props.closePrompt,
						text = RobloxTranslator:FormatByKey("CoreScripts.PublishCommon.Leave")
					},
					isDefaultChild = false
				},
				{
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = props.cancelClosePrompt,
						text = RobloxTranslator:FormatByKey("CoreScripts.PublishCommon.Stay")
					},
					isDefaultChild = true
				}
			}
		},
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = props.screenSize
	})
end

return LeaveCreationAlert
