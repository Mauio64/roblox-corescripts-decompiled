local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 9
	return {
		lastInputTypeUsed = p1
	}
end)
