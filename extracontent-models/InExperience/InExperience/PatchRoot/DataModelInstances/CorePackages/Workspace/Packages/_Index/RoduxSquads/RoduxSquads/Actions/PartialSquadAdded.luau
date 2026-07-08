local Parent = script:FindFirstAncestor("RoduxSquads").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 5
	return {
		payload = {
			partialSquad = p1
		}
	}
end)
