local Parent = script:FindFirstAncestor("AvatarExperienceRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 19
	return {
		profileConfiguration = t1
	}
end)
