local CorePackages = game:GetService("CorePackages")

require(script.Parent.Parent.Models.CollectibleInstance)

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(s1: string?, t1: {[any]: any}) -- line: 8
	return {
		collectibleItemId = s1,
		collectibleItemInstances = t1
	}
end)
