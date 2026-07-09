local scriptParent = script.Parent

return require(scriptParent.ActionCreator)(script.Name, function(p1: ((...any) -> ...any)?, t1: {[any]: any}?) -- line: 4
	return {
		onSelectionLost = p1,
		keybinds = t1
	}
end)
