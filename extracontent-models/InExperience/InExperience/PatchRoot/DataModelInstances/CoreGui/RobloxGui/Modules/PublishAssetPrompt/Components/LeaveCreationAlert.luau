local CorePackages = game:GetService("CorePackages")
local UIBlox = require(CorePackages.Packages.UIBlox)
local ButtonType = UIBlox.App.Button.Enum.ButtonType
local InteractiveAlert = UIBlox.App.Dialog.Alert.InteractiveAlert
local RobloxTranslator = require(CorePackages.Workspace.Packages.RobloxTranslator)
local React = require(CorePackages.Packages.React)

local function LeaveCreationAlert(t1: {[any]: any}) -- line: 19
	-- upvalues: React (copy), InteractiveAlert (copy), RobloxTranslator (copy), ButtonType (copy)
	return React.createElement(InteractiveAlert, {
		title = RobloxTranslator:FormatByKey("CoreScripts.PublishAvatarPrompt.LeaveCreationTitle"),
		bodyText = RobloxTranslator:FormatByKey("CoreScripts.PublishCommon.UnsavedWarning"),
		buttonStackInfo = {
			buttons = {
				{
					isDefaultChild = false,
					props = {
						onActivated = t1.closePrompt,
						text = RobloxTranslator:FormatByKey("CoreScripts.PublishCommon.Leave")
					}
				},
				{
					isDefaultChild = true,
					buttonType = ButtonType.PrimarySystem,
					props = {
						onActivated = t1.cancelClosePrompt,
						text = RobloxTranslator:FormatByKey("CoreScripts.PublishCommon.Stay")
					}
				}
			}
		},
		position = UDim2.fromScale(0.5, 0.5),
		screenSize = t1.screenSize
	})
end

return LeaveCreationAlert
