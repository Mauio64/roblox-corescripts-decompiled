game:GetService("Players")

local Modules = game:GetService("CoreGui").RobloxGui.Modules
local NewInviteMenuExperimentManager = require(Modules.Settings.Pages.ShareGame.NewInviteMenuExperimentManager)

game:DefineFastFlag("EnableNewInviteSendEndpoint", false)
game:DefineFastFlag("EnableNewInviteSendEndpointIXP", false)

return function() -- line: 10
	-- upvalues: NewInviteMenuExperimentManager (copy)
	return game:GetFastFlag("EnableNewInviteSendEndpoint") or game:GetFastFlag("EnableNewInviteSendEndpointIXP") and NewInviteMenuExperimentManager.default:getCustomizationEnabled()
end
