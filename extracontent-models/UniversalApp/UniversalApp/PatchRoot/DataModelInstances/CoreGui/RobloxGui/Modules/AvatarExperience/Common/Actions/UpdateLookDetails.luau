local CorePackages = game:GetService("CorePackages")
local CoreGui = game:GetService("CoreGui")
local Rodux = require(CorePackages.Packages.Rodux)
local Modules = CoreGui.RobloxGui.Modules

require(Modules.AvatarExperience.Common.Types)

return Rodux.makeActionCreator(script.Name, function(s1: string, p1) -- line: 18
	return {
		lookId = s1,
		lookDetails = p1
	}
end)
