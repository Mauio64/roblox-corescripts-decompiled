local Parent = script:FindFirstAncestor("ToastRodux").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(p1) -- line: 5
	assert(type(p1) == "table", "SetCurrentToastMessage action expects toastMessage to be a table")

	return {
		toastMessage = p1
	}
end)
