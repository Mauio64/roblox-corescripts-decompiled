local parent = script:FindFirstAncestor("Foundation").Parent

local React = require(parent.React)

return React.createContext({
	value = nil,
	onValueChanged = function(_: string)
		warn("No RadioGroupProvider found for RadioGroup")
	end,
	Selectable = true,
	testId = ""
})
