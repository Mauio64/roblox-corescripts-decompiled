local Parent = script:FindFirstAncestor("Foundation").Parent

return require(Parent.React).createContext({
	isContained = false,
	testId = "",
	fillDirection = Enum.FillDirection.Vertical
})
