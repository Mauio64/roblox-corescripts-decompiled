local Parent = script:FindFirstAncestor("SongDetailRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 6
	return {
		songDetail = p1
	}
end)
