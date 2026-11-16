local Foundation = script:FindFirstAncestor("Foundation")
local parent = Foundation.Parent

local InputPlacement = require(Foundation.Enums.InputPlacement)
local InputSize = require(Foundation.Enums.InputSize)
local React = require(parent.React)

return React.createContext({
	onAccordionItemActivated = nil,
	itemSize = InputSize.Medium,
	isContained = false,
	chevronPosition = InputPlacement.End,
	testId = ""
})
