local module = require("@luauforge/bundled/dPN")
local module2 = require("@luauforge/bundled/dRf")
local module3 = require("@luauforge/bundled/ehm")
local module4 = require("@luauforge/bundled/fCM")
local module5 = require("@luauforge/bundled/ehl")

local editProfileImageAnalytics = require("@luauforge/deferred/fCZ").EditProfileImageAnalytics

return function(data, callback)
	return function(object)
		object:dispatch(module3(module5.ConfirmationDialog, {
			title = data.title,
			body = data.body,
			confirmButtonText = data.confirm,
			cancelButtonText = data.cancel,
			disablePortal = false,
			onConfirm = function()
				object:dispatch(module2(module.AvatarType.R15))
				editProfileImageAnalytics.logR15UpgradePromptInteraction("confirm")
				callback()
				object:dispatch(module4())
			end,
			onCancel = function()
				editProfileImageAnalytics.logR15UpgradePromptInteraction("cancel")
				object:dispatch(module4())
			end
		}))

		editProfileImageAnalytics.logR15UpgradePromptShown()
	end
end
