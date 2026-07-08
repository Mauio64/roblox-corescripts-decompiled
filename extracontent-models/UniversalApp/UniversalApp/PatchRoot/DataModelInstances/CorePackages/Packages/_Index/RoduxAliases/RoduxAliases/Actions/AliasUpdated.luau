local Parent = script:FindFirstAncestor("RoduxAliases").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 5
	return {
		payload = {
			userId = p1,
			newAlias = p2
		}
	}
end)
