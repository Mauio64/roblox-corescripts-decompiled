local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local AvatarExperienceRodux = require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

require(Modules.AvatarExperience.Common.AvatarExperienceState)

local SetEquippedInTryOnManager = AvatarExperienceRodux.Actions.SetEquippedInTryOnManager

return function(p1, p2, _, p4, _) -- line: 14
	-- upvalues: SetEquippedInTryOnManager (copy)
	return function(p6) -- line: 15
		-- upvalues: SetEquippedInTryOnManager (copy), p1 (copy), p2 (copy), p4 (copy)
		p6:dispatch(SetEquippedInTryOnManager(p1, p2, p4))
	end
end
