local CorePackages = game:GetService("CorePackages")
local GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints = require(CorePackages.Workspace.Packages.SharedFlags).GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints

game:DefineFastFlag("EnableLeaveGameUpsellEntrypoint", false)

return function() -- line: 6
	-- upvalues: GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints (copy)
	return GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints() and game:GetFastFlag("EnableLeaveGameUpsellEntrypoint")
end
