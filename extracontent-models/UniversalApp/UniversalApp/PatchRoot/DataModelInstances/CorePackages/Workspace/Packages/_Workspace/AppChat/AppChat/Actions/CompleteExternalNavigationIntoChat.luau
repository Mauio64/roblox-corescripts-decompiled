local Parent = script:FindFirstAncestor("AppChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 6
	return {
		requestId = p1
	}
end)
