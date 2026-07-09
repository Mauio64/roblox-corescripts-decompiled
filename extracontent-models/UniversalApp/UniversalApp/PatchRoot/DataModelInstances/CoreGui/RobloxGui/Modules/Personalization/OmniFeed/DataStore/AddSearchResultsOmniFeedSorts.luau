local CorePackages = game:GetService("CorePackages")
local makeActionCreator = require(CorePackages.Packages.Rodux).makeActionCreator

require(CorePackages.Workspace.Packages.DiscoveryTypes)

return makeActionCreator(script.Name, function(s1: string, t1: {[any]: any}) -- line: 5
	return {
		searchUuid = s1,
		sorts = t1
	}
end)
