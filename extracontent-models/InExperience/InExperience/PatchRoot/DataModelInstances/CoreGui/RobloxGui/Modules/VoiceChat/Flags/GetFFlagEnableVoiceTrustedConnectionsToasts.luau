local CorePackages = game:GetService("CorePackages")

require(CorePackages.Workspace.Packages.VoiceChatCore)

local GetFFlagUpdateVoiceConnectionToasts = require(script.Parent.GetFFlagUpdateVoiceConnectionToasts)

game:DefineFastFlag("EnableVoiceTrustedConnectionsToasts", false)

return function() -- line: 7
	-- upvalues: GetFFlagUpdateVoiceConnectionToasts (copy)
	return GetFFlagUpdateVoiceConnectionToasts() and game:GetFastFlag("EnableVoiceTrustedConnectionsToasts")
end
