local Parent = script:FindFirstAncestor("InExperienceContainer").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 6
	return {
		screenSize = p1
	}
end)
