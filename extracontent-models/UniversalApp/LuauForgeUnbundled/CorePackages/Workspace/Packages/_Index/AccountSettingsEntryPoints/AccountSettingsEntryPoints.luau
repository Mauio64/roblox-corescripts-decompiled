local AccountSettingsPage = require("@game/CorePackages/Workspace/Packages/_Index/AccountSettingsEntryPoints/AccountSettingsEntryPoints/AccountSettingsPage")
local module2 = require("@game/CorePackages/Workspace/Packages/_Index/AccountSettingsEntryPoints/AccountSettingsEntryPoints/openAccountSettings")

return {
	Page = AccountSettingsPage,
	openAccountSettings = module2,
	registerAccountSettingsEntryPointsActions = function()
		require("@game/CorePackages/Workspace/Packages/_Index/AccountSettingsEntryPoints/AccountSettingsEntryPoints/Sdui/registerAccountSettingsEntryPointsActions")()
	end,
	Demo = {
		openAccountSettingsQrCode = function(p2, p3)
			module2(p2, p3, {
				internal = { presentation = "QrCode" }
			})
		end
	}
}
