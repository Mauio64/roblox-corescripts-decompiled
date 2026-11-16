local GetFFlagPackagifySettingsShowSignal = require(script.Parent.GetFFlagPackagifySettingsShowSignal)

game:DefineFastFlag("NotificationModalSetMenuIsOpen", false)

return function()
	return GetFFlagPackagifySettingsShowSignal() and game:GetFastFlag("NotificationModalSetMenuIsOpen")
end
