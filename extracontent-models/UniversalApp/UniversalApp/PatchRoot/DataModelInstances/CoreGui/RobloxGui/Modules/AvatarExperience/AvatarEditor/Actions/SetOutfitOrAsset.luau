local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)

require(Modules.AvatarExperience.Common.Types)
require(CorePackages.Workspace.Packages.AvatarExperienceRodux)

return Rodux.makeActionCreator(script.Name, function(t1: {[any]: any}, p1) -- line: 19
	return {
		ids = t1,
		itemType = p1
	}
end)
