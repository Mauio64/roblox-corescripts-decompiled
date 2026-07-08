local Parent = script:FindFirstAncestor("RoduxUsers").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 5
	return {
		payload = {
			id = p1
		}
	}
end)
