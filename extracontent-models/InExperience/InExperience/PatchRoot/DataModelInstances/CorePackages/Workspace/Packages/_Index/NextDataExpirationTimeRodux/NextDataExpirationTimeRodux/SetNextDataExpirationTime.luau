local Parent = script:FindFirstAncestor("NextDataExpirationTimeRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string, n1: number, s2: string?) -- line: 5
	assert(type(s1) == "string", "SetNextDataExpirationTime: key must be a string!")
	assert(type(n1) == "number" and n1 > 0, "SetNextDataExpirationTime: nextDataExpirationTime must be a positive number!")

	return {
		key = s1,
		nextDataExpirationTime = n1,
		namespace = s2
	}
end)
