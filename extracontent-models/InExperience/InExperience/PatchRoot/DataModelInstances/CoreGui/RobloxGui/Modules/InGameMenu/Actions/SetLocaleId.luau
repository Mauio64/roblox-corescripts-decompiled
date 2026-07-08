local CorePackages = game:GetService("CorePackages")

return require(CorePackages.Packages.Rodux).makeActionCreator("SET_LOCALE_ID", function(p1) -- line: 5
	return {
		newLocaleId = p1
	}
end)
