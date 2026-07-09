local Parent = script:FindFirstAncestor("CountryCode").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 6
	return {
		countryCode = p1
	}
end)
