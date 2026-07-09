local CorePackages = game:GetService("CorePackages")
local Modules = game:GetService("CoreGui").RobloxGui.Modules
local Rodux = require(CorePackages.Packages.Rodux)

require(Modules.AvatarExperience.Catalog.Http.WebApi)

return Rodux.makeActionCreator(script.Name, function(p1, t1: {[any]: any}) -- line: 21
	return {
		category = p1,
		items = t1
	}
end)
