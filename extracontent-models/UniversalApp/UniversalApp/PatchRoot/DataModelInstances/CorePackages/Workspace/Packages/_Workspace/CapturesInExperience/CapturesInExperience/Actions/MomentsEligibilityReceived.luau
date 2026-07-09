local ParentParent = script.Parent.Parent.Parent

return require(ParentParent.Rodux).makeActionCreator(script.Name, function(n1: number, b1: boolean) -- line: 11
	return {
		universeId = n1,
		isEligible = b1
	}
end)
