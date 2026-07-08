local ParentParent = script.Parent.Parent.Parent

return require(ParentParent.Rodux).makeActionCreator(script.Name, function(n1: number) -- line: 10
	return {
		promptId = n1
	}
end)
