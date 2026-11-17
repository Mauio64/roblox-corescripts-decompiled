local AccountSettingsPage = require(script.AccountSettingsPage)
local openAccountSettings = require(script.openAccountSettings)

return {
	["jest.config"] = script["jest.config"],
	Page = AccountSettingsPage,
	openAccountSettings = openAccountSettings,
	registerAccountSettingsEntryPointsActions = function()
		local registerAccountSettingsEntryPointsActions = require(script.Sdui.registerAccountSettingsEntryPointsActions)
		registerAccountSettingsEntryPointsActions()
	end,
	Demo = {
		openAccountSettingsQrCode = function(p, p2)
			openAccountSettings(p, p2, {
				internal = { presentation = "QrCode" }
			})
		end
	}
}
