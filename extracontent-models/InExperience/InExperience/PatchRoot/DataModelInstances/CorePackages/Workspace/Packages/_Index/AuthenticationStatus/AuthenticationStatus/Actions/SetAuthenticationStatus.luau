local Parent = script:FindFirstAncestor("AuthenticationStatus").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 5
	return {
		status = p1
	}
end)
