local Parent = script:FindFirstAncestor("RoduxFriends").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 5
	assert(type(p1) == "number", "Request count must be a number")

	return {
		payload = {
			count = p1
		}
	}
end)
