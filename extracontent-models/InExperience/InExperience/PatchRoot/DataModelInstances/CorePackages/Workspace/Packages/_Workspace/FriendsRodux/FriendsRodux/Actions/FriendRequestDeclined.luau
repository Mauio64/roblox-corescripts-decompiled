local Parent = script:FindFirstAncestor("FriendsRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 5
	return {
		ids = t1
	}
end)
