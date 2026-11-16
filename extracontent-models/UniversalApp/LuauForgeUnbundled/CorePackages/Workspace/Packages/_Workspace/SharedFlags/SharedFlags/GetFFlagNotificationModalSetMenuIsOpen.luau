local GetFFlagPackagifySettingsShowSignal = require("@game/CorePackages/Workspace/Packages/_Workspace/SharedFlags/SharedFlags/GetFFlagPackagifySettingsShowSignal")

game:DefineFastFlag("NotificationModalSetMenuIsOpen", false)

return function()
	return GetFFlagPackagifySettingsShowSignal() and game:GetFastFlag("NotificationModalSetMenuIsOpen")
end
