local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 9
	return {
		category = t1.category,
		subcategory = t1.subcategory
	}
end)
