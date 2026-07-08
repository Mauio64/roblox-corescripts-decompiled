local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(s1: string) -- line: 12
	return {
		interaction = s1
	}
end)
