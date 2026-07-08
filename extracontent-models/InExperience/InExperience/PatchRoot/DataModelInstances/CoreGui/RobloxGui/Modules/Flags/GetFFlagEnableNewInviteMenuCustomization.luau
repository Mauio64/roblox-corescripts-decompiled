game:GetService("Players")

local Modules = game:GetService("CoreGui").RobloxGui.Modules
local NewInviteMenuExperimentManager = require(Modules.Settings.Pages.ShareGame.NewInviteMenuExperimentManager)

game:DefineFastFlag("EnableNewInviteMenuCustomization2", false)
game:DefineFastFlag("EnableNewInviteMenuCustomizationIXP2", false)

return function() -- line: 10
	-- upvalues: NewInviteMenuExperimentManager (copy)
	return game:GetFastFlag("EnableNewInviteMenuCustomization2") or game:GetFastFlag("EnableNewInviteMenuCustomizationIXP2") and NewInviteMenuExperimentManager.default:getCustomizationEnabled()
end
