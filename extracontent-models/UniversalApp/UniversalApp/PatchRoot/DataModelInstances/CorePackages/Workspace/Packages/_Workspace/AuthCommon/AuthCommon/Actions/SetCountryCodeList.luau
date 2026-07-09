local Parent = script:FindFirstAncestor("AuthCommon").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 11
	return {
		countryCodeList = p1
	}
end)
