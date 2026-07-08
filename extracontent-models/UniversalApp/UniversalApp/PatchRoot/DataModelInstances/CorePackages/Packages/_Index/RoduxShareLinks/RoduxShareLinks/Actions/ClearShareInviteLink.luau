local Parent = script:FindFirstAncestor("RoduxShareLinks").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function() -- line: 7
	return {}
end)
