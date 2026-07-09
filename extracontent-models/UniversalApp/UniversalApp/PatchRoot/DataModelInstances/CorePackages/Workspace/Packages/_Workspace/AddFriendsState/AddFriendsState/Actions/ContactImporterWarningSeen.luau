local Parent = script:FindFirstAncestor("AddFriendsState").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function() -- line: 5
	return {}
end)
