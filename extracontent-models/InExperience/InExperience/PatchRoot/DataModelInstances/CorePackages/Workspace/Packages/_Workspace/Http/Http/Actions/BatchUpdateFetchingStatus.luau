local Parent = script:FindFirstAncestor("Http").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(t1: {[any]: any}, b1: boolean?) -- line: 11
	return {
		fetchingStatuses = t1,
		shouldImmediatelyDispatch = b1 or false
	}
end)
