local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator("InsertScreen", function(p1) -- line: 4
	return {
		item = p1
	}
end)
