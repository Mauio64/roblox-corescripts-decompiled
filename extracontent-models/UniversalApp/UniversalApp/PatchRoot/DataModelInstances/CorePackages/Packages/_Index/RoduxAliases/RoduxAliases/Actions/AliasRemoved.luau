local Parent = script:FindFirstAncestor("RoduxAliases").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 5
	return {
		payload = {
			userId = p1
		}
	}
end)
