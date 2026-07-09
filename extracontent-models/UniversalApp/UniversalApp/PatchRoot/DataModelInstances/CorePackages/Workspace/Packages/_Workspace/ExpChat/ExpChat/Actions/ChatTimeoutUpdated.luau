local Parent = script:FindFirstAncestor("ExpChat").Parent

return require(Parent.Rodux).makeActionCreator(script.Name, function(n1: number, b1: boolean) -- line: 10
	return {
		endTimestamp = n1,
		isEnforced = b1
	}
end)
