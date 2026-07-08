local Parent = script:FindFirstAncestor("RoduxFriends").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 5
	return {
		payload = {
			userId1 = p1,
			userId2 = p2
		}
	}
end)
