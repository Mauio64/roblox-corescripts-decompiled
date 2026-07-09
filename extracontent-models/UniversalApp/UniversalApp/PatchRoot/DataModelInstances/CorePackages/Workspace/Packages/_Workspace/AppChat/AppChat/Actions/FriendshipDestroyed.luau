local Parent = script:FindFirstAncestor("AppChat").Parent

return require(Parent.Rodux).makeActionCreator("AppChat." .. script.Name, function(t1: {[any]: any}) -- line: 15
	return t1
end)
