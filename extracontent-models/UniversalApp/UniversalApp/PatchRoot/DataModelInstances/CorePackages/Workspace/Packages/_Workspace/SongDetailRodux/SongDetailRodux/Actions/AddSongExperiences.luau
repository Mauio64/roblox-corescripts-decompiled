local Parent = script:FindFirstAncestor("SongDetailRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 8
	return {
		songExperiences = t1
	}
end)
