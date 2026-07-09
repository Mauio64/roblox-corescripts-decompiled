local ParentParent = script.Parent.Parent.Parent

return require(ParentParent.Rodux).makeActionCreator(script.Name, function(n1: number) -- line: 6
	return {
		index = n1
	}
end)
