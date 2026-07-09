local Parent = script:FindFirstAncestor("CommunityLinks").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1, p2) -- line: 6
	return {
		universeId = p1,
		communityLink = p2
	}
end)
