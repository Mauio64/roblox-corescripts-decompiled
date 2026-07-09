local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)

require(Modules.AvatarExperience.Common.Types)

return Rodux.makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 19
	return {
		outfits = t1
	}
end)
