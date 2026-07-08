local Parent = script:FindFirstAncestor("RoduxCall").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 5
	return {
		payload = {
			call = p1
		}
	}
end)
