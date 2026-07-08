local Parent = script:FindFirstAncestor("RoduxSquads").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 6
	return {
		payload = {
			selfPermissions = p1
		}
	}
end)
