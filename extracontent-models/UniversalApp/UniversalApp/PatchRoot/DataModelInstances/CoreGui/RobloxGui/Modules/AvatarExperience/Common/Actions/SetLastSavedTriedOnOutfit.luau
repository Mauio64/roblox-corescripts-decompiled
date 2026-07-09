local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 15
	return {
		savedOutfit = t1
	}
end)
