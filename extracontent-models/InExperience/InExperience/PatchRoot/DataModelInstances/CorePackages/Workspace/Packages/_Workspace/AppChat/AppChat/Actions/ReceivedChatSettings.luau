local Parent = script:FindFirstAncestor("AppChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 6
	assert(type(p1) == "table", script.Name .. ": result must be a table")

	return {
		result = p1
	}
end)
