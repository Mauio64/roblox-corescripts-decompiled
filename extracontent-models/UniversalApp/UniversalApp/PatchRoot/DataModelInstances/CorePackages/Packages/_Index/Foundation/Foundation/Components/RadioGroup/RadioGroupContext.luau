local Parent = script:FindFirstAncestor("Foundation").Parent

return require(Parent.React).createContext({
	value = nil,
	Selectable = true,
	testId = "",
	onValueChanged = function(_: string) -- line: 8
		warn("No RadioGroupProvider found for RadioGroup")
	end
})
