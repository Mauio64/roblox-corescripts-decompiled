local CorePackages = game:GetService("CorePackages")
local SharedFlags = require(CorePackages.Workspace.Packages.SharedFlags)
local GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints = SharedFlags.GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints

game:DefineFastFlag("EnableLeaveGameUpsellEntrypoint", false)

return function()
	return GetFFlagEnableInExpPhoneVoiceUpsellEntrypoints() and game:GetFastFlag("EnableLeaveGameUpsellEntrypoint")
end
