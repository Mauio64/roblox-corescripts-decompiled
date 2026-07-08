local Players = game:GetService("Players")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local NewInviteMenuExperimentManager = require(Modules.Settings.Pages.ShareGame.NewInviteMenuExperimentManager)

game:DefineFastInt("EnableNewInviteMenuStyleRollout", 0)
game:DefineFastFlag("EnableNewInviteMenuStyle", false)

return function() -- line: 10
	-- upvalues: Players (copy), NewInviteMenuExperimentManager (copy)
	if not Players.LocalPlayer then
		return false
	end

	if game:GetFastFlag("EnableNewInviteMenuStyle") then
		return true
	end

	local LocalPlayer = Players.LocalPlayer

	if game:GetFastInt("EnableNewInviteMenuStyleRollout") > LocalPlayer.UserId % 100 then
		return true
	end

	return NewInviteMenuExperimentManager.default:getStyleEnabled()
end
