local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Rodux = require(CorePackages.Packages.Rodux)
local Modules = CoreGui.RobloxGui.Modules

require(Modules.AvatarExperience.Common.Types)

return Rodux.makeActionCreator(script.Name, function(n1: number) -- line: 12
	return {
		outfitId = tostring(n1)
	}
end)
