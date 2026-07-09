local Parent = script:FindFirstAncestor("AvatarExperienceCatalog").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(t1: {[any]: any}) -- line: 14
	return {
		collectibleItemData = t1.collectibleItemData
	}
end)
