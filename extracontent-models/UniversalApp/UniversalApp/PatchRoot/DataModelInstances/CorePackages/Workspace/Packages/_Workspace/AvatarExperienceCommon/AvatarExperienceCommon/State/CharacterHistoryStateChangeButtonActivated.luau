local Parent = script:FindFirstAncestor("AvatarExperienceCommon").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 25
	return {
		type = script.Name,
		isUndo = t1.isUndo,
		equipped = t1.equipped,
		tryOn = t1.tryOn
	}
end)
