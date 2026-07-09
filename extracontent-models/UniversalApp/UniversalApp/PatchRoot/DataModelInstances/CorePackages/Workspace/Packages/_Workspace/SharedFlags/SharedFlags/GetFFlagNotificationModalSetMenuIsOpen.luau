local GetFFlagPackagifySettingsShowSignal = require(script.Parent.GetFFlagPackagifySettingsShowSignal)

game:DefineFastFlag("NotificationModalSetMenuIsOpen", false)

return function() -- line: 5
	-- upvalues: GetFFlagPackagifySettingsShowSignal (copy)
	return GetFFlagPackagifySettingsShowSignal() and game:GetFastFlag("NotificationModalSetMenuIsOpen")
end
