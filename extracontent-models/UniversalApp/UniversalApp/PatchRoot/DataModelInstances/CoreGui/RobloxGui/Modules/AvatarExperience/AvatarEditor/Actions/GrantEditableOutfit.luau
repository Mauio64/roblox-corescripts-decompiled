local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator(script.Name, function(n1: number) -- line: 9
	return {
		outfitId = n1
	}
end)
