local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local React = require(parent.React)

local InputSize = require(Foundation.Enums.InputSize)

return React.createContext({
	hasDivider = false,
	isContained = false,
	isInset = false,
	hasMargin = false,
	lastLayoutOrder = 0,
	size = InputSize.Medium,
	testId = ""
})
