local ParentParent = script.Parent.Parent.Parent

return require(ParentParent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 6
	return {
		serverType = p1
	}
end)
