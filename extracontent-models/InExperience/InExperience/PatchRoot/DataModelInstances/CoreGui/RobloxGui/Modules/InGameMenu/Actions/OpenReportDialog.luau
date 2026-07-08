local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator("OPEN_REPORT_DIALOG", function(p1, p2) -- line: 5
	return {
		userId = p1,
		userName = p2
	}
end)
